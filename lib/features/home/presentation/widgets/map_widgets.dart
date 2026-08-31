import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/schematic_map_painter.dart';

const double kInitialMapScale = 1.05;

/// Widget peta skematik jalur kereta yang bisa di-zoom, di-geser,
/// dan klik stasiun untuk memilihnya.
class MapView extends StatefulWidget {
  final bool showColors;
  final String? selectedStation;
  final String? fromStation;
  final ValueChanged<String>? onStationSelected;
  final Set<String>? visibleLineIds;
  final Set<String>? highlightedSegmentIds;
  final String? nearestStationId;
  final VoidCallback? onLocateUser;
  final bool isLocating;

  const MapView({
    super.key,
    this.showColors = false,
    this.selectedStation,
    this.fromStation,
    this.onStationSelected,
    this.visibleLineIds,
    this.highlightedSegmentIds,
    this.nearestStationId,
    this.onLocateUser,
    this.isLocating = false,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with SingleTickerProviderStateMixin {
  final TransformationController _transformController =
      TransformationController();

  // ── State untuk deteksi tap manual via Listener ──
  // Listener menangkap raw pointer events SEBELUM gesture arena,
  // sehingga tidak terblokir oleh InteractiveViewer.
  Offset? _pointerDownPos;
  DateTime? _pointerDownTime;

  // RenderBox key untuk mendapatkan posisi lokal relatif terhadap InteractiveViewer
  final GlobalKey _viewerKey = GlobalKey();

  // ── State untuk Animasi Kamera / Viewport ──
  late AnimationController _animationController;
  Animation<Matrix4>? _animationMatrix;
  String? _prevSelectedStation;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 350),
        )..addListener(() {
          if (_animationMatrix != null) {
            _transformController.value = _animationMatrix!.value;
          }
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  /// Dipanggil saat pointer turun (sebelum gesture arena memutuskan pan vs tap)
  void _onPointerDown(PointerDownEvent event) {
    _pointerDownPos = event.position; // posisi global
    _pointerDownTime = DateTime.now();
  }

  /// Dipanggil saat pointer naik. Cek apakah ini "tap":
  /// - Jarak geser < 18 logical pixels (toleransi jari)
  /// - Durasi tekan < 300ms
  void _onPointerUp(PointerUpEvent event, Size canvasSize) {
    if (_pointerDownPos == null || _pointerDownTime == null) return;

    final distance = (event.position - _pointerDownPos!).distance;
    final duration = DateTime.now().difference(_pointerDownTime!);

    // Threshold: gerakan kecil + durasi pendek = ini tap, bukan pan
    if (distance < 18 && duration.inMilliseconds < 300) {
      _detectStation(event.position, canvasSize);
    }

    _pointerDownPos = null;
    _pointerDownTime = null;
  }

  /// Konversi posisi global tap → koordinat canvas (memperhitungkan zoom/pan),
  /// lalu cek jarak ke setiap stasiun.
  void _detectStation(Offset globalPos, Size canvasSize) {
    // Dapatkan posisi lokal relatif terhadap widget InteractiveViewer
    final RenderBox? box =
        _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final localPos = box.globalToLocal(globalPos);

    // Terapkan inverse transformation matrix untuk mendapatkan koordinat canvas asli
    final matrix = _transformController.value;
    final inverseMatrix = Matrix4.inverted(matrix);
    final canvasPos = MatrixUtils.transformPoint(inverseMatrix, localPos);

    // Cek jarak tap ke setiap stasiun (threshold 25px di koordinat canvas)
    for (final station in stations) {
      if (station.isWaypoint) continue;
      final d = (canvasPos - station.position).distance;
      if (d < 25) {
        final selectionName = stationSelectionName(station);
        if (selectionName.isNotEmpty) {
          widget.onStationSelected?.call(selectionName);
        }
        return;
      }
    }
  }

  /// Menganimasikan InteractiveViewer agar terfokus di stasiun tertentu
  void _centerOnStation(
    String stationName,
    Size viewportSize, {
    bool animate = true,
    double? scale,
  }) {
    final query = stationName.toLowerCase();
    final station = stations.firstWhere(
      (s) =>
          s.id.toLowerCase() == query ||
          s.name.toLowerCase() == query ||
          stationSelectionName(s).toLowerCase() == query,
      orElse: () => stations.first,
    );

    final targetX = station.position.dx;
    final targetY = station.position.dy;

    // Tentukan zoom scale saat memfokuskan stasiun
    final double targetScale = scale ?? 1.8;

    // Hitung pergeseran (translation) agar target berada tepat di tengah viewport
    final double translationX =
        (viewportSize.width / 2) - (targetX * targetScale);
    // Geser titik tengah ke atas (- 160) agar stasiun tidak tertutup bottom sheet
    // Jika tidak ada station yang di-select secara eksplisit (seperti saat initial load),
    // kita tidak perlu menggeser ke atas sejauh itu, tapi karena fungsi ini
    // juga dipakai saat memilih stasiun, biarkan logic-nya. Untuk initial load,
    // kita kurangi pergeserannya.
    final double yOffset = (scale != null && scale < 1.5) ? 0 : 160;
    final double translationY =
        (viewportSize.height / 2) - (targetY * targetScale) - yOffset;

    final Matrix4 targetMatrix =
        Matrix4.translationValues(translationX, translationY, 0.0) *
        Matrix4.diagonal3Values(targetScale, targetScale, 1.0);

    if (animate) {
      _animationMatrix =
          Matrix4Tween(
            begin: _transformController.value,
            end: targetMatrix,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Curves.fastOutSlowIn,
            ),
          );
      _animationController.forward(from: 0.0);
    } else {
      _transformController.value = targetMatrix;
    }
  }

  /// Zoom in/out relatif terhadap tengah viewport
  void _zoom(double factor) {
    final currentMatrix = _transformController.value.clone();
    final currentScale = currentMatrix.getMaxScaleOnAxis();
    final newScale = (currentScale * factor).clamp(0.15, 4.0);
    final scaleChange = newScale / currentScale;

    final RenderBox? box =
        _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final center = Offset(box.size.width / 2, box.size.height / 2);

    final tx = currentMatrix.getTranslation().x;
    final ty = currentMatrix.getTranslation().y;

    final newTx = center.dx - (center.dx - tx) * scaleChange;
    final newTy = center.dy - (center.dy - ty) * scaleChange;

    final targetMatrix =
        Matrix4.translationValues(newTx, newTy, 0.0) *
        Matrix4.diagonal3Values(newScale, newScale, 1.0);

    _animationMatrix =
        Matrix4Tween(
          begin: _transformController.value,
          end: targetMatrix,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Canvas size tetap besar untuk menampung semua jalur
    const mapCanvas = Size(kMapWidth, kMapHeight);

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);

        // Pantau perubahan stasiun terpilih untuk digeser ke tengah layar
        if (widget.selectedStation != _prevSelectedStation) {
          final tempPrev = _prevSelectedStation;
          _prevSelectedStation = widget.selectedStation;
          if (widget.selectedStation != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _centerOnStation(
                widget.selectedStation!,
                viewportSize,
                animate: tempPrev != null && _hasInitialized,
              );
              _hasInitialized = true;
            });
          }
        } else if (!_hasInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _centerOnStation(
              'Dukuh Atas LRT', // Default initial view position based on screenshot
              viewportSize,
              animate: false,
              scale: kInitialMapScale,
            );
            _hasInitialized = true;
          });
        }

        // Listener menangkap raw pointer events di luar gesture arena.
        return Stack(
          children: [
            Listener(
              onPointerDown: _onPointerDown,
              onPointerUp: (event) => _onPointerUp(event, mapCanvas),
              child: SizedBox.expand(
                child: InteractiveViewer(
                  key: _viewerKey,
                  transformationController: _transformController,
                  minScale: 0.15,
                  maxScale: 4.0,
                  constrained: false,
                  boundaryMargin: const EdgeInsets.only(
                    left: 350,
                    top: 150,
                    right: 150,
                    bottom: 150,
                  ),
                  child: SizedBox(
                    width: kMapWidth,
                    height: kMapHeight,
                    child: CustomPaint(
                      size: mapCanvas,
                      painter: SchematicMapPainter(
                        showColors: widget.showColors,
                        selectedStation: widget.selectedStation,
                        fromStation: widget.fromStation,
                        visibleLineIds: widget.visibleLineIds,
                        highlightedSegmentIds: widget.highlightedSegmentIds,
                        nearestStation: widget.nearestStationId,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Tombol Zoom 🔍+ / 🔍- ──
            Positioned(
              right: 12,
              top: 12,
              child: Column(
                children: [
                  _ZoomButton(icon: Icons.zoom_in, onTap: () => _zoom(1.4)),
                  const SizedBox(height: 8),
                  _ZoomButton(icon: Icons.zoom_out, onTap: () => _zoom(0.7)),
                  if (widget.onLocateUser != null) ...[
                    const SizedBox(height: 8),
                    _LocationButton(
                      isLoading: widget.isLocating,
                      onTap: widget.onLocateUser!,
                    ),
                  ],
                ],
              ),
            ),

            // ── Legenda Rute (tengah kiri, bisa di-hide) ──
            const Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _MapLegendToggle(),
            ),
          ],
        );
      },
    );
  }
}

class _LocationButton extends StatelessWidget {
  const _LocationButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context)!.mapLocateMe,
      child: GestureDetector(
        key: const Key('locate-user-button'),
        onTap: isLoading ? null : onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isLoading ? AppColors.primaryBlueLight : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(11),
                  child: CircularProgressIndicator(
                    key: Key('locate-user-progress'),
                    strokeWidth: 2.5,
                  ),
                )
              : const Icon(
                  Icons.my_location_rounded,
                  color: AppColors.primaryBlue,
                  size: 21,
                ),
        ),
      ),
    );
  }
}

