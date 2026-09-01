import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/assistant_controller.dart';

class AssistantVoicePanel extends StatelessWidget {
  const AssistantVoicePanel({
    super.key,
    required this.state,
    required this.onTap,
  });

  final AssistantInteractionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final presentation = _VoicePresentation.forState(state, l10n);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text(
            presentation.prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            presentation.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          Semantics(
            button: true,
            enabled: onTap != null,
            label: presentation.semanticLabel,
            value: presentation.prompt,
            onTap: onTap,
            child: ExcludeSemantics(
              child: Material(
                color: presentation.color,
                shape: const CircleBorder(),
                elevation: state == AssistantInteractionState.listening ? 1 : 4,
                shadowColor: presentation.color.withValues(alpha: 0.28),
                child: InkWell(
                  key: const Key('assistant-microphone-button'),
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: SizedBox(
                    width: 88,
                    height: 88,
                    child: Icon(
                      presentation.icon,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _VoiceLevelIndicator(
            active:
                state == AssistantInteractionState.listening ||
                state == AssistantInteractionState.speaking,
            color: presentation.color,
          ),
        ],
      ),
    );
  }
}

class _VoiceLevelIndicator extends StatelessWidget {
  const _VoiceLevelIndicator({required this.active, required this.color});

  final bool active;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const heights = [8.0, 15.0, 23.0, 15.0, 8.0];
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: heights
            .map(
              (height) => Container(
                width: 4,
                height: active ? height : 4,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: active ? color : AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _VoicePresentation {
  const _VoicePresentation({
    required this.prompt,
    required this.description,
    required this.semanticLabel,
    required this.icon,
    required this.color,
  });

  final String prompt;
  final String description;
  final String semanticLabel;
  final IconData icon;
  final Color color;

  factory _VoicePresentation.forState(
    AssistantInteractionState state,
    AppLocalizations l10n,
  ) {
    return switch (state) {
      AssistantInteractionState.ready => _VoicePresentation(
        prompt: l10n.voiceTapToSpeak,
        description: l10n.voiceWhereToToday,
        semanticLabel: l10n.voiceStartConversation,
        icon: Icons.mic_rounded,
        color: AppColors.primaryBlue,
      ),
      AssistantInteractionState.listening => _VoicePresentation(
        prompt: l10n.voiceListening,
        description: l10n.voicePleaseStateDestination,
        semanticLabel: l10n.voiceStopConversation,
        icon: Icons.stop_rounded,
        color: AppColors.accentOrange,
      ),
      AssistantInteractionState.processing => _VoicePresentation(
        prompt: l10n.voiceProcessingRequest,
        description: l10n.voiceSearchingForTrips,
        semanticLabel: l10n.voiceRequestBeingProcessed,
        icon: Icons.hourglass_top_rounded,
        color: AppColors.buttonDark,
      ),
      AssistantInteractionState.speaking => _VoicePresentation(
        prompt: l10n.voiceAgentSpeaking,
        description: l10n.voiceReadingAnswer,
        semanticLabel: l10n.voiceStopAssistant,
        icon: Icons.stop_rounded,
        color: AppColors.statusGreen,
      ),
      AssistantInteractionState.confirmation => _VoicePresentation(
        prompt: l10n.voiceNeedsConfirmation,
        description: l10n.voiceChooseActionBeforeRoute,
        semanticLabel: l10n.voiceStartNewConversation,
        icon: Icons.mic_rounded,
        color: AppColors.primaryBlue,
      ),
      AssistantInteractionState.error => _VoicePresentation(
        prompt: l10n.assistantRetry,
        description: l10n.voiceUseVoiceOrQuickAction,
        semanticLabel: l10n.voiceRetryConversation,
        icon: Icons.refresh_rounded,
        color: AppColors.statusRed,
      ),
    };
  }
}
