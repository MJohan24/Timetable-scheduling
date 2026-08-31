# Ticket and Xendit Sandbox Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Connect Flutter ticket ordering, history, and payment reconciliation to the monorepo backend and Xendit Sandbox.

**Architecture:** Add a backend ticket-access policy, then build a Flutter ticket feature with domain entities, HTTP data source, repository, controller, and an external checkout launcher. The backend remains authoritative for fares and payment state; Flutter activates alarms only after an `ACTIVE` status response.

**Tech Stack:** Flutter/Dart, `package:http`, `url_launcher`, Express, TypeScript, Prisma, Node test runner, Xendit Payment Sessions.

---

## File Map

- Create `timetable_backend/src/domain/services/ticketAccessService.ts`: central ticket ownership checks.
- Modify `timetable_backend/src/presentation/controllers/paymentController.ts`: authenticated/guest checkout and status authorization.
- Modify `timetable_backend/src/presentation/routes/paymentRoutes.ts`: optional-auth middleware.
- Create `timetable_backend/tests/paymentAccess.test.ts`: policy regression tests.
- Create `lib/core/network/access_token_provider.dart`: data-layer token contract.
- Modify `lib/features/auth/data/repositories/auth_repository_impl.dart`: implement token provider and forced refresh.
- Create `lib/features/tickets/domain/entities/ticket.dart`: ticket and payment domain types.
- Create `lib/features/tickets/domain/repositories/ticket_repository.dart`: ticket operations contract.
- Create `lib/features/tickets/data/models/ticket_model.dart`: backend JSON mapping.
- Create `lib/features/tickets/data/datasources/ticket_remote_data_source.dart`: REST transport.
- Create `lib/features/tickets/data/repositories/ticket_repository_impl.dart`: auth retry and guest context.
- Create `lib/features/tickets/presentation/controllers/ticket_controller.dart`: checkout and status state machine.
- Create `lib/features/tickets/presentation/services/checkout_launcher.dart`: external-browser boundary.
- Modify `lib/features/tickets/presentation/pages/tickets_page.dart`: backend-driven UI and lifecycle refresh.
- Modify `lib/main.dart`: share auth repository/token provider with ticket composition.
- Modify `pubspec.yaml`: add `url_launcher`.
- Modify localization catalogs: backend checkout, validation, pending, retry, and failure copy.
- Create focused Flutter tests for models, transport, repository, controller, and page behavior.

### Task 1: Protect Backend Payment Access

**Files:**
- Create: `timetable_backend/src/domain/services/ticketAccessService.ts`
- Create: `timetable_backend/tests/paymentAccess.test.ts`
- Modify: `timetable_backend/src/presentation/controllers/paymentController.ts`
- Modify: `timetable_backend/src/presentation/routes/paymentRoutes.ts`

- [ ] **Step 1: Write failing policy tests**

Test an authenticated owner, a different authenticated user, a matching guest email, and a missing/mismatched guest email:

```ts
test('registered owner can access payment state', () => {
  assert.doesNotThrow(() => assertTicketPaymentAccess(ticket, ownerAuth));
});

test('different account cannot access payment state', () => {
  assert.throws(
    () => assertTicketPaymentAccess(ticket, otherAuth),
    (error: unknown) => error instanceof ApiError && error.statusCode === 403,
  );
});

test('guest email must match ticket contact', () => {
  assert.doesNotThrow(() => assertTicketPaymentAccess(guestTicket, undefined, 'guest@example.com'));
  assert.throws(() => assertTicketPaymentAccess(guestTicket, undefined, 'other@example.com'));
});
```

- [ ] **Step 2: Run the test and verify RED**

Run: `npm test -- --run tests/paymentAccess.test.ts`

Expected: FAIL because `ticketAccessService.ts` does not exist.

- [ ] **Step 3: Implement the access policy**

