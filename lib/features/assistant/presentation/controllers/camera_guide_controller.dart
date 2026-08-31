import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../../data/datasources/vision_guide_remote_data_source.dart';
import '../models/camera_guide_copy.dart';
import '../utils/nv21_jpeg_encoder.dart';

enum CameraGuideState {
  loading,
  active,
  permissionDenied,
  offline,
  error,
  stopped,
}

class CameraGuideController extends ChangeNotifier with WidgetsBindingObserver {
  CameraGuideController({
    CameraController? camera,
    FlutterTts? tts,
    VisionGuideRemoteDataSource? vision,
    CameraGuideCopy? copy,
  }) : _camera = camera,
       _tts = tts ?? FlutterTts(),
       _vision = vision ?? VisionGuideRemoteDataSource(),
       _copy = copy ?? CameraGuideCopy.indonesian();

  CameraController? _camera;
  final FlutterTts _tts;
  final VisionGuideRemoteDataSource _vision;
  ObjectDetector? _detector;
  Timer? _speechCooldown;
  DateTime? _lastVisionRequest;
  bool _visionBusy = false;
  bool _busy = false;
  bool _stopped = false;
  int _sessionId = 0;
  bool _observingLifecycle = false;
  bool _pausedByLifecycle = false;
  bool _disposed = false;
  Future<void>? _lifecyclePause;

  CameraGuideState state = CameraGuideState.loading;
  CameraGuideCopy _copy;
  String message = '';
  CameraController? get camera => _camera;
  CameraGuideCopy get copy => _copy;

  void configure(CameraGuideCopy value) {
    final previous = _copy;
    _copy = value;
    if (message.isEmpty || message == previous.loading) {
      message = value.loading;
    } else if (message == previous.active) {
      message = value.active;
    } else if (message == previous.unavailable) {
      message = value.unavailable;
    } else if (message == previous.offline) {
      message = value.offline;
    } else if (message == previous.stopped) {
      message = value.stopped;
    }
    _notifyIfMounted();
  }

