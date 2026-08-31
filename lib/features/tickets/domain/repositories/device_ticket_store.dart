import '../entities/device_ticket_checkout.dart';

abstract interface class DeviceTicketStore {
  Future<List<String>> readPaidEmails();

  Future<List<DeviceTicketCheckout>> readPendingCheckouts();

  Future<void> savePendingCheckout(DeviceTicketCheckout checkout);

  Future<void> promoteCheckout(DeviceTicketCheckout checkout);

  Future<void> removePendingCheckout(String ticketId);
}

class InMemoryDeviceTicketStore implements DeviceTicketStore {
  final Set<String> _paidEmails = {};
  final Map<String, DeviceTicketCheckout> _pending = {};

  @override
  Future<List<String>> readPaidEmails() async {
    final values = _paidEmails.toList()..sort();
    return values;
  }

  @override
  Future<List<DeviceTicketCheckout>> readPendingCheckouts() async =>
      _pending.values.toList(growable: false);

  @override
  Future<void> savePendingCheckout(DeviceTicketCheckout checkout) async {
    final value = checkout.normalized();
    _pending[value.ticketId] = value;
  }

  @override
  Future<void> promoteCheckout(DeviceTicketCheckout checkout) async {
    final value = checkout.normalized();
    _pending.remove(value.ticketId);
    _paidEmails.add(value.email);
  }

  @override
  Future<void> removePendingCheckout(String ticketId) async {
    _pending.remove(ticketId.trim());
  }
}
