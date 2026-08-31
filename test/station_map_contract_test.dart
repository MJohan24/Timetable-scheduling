import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/core/theme/app_colors.dart';
import 'package:timetable/features/home/presentation/widgets/map_widgets.dart';
import 'package:timetable/shared/widgets/schematic_map_painter.dart';

Future<ByteData> _renderMapPixels({Set<String>? highlightedSegmentIds}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..drawColor(Colors.white, BlendMode.src);
  SchematicMapPainter(
    showColors: true,
    highlightedSegmentIds: highlightedSegmentIds,
  ).paint(canvas, const Size(kMapWidth, kMapHeight));
  final image = await recorder.endRecording().toImage(
    kMapWidth.toInt(),
    kMapHeight.toInt(),
  );
  final pixels = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  image.dispose();
  return pixels!;
}

bool _pixelMatches(ByteData pixels, Offset point, Color target) {
  final x = point.dx.round();
  final y = point.dy.round();
  final index = (y * kMapWidth.toInt() + x) * 4;
  final difference =
      (pixels.getUint8(index) - (target.r * 255).round()).abs() +
      (pixels.getUint8(index + 1) - (target.g * 255).round()).abs() +
      (pixels.getUint8(index + 2) - (target.b * 255).round()).abs();
  return difference < 40;
}

bool _regionContainsColor(ByteData pixels, Rect region, Color target) {
  for (var y = region.top.floor(); y <= region.bottom.ceil(); y++) {
    for (var x = region.left.floor(); x <= region.right.ceil(); x++) {
      if (_pixelMatches(pixels, Offset(x.toDouble(), y.toDouble()), target)) {
        return true;
      }
    }
  }
  return false;
}

