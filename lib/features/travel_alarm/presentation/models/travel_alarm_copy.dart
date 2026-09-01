import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_id.dart';

class TravelAlarmCopy {
  const TravelAlarmCopy({
    required this.trainArrivesIn,
    required this.noActiveAlarm,
    required this.exitAt,
    required this.transferAt,
    required this.destinationFallback,
  });

  factory TravelAlarmCopy.fromL10n(AppLocalizations l10n) => TravelAlarmCopy(
    trainArrivesIn: l10n.travelAlarmTrainArrivesIn,
    noActiveAlarm: l10n.travelAlarmNoActive,
    exitAt: l10n.travelAlarmExitAt,
    transferAt: l10n.travelAlarmTransferAt,
    destinationFallback: l10n.travelAlarmDestinationFallback,
  );

  factory TravelAlarmCopy.indonesian() =>
      TravelAlarmCopy.fromL10n(AppLocalizationsId());

  final String Function(int minutes) trainArrivesIn;
  final String noActiveAlarm;
  final String Function(String destination, int stations) exitAt;
  final String Function(String station, int stations) transferAt;
  final String destinationFallback;
}
