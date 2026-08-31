import 'package:flutter/foundation.dart';

import '../../data/datasources/ticket_remote_data_source.dart';
import '../../domain/entities/device_ticket_checkout.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/device_ticket_store.dart';
import '../../domain/repositories/ticket_repository.dart';

enum TicketStage {
  idle,
  loadingHistory,
  historyReady,
  ordering,
  checkoutReady,
  checkingPayment,
  paymentPending,
  ticketActive,
  terminal,
  failure,
}

@immutable
class TicketViewState {
  const TicketViewState({
    this.stage = TicketStage.idle,
    this.tickets = const [],
    this.selectedTicket,
    this.payment,
    this.contactEmail,
    this.deviceEmails = const [],
    this.ownerEmailsByTicketId = const {},
    this.hasPartialHistoryFailure = false,
    this.isDeviceHistory = false,
    this.errorCode,
    this.errorMessage,
  });

  final TicketStage stage;
  final List<Ticket> tickets;
  final Ticket? selectedTicket;
  final TicketPayment? payment;
  final String? contactEmail;
  final List<String> deviceEmails;
  final Map<String, String> ownerEmailsByTicketId;
  final bool hasPartialHistoryFailure;
  final bool isDeviceHistory;
  final String? errorCode;
  final String? errorMessage;

  TicketViewState copyWith({
    TicketStage? stage,
    List<Ticket>? tickets,
    Ticket? selectedTicket,
    TicketPayment? payment,
    String? contactEmail,
    List<String>? deviceEmails,
    Map<String, String>? ownerEmailsByTicketId,
    bool? hasPartialHistoryFailure,
    bool? isDeviceHistory,
    String? errorCode,
    String? errorMessage,
    bool clearError = false,
    bool clearContactEmail = false,
  }) => TicketViewState(
    stage: stage ?? this.stage,
    tickets: tickets ?? this.tickets,
    selectedTicket: selectedTicket ?? this.selectedTicket,
    payment: payment ?? this.payment,
    contactEmail: clearContactEmail ? null : contactEmail ?? this.contactEmail,
    deviceEmails: deviceEmails ?? this.deviceEmails,
    ownerEmailsByTicketId: ownerEmailsByTicketId ?? this.ownerEmailsByTicketId,
    hasPartialHistoryFailure:
        hasPartialHistoryFailure ?? this.hasPartialHistoryFailure,
    isDeviceHistory: isDeviceHistory ?? this.isDeviceHistory,
    errorCode: clearError ? null : errorCode ?? this.errorCode,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}

class TicketController extends ChangeNotifier {
  TicketController(this._repository, {DeviceTicketStore? deviceStore})
    : _deviceStore = deviceStore ?? InMemoryDeviceTicketStore();

  final TicketRepository _repository;
  final DeviceTicketStore _deviceStore;
  final Set<String> _guestTicketIds = {};
  TicketViewState _state = const TicketViewState();

  TicketViewState get state => _state;

  Future<void> loadHistory({String? contactEmail}) async {
    _setState(
      _state.copyWith(
        stage: TicketStage.loadingHistory,
        contactEmail: contactEmail,
        clearError: true,
        isDeviceHistory: false,
      ),
    );
    try {
      final page = contactEmail == null
          ? await _repository.listTickets()
          : await _repository.listGuestTickets(contactEmail: contactEmail);
      final owners = <String, String>{
        if (contactEmail != null)
          for (final ticket in page.items) ticket.id: contactEmail,
      };
      if (contactEmail != null) {
        _guestTicketIds.addAll(page.items.map((ticket) => ticket.id));
      }
      _setState(
        _state.copyWith(
          stage: TicketStage.historyReady,
          tickets: page.items,
          ownerEmailsByTicketId: owners,
          hasPartialHistoryFailure: false,
          isDeviceHistory: false,
        ),
      );
    } catch (error) {
      _fail(error);
    }
  }

