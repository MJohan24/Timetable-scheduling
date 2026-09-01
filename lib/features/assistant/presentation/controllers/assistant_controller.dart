import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/services/device_assistant_voice_service.dart';
import '../../domain/services/assistant_voice_service.dart';
import '../models/assistant_copy.dart';

enum AssistantInteractionState {
  ready,
  listening,
  processing,
  speaking,
  confirmation,
  error,
}

typedef AssistantTranscriptSubmitter = Future<String?> Function(String value);

enum _ListeningPurpose { none, wakeWord, destination }

class AssistantController extends ChangeNotifier {
  AssistantController({
    AssistantVoiceService? voiceService,
    AssistantTranscriptSubmitter? submitTranscript,
    this.restartDelay = const Duration(milliseconds: 250),
    AssistantCopy? copy,
    @Deprecated('Voice input no longer uses a simulated timer.')
    Duration? listeningDuration,
    @Deprecated('Voice input no longer uses a simulated timer.')
    Duration? processingDuration,
    @Deprecated('Voice output no longer uses a simulated timer.')
    Duration? speakingDuration,
  }) : _voice = voiceService ?? DeviceAssistantVoiceService(),
       _submitTranscript = submitTranscript,
       _copy = copy ?? AssistantCopy.indonesian();

  final AssistantVoiceService _voice;
  final Duration restartDelay;

  AssistantInteractionState state = AssistantInteractionState.ready;
  bool wakeWordEnabled = false;
  int completedExchangeId = 0;
  String? userTranscript;
  String? assistantResponse;

  AssistantCopy _copy;
  AssistantTranscriptSubmitter? _submitTranscript;
  _ListeningPurpose _listeningPurpose = _ListeningPurpose.none;
  String _localeId = 'id-ID';
  bool _initialized = false;
  bool _foreground = true;
  bool _disposed = false;
  int _sessionId = 0;
  Timer? _restartTimer;

  AssistantCopy get copy => _copy;

  void configure(AssistantCopy copy, {String? languageCode}) {
    _copy = copy;
    if (languageCode != null) _localeId = _localeFor(languageCode);
  }

  void setTranscriptSubmitter(AssistantTranscriptSubmitter value) {
    _submitTranscript = value;
  }

  void clearTranscriptSubmitter() {
    _submitTranscript = null;
  }

  Future<void> toggleWakeWord(bool value) async {
    if (wakeWordEnabled == value) return;
    wakeWordEnabled = value;
    _notifyIfMounted();
    if (!value) {
      _restartTimer?.cancel();
      if (_listeningPurpose == _ListeningPurpose.wakeWord) {
        _listeningPurpose = _ListeningPurpose.none;
        await _voice.cancelListening();
      }
      if (state == AssistantInteractionState.ready) _notifyIfMounted();
      return;
    }
    if (!await _ensureInitialized()) return;
    await _listenForWakeWord();
  }

  Future<void> startConversation() async {
    if (!await _ensureInitialized()) return;
    await _askForDestination();
  }

  Future<void> repeatResponse() async {
    final response = assistantResponse;
    if (response == null || response.trim().isEmpty) return;
    final sessionId = ++_sessionId;
    _listeningPurpose = _ListeningPurpose.none;
    await _voice.cancelListening();
    if (!_isCurrent(sessionId)) return;
    _setState(AssistantInteractionState.speaking);
    try {
      await _voice.speak(response, _localeId);
      if (!_isCurrent(sessionId)) return;
      _setState(AssistantInteractionState.confirmation);
      await _resumeWakeWordIfNeeded();
    } catch (error) {
      _handleVoiceError(error);
    }
  }

  Future<void> stopSpeaking() async {
    if (state != AssistantInteractionState.speaking) return;
    ++_sessionId;
    await _voice.stopSpeaking();
    if (_disposed) return;
    _setState(AssistantInteractionState.confirmation);
    await _resumeWakeWordIfNeeded();
  }

  Future<void> cancelConversation() async {
    ++_sessionId;
    _restartTimer?.cancel();
    _listeningPurpose = _ListeningPurpose.none;
    await _voice.cancelListening();
    await _voice.stopSpeaking();
    if (_disposed) return;
    userTranscript = null;
    assistantResponse = null;
    _setState(AssistantInteractionState.ready);
    await _resumeWakeWordIfNeeded();
  }

  void showError() {
    ++_sessionId;
    _restartTimer?.cancel();
    assistantResponse = copy.unknownDestination;
    _setState(AssistantInteractionState.error);
  }

  Future<void> pauseForLifecycle() async {
    _foreground = false;
    ++_sessionId;
    _restartTimer?.cancel();
    _listeningPurpose = _ListeningPurpose.none;
    await _voice.cancelListening();
    await _voice.stopSpeaking();
    if (!_disposed) _setState(AssistantInteractionState.ready);
  }

  Future<void> resumeFromLifecycle() async {
    _foreground = true;
    if (wakeWordEnabled && await _ensureInitialized()) {
      await _listenForWakeWord();
    }
  }

