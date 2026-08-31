import '../../domain/repositories/assistant_chat_repository.dart';
import '../datasources/assistant_chat_remote_data_source.dart';

class AssistantChatRepositoryImpl implements AssistantChatRepository {
  AssistantChatRepositoryImpl({AssistantChatRemoteDataSource? remote})
    : _remote = remote ?? AssistantChatRemoteDataSource();

  final AssistantChatRemoteDataSource _remote;

  @override
  Future<String> ask(
    String message, {
    List<AssistantChatTurn> history = const [],
  }) =>
      _remote.ask(message, history: history);
}
