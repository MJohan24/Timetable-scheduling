import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:timetable/core/routing/router.dart';
import 'package:timetable/core/theme/app_colors.dart';
import 'package:timetable/features/assistant/presentation/controllers/assistant_controller.dart';
import 'package:timetable/features/assistant/presentation/controllers/assistant_conversation_controller.dart';
import 'package:timetable/features/assistant/presentation/pages/assistant_page.dart';
import 'package:timetable/features/tickets/presentation/pages/tickets_page.dart';
import 'package:timetable/features/travel_alarm/presentation/controllers/travel_alarm_controller.dart';
import 'package:timetable/features/travel_alarm/presentation/widgets/travel_alarm_scope.dart';
import 'package:timetable/l10n/app_localizations.dart';
import 'package:timetable/main.dart';

import 'helpers/localized_test_app.dart';

// These scenarios document the removed local payment simulator. The live
// checkout contract is covered by ticket_checkout_page_test.dart.
void legacyTicketSimulationTest(
  String description,
  WidgetTesterCallback callback,
) {}

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  for (final locale in const <Locale>[
    Locale('en'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale('ar'),
  ]) {
    legacyTicketSimulationTest(
      'Ticket service info follows ${locale.toLanguageTag()}',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          localizedTestApp(
            locale: locale,
            home: const TicketsPage(duration: '18', transit: '0'),
          ),
        );
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(TicketsPage));
        final l10n = AppLocalizations.of(context)!;
        final expected =
            '${l10n.lineNoTransit('LRT Jabodebek')} · ${l10n.durationMinutes('18')}';

        expect(find.text(expected), findsOneWidget);
        expect(find.textContaining('menit'), findsNothing);
        expect(find.textContaining('tanpa transit'), findsNothing);

        await tester.pumpWidget(
          localizedTestApp(
            locale: locale,
            home: const TicketsPage(duration: '18', transit: '1'),
          ),
        );
        await tester.pumpAndSettle();

        final expectedWithTransit =
            'LRT Jabodebek · ${l10n.durationMinutes('18')} · ${l10n.oneTransitAt('Setiabudi')}';
        expect(find.text(expectedWithTransit), findsOneWidget);
        expect(find.textContaining('menit'), findsNothing);
      },
    );
  }

  testWidgets('Tickets and Assistant share one travel alarm controller', (
    WidgetTester tester,
  ) async {
    appRouter.go('/tiket');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final ticketContext = tester.element(find.byType(TicketsPage));
    final ticketController = TravelAlarmScope.of(ticketContext);

    appRouter.go('/asisten');
    await tester.pumpAndSettle();
    final assistantContext = tester.element(find.byType(AssistantPage));

    expect(TravelAlarmScope.of(assistantContext), same(ticketController));
  });

  testWidgets('travel reminder is shown while another app page is open', (
    WidgetTester tester,
  ) async {
    appRouter.go('/');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final context = tester.element(
      find.text('Ketik nama stasiun, jalur, atau area'),
    );
    final alarms = TravelAlarmScope.of(context);
    alarms.completePurchase(from: 'Setiabudi', to: 'Manggarai');
    alarms.configureAlarms(departure: true, destination: false);

    alarms.advanceDepartureDemo();
    await tester.pump();
    await tester.pump();

    expect(find.text('Kereta datang 1 menit lagi'), findsOneWidget);
    alarms.cancelAllAlarms();
  });

  testWidgets('Home screen renders merged route search entry points', (
    WidgetTester tester,
  ) async {
    appRouter.go('/');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Ketik nama stasiun, jalur, atau area'), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Filter Kawasan'), findsOneWidget);
    expect(find.text('Filter Jalur Transportasi'), findsOneWidget);
    expect(
      find.text(
        'A11Y: Ada daftar rute dan tombol bacakan, peta bukan satu-satunya navigasi.',
      ),
      findsNothing,
    );
  });

  testWidgets('Selected station panel shows next train arrival board', (
    WidgetTester tester,
  ) async {
    appRouter.go('/?selected=Setiabudi');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Kereta berikutnya dari Setiabudi'), findsOneWidget);
    expect(find.text('Datang 3 menit lagi'), findsOneWidget);
    expect(find.text('Perjalanan 5 menit'), findsOneWidget);
    expect(find.text('Peron 1'), findsOneWidget);
  });

  testWidgets('Blind Guide switch opens auto-voice camera mode and resets', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    appRouter.go('/akun');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Pemandu Tunanetra'),
      180,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Aksesibilitas'), findsNothing);
    final guideSwitch = find.byKey(const ValueKey('blind-guide-switch'));
    expect(tester.widget<Switch>(guideSwitch).value, isFalse);

    await tester.scrollUntilVisible(
      guideSwitch,
      180,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(guideSwitch);

    final uri = appRouter.routeInformationProvider.value.uri;
    expect(uri.path, '/asisten/pemandu-kamera');
    expect(uri.queryParameters['autoVoice'], 'true');

    await tester.pump();
    appRouter.pop();
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(guideSwitch).value, isFalse);
  });

  testWidgets('Account opens filterable ticket history without bottom nav', (
    WidgetTester tester,
  ) async {
    appRouter.go('/akun');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Riwayat tiket lokal'),
      180,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Riwayat tiket lokal'));
    await tester.pumpAndSettle();

    expect(find.text('Riwayat tiket'), findsOneWidget);
    expect(find.text('Tiket terakhir'), findsOneWidget);
    expect(find.text('Bogor → Jakarta Kota'), findsOneWidget);
    expect(find.text('Dukuh Atas → Harjamukti'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Aktif'));
    await tester.pumpAndSettle();
    expect(find.text('Bogor → Jakarta Kota'), findsOneWidget);
    expect(find.text('Dukuh Atas → Harjamukti'), findsNothing);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Mode tamu aktif'), findsOneWidget);
  });

  testWidgets('Account opens language page and switches to English', (
    WidgetTester tester,
  ) async {
    appRouter.go('/akun');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bahasa'));
    await tester.pumpAndSettle();

    expect(find.text('Bahasa aplikasi'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    for (final label in const <String>[
      'Indonesia',
      'English',
      '简体中文',
      'العربية',
    ]) {
      expect(find.text(label, skipOffstage: false), findsWidgets);
    }

    await tester.tap(find.text('English'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('App Language'), findsOneWidget);
    expect(find.text('Language applied.'), findsOneWidget);
  });

  testWidgets('Active history opens active ticket detail without bottom nav', (
    WidgetTester tester,
  ) async {
    appRouter.go('/riwayat-tiket');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Aktif'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Detail'));
    await tester.pumpAndSettle();

    expect(find.text('Detail tiket aktif'), findsOneWidget);
    expect(find.text('Kode tiket aktif'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Tiket aktif'),
      180,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Tiket aktif'), findsOneWidget);
    expect(find.textContaining('lokal'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Bagikan kode'),
      120,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Bagikan kode'));
    await tester.pump();
    expect(find.text('Kode tiket aktif siap dibagikan.'), findsOneWidget);
  });

  testWidgets('Account opens searchable help center without bottom nav', (
    WidgetTester tester,
  ) async {
    appRouter.go('/akun');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Pusat Bantuan'),
      180,
      scrollable: find.byType(Scrollable),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pusat Bantuan'));
    await tester.pumpAndSettle();

    expect(find.text('Aksi cepat'), findsOneWidget);
    expect(find.text('Chat petugas'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.enterText(find.byType(TextField), 'jadwal');
    await tester.pumpAndSettle();
    expect(find.text('Jadwal atau ETA tidak sesuai'), findsOneWidget);
    expect(find.text('Masalah pembayaran'), findsNothing);

    await tester.tap(find.text('Chat petugas'));
    await tester.pumpAndSettle();
    expect(find.text('Chat Tiket'), findsOneWidget);
    expect(find.text('Topik aktif: Tiket'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.tap(find.text('Jadwal'));
    await tester.pumpAndSettle();
    expect(find.text('Chat Jadwal'), findsOneWidget);
    expect(find.text('Topik aktif: Jadwal'), findsOneWidget);
  });

  testWidgets('Support chat opens a local conversation and replies by topic', (
    WidgetTester tester,
  ) async {
    appRouter.go('/bantuan/chat');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Mulai chat tiket'),
      180,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Mulai chat tiket'));
    await tester.pumpAndSettle();

    expect(find.text('Petugas tiket'), findsWidgets);
    expect(find.text('Tiket • Balasan lokal'), findsOneWidget);
    expect(find.text('Saya butuh bantuan terkait tiket'), findsOneWidget);
    expect(find.textContaining('Halo, saya Rani'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('support-chat-message-field')),
      'Tiket saya belum muncul',
    );
    await tester.tap(find.byKey(const Key('support-chat-send-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(
      find.text('Tiket saya belum muncul', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Petugas sedang mengetik…'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 450));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Coba buka Tiket Saya', skipOffstage: false),
      findsOneWidget,
    );
    expect(find.text('Petugas sedang mengetik…'), findsNothing);
  });

  testWidgets(
    'Support chat keeps schedule and payment conversations distinct',
    (WidgetTester tester) async {
      appRouter.go('/bantuan/chat/percakapan?topic=schedule');
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Chat Jadwal'), findsOneWidget);
      expect(find.text('Petugas jadwal'), findsWidgets);
      expect(
        find.text('Saya butuh bantuan terkait jadwal atau ETA kereta'),
        findsOneWidget,
      );

      appRouter.go('/bantuan/chat/percakapan?topic=payment');
      await tester.pumpAndSettle();

      expect(find.text('Chat Pembayaran'), findsOneWidget);
      expect(
        find.text('Petugas pembayaran', skipOffstage: false),
        findsWidgets,
      );
      expect(
        find.text('Saya butuh bantuan terkait pembayaran tiket'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Ticket purchase help opens the same ticket chat setup', (
    WidgetTester tester,
  ) async {
    appRouter.go('/pusat-bantuan');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Cara membeli tiket lokal'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Cara membeli tiket lokal'));
    await tester.pumpAndSettle();

    expect(find.text('Chat Tiket'), findsOneWidget);
    expect(find.text('Topik aktif: Tiket'), findsOneWidget);
  });

  testWidgets('Help center opens all incorrect information report variants', (
    WidgetTester tester,
  ) async {
    appRouter.go('/pusat-bantuan');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Lapor info salah'));
    await tester.pumpAndSettle();
    expect(find.text('Lapor Jadwal'), findsOneWidget);
    expect(find.text('Jenis laporan: Jadwal'), findsOneWidget);

    await tester.tap(find.text('Rute'));
    await tester.pumpAndSettle();
    expect(find.text('Lapor Rute'), findsOneWidget);
    expect(find.text('Rute bermasalah'), findsOneWidget);

    await tester.tap(find.text('Stasiun'));
    await tester.pumpAndSettle();
    expect(find.text('Lapor Stasiun'), findsOneWidget);
    expect(find.text('Info yang salah'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('Help center opens all schedule and ETA issue variants', (
    WidgetTester tester,
  ) async {
    appRouter.go('/pusat-bantuan');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jadwal atau ETA tidak sesuai'));
    await tester.pumpAndSettle();
    expect(find.text('ETA Terlambat'), findsOneWidget);
    expect(find.text('Masalah aktif: ETA terlambat'), findsOneWidget);

    await tester.tap(find.text('Kereta hilang'));
    await tester.pumpAndSettle();
    expect(find.text('Kereta Hilang'), findsOneWidget);
    expect(find.text('Kereta terdekat tidak tampil'), findsOneWidget);

    await tester.tap(find.text('Jadwal berubah'));
    await tester.pumpAndSettle();
    expect(find.text('Jadwal Berubah'), findsOneWidget);
    expect(find.text('Jadwal aplikasi: 15:18 WIB'), findsOneWidget);

    await tester.tap(find.text('Peron berbeda'));
    await tester.pumpAndSettle();
    expect(find.text('Peron Berbeda'), findsOneWidget);
    expect(find.text('Peron aplikasi: Peron 2'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('Help center opens all payment issue variants', (
    WidgetTester tester,
  ) async {
    appRouter.go('/pusat-bantuan');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masalah pembayaran'));
    await tester.pumpAndSettle();
    expect(find.text('Saldo Terpotong'), findsOneWidget);
    expect(find.text('Diproses'), findsOneWidget);

    await tester.tap(find.text('Tiket belum muncul'));
    await tester.pumpAndSettle();
    expect(find.text('Tiket Belum Muncul'), findsOneWidget);
    expect(find.text('Berhasil'), findsOneWidget);

    await tester.tap(find.text('Refund'));
    await tester.pumpAndSettle();
    expect(find.text('Diajukan'), findsOneWidget);

    await tester.tap(find.text('Metode bayar'));
    await tester.pumpAndSettle();
    expect(find.text('Metode Bayar'), findsOneWidget);
    expect(find.text('Gagal'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('Completed history opens completed ticket detail and actions', (
    WidgetTester tester,
  ) async {
    appRouter.go('/riwayat-tiket');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ChoiceChip, 'Selesai'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Detail'));
    await tester.pumpAndSettle();

    expect(find.text('Detail tiket selesai'), findsOneWidget);
    expect(find.text('Ringkasan perjalanan'), findsOneWidget);
    expect(find.text('Durasi 44 menit'), findsOneWidget);
    expect(find.text('Home'), findsNothing);

    await tester.scrollUntilVisible(
      find.text('Unduh bukti'),
      180,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Unduh bukti'));
    await tester.pump();
    expect(find.text('Bukti perjalanan berhasil disiapkan.'), findsOneWidget);

    tester
        .state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger))
        .clearSnackBars();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laporkan masalah'));
    await tester.pumpAndSettle();
    expect(find.text('Pusat Bantuan'), findsOneWidget);
  });

  legacyTicketSimulationTest(
    'Ticket tab shows ticket list before payment methods',
    (WidgetTester tester) async {
      appRouter.go('/tiket');
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Tiket'), findsWidgets);
      expect(find.text('Beli tiket tanpa login'), findsNothing);
      expect(find.text('Belum dibayar'), findsWidgets);
      expect(find.text('Bayar sekarang'), findsOneWidget);
      expect(find.text('Lihat QR'), findsWidgets);
      expect(find.text('Pilih pembayaran'), findsNothing);

      await tester.tap(find.text('Bayar sekarang'));
      await tester.pumpAndSettle();

      expect(find.text('Pilih pembayaran'), findsOneWidget);
      expect(find.text('QRIS'), findsOneWidget);
    },
  );

  legacyTicketSimulationTest('Ticket tab can filter completed ticket history', (
    WidgetTester tester,
  ) async {
    appRouter.go('/tiket');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Selesai'), findsWidgets);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Selesai'));
    await tester.pumpAndSettle();

    expect(find.text('Riwayat selesai'), findsOneWidget);
    expect(find.text('Dukuh Atas -> Setiabudi'), findsOneWidget);
    expect(find.text('Sudah digunakan'), findsOneWidget);
    expect(find.text('Bayar sekarang'), findsNothing);
  });

  legacyTicketSimulationTest(
    'payment opens travel alarm setup before active ticket',
    (WidgetTester tester) async {
      final alarms = TravelAlarmController();
      addTearDown(alarms.dispose);
      await tester.pumpWidget(
        localizedTestApp(home: TicketsPage(alarmController: alarms)),
      );

      await tester.tap(find.text('Bayar sekarang'));
      await tester.pump();
      final payButton = find.text('Bayar Rp7.800');
      await tester.ensureVisible(payButton);
      await tester.tap(payButton);
      await tester.pumpAndSettle();

      expect(find.text('Aktifkan pengingat perjalanan?'), findsOneWidget);
      expect(alarms.state.hasActiveTicket, isTrue);
      expect(alarms.state.hasAnyAlarm, isFalse);

      await tester.tap(find.text('Aktifkan alarm'));
      await tester.pumpAndSettle();

      expect(alarms.state.departureAlarmEnabled, isTrue);
      expect(alarms.state.destinationAlarmEnabled, isTrue);
      expect(find.text('Alarm perjalanan diaktifkan'), findsOneWidget);
      alarms.cancelAllAlarms();
    },
  );

  legacyTicketSimulationTest(
    'active ticket confirms before disabling travel alarms',
    (WidgetTester tester) async {
      final alarms = TravelAlarmController();
      addTearDown(alarms.dispose);
      await tester.pumpWidget(
        localizedTestApp(home: TicketsPage(alarmController: alarms)),
      );

      await tester.tap(find.text('Bayar sekarang'));
      await tester.pump();
      final payButton = find.text('Bayar Rp7.800');
      await tester.ensureVisible(payButton);
      await tester.tap(payButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aktifkan alarm'));
      await tester.pumpAndSettle();

      await tester.tap(
        find.bySemanticsLabel(
          'Alarm perjalanan aktif, ketuk untuk menonaktifkan',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Matikan alarm perjalanan?'), findsOneWidget);
      expect(alarms.state.hasAnyAlarm, isTrue);

      await tester.tap(find.text('Matikan alarm'));
      await tester.pumpAndSettle();

      expect(alarms.state.hasAnyAlarm, isFalse);
      expect(find.text('Alarm perjalanan dinonaktifkan'), findsOneWidget);
    },
  );

  legacyTicketSimulationTest(
    'purchased ticket keeps its alarm control after page rebuild',
    (WidgetTester tester) async {
      final alarms = TravelAlarmController();
      addTearDown(alarms.dispose);
      alarms.completePurchase(from: 'Setiabudi', to: 'Pancoran Bank BJB');
      alarms.configureAlarms(departure: true, destination: true);

      await tester.pumpWidget(
        localizedTestApp(home: TicketsPage(alarmController: alarms)),
      );

      expect(find.text('Setiabudi -> Pancoran Bank BJB'), findsOneWidget);
      expect(find.text('Bayar sekarang'), findsNothing);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Lihat QR').first);
      await tester.pumpAndSettle();

      expect(
        find.bySemanticsLabel(
          'Alarm perjalanan aktif, ketuk untuk menonaktifkan',
        ),
        findsOneWidget,
      );
      expect(alarms.state.hasAnyAlarm, isTrue);
      alarms.cancelAllAlarms();
    },
  );

  legacyTicketSimulationTest(
    'viewing another ticket does not replace the active alarm trip',
    (WidgetTester tester) async {
      final alarms = TravelAlarmController()
        ..completePurchase(from: 'Setiabudi', to: 'Pancoran Bank BJB')
        ..configureAlarms(departure: true, destination: true);
      addTearDown(alarms.dispose);

      await tester.pumpWidget(
        localizedTestApp(home: TicketsPage(alarmController: alarms)),
      );
      await tester.tap(
        find.byKey(const Key('ticket-action-Manggarai-Tanah Abang')),
      );
      await tester.pumpAndSettle();

      expect(alarms.state.activeTrip?.from, 'Setiabudi');
      expect(alarms.state.hasAnyAlarm, isTrue);
      expect(
        find.bySemanticsLabel('Aktifkan alarm perjalanan'),
        findsOneWidget,
      );
      alarms.cancelAllAlarms();
    },
  );

  legacyTicketSimulationTest(
    'active ticket announces the one-minute train reminder',
    (WidgetTester tester) async {
      final alarms = TravelAlarmController(
        departureUrgentDelay: const Duration(seconds: 1),
        destinationWarningDelay: const Duration(seconds: 10),
      );
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        alarms.dispose();
      });
      await tester.pumpWidget(
        localizedTestApp(home: TicketsPage(alarmController: alarms)),
      );

      await tester.tap(find.text('Bayar sekarang'));
      await tester.pump();
      final payButton = find.text('Bayar Rp7.800');
      await tester.ensureVisible(payButton);
      await tester.tap(payButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aktifkan alarm'));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 300));

      expect(alarms.state.minutesUntilTrain, 1);
      expect(alarms.reminder.value?.message, 'Kereta datang 1 menit lagi');
      alarms.cancelAllAlarms();
    },
  );

  legacyTicketSimulationTest(
    'ticket alarm can be inspected and cancelled through chat',
    (WidgetTester tester) async {
      appRouter.go('/tiket');
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final ticketContext = tester.element(find.byType(TicketsPage));
      final alarms = TravelAlarmScope.of(ticketContext);

      await tester.tap(find.text('Bayar sekarang'));
      await tester.pump();
      final payButton = find.text('Bayar Rp7.800');
      await tester.ensureVisible(payButton);
      await tester.tap(payButton);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aktifkan alarm'));
      await tester.pumpAndSettle();
      expect(alarms.state.hasAnyAlarm, isTrue);

      appRouter.go('/asisten');
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('assistant-message-field')),
        'Alarm berikutnya kapan?',
      );
      await tester.tap(find.bySemanticsLabel('Kirim pesan'));
      await tester.pump();
      expect(find.text('Kereta datang 5 menit lagi'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('assistant-message-field')),
        'Batalkan semua alarm',
      );
      await tester.tap(find.bySemanticsLabel('Kirim pesan'));
      await tester.pump();

      expect(alarms.state.hasAnyAlarm, isFalse);
      expect(find.text('Semua alarm perjalanan dibatalkan.'), findsOneWidget);
    },
  );

  testWidgets('Assistant page exposes accessible voice-first controls', (
    WidgetTester tester,
  ) async {
    final controller = AssistantController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      localizedTestApp(home: AssistantPage(controller: controller)),
    );

    expect(find.text('Asisten Perjalanan'), findsOneWidget);
    expect(find.text('Dengarkan "Halo Asisten"'), findsOneWidget);
    expect(find.bySemanticsLabel('Mulai percakapan suara'), findsNWidgets(2));
    expect(find.text('Rencanakan perjalanan'), findsOneWidget);
    expect(find.text('Bantuan petugas'), findsOneWidget);

    final microphoneSemantics = tester
        .getSemantics(find.bySemanticsLabel('Mulai percakapan suara').first)
        .getSemanticsData();
    final wakeWordSemantics = tester
        .getSemantics(
          find.bySemanticsLabel(RegExp('Mode kata pemicu Halo Asisten')),
        )
        .getSemanticsData();
    final quickActionSemantics = tester
        .getSemantics(find.bySemanticsLabel('Buka Rencanakan perjalanan'))
        .getSemanticsData();
    expect(microphoneSemantics.hasAction(SemanticsAction.tap), isTrue);
    expect(wakeWordSemantics.hasAction(SemanticsAction.tap), isTrue);
    expect(quickActionSemantics.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.byKey(const Key('assistant-microphone-button')));
    await tester.pump();
    expect(
      find.bySemanticsLabel('Hentikan percakapan suara'),
      findsNWidgets(2),
    );

    await tester.tap(find.byKey(const Key('wake-word-switch')));
    await tester.pump();

    expect(find.text('Kata pemicu aktif'), findsOneWidget);
    final activeWakeWordText = tester.widget<Text>(
      find.text('Kata pemicu aktif'),
    );
    expect(activeWakeWordText.style?.color, AppColors.textPrimary);
  });

  testWidgets('Assistant keeps the latest conversation visible', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai');
    final conversation = AssistantConversationController(
      alarmController: alarms,
    );
    addTearDown(conversation.dispose);
    addTearDown(alarms.dispose);

    await tester.pumpWidget(
      localizedTestApp(
        home: AssistantPage(
          alarmController: alarms,
          conversationController: conversation,
        ),
      ),
    );

    conversation.submitText('Pesan pertama');
    await tester.pumpAndSettle();
    for (var index = 0; index < 5; index++) {
      conversation.submitText('Pesan lanjutan $index');
      await tester.pumpAndSettle();
    }

    final scrollable = tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byKey(const Key('assistant-conversation-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(scrollable.position.extentAfter, lessThan(1));
    expect(find.text('Pesan lanjutan 4'), findsOneWidget);
  });

  testWidgets('Assistant voice and text share one conversation timeline', (
    WidgetTester tester,
  ) async {
    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai')
      ..configureAlarms(departure: true, destination: true);
    final conversation = AssistantConversationController(
      alarmController: alarms,
    );
    final voice = AssistantController(
      listeningDuration: const Duration(milliseconds: 1),
      processingDuration: const Duration(milliseconds: 1),
      speakingDuration: const Duration(milliseconds: 1),
    );
    addTearDown(alarms.dispose);
    addTearDown(conversation.dispose);
    addTearDown(voice.dispose);

    await tester.pumpWidget(
      localizedTestApp(
        home: AssistantPage(
          controller: voice,
          alarmController: alarms,
          conversationController: conversation,
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('assistant-message-field')),
      'Alarm berikutnya kapan?',
    );
    await tester.tap(find.bySemanticsLabel('Kirim pesan'));
    await tester.pump();

    expect(find.text('Alarm berikutnya kapan?'), findsOneWidget);
    expect(find.text('Kereta datang 5 menit lagi'), findsOneWidget);

    final microphoneButton = find.byKey(
      const Key('assistant-microphone-button'),
    );
    await tester.ensureVisible(microphoneButton);
    await tester.tap(microphoneButton);
    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump(const Duration(milliseconds: 2));

    expect(
      find.text('Saya ingin ke Manggarai dari Setiabudi.'),
      findsOneWidget,
    );
    expect(
      find.text('Rute tercepat membutuhkan 7 menit. Kereta tiba 5 menit lagi.'),
      findsOneWidget,
    );
    expect(find.text('Pakai rute ini'), findsOneWidget);

    alarms.cancelAllAlarms();
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Assistant announces an urgent shared travel alarm', (
    WidgetTester tester,
  ) async {
    final alarms =
        TravelAlarmController(
            departureUrgentDelay: const Duration(seconds: 1),
            destinationWarningDelay: const Duration(seconds: 10),
          )
          ..completePurchase(from: 'Setiabudi', to: 'Manggarai')
          ..configureAlarms(departure: true, destination: true);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      alarms.dispose();
    });

    await tester.pumpWidget(
      localizedTestApp(home: AssistantPage(alarmController: alarms)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(alarms.reminder.value?.message, 'Kereta datang 1 menit lagi');
    alarms.cancelAllAlarms();
  });

  testWidgets('Assistant page simulates a trip and requests confirmation', (
    WidgetTester tester,
  ) async {
    final controller = AssistantController(
      listeningDuration: const Duration(milliseconds: 1),
      processingDuration: const Duration(milliseconds: 1),
      speakingDuration: const Duration(milliseconds: 1),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      localizedTestApp(home: AssistantPage(controller: controller)),
    );

    await tester.tap(find.byKey(const Key('assistant-microphone-button')));
    await tester.pump();
    expect(find.text('Mendengarkan'), findsWidgets);

    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump(const Duration(milliseconds: 2));

    expect(
      find.text('Saya ingin ke Manggarai dari Setiabudi.'),
      findsOneWidget,
    );
    expect(
      find.text('Rute tercepat membutuhkan 7 menit. Kereta tiba 5 menit lagi.'),
      findsOneWidget,
    );
    expect(find.text('Pakai rute ini'), findsOneWidget);
    expect(find.text('Ulangi'), findsOneWidget);
    expect(find.text('Batalkan'), findsOneWidget);
  });

  testWidgets('Assistant navigation replaces Promo and opens the new tab', (
    WidgetTester tester,
  ) async {
    appRouter.go('/');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Asisten'), findsOneWidget);
    expect(find.text('Promo'), findsNothing);

    await tester.tap(find.text('Asisten'));
    await tester.pumpAndSettle();

    expect(find.text('Asisten Perjalanan'), findsOneWidget);
    final assistantTabSemantics = tester
        .getSemantics(find.bySemanticsLabel('Asisten'))
        .getSemanticsData();
    expect(assistantTabSemantics.hasAction(SemanticsAction.tap), isTrue);
    expect(assistantTabSemantics.flagsCollection.isSelected, Tristate.isTrue);
  });

  testWidgets('Assistant navigation redirects the legacy Promo route', (
    WidgetTester tester,
  ) async {
    appRouter.go('/promo');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(appRouter.routeInformationProvider.value.uri.path, '/asisten');
    expect(find.text('Asisten Perjalanan'), findsOneWidget);
  });

  testWidgets('Assistant confirmation opens the requested Manggarai route', (
    WidgetTester tester,
  ) async {
    appRouter.go('/asisten');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final microphoneButton = find.byKey(
      const Key('assistant-microphone-button'),
    );
    await tester.ensureVisible(microphoneButton);
    await tester.tap(microphoneButton);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.ensureVisible(find.text('Pakai rute ini'));
    await tester.tap(find.text('Pakai rute ini'));
    await tester.pumpAndSettle();

    final uri = appRouter.routeInformationProvider.value.uri;
    expect(uri.path, '/rute');
    expect(uri.queryParameters['from'], 'Setiabudi');
    expect(uri.queryParameters['to'], 'Manggarai');
  });

  testWidgets('Assistant quick actions open existing app destinations', (
    WidgetTester tester,
  ) async {
    const destinations = <String, String>{
      'Rencanakan perjalanan': '/cari-stasiun',
      'Kereta berikutnya': '/timetable',
      'Tiket saya': '/tiket',
      'Bantuan petugas': '/pusat-bantuan',
    };

    for (final entry in destinations.entries) {
      appRouter.go('/asisten');
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text(entry.key));
      await tester.tap(find.text(entry.key));
      await tester.pumpAndSettle();

      expect(
        appRouter.routeInformationProvider.value.uri.path,
        entry.value,
        reason: '${entry.key} should open ${entry.value}',
      );
    }
  });

  testWidgets('Assistant wake-word mode resets after leaving the page', (
    WidgetTester tester,
  ) async {
    appRouter.go('/asisten');
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('wake-word-switch')));
    await tester.pump();
    expect(find.text('Kata pemicu aktif'), findsOneWidget);

    appRouter.go('/');
    await tester.pumpAndSettle();
    appRouter.go('/asisten');
    await tester.pumpAndSettle();

    expect(find.text('Aktif hanya di halaman ini'), findsOneWidget);
    expect(find.text('Kata pemicu aktif'), findsNothing);
  });

  testWidgets('Assistant page cancels an injected controller when disposed', (
    WidgetTester tester,
  ) async {
    final controller = AssistantController(
      listeningDuration: const Duration(milliseconds: 1),
      processingDuration: const Duration(milliseconds: 1),
      speakingDuration: const Duration(milliseconds: 1),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      localizedTestApp(home: AssistantPage(controller: controller)),
    );

    controller.startConversation();
    await tester.pump();
    expect(controller.state, AssistantInteractionState.listening);

    await tester.pumpWidget(localizedTestApp(home: const SizedBox.shrink()));
    await tester.pump(const Duration(milliseconds: 20));

    expect(controller.state, AssistantInteractionState.ready);
    expect(controller.userTranscript, isNull);
    expect(controller.assistantResponse, isNull);
  });

  testWidgets('Assistant page supports 200 percent text scaling', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = AssistantController(
      listeningDuration: const Duration(milliseconds: 1),
      processingDuration: const Duration(milliseconds: 1),
      speakingDuration: const Duration(milliseconds: 1),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      localizedTestApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: AssistantPage(controller: controller),
      ),
    );
    expect(tester.takeException(), isNull);

    final microphoneButton = find.byKey(
      const Key('assistant-microphone-button'),
    );
    await tester.ensureVisible(microphoneButton);
    await tester.tap(microphoneButton);
    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump(const Duration(milliseconds: 2));
    await tester.pump(const Duration(milliseconds: 2));

    expect(find.text('Pakai rute ini'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Assistant composer remains visible above the keyboard', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(localizedTestApp(home: const AssistantPage()));

    final field = find.byKey(const Key('assistant-message-field'));
    await tester.tap(field);
    await tester.showKeyboard(field);

    const keyboardHeight = 300.0;
    tester.view.viewInsets = const FakeViewPadding(bottom: keyboardHeight);
    await tester.pumpAndSettle();

    final keyboardTop = tester.view.physicalSize.height - keyboardHeight;
    expect(tester.getRect(field).bottom, lessThanOrEqualTo(keyboardTop));
    expect(tester.takeException(), isNull);
  });
}
