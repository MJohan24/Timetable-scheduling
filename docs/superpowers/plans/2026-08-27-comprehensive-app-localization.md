# Comprehensive App Localization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every app-owned user-facing string and spoken message follow the selected Indonesian, English, Simplified Chinese, or Arabic locale.

**Architecture:** Keep static and parameterized copy in the existing ARB catalogs. Replace display sentences in controllers and services with structured states or locale-aware copy objects, then translate at the presentation boundary. Add a source audit that rejects direct UI literals while allowing exact official names and transport identifiers.

**Tech Stack:** Flutter, Dart, `gen-l10n`, `flutter_test`, `flutter_tts`, `package:http`, ARB/ICU placeholders.

## Global Constraints

- Supported app locales are `id`, `en`, `zh-Hans`, and `ar`.
- Keep `app_zh.arb` synchronized with `app_zh_Hans.arb`.
- Preserve official station names, operator names, train numbers, ticket codes, transaction IDs, platform numbers, currency values, and API-provided official names.
- Keep the application shell left-to-right for Arabic.
- Use `id-ID`, `en-US`, `zh-CN`, and `ar-SA` for camera-guide TTS.
- Do not add runtime machine translation or a new package.
- Run `flutter gen-l10n` after every ARB change.
- Use `apply_patch` for source edits.

---

### Task 1: Locale-aware camera copy contract

**Files:**
- Create: `lib/features/assistant/presentation/models/camera_guide_copy.dart`
- Modify: `lib/features/assistant/presentation/controllers/camera_guide_controller.dart`
- Modify: `lib/features/assistant/presentation/pages/camera_guide_page.dart`
- Modify: `lib/features/assistant/data/datasources/vision_guide_remote_data_source.dart`
- Modify: `lib/l10n/app_id.arb`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_zh.arb`
- Modify: `lib/l10n/app_zh_Hans.arb`
- Modify: `lib/l10n/app_ar.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`
- Test: `test/camera_guide_controller_test.dart`
- Create: `test/camera_guide_page_test.dart`
- Create: `test/vision_guide_remote_data_source_test.dart`

**Interfaces:**
- Produces: `CameraGuideCopy.fromL10n(AppLocalizations l10n, Locale locale)`.
- Produces: `CameraGuideController.configure(CameraGuideCopy copy)`.
- Changes: `VisionGuideRemoteDataSource.analyzeJpeg(Uint8List bytes, {required String languageTag})`.

- [ ] **Step 1: Add failing tests for all four camera locales**

Add a fake TTS implementation and configure the controller with localized copy. Assert that an Indonesian start uses `id-ID`, English uses `en-US`, Chinese uses `zh-CN`, and Arabic uses `ar-SA`. In the page test, render `CameraGuidePage` through `localizedTestApp(locale: ...)` and assert localized title, safety warning, retry/start/stop labels, status text, tooltip, and semantics.

```dart
for (final entry in const <Locale, String>{
  Locale('id'): 'id-ID',
  Locale('en'): 'en-US',
  Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'): 'zh-CN',
  Locale('ar'): 'ar-SA',
}.entries) {
  test('${entry.key} configures camera TTS', () async {
    final tts = FakeFlutterTts();
    final controller = CameraGuideController(camera: camera, tts: tts)
      ..configure(copyFor(entry.key));
    await controller.announceGuideActive(controller.copy.active);
    expect(tts.language, entry.value);
  });
}
```

- [ ] **Step 2: Add a failing remote-vision language-header test**

```dart
test('vision request sends selected language', () async {
  final client = MockClient((request) async {
    expect(request.headers['Accept-Language'], 'zh-CN');
    return http.Response('{"data":{"spokenText":"前方安全","hazardLevel":"none"}}', 200);
  });
  await VisionGuideRemoteDataSource(client: client).analyzeJpeg(
    Uint8List.fromList(<int>[1, 2, 3]),
    languageTag: 'zh-CN',
  );
});
```

- [ ] **Step 3: Run camera tests and confirm failure**

Run: `C:\src\flutter\bin\flutter.bat test test\camera_guide_controller_test.dart test\camera_guide_page_test.dart test\vision_guide_remote_data_source_test.dart`

Expected: FAIL because `CameraGuideCopy`, `configure`, and `languageTag` do not exist and the page still contains Indonesian literals.

- [ ] **Step 4: Add camera ARB messages in all catalogs**

Add these exact keys with locale-appropriate translations and matching ICU placeholders: `cameraGuideTitle`, `cameraGuideBack`, `cameraGuideStatus`, `cameraGuideStateLoading`, `cameraGuideStateActive`, `cameraGuideStatePermissionDenied`, `cameraGuideStateOffline`, `cameraGuideStateError`, `cameraGuideStateStopped`, `cameraGuidePermissionRequired`, `cameraGuideSafetyWarning`, `cameraGuideRetry`, `cameraGuideStart`, `cameraGuideStop`, `cameraGuideLoadingMessage`, `cameraGuideActiveMessage`, `cameraGuideUnavailableMessage`, `cameraGuideOfflineMessage`, `cameraGuideStoppedMessage`, `cameraGuideNoClearObject`, `cameraGuideObjectCount`, and `cameraGuideLabelsDetected`.

Use these English templates for placeholder contracts:

```json
"cameraGuideStatus": "Camera status: {status}",
"cameraGuideObjectCount": "{count} objects detected ahead.",
"cameraGuideLabelsDetected": "{labels} detected ahead."
```

- [ ] **Step 5: Implement the camera copy object**

```dart
class CameraGuideCopy {
  const CameraGuideCopy({
    required this.languageTag,
    required this.loading,
    required this.active,
    required this.unavailable,
    required this.offline,
    required this.stopped,
    required this.noClearObject,
    required this.objectCount,
    required this.labelsDetected,
  });

