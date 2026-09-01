import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Bottom navigation bar datar dengan lima destinasi berukuran sama.
/// Layout: Beranda | Jadwal | Tiket | Asisten | Akun
///
/// Index mapping (tetap sama agar tidak break halaman lain):
///   0 = Beranda, 1 = Kereta, 2 = Tiket, 3 = Asisten, 4 = Akun
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, this.currentIndex = 0});

  static const List<String> _routes = [
    '/', // 0: Beranda
    '/timetable', // 1: Jadwal
    '/tiket', // 2: Tiket Saya
    '/asisten', // 3: Asisten
    '/akun', // 4: Akun
  ];

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) {
      if (index == 0) {
        // Jika sudah di Home, tap Home akan membersihkan query parameter dan menutup panel info stasiun
        context.go('/');
      }
      return;
    }
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final scaleProgress = (textScale - 1).clamp(0.0, 1.0);
    final navHeight = 72.0 + (28 * scaleProgress);
    final l10n = AppLocalizations.of(context)!;
    final items = [
      (
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: l10n.navHome,
        index: 0,
      ),
      (
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month_rounded,
        label: l10n.navSchedule,
        index: 1,
      ),
      (
        icon: Icons.confirmation_num_outlined,
        activeIcon: Icons.confirmation_num_rounded,
        label: l10n.navTickets,
        index: 2,
      ),
      (
        icon: Icons.headset_mic_outlined,
        activeIcon: Icons.headset_mic_rounded,
        label: l10n.navAssistant,
        index: 3,
      ),
      (
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: l10n.navAccount,
        index: 4,
      ),
    ];

    return Container(
      height: navHeight + bottomPadding,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: _NavItem(
                icon: item.icon,
                activeIcon: item.activeIcon,
                label: item.label,
                isActive: currentIndex == item.index,
                onTap: () => _onTap(context, item.index),
              ),
            ),
        ],
      ),
    );
  }
}

/// Item navigasi individual (ikon + label)
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (isActive)
                const Positioned(
                  top: 0,
                  width: 32,
                  height: 3,
                  child: DecoratedBox(
                    key: ValueKey('bottom-nav-active-indicator'),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive ? activeIcon : icon,
                    color: isActive
                        ? AppColors.primaryBlue
                        : AppColors.textHint,
                    size: 24,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                      color: isActive
                          ? AppColors.primaryBlue
                          : AppColors.textHint,
                      letterSpacing: 0.1,
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