  Future<void> loadDeviceHistory({
    required bool includeAccount,
    String? accountEmail,
  }) async {
    _setState(
      _state.copyWith(
        stage: TicketStage.loadingHistory,
        clearError: true,
        hasPartialHistoryFailure: false,
        isDeviceHistory: true,
      ),
    );

    var failures = await _reconcilePendingCheckouts();
    final deviceEmails = await _deviceStore.readPaidEmails();
    final ticketsById = <String, Ticket>{};
    final owners = <String, String>{};
    _guestTicketIds.clear();
    var sourceCount = deviceEmails.length;
    var successfulSources = 0;

    if (includeAccount) {
      sourceCount++;
      try {
        final accountTickets = await _loadAllPages(
          (page, limit) => _repository.listTickets(page: page, limit: limit),
        );
        successfulSources++;
        final normalizedAccountEmail = accountEmail?.trim().toLowerCase();
        for (final ticket in accountTickets) {
          ticketsById.putIfAbsent(ticket.id, () => ticket);
          if (normalizedAccountEmail != null &&
              normalizedAccountEmail.isNotEmpty) {
            owners[ticket.id] = normalizedAccountEmail;
          }
        }
      } on Object {
        failures++;
      }
    }

    for (final email in deviceEmails) {
      try {
        final guestTickets = await _loadAllPages(
          (page, limit) => _repository.listGuestTickets(
            contactEmail: email,
            page: page,
            limit: limit,
          ),
        );
        successfulSources++;
        for (final ticket in guestTickets) {
          if (!ticketsById.containsKey(ticket.id)) {
            ticketsById[ticket.id] = ticket;
            owners[ticket.id] =
                ticket.contactEmail?.trim().toLowerCase() ?? email;
            _guestTicketIds.add(ticket.id);
          }
        }
      } on Object {
        failures++;
      }
    }

    if (sourceCount > 0 && successfulSources == 0) {
      _setState(
        _state.copyWith(
          stage: TicketStage.failure,
          deviceEmails: deviceEmails,
          errorCode: 'HISTORY_UNAVAILABLE',
          errorMessage: 'Riwayat tiket belum dapat dimuat.',
          isDeviceHistory: true,
        ),
      );
      return;
    }

    final tickets = ticketsById.values.toList()
      ..sort((a, b) => b.travelDate.compareTo(a.travelDate));
    _setState(
      _state.copyWith(
        stage: TicketStage.historyReady,
        tickets: tickets,
        deviceEmails: deviceEmails,
        ownerEmailsByTicketId: owners,
        hasPartialHistoryFailure: failures > 0,
        clearError: true,
        clearContactEmail: true,
        isDeviceHistory: true,
      ),
    );
  }

  Future<List<Ticket>> _loadAllPages(
    Future<TicketPage> Function(int page, int limit) loadPage,
  ) async {
    const limit = 20;
    final tickets = <Ticket>[];
    var pageNumber = 1;
    while (true) {
      final page = await loadPage(pageNumber, limit);
      tickets.addAll(page.items);
      if (page.items.isEmpty || tickets.length >= page.total) break;
      pageNumber++;
    }
    return tickets;
  }

  Future<void> startCheckout({
    required String origin,
    required String destination,
    required DateTime travelDate,
    int passengerCount = 1,
    String? contactEmail,
  }) async {
    final normalizedEmail = contactEmail?.trim().toLowerCase();
    _setState(
      _state.copyWith(
        stage: TicketStage.ordering,
        contactEmail: normalizedEmail,
        clearError: true,
      ),
    );
    try {
      final ticket = await _repository.orderTicket(
        origin: origin,
        destination: destination,
        travelDate: travelDate,
        passengerCount: passengerCount,
        contactEmail: normalizedEmail,
      );
      final payment = await _repository.createCheckout(
        ticketId: ticket.id,
        contactEmail: normalizedEmail,
      );
      if (normalizedEmail != null && normalizedEmail.isNotEmpty) {
        try {
          await _deviceStore.savePendingCheckout(
            DeviceTicketCheckout(ticketId: ticket.id, email: normalizedEmail),
          );
        } on Object {
          // A local registry failure must not hide a valid hosted checkout.
        }
      }
      _setState(
        _state.copyWith(
          stage: TicketStage.checkoutReady,
          selectedTicket: ticket,
          payment: payment,
        ),
      );
    } catch (error) {
      _fail(error);
    }
  }

