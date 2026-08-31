import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/tickets/domain/entities/device_ticket_checkout.dart';
import 'package:timetable/features/tickets/domain/entities/ticket.dart';
import 'package:timetable/features/tickets/domain/repositories/device_ticket_store.dart';
import 'package:timetable/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:timetable/features/tickets/presentation/controllers/ticket_controller.dart';

void main() {
  test(
    'guest checkout remains pending without registering its email',
    () async {
      final repository = _Repository();
      final store = InMemoryDeviceTicketStore();
      final controller = TicketController(repository, deviceStore: store);

      await controller.startCheckout(
        origin: 'Setiabudi',
        destination: 'Manggarai',
        travelDate: DateTime.utc(2026, 8, 13),
        contactEmail: ' Guest@Example.COM ',
      );
      await controller.checkPayment();

      expect(controller.state.stage, TicketStage.paymentPending);
      expect(await store.readPaidEmails(), isEmpty);
      final pending = await store.readPendingCheckouts();
      expect(pending, hasLength(1));
      expect(pending.single.email, 'guest@example.com');
    },
  );

  test('checkout remains available when pending persistence fails', () async {
    final controller = TicketController(
      _Repository(),
      deviceStore: _FailingSaveDeviceStore(),
    );

    await controller.startCheckout(
      origin: 'Setiabudi',
      destination: 'Manggarai',
      travelDate: DateTime.utc(2026, 8, 13),
      contactEmail: 'guest@example.com',
    );

    expect(controller.state.stage, TicketStage.checkoutReady);
    expect(
      controller.state.payment?.checkoutUrl,
      Uri.parse('https://pay.test/1'),
    );
  });

  test('paid guest checkout promotes its normalized email', () async {
    final repository = _Repository()..paymentStatus = TicketStatus.active;
    final store = InMemoryDeviceTicketStore();
    final controller = TicketController(repository, deviceStore: store);
    await controller.startCheckout(
      origin: 'Setiabudi',
      destination: 'Manggarai',
      travelDate: DateTime.utc(2026, 8, 13),
      contactEmail: 'Guest@Example.COM',
    );

    await controller.checkPayment();

    expect(controller.state.stage, TicketStage.ticketActive);
    expect(await store.readPaidEmails(), ['guest@example.com']);
    expect(await store.readPendingCheckouts(), isEmpty);
  });

  test('terminal guest checkout removes pending ownership', () async {
    final repository = _Repository()..paymentStatus = TicketStatus.expired;
    final store = InMemoryDeviceTicketStore();
    final controller = TicketController(repository, deviceStore: store);
    await controller.startCheckout(
      origin: 'Setiabudi',
      destination: 'Manggarai',
      travelDate: DateTime.utc(2026, 8, 13),
      contactEmail: 'guest@example.com',
    );

    await controller.checkPayment();

    expect(controller.state.stage, TicketStage.terminal);
    expect(await store.readPaidEmails(), isEmpty);
    expect(await store.readPendingCheckouts(), isEmpty);
  });

  test(
    'startup reconciles a paid checkout before loading guest history',
    () async {
      final repository = _Repository()..paymentStatus = TicketStatus.paid;
      repository.guestTickets['guest@example.com'] = [
        _ticket(
          id: 'guest-ticket',
          status: TicketStatus.active,
          email: 'guest@example.com',
        ),
      ];
      final store = InMemoryDeviceTicketStore();
      await store.savePendingCheckout(
        const DeviceTicketCheckout(
          ticketId: 'guest-ticket',
          email: 'guest@example.com',
        ),
      );
      final controller = TicketController(repository, deviceStore: store);

      await controller.loadDeviceHistory(includeAccount: false);

      expect(await store.readPaidEmails(), ['guest@example.com']);
      expect(controller.state.tickets.single.id, 'guest-ticket');
    },
  );

  test(
    'manual guest search does not register its email on the device',
    () async {
      final repository = _Repository();
      repository.guestTickets['searched@example.com'] = [
        _ticket(
          id: 'searched-ticket',
          status: TicketStatus.active,
          email: 'searched@example.com',
        ),
      ];
      final store = InMemoryDeviceTicketStore();
      final controller = TicketController(repository, deviceStore: store);

      await controller.loadHistory(contactEmail: 'searched@example.com');

      expect(controller.state.tickets.single.id, 'searched-ticket');
      expect(await store.readPaidEmails(), isEmpty);
    },
  );

  test(
    'device history merges account and guest tickets newest first',
    () async {
      final repository = _Repository();
      repository.accountTickets.addAll([
        _ticket(
          id: 'account-ticket',
          status: TicketStatus.active,
          date: DateTime.utc(2026, 8, 12),
        ),
        _ticket(
          id: 'duplicate',
          status: TicketStatus.used,
          date: DateTime.utc(2026, 8, 10),
        ),
      ]);
      repository.guestTickets['guest@example.com'] = [
        _ticket(
          id: 'guest-ticket',
          status: TicketStatus.active,
          email: 'guest@example.com',
          date: DateTime.utc(2026, 8, 13),
        ),
        _ticket(
          id: 'duplicate',
          status: TicketStatus.used,
          email: 'guest@example.com',
          date: DateTime.utc(2026, 8, 10),
        ),
      ];
      final store = InMemoryDeviceTicketStore();
      await _seedPaidEmail(store, 'guest@example.com');
      final controller = TicketController(repository, deviceStore: store);

      await controller.loadDeviceHistory(
        includeAccount: true,
        accountEmail: 'account@example.com',
      );

      expect(controller.state.tickets.map((ticket) => ticket.id), [
        'guest-ticket',
        'account-ticket',
        'duplicate',
      ]);
      expect(controller.state.deviceEmails, ['guest@example.com']);
      expect(
        controller.state.ownerEmailsByTicketId['account-ticket'],
        'account@example.com',
      );
      expect(
        controller.state.ownerEmailsByTicketId['guest-ticket'],
        'guest@example.com',
      );

      controller.selectTicket(
        controller.state.tickets.singleWhere(
          (ticket) => ticket.id == 'duplicate',
        ),
      );
      expect(controller.state.contactEmail, isNull);
    },
  );

  test(
    'device history keeps successful sources after a partial failure',
    () async {
      final repository = _Repository();
      repository.guestTickets['works@example.com'] = [
        _ticket(
          id: 'available-ticket',
          status: TicketStatus.active,
          email: 'works@example.com',
        ),
      ];
      repository.failingGuestEmails.add('fails@example.com');
      final store = InMemoryDeviceTicketStore();
      await _seedPaidEmail(store, 'works@example.com');
      await _seedPaidEmail(store, 'fails@example.com');
      final controller = TicketController(repository, deviceStore: store);

      await controller.loadDeviceHistory(includeAccount: false);

      expect(controller.state.tickets.single.id, 'available-ticket');
      expect(controller.state.hasPartialHistoryFailure, isTrue);
      expect(controller.state.stage, TicketStage.historyReady);
    },
  );

  test('device history loads every page for a paid device email', () async {
    final repository = _Repository();
    repository.guestTickets['many@example.com'] = List.generate(
      25,
      (index) => _ticket(
        id: 'ticket-$index',
        status: TicketStatus.used,
        email: 'many@example.com',
        date: DateTime.utc(2026, 8, 1).add(Duration(days: index)),
      ),
    );
    final store = InMemoryDeviceTicketStore();
    await _seedPaidEmail(store, 'many@example.com');
    final controller = TicketController(repository, deviceStore: store);

    await controller.loadDeviceHistory(includeAccount: false);

    expect(controller.state.tickets, hasLength(25));
    expect(repository.guestHistoryCalls, 2);
  });
}

