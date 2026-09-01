import 'package:flutter/widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_id.dart';

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

  factory CameraGuideCopy.fromL10n(AppLocalizations l10n, Locale locale) {
    final languageTag = switch (locale.languageCode) {
      'id' => 'id-ID',
      'zh' => 'zh-CN',
      'ar' => 'ar-SA',
      _ => 'en-US',
    };
    final separator = switch (locale.languageCode) {
      'id' => ' dan ',
      'zh' => '、',
      'ar' => ' و',
      _ => ' and ',
    };

    return CameraGuideCopy(
      languageTag: languageTag,
      loading: l10n.cameraGuideLoadingMessage,
      active: l10n.cameraGuideActiveMessage,
      unavailable: l10n.cameraGuideUnavailableMessage,
      offline: l10n.cameraGuideOfflineMessage,
      stopped: l10n.cameraGuideStoppedMessage,
      noClearObject: l10n.cameraGuideNoClearObject,
      objectCount: l10n.cameraGuideObjectCount,
      labelsDetected: (labels) =>
          l10n.cameraGuideLabelsDetected(labels.join(separator)),
    );
  }

  factory CameraGuideCopy.indonesian() =>
      CameraGuideCopy.fromL10n(AppLocalizationsId(), const Locale('id'));

  final String languageTag;
  final String loading;
  final String active;
  final String unavailable;
  final String offline;
  final String stopped;
  final String noClearObject;
  final String Function(int count) objectCount;
  final String Function(List<String> labels) labelsDetected;
}
