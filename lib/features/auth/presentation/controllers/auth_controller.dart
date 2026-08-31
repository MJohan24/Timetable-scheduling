import 'package:flutter/foundation.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../domain/entities/account_user.dart';
import '../../domain/repositories/auth_repository.dart';

enum AuthStatus {
  restoring,
  guest,
  authenticated,
  offlineAuthenticated,
  submitting,
}

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;
  AuthStatus _status = AuthStatus.restoring;
  AccountUser? _user;
  String? _errorCode;

  AuthStatus get status => _status;
  AccountUser? get user => _user;
  String? get errorCode => _errorCode;
  bool get isAuthenticated => _user != null;
  bool get isBusy =>
      _status == AuthStatus.restoring || _status == AuthStatus.submitting;

  Future<void> bootstrap() async {
    try {
      final result = await _repository.bootstrap();
      _user = result.user;
      _status = result.isAuthenticated
          ? (result.offline
                ? AuthStatus.offlineAuthenticated
                : AuthStatus.authenticated)
          : AuthStatus.guest;
    } on Object {
      _user = null;
      _errorCode = 'AUTH_RESTORE_FAILED';
      _status = AuthStatus.guest;
    }
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) =>
      _submit(() => _repository.login(email: email, password: password));

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) => _submit(
    () => _repository.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    ),
  );

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _errorCode = null;
    _status = AuthStatus.guest;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? language,
    bool? accessibilityEnabled,
    bool? notificationsEnabled,
  }) => _submit(
    () => _repository.updateProfile(
      name: name,
      phone: phone,
      language: language,
      accessibilityEnabled: accessibilityEnabled,
      notificationsEnabled: notificationsEnabled,
    ),
    preserveUser: true,
  );

  void clearError() {
    _errorCode = null;
    notifyListeners();
  }

  Future<bool> _submit(
    Future<AccountUser> Function() action, {
    bool preserveUser = false,
  }) async {
    final previousUser = _user;
    _status = AuthStatus.submitting;
    _errorCode = null;
    notifyListeners();
    try {
      _user = await action();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on AuthRemoteException catch (error) {
      _user = preserveUser ? previousUser : null;
      _errorCode = error.code;
      _status = _user == null
          ? AuthStatus.guest
          : AuthStatus.offlineAuthenticated;
      notifyListeners();
      return false;
    }
  }
}
