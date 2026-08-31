import '../entities/station.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_ar.dart';
import '../../../../l10n/app_localizations_en.dart';
import '../../../../l10n/app_localizations_id.dart';
import '../../../../l10n/app_localizations_zh.dart';

String buildStationVoiceGuide(List<Station> stations, String languageCode) {
  final l10n = _copyFor(languageCode);
  if (stations.isEmpty) {
    return l10n.stationVoiceEmpty;
  }

  final details = stations.take(5).map((station) => station.name).join('. ');
  final count = stations.length;
  final summary = l10n.stationVoiceFound(count);
  return '$summary $details.';
}

AppLocalizations _copyFor(String languageCode) => switch (languageCode) {
  'en' => AppLocalizationsEn(),
  'zh' => AppLocalizationsZh(),
  'ar' => AppLocalizationsAr(),
  _ => AppLocalizationsId(),
};
