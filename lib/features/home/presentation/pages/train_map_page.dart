import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../data/krl_station_locations.dart';
import '../../data/services/user_location_service.dart';
import '../../domain/entities/station_geo_point.dart';
import '../../domain/services/nearest_krl_station.dart';
import '../../../home/presentation/widgets/map_widgets.dart';

/// Halaman Kereta / Train Map (Screen 1 di Figma)
/// Menampilkan peta skematik (warna pudar), search bar, tombol aksi stasiun,
/// dan info detail stasiun yang dipilih. Stasiun bisa diklik.
class TrainMapPage extends StatefulWidget {
  const TrainMapPage({
    super.key,
    this.locationService = const UserLocationService(),
    this.stationLocations = krlStationLocations,
  });

  final UserLocationService locationService;
  final List<StationGeoPoint> stationLocations;

  @override
  State<TrainMapPage> createState() => _TrainMapPageState();
}

class _TrainMapPageState extends State<TrainMapPage> {
  String _selectedStation = 'Cawang';
  String? _nearestStationId;
  String? _nearestStationName;
  bool _isLocating = false;

  Future<void> _locateUser() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    final result = await widget.locationService.locate();
    if (!mounted) return;

    if (result.status == UserLocationStatus.success &&
        result.coordinates != null) {
      final nearest = NearestKrlStation.find(
        latitude: result.coordinates!.latitude,
        longitude: result.coordinates!.longitude,
        stations: widget.stationLocations,
      );
      if (nearest != null) {
        setState(() {
          _isLocating = false;
          _nearestStationId = nearest.station.schematicStationId;
          _nearestStationName = nearest.station.name;
          _selectedStation = nearest.station.name;
        });
        if (result.usedLastKnownPosition) {
          _showLocationMessage(
            AppLocalizations.of(context)!.mapNearestMarkerNote,
          );
        }
        return;
      }
    }

    setState(() => _isLocating = false);
    _showLocationMessage(_messageFor(result.status));
  }

  String _messageFor(UserLocationStatus status) {
    final l10n = AppLocalizations.of(context)!;
    return switch (status) {
      UserLocationStatus.servicesDisabled => l10n.mapLocationServiceDisabled,
      UserLocationStatus.permissionDenied => l10n.mapLocationPermissionDenied,
      UserLocationStatus.permissionDeniedForever =>
        l10n.mapLocationPermissionDenied,
      UserLocationStatus.unavailable ||
      UserLocationStatus.success => l10n.stationLoadError,
    };
  }

  void _showLocationMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Data dummy info stasiun
  Map<String, Map<String, String>> _getStationData(AppLocalizations l10n) => {
    'Setiabudi': {
      'subtitle': l10n.mapSubtitleLrtKrl,
      'lrtDest': 'Dukuh Atas',
      'lrtDur': l10n.durationMinutes('3'),
      'krlDest': 'Manggarai',
      'krlDur': l10n.durationMinutes('7'),
    },
    'Cawang': {
      'subtitle': l10n.mapSubtitleLrtKrl,
      'lrtDest': 'Dukuh Atas',
      'lrtDur': l10n.durationMinutes('5'),
      'krlDest': 'Manggarai',
      'krlDur': l10n.durationMinutes('9'),
    },
    'Manggarai': {
      'subtitle': l10n.mapSubtitleKrlTransit,
      'lrtDest': 'Setiabudi',
      'lrtDur': l10n.durationMinutes('4'),
      'krlDest': 'Tanah Abang',
      'krlDur': l10n.durationMinutes('6'),
    },
    'Tanah Abang': {
      'subtitle': l10n.mapSubtitleKrl,
      'lrtDest': 'Manggarai',
      'lrtDur': l10n.durationMinutes('6'),
      'krlDest': 'Sudirman',
      'krlDur': l10n.durationMinutes('3'),
    },
    'Halim': {
      'subtitle': l10n.mapSubtitleLrt,
      'lrtDest': 'Setiabudi',
      'lrtDur': l10n.durationMinutes('8'),
      'krlDest': 'Cawang',
      'krlDur': l10n.durationMinutes('4'),
    },
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final data =
        _getStationData(l10n)[_selectedStation] ??
        {
          'subtitle': 'Stasiun KRL Jabodetabek',
          'lrtDest': '-',
          'lrtDur': '-',
          'krlDest': 'Lihat jadwal',
          'krlDur': 'KRL',
        };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Search Bar ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () => context.go('/cari-stasiun'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.mapSearchHint,
                                style: const TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Peta Skematik (warna pudar, interaktif) ──
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: MapView(
                        showColors: false,
                        selectedStation: _selectedStation,
                        nearestStationId: _nearestStationId,
                        onLocateUser: _locateUser,
                        isLocating: _isLocating,
                        onStationSelected: (name) {
                          setState(() => _selectedStation = name);
                        },
                      ),
                    ),

                    // ── Tombol Aksi Stasiun (Dari, Lewat, Ke, Info) ──
                    if (_nearestStationName != null)
                      Container(
                        key: const Key('nearest-station-banner'),
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.my_location_rounded,
                              size: 19,
                              color: AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.mapNearStation(_nearestStationName!),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.mapNearestMarkerNote,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      height: 1.35,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Center(child: StationActionBar()),

                    const SizedBox(height: 24),

                    // ── Info Detail Stasiun yang Dipilih ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedStation,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['subtitle']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TransitChip(
                                  lineType: 'LRT',
                                  destination: data['lrtDest']!,
                                  duration: data['lrtDur']!,
                                  lineColor: AppColors.badgeLRT,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TransitChip(
                                  lineType: 'KRL',
                                  destination: data['krlDest']!,
                                  duration: data['krlDur']!,
                                  lineColor: AppColors.badgeKRL,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Navigation Bar ──
            const AppBottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}
