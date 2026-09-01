import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/map_widgets.dart';
import '../../../../shared/widgets/schematic_map_painter.dart';
import '../../domain/entities/route_plan.dart';
import '../../../../l10n/app_localizations.dart';

class RouteMapPreviewPage extends StatefulWidget {
  const RouteMapPreviewPage({super.key, required this.route});

  final RoutePlan? route;

  @override
  State<RouteMapPreviewPage> createState() => _RouteMapPreviewPageState();
}

class _RouteMapPreviewPageState extends State<RouteMapPreviewPage> {
  bool _showAllLines = false;

  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    if (route == null || route.lineSlugs.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.routePreviewTitle)),
        body: Center(child: Text(l10n.routePreviewUnavailable)),
      );
    }

    final journeyLines = route.journeyLines;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _PreviewHeader(route: route),
            Expanded(
              child: MapView(
                showColors: true,
                selectedStation: route.from,
                fromStation: route.from,
                highlightedSegmentIds: _showAllLines
                    ? null
                    : routeMapSegmentIds(route),
              ),
            ),
            _PreviewControls(
              route: route,
              journeyLines: journeyLines,
              showAllLines: _showAllLines,
              onShowAllLines: () => setState(() => _showAllLines = true),
              onFocusJourney: () => setState(() => _showAllLines = false),
            ),
          ],
        ),
      ),
    );
  }
}

Set<String> routeMapSegmentIds(RoutePlan route) {
  final segments = <String>{};
  for (var index = 0; index < route.stationSequence.length - 1; index++) {
    final from = route.stationSequence[index];
    final to = route.stationSequence[index + 1];
    // A line change with a different color represents a transfer (including
    // the Cikoko LRT -> Cawang KRL walk), not a rail segment to highlight.
    // Same-color changes are retained for branch handoffs such as Bogor.
    if (from.line.slug != to.line.slug && from.line.color != to.line.color) {
      continue;
    }
    final candidateLines = transitLines.where(
      (line) => line.id == from.line.slug || line.id == to.line.slug,
    );
    for (final line in candidateLines) {
      final orderedStations = [
        for (final stationId in line.stationIds)
          for (final station in stations)
            if (station.id == stationId) station,
      ];
      final fromIndex = orderedStations.indexWhere(
        (station) => _matchesRouteStation(station, from),
      );
      final toIndex = orderedStations.indexWhere(
        (station) => _matchesRouteStation(station, to),
      );
      if (fromIndex == -1 || toIndex == -1 || fromIndex == toIndex) {
        continue;
      }

      final start = fromIndex < toIndex ? fromIndex : toIndex;
      final end = fromIndex < toIndex ? toIndex : fromIndex;
      for (var edge = start; edge < end; edge++) {
        segments.add(
          mapRouteSegmentKey(
            line.id,
            mapSegmentNodeIdentity(orderedStations[edge]),
            mapSegmentNodeIdentity(orderedStations[edge + 1]),
          ),
        );
      }
    }
  }
  return segments;
}

bool _matchesRouteStation(StationData mapStation, RouteStation routeStation) {
  final routeCode = routeStation.nodeCode?.trim().toLowerCase() ?? '';
  if (routeCode.isNotEmpty) {
    // Node code is line-specific; station names are not (Cawang, Duri,
    // Jakarta Kota, and others have multiple map nodes).
    return mapStation.code.trim().toLowerCase() == routeCode;
  }
  return mapStation.name.trim().toLowerCase() ==
      routeStation.name.trim().toLowerCase();
}

class _PreviewHeader extends StatelessWidget {
  const _PreviewHeader({required this.route});

  final RoutePlan route;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(8, 6, 16, 12),
    decoration: const BoxDecoration(
      color: AppColors.surface,
      border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: AppLocalizations.of(context)!.routeBackToResults,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.routePreviewLineTitle,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.routeFromTo(route.from, route.to),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PreviewControls extends StatelessWidget {
  const _PreviewControls({
    required this.route,
    required this.journeyLines,
    required this.showAllLines,
    required this.onShowAllLines,
    required this.onFocusJourney,
  });

  final RoutePlan route;
  final List<RouteLine> journeyLines;
  final bool showAllLines;
  final VoidCallback onShowAllLines;
  final VoidCallback onFocusJourney;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    decoration: const BoxDecoration(
      color: AppColors.surface,
      border: Border(top: BorderSide(color: AppColors.cardBorder)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.my_location_rounded, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.routeCurrentLocation(route.from),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            TextButton(
              onPressed: showAllLines ? onFocusJourney : onShowAllLines,
              child: Text(
                showAllLines
                    ? AppLocalizations.of(context)!.routeFocusJourney
                    : AppLocalizations.of(context)!.routeAllLines,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final line in journeyLines)
              Chip(
                avatar: CircleAvatar(backgroundColor: _parseColor(line.color)),
                label: Text(line.name),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context)!.routeDimmedLinesNote,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    ),
  );

  Color _parseColor(String value) {
    final normalized = value.replaceFirst('#', '');
    final hex = normalized.length == 6 ? 'FF$normalized' : normalized;
    return Color(int.tryParse(hex, radix: 16) ?? 0xFF2563EB);
  }
}
