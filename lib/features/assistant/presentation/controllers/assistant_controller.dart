import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/assistant_copy.dart';

enum AssistantInteractionState {
  ready,
  listening,
  processing,
  speaking,
  confirmation,
  error,
}

class AssistantController extends ChangeNotifier {
  AssistantController({
    this.listeningDuration = const Duration(milliseconds: 850),
    this.processingDuration = const Duration(milliseconds: 700),
    this.speakingDuration = const Duration(milliseconds: 650),
    AssistantCopy? copy,
  }) : _copy = copy ?? AssistantCopy.indonesian();

  final Duration listeningDuration;
  final Duration processingDuration;
  final Duration speakingDuration;

  static const String demoOrigin = 'Setiabudi';
  static const String demoDestination = 'Manggarai';

  AssistantInteractionState state = AssistantInteractionState.ready;
  bool wakeWordEnabled = false;
  int completedExchangeId = 0;
  String? userTranscript;
  String? assistantResponse;
  AssistantCopy _copy;

  Timer? _timer;

  void configure(AssistantCopy copy) => _copy = copy;

  AssistantCopy get copy => _copy;

  void toggleWakeWord(bool value) {
    if (wakeWordEnabled == value) return;
    wakeWordEnabled = value;
    notifyListeners();
  }

  void startConversation() {
    _timer?.cancel();
    userTranscript = null;
    assistantResponse = null;
    _setState(AssistantInteractionState.listening);
    _timer = Timer(listeningDuration, _finishListening);
  }

  void repeatResponse() {
    if (assistantResponse == null) return;
    _timer?.cancel();
    _setState(AssistantInteractionState.speaking);
    _timer = Timer(speakingDuration, _finishSpeaking);
  }

  void stopSpeaking() {
    if (state != AssistantInteractionState.speaking) return;
    _timer?.cancel();
    _timer = null;
    _setState(AssistantInteractionState.confirmation);
  }

  void cancelConversation() {
    _timer?.cancel();
    _timer = null;
    userTranscript = null;
    assistantResponse = null;
    _setState(AssistantInteractionState.ready);
  }

  void showError() {
    _timer?.cancel();
    _timer = null;
    assistantResponse = copy.unknownDestination;
    _setState(AssistantInteractionState.error);
  }

  void _finishListening() {
    userTranscript = copy.demoTranscript(demoDestination, demoOrigin);
    _setState(AssistantInteractionState.processing);
    _timer = Timer(processingDuration, _finishProcessing);
  }

  void _finishProcessing() {
    assistantResponse = copy.demoResponse;
    completedExchangeId++;
    _setState(AssistantInteractionState.speaking);
    _timer = Timer(speakingDuration, _finishSpeaking);
  }

  void _finishSpeaking() {
    _timer = null;
    _setState(AssistantInteractionState.confirmation);
  }

  void _setState(AssistantInteractionState value) {
    state = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
