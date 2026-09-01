import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../travel_alarm/presentation/controllers/travel_alarm_controller.dart';
import '../controllers/assistant_controller.dart';
import '../controllers/assistant_conversation_controller.dart';
import '../models/assistant_copy.dart';
import '../../../travel_alarm/presentation/models/travel_alarm_copy.dart';
import '../../data/repositories/assistant_chat_repository_impl.dart';
import '../widgets/assistant_composer.dart';
import '../widgets/assistant_conversation_timeline.dart';
import '../widgets/assistant_quick_actions.dart';
import '../widgets/assistant_voice_panel.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({
    super.key,
    this.controller,
    this.alarmController,
    this.conversationController,
  });

  final AssistantController? controller;
  final TravelAlarmController? alarmController;
  final AssistantConversationController? conversationController;

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage>
    with WidgetsBindingObserver {
  late final AssistantController _controller;
  late final bool _ownsController;
  late final TravelAlarmController _alarmController;
  late final bool _ownsAlarmController;
  late final AssistantConversationController _conversationController;
  late final bool _ownsConversationController;
  final ScrollController _scrollController = ScrollController();
  int _lastConversationItemCount = 0;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? AssistantController();
    _ownsAlarmController = widget.alarmController == null;
    _alarmController = widget.alarmController ?? TravelAlarmController();
    _ownsConversationController = widget.conversationController == null;
    _conversationController =
        widget.conversationController ??
        AssistantConversationController(
          alarmController: _alarmController,
          chatRepository: AssistantChatRepositoryImpl(),
        );
    _lastConversationItemCount = _conversationController.items.length;
    _controller.setTranscriptSubmitter(_submitVoiceTranscript);
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_handleVoiceControllerChange);
    _conversationController.addListener(_handleConversationChange);
    _alarmController.addListener(_handleAlarmChange);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_handleVoiceControllerChange);
    _conversationController.removeListener(_handleConversationChange);
    _alarmController.removeListener(_handleAlarmChange);
    _controller.clearTranscriptSubmitter();
    if (_ownsController) {
      _controller.dispose();
    } else {
      unawaited(() async {
        await _controller.toggleWakeWord(false);
        await _controller.pauseForLifecycle();
      }());
    }
    if (_ownsConversationController) {
      _conversationController.dispose();
    }
    if (_ownsAlarmController) {
      _alarmController.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    final copy = AssistantCopy.fromL10n(l10n);
    _controller.configure(
      copy,
      languageCode: Localizations.localeOf(context).languageCode,
    );
    _conversationController.configure(copy);
    _alarmController.configure(TravelAlarmCopy.fromL10n(l10n));
  }

  void _handleVoiceControllerChange() {
    if (mounted) setState(() {});
  }

  Future<String?> _submitVoiceTranscript(String transcript) {
    if (!mounted) return Future<String?>.value();
    return _conversationController.submitText(
      transcript,
      lang: Localizations.localeOf(context).languageCode,
    );
  }

  void _handleConversationChange() {
    if (!mounted) return;
    final isFirstExchange =
        _lastConversationItemCount == 0 &&
        _conversationController.items.isNotEmpty;
    _lastConversationItemCount = _conversationController.items.length;
    final shouldFollowLatest =
        isFirstExchange ||
        !_scrollController.hasClients ||
        _scrollController.position.extentAfter < 120;
    setState(() {});
    if (shouldFollowLatest) _scheduleScrollToLatest();
  }

  @override
  void didChangeMetrics() {
    _scheduleScrollToLatest(onlyWhenNearBottom: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_controller.resumeFromLifecycle());
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(_controller.pauseForLifecycle());
    }
  }

  void _scheduleScrollToLatest({bool onlyWhenNearBottom = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (onlyWhenNearBottom && _scrollController.position.extentAfter >= 120) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleAlarmChange() {
    if (!mounted) return;
    setState(() {});
  }

  void _confirmRoute(String from, String to) {
    context.go(
      Uri(path: '/rute', queryParameters: {'from': from, 'to': to}).toString(),
    );
  }

  void _cancelAlarms() {
    if (!_alarmController.state.hasAnyAlarm) return;
    _alarmController.cancelAllAlarms();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.alarmDeactivated)),
      );
  }

  VoidCallback? get _voiceAction {
    return switch (_controller.state) {
      AssistantInteractionState.ready ||
      AssistantInteractionState.confirmation ||
      AssistantInteractionState.error => _controller.startConversation,
      AssistantInteractionState.listening => _controller.cancelConversation,
      AssistantInteractionState.speaking => _controller.stopSpeaking,
      AssistantInteractionState.processing => null,
    };
  }

  String _statusLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (_controller.state) {
      AssistantInteractionState.ready => l10n.assistantReady,
      AssistantInteractionState.listening => l10n.assistantListening,
      AssistantInteractionState.processing => l10n.assistantProcessing,
      AssistantInteractionState.speaking => l10n.assistantSpeaking,
      AssistantInteractionState.confirmation => l10n.assistantWaiting,
      AssistantInteractionState.error => l10n.assistantError,
    };
  }

  Color get _statusColor {
    return switch (_controller.state) {
      AssistantInteractionState.error => AppColors.statusRed,
      AssistantInteractionState.listening => AppColors.accentOrange,
      AssistantInteractionState.processing => AppColors.statusAmber,
      _ => AppColors.statusGreen,
    };
  }

  String _voiceSemanticsLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (_controller.state) {
      AssistantInteractionState.ready => l10n.voiceStart,
      AssistantInteractionState.listening => l10n.voiceStop,
      AssistantInteractionState.processing => l10n.voiceProcessing,
      AssistantInteractionState.speaking => l10n.voiceStopSpeaking,
      AssistantInteractionState.confirmation => l10n.voiceNew,
      AssistantInteractionState.error => l10n.voiceRetry,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: const Key('assistant-conversation-scroll'),
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    _buildWakeWordSetting(context),
                    const SizedBox(height: 12),
                    AssistantVoicePanel(
                      state: _controller.state,
                      onTap: _voiceAction,
                    ),
                    if (_conversationController.items.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      AssistantConversationTimeline(
                        items: _conversationController.items,
                        alarmState: _alarmController.state,
                        onViewTicket: () => context.go('/tiket'),
                        onCancelAlarm: _cancelAlarms,
                        onFindTrip: () => context.go('/cari-stasiun'),
                        onConfirmRoute: _confirmRoute,
                        onRepeatRoute: _controller.repeatResponse,
                        onCancelRoute: _controller.cancelConversation,
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.quickActions,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AssistantQuickActions(
                      actions: [
                        AssistantQuickAction(
                          label: AppLocalizations.of(context)!.planTrip,
                          icon: Icons.route_rounded,
                          onTap: () => context.go('/cari-stasiun'),
                        ),
                        AssistantQuickAction(
                          label: AppLocalizations.of(context)!.nextTrain,
                          icon: Icons.train_rounded,
                          onTap: () => context.go('/timetable'),
                        ),
                        AssistantQuickAction(
                          label: AppLocalizations.of(context)!.myTickets,
                          icon: Icons.confirmation_num_rounded,
                          onTap: () => context.go('/tiket'),
                        ),
                        AssistantQuickAction(
                          label: AppLocalizations.of(context)!.officerHelp,
                          icon: Icons.support_agent_rounded,
                          onTap: () => context.go('/pusat-bantuan'),
                        ),
                        AssistantQuickAction(
                          label: AppLocalizations.of(
                            context,
                          )!.assistantCameraGuideAction,
                          icon: Icons.camera_alt_rounded,
                          onTap: () => context.push('/asisten/pemandu-kamera'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AssistantComposer(
              onSubmit: (text) => _conversationController.submitText(
                text,
                lang: Localizations.localeOf(context).languageCode,
              ),
              onMicrophoneTap: _voiceAction,
              microphoneSemanticsLabel: _voiceSemanticsLabel(context),
            ),
            const AppBottomNavBar(currentIndex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryBlueLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.headset_mic_rounded,
            color: AppColors.primaryBlue,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.travelAssistant,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Semantics(
                liveRegion: true,
                label: l10n.assistantStatusLabel(_statusLabel(context)),
                child: ExcludeSemantics(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          _statusLabel(context),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWakeWordSetting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = _controller.wakeWordEnabled;
    return Semantics(
      container: true,
      label: l10n.wakeWordMode,
      value: enabled ? l10n.active : l10n.inactive,
      toggled: enabled,
      onTap: () => unawaited(_controller.toggleWakeWord(!enabled)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.statusGreen.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled
                ? AppColors.statusGreen.withValues(alpha: 0.45)
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              enabled ? Icons.hearing_rounded : Icons.hearing_disabled_rounded,
              color: enabled ? AppColors.statusGreen : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.listenWakeWord,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    enabled ? l10n.wakeWordActiveText : l10n.wakeWordPageOnly,
                    style: TextStyle(
                      color: enabled
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            ExcludeSemantics(
              child: Switch(
                key: const Key('wake-word-switch'),
                value: enabled,
                onChanged: (value) =>
                    unawaited(_controller.toggleWakeWord(value)),
                activeThumbColor: AppColors.statusGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
