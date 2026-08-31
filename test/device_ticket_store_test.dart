import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:timetable/features/tickets/data/datasources/shared_preferences_device_ticket_store.dart';
import 'package:timetable/features/tickets/domain/entities/device_ticket_checkout.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() {
    SharedPreferencesAsyncPlatform.instance = null;
  });

  test(
    'pending checkout normalizes its email and replaces the same ticket',
    () async {
      final store = SharedPreferencesDeviceTicketStore(
        SharedPreferencesAsync(),
      );

      await store.savePendingCheckout(
        const DeviceTicketCheckout(
          ticketId: 'ticket-1',
          email: ' Guest@Example.COM ',
        ),
      );
      await store.savePendingCheckout(
        const DeviceTicketCheckout(
          ticketId: 'ticket-1',
          email: 'other@example.com',
        ),
      );

      final pending = await store.readPendingCheckouts();
      expect(pending, hasLength(1));
      expect(pending.single.ticketId, 'ticket-1');
      expect(pending.single.email, 'other@example.com');
    },
  );

  test(
    'promoting checkouts removes pending entries and deduplicates email',
    () async {
      final store = SharedPreferencesDeviceTicketStore(
        SharedPreferencesAsync(),
      );
      const first = DeviceTicketCheckout(
        ticketId: 'ticket-1',
        email: 'Guest@Example.com',
      );
      const second = DeviceTicketCheckout(
        ticketId: 'ticket-2',
        email: 'guest@example.com',
      );
      await store.savePendingCheckout(first);
      await store.savePendingCheckout(second);

      await store.promoteCheckout(first);
      await store.promoteCheckout(second);

      expect(await store.readPaidEmails(), ['guest@example.com']);
      expect(await store.readPendingCheckouts(), isEmpty);
    },
  );
}
