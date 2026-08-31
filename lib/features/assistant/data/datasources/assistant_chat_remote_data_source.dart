import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_timeouts.dart';
import '../../domain/repositories/assistant_chat_repository.dart';

class AssistantChatRemoteDataSource {
  AssistantChatRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> ask(
    String message, {
    List<AssistantChatTurn> history = const [],
  }) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConfig.baseUrl}/assistant/chat'),
          headers: const {'content-type': 'application/json'},
          body: jsonEncode({
            'message': message,
            if (history.isNotEmpty)
              'history': history
                  .map((turn) => {'role': turn.role.name, 'text': turn.text})
                  .toList(growable: false),
          }),
        )
        .timeout(ApiTimeouts.request);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || body['success'] != true) {
      final error = body['error'];
      final code = error is Map<String, dynamic> ? error['code'] : null;
      throw AssistantChatException(code?.toString() ?? 'AI_UNAVAILABLE');
    }
    final data = body['data'];
    final reply = data is Map<String, dynamic> ? data['reply'] : null;
    if (reply is! String || reply.trim().isEmpty) {
      throw const AssistantChatException('AI_EMPTY_RESPONSE');
    }
    return reply.trim();
  }
}

class AssistantChatException implements Exception {
  const AssistantChatException(this.code);

  final String code;
}
