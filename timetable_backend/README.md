# KAI Access Multimodal Backend

Express/TypeScript backend aligned with the Flutter project in `KAIACCES/timetable`. The canonical catalog contains 123 station identities, 121 drawable stations, 135 line-specific nodes, 11 lines/branches, and 292 directed graph connections. Gambir is timetable-only, while Jatake is boardable but remains outside the supplied mobile map geometry.

## What is implemented

- Station list/search by name, sponsored alias, service, accessibility, and node code.
- Full network endpoint with ordered nodes and map coordinates.
- Real graph routing with station sequence and interchange steps; disconnected lines return an explicit error instead of a fabricated route.
- Schedule filtering by station UUID/name/node code, service type, weekday/weekend, and time range.
- Server-calculated booking fare, passenger count, ticket expiry, ticket list/history, cancellation, signed QR issuance, and QR validation.
- Xendit Payment Session hosted checkout with reusable active sessions, callback-token verification, amount/reference/session verification, and idempotent webhook processing.
- Reminder CRUD, report submission/status workflow, authenticated profile and accessibility/language preferences.
- Configurable realtime KAI provider; no random tracking data is returned when the provider is absent.

The fare engine is currently a product estimate (`Rp3.000` base plus route bands). Replace it with an official operator fare source before production sales.

## Local setup

```powershell
npm install
Copy-Item .env.example .env
docker compose up -d db
npx prisma migrate deploy
npx prisma generate
npx prisma db seed
npm run timetable:import -- prisma/data/commuter-2026-02.json
npm run dev
```

