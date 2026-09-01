import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/profile/presentation/models/support_chat_topic.dart';
import 'package:timetable/features/profile/presentation/pages/help_chat_page.dart';
import 'package:timetable/features/profile/presentation/pages/support_chat_conversation_page.dart';

import 'helpers/localized_test_app.dart';

const _samples = <SupportChatTopic, String>{
  SupportChatTopic.ticket:
      'Kode tiket: TKT-20260827-001\n'
      'Rute: Manggarai – Tanah Abang\n'
      'Tanggal perjalanan: 27 Agustus 2026\n'
      'Status: Aktif',
  SupportChatTopic.schedule:
      'Stasiun asal: Manggarai\n'
      'Tujuan: Jakarta Kota\n'
      'Nomor kereta: KA 1184\n'
      'Keberangkatan: 10.25 WIB\n'
      'Peron: 3',
  SupportChatTopic.payment:
      'ID transaksi: TRX-20260827-001\n'
      'Metode: QRIS\n'
      'Nominal: Rp7.800\n'
      'Waktu: 27 Agustus 2026, 10.20 WIB\n'
      'Status: Berhasil',
};

const _summaries = <SupportChatTopic, String>{
  SupportChatTopic.ticket: 'Mode tamu, ID tiket, dan rute terakhir',
  SupportChatTopic.schedule:
      'Rute terakhir, stasiun asal-tujuan, dan waktu perjalanan',
  SupportChatTopic.payment:
      'Status transaksi terakhir, kode tiket, dan waktu pembayaran',
};

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('chat setup shows data categories without concrete values', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(localizedTestApp(home: const HelpChatPage()));

    for (final entry in _summaries.entries) {
      final label = switch (entry.key) {
        SupportChatTopic.ticket => 'Tiket',
        SupportChatTopic.schedule => 'Jadwal',
        SupportChatTopic.payment => 'Pembayaran',
      };
      if (entry.key != SupportChatTopic.ticket) {
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        await tester.pump();
      }

      expect(find.text(entry.value), findsOneWidget);
      expect(find.text(_samples[entry.key]!), findsNothing);
    }
  });

  for (final entry in _samples.entries) {
    testWidgets('${entry.key.name} conversation receives the shared sample', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        localizedTestApp(home: SupportChatConversationPage(topic: entry.key)),
      );

      expect(find.text('Data yang diterima:\n${entry.value}'), findsOneWidget);
    });
  }
}
