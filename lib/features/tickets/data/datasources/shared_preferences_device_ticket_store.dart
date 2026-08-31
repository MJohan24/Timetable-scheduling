import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/device_ticket_checkout.dart';
import '../../domain/repositories/device_ticket_store.dart';

class SharedPreferencesDeviceTicketStore implements DeviceTicketStore {
  SharedPreferencesDeviceTicketStore(this._preferences);

  static const paidEmailsKey = 'device_paid_ticket_emails';
  static const pendingCheckoutsKey = 'device_pending_ticket_checkouts';

  final SharedPreferencesAsync _preferences;

  @override
  Future<List<String>> readPaidEmails() async {
    final values = await _preferences.getStringList(paidEmailsKey) ?? const [];
    final normalized =
        values
            .map((email) => email.trim().toLowerCase())
            .where((email) => email.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return normalized;
  }

  @override
  Future<List<DeviceTicketCheckout>> readPendingCheckouts() async {
    final encoded = await _preferences.getString(pendingCheckoutsKey);
    if (encoded == null || encoded.isEmpty) return const [];
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((value) => Map<String, dynamic>.from(value))
          .where(
            (value) => value['ticketId'] is String && value['email'] is String,
          )
          .map(
            (value) => DeviceTicketCheckout(
              ticketId: value['ticketId'] as String,
              email: value['email'] as String,
            ).normalized(),
          )
          .where(
            (checkout) =>
                checkout.ticketId.isNotEmpty && checkout.email.isNotEmpty,
          )
          .toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> savePendingCheckout(DeviceTicketCheckout checkout) async {
    final value = checkout.normalized();
    final pending = {
      for (final item in await readPendingCheckouts()) item.ticketId: item,
      value.ticketId: value,
    };
    await _writePending(pending.values);
  }

  @override
  Future<void> promoteCheckout(DeviceTicketCheckout checkout) async {
    final value = checkout.normalized();
    final paidEmails = {...await readPaidEmails(), value.email}.toList()
      ..sort();
    await _preferences.setStringList(paidEmailsKey, paidEmails);
    await removePendingCheckout(value.ticketId);
  }

  @override
  Future<void> removePendingCheckout(String ticketId) async {
    final normalizedId = ticketId.trim();
    final remaining = (await readPendingCheckouts()).where(
      (checkout) => checkout.ticketId != normalizedId,
    );
    await _writePending(remaining);
  }

  Future<void> _writePending(Iterable<DeviceTicketCheckout> checkouts) =>
      _preferences.setString(
        pendingCheckoutsKey,
        jsonEncode(
          checkouts
              .map(
                (checkout) => {
                  'ticketId': checkout.ticketId,
                  'email': checkout.email,
                },
              )
              .toList(growable: false),
        ),
      );
}