void main() {
  StationData station(String id) =>
      stations.firstWhere((item) => item.id == id);

  test(
    'route highlight follows the existing rounded corner at original width',
    () async {
      final normal = await _renderMapPixels();
      final focused = await _renderMapPixels(
        highlightedSegmentIds: {
          mapRouteSegmentKey('cikarang_loop', 'C07', 'wp_kb_top'),
          mapRouteSegmentKey('cikarang_loop', 'wp_kb_top', 'wp_kb_left'),
          mapRouteSegmentKey('cikarang_loop', 'wp_kb_left', 'C08'),
        },
      );
      // Compare the entire bend, not only the straight sections between nodes.
      for (var y = 145; y < 225; y++) {
        for (var x = 1205; x < 1280; x++) {
          final point = Offset(x.toDouble(), y.toDouble());
          expect(
            _pixelMatches(focused, point, AppColors.lineCikarang),
            _pixelMatches(normal, point, AppColors.lineCikarang),
            reason: 'Route geometry changed at $point',
          );
        }
      }
      expect(
        _pixelMatches(
          focused,
          const Offset(1450, 510),
          const Color(0xFFCDD1DB),
        ),
        isTrue,
      );
    },
  );

  test('active and inactive edges share the same rounded bend', () async {
    final pixels = await _renderMapPixels(
      highlightedSegmentIds: {
        mapRouteSegmentKey('cikarang_loop', 'wp_kb_top', 'wp_kb_left'),
      },
    );
    expect(
      _pixelMatches(pixels, const Offset(1245, 167), AppColors.lineCikarang),
      isTrue,
    );
    expect(
      _pixelMatches(pixels, const Offset(1268, 193), const Color(0xFFCDD1DB)),
      isTrue,
    );
    expect(
      _pixelMatches(pixels, const Offset(1270, 165), Colors.white),
      isTrue,
    );
  });

  test(
    'inactive Cikarang crossing cannot cover the active Bogor route',
    () async {
      final pixels = await _renderMapPixels(
        highlightedSegmentIds: {
          mapRouteSegmentKey('bogor', 'B09', 'wp_bogor_manggarai_out'),
          mapRouteSegmentKey('bogor', 'wp_bogor_manggarai_out', 'B10'),
        },
      );
      expect(
        _pixelMatches(pixels, const Offset(1510, 1230), AppColors.lineBogor),
        isTrue,
        reason: 'The inactive Cikarang line must not cut the selected route',
      );
      expect(
        _pixelMatches(
          pixels,
          const Offset(1490, 1230),
          const Color(0xFFCDD1DB),
        ),
        isTrue,
      );
    },
  );

  test(
    'official station labels and public codes match supplied route maps',
    () {
      expect(station('asean').name, 'ASEAN Headquarters');
      expect(station('lebak_bulus').name, 'Lebak Bulus Bank Syariah Indonesia');
      expect(
        station('dukuh_atas_lrt_bk').name,
        'Dukuh Atas Bank Syariah Indonesia',
      );
      expect(station('pancoran_bk').name, 'Pancoran bank bjb');
      expect(station('jatibening_baru').name, 'Jati Bening Baru');
      expect(station('taman_mini').name, 'TMII');

      expect(station('jis').code, isEmpty);
      expect(station('tanjung_priok').code, 'TP04');
      expect(station('parung_panjang').code, 'R12');
      expect(station('cilejit').code, 'R14');
      expect(station('daru').code, 'R15');
      expect(station('tenjo').code, 'R16');
      expect(station('tigaraksa').code, 'R18');
      expect(station('cikoya').code, 'R19');
      expect(station('maja').code, 'R20');
      expect(station('citeras').code, 'R21');
      expect(station('rangkasbitung').code, 'R22');
      expect(station('pondok_rajeg').code, 'b23');
      expect(station('nambo').code, 'b26');
    },
  );

  test('station identity changes preserve schematic topology', () {
    expect(stations, hasLength(177));
    expect(transitLines, hasLength(11));
    expect(stations.map((item) => item.id).toSet(), hasLength(177));
    expect(
      transitLines.map((line) => line.id).toSet(),
      hasLength(transitLines.length),
    );
    expect(
      transitLines.firstWhere((line) => line.id == 'tanjung_priok').stationIds,
      containsAllInOrder(['ancol', 'jis', 'tanjung_priok']),
    );
    expect(station('cawang_krl').position, const Offset(1555, 1575));
    expect(station('cikoko_bk').position, const Offset(1600, 1644));
    expect(station('cikoko_cb').position, const Offset(1600, 1656));
  });

  test('map geometry fingerprint remains unchanged', () {
    expect(kInitialMapScale, 1.05);
    final geometry = <String>[
      '$kMapWidth|$kMapHeight',
      for (final item in stations)
        '${item.id}|${item.position.dx}|${item.position.dy}|${item.isWaypoint}',
      for (final line in transitLines)
        '${line.id}|${line.stationIds.join(',')}',
      for (final connection in walkingConnections)
        '${connection.fromStationId}|${connection.toStationId}|${connection.walkingMinutes}',
      for (final pair in kMergedStationPairs.entries)
        '${pair.key}|${pair.value}',
    ].join(';');

    var fingerprint = 0x811c9dc5;
    for (final codeUnit in geometry.codeUnits) {
      fingerprint ^= codeUnit;
      fingerprint = (fingerprint * 0x01000193) & 0xffffffff;
    }

    expect(fingerprint, 721664269);
  });

  test('route lines, nodes, and station labels use readable visual sizes', () {
    for (final line in transitLines) {
      expect(
        line.strokeWidth,
        kKrlLineIds.contains(line.id) ? 8 : 7,
        reason: '${line.id} has the wrong visual weight',
      );
    }

    expect(stationNodeRadius(station('bogor')), 12);
    expect(stationNodeRadius(station('bekasi')), 15);
    expect(stationNodeRadius(station('jis')), 7);
    expect(
      stationNodeRadius(
        const StationData(
          id: 'uncoded_krl_transit',
          name: 'Test',
          position: Offset.zero,
          isTransit: true,
          lines: ['bogor'],
        ),
      ),
      10,
    );
    expect(stationNodeRadius(station('bundaran_hi')), 12);
    expect(stationNodeRadius(station('setiabudi')), 14);

    expect(stationLabelFontSize(station('bogor')), 16);
    expect(stationLabelFontSize(station('bekasi')), 16);
    expect(kStationLabelFontWeight, FontWeight.w700);
    expect(kHubStationNameFontSize, 14);
    expect(kStationLabelOutlineWidth, 3.5);
    expect(kRegularStationLabelOffset, 32);
    expect(kTransitStationLabelOffset, 40);
  });

  test('reported station labels avoid nearby map components', () {
    final painter = SchematicMapPainter();

    expect(
      painter.stationLabelPositionFor(station('lebak_bulus')),
      LabelPos.top,
    );
    expect(painter.stationLabelPositionFor(station('sudirman')), LabelPos.top);
  });

  test('Jakarta Kota route badges leave room for the station hub', () async {
    final pixels = await _renderMapPixels();
    expect(
      _pixelMatches(pixels, const Offset(870, 246), AppColors.lineBogor),
      isTrue,
    );
    expect(
      _pixelMatches(pixels, const Offset(920, 246), AppColors.lineTanjungPriok),
      isTrue,
    );
  });

  test(
    'Sudirman label stays above the station and clear of the MRT line',
    () async {
      final pixels = await _renderMapPixels();
      expect(
        _pixelMatches(pixels, const Offset(1075, 965), AppColors.lineMRT),
        isTrue,
      );
      expect(
        _regionContainsColor(
          pixels,
          const Rect.fromLTRB(1089, 950, 1220, 975),
          AppColors.textPrimary,
        ),
        isTrue,
      );
    },
  );

  test('Cikoko to Cawang is a separate black walking overlay', () async {
    expect(walkingConnections, hasLength(1));
    expect(walkingConnections.single.fromStationId, 'cawang_krl');
    expect(walkingConnections.single.toStationId, 'cikoko_bk');
    expect(walkingConnections.single.walkingMinutes, 5);
    expect(
      transitLines.every(
        (line) =>
            !line.stationIds.contains('cawang_krl') ||
            !line.stationIds.contains('cikoko_bk'),
      ),
      isTrue,
    );

    final pixels = await _renderMapPixels();
    expect(
      _regionContainsColor(
        pixels,
        const Rect.fromLTRB(1585, 1590, 1604, 1634),
        Colors.black,
      ),
      isTrue,
    );
  });

  test('every drawable station resolves to a selectable station name', () {
    for (final item in stations.where((station) => !station.isWaypoint)) {
      expect(
        stationSelectionName(item),
        isNotEmpty,
        reason: '${item.id} tidak dapat dipilih dari peta',
      );
    }
    expect(stationSelectionName(station('manggarai_bk')), 'Manggarai');
    expect(stationSelectionName(station('setiabudi_lrt_cb')), 'Setiabudi');
  });

  test(
    'every merged interchange renders one hub at the line intersection',
    () async {
      final pixels = await _renderMapPixels();

      for (final pair in kMergedStationPairs.entries) {
        final primary = station(pair.key);
        final secondary = station(pair.value);
        final hubRect = mergedStationHubRect(primary, secondary);
        final intersection = Offset(
          (primary.position.dx + secondary.position.dx) / 2,
          (primary.position.dy + secondary.position.dy) / 2,
        );

        expect(hubRect.center, intersection);
        expect(hubRect.contains(primary.position), isTrue);
        expect(hubRect.contains(secondary.position), isTrue);
        expect(
          _pixelMatches(pixels, intersection.translate(0, -8), Colors.white),
          isTrue,
          reason: '${pair.key}/${pair.value} bukan satu hub gabungan',
        );
      }
    },
  );
}