  Future<bool> _ensureInitialized() async {
    if (_initialized) return true;
    try {
      _initialized = await _voice.initialize(
        onError: _handleVoiceError,
        onDone: _handleListeningDone,
      );
    } catch (error) {
      _handleVoiceError(error);
      return false;
    }
    if (!_initialized) {
      wakeWordEnabled = false;
      assistantResponse = copy.voiceUnavailable;
      _setState(AssistantInteractionState.error);
      return false;
    }
    return true;
  }

  Future<void> _listenForWakeWord() async {
    if (_disposed || !_foreground || !wakeWordEnabled) return;
    _restartTimer?.cancel();
    _listeningPurpose = _ListeningPurpose.wakeWord;
    try {
      await _voice.listen(localeId: _localeId, onResult: _handleVoiceResult);
    } catch (error) {
      _handleVoiceError(error);
    }
  }

  Future<void> _askForDestination() async {
    final sessionId = ++_sessionId;
    _restartTimer?.cancel();
    _listeningPurpose = _ListeningPurpose.none;
    await _voice.stopListening();
    await _voice.stopSpeaking();
    if (!_isCurrent(sessionId)) return;
    userTranscript = null;
    assistantResponse = null;
    _setState(AssistantInteractionState.speaking);
    try {
      await _voice.speak(copy.voiceDestinationPrompt, _localeId);
      if (!_isCurrent(sessionId) || !_foreground) return;
      _listeningPurpose = _ListeningPurpose.destination;
      _setState(AssistantInteractionState.listening);
      await _voice.listen(localeId: _localeId, onResult: _handleVoiceResult);
    } catch (error) {
      _handleVoiceError(error);
    }
  }

  void _handleVoiceResult(AssistantVoiceResult result) {
    if (_disposed || !_foreground) return;
    final text = result.text.trim();
    if (text.isEmpty) return;
    if (_listeningPurpose == _ListeningPurpose.wakeWord) {
      if (_normalize(text).contains('halo asisten')) {
        _listeningPurpose = _ListeningPurpose.none;
        unawaited(_askForDestination());
      }
      return;
    }
    if (_listeningPurpose == _ListeningPurpose.destination && result.isFinal) {
      _listeningPurpose = _ListeningPurpose.none;
      unawaited(_submitDestination(text));
    }
  }

  Future<void> _submitDestination(String text) async {
    final sessionId = ++_sessionId;
    await _voice.stopListening();
    if (!_isCurrent(sessionId)) return;
    userTranscript = text;
    assistantResponse = null;
    _setState(AssistantInteractionState.processing);
    try {
      final response = (await _submitTranscript?.call(text))?.trim();
      if (!_isCurrent(sessionId)) return;
      if (response == null || response.isEmpty) {
        _setState(AssistantInteractionState.confirmation);
        await _resumeWakeWordIfNeeded();
        return;
      }
      assistantResponse = response;
      completedExchangeId += 1;
      _setState(AssistantInteractionState.speaking);
      await _voice.speak(response, _localeId);
      if (!_isCurrent(sessionId)) return;
      _setState(AssistantInteractionState.confirmation);
      await _resumeWakeWordIfNeeded();
    } catch (error) {
      _handleVoiceError(error);
    }
  }

  void _handleListeningDone() {
    if (_disposed || !_foreground) return;
    final purpose = _listeningPurpose;
    _listeningPurpose = _ListeningPurpose.none;
    if (purpose == _ListeningPurpose.wakeWord && wakeWordEnabled) {
      _scheduleWakeWordRestart();
    } else if (purpose == _ListeningPurpose.destination) {
      assistantResponse = copy.voiceNoSpeech;
      _setState(AssistantInteractionState.error);
      if (wakeWordEnabled) _scheduleWakeWordRestart();
    }
  }

  void _scheduleWakeWordRestart() {
    _restartTimer?.cancel();
    _restartTimer = Timer(restartDelay, () {
      if (!_disposed && _foreground && wakeWordEnabled) {
        unawaited(_listenForWakeWord());
      }
    });
  }

  Future<void> _resumeWakeWordIfNeeded() async {
    if (wakeWordEnabled && _foreground) await _listenForWakeWord();
  }

  void _handleVoiceError(Object error) {
    if (_disposed) return;
    ++_sessionId;
    _restartTimer?.cancel();
    _listeningPurpose = _ListeningPurpose.none;
    assistantResponse = copy.voiceUnavailable;
    _setState(AssistantInteractionState.error);
  }

  bool _isCurrent(int sessionId) =>
      !_disposed && _foreground && sessionId == _sessionId;

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  String _localeFor(String languageCode) => switch (languageCode) {
    'en' => 'en-US',
    'ar' => 'ar-SA',
    'zh' => 'zh-CN',
    _ => 'id-ID',
  };

  void _setState(AssistantInteractionState value) {
    state = value;
    _notifyIfMounted();
  }

  void _notifyIfMounted() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _restartTimer?.cancel();
    _listeningPurpose = _ListeningPurpose.none;
    unawaited(_voice.dispose());
    super.dispose();
  }
}
