import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/core/network/access_token_provider.dart';
import 'package:timetable/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:timetable/features/auth/data/datasources/auth_secure_store.dart';
import 'package:timetable/features/auth/data/models/account_user_model.dart';
import 'package:timetable/features/auth/data/models/auth_session_model.dart';
import 'package:timetable/features/auth/data/repositories/auth_repository_impl.dart';

const _user = AccountUserModel(
  id: 'user-1',
  email: 'user@example.com',
  name: 'Riyadh',
  role: 'REGISTERED',
  language: 'id',
  accessibilityEnabled: false,
  notificationsEnabled: true,
);

const _firstSession = AuthSessionModel(
  user: _user,
  accessToken: 'access-first',
  refreshToken: 'refresh-first',
  accessTokenExpiresIn: 900,
);

const _secondSession = AuthSessionModel(
  user: _user,
  accessToken: 'access-second',
  refreshToken: 'refresh-second',
  accessTokenExpiresIn: 900,
);

class _FakeRemote extends AuthRemoteDataSource {
  final Queue<AuthSessionModel> sessions = Queue<AuthSessionModel>();
  int refreshCalls = 0;

  @override
  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async => sessions.removeFirst();

  @override
  Future<AuthSessionModel> refresh(String refreshToken) async {
    refreshCalls += 1;
    return sessions.removeFirst();
  }
}

class _MemoryStore implements AuthSessionStore {
  String? refreshToken;
  String? pendingRevocation;
  AccountUserModel? user;

  @override
  Future<void> clearPendingRevocation() async => pendingRevocation = null;

  @override
  Future<void> clearSession() async {
    refreshToken = null;
    user = null;
  }

  @override
  Future<String?> readPendingRevocation() async => pendingRevocation;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<AccountUserModel?> readUser() async => user;

  @override
  Future<void> savePendingRevocation(String token) async {
    pendingRevocation = token;
  }

  @override
  Future<void> saveSession(AuthSessionModel session) async {
    refreshToken = session.refreshToken;
    user = session.user as AccountUserModel;
  }

  @override
  Future<void> saveUser(AccountUserModel value) async => user = value;
}

void main() {
  test('repository implements the internal access token boundary', () {
    final repository = AuthRepositoryImpl(
      remote: _FakeRemote(),
      store: _MemoryStore(),
    );

    expect(repository, isA<AccessTokenProvider>());
  });

  test('provider reuses current token and can force rotation', () async {
    final remote = _FakeRemote()
      ..sessions.addAll([_firstSession, _secondSession]);
    final repository = AuthRepositoryImpl(
      remote: remote,
      store: _MemoryStore(),
    );
    await repository.login(
      email: 'user@example.com',
      password: 'password123',
    );

    expect(await repository.getAccessToken(), 'access-first');
    expect(remote.refreshCalls, 0);
    expect(
      await repository.getAccessToken(forceRefresh: true),
      'access-second',
    );
    expect(remote.refreshCalls, 1);
  });

  test('guest provider returns no access token', () async {
    final repository = AuthRepositoryImpl(
      remote: _FakeRemote(),
      store: _MemoryStore(),
    );

    expect(await repository.getAccessToken(), isNull);
  });
}