```ts
export type PaymentTicketOwner = { userId: string | null; contactEmail: string | null };

export function assertTicketPaymentAccess(
  ticket: PaymentTicketOwner,
  auth: Request['auth'],
  guestEmail?: string,
) {
  if (ticket.userId) {
    if (auth?.role !== 'GUEST' && auth?.userId === ticket.userId) return;
    throw new ApiError(403, 'Ticket belongs to another account', 'TICKET_FORBIDDEN');
  }
  if (guestEmail && ticket.contactEmail?.toLowerCase() === guestEmail.toLowerCase()) return;
  throw new ApiError(403, 'Guest ticket email does not match', 'TICKET_FORBIDDEN');
}
```

Add `optionalAuth` to checkout/status routes. Accept `contactEmail` in checkout body and status query, then call the policy after loading the ticket and before returning payment data.

- [ ] **Step 4: Run backend focused tests and verify GREEN**

Run: `npm test -- --run tests/paymentAccess.test.ts tests/ticketOrderAuth.test.ts tests/xenditWebhook.test.ts`

Expected: all focused tests pass.

- [ ] **Step 5: Commit backend access control**

```bash
git add timetable_backend/src timetable_backend/tests/paymentAccess.test.ts
git commit -m "feat(backend): protect ticket payment access"
```

### Task 2: Add Authenticated Token Boundary

**Files:**
- Create: `lib/core/network/access_token_provider.dart`
- Create: `test/auth_token_provider_test.dart`
- Modify: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- Modify test fakes implementing `AuthRepository` only if their contracts are affected.

- [ ] **Step 1: Write a failing token-provider test**

```dart
test('provider reuses the current access token and can force rotation', () async {
  final remote = FakeAuthRemote()..sessions.addAll([firstSession, secondSession]);
  final repository = AuthRepositoryImpl(remote: remote, store: store);
  await repository.login(email: 'user@example.com', password: 'password');

  expect(await repository.getAccessToken(), firstSession.accessToken);
  expect(await repository.getAccessToken(forceRefresh: true), secondSession.accessToken);
});
```

- [ ] **Step 2: Run the test and verify RED**

Run: `flutter test test/auth_token_provider_test.dart`

Expected: FAIL because `AccessTokenProvider` and `getAccessToken` do not exist.

- [ ] **Step 3: Implement the token provider**

```dart
abstract interface class AccessTokenProvider {
  Future<String?> getAccessToken({bool forceRefresh = false});
}
```

`AuthRepositoryImpl` implements the interface. It returns the in-memory access token, rotates using the refresh token when forced, and returns `null` when no session exists.

- [ ] **Step 4: Run auth tests and verify GREEN**

Run: `flutter test test/auth_token_provider_test.dart test/auth_controller_test.dart`

Expected: all tests pass.

- [ ] **Step 5: Commit token boundary**

```bash
git add lib/core/network lib/features/auth test/auth_token_provider_test.dart
git commit -m "feat(auth): expose repository token provider"
```

### Task 3: Model Ticket and Payment Responses

**Files:**
- Create: `lib/features/tickets/domain/entities/ticket.dart`
- Create: `lib/features/tickets/data/models/ticket_model.dart`
- Create: `test/ticket_model_test.dart`

- [ ] **Step 1: Write failing JSON mapping tests**

Cover pending, active, used, expired, nested stations, latest payment, checkout URL, QR payload, fare, and ISO timestamps.

```dart
final ticket = TicketModel.fromJson(ticketJson);
expect(ticket.status, TicketStatus.active);
expect(ticket.origin.name, 'Setiabudi');
expect(ticket.latestPayment?.checkoutUrl, startsWith('https://checkout.xendit.co/'));
expect(ticket.isCompleted, isFalse);
```

- [ ] **Step 2: Run and verify RED**

Run: `flutter test test/ticket_model_test.dart`

Expected: FAIL because ticket models do not exist.

- [ ] **Step 3: Implement domain entities and models**

