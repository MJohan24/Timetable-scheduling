import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:timetable/core/config/api_config.dart';
import 'package:timetable/features/tickets/data/datasources/ticket_remote_data_source.dart';
import 'package:timetable/features/tickets/domain/entities/ticket.dart';

const _ticket = <String, dynamic>{
  'id': 'ticket-1',
  'publicCode': 'LRT-ABC123',
  'contactEmail': 'guest@example.com',
  'passengerCount': 1,
  'unitPrice': 7800,
  'price': 7800,
  'status': 'PAYMENT_PENDING',
  'qrCode': null,
  'travelDate': '2026-08-13T09:00:00.000Z',
  'departureTime': null,
  'arrivalTime': null,
  'expiresAt': '2026-08-13T09:30:00.000Z',
  'originStation': {'id': 'station-1', 'name': 'Setiabudi'},
  'destinationStation': {'id': 'station-2', 'name': 'Manggarai'},
  'payments': <Map<String, dynamic>>[],
};

const _payment = <String, dynamic>{
  'id': 'payment-1',
  'referenceId': 'LRT-ABC123-a1b2c3',
  'checkoutUrl': 'https://checkout.xendit.co/web/session-1',
  'currency': 'IDR',
  'amount': 7800,
  'status': 'PENDING',
  'expiresAt': '2026-08-13T09:30:00.000Z',
};

void main() {
  test('order posts route and guest contact to backend', () async {
    http.Request? captured;
    final source = TicketRemoteDataSource(
      client: MockClient((request) async {
        captured = request;
        return http.Response(
          jsonEncode({'success': true, 'data': _ticket}),
          201,
        );
      }),
    );

    final ticket = await source.orderTicket(
      origin: 'setiabudi',
      destination: 'manggarai',
      travelDate: DateTime.utc(2026, 8, 13, 9),
      contactEmail: 'guest@example.com',
    );

    expect(captured!.method, 'POST');
    expect(captured!.url.toString(), '${ApiConfig.baseUrl}/tickets/order');
    expect(jsonDecode(captured!.body), {
      'origin': 'setiabudi',
      'destination': 'manggarai',
      'travelDate': '2026-08-13T09:00:00.000Z',
      'passengerCount': 1,
      'contactEmail': 'guest@example.com',
    });
    expect(ticket.status, TicketStatus.paymentPending);
  });

  test('history sends bearer token and parses pagination', () async {
    http.Request? captured;
    final source = TicketRemoteDataSource(
      client: MockClient((request) async {
        captured = request;
        return http.Response(
          jsonEncode({
            'success': true,
            'data': [_ticket],
            'meta': {'page': 1, 'limit': 20, 'total': 1},
          }),
          200,
        );
      }),
    );

    final page = await source.listTickets(accessToken: 'access-token');

    expect(captured!.method, 'GET');
    expect(captured!.url.path, '/api/v1/tickets');
    expect(captured!.headers['authorization'], 'Bearer access-token');
    expect(page.total, 1);
  });

  test('checkout and status include matching guest email', () async {
    final requests = <http.Request>[];
    final source = TicketRemoteDataSource(
      client: MockClient((request) async {
        requests.add(request);
        if (request.url.path.endsWith('/checkout')) {
          return http.Response(
            jsonEncode({'success': true, 'data': _payment}),
            201,
          );
        }
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'ticketStatus': 'ACTIVE',
              'payment': {..._payment, 'status': 'COMPLETED'},
            },
          }),
          200,
        );
      }),
    );

    final payment = await source.createCheckout(
      ticketId: 'ticket-1',
      contactEmail: 'guest@example.com',
    );
    final status = await source.getPaymentStatus(
      ticketId: 'ticket-1',
      contactEmail: 'guest@example.com',
    );

    expect(jsonDecode(requests.first.body), {
      'ticketId': 'ticket-1',
      'contactEmail': 'guest@example.com',
    });
    expect(
      requests.last.url.queryParameters['contactEmail'],
      'guest@example.com',
    );
    expect(payment.checkoutUrl, isNotNull);
    expect(status.ticketStatus, TicketStatus.active);
  });

  test('non-success response exposes stable backend error', () async {
    final source = TicketRemoteDataSource(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'success': false,
            'error': {
              'code': 'TICKET_EXPIRED',
              'message': 'Ticket payment window has expired',
            },
          }),
          409,
        ),
      ),
    );

    expect(
      () => source.createCheckout(ticketId: 'ticket-1'),
      throwsA(
        isA<TicketRemoteException>()
            .having((error) => error.code, 'code', 'TICKET_EXPIRED')
            .having((error) => error.statusCode, 'statusCode', 409),
      ),
    );
  });

  test('timeout exposes a retryable network error', () async {
    final source = TicketRemoteDataSource(
      client: MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return http.Response('{}', 200);
      }),
      requestTimeout: const Duration(milliseconds: 5),
    );

    expect(
      () => source.listTickets(contactEmail: 'guest@example.com'),
      throwsA(
        isA<TicketRemoteException>()
            .having((error) => error.code, 'code', 'NETWORK_ERROR')
            .having((error) => error.isNetwork, 'isNetwork', isTrue),
      ),
    );
  });
}
