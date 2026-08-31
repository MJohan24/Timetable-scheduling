import '../entities/route_plan.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_ar.dart';
import '../../../../l10n/app_localizations_en.dart';
import '../../../../l10n/app_localizations_id.dart';
import '../../../../l10n/app_localizations_zh.dart';

abstract interface class RouteSpeechService {
  Future<void> speak(String text, String languageCode);
  Future<void> pause();
  Future<void> stop();
}

String _rupiah(int value) => value.toString().replaceAllMapped(
  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  (match) => '${match[1]}.',
);

String buildRouteNarration(RoutePlan route, String languageCode) {
  final l10n = _copyFor(languageCode);
  final currency = languageCode == 'id' && route.currency == 'IDR'
      ? 'Rp'
      : route.currency;
  final summary = l10n.routeNarrationSummary(
    route.from,
    route.to,
    route.travelTime,
    currency,
    _rupiah(route.fare),
  );
  final steps = route.steps
      .map(
        (step) =>
            '${[step.text, step.detailNote, step.durationText].where((part) => part.trim().isNotEmpty).join('. ')}.',
      )
      .join(' ');
  return '$summary $steps'.trim();
}

AppLocalizations _copyFor(String languageCode) => switch (languageCode) {
  'en' => AppLocalizationsEn(),
  'zh' => AppLocalizationsZh(),
  'ar' => AppLocalizationsAr(),
  _ => AppLocalizationsId(),
};
