import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:timetable/features/auth/domain/entities/account_user.dart';
import 'package:timetable/features/auth/domain/entities/auth_session.dart';
import 'package:timetable/features/auth/domain/repositories/auth_repository.dart';
import 'package:timetable/features/auth/presentation/controllers/auth_controller.dart';

const _user = AccountUser(
  id: 'user-1',
  email: 'user@example.com',
  name: 'Riyadh',
  role: 'REGISTERED',
  language: 'id',
  accessibilityEnabled: false,
  notificationsEnabled: true,
);

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.bootstrapResult = const AuthBootstrapResult()});

  AuthBootstrapResult bootstrapResult;
  bool failBootstrapUnexpectedly = false;
  bool failLogin = false;
  AccountUser? _currentUser;

  @override
  AccountUser? get currentUser => _currentUser;

  @override
  Future<AuthBootstrapResult> bootstrap() async {
    if (failBootstrapUnexpectedly) {
      throw StateError('secure storage unavailable');
    }
    _currentUser = bootstrapResult.user;
    return bootstrapResult;
  }

  @override
  Future<AccountUser> login({
    required String email,
    required String password,
  }) async {
    if (failLogin) {
      throw const AuthRemoteException('INVALID_CREDENTIALS', 'invalid');
    }
    return _currentUser = _user;
  }

  @override
  Future<AccountUser> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async => _currentUser = _user;

  @override
  Future<void> logout() async => _currentUser = null;

  @override
  Future<AccountUser> updateProfile({
    String? name,
    String? phone,
    String? language,
    bool? accessibilityEnabled,
    bool? notificationsEnabled,
  }) async => _currentUser = _user;
}

void main() {
  test(
    'bootstrap keeps cached account visible when network is offline',
    () async {
      final repository = _FakeAuthRepository(
        bootstrapResult: const AuthBootstrapResult(user: _user, offline: true),
      );
      final controller = AuthController(repository);

      await controller.bootstrap();

      expect(controller.status, AuthStatus.offlineAuthenticated);
      expect(controller.user, _user);
    },
  );

  test('bootstrap failure falls back to guest mode', () async {
    final repository = _FakeAuthRepository()..failBootstrapUnexpectedly = true;
    final controller = AuthController(repository);

    await controller.bootstrap();

    expect(controller.status, AuthStatus.guest);
    expect(controller.user, isNull);
    expect(controller.errorCode, 'AUTH_RESTORE_FAILED');
  });

  test('invalid login returns to guest with a stable error code', () async {
    final repository = _FakeAuthRepository()..failLogin = true;
    final controller = AuthController(repository);

    final success = await controller.login(
      email: 'bad@example.com',
      password: 'wrong-pass',
    );

    expect(success, isFalse);
    expect(controller.status, AuthStatus.guest);
    expect(controller.errorCode, 'INVALID_CREDENTIALS');
  });

  test(
    'explicit logout returns an authenticated account to guest mode',
    () async {
      final repository = _FakeAuthRepository(
        bootstrapResult: const AuthBootstrapResult(user: _user),
      );
      final controller = AuthController(repository);
      await controller.bootstrap();

      await controller.logout();

      expect(controller.status, AuthStatus.guest);
      expect(controller.user, isNull);
    },
  );
}
