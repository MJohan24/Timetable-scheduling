# Pemandu Tunanetra and Support Chat Samples Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Account accessibility settings with a blind-user camera guide that announces itself automatically, and make support chats display topic-specific sample data both before and inside the conversation.

**Architecture:** Reuse the existing camera guide route and controller. Pass an `autoVoice` route flag only from Account, expose one controller method for the startup announcement, and keep one-shot announcement state in the page. Keep support sample data in `SupportChatTopic`, so the chat setup page and conversation timeline render the same localized string.

**Tech Stack:** Flutter, Dart 3.11, Material, GoRouter, Flutter TTS, ARB localization, `flutter_test`.

## Global Constraints

- Remove the visible Account accessibility settings and internal `/aksesibilitas` route.
- Keep `accessibilityEnabled` in account models and backend contracts.
- Reuse `CameraGuidePage`; do not create a second camera implementation.
- Start the camera automatically and announce startup only after the camera becomes active when opened from Account.
- Use one source for each topic's `Data yang dikirim` text and the corresponding initial agent message.
- Preserve the existing keyword-based local chat replies.
- Run the finished app on an Android Pixel 9 emulator.

---

## File Structure

- `lib/features/profile/presentation/models/support_chat_topic.dart`: owns localized sample-data selection per support topic.
- `lib/features/profile/presentation/pages/help_chat_page.dart`: previews the selected topic's sample data.
- `lib/features/profile/presentation/pages/support_chat_conversation_page.dart`: inserts the same sample data as the third initial message.
- `lib/features/profile/presentation/pages/profile_page.dart`: exposes the new Pemandu Tunanetra menu.
- `lib/core/routing/router.dart`: removes the old route and forwards the Account-only voice flag.
- `lib/features/assistant/presentation/pages/camera_guide_page.dart`: triggers the startup announcement once after activation.
- `lib/features/assistant/presentation/controllers/camera_guide_controller.dart`: owns the TTS startup operation.
- `lib/l10n/app_*.arb` and generated `lib/l10n/app_localizations*.dart`: provide menu, announcement, received-data, and topic sample copy.
- `test/account_pages_test.dart`, `test/camera_guide_controller_test.dart`, and `test/widget_test.dart`: cover Account and camera behavior.
- `test/support_chat_pages_test.dart`: covers sample-data consistency for all topics.

---

### Task 1: Topic-specific support chat sample data

