import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/tickets/data/models/ticket_model.dart';
import 'package:timetable/features/tickets/domain/entities/ticket.dart';

const _ticketJson = <String, dynamic>{
  'id': 'ticket-1',
  'publicCode': 'LRT-ABC123',
  'contactEmail': 'guest@example.com',
  'passengerCount': 1,
  'unitPrice': 7800,
  'price': 7800,
  'status': 'ACTIVE',
  'qrCode': 'signed-ticket-qr-payload',
  'travelDate': '2026-08-13T09:00:00.000Z',
  'departureTime': '09:00',
  'arrivalTime': '09:18',
  'expiresAt': '2026-08-13T09:30:00.000Z',
  'originStation': {'id': 'station-1', 'name': 'Setiabudi'},
  'destinationStation': {'id': 'station-2', 'name': 'Manggarai'},
  'payments': [
    {
      'id': 'payment-1',
      'referenceId': 'LRT-ABC123-a1b2c3',
      'checkoutUrl': 'https://checkout.xendit.co/web/session-1',
      'currency': 'IDR',
      'amount': 7800,
      'status': 'COMPLETED',
      'expiresAt': '2026-08-13T09:30:00.000Z',
    },
  ],
};

void main() {
  test('ticket model maps active backend ticket and latest payment', () {
    final ticket = TicketModel.fromJson(_ticketJson);

    expect(ticket.id, 'ticket-1');
    expect(ticket.status, TicketStatus.active);
    expect(ticket.origin.name, 'Setiabudi');
    expect(ticket.destination.name, 'Manggarai');
    expect(ticket.price, 7800);
    expect(ticket.qrCode, 'signed-ticket-qr-payload');
    expect(ticket.latestPayment?.status, PaymentStatus.completed);
    expect(
      ticket.latestPayment?.checkoutUrl.toString(),
      'https://checkout.xendit.co/web/session-1',
    );
    expect(ticket.isCompleted, isFalse);
  });

  test('ticket model maps terminal and unknown statuses safely', () {
    final used = TicketModel.fromJson({..._ticketJson, 'status': 'USED'});
    final unknown = TicketModel.fromJson({
      ..._ticketJson,
      'status': 'PROVIDER_REVIEW',
      'payments': [
        {...(_ticketJson['payments'] as List).first, 'status': 'REVIEW'},
      ],
    });

    expect(used.status, TicketStatus.used);
    expect(used.isCompleted, isTrue);
    expect(unknown.status, TicketStatus.unknown);
    expect(unknown.latestPayment?.status, PaymentStatus.unknown);
  });

  test('ticket page model maps pagination metadata', () {
    final page = TicketPageModel.fromResponse({
      'data': [_ticketJson],
      'meta': {'page': 2, 'limit': 10, 'total': 11},
    });

    expect(page.items, hasLength(1));
    expect(page.page, 2);
    expect(page.limit, 10);
    expect(page.total, 11);
  });

  test('payment snapshot maps a nullable payment', () {
    final pending = PaymentSnapshotModel.fromJson({
      'ticketStatus': 'PAYMENT_PENDING',
      'payment': null,
    });

    expect(pending.ticketStatus, TicketStatus.paymentPending);
    expect(pending.payment, isNull);
  });
}
