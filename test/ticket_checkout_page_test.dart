import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/core/theme/app_colors.dart';
import 'package:timetable/features/auth/domain/entities/account_user.dart';
import 'package:timetable/features/auth/domain/entities/auth_session.dart';
import 'package:timetable/features/auth/domain/repositories/auth_repository.dart';
import 'package:timetable/features/auth/presentation/controllers/auth_controller.dart';
import 'package:timetable/features/auth/presentation/widgets/auth_scope.dart';
import 'package:timetable/features/tickets/domain/entities/device_ticket_checkout.dart';
import 'package:timetable/features/tickets/domain/entities/ticket.dart';
import 'package:timetable/features/tickets/domain/repositories/device_ticket_store.dart';
import 'package:timetable/features/tickets/domain/repositories/ticket_repository.dart';
import 'package:timetable/features/tickets/presentation/controllers/ticket_controller.dart';
import 'package:timetable/features/tickets/presentation/pages/tickets_page.dart';
import 'package:timetable/l10n/app_localizations.dart';

void main() {
  testWidgets('page initially combines paid device email history', (
    tester,
  ) async {
    final repository = _Repository(
      guestTickets: [
        _ticket(
          id: 'guest-ticket',
          status: TicketStatus.active,
          contactEmail: 'guest@example.com',
        ),
      ],
    );
    final store = InMemoryDeviceTicketStore();
    const checkout = DeviceTicketCheckout(
      ticketId: 'paid-seed',
      email: 'guest@example.com',
    );
    await store.savePendingCheckout(checkout);
    await store.promoteCheckout(checkout);
    final controller = TicketController(repository, deviceStore: store);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TicketsPage(ticketController: controller, authenticated: false),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Menampilkan tiket dari perangkat ini'), findsOneWidget);
    expect(find.text('1 email tersimpan'), findsOneWidget);
    expect(find.text('Email: guest@example.com'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        'Tiket perjalanan: Setiabudi → Manggarai, Aktif, email '
        'guest@example.com, 13 Agu 2026, Rp7.800',
      ),
      findsOneWidget,
    );
  });

  testWidgets('populated ticket page uses timetable visual surfaces', (
    tester,
  ) async {
    final repository = _Repository(
      guestTickets: [
        _ticket(
          id: 'guest-ticket',
          status: TicketStatus.active,
          contactEmail: 'guest@example.com',
        ),
      ],
    );
    final store = InMemoryDeviceTicketStore();
    const checkout = DeviceTicketCheckout(
      ticketId: 'paid-seed',
      email: 'guest@example.com',
    );
    await store.savePendingCheckout(checkout);
    await store.promoteCheckout(checkout);
    final controller = TicketController(repository, deviceStore: store);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TicketsPage(ticketController: controller, authenticated: false),
      ),
    );
    await tester.pumpAndSettle();

    final safeAreaSurface = tester.widget<ColoredBox>(
      find.byKey(const Key('ticket-safe-area-surface')),
    );
    final contentBackground = tester.widget<ColoredBox>(
      find.byKey(const Key('ticket-page-content-background')),
    );
    final header = tester.widget<Container>(
      find.byKey(const Key('ticket-page-header')),
    );
    final titleFinder = find.descendant(
      of: find.byKey(const Key('ticket-page-header')),
      matching: find.text('Tiket'),
    );
    final title = tester.widget<Text>(titleFinder);
    final filterFinder = find.byKey(const Key('ticket-history-filter'));
    final filter = tester.widget<Container>(filterFinder);
    final selectedSegmentFinder = find.byKey(
      const Key('ticket-filter-selected-segment'),
    );
    final selectedSegment = tester.widget<AnimatedContainer>(
      selectedSegmentFinder,
    );
    final selectedSegmentDecoration =
        selectedSegment.decoration! as BoxDecoration;
    final selectedLabel = tester.widget<Text>(
      find.descendant(of: selectedSegmentFinder, matching: find.text('Semua')),
    );
    final card = tester.widget<Container>(
      find.byKey(const Key('ticket-card-guest-ticket')),
    );
    final filterDecoration = filter.decoration! as BoxDecoration;
    final cardDecoration = card.decoration! as BoxDecoration;
    final cardBorder = cardDecoration.border! as Border;
    final emailField = tester.widget<TextField>(
      find.descendant(
        of: find.byType(TextFormField),
        matching: find.byType(TextField),
      ),
    );

    expect(safeAreaSurface.color, AppColors.surface);
    expect(contentBackground.color, AppColors.background);
    expect(header.color, AppColors.surface);
    expect(titleFinder, findsOneWidget);
    expect(title.style?.fontSize, 22);
    expect(title.style?.fontWeight, FontWeight.w800);
    expect(filterDecoration.color, AppColors.background);
    expect(filterDecoration.borderRadius, BorderRadius.circular(14));
    for (final label in const ['Semua', 'Belum bayar', 'Aktif', 'Selesai']) {
      expect(
        find.descendant(of: filterFinder, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(selectedSegmentDecoration.color, AppColors.primaryBlue);
    expect(selectedLabel.style?.color, Colors.white);
    expect(cardDecoration.borderRadius, BorderRadius.circular(16));
    expect(cardBorder.top.color, AppColors.cardBorder);
    expect(cardDecoration.boxShadow, isNotEmpty);
    expect(find.text('Setiabudi  →  Manggarai'), findsOneWidget);
    expect(find.text('TKT-001 · 13 Agu 2026'), findsOneWidget);
    expect(find.text('Email: guest@example.com'), findsOneWidget);
    expect(find.text('Rp7.800'), findsOneWidget);
    expect(emailField.decoration?.filled, isFalse);
  });

  testWidgets('guest email field keeps one border and shows validation error', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final controller = TicketController(_Repository());
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            disabledBorder: OutlineInputBorder(),
            errorBorder: OutlineInputBorder(),
            focusedErrorBorder: OutlineInputBorder(),
          ),
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TicketsPage(ticketController: controller, authenticated: false),
      ),
    );
    await tester.pumpAndSettle();

    final textFormFieldFinder = find.byType(TextFormField);
    final emailField = tester.widget<TextField>(
      find.descendant(
        of: textFormFieldFinder,
        matching: find.byType(TextField),
      ),
    );
    final decoration = emailField.decoration!;

    expect(decoration.border, InputBorder.none);
    expect(decoration.enabledBorder, InputBorder.none);
    expect(decoration.focusedBorder, InputBorder.none);
    expect(decoration.disabledBorder, InputBorder.none);
    expect(decoration.errorBorder, InputBorder.none);
    expect(decoration.focusedErrorBorder, InputBorder.none);

    await tester.enterText(textFormFieldFinder, 'email-tidak-valid');
    await tester.tap(find.byTooltip('Tampilkan riwayat'));
    await tester.pumpAndSettle();

    expect(find.text('Masukkan email yang valid'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('each ticket history filter exposes a tap semantics action', (
    tester,
  ) async {
    final controller = TicketController(_Repository());
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TicketsPage(ticketController: controller, authenticated: true),
      ),
    );
    await tester.pumpAndSettle();

    for (final label in const ['Semua', 'Belum bayar', 'Aktif', 'Selesai']) {
      final semantics = tester
          .getSemantics(find.bySemanticsLabel(label))
          .getSemanticsData();
      expect(
        semantics.hasAction(SemanticsAction.tap),
        isTrue,
        reason: '$label harus dapat diaktifkan dari accessibility service',
      );
    }
  });

  testWidgets('ticket page title exposes heading semantics', (tester) async {
    final controller = TicketController(_Repository());
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TicketsPage(ticketController: controller, authenticated: true),
      ),
    );
    await tester.pumpAndSettle();

    final titleSemantics = tester
        .getSemantics(
          find.descendant(
            of: find.byKey(const Key('ticket-page-header')),
            matching: find.bySemanticsLabel('Tiket'),
          ),
        )
        .getSemanticsData();
    expect(titleSemantics.flagsCollection.isHeader, isTrue);
  });

  testWidgets('ticket filters stay complete and tappable at 200% text scale', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final controller = TicketController(_Repository());
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TicketsPage(ticketController: controller, authenticated: true),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final filterFinder = find.byKey(const Key('ticket-history-filter'));
    for (final label in const ['Semua', 'Belum bayar', 'Aktif', 'Selesai']) {
      final labelFinder = find.descendant(
        of: filterFinder,
        matching: find.text(label),
      );
      expect(labelFinder, findsOneWidget);
      final labelWidget = tester.widget<Text>(labelFinder);
      final segmentFinder = find.ancestor(
        of: labelFinder,
        matching: find.byType(AnimatedContainer),
      );

      expect(labelWidget.maxLines, 2);
      expect(labelWidget.textAlign, TextAlign.center);
      expect(labelWidget.overflow, isNot(TextOverflow.ellipsis));
      expect(tester.getSize(segmentFinder).height, greaterThanOrEqualTo(48));
    }
  });

  testWidgets('checkout opens hosted Xendit link and remains pending', (
    tester,
  ) async {
    final controller = TicketController(_Repository());
    addTearDown(controller.dispose);
    Uri? opened;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TicketsPage(
          ticketController: controller,
          authenticated: true,
          from: 'Setiabudi',
          to: 'Manggarai',
          fare: 'Rp7.800',
          duration: '7',
          transit: '0',
          checkoutLauncher: (uri) async {
            opened = uri;
            return true;
          },
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('buy-ticket-button')));
    await tester.pumpAndSettle();

    expect(opened, Uri.parse('https://checkout.xendit.test/session-1'));
    expect(find.text('Menunggu pembayaran'), findsOneWidget);
    expect(controller.state.stage, TicketStage.checkoutReady);
    expect(find.text('Tiket aktif'), findsNothing);
  });

  testWidgets('ticket history reloads after login and logout', (tester) async {
    final auth = AuthController(_AuthRepository());
    final repository = _Repository(
      accountTickets: [
        _ticket(id: 'account-ticket', status: TicketStatus.active),
      ],
    );
    final controller = TicketController(repository);
    addTearDown(auth.dispose);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: AuthScope(
          controller: auth,
          child: TicketsPage(ticketController: controller),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('TKT-001'), findsNothing);

    await auth.login(email: 'account@example.com', password: 'password');
    await tester.pumpAndSettle();
    expect(controller.state.tickets, hasLength(1));

    await auth.logout();
    await tester.pumpAndSettle();
    expect(controller.state.tickets, isEmpty);
  });
}