  final String languageTag;
  final String loading;
  final String active;
  final String unavailable;
  final String offline;
  final String stopped;
  final String noClearObject;
  final String Function(int count) objectCount;
  final String Function(String labels) labelsDetected;
}
```

`fromL10n` maps the four app locales to the four exact TTS tags from Global Constraints and obtains every phrase from `AppLocalizations`.

- [ ] **Step 6: Remove camera literals and send the locale to vision/TTS**

Move the page's first configuration/start from `initState` into `didChangeDependencies`, call `configure` again when locale dependencies change, and keep only one camera start per page lifetime. Map `CameraGuideState` to localized badge copy in the page. Replace controller sentences with `copy` members and local object announcements with `copy.objectCount`/`copy.labelsDetected`. Set TTS language from `copy.languageTag`. Send the same tag as `Accept-Language` in the remote vision request.

- [ ] **Step 7: Generate, format, test, and commit**

Run:

```powershell
C:\src\flutter\bin\flutter.bat gen-l10n
C:\src\flutter\bin\dart.bat format lib\features\assistant test\camera_guide_controller_test.dart test\camera_guide_page_test.dart test\vision_guide_remote_data_source_test.dart
C:\src\flutter\bin\flutter.bat test test\camera_guide_controller_test.dart test\camera_guide_page_test.dart test\vision_guide_remote_data_source_test.dart
git add lib/features/assistant lib/l10n test/camera_guide_controller_test.dart test/camera_guide_page_test.dart test/vision_guide_remote_data_source_test.dart
git commit -m "feat: localize camera guide and speech"
```

---

### Task 2: Structured assistant and travel-alarm messages

**Files:**
- Create: `lib/features/assistant/presentation/models/assistant_copy.dart`
- Modify: `lib/features/assistant/presentation/controllers/assistant_controller.dart`
- Modify: `lib/features/assistant/presentation/controllers/assistant_conversation_controller.dart`
- Modify: `lib/features/assistant/presentation/pages/assistant_page.dart`
- Modify: `lib/features/assistant/presentation/widgets/assistant_conversation_timeline.dart`
- Modify: `lib/features/travel_alarm/presentation/controllers/travel_alarm_controller.dart`
- Modify: `lib/features/travel_alarm/presentation/widgets/travel_alarm_scope.dart`
- Modify: `lib/l10n/app_*.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`
- Test: `test/assistant_controller_test.dart`
- Test: `test/assistant_conversation_controller_test.dart`
- Test: `test/travel_alarm_controller_test.dart`
- Test: `test/widget_test.dart`

**Interfaces:**
- Produces: `AssistantCopy.fromL10n(AppLocalizations l10n)`.
- Produces: `TravelAlarmCopy.fromL10n(AppLocalizations l10n)`.
- Changes: assistant and alarm controllers receive copy objects through `configure` and never create Indonesian display sentences.

- [ ] **Step 1: Write failing locale-switch tests**

Configure the assistant with English, invoke the demo trip, and expect `I want to go to Manggarai from Setiabudi.` and `The fastest route takes 7 minutes. The train arrives in 5 minutes.` Configure the conversation controller in Chinese and assert its no-ticket, all-alarms-active, all-alarms-cancelled, and next-train responses are Chinese. Configure the alarm in Arabic and assert its train-arrival and destination reminders are Arabic while station names remain unchanged.

- [ ] **Step 2: Run focused tests and confirm failure**

Run: `C:\src\flutter\bin\flutter.bat test test\assistant_controller_test.dart test\assistant_conversation_controller_test.dart test\travel_alarm_controller_test.dart`

Expected: FAIL on current Indonesian controller strings.

- [ ] **Step 3: Add exact assistant/alarm message keys**

Add locale variants for: unknown destination, demo transcript, fastest-route summary, assistant unavailable, unknown command, no active ticket, no active alarm, all alarms cancelled, destination alarm already off, destination alarm disabled, all alarms active, train-arrival minutes, travel destination, travel transfer, destination fallback, camera-guide quick action, and assistant-message semantics. Use typed `{origin}`, `{destination}`, `{minutes}`, `{station}`, `{sender}`, and `{message}` placeholders.

- [ ] **Step 4: Implement copy objects and controller configuration**

```dart
class TravelAlarmCopy {
  const TravelAlarmCopy({
    required this.trainArrivesIn,
    required this.noActiveAlarm,
    required this.exitAt,
    required this.transferAt,
    required this.destinationFallback,
  });
  final String Function(int minutes) trainArrivesIn;
  final String noActiveAlarm;
  final String Function(String destination) exitAt;
  final String Function(String station) transferAt;
  final String destinationFallback;
}
```

Keep command matching compatible with existing Indonesian phrases and add localized quick-command aliases through `AssistantCopy.commandAliases`; do not translate user-entered text.

- [ ] **Step 5: Configure copies from localized widget dependencies**

In `AssistantPage.didChangeDependencies`, build both copy objects from current `AppLocalizations`, configure the assistant conversation controller and the shared alarm controller, and rebuild their current derived labels. `TravelAlarmScope` retains controller ownership only; it does not cache localized sentences.

- [ ] **Step 6: Generate, format, test, and commit**

Run the focused tests, then commit:

```powershell
git add lib/features/assistant lib/features/travel_alarm lib/l10n test/assistant_controller_test.dart test/assistant_conversation_controller_test.dart test/travel_alarm_controller_test.dart test/widget_test.dart
git commit -m "feat: localize assistant and alarm messages"
```

---

### Task 3: Tickets and timetable localization debt

**Files:**
- Modify: `lib/features/tickets/presentation/pages/tickets_page.dart`
- Modify: `lib/features/timetable/domain/services/schedule_status.dart`
- Modify: `lib/features/timetable/presentation/pages/timetable_page.dart`
- Modify: `lib/features/timetable/presentation/widgets/schedule_card.dart`
- Modify: `lib/l10n/app_*.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`
- Test: `test/ticket_checkout_page_test.dart`
- Test: `test/schedule_status_test.dart`
- Test: `test/schedule_card_status_test.dart`

**Interfaces:**
- Changes: `ScheduleStatus.fromSchedule` returns status kind and minutes, not a pretranslated `label`.
- Produces: `ScheduleStatus.localizedLabel(AppLocalizations l10n)` in the presentation layer.

- [ ] **Step 1: Add failing multilingual ticket and schedule tests**

Render empty, partial-failure, checkout, device-ticket, email-ticket, and ticket-detail states in English and Chinese. Assert translated history/reload/payment/status/retry/empty text and semantics. Test the five schedule kinds—upcoming, soon, now, passed, unavailable—against Indonesian, English, Chinese, and Arabic localization instances.

- [ ] **Step 2: Run focused tests and confirm untranslated strings**

Run: `C:\src\flutter\bin\flutter.bat test test\ticket_checkout_page_test.dart test\schedule_status_test.dart test\schedule_card_status_test.dart`

- [ ] **Step 3: Add ticket and schedule ARB entries**

Move every direct ticket/timetable UI literal found by the tests into ARB, including history tooltips, reload, checkout actions, status action, list semantics, partial-history failure, empty category, generic retry, arriving/departing phrases, platform labels, and unavailable status. Use `{email}`, `{count}`, `{minutes}`, and `{platform}` placeholders.

- [ ] **Step 4: Replace literal widgets and structure schedule state**

Replace all `const Text('...')`, tooltip strings, and semantic-label interpolations in the listed files with `l10n` calls. Refactor schedule status to:

```dart
enum ScheduleStatusKind { upcoming, soon, now, passed, unavailable }

