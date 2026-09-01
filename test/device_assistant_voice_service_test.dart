import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/assistant/data/services/device_assistant_voice_service.dart';
import 'package:timetable/features/assistant/domain/services/assistant_voice_service.dart';

class _FakeRecognizer implements AssistantSpeechRecognizerClient {
  AssistantVoiceResultCallback? onResult;
  AssistantVoiceErrorCallback? onError;
  VoidCallback? onDone;
  bool initialized = false;
  String? localeId;
  int stopCalls = 0;
  int cancelCalls = 0;

  @override
  Future<bool> initialize({
    required AssistantVoiceErrorCallback handleError,
    required VoidCallback handleDone,
  }) async {
    initialized = true;
    onError = handleError;
    onDone = handleDone;
    return true;
  }

  @override
  Future<void> listen({
    required String localeId,
    required AssistantVoiceResultCallback handleResult,
  }) async {
    this.localeId = localeId;
    onResult = handleResult;
  }

  @override
  Future<void> stop() async => stopCalls += 1;

  @override
  Future<void> cancel() async => cancelCalls += 1;
}

class _FakeSynthesizer implements AssistantSpeechSynthesizerClient {
  String? language;
  String? text;
  int stopCalls = 0;

  @override
  Future<void> setLanguage(String localeId) async => language = localeId;

  @override
  Future<void> speak(String value) async => text = value;

  @override
  Future<void> stop() async => stopCalls += 1;
}

void main() {
  test(
    'device voice service forwards recognition and TTS operations',
    () async {
      final recognizer = _FakeRecognizer();
      final synthesizer = _FakeSynthesizer();
      final service = DeviceAssistantVoiceService(
        recognizer: recognizer,
        synthesizer: synthesizer,
      );
      final results = <AssistantVoiceResult>[];
      Object? error;
      var doneCalls = 0;

      expect(
        await service.initialize(
          onError: (value) => error = value,
          onDone: () => doneCalls += 1,
        ),
        isTrue,
      );
      await service.listen(localeId: 'id-ID', onResult: results.add);
      recognizer.onResult!(const AssistantVoiceResult('Halo Asisten', true));
      recognizer.onError!(StateError('microphone'));
      recognizer.onDone!();
      await service.speak(
        'Halo, kamu mau melakukan perjalanan ke mana?',
        'id-ID',
      );
      await service.stopListening();
      await service.cancelListening();
      await service.stopSpeaking();

      expect(results.single.text, 'Halo Asisten');
      expect(error, isA<StateError>());
      expect(doneCalls, 1);
      expect(recognizer.localeId, 'id-ID');
      expect(recognizer.stopCalls, 1);
      expect(recognizer.cancelCalls, 1);
      expect(synthesizer.language, 'id-ID');
      expect(synthesizer.text, 'Halo, kamu mau melakukan perjalanan ke mana?');
      expect(synthesizer.stopCalls, 1);
    },
  );
}