Define `TicketStatus`, `PaymentStatus`, `TicketStation`, `TicketPayment`, `Ticket`, `TicketPage`, and `PaymentSnapshot`. Unknown statuses map to a stable `unknown` enum member rather than throwing.

- [ ] **Step 4: Run and verify GREEN**

Run: `flutter test test/ticket_model_test.dart`

Expected: all mapping tests pass.

- [ ] **Step 5: Commit models**

```bash
git add lib/features/tickets/domain lib/features/tickets/data/models test/ticket_model_test.dart
git commit -m "feat(tickets): model backend ticket state"
```

### Task 4: Implement Ticket REST Transport

**Files:**
- Create: `lib/features/tickets/data/datasources/ticket_remote_data_source.dart`
- Create: `test/ticket_remote_data_source_test.dart`

- [ ] **Step 1: Write failing HTTP contract tests**

Verify exact method, path, bearer header, guest email, request JSON, query encoding, timeout/error mapping, and response parsing for:

```text
POST /tickets/order
GET  /tickets
POST /payments/checkout
GET  /payments/status/:ticketId
```

- [ ] **Step 2: Run and verify RED**

Run: `flutter test test/ticket_remote_data_source_test.dart`

Expected: FAIL because the remote source does not exist.

- [ ] **Step 3: Implement the remote source**

Use injected `http.Client`, `ApiConfig.baseUrl`, JSON content type, optional bearer token, a ten-second timeout, and `TicketRemoteException(code, message, isNetwork, isUnauthorized)`.

- [ ] **Step 4: Run and verify GREEN**

Run: `flutter test test/ticket_remote_data_source_test.dart`

Expected: all transport tests pass.

- [ ] **Step 5: Commit transport**

```bash
git add lib/features/tickets/data/datasources test/ticket_remote_data_source_test.dart
git commit -m "feat(tickets): add backend REST transport"
```

### Task 5: Implement Repository and Controller State Machine

**Files:**
- Create: `lib/features/tickets/domain/repositories/ticket_repository.dart`
- Create: `lib/features/tickets/data/repositories/ticket_repository_impl.dart`
- Create: `lib/features/tickets/presentation/controllers/ticket_controller.dart`
- Create: `test/ticket_repository_test.dart`
- Create: `test/ticket_controller_test.dart`

- [ ] **Step 1: Write failing repository tests**

Verify authenticated requests, guest email propagation, one forced token refresh after `401`, and no retry for non-auth errors.

- [ ] **Step 2: Run repository tests and verify RED**

Run: `flutter test test/ticket_repository_test.dart`

Expected: FAIL because the repository does not exist.

- [ ] **Step 3: Implement repository**

The repository asks `AccessTokenProvider` for a token, sends guest email only when no token exists, retries exactly once with `forceRefresh: true`, and exposes typed operations for order, history, checkout, and payment status.

- [ ] **Step 4: Write failing controller tests**

```dart
await controller.orderAndCreateCheckout(request);
expect(controller.state.stage, TicketStage.checkoutReady);
expect(controller.state.checkoutUrl, checkoutUrl);

await controller.refreshPaymentStatus();
expect(controller.state.stage, TicketStage.ticketActive);
```

Also verify invalid guest email, pending status, expired state, recoverable errors, lifecycle refresh eligibility, and no alarm mutation inside the controller.

- [ ] **Step 5: Run controller tests and verify RED**

Run: `flutter test test/ticket_controller_test.dart`

Expected: FAIL because the controller does not exist.

- [ ] **Step 6: Implement controller and verify GREEN**

Run: `flutter test test/ticket_repository_test.dart test/ticket_controller_test.dart`

Expected: all repository and controller tests pass.

- [ ] **Step 7: Commit repository/controller**

```bash
git add lib/features/tickets test/ticket_repository_test.dart test/ticket_controller_test.dart
git commit -m "feat(tickets): coordinate checkout and payment status"
```

### Task 6: Replace Simulated Ticket UI