class ScheduleStatus {
  const ScheduleStatus({required this.kind, this.minutes});
  final ScheduleStatusKind kind;
  final int? minutes;
}
```

Map this structure to localized text in `schedule_card.dart`.

- [ ] **Step 5: Generate, test, and commit**

```powershell
C:\src\flutter\bin\flutter.bat gen-l10n
C:\src\flutter\bin\flutter.bat test test\ticket_checkout_page_test.dart test\schedule_status_test.dart test\schedule_card_status_test.dart
git add lib/features/tickets lib/features/timetable lib/l10n test/ticket_checkout_page_test.dart test/schedule_status_test.dart test/schedule_card_status_test.dart
git commit -m "feat: complete ticket and schedule localization"
```

---

### Task 4: Home, departures, map controls, and station search

**Files:**
- Modify: `lib/features/home/presentation/pages/home_page.dart`
- Modify: `lib/features/home/presentation/pages/departure_detail_page.dart`
- Modify: `lib/features/home/presentation/pages/train_map_page.dart`
- Modify: `lib/features/home/presentation/widgets/map_widgets.dart`
- Modify: `lib/features/search_station/presentation/pages/search_station_page.dart`
- Modify: `lib/features/search_station/presentation/widgets/station_card.dart`
- Modify: `lib/features/search_station/domain/services/station_voice_guide.dart`
- Modify: `lib/l10n/app_*.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`
- Test: `test/train_map_location_test.dart`
- Test: `test/station_card_test.dart`
- Test: `test/station_voice_guide_test.dart`
- Test: `test/widget_test.dart`

**Interfaces:**
- Keeps official station and line names unchanged.
- Changes sample departures to store numeric minute values instead of strings such as `6 menit`.
- Changes `StationVoiceGuide` methods to receive localized formatters instead of producing Indonesian narration.

- [ ] **Step 1: Add failing multilingual tests**

Test area filters, station facilities, departure countdown/duration/platform labels, locate-me semantics, station empty/error/retry states, and voice-guide result/empty narration in English, Chinese, and Arabic. Assert station names remain `Manggarai`, `Jakarta Kota`, and `Tanah Abang`.

- [ ] **Step 2: Run focused tests and confirm failure**

Run: `C:\src\flutter\bin\flutter.bat test test\train_map_location_test.dart test\station_card_test.dart test\station_voice_guide_test.dart test\widget_test.dart`

- [ ] **Step 3: Add home/station ARB entries**

Add locale variants for the six area labels; eight facility labels; minute/duration/platform templates; locate-me semantics; departure details; station service/accessibility labels; station empty/error/retry copy; and voice result, limit, and empty announcements. Preserve station/operator values as placeholders.

- [ ] **Step 4: Replace formatted Indonesian sample values with structured numbers**

Change `_DepartureInfo` to hold `int arrivalMinutes` and `int durationMinutes`. Use `l10n.minutesValue(value)` at render time. Build area and facility label maps inside `build` from `l10n`, while keeping internal keys such as `bogor` and official facility capabilities unchanged.

- [ ] **Step 5: Localize station voice and map semantics**

Pass a locale-aware copy object to `StationVoiceGuide`. Replace `Temukan lokasi saya`, retry copy, accessibility summaries, and service descriptions with ARB calls. Keep map geometry and station-map data untouched.

- [ ] **Step 6: Generate, test, and commit**

```powershell
git add lib/features/home lib/features/search_station lib/l10n test/train_map_location_test.dart test/station_card_test.dart test/station_voice_guide_test.dart test/widget_test.dart
git commit -m "feat: localize home and station flows"
```

---

### Task 5: Route results, preview, and route speech

**Files:**
- Modify: `lib/features/route_result/presentation/controllers/route_controller.dart`
- Modify: `lib/features/route_result/presentation/pages/route_result_page.dart`
- Modify: `lib/features/route_result/presentation/pages/route_map_preview_page.dart`
- Modify: `lib/features/route_result/presentation/widgets/route_journey_timeline.dart`
- Modify: `lib/features/route_result/presentation/widgets/route_widgets.dart`
- Modify: `lib/features/route_result/data/services/native_route_speech_service.dart`
- Modify: `lib/l10n/app_*.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`
- Test: `test/route_controller_test.dart`
- Test: `test/route_result_page_test.dart`
- Test: `test/native_route_speech_service_test.dart`

**Interfaces:**
- Changes: `RouteController` exposes `RouteFailureKind` instead of a fixed Indonesian error sentence.
- Keeps: `RouteSpeechService.speak(String text, String languageCode)`.

- [ ] **Step 1: Add failing multilingual route tests**

Render loading, failure, retry, route overview, map-preview unavailable, preview header, back tooltip, journey steps, and line-map action in English, Chinese, and Arabic. Assert route speech receives the active language code and localized narration while official station names remain unchanged.

- [ ] **Step 2: Run route tests and confirm failure**

Run: `C:\src\flutter\bin\flutter.bat test test\route_controller_test.dart test\route_result_page_test.dart test\native_route_speech_service_test.dart`

- [ ] **Step 3: Add route ARB entries and structured failure state**

Add route preview title/unavailable/back, show-line-map, retry, generic load failure, journey transfer/walk/board/exit phrases, duration, stops, and accessible narration keys. Define:

```dart
enum RouteFailureKind { loadFailed }
```

Store `RouteFailureKind? failure` in the controller and translate it in `RouteResultPage`.

- [ ] **Step 4: Replace route literals and pass active speech locale**

Obtain `Localizations.localeOf(context)` when invoking speech, map it to `id-ID`, `en-US`, `zh-CN`, or `ar-SA`, and build narration from ARB placeholders. Do not change the route API model or map geometry.

- [ ] **Step 5: Generate, test, and commit**

```powershell
git add lib/features/route_result lib/l10n test/route_controller_test.dart test/route_result_page_test.dart test/native_route_speech_service_test.dart
git commit -m "feat: localize route guidance"
```

---

### Task 6: Residual app-wide display-string audit

**Files:**
- Create: `test/hardcoded_user_facing_strings_test.dart`
- Modify: `lib/features/profile/presentation/pages/support_chat_conversation_page.dart`
- Verify: `lib/features/profile/presentation/pages/active_ticket_detail_page.dart`
- Verify: `lib/main.dart`
- Modify: `lib/l10n/app_*.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`
- Test: `test/localization_catalog_test.dart`
- Test: `test/language_page_test.dart`
- Test: `test/support_chat_pages_test.dart`
- Test: `test/hardcoded_user_facing_strings_test.dart`

**Interfaces:**
- Produces: a regression test that rejects direct strings passed to `Text`, tooltip/hint/semantic fields, SnackBars, controller display-message assignments, and TTS calls.

- [ ] **Step 1: Create the source audit test**

```dart
final forbiddenPatterns = <RegExp>[
  RegExp(r'''(?:const\s+)?Text\(\s*['\"]([^'\"]+)['\"]'''),
  RegExp(r'''(?:tooltip|semanticLabel|hintText|helperText|errorText)\s*:\s*['\"]([^'\"]+)['\"]'''),
  RegExp(r'''\bmessage\s*=\s*['\"]([^'\"]+)['\"]'''),
  RegExp(r'''\.speak\(\s*['\"]([^'\"]+)['\"]'''),
];

