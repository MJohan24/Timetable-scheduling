import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class AssistantComposer extends StatefulWidget {
  const AssistantComposer({
    super.key,
    required this.onSubmit,
    required this.onMicrophoneTap,
    this.microphoneSemanticsLabel = 'Mulai percakapan suara',
  });

  final ValueChanged<String> onSubmit;
  final VoidCallback? onMicrophoneTap;
  final String microphoneSemanticsLabel;

  @override
  State<AssistantComposer> createState() => _AssistantComposerState();
}

class _AssistantComposerState extends State<AssistantComposer> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit([String? _]) {
    final value = _textController.text.trim();
    if (value.isEmpty) return;
    widget.onSubmit(value);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.cardBorder)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  key: const Key('assistant-message-field'),
                  controller: _textController,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _submit,
                  decoration: InputDecoration(
                    labelText: l10n.assistantTypeMessage,
                    prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.cardBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primaryBlue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _ComposerIconButton(
                semanticsLabel: widget.microphoneSemanticsLabel.isEmpty
                    ? l10n.voiceStartConversation
                    : widget.microphoneSemanticsLabel,
                icon: Icons.mic_rounded,
                onPressed: widget.onMicrophoneTap,
                foregroundColor: AppColors.primaryBlue,
                backgroundColor: AppColors.primaryBlueLight,
              ),
              const SizedBox(width: 6),
              _ComposerIconButton(
                semanticsLabel: l10n.assistantSendMessage,
                icon: Icons.send_rounded,
                onPressed: _submit,
                foregroundColor: AppColors.textOnPrimary,
                backgroundColor: AppColors.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComposerIconButton extends StatelessWidget {
  const _ComposerIconButton({
    required this.semanticsLabel,
    required this.icon,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final String semanticsLabel;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticsLabel,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon),
          color: foregroundColor,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
