import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/train_schedule.dart';
import '../../domain/services/platform_display.dart';
import '../../domain/services/schedule_status.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.schedule,
    this.now,
    this.isNextUpcoming = false,
  });

  final TrainSchedule schedule;
  final DateTime? now;
  final bool isNextUpcoming;

  Color _getTrainColor(String type) {
    switch (type.toUpperCase()) {
      case 'LRT':
        return AppColors.badgeLRT;
      case 'KRL':
        return AppColors.badgeKRL;
      case 'MRT':
        return const Color(0xFF005A9C); // MRT Blue premium
      default:
        return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainColor = _getTrainColor(schedule.trainType);
    final l10n = AppLocalizations.of(context)!;
    final status = ScheduleStatusCalculator.calculate(
      schedule: schedule,
      now: now ?? DateTime.now(),
      l10n: l10n,
    );
    final isPassed = status.hasDeparted;
    final statusColor = switch (status.kind) {
      ScheduleStatusKind.upcoming => AppColors.primaryBlue,
      ScheduleStatusKind.soon => const Color(0xFFE07A16),
      ScheduleStatusKind.now => const Color(0xFF16834A),
      ScheduleStatusKind.passed => AppColors.textHint,
      ScheduleStatusKind.unavailable => AppColors.textSecondary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNextUpcoming
              ? AppColors.primaryBlue
              : AppColors.primaryPurple.withValues(alpha: 0.24),
          width: isNextUpcoming ? 1.75 : 1.25,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Opacity(
        opacity: isPassed ? 0.62 : 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Baris Atas: Nama Kereta, Tipe Badge, dan Peron ──
              Row(
                children: [
                  // Badge Tipe Kereta (KRL/LRT/MRT)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: trainColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      schedule.trainType,
                      style: TextStyle(
                        color: trainColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Nama Kereta
                  Expanded(
                    child: Text(
                      schedule.trainName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  // Nomor Peron
                  Container(
                    key: const Key('schedule-platform'),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Text(
                      PlatformDisplay.label(schedule.platform),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                PlatformDisplay.checkBoardHint,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              // Rute perjalanan
              Text(
                schedule.route,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                key: const Key('schedule-status'),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status.kind == ScheduleStatusKind.passed
                          ? Icons.history_rounded
                          : Icons.schedule_rounded,
                      size: 13,
                      color: statusColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      status.label,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.scheduleStatusDisclaimer,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              // Detail Waktu
              Row(
                children: [
                  Expanded(
                    child: _TimeBlock(
                      label: l10n.departFromStation(schedule.stationName),
                      value: schedule.departureTime,
                      icon: Icons.play_arrow_rounded,
                      color: trainColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeBlock(
                      label: l10n.estimatedArrival,
                      value: schedule.arrivalTime,
                      icon: Icons.stop_rounded,
                      color: AppColors.textSecondary,
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

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
