# Assistant Wake Word Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the simulated assistant microphone with foreground Android speech recognition, the "Halo Asisten" trigger, a spoken destination prompt, backend submission, and spoken responses.

**Architecture:** Keep platform plugins behind an `AssistantVoiceService` interface and make `AssistantController` a deterministic state machine. `AssistantPage` bridges final destination transcripts into the existing `AssistantConversationController`, then returns its latest assistant response to the voice controller for TTS. Foreground lifecycle owns recognition and prevents TTS feedback into the wake-word listener.

**Tech Stack:** Flutter/Dart, `speech_to_text` 7.4.x, `flutter_tts`, Android runtime permissions, Flutter unit/widget tests.

---

### Task 1: Voice service contract and device adapter

**Files:**
- Create: `lib/features/assistant/domain/services/assistant_voice_service.dart`
- Create: `lib/features/assistant/data/services/device_assistant_voice_service.dart`
- Create: `test/device_assistant_voice_service_test.dart`
- Modify: `pubspec.yaml`
- Modify: `android/app/src/main/AndroidManifest.xml`

- [ ] Write a failing service contract test that expects recognized words and final-state callbacks to cross the adapter boundary.
- [ ] Run `flutter test test/device_assistant_voice_service_test.dart` and confirm failure because the service files do not exist.
- [ ] Define `AssistantVoiceResult(text, isFinal)` and methods `initialize`, `listen`, `stopListening`, `cancelListening`, `speak`, `stopSpeaking`, and `dispose`.
- [ ] Add `speech_to_text: ^7.4.0`; implement the adapter with one `SpeechToText` instance and the existing `FlutterTts` package.
- [ ] Add `RECORD_AUDIO`, Bluetooth speech permissions, and the `android.speech.RecognitionService` query to the Android manifest.
- [ ] Run the focused test and confirm it passes.

### Task 2: Wake-word state machine

**Files:**
- Modify: `lib/features/assistant/presentation/controllers/assistant_controller.dart`
- Modify: `lib/features/assistant/presentation/models/assistant_copy.dart`
- Modify: `test/assistant_controller_test.dart`

- [ ] Replace the timer-based tests with a fake voice service and write failing tests for normalized wake-word detection, spoken prompt ordering, destination capture, TTS-before-listen sequencing, manual microphone start, restart after recognizer completion, and recoverable errors.
- [ ] Run `flutter test test/assistant_controller_test.dart` and verify the new tests fail against the simulated controller.
- [ ] Add explicit voice phases for wake listening, destination listening, processing, response speaking, and paused lifecycle behavior while retaining existing public UI states.
- [ ] Implement the prompt text `Halo, kamu mau melakukan perjalanan ke mana?` through localized `AssistantCopy`.
- [ ] Make `toggleWakeWord`, `startConversation`, lifecycle pause/resume, `speakResponse`, and disposal serialize microphone/TTS operations and ignore stale callbacks with a session token.
- [ ] Run the focused controller tests and confirm all pass.

### Task 3: Connect recognized destination to backend response

**Files:**
- Modify: `lib/features/assistant/presentation/pages/assistant_page.dart`
- Modify: `lib/features/assistant/presentation/controllers/assistant_conversation_controller.dart`
- Modify: `test/assistant_conversation_controller_test.dart`
- Modify: `test/widget_test.dart`

- [ ] Write failing tests proving a voice transcript uses `submitText`, preserves its language code, returns the appended assistant reply, and causes that reply to be spoken once.
- [ ] Run the focused tests and verify expected failures.
- [ ] Change `submitText` to return the assistant reply used for that submission without changing the conversation DTOs.
- [ ] In `AssistantPage`, register the destination callback, await backend submission, pass the reply to `speakResponse`, and route app lifecycle changes into the controller.
- [ ] Keep typed messages silent and preserve the existing text/voice shared timeline.
- [ ] Run the focused conversation and widget tests and confirm they pass.

### Task 4: Localization and generated output

**Files:**
- Modify: `lib/l10n/app_id.arb`
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ar.arb`
- Modify: `lib/l10n/app_zh.arb`
- Modify: `lib/l10n/app_zh_Hans.arb`
- Regenerate: `lib/l10n/app_localizations*.dart`

- [ ] Add localized wake prompt, microphone unavailable, permission denied, and no-speech copy with the exact Indonesian prompt approved by the user.
- [ ] Run `flutter gen-l10n` and verify generated getters compile.
- [ ] Run localization/widget tests and confirm all supported locales build.

### Task 5: Full verification and physical Android test

**Files:**
- Modify only if a reproduced device-specific defect requires it.

- [ ] Run `flutter analyze` and require zero errors.
- [ ] Run `flutter test` and require the entire suite to pass.
- [ ] Build/install the current debug app with the hosted API URL on device `RRCX109Z1EV`.
- [ ] Grant/verify microphone permission, open Asisten, enable wake word, say "Halo Asisten", verify the approved prompt is audible, answer a destination, and verify backend answer plus TTS.
- [ ] Background and resume the app; verify microphone stops and foreground wake listening resumes only when enabled.
- [ ] Review `adb logcat` for speech/TTS exceptions, then commit and push the implementation to `MJohan-Dev3`.
