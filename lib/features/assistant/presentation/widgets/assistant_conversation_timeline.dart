import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../travel_alarm/domain/entities/travel_alarm_state.dart';
import '../../../travel_alarm/presentation/widgets/travel_alarm_status_card.dart';
import '../../domain/entities/assistant_conversation_item.dart';

class AssistantConversationTimeline extends StatelessWidget {
  const AssistantConversationTimeline({
    super.key,
    required this.items,
    required this.alarmState,
    required this.onViewTicket,
    required this.onCancelAlarm,
    required this.onFindTrip,
    required this.onConfirmRoute,
    required this.onRepeatRoute,
    required this.onCancelRoute,
  });

  final List<AssistantConversationItem> items;
  final TravelAlarmState alarmState;
  final VoidCallback onViewTicket;
  final VoidCallback onCancelAlarm;
  final VoidCallback onFindTrip;
  final VoidCallback onConfirmRoute;
  final VoidCallback onRepeatRoute;
  final VoidCallback onCancelRoute;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _buildItem(
            context,
            items[index],
            isLatest: index == items.length - 1,
          ),
          if (index != items.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildItem(
    BuildContext context,
    AssistantConversationItem item, {
    required bool isLatest,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final sender = item.author == AssistantMessageAuthor.user
        ? l10n.chatUser
        : l10n.assistantChatAssistant;
    final isAssistant = item.author == AssistantMessageAuthor.assistant;

    return Semantics(
      container: true,
      liveRegion: isLatest && isAssistant,
      label: AppLocalizations.of(
        context,
      )!.assistantMessageSemantics(sender, item.text),
      explicitChildNodes: true,
      child: Column(
        crossAxisAlignment: isAssistant
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          switch (item.kind) {
            AssistantConversationItemKind.alarmStatus => TravelAlarmStatusCard(
              message: item.text,
              state: item.alarmSnapshot ?? alarmState,
              onViewTicket: onViewTicket,
              onCancelAlarm: onCancelAlarm,
              canCancelAlarm: alarmState.hasAnyAlarm,
            ),
            AssistantConversationItemKind.noActiveTicket =>
              _NoActiveTicketMessage(
                message: item.text,
                onFindTrip: onFindTrip,
              ),
            AssistantConversationItemKind.routeSuggestion =>
              _RouteSuggestionMessage(
                message: item.text,
                onConfirm: onConfirmRoute,
                onRepeat: onRepeatRoute,
                onCancel: onCancelRoute,
              ),
            AssistantConversationItemKind.message => _MessageBubble(
              text: item.text,
              isUser: !isAssistant,
            ),
          },
        ],
      ),
    );
  }
}

class _RouteSuggestionMessage extends StatelessWidget {
  const _RouteSuggestionMessage({
    required this.message,
    required this.onConfirm,
    required this.onRepeat,
    required this.onCancel,
  });

  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onRepeat;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onConfirm,
              icon: const Icon(Icons.route_rounded),
              label: Text(l10n.assistantUseThisRoute),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              OutlinedButton.icon(
                onPressed: onRepeat,
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: Text(l10n.assistantRepeat),
              ),
              TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded, size: 18),
                label: Text(l10n.assistantCancel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.text, required this.isUser});

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 310),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryBlue : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: isUser ? null : Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? AppColors.textOnPrimary : AppColors.textPrimary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _NoActiveTicketMessage extends StatelessWidget {
  const _NoActiveTicketMessage({
    required this.message,
    required this.onFindTrip,
  });

  final String message;
  final VoidCallback onFindTrip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            l10n.assistantBuyTicketToUseAlarm,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onFindTrip,
            icon: const Icon(Icons.route_rounded, size: 18),
            label: Text(l10n.assistantSearchTrip),
          ),
        ],
      ),
    );
  }
}