The bundled PostgreSQL container is published on `localhost:5433`. API documentation is available at [http://localhost:3000/api-docs](http://localhost:3000/api-docs), and health status at `GET /health`.

For Android Emulator use `http://10.0.2.2:3000` as the Flutter base URL. A physical phone must use the development computer's LAN address, for example `http://192.168.1.20:3000`; allow port 3000 through the local firewall only on trusted networks.

## Core mobile API contract

| Method | Endpoint | Purpose |
|---|---|---|
| `GET` | `/api/v1/stations` | Paginated station list; filters: `q`, `service`, `accessible`, `transit` |
| `GET` | `/api/v1/stations/network` | Ordered line/node topology for the mobile map |
| `GET` | `/api/v1/schedules` | Requires `stationId` or `station`; optional service/time/weekend filters |
| `POST` | `/api/v1/routes/plan` | Calculate connected route and server fare |
| `POST` | `/api/v1/tickets/order` | Create payment-pending booking |
| `GET` | `/api/v1/tickets` | Ticket history by registered user/contact email |
| `GET` | `/api/v1/tickets/:id` | Ticket detail by UUID or public code |
| `POST` | `/api/v1/tickets/:id/cancel` | Cancel an unpaid ticket |
| `POST` | `/api/v1/tickets/validate` | Validate or consume a signed ticket QR |
| `POST` | `/api/v1/payments/checkout` | Create/reuse a Xendit hosted checkout session |
| `GET` | `/api/v1/payments/status/:ticketId` | Poll ticket/payment status after returning to mobile |
| `POST` | `/api/v1/payments/webhook/xendit` | Server-only Xendit Payment Session webhook |
| `GET/PATCH` | `/api/v1/profile` | Authenticated account and accessibility preferences |
| `GET/POST/PATCH/DELETE` | `/api/v1/utilities/reminders...` | Travel alarm management |
| `GET/POST/PATCH` | `/api/v1/utilities/reports...` | User/staff issue workflow |
| `GET` | `/api/v1/tracking/:trainNumber` | Configured realtime provider proxy |

Route request:

```json
{
  "from": "bogor",
  "to": "jakarta-kota",
  "passengerCount": 2,
  "preference": "FASTEST"
}
```

`from` and `to` should be stable station slugs from `GET /stations`; names and
aliases remain accepted as a transition fallback. `FASTEST` minimizes journey
minutes and then transfers. `MIN_TRANSFERS` minimizes transfers and then journey
minutes. The mobile accessible mode requests `FASTEST` and narrates the returned
route using native text-to-speech, so it does not fabricate a separate path.

Booking request (`price` is intentionally absent because the server calculates it):

```json
{
  "contactEmail": "penumpang@example.com",
  "origin": "Bogor",
  "destination": "Jakarta Kota",
  "travelDate": "2026-08-09T00:00:00+07:00",
  "passengerCount": 2
}
```

All new endpoints use `{ "success": true, "data": ... }`. Errors use `{ "success": false, "error": { "code", "message", "details"? } }`.

## Versioned commuter timetable

The checked-in `prisma/data/commuter-2026-02.json` is the deterministic snapshot of `Jadwal Commuter Line Jabodetabek Update Februari 2026.pdf`. It contains 1,145 services and 19,328 stop/pass-through calls. Operational PDF abbreviations (`GMR`, `JTK`, and 83 others) resolve to stable station slugs; public map codes remain a separate identity.

To regenerate and import it:

```powershell
<bundled-python> scripts/extract_commuter_timetable.py "C:\path\Jadwal Commuter Line Jabodetabek Update Februari 2026.pdf" prisma/data/commuter-2026-02.json
npm run timetable:import -- prisma/data/commuter-2026-02.json
```

Import is transactional and idempotent for a dataset version. It rebuilds only `2026-02`, validates every station/line/count before activation, leaves legacy `Schedule` rows and older datasets intact, and activates the new dataset only after all stop rows are inserted. To roll back, set the desired older `TimetableDataset.isActive` to `true` and the current one to `false` in one transaction; the database partial unique index permits only one active dataset.

Schedule service groups are intentionally separate from mobile geometry. For example, PDF group `cikarang` maps onto the existing `cikarang_loop` and `cikarang_east` graph lines; it does not add or reshape a mobile line.

## Xendit configuration

1. Put the server-side API key in `XENDIT_SECRET_KEY`. Never place it in Flutter.
2. Put the Dashboard webhook verification token in `XENDIT_WEBHOOK_TOKEN`.
3. Configure the Xendit Payment Session webhook URL as `https://your-api.example.com/api/v1/payments/webhook/xendit`.
4. Configure HTTPS success/cancel URLs if the hosted checkout should redirect to a web/deep-link bridge.
5. Mobile calls checkout, opens `checkoutUrl`, then polls `/payments/status/:ticketId`. The webhook—not the mobile redirect—activates the ticket and generates its QR.

Without Xendit configuration, checkout returns HTTP `503` with `PAYMENT_PROVIDER_NOT_CONFIGURED`; it never returns a dummy payment URL.

## Verification

For the 200 ms performance benchmark, first-request handling, continuous testing,
and the initial measurements, see [Performance benchmark](docs/performance.md).

```powershell
npx prisma validate
npx prisma generate
npm test
npm run build
```

The seed is idempotent and can be re-run with `npx prisma db seed`. External KAI realtime data and production fare accuracy still require credentials/contract access from the official provider.
# Optional account authentication

Guest mode remains the default and still supports stations, schedules, route
planning, ticket orders, Xendit checkout, and locally retained QR tickets.
Accounts only add a persistent profile and authenticated ticket ownership.

Authentication endpoints under `/api/v1`:

- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/refresh`
- `POST /auth/logout`
- `GET/PATCH /profile` with `Authorization: Bearer <access-token>`

Access tokens expire after 15 minutes. Opaque refresh tokens use a sliding
90-day lifetime, rotate after every refresh, and are stored in PostgreSQL only
as SHA-256 hashes in `AuthSession`. Configure a strong `JWT_SECRET` in `.env`;
never copy the Xendit or JWT secret into Flutter.

Apply the schema and start development:

```powershell
npx prisma migrate deploy
npm run dev
```

The Android emulator reaches this server through
`http://10.0.2.2:3000/api/v1`.
