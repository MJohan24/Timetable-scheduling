import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// Shell visual bersama untuk seluruh halaman detail dari menu Akun.
///
/// Shell ini mempertahankan header berwarna merek, permukaan atas membulat, tombol
/// kembali, dan tidak menampilkan navigasi bawah.
class ProfileDetailScaffold extends StatelessWidget {
  static const Color headerColor = AppColors.deepPurple;
  static const Color pageBackground = AppColors.background;

  final String title;
  final String subtitle;
  final List<Widget> children;
  final String fallbackRoute;
  final EdgeInsetsGeometry bodyPadding;
  final Widget? footer;
  final ScrollController? scrollController;

  const ProfileDetailScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.fallbackRoute = '/akun',
    this.bodyPadding = const EdgeInsetsDirectional.fromSTEB(28, 28, 28, 32),
    this.footer,
    this.scrollController,
  });

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(fallbackRoute);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: headerColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: pageBackground,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: pageBackground,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 24, 24, 50),
                  child: Row(
                    children: [
                      Semantics(
                        button: true,
                        label: AppLocalizations.of(context)!.actionBack,
                        child: Material(
                          color: Colors.white.withValues(alpha: 0.16),
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => _goBack(context),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Icon(
                                Directionality.of(context) == TextDirection.rtl
                                    ? Icons.chevron_right_rounded
                                    : Icons.chevron_left_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: pageBackground,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: bodyPadding,
                          children: children,
                        ),
                      ),
                      ?footer,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
