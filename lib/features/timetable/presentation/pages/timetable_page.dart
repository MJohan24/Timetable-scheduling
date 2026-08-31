import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/train_schedule.dart';
import '../../domain/services/schedule_status.dart';
import '../controllers/timetable_controller.dart';
import '../widgets/schedule_card.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final TimetableController _controller = TimetableController();
  late Future<List<TrainSchedule>> _schedulesFuture;
  late DateTime _now;
  Timer? _statusRefreshTimer;

  // State Filter
  String _searchQuery = '';
  String _selectedStationFilter = 'Semua Stasiun';
  String _selectedTypeFilter = 'Semua'; // 'Semua', 'KRL', 'LRT', 'MRT'
  bool _isWeekendFilter =
      false; // false = Hari Kerja (Weekday), true = Akhir Pekan (Weekend)

  // Daftar Stasiun yang tersedia di peta skematik
  final List<String> _stations = const [
    'Semua Stasiun',
    'Manggarai',
    'Tanah Abang',
    'Jakarta Kota',
    'Jatinegara',
    'Bekasi',
    'Cikarang',
    'Bogor',
    'Depok',
    'Citayam',
    'Nambo',
    'Rangkasbitung',
    'Parung Panjang',
    'Tangerang',
    'Duri',
    'Batu Ceper',
    'Tanjung Priok',
    'Setiabudi',
    'Dukuh Atas',
    'Bundaran HI',
    'Lebak Bulus',
    'Blok M',
    'Cawang',
    'Halim',
    'Jati Mulya',
    'Harjamukti',
    'Pegangsaan Dua',
    'Velodrome',
  ];

  // Daftar Jenis Kereta
  final List<String> _trainTypes = const ['Semua', 'KRL', 'LRT', 'MRT'];

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _loadSchedules();
    _statusRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _statusRefreshTimer?.cancel();
    super.dispose();
  }

  void _loadSchedules() {
    setState(() {
      _schedulesFuture = _controller.loadSchedules(
        station: _selectedStationFilter,
        trainType: _selectedTypeFilter,
        isWeekend: _isWeekendFilter,
      );
    });
  }

  Color _getTrainColor(String type) {
    switch (type.toUpperCase()) {
      case 'LRT':
        return AppColors.badgeLRT;
      case 'KRL':
        return AppColors.badgeKRL;
      case 'MRT':
        return const Color(0xFF005A9C);
      default:
        return AppColors.primaryBlue;
    }
  }

  void _showStationPickerSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        String sheetSearchQuery = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filteredStations = _stations.where((st) {
              if (sheetSearchQuery.isEmpty) return true;
              return st.toLowerCase().contains(sheetSearchQuery.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.selectOriginStation,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 22,
                          color: AppColors.textSecondary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Search Box di Bottom Sheet
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setSheetState(() => sheetSearchQuery = val);
                      },
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.search,
                          size: 18,
                          color: AppColors.textHint,
                        ),
                        hintText: l10n.searchStationHint2,
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredStations.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: AppColors.cardBorder),
                      itemBuilder: (context, index) {
                        final station = filteredStations[index];
                        final isSelected = _selectedStationFilter == station;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          leading: Icon(
                            station == 'Semua Stasiun'
                                ? Icons.train_rounded
                                : Icons.location_on_outlined,
                            color: isSelected
                                ? AppColors.primaryBlue
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                          title: Text(
                            station,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : AppColors.textPrimary,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primaryBlue,
                                  size: 20,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedStationFilter = station;
                            });
                            _loadSchedules();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header Section ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan Segmented Switch Weekday/Weekend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.trainSchedule,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            l10n.trainTypesJakarta,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Segmented Switch Day Filter
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() => _isWeekendFilter = false);
                                _loadSchedules();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isWeekendFilter
                                      ? AppColors.primaryBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  l10n.weekday,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: !_isWeekendFilter
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() => _isWeekendFilter = true);
                                _loadSchedules();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _isWeekendFilter
                                      ? AppColors.primaryBlue
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  l10n.weekend,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _isWeekendFilter
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColors.textHint,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                _searchQuery = val;
                              });
                            },
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: l10n.searchDestinationHint,
                              hintStyle: const TextStyle(
                                color: AppColors.textHint,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: const Icon(
                              Icons.clear,
                              color: AppColors.textHint,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),

            // ── Clean & Spacious Filter Section ──
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Full-Width Train Type Segmented Capsule
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: _trainTypes.map((type) {
                        final isSelected = _selectedTypeFilter == type;
                        final typeColor = _getTrainColor(type);
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedTypeFilter = type);
                              _loadSchedules();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (type == 'Semua'
                                          ? AppColors.primaryBlue
                                          : typeColor)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color:
                                              (type == 'Semua'
                                                      ? AppColors.primaryBlue
                                                      : typeColor)
                                                  .withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  type == 'Semua' ? l10n.all : type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Row 2: Full-Width Station Selector Field
                  GestureDetector(
                    onTap: _showStationPickerSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedStationFilter != 'Semua Stasiun'
                            ? AppColors.primaryBlueLight
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _selectedStationFilter != 'Semua Stasiun'
                              ? AppColors.primaryBlue
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _selectedStationFilter != 'Semua Stasiun'
                                ? Icons.location_on
                                : Icons.location_on_outlined,
                            size: 18,
                            color: _selectedStationFilter != 'Semua Stasiun'
                                ? AppColors.primaryBlue
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedStationFilter == 'Semua Stasiun'
                                  ? l10n.filterOriginAll
                                  : l10n.originStation(_selectedStationFilter),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    _selectedStationFilter != 'Semua Stasiun'
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                                color: _selectedStationFilter != 'Semua Stasiun'
                                    ? AppColors.primaryBlue
                                    : AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_selectedStationFilter != 'Semua Stasiun')
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedStationFilter = 'Semua Stasiun';
                                });
                                _loadSchedules();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),

            // ── Schedule List ──
            Expanded(
              child: FutureBuilder<List<TrainSchedule>>(
                future: _schedulesFuture,
                builder: (context, snapshot) {
                  // Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error state — timeout/cold-start is not treated as empty data.
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_queue_rounded,
                              size: 48,
                              color: AppColors.textHint.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.scheduleServerActive,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.scheduleBackendError,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton.icon(
                              onPressed: _loadSchedules,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: Text(l10n.actionRetry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Data state — apply text search filter client-side
                  final raw = snapshot.data ?? <TrainSchedule>[];
                  final filteredSchedules =
                      (_searchQuery.isEmpty
                            ? List<TrainSchedule>.of(raw)
                            : raw.where((s) {
                                final q = _searchQuery.toLowerCase();
                                return s.trainName.toLowerCase().contains(q) ||
                                    s.route.toLowerCase().contains(q) ||
                                    s.stationName.toLowerCase().contains(q);
                              }).toList())
                        ..sort(
                          (a, b) => a.departureTime.compareTo(b.departureTime),
                        );

                  if (filteredSchedules.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.train_outlined,
                            size: 48,
                            color: AppColors.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.scheduleNotFound,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.tryChangingFilter,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final nextUpcomingIndex = filteredSchedules.indexWhere((
                    schedule,
                  ) {
                    final status = ScheduleStatusCalculator.calculate(
                      schedule: schedule,
                      now: _now,
                      l10n: l10n,
                    );
                    return !status.hasDeparted &&
                        status.kind != ScheduleStatusKind.unavailable;
                  });

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredSchedules.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.scheduleDatasetNote,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final scheduleIndex = index - 1;
                      return ScheduleCard(
                        schedule: filteredSchedules[scheduleIndex],
                        now: _now,
                        isNextUpcoming: scheduleIndex == nextUpcomingIndex,
                      );
                    },
                  );
                },
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