Future<void> _seedPaidEmail(DeviceTicketStore store, String email) async {
  final checkout = DeviceTicketCheckout(ticketId: 'seed-$email', email: email);
  await store.savePendingCheckout(checkout);
  await store.promoteCheckout(checkout);
}

class _Repository implements TicketRepository {
  TicketStatus paymentStatus = TicketStatus.paymentPending;
  String? contactEmail;
  final List<Ticket> accountTickets = [];
  final Map<String, List<Ticket>> guestTickets = {};
  final Set<String> failingGuestEmails = {};
  int guestHistoryCalls = 0;

  @override
  Future<Ticket> orderTicket({
    required String origin,
    required String destination,
    required DateTime travelDate,
    int passengerCount = 1,
    String? contactEmail,
  }) async {
    this.contactEmail = contactEmail?.trim().toLowerCase();
    return _ticket(
      id: 'ticket-1',
      status: TicketStatus.paymentPending,
      email: this.contactEmail,
      date: travelDate,
    );
  }

  @override
  Future<TicketPayment> createCheckout({
    required String ticketId,
    String? contactEmail,
  }) async => _payment;

  @override
  Future<PaymentSnapshot> getPaymentStatus({
    required String ticketId,
    String? contactEmail,
  }) async => PaymentSnapshot(
    ticketStatus: paymentStatus,
    payment: _paymentFor(paymentStatus),
  );

