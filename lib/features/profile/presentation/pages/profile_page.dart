import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/locale_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../auth/domain/entities/account_user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/widgets/auth_scope.dart';
import '../models/app_locale_presentation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = AuthScope.of(context);
    final user = auth.user;
    final offline = auth.status == AuthStatus.offlineAuthenticated;
    final currentLocale = LocaleScope.of(context).value;
    final ticketTitle = user == null
        ? l10n.profileLocalTicketHistory
        : l10n.profileAccountTicketHistory;
    final ticketSubtitle = user == null
        ? l10n.profileSavedOnDevice
        : l10n.profileSyncedAccount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: auth.status == AuthStatus.restoring
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _AccountHero(user: user, offline: offline),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _ProfileMenuSection(
                                entries: [
                                  _MenuEntry(
                                    icon: Icons.receipt_long_outlined,
                                    title: ticketTitle,
                                    subtitle: ticketSubtitle,
                                    onTap: () => context.push('/riwayat-tiket'),
                                  ),
                                  _MenuEntry(
                                    icon: Icons.language_rounded,
                                    title: l10n.languagePageTitle,
                                    subtitle: currentLocale.localizedName(l10n),
                                    onTap: () => context.push('/bahasa'),
                                  ),
                                  _MenuEntry(
                                    icon: Icons.support_agent_rounded,
                                    title: l10n.profileHelpCenter,
                                    subtitle: l10n.profileContactOfficer,
                                    onTap: () => context.push('/pusat-bantuan'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const _BlindGuideCard(),
                              if (user != null) ...[
                                const SizedBox(height: 14),
                                _ProfileMenuSection(
                                  sectionKey: const ValueKey(
                                    'account-logout-section',
                                  ),
                                  entries: const [],
                                  onLogout: () => _confirmLogout(context, auth),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const AppBottomNavBar(currentIndex: 4),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthController auth) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileLogout),
        content: Text(l10n.profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.profileCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.profileLogout),
          ),
        ],
      ),
    );
    if (confirmed == true) await auth.logout();
  }
}

class _AccountHero extends StatelessWidget {
  const _AccountHero({required this.user, required this.offline});

  final AccountUser? user;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          height: 174,
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.profileAccount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user == null
                    ? l10n.profileGuestModeActive
                    : offline
                    ? l10n.profileOfflineSession
                    : l10n.profileSignedIn,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 108, 20, 0),
          child: _IdentityCard(user: user, offline: offline),
        ),
      ],
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.user, required this.offline});

  final AccountUser? user;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final signedIn = user != null;
    final displayName = signedIn
        ? (user!.name ?? user!.email)
        : l10n.profileGuest;
    return Container(
      key: const ValueKey('account-identity-card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: signedIn
                    ? AppColors.primaryPurple
                    : AppColors.pinkAccent,
                child: Text(
                  _initials(user),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      signedIn ? user!.email : l10n.profileGuestDesc,
                      maxLines: signedIn ? 1 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    if (signedIn) ...[
                      const SizedBox(height: 7),
                      _AccountStatus(offline: offline),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (signedIn)
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.person_outline_rounded,
                    label: l10n.profileEdit,
                    onPressed: () => context.push('/profil-saya'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.receipt_long_outlined,
                    label: l10n.profileAccountTicketHistory,
                    onPressed: () => context.push('/riwayat-tiket'),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push('/masuk'),
                icon: const Icon(Icons.login_rounded, size: 19),
                label: Text(l10n.profileOptionalLogin),
              ),
            ),
        ],
      ),
    );
  }

  String _initials(AccountUser? user) {
    if (user == null) return 'T';
    final source = user.name?.trim().isNotEmpty == true
        ? user.name!
        : user.email;
    final words = source.trim().split(RegExp(r'\s+'));
    if (words.length > 1) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    final word = words.first;
    return (word.length == 1 ? word : word.substring(0, 2)).toUpperCase();
  }
}

class _AccountStatus extends StatelessWidget {
  const _AccountStatus({required this.offline});

  final bool offline;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = offline ? AppColors.statusAmber : AppColors.statusGreen;
    return Row(
      children: [
        Icon(
          offline ? Icons.cloud_off_outlined : Icons.verified_rounded,
          color: color,
          size: 15,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            offline ? l10n.profileOfflineSession : l10n.profileSignedIn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(0, 48),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      side: const BorderSide(color: AppColors.cardBorder),
      foregroundColor: AppColors.textPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    icon: Icon(icon, size: 19),
    label: Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );
}

class _ProfileMenuSection extends StatelessWidget {
  const _ProfileMenuSection({
    required this.entries,
    this.onLogout,
    this.sectionKey = const ValueKey('account-menu-section'),
  });

  final List<_MenuEntry> entries;
  final VoidCallback? onLogout;
  final Key sectionKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = <Widget>[];
    for (var index = 0; index < entries.length; index++) {
      final entry = entries[index];
      rows.add(
        _MenuRow(
          icon: entry.icon,
          title: entry.title,
          subtitle: entry.subtitle,
          onTap: entry.onTap,
        ),
      );
      if (index < entries.length - 1 || onLogout != null) {
        rows.add(const Divider(height: 1, indent: 18, endIndent: 18));
      }
    }
    if (onLogout != null) {
      rows.add(
        _MenuRow(
          key: const ValueKey('account-logout'),
          icon: Icons.logout_rounded,
          title: l10n.profileLogout,
          foregroundColor: AppColors.statusRed,
          showChevron: false,
          onTap: onLogout!,
        ),
      );
    }

    return Material(
      key: sectionKey,
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: Column(children: rows),
    );
  }
}

class _BlindGuideCard extends StatefulWidget {
  const _BlindGuideCard();

  @override
  State<_BlindGuideCard> createState() => _BlindGuideCardState();
}

class _BlindGuideCardState extends State<_BlindGuideCard> {
  bool _active = false;

  Future<void> _activate() async {
    if (_active) return;
    setState(() => _active = true);
    await context.push('/asisten/pemandu-kamera?autoVoice=true');
    if (mounted) setState(() => _active = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      key: const ValueKey('blind-guide-card'),
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: Semantics(
        button: true,
        toggled: _active,
        label:
            '${l10n.profileBlindGuide}. ${l10n.profileBlindGuideDescription}',
        child: InkWell(
          onTap: _activate,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 82),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.blind_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.profileBlindGuide,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          l10n.profileBlindGuideDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ExcludeSemantics(
                    child: Switch(
                      key: const ValueKey('blind-guide-switch'),
                      value: _active,
                      onChanged: (value) {
                        if (value) _activate();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.foregroundColor = AppColors.textPrimary,
    this.showChevron = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color foregroundColor;
  final bool showChevron;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: [title, if (subtitle?.isNotEmpty == true) subtitle!].join('. '),
    child: InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 68),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle?.isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showChevron) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}

class _MenuEntry {
  const _MenuEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}
