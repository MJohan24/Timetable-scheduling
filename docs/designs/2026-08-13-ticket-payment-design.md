# Ticket and Xendit Sandbox Integration Design

## Goal

Replace the local ticket and payment simulation with backend-owned ticket ordering, Xendit Payment Sessions, webhook-authoritative activation, and backend ticket history for authenticated and guest users.

## Scope

- Order tickets from the Flutter application through the REST backend.
- Support authenticated checkout and checkout without login.
- Require a valid email for guest checkout so guest history can be restored.
- Create Xendit Sandbox Payment Sessions on the backend.
- Open the hosted Xendit checkout in an external browser.
- Refresh payment status when the user returns to the app.
- Keep manual status refresh and reopen-payment actions available.
- Load and filter pending, active, and completed tickets from the backend.
- Offer travel-alarm setup only after the backend reports an active ticket.
- Enforce ticket ownership when creating checkout sessions or reading payment status.

Refunds, production Xendit credentials, saved payment methods, and in-app card entry are outside this iteration.

## Architecture

The Flutter implementation follows the existing feature boundaries used by schedules and route planning:

- A ticket remote data source owns HTTP serialization, timeouts, and API errors.
- Ticket and payment models map backend responses into domain entities.
- A ticket repository coordinates optional authentication and one access-token refresh on authorization failure.
- A ticket controller exposes explicit loading, checkout, payment-checking, active, and failure states.
- The ticket page renders controller state and delegates external checkout opening to an injected launcher.

The authentication repository implements an internal access-token provider used by data repositories. Widgets never receive or persist access tokens.

## Backend Contract

Ticket ordering uses `POST /api/v1/tickets/order`. The server calculates the fare and ignores client-supplied prices. Authenticated ownership is taken from the verified bearer token. Guest orders include a required contact email.

Checkout uses `POST /api/v1/payments/checkout`. Payment status uses `GET /api/v1/payments/status/:ticketId`. Both routes use optional authentication and verify that the authenticated user owns the ticket or that the supplied guest email matches the ticket.

The Xendit webhook at `POST /api/v1/payments/webhook/xendit` remains the only authority that activates or expires tickets. Browser redirects and Flutter state never activate a ticket directly.

## User Flow

1. The ticket page loads backend ticket history.
2. The user selects a pending ticket or starts checkout from a planned route.
3. A guest enters and validates an email; an authenticated user proceeds without contact input.
4. Flutter orders a ticket and displays the server-calculated fare and payment deadline.
5. Flutter requests a Xendit Payment Session and opens its payment link in an external browser.
6. On application resume, Flutter requests the current payment status.
7. An active response opens the active-ticket state and offers travel-alarm setup.
8. A pending response keeps the payment screen visible with check-status and reopen-payment actions.
9. Expired, cancelled, or failed responses display a terminal state and allow a new order.

Payment methods such as QRIS, virtual accounts, cards, and e-wallets are selected on Xendit's hosted page. The simulated payment-method tiles are removed from Flutter.

## UI States

- `loadingHistory`: ticket history is being loaded.
- `historyReady`: pending, active, and completed tickets are available.
- `ordering`: the backend is creating and pricing the ticket.
- `checkoutReady`: a ticket and reusable checkout URL exist.
- `openingCheckout`: Flutter is launching the external browser.
- `checkingPayment`: Flutter is reconciling the webhook-backed status.
- `paymentPending`: payment has not yet been confirmed.
- `ticketActive`: a signed QR ticket is active.
- `terminal`: the ticket is expired, cancelled, used, or failed.
- `failure`: a recoverable request or browser-launch error occurred.

Status changes are exposed as accessible live-region announcements. Loading indicators do not replace route and fare context.

## Error Handling

- Network and timeout errors retain the current screen and expose a retry action.
- Invalid guest email is rejected before ticket creation.
- An unauthorized response triggers one token refresh; a second failure returns the user to a recoverable signed-out state.
- A missing or invalid checkout URL is treated as a backend response error.
- Failure to open the browser preserves the checkout URL and allows another attempt.
- Pending status never produces a local active ticket.
- Expired sessions cannot be reused.
- Invalid webhook tokens return `401` without changing payment or ticket records.
- Xendit errors preserve a pending, unexpired ticket so checkout can be retried without creating a duplicate order.

## Security

- The Xendit secret key and webhook token remain exclusively in `timetable_backend/.env`.
- `.env` remains ignored by Git.
- Flutter receives only the short-lived hosted checkout URL.
- Backend ownership checks protect checkout creation and payment-status reads.
- Ticket activation validates webhook token, reference, session, currency, and amount.
- No success redirect is treated as proof of payment.

## Testing

Flutter tests cover model parsing, authenticated and guest order requests, required guest email, checkout URL parsing, token retry, status reconciliation, ticket filtering, browser-launch failure, app-resume refresh, and alarm gating until an `ACTIVE` response.

Backend tests cover authenticated and guest ownership, rejected cross-user access, guest-email matching, checkout reuse, payment status, webhook activation, expiration, mismatch rejection, and duplicate webhook idempotency.

Verification includes Flutter analysis, the full Flutter test suite, an Android debug build, backend TypeScript compilation, backend tests, and a sandbox checkout smoke test through ngrok.
