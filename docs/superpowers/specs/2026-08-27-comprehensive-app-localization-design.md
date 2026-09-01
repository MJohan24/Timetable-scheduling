# Comprehensive App Localization Design

## Goal

Make every user-facing app string and spoken app message follow the language selected in Account → Language. The supported languages remain Indonesian, English, Simplified Chinese, and Arabic.

## Scope

The localization audit covers all production Dart files under `lib/`, not only widgets that already import `AppLocalizations`. It includes:

- page titles, labels, buttons, tooltips, hints, badges, empty states, and loading states;
- dialogs, snackbars, validation messages, permissions, errors, and retry copy;
- accessibility semantics and screen-reader descriptions;
- controller and service messages displayed after asynchronous work;
- local camera-guide detections, camera status, safety guidance, and text-to-speech;
- user-facing units and phrases embedded in dummy schedules or local sample data;
- support, ticket, timetable, route, station, travel-alarm, authentication, home, assistant, and profile flows.

The audit excludes internal identifiers, API paths, query keys, storage keys, debug-only text, test descriptions, and source comments.

## Preserved Official Data

The app does not translate proper nouns or official identifiers. Station names such as `Manggarai` and `Jakarta Kota`, operator names such as KRL/MRT/LRT, train numbers, ticket codes, transaction IDs, platform numbers, currency values, and API-provided official names remain unchanged. The app translates labels and sentences around those values.

## Localization Architecture

All static user-facing copy lives in the existing ARB catalogs:

- `lib/l10n/app_id.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_zh.arb`
- `lib/l10n/app_zh_Hans.arb`
- `lib/l10n/app_ar.arb`

Widgets obtain copy from `AppLocalizations.of(context)!`. Messages that contain runtime values use typed ARB placeholders instead of string concatenation. The generated `AppLocalizations` files remain generated artifacts.

Controllers and domain services must not own Indonesian display sentences. They expose structured state, message identifiers, or raw official values. The presentation layer converts that state into localized copy. When a controller must speak immediately, its public operation receives a locale-aware message bundle or an explicit locale tag and localized phrase.

## Camera Guide

The camera guide localizes its title, back tooltip, status badge, permission guidance, safety warning, retry action, start/stop action, loading state, active state, offline state, error state, stopped state, empty-detection announcement, object-count announcement, and label-list announcement.

The camera guide maps app locales to TTS locales:

| App locale | TTS locale |
| --- | --- |
| Indonesian | `id-ID` |
| English | `en-US` |
| Simplified Chinese | `zh-CN` |
| Arabic | `ar-SA` |

The controller receives localized camera phrases from the page before it starts. It uses those phrases for status text and local detection narration. It sends the active language tag with remote vision requests so a capable backend can return matching spoken text. If the backend ignores the language, the app displays and speaks the returned text without runtime machine translation; local guidance remains localized.

ML Kit object labels may come from the detector in a language the SDK controls. The app localizes the surrounding sentence and preserves unknown detector labels rather than guessing a translation.

## Dynamic and Sample Data

Local sample models keep structured values where practical. Presentation helpers format durations, statuses, dates, and labels with the active localization. Official values remain data. Existing support-chat dummy values keep separate localized variants in ARB because they represent full sample sentences shown to the user.

API error descriptions do not pass directly to the interface when a stable app error category exists. The UI shows a localized category message and may preserve a safe official reference code separately. Unknown backend prose may appear only as a fallback when the app has no mapped category.

## Arabic Layout

Arabic copy is fully translated, but the application shell remains left-to-right. This preserves the current navigation order, back-button behavior, map orientation, and tested interaction layout. Text widgets may use their natural alignment where this does not reorder core navigation.

## Audit Guard

A source-level localization audit test scans production presentation and user-facing controller/service files for direct display strings. The test uses a small allowlist for official proper nouns, transport codes, internal identifiers, and non-display data. New user-facing hardcoded strings fail the test and must be moved into ARB.

The allowlist must name exact files and values. It must not exempt an entire feature directory or broad language pattern.

## Testing

Verification includes:

1. Catalog contract tests confirm identical keys, metadata, and placeholders across all five ARB files, including the synchronized Chinese fallback catalogs.
2. Widget tests render representative camera, ticket, route, station, home, assistant, and profile states in all four supported app locales.
3. Camera controller tests verify localized loading, active, empty-detection, offline, error, and stopped messages.
4. TTS tests verify `id-ID`, `en-US`, `zh-CN`, and `ar-SA` selection.
5. Remote vision tests verify the active language tag is sent with image analysis requests.
6. The hardcoded-string audit test prevents untranslated user-facing copy from returning.
7. `flutter analyze` and the full Flutter test suite must pass.

## Device Verification

After automated checks pass, run the current build on `emulator-5554` (Pixel 9). Change the language from Account → Language and inspect at least the Account, Camera Guide, Assistant, Home, Tickets, Schedule, route result, and Help Center flows. Confirm visible text, status changes, error states that can be safely simulated, accessibility labels, and camera TTS follow the selected language without restarting the app.

## Success Criteria

- Every user-facing app-owned string follows the selected language.
- Camera Guide text and app-owned speech use the selected language.
- Changing language updates active UI without an application restart.
- Proper nouns and official codes remain unchanged.
- Arabic translations do not reorder the application shell.
- Automated tests reject missing catalog entries and new hardcoded display strings.
- The app runs successfully on the Pixel 9 emulator after the change.