class _Repository implements TicketRepository {
  _Repository({this.guestTickets = const [], this.accountTickets = const []});

  final List<Ticket> guestTickets;
  final List<Ticket> accountTickets;

  @override
  Future<TicketPage> listGuestTickets({
    required String contactEmail,
    int page = 1,
    int limit = 20,
  }) async => TicketPage(
    items: guestTickets,
    page: page,
    limit: limit,
    total: guestTickets.length,
  );

  @override
  Future<Ticket> orderTicket({
    required String origin,
    required String destination,
    required DateTime travelDate,
    int passengerCount = 1,
    String? contactEmail,
  }) async => _ticket(
    id: 'ticket-1',
    status: TicketStatus.paymentPending,
    contactEmail: contactEmail,
    travelDate: travelDate,
  );

  @override
  Future<TicketPayment> createCheckout({
    required String ticketId,
    String? contactEmail,
  }) async => TicketPayment(
    id: 'payment-1',
    referenceId: 'reference-1',
    amount: 7800,
    currency: 'IDR',
    status: PaymentStatus.pending,
    checkoutUrl: Uri.parse('https://checkout.xendit.test/session-1'),
  );

  @override
  Future<PaymentSnapshot> getPaymentStatus({
    required String ticketId,
    String? contactEmail,
  }) => throw UnimplementedError();

