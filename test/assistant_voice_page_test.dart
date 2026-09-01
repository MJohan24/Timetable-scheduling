import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/assistant/domain/repositories/assistant_chat_repository.dart';
import 'package:timetable/features/assistant/domain/services/assistant_voice_service.dart';
import 'package:timetable/features/assistant/presentation/controllers/assistant_controller.dart';
import 'package:timetable/features/assistant/presentation/controllers/assistant_conversation_controller.dart';
import 'package:timetable/features/assistant/presentation/pages/assistant_page.dart';
import 'package:timetable/features/travel_alarm/presentation/controllers/travel_alarm_controller.dart';

import 'helpers/localized_test_app.dart';

class _Voice implements AssistantVoiceService {
  AssistantVoiceResultCallback? onResult;
  final spoken = <String>[];

  @override
  Future<bool> initialize({
    required AssistantVoiceErrorCallback onError,
    required void Function() onDone,
  }) async => true;

  @override
  Future<void> listen({
    required String localeId,
    required AssistantVoiceResultCallback onResult,
  }) async => this.onResult = onResult;

  @override
  Future<void> speak(String text, String localeId) async => spoken.add(text);

  @override
  Future<void> cancelListening() async {}

  @override
  Future<void> stopListening() async {}

  @override
  Future<void> stopSpeaking() async {}

  @override
  Future<void> dispose() async {}

  void emit(String text, {bool isFinal = false}) =>
      onResult?.call(AssistantVoiceResult(text, isFinal));
}

class _Repository implements AssistantChatRepository {
  String? message;
  String? lang;

  @override
  Future<AssistantChatAnswer> ask(
    String value, {
    List<AssistantChatTurn> history = const [],
    String? lang,
  }) async {
    message = value;
    this.lang = lang;
    return const AssistantChatAnswer(
      reply: 'Naik KRL tujuan Bogor dari Peron 2.',
    );
  }
}

Future<void> _drain(WidgetTester tester) async {
  for (var index = 0; index < 8; index++) {
    await tester.pump();
  }
}

void main() {
  testWidgets('voice destination uses backend timeline and speaks its reply', (
    tester,
  ) async {
    final voice = _Voice();
    final repository = _Repository();
    final alarms = TravelAlarmController();
    final conversation = AssistantConversationController(
      alarmController: alarms,
      chatRepository: repository,
    );
    final controller = AssistantController(
      voiceService: voice,
      restartDelay: Duration.zero,
    );
    addTearDown(controller.dispose);
    addTearDown(conversation.dispose);
    addTearDown(alarms.dispose);

    await tester.pumpWidget(
      localizedTestApp(
        home: AssistantPage(
          controller: controller,
          alarmController: alarms,
          conversationController: conversation,
        ),
      ),
    );
    await controller.toggleWakeWord(true);
    voice.emit('Halo Asisten');
    await _drain(tester);
    expect(
      voice.spoken,
      contains('Halo, kamu mau melakukan perjalanan ke mana?'),
    );

    voice.emit('Saya mau ke Bogor', isFinal: true);
    await _drain(tester);

    expect(repository.message, 'Saya mau ke Bogor');
    expect(repository.lang, 'id');
    expect(voice.spoken, contains('Naik KRL tujuan Bogor dari Peron 2.'));
    expect(find.text('Saya mau ke Bogor'), findsOneWidget);
    expect(find.text('Naik KRL tujuan Bogor dari Peron 2.'), findsOneWidget);
  });

  testWidgets('voice prompt follows the active application locale', (
    tester,
  ) async {
    final voice = _Voice();
    final controller = AssistantController(voiceService: voice);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      localizedTestApp(
        locale: const Locale('en'),
        home: AssistantPage(controller: controller),
      ),
    );

    await controller.startConversation();
    await _drain(tester);

    expect(voice.spoken, contains('Hello, where would you like to travel?'));
  });
}
