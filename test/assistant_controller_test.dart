import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/assistant/domain/services/assistant_voice_service.dart';
import 'package:timetable/features/assistant/presentation/controllers/assistant_controller.dart';

class _FakeVoiceService implements AssistantVoiceService {
  bool available = true;
  AssistantVoiceErrorCallback? onError;
  void Function()? onDone;
  AssistantVoiceResultCallback? onResult;
  final actions = <String>[];
  int listenCount = 0;

  @override
  Future<bool> initialize({
    required AssistantVoiceErrorCallback onError,
    required void Function() onDone,
  }) async {
    actions.add('initialize');
    this.onError = onError;
    this.onDone = onDone;
    return available;
  }

  @override
  Future<void> listen({
    required String localeId,
    required AssistantVoiceResultCallback onResult,
  }) async {
    actions.add('listen:$localeId');
    listenCount += 1;
    this.onResult = onResult;
  }

  @override
  Future<void> stopListening() async => actions.add('stop-listening');

  @override
  Future<void> cancelListening() async => actions.add('cancel-listening');

  @override
  Future<void> speak(String text, String localeId) async {
    actions.add('speak:$text:$localeId');
  }

  @override
  Future<void> stopSpeaking() async => actions.add('stop-speaking');

  @override
  Future<void> dispose() async => actions.add('dispose');

  void emit(String text, {bool isFinal = false}) {
    onResult?.call(AssistantVoiceResult(text, isFinal));
  }
}

Future<void> _drain() async {
  for (var index = 0; index < 8; index++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  test('wake word asks for destination and submits the final answer', () async {
    final voice = _FakeVoiceService();
    String? submitted;
    final controller = AssistantController(
      voiceService: voice,
      restartDelay: Duration.zero,
      submitTranscript: (value) async {
        submitted = value;
        return 'Rute ke Bogor sudah ditemukan.';
      },
    );
    addTearDown(controller.dispose);

    await controller.toggleWakeWord(true);
    expect(controller.wakeWordEnabled, isTrue);
    expect(voice.listenCount, 1);

    voice.emit('suara lain');
    await _drain();
    expect(voice.actions.where((value) => value.startsWith('speak:')), isEmpty);

    voice.emit('Halo, ASISTEN!');
    await _drain();

    expect(
      voice.actions,
      containsAllInOrder([
        'stop-listening',
        'speak:Halo, kamu mau melakukan perjalanan ke mana?:id-ID',
        'listen:id-ID',
      ]),
    );
    expect(controller.state, AssistantInteractionState.listening);

    voice.emit('Saya ingin ke Bogor', isFinal: true);
    await _drain();

    expect(submitted, 'Saya ingin ke Bogor');
    expect(controller.userTranscript, 'Saya ingin ke Bogor');
    expect(controller.assistantResponse, 'Rute ke Bogor sudah ditemukan.');
    expect(
      voice.actions,
      contains('speak:Rute ke Bogor sudah ditemukan.:id-ID'),
    );
    expect(controller.state, AssistantInteractionState.confirmation);
    expect(voice.listenCount, 3);
  });

  test('manual microphone asks immediately without a wake phrase', () async {
    final voice = _FakeVoiceService();
    final controller = AssistantController(
      voiceService: voice,
      restartDelay: Duration.zero,
    );
    addTearDown(controller.dispose);

    await controller.startConversation();

    expect(
      voice.actions,
      containsAllInOrder([
        'initialize',
        'stop-listening',
        'speak:Halo, kamu mau melakukan perjalanan ke mana?:id-ID',
        'listen:id-ID',
      ]),
    );
    expect(controller.state, AssistantInteractionState.listening);
  });

  test('recognizer completion restarts passive wake listening', () async {
    final voice = _FakeVoiceService();
    final controller = AssistantController(
      voiceService: voice,
      restartDelay: Duration.zero,
    );
    addTearDown(controller.dispose);

    await controller.toggleWakeWord(true);
    voice.onDone?.call();
    await _drain();

    expect(voice.listenCount, 2);
    expect(controller.state, AssistantInteractionState.ready);
  });

  test('missing destination resumes wake listening', () async {
    final voice = _FakeVoiceService();
    final controller = AssistantController(
      voiceService: voice,
      restartDelay: Duration.zero,
    );
    addTearDown(controller.dispose);

    await controller.toggleWakeWord(true);
    voice.emit('Halo Asisten');
    await _drain();
    expect(controller.state, AssistantInteractionState.listening);
    final listenCountBeforeTimeout = voice.listenCount;

    voice.onDone?.call();
    await _drain();

    expect(controller.state, AssistantInteractionState.error);
    expect(voice.listenCount, listenCountBeforeTimeout + 1);
  });

  test('voice unavailability creates a recoverable error state', () async {
    final voice = _FakeVoiceService()..available = false;
    final controller = AssistantController(
      voiceService: voice,
      restartDelay: Duration.zero,
    );
    addTearDown(controller.dispose);

    await controller.toggleWakeWord(true);

    expect(controller.state, AssistantInteractionState.error);
    expect(controller.wakeWordEnabled, isFalse);
    expect(controller.assistantResponse, isNotEmpty);
  });

  test(
    'lifecycle pause stops audio and resume restores wake listening',
    () async {
      final voice = _FakeVoiceService();
      final controller = AssistantController(
        voiceService: voice,
        restartDelay: Duration.zero,
      );
      addTearDown(controller.dispose);
      await controller.toggleWakeWord(true);

      await controller.pauseForLifecycle();
      final listenCountWhilePaused = voice.listenCount;
      voice.onDone?.call();
      await _drain();
      expect(voice.listenCount, listenCountWhilePaused);

      await controller.resumeFromLifecycle();
      expect(voice.listenCount, listenCountWhilePaused + 1);
      expect(
        voice.actions,
        containsAllInOrder(['cancel-listening', 'stop-speaking']),
      );
    },
  );

  test('stopping spoken response returns to confirmation', () async {
    final voice = _FakeVoiceService();
    final response = Completer<String?>();
    final controller = AssistantController(
      voiceService: voice,
      restartDelay: Duration.zero,
      submitTranscript: (_) => response.future,
    );
    addTearDown(controller.dispose);
    await controller.startConversation();
    voice.emit('Ke Tangerang', isFinal: true);
    await _drain();
    response.complete('Silakan menuju peron.');
    await _drain();

    await controller.stopSpeaking();

    expect(voice.actions, contains('stop-speaking'));
    expect(controller.state, AssistantInteractionState.confirmation);
  });
}