  @override
  Future<PaymentSnapshot> getGuestPaymentStatus({
    required String ticketId,
    required String contactEmail,
  }) => getPaymentStatus(ticketId: ticketId, contactEmail: contactEmail);

  @override
  Future<TicketPage> listTickets({
    String? contactEmail,
    int page = 1,
    int limit = 20,
  }) async => TicketPage(
    items: accountTickets,
    page: page,
    limit: limit,
    total: accountTickets.length,
  );
}

class _AuthRepository implements AuthRepository {
  AccountUser? _user;

  @override
  AccountUser? get currentUser => _user;

  @override
  Future<AuthBootstrapResult> bootstrap() async => const AuthBootstrapResult();

  @override
  Future<AccountUser> login({
    required String email,
    required String password,
  }) async => _user = AccountUser(
    id: 'account-1',
    email: email,
    role: 'REGISTERED',
    language: 'id',
    accessibilityEnabled: true,
    notificationsEnabled: true,
  );

  @override
  Future<void> logout() async {
    _user = null;
  }

  @override
  Future<AccountUser> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) => login(email: email, password: password);

  @override
  Future<AccountUser> updateProfile({
    String? name,
    String? phone,
    String? language,
    bool? accessibilityEnabled,
    bool? notificationsEnabled,
  }) async => _user!;
}

Ticket _ticket({
  required String id,
  required TicketStatus status,
  String? contactEmail,
  DateTime? travelDate,
}) => Ticket(
  id: id,
  publicCode: 'TKT-001',
  contactEmail: contactEmail,
  origin: const TicketStation(id: 'origin', name: 'Setiabudi'),
  destination: const TicketStation(id: 'destination', name: 'Manggarai'),
  passengerCount: 1,
  unitPrice: 7800,
  price: 7800,
  status: status,
  travelDate: travelDate ?? DateTime.utc(2026, 8, 13, 12),
  payments: const [],
);