const allowedExactValues = <String>{
  'KRL',
  'MRT',
  'LRT',
  'QRIS',
  'KRL-2407-0812',
  'KAI Access Prototype',
  'nama@email.com',
};
```

Scan production `.dart` files, skip generated localization files, and report `path:line:value` for every non-allowlisted match. The allowlist contains only the seven exact values above; official station names belong in data structures and must not be direct UI literals.

- [ ] **Step 2: Run the audit and confirm the support-chat semantics failure**

Run: `C:\src\flutter\bin\flutter.bat test test\hardcoded_user_facing_strings_test.dart`

Expected: FAIL on the direct `'$sender, ${message.text}'` semantics string in `support_chat_conversation_page.dart`. All direct UI strings from Tasks 1–5 must already be absent.

- [ ] **Step 3: Localize support-chat message semantics**

Add `chatMessageSemantics` with `{sender}` and `{message}` placeholders to every ARB catalog. Replace the direct interpolation with `l10n.chatMessageSemantics(sender, message.text)`. Keep `KRL-2407-0812` and `KAI Access Prototype` unchanged because they are exact official/product values in the allowlist.

- [ ] **Step 4: Verify catalog parity and all four language settings**

Run:

```powershell
C:\src\flutter\bin\flutter.bat gen-l10n
C:\src\flutter\bin\flutter.bat test test\hardcoded_user_facing_strings_test.dart test\localization_catalog_test.dart test\language_page_test.dart test\support_chat_pages_test.dart
```

Expected: all tests PASS; Chinese catalogs remain identical apart from `@@locale`, and Arabic/Chinese script coverage remains above 80 percent.

- [ ] **Step 5: Commit the residual cleanup and audit guard**

```powershell
git add lib test/hardcoded_user_facing_strings_test.dart test/localization_catalog_test.dart test/language_page_test.dart test/support_chat_pages_test.dart
git commit -m "test: prevent untranslated app copy"
```

---

### Task 7: Full verification and Pixel 9 review build

**Files:**
- Verify: all changed production and test files
- Output: `build/codex-localization-*.png`

**Interfaces:**
- Consumes: all localized UI, structured states, and speech locale contracts from Tasks 1–6.
- Produces: a clean analyzed/tested build running on `emulator-5554`.

- [ ] **Step 1: Format all changed Dart files and check diffs**

Run:

```powershell
C:\src\flutter\bin\dart.bat format lib test
git diff --check
git status --short
```

- [ ] **Step 2: Run static analysis and the complete suite**

Run:

```powershell
C:\src\flutter\bin\flutter.bat analyze
C:\src\flutter\bin\flutter.bat test
```

Expected: analyzer reports `No issues found` and every test passes.

- [ ] **Step 3: Run the application on Pixel 9**

Run:

```powershell
C:\src\flutter\bin\flutter.bat run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:3000/api/v1
```

- [ ] **Step 4: Verify locale changes without restart**

For each language, use Account → Language, then inspect Account, Camera Guide, Assistant, Home, Tickets, Schedule, route result, and Help Center. Capture at least one Account screenshot and one Camera Guide screenshot per locale under `build/codex-localization-<locale>-*.png`. Confirm camera status and app-owned spoken output use the selected language.

- [ ] **Step 5: Final repository checkpoint**

If device verification requires a source correction, repeat Task 7 Steps 1–4 and commit it as `fix: complete device localization`. Leave the verified app running on the Pixel 9 review screen and ensure `git status --short` is empty.
