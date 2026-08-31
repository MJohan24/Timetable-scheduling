import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../travel_alarm/domain/entities/travel_alarm_state.dart';
import '../../../travel_alarm/presentation/controllers/travel_alarm_controller.dart';
import '../../domain/entities/assistant_conversation_item.dart';
import '../../domain/repositories/assistant_chat_repository.dart';
import '../models/assistant_copy.dart';

class AssistantConversationController extends ChangeNotifier {
  AssistantConversationController({
    required this.alarmController,
    this.chatRepository,
    AssistantCopy? copy,
  }) : _copy = copy ?? AssistantCopy.indonesian();

  final TravelAlarmController alarmController;
  final AssistantChatRepository? chatRepository;
  final List<AssistantConversationItem> _items = [];
  int _nextId = 0;
  bool _isSending = false;
  AssistantCopy _copy;

  void configure(AssistantCopy copy) => _copy = copy;

  AssistantCopy get copy => _copy;

  UnmodifiableListView<AssistantConversationItem> get items =>
      UnmodifiableListView(_items);
  bool get isSending => _isSending;

  Future<void> submitText(String rawText, {String? lang}) async {
    final text = rawText.trim();
    if (text.isEmpty) return;

    _append(
      author: AssistantMessageAuthor.user,
      kind: AssistantConversationItemKind.message,
      text: text,
    );
    final handled = _handleCommand(text.toLowerCase());
    if (!handled && chatRepository != null) {
      _isSending = true;
      notifyListeners();
      try {
        final answer = await chatRepository!.ask(
          text,
          history: _historyBeforeCurrent(),
          lang: lang,
        );
        _append(
          author: AssistantMessageAuthor.assistant,
          kind: AssistantConversationItemKind.message,
          text: answer.reply,
          routeFrom: answer.routeFrom,
          routeTo: answer.routeTo,
        );
      } on Exception {
        _appendAssistant(copy.unavailable);
      } finally {
        _isSending = false;
      }
      notifyListeners();
      return;
    }
    if (!handled) {
      _appendAssistant(copy.unknownCommand);
    }
    notifyListeners();
  }

  void addVoiceExchange({
    required String transcript,
    required String response,
  }) {
    final normalized = transcript.trim().toLowerCase();
    _append(
      author: AssistantMessageAuthor.user,
      kind: AssistantConversationItemKind.message,
      text: transcript,
    );
    if (_isAlarmCommand(normalized)) {
      _handleCommand(normalized);
    } else {
      _append(
        author: AssistantMessageAuthor.assistant,
        kind: AssistantConversationItemKind.routeSuggestion,
        text: response,
      );
    }
    notifyListeners();
  }

  bool _handleCommand(String normalized) {
    if (_requiresTicket(normalized) && !alarmController.state.hasActiveTicket) {
      _append(
        author: AssistantMessageAuthor.assistant,
        kind: AssistantConversationItemKind.noActiveTicket,
        text: copy.noActiveTicket,
      );
      return true;
    }

    if (normalized.contains('batalkan semua alarm')) {
      if (!alarmController.state.hasAnyAlarm) {
        _appendAssistant(copy.noActiveAlarm);
        return true;
      }
      alarmController.cancelAllAlarms();
      _appendAssistant(copy.allAlarmsCancelled);
      return true;
    }

    if (normalized.contains('matikan alarm tujuan')) {
      if (!alarmController.state.destinationAlarmEnabled) {
        _appendAlarmStatus(copy.destinationAlarmAlreadyOff);
        return true;
      }
      alarmController.disableDestinationAlarm();
      _appendAlarmStatus(copy.destinationAlarmDisabled);
      return true;
    }

    if (normalized.contains('aktifkan semua alarm')) {
      alarmController.configureAlarms(departure: true, destination: true);
      _appendAlarmStatus(copy.allAlarmsActive);
      return true;
    }

    if (normalized.contains('alarm berikutnya')) {
      _appendAlarmStatus(alarmController.nextAlarmDescription);
      return true;
    }

    if (normalized.contains('datang') || normalized.contains('berapa menit')) {
      _appendAssistant(
        copy.trainArrivesIn(alarmController.state.minutesUntilTrain),
      );
      return true;
    }
    return false;
  }

  bool _requiresTicket(String text) {
    return text.contains('alarm') ||
        text.contains('kereta') ||
        text.contains('berapa menit');
  }

  bool _isAlarmCommand(String text) {
    return text.contains('alarm') ||
        text.contains('berapa menit') ||
        text.contains('kereta saya datang');
  }

  void _appendAssistant(String text) {
    _append(
      author: AssistantMessageAuthor.assistant,
      kind: AssistantConversationItemKind.message,
      text: text,
    );
  }

  List<AssistantChatTurn> _historyBeforeCurrent() {
    final previous = _items
        .take(_items.length - 1)
        .where(
          (item) =>
              item.kind == AssistantConversationItemKind.message ||
              item.kind == AssistantConversationItemKind.routeSuggestion,
        )
        .toList();
    final start = previous.length > 6 ? previous.length - 6 : 0;
    return previous
        .sublist(start)
        .map(
          (item) => AssistantChatTurn(
            role: item.author == AssistantMessageAuthor.user
                ? AssistantChatRole.user
                : AssistantChatRole.assistant,
            text: item.text,
          ),
        )
        .toList(growable: false);
  }

  void _appendAlarmStatus(String text) {
    _append(
      author: AssistantMessageAuthor.assistant,
      kind: AssistantConversationItemKind.alarmStatus,
      text: text,
      alarmSnapshot: alarmController.state,
    );
  }

  void _append({
    required AssistantMessageAuthor author,
    required AssistantConversationItemKind kind,
    required String text,
    TravelAlarmState? alarmSnapshot,
    String? routeFrom,
    String? routeTo,
  }) {
    _items.add(
      AssistantConversationItem(
        id: _nextId++,
        author: author,
        kind: kind,
        text: text,
        alarmSnapshot: alarmSnapshot,
        routeFrom: routeFrom,
        routeTo: routeTo,
      ),
    );
  }
}
