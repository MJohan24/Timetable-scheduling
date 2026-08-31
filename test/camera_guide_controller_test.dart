import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/assistant/presentation/controllers/camera_guide_controller.dart';
import 'package:timetable/features/assistant/presentation/pages/camera_guide_page.dart';

import 'helpers/localized_test_app.dart';

class _TrackingCameraGuideController extends CameraGuideController {
  int restartCalls = 0;
  int announceCalls = 0;

  @override
  Future<void> start() async {}

  @override
  Future<void> restart() async {
    restartCalls += 1;
  }

  @override
  Future<void> announceGuideActive(String message) async {
    announceCalls += 1;
  }

  void activate() {
    state = CameraGuideState.active;
    notifyListeners();
  }
}

void main() {
  testWidgets(
    'does not stop while the camera permission flow is still loading',
    (tester) async {
      final controller = CameraGuideController();

      controller.didChangeAppLifecycleState(AppLifecycleState.inactive);
      await tester.pump();

      expect(controller.state, CameraGuideState.loading);
    },
  );

  testWidgets('restarts after returning from a lifecycle pause', (
    tester,
  ) async {
    final controller = _TrackingCameraGuideController()
      ..state = CameraGuideState.active;

    controller.didChangeAppLifecycleState(AppLifecycleState.inactive);
    await tester.pump();
    expect(controller.state, CameraGuideState.stopped);

    controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();

    expect(controller.restartCalls, 1);
  });

  testWidgets('offers to start the guide when the camera is stopped', (
    tester,
  ) async {
    final controller = _TrackingCameraGuideController()
      ..state = CameraGuideState.stopped;

    await tester.pumpWidget(
      localizedTestApp(home: CameraGuidePage(controller: controller)),
    );

    expect(find.text('Mulai Pemandu'), findsOneWidget);
    await tester.tap(find.text('Mulai Pemandu'));
    await tester.pump();

    expect(controller.restartCalls, 1);
  });

  for (final localeAndLabels in const <(Locale, List<String>)>[
    (
      Locale('en'),
      <String>[
        'Camera Guide',
        'Stopped',
        'Detection can be wrong. Use a cane, companion, or ask staff for help.',
        'Start Guide',
      ],
    ),
    (
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      <String>['相机向导', '已停止', '检测结果可能有误。请使用手杖、由他人陪同或向工作人员求助。', '启动向导'],
    ),
    (
      Locale('ar'),
      <String>[
        'دليل الكاميرا',
        'متوقف',
        'قد يكون الاكتشاف غير دقيق. استخدم عصًا أو مرافقًا أو اطلب مساعدة الموظفين.',
        'بدء الدليل',
      ],
    ),
  ]) {
    testWidgets('camera guide follows ${localeAndLabels.$1}', (tester) async {
      final controller = _TrackingCameraGuideController()
        ..state = CameraGuideState.stopped;

      await tester.pumpWidget(
        localizedTestApp(
          locale: localeAndLabels.$1,
          home: CameraGuidePage(controller: controller),
        ),
      );

      for (final label in localeAndLabels.$2) {
        expect(find.text(label), findsOneWidget);
      }
    });
  }

  testWidgets('auto voice announces once when the camera becomes active', (
    tester,
  ) async {
    final controller = _TrackingCameraGuideController();

    await tester.pumpWidget(
      localizedTestApp(
        home: CameraGuidePage(controller: controller, autoAnnounce: true),
      ),
    );

    controller.activate();
    await tester.pump();
    controller.activate();
    await tester.pump();

    expect(controller.announceCalls, 1);
  });

  testWidgets('default camera access does not force a startup announcement', (
    tester,
  ) async {
    final controller = _TrackingCameraGuideController();

    await tester.pumpWidget(
      localizedTestApp(home: CameraGuidePage(controller: controller)),
    );

    controller.activate();
    await tester.pump();

    expect(controller.announceCalls, 0);
  });
}
