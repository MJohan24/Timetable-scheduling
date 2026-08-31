import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../models/support_chat_topic.dart';
import '../widgets/help_flow_widgets.dart';
import '../widgets/profile_detail_scaffold.dart';

enum _SupportMessageAuthor { user, agent }

class _SupportMessage {
  const _SupportMessage({required this.author, required this.text});

  final _SupportMessageAuthor author;
  final String text;
}

class SupportChatConversationPage extends StatefulWidget {
  const SupportChatConversationPage({super.key, required this.topic});

  final SupportChatTopic topic;

  @override
  State<SupportChatConversationPage> createState() =>
      _SupportChatConversationPageState();
}

class _SupportChatConversationPageState
    extends State<SupportChatConversationPage> {
  final ScrollController _scrollController = ScrollController();
  late List<_SupportMessage> _messages;
  Timer? _replyTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      _messages = _initialMessages(AppLocalizations.of(context)!);
    }
  }

  @override
  void didUpdateWidget(covariant SupportChatConversationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic == widget.topic) return;
    _replyTimer?.cancel();
    _messages = _initialMessages(AppLocalizations.of(context)!);
    _isTyping = false;
    _scrollToBottom();
  }

  List<_SupportMessage> _initialMessages(AppLocalizations l10n) {
    final sampleData = widget.topic.sampleData(l10n);
    return [
      _SupportMessage(
        author: _SupportMessageAuthor.user,
        text: widget.topic.openingMessage(l10n),
      ),
      _SupportMessage(
        author: _SupportMessageAuthor.agent,
        text: widget.topic.greeting(l10n),
      ),
      _SupportMessage(
        author: _SupportMessageAuthor.agent,
        text: l10n.chatReceivedData(sampleData),
      ),
    ];
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(
        _SupportMessage(author: _SupportMessageAuthor.user, text: trimmed),
      );
      _isTyping = true;
    });
    _scrollToBottom();
    _replyTimer?.cancel();
    _replyTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _SupportMessage(
            author: _SupportMessageAuthor.agent,
            text: widget.topic.replyTo(trimmed, AppLocalizations.of(context)!),
          ),
        );
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ProfileDetailScaffold(
      title: widget.topic.title(l10n),
      subtitle: '${widget.topic.agentName(l10n)} • ${l10n.chatOnline}',
      fallbackRoute: '/bantuan/chat',
      bodyPadding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      scrollController: _scrollController,
      footer: _SupportChatComposer(
        enabled: !_isTyping,
        isTyping: _isTyping,
        onSubmit: _sendMessage,
      ),
      children: [
        _AgentStatusCard(topic: widget.topic),
        const SizedBox(height: 22),
        const _DayDivider(),
        const SizedBox(height: 18),
        for (var index = 0; index < _messages.length; index++) ...[
          _SupportMessageBubble(
            message: _messages[index],
            isLatest: index == _messages.length - 1,
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _AgentStatusCard extends StatelessWidget {
  const _AgentStatusCard({required this.topic});

  final SupportChatTopic topic;

  @override
  Widget build(BuildContext context) {
    return HelpSurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlueLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.support_agent_rounded,
                  color: AppColors.primaryBlue,
                  size: 27,
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF17A871),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.agentName(AppLocalizations.of(context)!),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${topic.label(AppLocalizations.of(context)!)} • ${AppLocalizations.of(context)!.chatLocalReply}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F0),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              AppLocalizations.of(context)!.chatOnline,
              style: const TextStyle(
                color: Color(0xFF079669),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayDivider extends StatelessWidget {
  const _DayDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.cardBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            AppLocalizations.of(context)!.chatToday,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.cardBorder)),
      ],
    );
  }
}

class _SupportMessageBubble extends StatelessWidget {
  const _SupportMessageBubble({required this.message, required this.isLatest});

  final _SupportMessage message;
  final bool isLatest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUser = message.author == _SupportMessageAuthor.user;
    final sender = isUser ? l10n.chatUser : l10n.chatAgent;

    return Semantics(
      container: true,
      liveRegion: isLatest && !isUser,
      label: '$sender, ${message.text}',
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: isUser
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.76,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryBlue : Colors.white,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(16),
                  topEnd: const Radius.circular(16),
                  bottomStart: Radius.circular(isUser ? 16 : 4),
                  bottomEnd: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser ? null : Border.all(color: AppColors.cardBorder),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      liveRegion: true,
      label: l10n.chatAgentTyping,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          l10n.chatAgentTyping,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12.5,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

class _SupportChatComposer extends StatefulWidget {
  const _SupportChatComposer({
    required this.enabled,
    required this.isTyping,
    required this.onSubmit,
  });

  final bool enabled;
  final bool isTyping;
  final ValueChanged<String> onSubmit;

  @override
  State<_SupportChatComposer> createState() => _SupportChatComposerState();
}

class _SupportChatComposerState extends State<_SupportChatComposer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit([String? _]) {
    final message = _controller.text.trim();
    if (!widget.enabled || message.isEmpty) return;
    widget.onSubmit(message);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.cardBorder)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isTyping) ...[
                const _TypingIndicator(),
                const SizedBox(height: 8),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      key: const Key('support-chat-message-field'),
                      controller: _controller,
                      enabled: widget.enabled,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _submit,
                      decoration: InputDecoration(
                        hintText: widget.enabled
                            ? AppLocalizations.of(context)!.chatWriteMessage
                            : AppLocalizations.of(context)!.chatWaitReply,
                        filled: true,
                        fillColor: ProfileDetailScaffold.pageBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.cardBorder,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.cardBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primaryBlue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Semantics(
                    button: true,
                    enabled: widget.enabled,
                    label: AppLocalizations.of(context)!.chatSendMessage,
                    child: IconButton.filled(
                      key: const Key('support-chat-send-button'),
                      onPressed: widget.enabled ? _submit : null,
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        disabledBackgroundColor: const Color(0xFFCBD5E1),
                        minimumSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