  Future<void> start() async {
    _sessionId += 1;
    _stopped = false;
    _busy = false;
    _visionBusy = false;
    if (!_observingLifecycle) {
      WidgetsBinding.instance.addObserver(this);
      _observingLifecycle = true;
    }
    if (_camera != null) {
      await _startDetectorAndStream();
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('NoCamera', copy.unavailable);
      }
      _camera = CameraController(
        cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        ),
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      await _camera!.initialize();
      await _startDetectorAndStream();
    } on CameraException catch (error) {
      await _camera?.dispose();
      _camera = null;
      state =
          error.code == 'CameraAccessDenied' ||
              error.code == 'CameraAccessRestricted'
          ? CameraGuideState.permissionDenied
          : CameraGuideState.error;
      message = copy.unavailable;
      _notifyIfMounted();
    } catch (_) {
      await _camera?.dispose();
      _camera = null;
      state = CameraGuideState.error;
      message = copy.unavailable;
      _notifyIfMounted();
    }
  }

  Future<void> restart() async {
    await stop();
    state = CameraGuideState.loading;
    message = copy.loading;
    _notifyIfMounted();
    await start();
  }

  Future<void> _startDetectorAndStream() async {
    _detector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.stream,
        classifyObjects: true,
        multipleObjects: true,
      ),
    );
    await _camera!.startImageStream(_processImage);
    state = CameraGuideState.active;
    message = copy.active;
    _notifyIfMounted();
  }

  Future<void> _processImage(CameraImage image) async {
    if (_busy || _stopped || _detector == null || _camera == null) return;
    final sessionId = _sessionId;
    _busy = true;
    try {
      _sendRemoteVisionIfDue(image, sessionId: sessionId);
      final input = _inputImageFromCameraImage(image);
      if (input == null) return;
      final objects = await _detector!.processImage(input);
      if (_stopped || sessionId != _sessionId) return;
      if (objects.isEmpty) {
        _announce(copy.noClearObject);
        return;
      }
      final labels = objects
          .expand((object) => object.labels.map((label) => label.text))
          .where((label) => label.isNotEmpty)
          .take(2)
          .toList(growable: false);
      final description = labels.isEmpty
          ? copy.objectCount(objects.length)
          : copy.labelsDetected(labels);
      _announce(description);
    } catch (_) {
      if (_stopped || sessionId != _sessionId) return;
      state = CameraGuideState.offline;
      message = copy.offline;
      _notifyIfMounted();
    } finally {
      if (sessionId == _sessionId) _busy = false;
    }
  }

  void _sendRemoteVisionIfDue(CameraImage image, {required int sessionId}) {
    if (!Platform.isAndroid || _visionBusy || image.planes.length != 1) return;
    final now = DateTime.now();
    if (_lastVisionRequest != null &&
        now.difference(_lastVisionRequest!) < const Duration(seconds: 8)) {
      return;
    }
    final bytes = image.planes.first.bytes;
    if (bytes.isEmpty) return;
    _lastVisionRequest = now;
    _visionBusy = true;
    unawaited(
      _requestRemoteVision(
        Uint8List.fromList(bytes),
        width: image.width,
        height: image.height,
        rotationDegrees: _camera?.description.sensorOrientation ?? 0,
        sessionId: sessionId,
      ),
    );
  }

  Future<void> _requestRemoteVision(
    Uint8List nv21Bytes, {
    required int width,
    required int height,
    required int rotationDegrees,
    required int sessionId,
  }) async {
    try {
      final jpegBytes = await Isolate.run(
        () => encodeNv21ToJpeg(
          nv21Bytes,
          width: width,
          height: height,
          rotationDegrees: rotationDegrees,
        ),
      );
      if (jpegBytes.length > 1_048_576) return;
      final result = await _vision.analyzeJpeg(
        jpegBytes,
        languageTag: copy.languageTag,
      );
      if (result != null && !_stopped && sessionId == _sessionId) {
        _announce(result.spokenText);
      }
    } catch (_) {
      // Local ML Kit remains active when the backend is unavailable.
    } finally {
      if (sessionId == _sessionId) _visionBusy = false;
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final controller = _camera;
    if (controller == null) return null;
    final rotation = InputImageRotationValue.fromRawValue(
      controller.description.sensorOrientation,
    );
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (rotation == null || format == null || image.planes.length != 1) {
      return null;
    }
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  void _announce(String value) {
    message = value;
    _notifyIfMounted();
    if (_speechCooldown?.isActive ?? false) return;
    _tts.setLanguage(copy.languageTag);
    _tts.speak(value);
    _speechCooldown = Timer(const Duration(seconds: 4), () {});
  }

  Future<void> announceGuideActive(String value) async {
    _announce(value);
  }

  Future<void> stop() async {
    _pausedByLifecycle = false;
    await _stopCamera(removeLifecycleObserver: true);
    message = copy.stopped;
    _notifyIfMounted();
  }

  Future<void> _stopCamera({required bool removeLifecycleObserver}) async {
    _sessionId += 1;
    _stopped = true;
    _busy = false;
    _visionBusy = false;
    if (removeLifecycleObserver && _observingLifecycle) {
      WidgetsBinding.instance.removeObserver(this);
      _observingLifecycle = false;
    }
    _speechCooldown?.cancel();
    final camera = _camera;
    if (camera?.value.isStreamingImages ?? false) {
      await camera!.stopImageStream();
    }
    await _detector?.close();
    await camera?.dispose();
    _camera = null;
    state = CameraGuideState.stopped;
    _notifyIfMounted();
  }

  void _notifyIfMounted() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _resumeAfterLifecyclePause() async {
    await _lifecyclePause;
    if (_pausedByLifecycle) return;
    await restart();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (this.state == CameraGuideState.active &&
        (state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive)) {
      _pausedByLifecycle = true;
      _lifecyclePause = _stopCamera(removeLifecycleObserver: false);
      unawaited(_lifecyclePause);
      return;
    }
    if (state == AppLifecycleState.resumed && _pausedByLifecycle) {
      _pausedByLifecycle = false;
      unawaited(_resumeAfterLifecyclePause());
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(stop());
    _tts.stop();
    _vision.close();
    super.dispose();
  }
}
