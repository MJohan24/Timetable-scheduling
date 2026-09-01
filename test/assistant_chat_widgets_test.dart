import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/assistant/domain/entities/assistant_conversation_item.dart';
import 'package:timetable/features/assistant/presentation/widgets/assistant_composer.dart';
import 'package:timetable/features/assistant/presentation/widgets/assistant_conversation_timeline.dart';
import 'package:timetable/features/travel_alarm/domain/entities/travel_alarm_state.dart';

import 'helpers/localized_test_app.dart';

void main() {
  testWidgets('composer submits trimmed text and retains voice action', (
    WidgetTester tester,
  ) async {
    String? submitted;
    var microphoneTaps = 0;
    await tester.pumpWidget(
      localizedTestApp(
        home: Scaffold(
          body: AssistantComposer(
            onSubmit: (value) => submitted = value,
            onMicrophoneTap: () => microphoneTaps++,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.bySemanticsLabel('Ketik pesan untuk Asisten'),
      '  Alarm berikutnya kapan?  ',
    );
    await tester.tap(find.bySemanticsLabel('Kirim pesan'));

    expect(submitted, 'Alarm berikutnya kapan?');
    expect(find.text('Alarm berikutnya kapan?'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Mulai percakapan suara'));
    expect(microphoneTaps, 1);
  });

  testWidgets('composer ignores whitespace-only messages', (
    WidgetTester tester,
  ) async {
    var submissions = 0;
    await tester.pumpWidget(
      localizedTestApp(
        home: Scaffold(
          body: AssistantComposer(
            onSubmit: (_) => submissions++,
            onMicrophoneTap: () {},
          ),
        ),
      ),
    );

    await tester.enterText(
      find.bySemanticsLabel('Ketik pesan untuk Asisten'),
      '   ',
    );
    await tester.testTextInput.receiveAction(TextInputAction.send);

    expect(submissions, 0);
  });

  testWidgets('conversation timeline renders messages and alarm status', (
    WidgetTester tester,
  ) async {
    var viewTicketTaps = 0;
    var cancelTaps = 0;
    final items = [
      const AssistantConversationItem(
        id: 0,
        author: AssistantMessageAuthor.user,
        kind: AssistantConversationItemKind.message,
        text: 'Alarm berikutnya kapan?',
      ),
      const AssistantConversationItem(
        id: 1,
        author: AssistantMessageAuthor.assistant,
        kind: AssistantConversationItemKind.alarmStatus,
        text: 'Kereta datang 5 menit lagi',
      ),
    ];
    const alarmState = TravelAlarmState(
      activeTrip: ActiveTrip(from: 'Setiabudi', to: 'Manggarai'),
      departureAlarmEnabled: true,
      destinationAlarmEnabled: true,
    );

    await tester.pumpWidget(
      localizedTestApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AssistantConversationTimeline(
              items: items,
              alarmState: alarmState,
              onViewTicket: () => viewTicketTaps++,
              onCancelAlarm: () => cancelTaps++,
              onFindTrip: () {},
              onConfirmRoute: (from, to) {},
              onRepeatRoute: () {},
              onCancelRoute: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Anda'), findsOneWidget);
    expect(find.text('Asisten'), findsOneWidget);
    expect(find.text('Alarm berikutnya kapan?'), findsOneWidget);
    expect(find.text('Kereta datang 5 menit lagi'), findsOneWidget);
    expect(find.text('Setiabudi ke Manggarai'), findsOneWidget);
    expect(find.text('Kereta datang aktif'), findsOneWidget);
    expect(find.text('Turun atau transit aktif'), findsOneWidget);

    await tester.tap(find.text('Lihat tiket'));
    await tester.tap(find.text('Batalkan alarm'));
    expect(viewTicketTaps, 1);
    expect(cancelTaps, 1);

    final latestSemantics = tester
        .getSemantics(
          find.bySemanticsLabel('Asisten, Kereta datang 5 menit lagi'),
        )
        .getSemanticsData();
    expect(latestSemantics.flagsCollection.isLiveRegion, isTrue);
  });

  testWidgets('no-ticket item offers an accessible recovery action', (
    WidgetTester tester,
  ) async {
    var findTripTaps = 0;
    await tester.pumpWidget(
      localizedTestApp(
        home: Scaffold(
          body: AssistantConversationTimeline(
            items: const [
              AssistantConversationItem(
                id: 0,
                author: AssistantMessageAuthor.assistant,
                kind: AssistantConversationItemKind.noActiveTicket,
                text: 'Belum ada tiket aktif',
              ),
            ],
            alarmState: const TravelAlarmState(),
            onViewTicket: () {},
            onCancelAlarm: () {},
            onFindTrip: () => findTripTaps++,
            onConfirmRoute: (from, to) {},
            onRepeatRoute: () {},
            onCancelRoute: () {},
          ),
        ),
      ),
    );

    expect(find.text('Belum ada tiket aktif'), findsOneWidget);
    final action = tester
        .getSemantics(find.bySemanticsLabel('Cari perjalanan'))
        .getSemanticsData();
    expect(action.hasAction(SemanticsAction.tap), isTrue);

    await tester.tap(find.text('Cari perjalanan'));
    expect(findTripTaps, 1);
  });
}
