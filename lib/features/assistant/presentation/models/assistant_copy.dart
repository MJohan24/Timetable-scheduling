import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_id.dart';

class AssistantCopy {
  const AssistantCopy({
    required this.unknownDestination,
    required this.demoTranscript,
    required this.demoResponse,
    required this.unavailable,
    required this.unknownCommand,
    required this.noActiveTicket,
    required this.noActiveAlarm,
    required this.allAlarmsCancelled,
    required this.destinationAlarmAlreadyOff,
    required this.destinationAlarmDisabled,
    required this.allAlarmsActive,
    required this.trainArrivesIn,
    required this.voiceDestinationPrompt,
    required this.voiceUnavailable,
    required this.voiceNoSpeech,
  });

  factory AssistantCopy.fromL10n(AppLocalizations l10n) => AssistantCopy(
    unknownDestination: l10n.assistantUnknownDestination,
    demoTranscript: l10n.assistantDemoTranscript,
    demoResponse: l10n.assistantDemoResponse,
    unavailable: l10n.assistantUnavailable,
    unknownCommand: l10n.assistantUnknownCommand,
    noActiveTicket: l10n.assistantNoActiveTicket,
    noActiveAlarm: l10n.assistantNoActiveAlarm,
    allAlarmsCancelled: l10n.assistantAllAlarmsCancelled,
    destinationAlarmAlreadyOff: l10n.assistantDestinationAlarmAlreadyOff,
    destinationAlarmDisabled: l10n.assistantDestinationAlarmDisabled,
    allAlarmsActive: l10n.assistantAllAlarmsActive,
    trainArrivesIn: l10n.travelAlarmTrainArrivesIn,
    voiceDestinationPrompt: l10n.assistantVoiceDestinationPrompt,
    voiceUnavailable: l10n.assistantVoiceUnavailable,
    voiceNoSpeech: l10n.assistantVoiceNoSpeech,
  );

  factory AssistantCopy.indonesian() =>
      AssistantCopy.fromL10n(AppLocalizationsId());

  final String unknownDestination;
  final String Function(String destination, String origin) demoTranscript;
  final String demoResponse;
  final String unavailable;
  final String unknownCommand;
  final String noActiveTicket;
  final String noActiveAlarm;
  final String allAlarmsCancelled;
  final String destinationAlarmAlreadyOff;
  final String destinationAlarmDisabled;
  final String allAlarmsActive;
  final String Function(int minutes) trainArrivesIn;
  final String voiceDestinationPrompt;
  final String voiceUnavailable;
  final String voiceNoSpeech;
}
