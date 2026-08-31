import crypto from 'node:crypto';
import { NextFunction, Request, Response } from 'express';
import { Prisma } from '@prisma/client';
import { z } from 'zod';
import { ApiError } from '../../domain/errors/ApiError';
import { TicketService } from '../../domain/services/ticketService';
import { assertTicketPaymentAccess } from '../../domain/services/ticketAccessService';
import { prisma } from '../../infrastructure/database/prismaClient';
import {
  createPaymentSession,
  isXenditConfigured,
} from '../../infrastructure/payments/xenditClient';
import { verifyXenditCallbackToken } from '../../infrastructure/payments/xenditWebhook';

const checkoutSchema = z.object({
  ticketId: z.string().uuid(),
  contactEmail: z.string().email().optional(),
});

export const checkout = async (req: Request, res: Response, next: NextFunction) => {
  let paymentId: string | undefined;
  try {
    const parsed = checkoutSchema.safeParse(req.body);
    if (!parsed.success) {
      throw new ApiError(400, 'ticketId is required', 'VALIDATION_ERROR', parsed.error.issues);
    }
    if (!isXenditConfigured()) {
      throw new ApiError(503, 'Xendit is not configured', 'PAYMENT_PROVIDER_NOT_CONFIGURED');
    }
    const ticket = await prisma.ticket.findUnique({
      where: { id: parsed.data.ticketId },
      include: {
        user: true,
        originStation: true,
        destinationStation: true,
        payments: { where: { status: 'PENDING' }, orderBy: { createdAt: 'desc' } },
      },
    });
    if (!ticket) throw new ApiError(404, 'Ticket not found', 'TICKET_NOT_FOUND');
    assertTicketPaymentAccess(ticket, req.auth, parsed.data.contactEmail);
    if (!['PENDING', 'PAYMENT_PENDING'].includes(ticket.status)) {
      throw new ApiError(409, `Ticket status is ${ticket.status}`, 'TICKET_NOT_PAYABLE');
    }
    if (ticket.expiresAt && ticket.expiresAt <= new Date()) {
      await prisma.ticket.update({ where: { id: ticket.id }, data: { status: 'EXPIRED' } });
      throw new ApiError(409, 'Ticket payment window has expired', 'TICKET_EXPIRED');
    }
    const reusable = ticket.payments.find(
      (payment) => payment.checkoutUrl && payment.expiresAt && payment.expiresAt > new Date(),
    );
    if (reusable) {
      res.json({ success: true, data: reusable, meta: { reused: true } });
      return;
    }

    const referenceId = `${ticket.publicCode}-${crypto.randomBytes(3).toString('hex')}`.slice(0, 64);
    const expiresAt = ticket.expiresAt ?? new Date(Date.now() + 30 * 60 * 1000);
    const payment = await prisma.payment.create({
      data: {
        ticketId: ticket.id,
        referenceId,
        amount: ticket.price,
        currency: 'IDR',
        expiresAt,
        status: 'PENDING',
      },
    });
    paymentId = payment.id;
    const session = await createPaymentSession({
      referenceId,
      amount: ticket.price,
      ticketId: ticket.id,
      publicCode: ticket.publicCode,
      description: `Tiket ${ticket.originStation.name} ke ${ticket.destinationStation.name}`,
      customerName: ticket.user?.name,
      customerEmail: ticket.contactEmail ?? ticket.user?.email,
      customerPhone: ticket.contactPhone ?? ticket.user?.phone,
      expiresAt,
    });
    const updated = await prisma.payment.update({
      where: { id: payment.id },
      data: {
        xenditSessionId: session.payment_session_id,
        checkoutUrl: session.payment_link_url,
        expiresAt: new Date(session.expires_at),
      },
    });
    res.status(201).json({ success: true, data: updated, meta: { reused: false } });
  } catch (error) {
    if (paymentId) {
      await prisma.payment.update({ where: { id: paymentId }, data: { status: 'FAILED' } }).catch(() => undefined);
    }
    next(error);
  }
};

