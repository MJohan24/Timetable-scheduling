enum AssistantChatRole { user, assistant }

class AssistantChatTurn {
  const AssistantChatTurn({required this.role, required this.text});

  final AssistantChatRole role;
  final String text;
}

class AssistantChatAnswer {
  const AssistantChatAnswer({
    required this.reply,
    this.routeFrom,
    this.routeTo,
  });

  final String reply;
  final String? routeFrom;
  final String? routeTo;
}

abstract interface class AssistantChatRepository {
  Future<AssistantChatAnswer> ask(
    String message, {
    List<AssistantChatTurn> history = const [],
    String? lang,
  });
}
