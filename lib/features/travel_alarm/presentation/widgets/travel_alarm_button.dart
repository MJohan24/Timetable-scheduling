import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class TravelAlarmButton extends StatelessWidget {
  const TravelAlarmButton({
    super.key,
    required this.isActive,
    required this.onPressed,
  });

  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final semanticsLabel = isActive
        ? l10n.alarmActiveSemantics
        : l10n.alarmInactiveSemantics;

    return Semantics(
      button: true,
      toggled: isActive,
      label: semanticsLabel,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: Tooltip(
          message: isActive
              ? l10n.alarmActiveTooltip
              : l10n.alarmInactiveTooltip,
          child: Material(
            color: isActive ? AppColors.statusRed : AppColors.surface,
            elevation: 5,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(
                  isActive ? Icons.alarm_on_rounded : Icons.alarm_add_rounded,
                  color: isActive
                      ? AppColors.textOnPrimary
                      : AppColors.textSecondary,
                  size: 27,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