**Files:**
- Create: `test/support_chat_pages_test.dart`
- Modify: `lib/features/profile/presentation/models/support_chat_topic.dart`
- Modify: `lib/features/profile/presentation/pages/support_chat_conversation_page.dart`
- Modify: `lib/l10n/app_id.arb`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ar.arb`
- Modify: `lib/l10n/app_zh.arb`
- Modify: `lib/l10n/app_zh_Hans.arb`
- Regenerate: `lib/l10n/app_localizations.dart`
- Regenerate: `lib/l10n/app_localizations_id.dart`
- Regenerate: `lib/l10n/app_localizations_en.dart`
- Regenerate: `lib/l10n/app_localizations_ar.dart`
- Regenerate: `lib/l10n/app_localizations_zh.dart`

**Interfaces:**
- Consumes: `SupportChatTopic.sharedData(AppLocalizations l10n)`.
- Produces: `AppLocalizations.chatReceivedData(String data)` and concrete multiline values from `SupportChatTopic.sharedData`.

- [ ] **Step 1: Write failing widget tests for all three topics**

Create a localized test app that opens `HelpChatPage`, selects each topic, records the `HelpFieldCard` value, opens the conversation, and expects both the preview text and `Data yang diterima:\n<same text>` in the timeline. Use these Indonesian sample values:

```dart
const samples = <String, String>{
  'Tiket': 'Kode tiket: TKT-20260827-001\nRute: Manggarai – Tanah Abang\nTanggal perjalanan: 27 Agustus 2026\nStatus: Aktif',
  'Jadwal': 'Stasiun asal: Manggarai\nTujuan: Jakarta Kota\nNomor kereta: KA 1184\nKeberangkatan: 10.25 WIB\nPeron: 3',
  'Pembayaran': 'ID transaksi: TRX-20260827-001\nMetode: QRIS\nNominal: Rp7.800\nWaktu: 27 Agustus 2026, 10.20 WIB\nStatus: Berhasil',
};
```

- [ ] **Step 2: Run the new tests and confirm failure**

Run: `flutter test test/support_chat_pages_test.dart`

Expected: FAIL because current shared-data strings are generic and the conversation omits a received-data message.

- [ ] **Step 3: Replace generic shared data with concrete localized samples**

Update `topicTicketShared`, `topicScheduleShared`, and `topicPaymentShared` in every ARB catalog. Add this parameterized message and its placeholder metadata:

```json
"chatReceivedData": "Data yang diterima:\n{data}",
"@chatReceivedData": {
  "placeholders": {
    "data": { "type": "String" }
  }
}
```

Translate the label and field names for English, Arabic, and Chinese while retaining the same dummy identifiers, route, date, times, amount, and status meaning.

- [ ] **Step 4: Regenerate localizations**

Run: `flutter gen-l10n`

Expected: generated localization classes expose `String chatReceivedData(String data)` and compile without untranslated-message errors.

- [ ] **Step 5: Add the received-data message to the initial timeline**

Change `_initialMessages` to use one `sharedData` local variable and append the agent message:

```dart
final sharedData = widget.topic.sharedData(l10n);
return [
  _SupportMessage(author: _SupportMessageAuthor.user, text: widget.topic.openingMessage(l10n)),
  _SupportMessage(author: _SupportMessageAuthor.agent, text: widget.topic.greeting(l10n)),
  _SupportMessage(author: _SupportMessageAuthor.agent, text: l10n.chatReceivedData(sharedData)),
];
```

- [ ] **Step 6: Run the support chat tests**

Run: `flutter test test/support_chat_pages_test.dart`

Expected: PASS for ticket, schedule, and payment.

- [ ] **Step 7: Commit the chat deliverable**

```powershell
git add lib/features/profile/presentation/models/support_chat_topic.dart lib/features/profile/presentation/pages/support_chat_conversation_page.dart lib/l10n test/support_chat_pages_test.dart
git commit -m "feat: add support chat sample data"
```

### Task 2: Replace Account accessibility with Pemandu Tunanetra

**Files:**
- Modify: `test/account_pages_test.dart`
- Modify: `test/widget_test.dart`
- Modify: `lib/features/profile/presentation/pages/profile_page.dart`
- Modify: `lib/core/routing/router.dart`
- Delete: `lib/features/profile/presentation/pages/accessibility_page.dart`
- Modify and regenerate: localization files listed in Task 1.

**Interfaces:**
- Consumes: GoRouter route `/asisten/pemandu-kamera`.
- Produces: Account navigation URL `/asisten/pemandu-kamera?autoVoice=true` and localized `profileBlindGuide` / `profileBlindGuideDescription` strings.

- [ ] **Step 1: Write failing Account tests**

Add assertions that `ProfilePage` contains `Pemandu Tunanetra`, contains no `Aksesibilitas`, and uses a tappable menu entry. In the router-backed widget test, tap the new menu and assert:

```dart
expect(appRouter.routeInformationProvider.value.uri.path, '/asisten/pemandu-kamera');
expect(appRouter.routeInformationProvider.value.uri.queryParameters['autoVoice'], 'true');
```

- [ ] **Step 2: Run the Account tests and confirm failure**

Run: `flutter test test/account_pages_test.dart test/widget_test.dart --plain-name "Account"`

Expected: FAIL because the old Aksesibilitas entry and route remain.

- [ ] **Step 3: Add localized Account menu copy**

Add `profileBlindGuide` and `profileBlindGuideDescription` to all ARB catalogs. The Indonesian values are:

```json
"profileBlindGuide": "Pemandu Tunanetra",
"profileBlindGuideDescription": "Buka kamera dengan panduan suara otomatis"
```

Run: `flutter gen-l10n`

- [ ] **Step 4: Replace the menu entry**

Use the blind-user icon and deep-link:

```dart
_MenuEntry(
  icon: Icons.blind_rounded,
  title: l10n.profileBlindGuide,
  subtitle: l10n.profileBlindGuideDescription,
  onTap: () => context.push('/asisten/pemandu-kamera?autoVoice=true'),
),
```

- [ ] **Step 5: Remove the old settings route and page**

Remove the `accessibility_page.dart` import and `/aksesibilitas` `GoRoute` from `router.dart`, then delete `accessibility_page.dart`. Do not change account entities, repositories, API payloads, or `accessibilityEnabled` fields.

- [ ] **Step 6: Run Account tests**

Run: `flutter test test/account_pages_test.dart test/widget_test.dart --plain-name "Account"`

Expected: PASS with the new menu and query parameter.

- [ ] **Step 7: Commit the Account deliverable**

```powershell
git add lib/core/routing/router.dart lib/features/profile/presentation/pages/profile_page.dart lib/features/profile/presentation/pages/accessibility_page.dart lib/l10n test/account_pages_test.dart test/widget_test.dart
git commit -m "feat: replace accessibility menu with blind guide"
```

### Task 3: Announce camera guide activation from Account

**Files:**
- Modify: `test/camera_guide_controller_test.dart`
- Modify: `lib/features/assistant/presentation/controllers/camera_guide_controller.dart`
- Modify: `lib/features/assistant/presentation/pages/camera_guide_page.dart`
- Modify: `lib/core/routing/router.dart`
- Modify and regenerate: localization files listed in Task 1.

**Interfaces:**
- Produces: `CameraGuidePage({CameraGuideController? controller, bool autoAnnounce = false})`.
- Produces: `Future<void> CameraGuideController.announceGuideActive(String message)`.
- Consumes: router query parameter `autoVoice == 'true'`.

- [ ] **Step 1: Write failing one-shot announcement tests**

Extend the tracking controller with `announceCalls` and override `announceGuideActive`. Pump `CameraGuidePage(controller: controller, autoAnnounce: true)`, transition the controller from loading to active twice, and assert `announceCalls == 1`. Pump another page with `autoAnnounce: false`, transition to active, and assert `announceCalls == 0`.

```dart
controller.state = CameraGuideState.active;
controller.notifyListeners();
await tester.pump();
expect(controller.announceCalls, 1);
```

- [ ] **Step 2: Run the camera guide tests and confirm failure**

Run: `flutter test test/camera_guide_controller_test.dart`

Expected: FAIL because the page and controller do not expose auto-announcement APIs.

- [ ] **Step 3: Add the localized startup message**

Add `cameraGuideActiveAnnouncement` to all ARB catalogs. The Indonesian value is `Pemandu kamera aktif. Arahkan kamera ke depan.` Regenerate with `flutter gen-l10n`.

- [ ] **Step 4: Expose the controller announcement operation**

Add a narrow public method that delegates to the existing TTS path:

```dart
Future<void> announceGuideActive(String message) async {
  _announce(message);
}
```

Keep `_announce` responsible for updating the visible message, setting `id-ID`, speaking, and applying the existing cooldown.

- [ ] **Step 5: Trigger the announcement once after activation**

Add `autoAnnounce` to `CameraGuidePage`. In `_refresh`, set a `_didAutoAnnounce` guard before calling the controller when `state == CameraGuideState.active`. Use `AppLocalizations.of(context)!.cameraGuideActiveAnnouncement`; add the localization import to the page.

- [ ] **Step 6: Forward the router query flag**

Change the camera guide route builder to:

```dart
builder: (context, state) => CameraGuidePage(
  autoAnnounce: state.uri.queryParameters['autoVoice'] == 'true',
),
```

- [ ] **Step 7: Run camera and Account navigation tests**

Run: `flutter test test/camera_guide_controller_test.dart test/account_pages_test.dart`

Expected: PASS; one announcement from the Account link, none from the default constructor.

- [ ] **Step 8: Commit the camera deliverable**

```powershell
git add lib/core/routing/router.dart lib/features/assistant/presentation/controllers/camera_guide_controller.dart lib/features/assistant/presentation/pages/camera_guide_page.dart lib/l10n test/camera_guide_controller_test.dart
git commit -m "feat: announce blind camera guide activation"
```

### Task 4: Full verification and Pixel 9 review run

**Files:**
- Modify only files needed to correct verification failures introduced by Tasks 1–3.

**Interfaces:**
- Consumes: completed Account, camera guide, and support chat changes.
- Produces: formatted, analyzed, tested app running on Pixel 9.

- [ ] **Step 1: Format changed Dart files**

Run: `dart format lib test`

Expected: formatter exits successfully.

- [ ] **Step 2: Run static analysis**

Run: `flutter analyze`

Expected: `No issues found!`

- [ ] **Step 3: Run focused tests**

Run: `flutter test test/support_chat_pages_test.dart test/account_pages_test.dart test/camera_guide_controller_test.dart`

Expected: all focused tests pass.

- [ ] **Step 4: Run the full Flutter test suite**

Run: `flutter test`

Expected: all tests pass.

- [ ] **Step 5: Confirm or create the Pixel 9 emulator**

First resolve the Flutter SDK path because this PowerShell session does not currently expose `flutter` on `PATH`. Check the project IDE configuration and common local SDK locations, then invoke the discovered `flutter.bat` by its absolute path for every Flutter command. Run its `emulators` and `devices` subcommands.

If a Pixel 9 AVD exists, copy the exact emulator ID printed by the `emulators` subcommand and pass it to `flutter emulators --launch`. If Android tooling has no Pixel 9 AVD, inspect `emulator -list-avds`, create a Pixel 9 AVD from an installed Android system image with `avdmanager`, and launch it. Wait until `adb shell getprop sys.boot_completed` returns `1`.

- [ ] **Step 6: Run the application on Pixel 9**

Run `flutter devices`, copy the exact Android device ID shown for the booted Pixel 9, then pass that value to `flutter run -d` with `--dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1`.

Expected: Flutter installs the debug build and reports the application running. Keep the run session active for user review.

- [ ] **Step 7: Inspect the launched UI**

Open Account, verify `Pemandu Tunanetra`, open it, grant camera permission if Android asks, and verify the startup announcement path. Return to Account, open Pusat Bantuan → Chat petugas, and verify topic-specific `Data yang dikirim` and the matching received-data bubble.

- [ ] **Step 8: Commit verification corrections if any**

Inspect `git diff --name-only`, stage only files from Tasks 1–3 that needed a verification correction, and commit them with `git commit -m "test: verify blind guide and support chat"`. Skip this commit when verification requires no correction.

### Task 5: Separate Blind Guide activation card

This revision supersedes Task 2's placement of Blind Guide inside the general Account menu. The existing route and automatic camera announcement remain unchanged.

**Files:**
- Modify: `lib/features/profile/presentation/pages/profile_page.dart`
- Modify: `test/account_pages_test.dart`
- Modify: `test/widget_test.dart`

**Interfaces:**
- Consumes: `/asisten/pemandu-kamera?autoVoice=true` from Task 2.
- Produces: a widget keyed `blind-guide-card`, a switch keyed `blind-guide-switch`, and a momentary activation flow that resets after `context.push` completes.

- [ ] **Step 1: Write failing layout and switch tests**

In `account_pages_test.dart`, use a 430×1000 surface and verify the general card ends with Help Center, `blind-guide-card` is a separate Material surface below `account-menu-section`, and `blind-guide-switch` is off:

```dart
final menuBottom = tester.getBottomLeft(
  find.byKey(const ValueKey('account-menu-section')),
).dy;
final guideTop = tester.getTopLeft(
  find.byKey(const ValueKey('blind-guide-card')),
).dy;
expect(guideTop, greaterThan(menuBottom));
expect(
  tester.widget<Switch>(find.byKey(const ValueKey('blind-guide-switch'))).value,
  isFalse,
);
```

Update the router-backed Account test in `widget_test.dart`: activate the switch, verify the camera URL contains `autoVoice=true`, pop the route before rendering the camera page, pump, and verify the switch returns to false.

- [ ] **Step 2: Run tests and confirm failure**

Run: `flutter test test/account_pages_test.dart test/widget_test.dart --plain-name "Blind Guide"`

Expected: FAIL because Blind Guide still belongs to `account-menu-section` and no keyed switch exists.

- [ ] **Step 3: Remove Blind Guide from the general menu**

Keep only ticket history, language, and Help Center in `_ProfileMenuSection.entries`. Remove its Blind Guide `_MenuEntry`.

- [ ] **Step 4: Implement the momentary activation card**

Add a private stateful `_BlindGuideCard`. Make its full Material/InkWell row a semantic switch and include the visual `Switch`:

```dart
Future<void> _activate() async {
  if (_active) return;
  setState(() => _active = true);
  await context.push('/asisten/pemandu-kamera?autoVoice=true');
  if (mounted) setState(() => _active = false);
}
```

Use `ValueKey('blind-guide-card')` on the outer Material and `ValueKey('blind-guide-switch')` on the switch. Both tapping the row and changing the switch to true call `_activate`; changing it to false does nothing because navigation immediately owns the active state.

- [ ] **Step 5: Preserve signed-in logout order**

Render the general menu without logout, then `_BlindGuideCard`, then a separate logout-only `_ProfileMenuSection` when the user is signed in. Keep `ValueKey('account-logout')` on the logout row so existing account tests retain their contract.

- [ ] **Step 6: Run focused tests**

Run: `flutter test test/account_pages_test.dart test/widget_test.dart --plain-name "Blind Guide"`

Expected: PASS for card placement, initial switch state, navigation, and reset.

- [ ] **Step 7: Format, analyze, and run the full suite**

Run `dart format lib/features/profile/presentation/pages/profile_page.dart test/account_pages_test.dart test/widget_test.dart`, then `flutter analyze`, then `flutter test`.

Expected: analyzer reports no issues and all tests pass.

- [ ] **Step 8: Commit and hot reload Pixel 9**

```powershell
git add lib/features/profile/presentation/pages/profile_page.dart test/account_pages_test.dart test/widget_test.dart
git commit -m "feat: separate blind guide activation card"
```

Send `r` to the active Flutter run session. If that session ended, run the app again on `emulator-5554` with `--dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1`.

### Task 6: Keep concrete dummy values inside the conversation

This revision supersedes Task 1's requirement that `Data yang dikirim` and `Data yang diterima` use the same concrete string. The setup page now lists field categories only; concrete values remain in chat.

**Files:**
- Modify: `test/support_chat_pages_test.dart`
- Modify: `lib/features/profile/presentation/models/support_chat_topic.dart`
- Modify: `lib/features/profile/presentation/pages/support_chat_conversation_page.dart`
- Modify and regenerate: `lib/l10n/app_*.arb` and `lib/l10n/app_localizations*.dart`

**Interfaces:**
- Keeps: `SupportChatTopic.sharedData(AppLocalizations l10n)` for generic field descriptions.
- Produces: `SupportChatTopic.sampleData(AppLocalizations l10n)` for concrete dummy values.

- [ ] **Step 1: Change tests to require generic setup text and concrete chat text**

Expect `HelpChatPage` to show the original summaries:

```dart
const summaries = <SupportChatTopic, String>{
  SupportChatTopic.ticket: 'Mode tamu, ID tiket, dan rute terakhir',
  SupportChatTopic.schedule: 'Rute terakhir, stasiun asal-tujuan, dan waktu perjalanan',
  SupportChatTopic.payment: 'Status transaksi terakhir, kode tiket, dan waktu pembayaran',
};
```

For each topic, also expect its concrete sample to be absent from `HelpChatPage` and present in `SupportChatConversationPage` under `Data yang diterima`.

- [ ] **Step 2: Run the support chat tests and confirm failure**

Run: `flutter test test/support_chat_pages_test.dart`

Expected: FAIL because `sharedData` currently contains concrete values.

- [ ] **Step 3: Restore generic shared-data strings and add sample-data strings**

Restore `topicTicketShared`, `topicScheduleShared`, and `topicPaymentShared` in every language. Add localized `topicTicketSampleData`, `topicScheduleSampleData`, and `topicPaymentSampleData` keys containing the concrete values currently stored in the shared-data keys.

- [ ] **Step 4: Expose sample data per topic**

Add this extension method:

```dart
String sampleData(AppLocalizations l10n) {
  return switch (this) {
    SupportChatTopic.ticket => l10n.topicTicketSampleData,
    SupportChatTopic.schedule => l10n.topicScheduleSampleData,
    SupportChatTopic.payment => l10n.topicPaymentSampleData,
  };
}
```

- [ ] **Step 5: Use sample data only in the conversation**

Change `_initialMessages` to call `widget.topic.sampleData(l10n)` when building `chatReceivedData`. Leave `HelpChatPage` on `sharedData`.

- [ ] **Step 6: Generate, test, analyze, and commit**

Run `flutter gen-l10n`, `dart format` on changed Dart files, `flutter test test/support_chat_pages_test.dart`, `flutter analyze`, and `flutter test`. Commit with:

```powershell
git add lib/features/profile/presentation/models/support_chat_topic.dart lib/features/profile/presentation/pages/support_chat_conversation_page.dart lib/l10n test/support_chat_pages_test.dart
git commit -m "fix: keep support sample values inside chat"
```

- [ ] **Step 7: Hot restart Pixel 9 and verify**

Send `R` to the active Flutter run session, open Account → Help Center → Chat petugas, and verify setup summaries contain no concrete values while conversations do.
