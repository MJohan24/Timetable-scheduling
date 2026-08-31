import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/config/api_config.dart';
import '../../../../core/network/api_timeouts.dart';
import '../../domain/entities/ticket.dart';
import '../models/ticket_model.dart';

class TicketRemoteException implements Exception {
  const TicketRemoteException(
    this.code,
    this.message, {
    this.statusCode,
    this.isNetwork = false,
  });

  final String code;
  final String message;
  final int? statusCode;
  final bool isNetwork;

  bool get isUnauthorized =>
      statusCode == 401 ||
      code == 'INVALID_ACCESS_TOKEN' ||
      code == 'AUTHENTICATION_REQUIRED';
}

class TicketRemoteDataSource {
  TicketRemoteDataSource({
    http.Client? client,
    Duration requestTimeout = ApiTimeouts.request,
  }) : _client = client ?? http.Client(),
       _timeout = requestTimeout;

  final http.Client _client;
  final Duration _timeout;

  Future<Ticket> orderTicket({
    required String origin,
    required String destination,
    required DateTime travelDate,
    int passengerCount = 1,
    String? contactEmail,
    String? accessToken,
  }) async {
    final body = <String, dynamic>{
      'origin': origin,
      'destination': destination,
      'travelDate': travelDate.toUtc().toIso8601String(),
      'passengerCount': passengerCount,
    };
    if (contactEmail != null) body['contactEmail'] = contactEmail;
    final response = await _request(
      'POST',
      '/tickets/order',
      accessToken: accessToken,
      body: body,
    );
    return TicketModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<TicketPage> listTickets({
    String? accessToken,
    String? contactEmail,
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, String>{'page': '$page', 'limit': '$limit'};
    if (contactEmail != null) query['contactEmail'] = contactEmail;
    final response = await _request(
      'GET',
      '/tickets',
      accessToken: accessToken,
      queryParameters: query,
    );
    return TicketPageModel.fromResponse(response);
  }

  Future<TicketPayment> createCheckout({
    required String ticketId,
    String? contactEmail,
    String? accessToken,
  }) async {
    final body = <String, dynamic>{'ticketId': ticketId};
    if (contactEmail != null) body['contactEmail'] = contactEmail;
    final response = await _request(
      'POST',
      '/payments/checkout',
      accessToken: accessToken,
      body: body,
    );
    return TicketPaymentModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  Future<PaymentSnapshot> getPaymentStatus({
    required String ticketId,
    String? contactEmail,
    String? accessToken,
  }) async {
    final query = <String, String>{};
    if (contactEmail != null) query['contactEmail'] = contactEmail;
    final response = await _request(
      'GET',
      '/payments/status/$ticketId',
      accessToken: accessToken,
      queryParameters: query,
    );
    return PaymentSnapshotModel.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    String? accessToken,
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}$path',
      ).replace(queryParameters: queryParameters);
      final headers = {
        'Content-Type': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };
      final response = method == 'GET'
          ? await _client.get(uri, headers: headers).timeout(_timeout)
          : await _client
                .post(uri, headers: headers, body: jsonEncode(body))
                .timeout(_timeout);
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode < 200 ||
          response.statusCode >= 300 ||
          decoded['success'] != true) {
        final error = decoded['error'] as Map<String, dynamic>?;
        throw TicketRemoteException(
          error?['code'] as String? ?? 'REQUEST_FAILED',
          error?['message'] as String? ?? 'Ticket request failed',
          statusCode: response.statusCode,
        );
      }
      return decoded;
    } on TicketRemoteException {
      rethrow;
    } on TimeoutException catch (_) {
      throw const TicketRemoteException(
        'NETWORK_ERROR',
        'Connection timed out',
        isNetwork: true,
      );
    } on SocketException catch (_) {
      throw const TicketRemoteException(
        'NETWORK_ERROR',
        'No network connection',
        isNetwork: true,
      );
    } on http.ClientException catch (_) {
      throw const TicketRemoteException(
        'NETWORK_ERROR',
        'Cannot reach server',
        isNetwork: true,
      );
    } on FormatException catch (_) {
      throw const TicketRemoteException(
        'INVALID_RESPONSE',
        'Invalid server response',
      );
    } on TypeError catch (_) {
      throw const TicketRemoteException(
        'INVALID_RESPONSE',
        'Invalid server response',
      );
    }
  }
}
