import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/core/localization/app_locale.dart';
import 'package:timetable/core/localization/locale_controller.dart';
import 'package:timetable/core/localization/locale_provider.dart';
import 'package:timetable/features/auth/domain/entities/account_user.dart';
import 'package:timetable/features/auth/domain/entities/auth_session.dart';
import 'package:timetable/features/auth/domain/repositories/auth_repository.dart';
import 'package:timetable/features/auth/presentation/controllers/auth_controller.dart';
import 'package:timetable/features/auth/presentation/pages/auth_page.dart';
import 'package:timetable/features/auth/presentation/widgets/auth_scope.dart';
import 'package:timetable/features/profile/presentation/pages/profile_page.dart';
import 'package:timetable/l10n/app_localizations.dart';

class _AuthRepository implements AuthRepository {
  _AuthRepository({this.user, this.offline = false});

  final AccountUser? user;
  final bool offline;
  int logoutCount = 0;

  @override
  AccountUser? get currentUser => user;

  @override
  Future<AuthBootstrapResult> bootstrap() async =>
      AuthBootstrapResult(user: user, offline: offline);

  @override
  Future<AccountUser> login({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<AccountUser> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) => throw UnimplementedError();

  @override
  Future<void> logout() async => logoutCount++;

  @override
  Future<AccountUser> updateProfile({
    String? name,
    String? phone,
    String? language,
    bool? accessibilityEnabled,
    bool? notificationsEnabled,
  }) => throw UnimplementedError();
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  _AuthRepository? repository,
  double textScale = 1,
}) async {
  final controller = AuthController(repository ?? _AuthRepository());
  final localeController = LocaleController(
    initialLocale: AppLocale.indonesian,
  );
  addTearDown(controller.dispose);
  addTearDown(localeController.dispose);
  await controller.bootstrap();
  await tester.pumpWidget(
    LocaleScope(
      notifier: localeController,
      child: AuthScope(
        controller: controller,
        child: MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('guest account explicitly keeps ticket purchase available', (
    tester,
  ) async {
    await _pump(tester, const ProfilePage());

    expect(find.text('Masuk atau Buat Akun'), findsOneWidget);
    expect(find.textContaining('beli tiket'), findsOneWidget);
    expect(find.byKey(const ValueKey('account-identity-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('account-menu-section')), findsOneWidget);
    expect(find.byKey(const ValueKey('account-logout')), findsNothing);
    expect(find.text('Pemandu Tunanetra'), findsOneWidget);
    expect(find.text('Aksesibilitas'), findsNothing);
  });

  testWidgets('Blind Guide uses a separate card with an inactive switch', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(tester, const ProfilePage());

    final menu = find.byKey(const ValueKey('account-menu-section'));
    final guide = find.byKey(const ValueKey('blind-guide-card'));
    final guideSwitch = find.byKey(const ValueKey('blind-guide-switch'));

    expect(menu, findsOneWidget);
    expect(guide, findsOneWidget);
    expect(
      tester.getTopLeft(guide).dy,
      greaterThan(tester.getBottomLeft(menu).dy),
    );
    expect(tester.widget<Switch>(guideSwitch).value, isFalse);
  });

  testWidgets('signed-in account exposes identity and existing actions', (
    tester,
  ) async {
    await _pump(
      tester,
      const ProfilePage(),
      repository: _AuthRepository(
        offline: true,
        user: const AccountUser(
          id: 'user-1',
          email: 'riyadh@example.com',
          role: 'USER',
          language: 'id',
          accessibilityEnabled: false,
          notificationsEnabled: true,
          name: 'Muhammad Riyadh',
        ),
      ),
    );

    expect(find.text('MR'), findsOneWidget);
    expect(find.text('Muhammad Riyadh'), findsOneWidget);
    expect(find.text('riyadh@example.com'), findsOneWidget);
    expect(find.text('Akun tersimpan • sedang offline'), findsWidgets);
    expect(find.text('Edit profil'), findsOneWidget);
    expect(find.text('Riwayat tiket akun'), findsWidgets);
    expect(find.byKey(const ValueKey('account-logout')), findsOneWidget);
  });

  testWidgets('registration requires a password confirmation field', (
    tester,
  ) async {
    await _pump(tester, const AuthPage(register: true));

    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('Nomor telepon (opsional)'), findsOneWidget);
    expect(find.text('Ulangi kata sandi'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('account layout handles long identity and larger text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _pump(
      tester,
      const ProfilePage(),
      textScale: 1.3,
      repository: _AuthRepository(
        user: const AccountUser(
          id: 'user-long',
          email: 'muhammad.riyadh.haqqi.mujtaba@example.com',
          role: 'USER',
          language: 'id',
          accessibilityEnabled: true,
          notificationsEnabled: true,
          name: 'Muhammad Riyadh Haqqi Mujtaba dengan Nama Sangat Panjang',
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Akun'), findsWidgets);
    expect(find.byKey(const ValueKey('account-menu-section')), findsOneWidget);
  });
}