  @override
  Future<PaymentSnapshot> getGuestPaymentStatus({
    required String ticketId,
    required String contactEmail,
  }) => getPaymentStatus(ticketId: ticketId, contactEmail: contactEmail);

  @override
  Future<TicketPage> listTickets({
    String? contactEmail,
    int page = 1,
    int limit = 20,
  }) async => TicketPage(
    items: accountTickets.isEmpty
        ? [
            _ticket(
              id: 'ticket-1',
              status: paymentStatus,
              email: this.contactEmail,
            ),
          ]
        : accountTickets,
    page: page,
    limit: limit,
    total: accountTickets.length,
  );

  @override
  Future<TicketPage> listGuestTickets({
    required String contactEmail,
    int page = 1,
    int limit = 20,
  }) async {
    guestHistoryCalls++;
    if (failingGuestEmails.contains(contactEmail)) {
      throw StateError('guest source unavailable');
    }
    final tickets = guestTickets[contactEmail] ?? const [];
    final start = (page - 1) * limit;
    final items = start >= tickets.length
        ? <Ticket>[]
        : tickets.sublist(start, (start + limit).clamp(0, tickets.length));
    return TicketPage(
      items: items,
      page: page,
      limit: limit,
      total: tickets.length,
    );
  }
}

class _FailingSaveDeviceStore extends InMemoryDeviceTicketStore {
  @override
  Future<void> savePendingCheckout(DeviceTicketCheckout checkout) async {
    throw StateError('storage unavailable');
  }
}

Ticket _ticket({
  required String id,
  required TicketStatus status,
  String? email,
  DateTime? date,
}) => Ticket(
  id: id,
  publicCode: 'TKT-$id',
  contactEmail: email,
  origin: const TicketStation(id: 'origin', name: 'Setiabudi'),
  destination: const TicketStation(id: 'destination', name: 'Manggarai'),
  passengerCount: 1,
  unitPrice: 7800,
  price: 7800,
  status: status,
  travelDate: date ?? DateTime.utc(2026, 8, 13),
  payments: [_paymentFor(status)],
  qrCode: status == TicketStatus.active ? 'signed-qr' : null,
);

TicketPayment _paymentFor(TicketStatus status) => TicketPayment(
  id: 'payment-1',
  referenceId: 'ref-1',
  amount: 7800,
  currency: 'IDR',
  status: switch (status) {
    TicketStatus.paid || TicketStatus.active => PaymentStatus.completed,
    TicketStatus.expired => PaymentStatus.expired,
    TicketStatus.cancelled => PaymentStatus.cancelled,
    _ => PaymentStatus.pending,
  },
  checkoutUrl: Uri.parse('https://pay.test/1'),
);

final _payment = _paymentFor(TicketStatus.paymentPending);
