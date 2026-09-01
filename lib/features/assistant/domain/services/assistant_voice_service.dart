import 'package:flutter/foundation.dart';

@immutable
class AssistantVoiceResult {
  const AssistantVoiceResult(this.text, this.isFinal);

  final String text;
  final bool isFinal;
}

typedef AssistantVoiceResultCallback =
    void Function(AssistantVoiceResult value);
typedef AssistantVoiceErrorCallback = void Function(Object error);

abstract interface class AssistantVoiceService {
  Future<bool> initialize({
    required AssistantVoiceErrorCallback onError,
    required VoidCallback onDone,
  });

  Future<void> listen({
    required String localeId,
    required AssistantVoiceResultCallback onResult,
  });

  Future<void> stopListening();
  Future<void> cancelListening();
  Future<void> speak(String text, String localeId);
  Future<void> stopSpeaking();
  Future<void> dispose();
}
