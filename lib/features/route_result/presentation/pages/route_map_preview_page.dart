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

final _mapStationsById = {for (final station in stations) station.id: station};
final _pairedStationIds = {
  ...kMergedStationPairs,
  for (final pair in kMergedStationPairs.entries) pair.value: pair.key,
};

Set<String> routeMapSegmentIds(RoutePlan route) {
  final segments = <String>{};
  for (var index = 0; index < route.stationSequence.length - 1; index++) {
    final from = route.stationSequence[index];
    final to = route.stationSequence[index + 1];
    // The backend emits a physical interchange once, with its incoming code.
    // Prefer the outgoing line, resolving only explicitly merged map nodes.
    for (final lineId in {to.line.slug, from.line.slug}) {
      final candidates = transitLines.where((line) => line.id == lineId);
      if (candidates.isEmpty) continue;
      final line = candidates.first;
      final orderedStations = [
        for (final stationId in line.stationIds) ?_mapStationsById[stationId],
      ];
      final fromIndices = [
        for (var i = 0; i < orderedStations.length; i++)
          if (_matchesRouteStation(orderedStations[i], from)) i,
      ];
      final toIndices = [
        for (var i = 0; i < orderedStations.length; i++)
          if (_matchesRouteStation(orderedStations[i], to)) i,
      ];
      if (fromIndices.isEmpty || toIndices.isEmpty) continue;
      // A loop lists its closing station twice. Use the adjacent occurrence,
      // not the long way around the loop for an otherwise neighbouring stop.
      var start = 0;
      var end = orderedStations.length;
      for (final a in fromIndices) {
        for (final b in toIndices) {
          if ((a - b).abs() < end - start) {
            start = a < b ? a : b;
            end = a < b ? b : a;
          }
        }
      }
      for (var edge = start; edge < end; edge++) {
        segments.add(
          mapRouteSegmentKey(
            line.id,
            mapSegmentNodeIdentity(orderedStations[edge]),
            mapSegmentNodeIdentity(orderedStations[edge + 1]),
          ),
        );
      }
      break;
    }
  }
  return segments;
}

bool _matchesRouteStation(StationData mapStation, RouteStation routeStation) {
  final routeCode = routeStation.nodeCode?.trim().toLowerCase() ?? '';
  if (routeCode.isNotEmpty) {
    final paired = _mapStationsById[_pairedStationIds[mapStation.id]];
    return mapStation.code.trim().toLowerCase() == routeCode ||
        paired?.code.trim().toLowerCase() == routeCode;
  }
  return !mapStation.isWaypoint &&
      stationSelectionName(mapStation).trim().toLowerCase() ==
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
