import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/camera_guide_controller.dart';
import '../models/camera_guide_copy.dart';

class CameraGuidePage extends StatefulWidget {
  const CameraGuidePage({
    super.key,
    this.controller,
    this.autoAnnounce = false,
  });

  final CameraGuideController? controller;
  final bool autoAnnounce;

  @override
  State<CameraGuidePage> createState() => _CameraGuidePageState();
}

class _CameraGuidePageState extends State<CameraGuidePage> {
  late final CameraGuideController _controller;
  late final bool _ownsController;
  bool _didAutoAnnounce = false;
  bool _didStart = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? CameraGuideController();
    _controller.addListener(_refresh);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _controller.configure(
      CameraGuideCopy.fromL10n(l10n, Localizations.localeOf(context)),
    );
    if (!_didStart) {
      _didStart = true;
      unawaited(_controller.start());
    }
  }

  void _refresh() {
    if (!mounted) return;
    if (widget.autoAnnounce &&
        !_didAutoAnnounce &&
        _controller.state == CameraGuideState.active) {
      _didAutoAnnounce = true;
      unawaited(
        _controller.announceGuideActive(
          AppLocalizations.of(context)!.cameraGuideActiveAnnouncement,
        ),
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      fit: StackFit.expand,
      children: [
        if (_controller.camera?.value.isInitialized ?? false)
          CameraPreview(_controller.camera!)
        else
          const ColoredBox(color: Colors.black),
        SafeArea(
          child: Column(
            children: [_header(context), const Spacer(), _statusPanel()],
          ),
        ),
      ],
    ),
  );

  Widget _header(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
    child: Row(
      children: [
        IconButton(
          tooltip: AppLocalizations.of(context)!.cameraGuideBack,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.cameraGuideTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Semantics(
          label: AppLocalizations.of(
            context,
          )!.cameraGuideStatus(_stateLabel(context)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _stateLabel(context),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  String _stateLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (_controller.state) {
      CameraGuideState.loading => l10n.cameraGuideStateLoading,
      CameraGuideState.active => l10n.cameraGuideStateActive,
      CameraGuideState.permissionDenied =>
        l10n.cameraGuideStatePermissionDenied,
      CameraGuideState.offline => l10n.cameraGuideStateOffline,
      CameraGuideState.error => l10n.cameraGuideStateError,
      CameraGuideState.stopped => l10n.cameraGuideStateStopped,
    };
  }

  Widget _statusPanel() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.state == CameraGuideState.permissionDenied
                ? l10n.cameraGuidePermissionRequired
                : _controller.message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cameraGuideSafetyWarning,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 14),
          if (_controller.state == CameraGuideState.permissionDenied ||
              _controller.state == CameraGuideState.error)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _controller.restart,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.cameraGuideRetry),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _controller.state == CameraGuideState.stopped
                  ? _controller.restart
                  : _controller.stop,
              icon: Icon(
                _controller.state == CameraGuideState.stopped
                    ? Icons.play_circle_outline_rounded
                    : Icons.stop_circle_outlined,
              ),
              label: Text(
                _controller.state == CameraGuideState.stopped
                    ? l10n.cameraGuideStart
                    : l10n.cameraGuideStop,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _controller.state == CameraGuideState.stopped
                    ? AppColors.primaryBlue
                    : AppColors.statusRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
