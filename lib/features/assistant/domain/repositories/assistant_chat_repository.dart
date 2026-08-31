enum AssistantChatRole { user, assistant }

class AssistantChatTurn {
  const AssistantChatTurn({required this.role, required this.text});

  final AssistantChatRole role;
  final String text;
}

abstract interface class AssistantChatRepository {
  Future<String> ask(
    String message, {
    List<AssistantChatTurn> history = const [],
  });
}
