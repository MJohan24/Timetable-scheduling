import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_timeouts.dart';

class VisionGuideResult {
  const VisionGuideResult({
    required this.spokenText,
    required this.hazardLevel,
  });

  final String spokenText;
  final String hazardLevel;
}

class VisionGuideRemoteDataSource {
  VisionGuideRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  void close() => _client.close();

  Future<VisionGuideResult?> analyzeJpeg(
    Uint8List bytes, {
    required String languageTag,
  }) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConfig.baseUrl}/assistant/vision'),
          headers: {
            'Content-Type': 'image/jpeg',
            'Accept-Language': languageTag,
          },
          body: bytes,
        )
        .timeout(ApiTimeouts.request);
    if (response.statusCode != 200) return null;
    final decoded = jsonDecode(response.body);
    final data = decoded is Map<String, dynamic> ? decoded['data'] : null;
    if (data is! Map<String, dynamic>) return null;
    final spokenText = data['spokenText'];
    final hazardLevel = data['hazardLevel'];
    if (spokenText is! String ||
        spokenText.trim().isEmpty ||
        hazardLevel is! String) {
      return null;
    }
    return VisionGuideResult(
      spokenText: spokenText.trim(),
      hazardLevel: hazardLevel,
    );
  }
}