  Future<void> checkPayment() async {
    final ticket = _state.selectedTicket;
    if (ticket == null) return;
    _setState(
      _state.copyWith(stage: TicketStage.checkingPayment, clearError: true),
    );
    try {
      final guestEmail = _state.contactEmail;
      final snapshot = guestEmail == null
          ? await _repository.getPaymentStatus(ticketId: ticket.id)
          : await _repository.getGuestPaymentStatus(
              ticketId: ticket.id,
              contactEmail: guestEmail,
            );
      if (snapshot.ticketStatus == TicketStatus.active ||
          snapshot.ticketStatus == TicketStatus.paid) {
        if (guestEmail != null) {
          await _deviceStore.promoteCheckout(
            DeviceTicketCheckout(ticketId: ticket.id, email: guestEmail),
          );
        }
        final page = guestEmail == null
            ? await _repository.listTickets()
            : await _repository.listGuestTickets(contactEmail: guestEmail);
        final refreshed = page.items.where((item) => item.id == ticket.id);
        _setState(
          _state.copyWith(
            stage: TicketStage.ticketActive,
            tickets: page.items,
            selectedTicket: refreshed.isEmpty ? ticket : refreshed.first,
            payment: snapshot.payment,
          ),
        );
        return;
      }
      if (snapshot.ticketStatus == TicketStatus.expired ||
          snapshot.ticketStatus == TicketStatus.cancelled ||
          snapshot.payment?.status == PaymentStatus.failed ||
          snapshot.payment?.status == PaymentStatus.expired ||
          snapshot.payment?.status == PaymentStatus.cancelled) {
        if (guestEmail != null) {
          await _deviceStore.removePendingCheckout(ticket.id);
        }
        _setState(
          _state.copyWith(
            stage: TicketStage.terminal,
            payment: snapshot.payment,
          ),
        );
        return;
      }
      _setState(
        _state.copyWith(
          stage: TicketStage.paymentPending,
          payment: snapshot.payment,
        ),
      );
    } catch (error) {
      _fail(error);
    }
  }

  void selectTicket(Ticket ticket) {
    final isGuestTicket = _guestTicketIds.contains(ticket.id);
    _setState(
      _state.copyWith(
        selectedTicket: ticket,
        payment: ticket.latestPayment,
        stage: ticket.isActive
            ? TicketStage.ticketActive
            : ticket.isPending
            ? TicketStage.paymentPending
            : TicketStage.historyReady,
        contactEmail: isGuestTicket
            ? ticket.contactEmail ?? _state.ownerEmailsByTicketId[ticket.id]
            : null,
        clearContactEmail: !isGuestTicket,
        clearError: true,
      ),
    );
  }

  Future<int> _reconcilePendingCheckouts() async {
    var failures = 0;
    final pending = await _deviceStore.readPendingCheckouts();
    for (final checkout in pending) {
      try {
        final snapshot = await _repository.getGuestPaymentStatus(
          ticketId: checkout.ticketId,
          contactEmail: checkout.email,
        );
        if (snapshot.ticketStatus == TicketStatus.active ||
            snapshot.ticketStatus == TicketStatus.paid) {
          await _deviceStore.promoteCheckout(checkout);
        } else if (snapshot.ticketStatus == TicketStatus.expired ||
            snapshot.ticketStatus == TicketStatus.cancelled ||
            snapshot.payment?.status == PaymentStatus.failed ||
            snapshot.payment?.status == PaymentStatus.expired ||
            snapshot.payment?.status == PaymentStatus.cancelled) {
          await _deviceStore.removePendingCheckout(checkout.ticketId);
        }
      } on Object {
        failures++;
      }
    }
    return failures;
  }

  void _fail(Object error) {
    if (error is TicketRemoteException) {
      _setState(
        _state.copyWith(
          stage: TicketStage.failure,
          errorCode: error.code,
          errorMessage: error.message,
        ),
      );
      return;
    }
    _setState(
      _state.copyWith(
        stage: TicketStage.failure,
        errorCode: 'UNEXPECTED_ERROR',
        errorMessage: 'Unexpected ticket error',
      ),
    );
  }

  void _setState(TicketViewState value) {
    _state = value;
    notifyListeners();
  }
}
