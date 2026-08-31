import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/core/network/access_token_provider.dart';
import 'package:timetable/features/tickets/data/datasources/ticket_remote_data_source.dart';
import 'package:timetable/features/tickets/data/repositories/ticket_repository_impl.dart';
import 'package:timetable/features/tickets/domain/entities/ticket.dart';

void main() {
  test('authenticated history sends token and omits guest email', () async {
    final remote = _Remote();
    final repository = TicketRepositoryImpl(
      tokenProvider: _Tokens('access'),
      remote: remote,
    );

    await repository.listTickets(contactEmail: 'guest@example.com');

    expect(remote.accessToken, 'access');
    expect(remote.contactEmail, isNull);
  });

  test('guest checkout propagates ownership email', () async {
    final remote = _Remote();
    final repository = TicketRepositoryImpl(
      tokenProvider: _Tokens(null),
      remote: remote,
    );

    await repository.createCheckout(
      ticketId: 'ticket-1',
      contactEmail: 'guest@example.com',
    );

    expect(remote.accessToken, isNull);
    expect(remote.contactEmail, 'guest@example.com');
  });

  test('explicit guest history omits an available account token', () async {
    final remote = _Remote();
    final repository = TicketRepositoryImpl(
      tokenProvider: _Tokens('account-token'),
      remote: remote,
    );

    await repository.listGuestTickets(contactEmail: 'guest@example.com');

    expect(remote.accessToken, isNull);
    expect(remote.contactEmail, 'guest@example.com');
  });

  test(
    'explicit guest payment status omits an available account token',
    () async {
      final remote = _Remote();
      final repository = TicketRepositoryImpl(
        tokenProvider: _Tokens('account-token'),
        remote: remote,
      );

      await repository.getGuestPaymentStatus(
        ticketId: 'ticket-1',
        contactEmail: 'guest@example.com',
      );

      expect(remote.accessToken, isNull);
      expect(remote.contactEmail, 'guest@example.com');
    },
  );

  test('unauthorized request refreshes token exactly once', () async {
    final remote = _Remote(unauthorizedOnce: true);
    final tokens = _Tokens('expired', refreshed: 'fresh');
    final repository = TicketRepositoryImpl(
      tokenProvider: tokens,
      remote: remote,
    );

    await repository.listTickets();

    expect(tokens.forceRefreshCalls, 1);
    expect(remote.calls, 2);
    expect(remote.accessToken, 'fresh');
  });
}

class _Tokens implements AccessTokenProvider {
  _Tokens(this.value, {this.refreshed});

  final String? value;
  final String? refreshed;
  int forceRefreshCalls = 0;

  @override
  Future<String?> getAccessToken({bool forceRefresh = false}) async {
    if (forceRefresh) {
      forceRefreshCalls++;
      return refreshed;
    }
    return value;
  }
}

class _Remote extends TicketRemoteDataSource {
  _Remote({this.unauthorizedOnce = false});

  final bool unauthorizedOnce;
  int calls = 0;
  String? accessToken;
  String? contactEmail;

  @override
  Future<TicketPage> listTickets({
    String? accessToken,
    String? contactEmail,
    int page = 1,
    int limit = 20,
  }) async {
    calls++;
    this.accessToken = accessToken;
    this.contactEmail = contactEmail;
    if (unauthorizedOnce && calls == 1) {
      throw const TicketRemoteException(
        'INVALID_ACCESS_TOKEN',
        'expired',
        statusCode: 401,
      );
    }
    return const TicketPage(items: [], page: 1, limit: 20, total: 0);
  }

  @override
  Future<TicketPayment> createCheckout({
    required String ticketId,
    String? contactEmail,
    String? accessToken,
  }) async {
    this.accessToken = accessToken;
    this.contactEmail = contactEmail;
    return _payment;
  }

  @override
  Future<PaymentSnapshot> getPaymentStatus({
    required String ticketId,
    String? contactEmail,
    String? accessToken,
  }) async {
    this.accessToken = accessToken;
    this.contactEmail = contactEmail;
    return const PaymentSnapshot(ticketStatus: TicketStatus.paymentPending);
  }
}

const _payment = TicketPayment(
  id: 'payment-1',
  referenceId: 'ref-1',
  amount: 7800,
  currency: 'IDR',
  status: PaymentStatus.pending,
);
