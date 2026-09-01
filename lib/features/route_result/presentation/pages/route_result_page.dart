import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../data/datasources/route_remote_data_source.dart';
import '../../data/repositories/route_repository_impl.dart';
import '../../data/services/native_route_speech_service.dart';
import '../../domain/entities/route_plan.dart';
import '../controllers/route_controller.dart';
import '../widgets/route_journey_timeline.dart';

class RouteResultPage extends StatefulWidget {
  const RouteResultPage({super.key, this.controller, this.from, this.to});

  final RouteController? controller;
  final String? from;
  final String? to;

  @override
  State<RouteResultPage> createState() => _RouteResultPageState();
}

class _RouteResultPageState extends State<RouteResultPage> {
  late final RouteController _controller;
  late final bool _ownsController;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ??
        RouteController(
          RouteRepositoryImpl(RouteRemoteDataSource()),
          const NativeRouteSpeechService(),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final uri = widget.from == null || widget.to == null
        ? GoRouterState.of(context).uri
        : null;
    final from = widget.from ?? uri?.queryParameters['from'] ?? '';
    final to = widget.to ?? uri?.queryParameters['to'] ?? '';
    unawaited(_controller.load(from: from, to: to));
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) => switch (_controller.state) {
                  RouteViewState.initial || RouteViewState.loading =>
                    const Center(child: CircularProgressIndicator()),
                  RouteViewState.error => _RouteError(
                    message: AppLocalizations.of(context)!.routeLoadError,
                    onRetry: _controller.retry,
                  ),
                  RouteViewState.success => _RouteContent(
                    controller: _controller,
                    route: _controller.route!,
                  ),
                },
              ),
            ),
            const AppBottomNavBar(currentIndex: 0),
          ],
        ),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final route = _controller.route;
          final canPreview =
              _controller.state == RouteViewState.success &&
              route != null &&
              route.lineSlugs.isNotEmpty;
          if (!canPreview) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: FloatingActionButton.extended(
              key: const Key('journey-map-preview-button'),
              onPressed: () => context.push('/rute/peta', extra: route),
              icon: const Icon(Icons.map_rounded),
              label: Text(AppLocalizations.of(context)!.routeShowLineMap),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _RouteError extends StatelessWidget {
  const _RouteError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.routeColdStartHint,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(AppLocalizations.of(context)!.actionRetry),
          ),
        ],
      ),
    ),
  );
}

class _RouteContent extends StatelessWidget {
  const _RouteContent({required this.controller, required this.route});

  final RouteController controller;
  final RoutePlan route;

  String get _formattedFare =>
      'Rp${route.fare.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _header(context, l10n),
        const SizedBox(height: 20),
        _filters(l10n),
        const SizedBox(height: 16),
        _summary(l10n),
        if (controller.preference == RoutePreference.accessible) ...[
          const SizedBox(height: 14),
          _speechControls(context),
        ],
        const SizedBox(height: 16),
        _timeline(l10n),
        const SizedBox(height: 16),
        _exitGates(l10n),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => context.go(
            Uri(
              path: '/tiket',
              queryParameters: {
                'from': route.from,
                'to': route.to,
                'fare': '${route.fare}',
                'duration': '${route.travelTime}',
                'transit': route.hasTransit ? '1' : '0',
              },
            ).toString(),
          ),
          icon: const Icon(Icons.confirmation_num_rounded),
          label: Text(l10n.buyTicketDirect(_formattedFare)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context, AppLocalizations l10n) => Row(
    children: [
      IconButton(
        onPressed: () => context.go(
          Uri(path: '/', queryParameters: {'selected': route.from}).toString(),
        ),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.routeGuideTitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    route.from,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    Icons.east_rounded,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Flexible(
                  child: Text(
                    route.to,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const CircleAvatar(
        backgroundColor: AppColors.a11yYellow,
        child: Icon(Icons.accessibility_new_rounded),
      ),
    ],
  );

  Widget _filters(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Row(
      children: [
        _filter(l10n.fastest, RoutePreference.fastest, Icons.bolt_rounded),
        _filter(
          l10n.minTransit,
          RoutePreference.minimumTransfers,
          Icons.sync_alt_rounded,
        ),
        _filter(
          l10n.accessible,
          RoutePreference.accessible,
          Icons.accessible_rounded,
        ),
      ],
    ),
  );

  Widget _filter(String label, RoutePreference value, IconData icon) {
    final selected = controller.preference == value;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: () => controller.selectPreference(value),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summary(AppLocalizations l10n) => Semantics(
    label: l10n.routeSummarySemantics(
      route.travelTime,
      route.stops,
      _formattedFare,
    ),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.travelEstimate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${route.travelTime}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(l10n.minutesOnly),
                  ],
                ),
                Text(
                  l10n.stopsAndService(route.stops, route.serviceInfo),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.travelFare,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                _formattedFare,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                l10n.routeTransferCount(route.transferCount),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _speechControls(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.a11yBannerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.a11yYellow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.record_voice_over_rounded),
              SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.routeVoiceGuide,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _speechButton(
                l10n.readRouteBtn,
                Icons.volume_up_rounded,
                () => controller.speak(language),
              ),
              _speechButton(
                l10n.actionRepeat,
                Icons.replay_rounded,
                () => controller.repeat(language),
              ),
              _speechButton(
                l10n.actionPause,
                Icons.pause_rounded,
                controller.pause,
              ),
              _speechButton(
                l10n.actionStop,
                Icons.stop_rounded,
                controller.stop,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _speechButton(
    String label,
    IconData icon,
    Future<void> Function() action,
  ) => OutlinedButton.icon(
    onPressed: action,
    icon: Icon(icon, size: 18),
    label: Text(label),
  );

  Widget _timeline(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(18),
    decoration: _cardDecoration(),
    child: RouteJourneyTimeline(title: l10n.routeTimeline, steps: route.steps),
  );

  Widget _exitGates(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(18),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.exitGateInfo(route.to),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        _gate(route.exitGateA, AppColors.primaryBlue),
        const SizedBox(height: 8),
        _gate(route.exitGateB, AppColors.statusGreen),
      ],
    ),
  );

  Widget _gate(String text, Color color) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Icon(Icons.meeting_room_outlined, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.cardBorder),
  );
}