export const getPaymentStatus = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const query = z.object({ contactEmail: z.string().email().optional() }).safeParse(req.query);
    if (!query.success) {
      throw new ApiError(400, 'Invalid payment status query', 'VALIDATION_ERROR');
    }
    const ticketId = Array.isArray(req.params.ticketId)
      ? req.params.ticketId[0]
      : req.params.ticketId;
    const ticket = await prisma.ticket.findUnique({
      where: { id: ticketId },
      include: { payments: { orderBy: { createdAt: 'desc' } } },
    });
    if (!ticket) throw new ApiError(404, 'Ticket not found', 'TICKET_NOT_FOUND');
    assertTicketPaymentAccess(ticket, req.auth, query.data.contactEmail);
    res.json({ success: true, data: { ticketStatus: ticket.status, payment: ticket.payments[0] ?? null } });
  } catch (error) {
    next(error);
  }
};

const webhookSchema = z.object({
  event: z.enum(['payment_session.completed', 'payment_session.expired']),
  created: z.string(),
  data: z.object({
    payment_session_id: z.string(),
    reference_id: z.string(),
    status: z.enum(['COMPLETED', 'EXPIRED']),
    amount: z.number(),
    currency: z.string(),
    payment_id: z.string().optional(),
  }),
});

export const xenditWebhook = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const suppliedToken = req.header('x-callback-token');
    if (!verifyXenditCallbackToken(suppliedToken)) {
      throw new ApiError(401, 'Invalid Xendit callback token', 'INVALID_WEBHOOK_TOKEN');
    }
    const parsed = webhookSchema.safeParse(req.body);
    if (!parsed.success) {
      throw new ApiError(400, 'Invalid Xendit webhook payload', 'VALIDATION_ERROR', parsed.error.issues);
    }
    const payload = parsed.data;
    const payment = await prisma.payment.findFirst({
      where: {
        OR: [
          { referenceId: payload.data.reference_id },
          { xenditSessionId: payload.data.payment_session_id },
        ],
      },
      include: { ticket: true },
    });
    if (!payment) throw new ApiError(404, 'Payment reference not found', 'PAYMENT_NOT_FOUND');
    if (
      payment.referenceId !== payload.data.reference_id ||
      (payment.xenditSessionId && payment.xenditSessionId !== payload.data.payment_session_id) ||
      payment.amount !== payload.data.amount ||
      payment.currency !== payload.data.currency
    ) {
      throw new ApiError(409, 'Webhook does not match the payment record', 'PAYMENT_MISMATCH');
    }
    const eventKey = `${payload.event}:${payload.data.payment_session_id}`;
    if (await prisma.webhookEvent.findUnique({ where: { eventKey } })) {
      res.json({ success: true, data: { duplicate: true } });
      return;
    }

    try {
      await prisma.$transaction(async (tx) => {
        await tx.webhookEvent.create({
          data: {
            provider: 'XENDIT',
            eventKey,
            eventType: payload.event,
            payload: payload as unknown as Prisma.InputJsonValue,
          },
        });
        if (payload.event === 'payment_session.completed') {
          const qrCode = payment.ticket.qrCode ?? TicketService.createQrPayload(payment.ticket.publicCode);
          await tx.payment.update({
            where: { id: payment.id },
            data: {
              status: 'COMPLETED',
              xenditPaymentId: payload.data.payment_id,
              xenditSessionId: payload.data.payment_session_id,
            },
          });
          if (!['ACTIVE', 'USED'].includes(payment.ticket.status)) {
            await tx.ticket.update({
              where: { id: payment.ticketId },
              data: { status: 'ACTIVE', qrCode, activatedAt: new Date() },
            });
          }
        } else {
          await tx.payment.update({ where: { id: payment.id }, data: { status: 'EXPIRED' } });
          if (['PENDING', 'PAYMENT_PENDING'].includes(payment.ticket.status)) {
            await tx.ticket.update({ where: { id: payment.ticketId }, data: { status: 'EXPIRED' } });
          }
        }
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        res.json({ success: true, data: { duplicate: true } });
        return;
      }
      throw error;
    }
    res.json({ success: true, data: { duplicate: false } });
  } catch (error) {
    next(error);
  }
};