/// Tombol zoom bulat dengan ikon magnifier glass
class _ZoomButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ZoomButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }
}

/// Chip kecil untuk menampilkan info transit (LRT/KRL + waktu tempuh)
class TransitChip extends StatelessWidget {
  final String lineType;
  final String destination;
  final String duration;
  final Color lineColor;

  const TransitChip({
    super.key,
    required this.lineType,
    required this.destination,
    required this.duration,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: lineColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                lineType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                destination,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                duration,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tombol aksi stasiun: Dari, Lewat, Ke, Info
class StationActionBar extends StatelessWidget {
  const StationActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.buttonDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ActionButton(
            label: AppLocalizations.of(context)!.mapActionFrom,
            onTap: () {},
          ),
          _ActionButton(
            label: AppLocalizations.of(context)!.mapActionVia,
            onTap: () {},
          ),
          _ActionButton(
            label: AppLocalizations.of(context)!.mapActionTo,
            onTap: () {},
          ),
          _ActionButton(
            label: AppLocalizations.of(context)!.mapActionInfo,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Filter chip untuk LRT Jabodebek, KRL Jabodetabek, Kontras
class LineFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  const LineFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.isDark = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.buttonDark
              : isSelected
              ? AppColors.primaryBlue
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.buttonDark : AppColors.primaryBlue,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: (isDark || isSelected)
                ? Colors.white
                : AppColors.primaryBlue,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Wrapper yang menampilkan legenda di tengah kiri dengan tombol hide/show
class _MapLegendToggle extends StatefulWidget {
  const _MapLegendToggle();

  @override
  State<_MapLegendToggle> createState() => _MapLegendToggleState();
}

class _MapLegendToggleState extends State<_MapLegendToggle>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isVisible = !_isVisible;
      if (_isVisible) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tombol Toggle (di atas legenda) ──
            GestureDetector(
              onTap: _toggle,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: AnimatedRotation(
                  turns: _isVisible ? 0.0 : 0.5,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // ── Panel Legenda (slide & fade) ──
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const _MapLegend(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget Legenda Rute Kereta Api
class _MapLegend extends StatelessWidget {
  const _MapLegend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.mapLegendTitle,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _LegendItem(
            code: "B",
            label: AppLocalizations.of(context)!.mapLegendBogor,
            color: AppColors.lineBogor,
          ),
          _LegendItem(
            code: "C",
            label: AppLocalizations.of(context)!.mapLegendCikarang,
            color: AppColors.lineCikarang,
          ),
          _LegendItem(
            code: "R",
            label: AppLocalizations.of(context)!.mapLegendRangkasbitung,
            color: AppColors.lineRangkasbitung,
          ),
          _LegendItem(
            code: "T",
            label: AppLocalizations.of(context)!.mapLegendTangerang,
            color: AppColors.lineTangerang,
          ),
          _LegendItem(
            code: "TP",
            label: AppLocalizations.of(context)!.mapLegendTanjungPriok,
            color: AppColors.lineTanjungPriok,
          ),
          _LegendItem(
            code: "M",
            label: AppLocalizations.of(context)!.mapLegendMrt,
            color: AppColors.lineMRT,
          ),
          _LegendItem(
            code: "BK",
            label: AppLocalizations.of(context)!.mapLegendLrtBekasi,
            color: AppColors.lineLRTBekasi,
          ),
          _LegendItem(
            code: "CB",
            label: AppLocalizations.of(context)!.mapLegendLrtCibubur,
            color: AppColors.lineLRTCibubur,
          ),
          _LegendItem(
            code: "S",
            label: AppLocalizations.of(context)!.mapLegendLrtJakarta,
            color: AppColors.lineLRTJakarta,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String code;
  final String label;
  final Color color;

  const _LegendItem({
    required this.code,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              code,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
