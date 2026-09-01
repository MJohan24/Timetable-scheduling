import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../domain/services/assistant_voice_service.dart';

abstract interface class AssistantSpeechRecognizerClient {
  Future<bool> initialize({
    required AssistantVoiceErrorCallback handleError,
    required VoidCallback handleDone,
  });

  Future<void> listen({
    required String localeId,
    required AssistantVoiceResultCallback handleResult,
  });

  Future<void> stop();
  Future<void> cancel();
}

abstract interface class AssistantSpeechSynthesizerClient {
  Future<void> setLanguage(String localeId);
  Future<void> speak(String value);
  Future<void> stop();
}

class SpeechToTextRecognizerClient implements AssistantSpeechRecognizerClient {
  SpeechToTextRecognizerClient({SpeechToText? speech})
    : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;

  @override
  Future<bool> initialize({
    required AssistantVoiceErrorCallback handleError,
    required VoidCallback handleDone,
  }) {
    return _speech.initialize(
      onError: handleError,
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') handleDone();
      },
      options: <SpeechConfigOption>[SpeechToText.androidNoBluetooth],
    );
  }

  @override
  Future<void> listen({
    required String localeId,
    required AssistantVoiceResultCallback handleResult,
  }) async {
    await _speech.listen(
      onResult: (SpeechRecognitionResult result) => handleResult(
        AssistantVoiceResult(result.recognizedWords, result.finalResult),
      ),
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.confirmation,
      ),
    );
  }

  @override
  Future<void> stop() => _speech.stop();

  @override
  Future<void> cancel() => _speech.cancel();
}

class FlutterTtsSynthesizerClient implements AssistantSpeechSynthesizerClient {
  FlutterTtsSynthesizerClient({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  @override
  Future<void> setLanguage(String localeId) async {
    await _tts.setLanguage(localeId);
    await _tts.setSpeechRate(0.45);
    await _tts.awaitSpeakCompletion(true);
  }

  @override
  Future<void> speak(String value) async {
    await _tts.speak(value);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}

class DeviceAssistantVoiceService implements AssistantVoiceService {
  DeviceAssistantVoiceService({
    AssistantSpeechRecognizerClient? recognizer,
    AssistantSpeechSynthesizerClient? synthesizer,
  }) : _recognizer = recognizer ?? SpeechToTextRecognizerClient(),
       _synthesizer = synthesizer ?? FlutterTtsSynthesizerClient();

  final AssistantSpeechRecognizerClient _recognizer;
  final AssistantSpeechSynthesizerClient _synthesizer;

  @override
  Future<bool> initialize({
    required AssistantVoiceErrorCallback onError,
    required VoidCallback onDone,
  }) => _recognizer.initialize(handleError: onError, handleDone: onDone);

  @override
  Future<void> listen({
    required String localeId,
    required AssistantVoiceResultCallback onResult,
  }) => _recognizer.listen(localeId: localeId, handleResult: onResult);

  @override
  Future<void> stopListening() => _recognizer.stop();

  @override
  Future<void> cancelListening() => _recognizer.cancel();

  @override
  Future<void> speak(String text, String localeId) async {
    await _synthesizer.setLanguage(localeId);
    await _synthesizer.speak(text);
  }

  @override
  Future<void> stopSpeaking() => _synthesizer.stop();

  @override
  Future<void> dispose() async {
    await _recognizer.cancel();
    await _synthesizer.stop();
  }
}
