import { ApiError } from '../errors/ApiError';

export type TicketPaymentOwner = {
  userId: string | null;
  contactEmail: string | null;
};

export type TicketRequestAuth = {
  userId?: string;
  role: 'GUEST' | 'REGISTERED' | 'ADMIN';
};

export function assertTicketPaymentAccess(
  ticket: TicketPaymentOwner,
  auth?: TicketRequestAuth,
  guestEmail?: string,
) {
  if (ticket.userId) {
    if (auth?.role !== 'GUEST' && auth?.userId === ticket.userId) return;
    throw new ApiError(
      403,
      'Ticket belongs to another account',
      'TICKET_FORBIDDEN',
    );
  }

  const suppliedEmail = guestEmail?.trim().toLowerCase();
  const ticketEmail = ticket.contactEmail?.trim().toLowerCase();
  if (suppliedEmail && ticketEmail === suppliedEmail) return;

  throw new ApiError(
    403,
    'Guest ticket email does not match',
    'TICKET_FORBIDDEN',
  );
}
