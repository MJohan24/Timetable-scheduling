import 'package:flutter/foundation.dart';

import '../../../travel_alarm/domain/entities/travel_alarm_state.dart';

enum AssistantMessageAuthor { user, assistant }

enum AssistantConversationItemKind {
  message,
  alarmStatus,
  noActiveTicket,
  routeSuggestion,
}

@immutable
class AssistantConversationItem {
  const AssistantConversationItem({
    required this.id,
    required this.author,
    required this.kind,
    required this.text,
    this.alarmSnapshot,
    this.routeFrom,
    this.routeTo,
  });

  final int id;
  final AssistantMessageAuthor author;
  final AssistantConversationItemKind kind;
  final String text;
  final TravelAlarmState? alarmSnapshot;
  final String? routeFrom;
  final String? routeTo;
}