**Files:**
- Create: `lib/features/tickets/presentation/services/checkout_launcher.dart`
- Modify: `lib/features/tickets/presentation/pages/tickets_page.dart`
- Modify: `lib/main.dart`
- Modify: `pubspec.yaml`
- Modify: `lib/l10n/app_id.arb`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ar.arb`
- Modify: `lib/l10n/app_zh.arb`
- Modify: `lib/l10n/app_zh_Hans.arb`
- Modify: `test/widget_test.dart`
- Create: `test/tickets_page_backend_test.dart`

- [ ] **Step 1: Add `url_launcher` and write failing widget tests**

Tests inject a fake controller and checkout launcher. They verify guest email input, server fare, `Lanjut ke Xendit`, checkout launch, pending actions, lifecycle refresh, active QR rendering, and alarm setup only after active status.

- [ ] **Step 2: Run widget tests and verify RED**

Run: `flutter test test/tickets_page_backend_test.dart`

Expected: FAIL because the page still uses local ticket/payment simulation.

- [ ] **Step 3: Implement the external launcher**

```dart
abstract interface class CheckoutLauncher {
  Future<bool> open(Uri uri);
}

class ExternalCheckoutLauncher implements CheckoutLauncher {
  @override
  Future<bool> open(Uri uri) => launchUrl(uri, mode: LaunchMode.externalApplication);
}
```

- [ ] **Step 4: Rebuild the page around controller state**

Keep the existing visual language and filters, replace hardcoded ticket items with backend tickets, replace simulated payment tiles with contact/summary/Xendit CTA, implement `WidgetsBindingObserver`, and call payment refresh on `AppLifecycleState.resumed` only when a checkout is pending.

- [ ] **Step 5: Connect composition in `main.dart`**

Create one `AuthRepositoryImpl`, use it for `AuthController` and as the ticket repository's `AccessTokenProvider`, and inject a shared `TicketController` into the ticket route/page boundary without exposing tokens to widgets.

- [ ] **Step 6: Generate localizations and verify widget tests GREEN**

Run:

```bash
flutter gen-l10n
flutter test test/tickets_page_backend_test.dart test/widget_test.dart
```

Expected: the focused ticket flow and existing app flows pass.

- [ ] **Step 7: Commit UI integration**

```bash
git add lib test pubspec.yaml pubspec.lock
git commit -m "feat(tickets): integrate Xendit checkout UI"
```

### Task 7: Verify End to End

**Files:**
- Modify only files required by failures proven during verification.

- [ ] **Step 1: Run formatter and static checks**

Run:

```bash
dart format lib test
flutter analyze
npm run build
```

Expected: zero analyzer/compiler errors.

- [ ] **Step 2: Run full automated tests**

Run:

```bash
flutter test
npm test -- --run
```

Expected: Flutter suite passes. Backend suite passes except no known data-fixture mismatch may be silently ignored; the existing legacy total mismatch must be reported if still present.

- [ ] **Step 3: Build Android debug APK**

Run: `flutter build apk --debug`

Expected: `build/app/outputs/flutter-apk/app-debug.apk` is produced.

- [ ] **Step 4: Perform Xendit Sandbox smoke test**

Start PostgreSQL, backend, and ngrok. From the emulator, order a guest ticket, open Xendit, complete a sandbox payment, return to the app, verify the ticket becomes active, and verify alarm setup appears only after activation.

- [ ] **Step 5: Verify secrets and repository status**

Run:

```bash
git check-ignore -v timetable_backend/.env
git ls-files "*docs/superpowers*" timetable_backend/.env
git status --short
```

Expected: `.env` is ignored, no `docs/superpowers` or `.env` is tracked, and only intentional changes remain.

- [ ] **Step 6: Commit verification fixes, if any**

```bash
git add lib test timetable_backend/src timetable_backend/tests pubspec.yaml pubspec.lock
git commit -m "fix(tickets): stabilize sandbox checkout flow"
```
