import '../../../../core/network/access_token_provider.dart';
import '../../domain/entities/account_user.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_secure_store.dart';
import '../models/account_user_model.dart';
import '../models/auth_session_model.dart';

class AuthRepositoryImpl implements AuthRepository, AccessTokenProvider {
  AuthRepositoryImpl({AuthRemoteDataSource? remote, AuthSessionStore? store})
    : _remote = remote ?? AuthRemoteDataSource(),
      _store = store ?? AuthSecureStore();

  final AuthRemoteDataSource _remote;
  final AuthSessionStore _store;
  AuthSessionModel? _session;
  AccountUserModel? _cachedUser;
  Future<AuthSessionModel>? _refreshing;

  @override
  AccountUser? get currentUser => _session?.user ?? _cachedUser;

  @override
  Future<String?> getAccessToken({bool forceRefresh = false}) async {
    if (!forceRefresh && _session != null) return _session!.accessToken;
    final refreshToken = await _store.readRefreshToken();
    if (refreshToken == null) return null;
    return (await _refreshOnce()).accessToken;
  }

  @override
  Future<AuthBootstrapResult> bootstrap() async {
    await _retryPendingRevocation();
    final token = await _store.readRefreshToken();
    if (token == null) return const AuthBootstrapResult();
    try {
      final session = await _remote.refresh(token);
      await _accept(session);
      return AuthBootstrapResult(user: session.user);
    } on AuthRemoteException catch (error) {
      if (error.isUnauthorized) {
        await _store.clearSession();
        return const AuthBootstrapResult();
      }
      _cachedUser = await _store.readUser();
      return AuthBootstrapResult(
        user: _cachedUser,
        offline: _cachedUser != null,
      );
    }
  }

  @override
  Future<AccountUser> login({
    required String email,
    required String password,
  }) async {
    final session = await _remote.login(email: email, password: password);
    await _accept(session);
    return session.user;
  }

  @override
  Future<AccountUser> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final session = await _remote.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    await _accept(session);
    return session.user;
  }

  @override
  Future<void> logout() async {
    final token = await _store.readRefreshToken();
    _session = null;
    _cachedUser = null;
    await _store.clearSession();
    if (token == null) return;
    try {
      await _remote.logout(token);
    } on AuthRemoteException {
      await _store.savePendingRevocation(token);
    }
  }

  @override
  Future<AccountUser> updateProfile({
    String? name,
    String? phone,
    String? language,
    bool? accessibilityEnabled,
    bool? notificationsEnabled,
  }) async {
    final changes = Map<String, dynamic>.fromEntries(
      <MapEntry<String, dynamic>>[
        MapEntry('name', name),
        MapEntry('phone', phone),
        MapEntry('language', language),
        MapEntry('accessibilityEnabled', accessibilityEnabled),
        MapEntry('notificationsEnabled', notificationsEnabled),
      ].where((entry) => entry.value != null),
    );
    final user = await _authorized(
      (token) => _remote.updateProfile(token, changes),
    );
    _cachedUser = user;
    await _store.saveUser(user);
    return user;
  }

  Future<T> _authorized<T>(Future<T> Function(String token) request) async {
    var session = _session;
    session ??= await _refreshOnce();
    try {
      return await request(session.accessToken);
    } on AuthRemoteException catch (error) {
      if (!error.isUnauthorized) rethrow;
      return request((await _refreshOnce()).accessToken);
    }
  }

  Future<AuthSessionModel> _refreshOnce() async {
    final active = _refreshing;
    if (active != null) return active;
    final future = _rotate();
    _refreshing = future;
    try {
      return await future;
    } finally {
      if (identical(_refreshing, future)) _refreshing = null;
    }
  }

  Future<AuthSessionModel> _rotate() async {
    final token = await _store.readRefreshToken();
    if (token == null) {
      throw const AuthRemoteException('UNAUTHORIZED', 'Please sign in again');
    }
    try {
      final session = await _remote.refresh(token);
      await _accept(session);
      return session;
    } on AuthRemoteException catch (error) {
      if (error.isUnauthorized) {
        _session = null;
        _cachedUser = null;
        await _store.clearSession();
      }
      rethrow;
    }
  }

  Future<void> _accept(AuthSessionModel session) async {
    _session = session;
    _cachedUser = session.user as AccountUserModel;
    await _store.saveSession(session);
  }

  Future<void> _retryPendingRevocation() async {
    final token = await _store.readPendingRevocation();
    if (token == null) return;
    try {
      await _remote.logout(token);
      await _store.clearPendingRevocation();
    } on AuthRemoteException {
      // Logout stays local-first; a later app launch retries revocation.
    }
  }
}
