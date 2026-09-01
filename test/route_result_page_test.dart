import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/route_result/domain/entities/route_plan.dart';
import 'package:timetable/features/route_result/domain/repositories/route_repository.dart';
import 'package:timetable/features/route_result/domain/services/route_speech_service.dart';
import 'package:timetable/features/route_result/presentation/controllers/route_controller.dart';
import 'package:timetable/features/route_result/presentation/pages/route_result_page.dart';
import 'package:timetable/features/route_result/presentation/pages/route_map_preview_page.dart';
import 'package:timetable/features/home/presentation/widgets/map_widgets.dart';
import 'package:timetable/l10n/app_localizations.dart';
import 'package:timetable/shared/widgets/schematic_map_painter.dart';
import 'helpers/route_test_data.dart';

class _Repository implements RouteRepository {
  _Repository(this.handler);
  final Future<RoutePlan> Function() handler;

  @override
  Future<RoutePlan> plan({
    required String from,
    required String to,
    required RoutePreference preference,
    int passengerCount = 1,
  }) => handler();
}

class _Speech implements RouteSpeechService {
  @override
  Future<void> pause() async {}
  @override
  Future<void> speak(String text, String languageCode) async {}
  @override
  Future<void> stop() async {}
}

Widget _page(RouteController controller) => MaterialApp(
  locale: const Locale('id'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: RouteResultPage(controller: controller, from: 'bogor', to: 'tangerang'),
);

const _lrtCibubur = RouteLine(
  id: 'line-lrt-cibubur',
  slug: 'lrt_cibubur',
  name: 'LRT Jabodebek (Cibubur)',
  color: '#003399',
  serviceType: 'LRT',
);

const _krlBogor = RouteLine(
  id: 'line-bogor',
  slug: 'bogor',
  name: 'KRL Lin Bogor',
  color: '#E53935',
  serviceType: 'KRL',
);

RoutePlan _route(List<RouteStation> stations) => RoutePlan(
  from: stations.first.name,
  to: stations.last.name,
  travelTime: 20,
  fare: 4000,
  unitFare: 4000,
  currency: 'IDR',
  passengerCount: 1,
  stops: stations.length,
  serviceInfo: 'Layanan normal',
  hasTransit: stations.map((station) => station.line.slug).toSet().length > 1,
  transferCount:
      stations.map((station) => station.line.slug).toSet().length - 1,
  preference: RoutePreference.fastest,
  steps: const [],
  stationSequence: stations,
  exitGateA: 'Pintu utama',
  exitGateB: 'Area antar-jemput',
);

void main() {
  testWidgets('route page renders loading and exact retry error', (
    tester,
  ) async {
    final pending = Completer<RoutePlan>();
    final loading = RouteController(
      _Repository(() => pending.future),
      _Speech(),
    );
    await tester.pumpWidget(_page(loading));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());

    final failing = RouteController(
      _Repository(() async => throw Exception('offline')),
      _Speech(),
    );
    await tester.pumpWidget(_page(failing));
    await tester.pumpAndSettle();
    expect(
      find.text('Tidak dapat memuat rute. Periksa koneksi dan coba lagi.'),
      findsOneWidget,
    );
    expect(find.text('Coba Lagi'), findsOneWidget);
    expect(find.text('Halim'), findsNothing);
  });

  testWidgets('route page renders backend result and accessible controls', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = RouteController(
      _Repository(() async => testRoute),
      _Speech(),
    );
    await tester.pumpWidget(_page(controller));
    await tester.pumpAndSettle();

    expect(find.text('Bogor'), findsWidgets);
    expect(find.text('Tangerang'), findsWidgets);
    expect(find.text('134'), findsOneWidget);
    expect(find.text('Rp10.000'), findsWidgets);
    expect(find.text('Pindah peron di Duri'), findsOneWidget);
    expect(find.text('Lanjut naik KRL Lin Tangerang'), findsOneWidget);
    expect(find.byKey(const Key('journey-map-preview-button')), findsOneWidget);
    expect(find.text('Urutan stasiun'), findsNothing);

    await tester.tap(find.text('Aksesibel'));
    await tester.pumpAndSettle();
    expect(find.text('Bacakan Rute'), findsOneWidget);
    expect(find.text('Ulangi'), findsOneWidget);
    expect(find.text('Jeda'), findsOneWidget);
    expect(find.text('Hentikan'), findsOneWidget);
  });

  testWidgets('route timeline marks a pedestrian transfer distinctly', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = RouteController(
      _Repository(() async => testWalkingRoute),
      _Speech(),
    );

    await tester.pumpWidget(_page(controller));
    await tester.pumpAndSettle();

    expect(
      find.text('Berjalan dari Cikoko menuju Stasiun Cawang'),
      findsOneWidget,
    );
    expect(find.text('Lanjut naik KRL Lin Bogor'), findsOneWidget);
    expect(find.byKey(const ValueKey('route-timeline-walk-1')), findsOneWidget);
    expect(find.byKey(const Key('journey-map-preview-button')), findsNothing);
  });

  testWidgets('journey map preview focuses route lines and origin', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('id'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: RouteMapPreviewPage(route: testRoute),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pratinjau Line Perjalanan'), findsOneWidget);
    expect(find.text('Anda Di Sini: Bogor'), findsOneWidget);
    expect(find.text('Lin Bogor'), findsOneWidget);
    expect(find.text('Lin Tangerang'), findsOneWidget);
    expect(find.text('Semua Line'), findsOneWidget);

    MapView map = tester.widget(find.byType(MapView));
    expect(map.highlightedSegmentIds, isNotNull);

    await tester.tap(find.text('Semua Line'));
    await tester.pump();
    expect(find.text('Fokus Perjalanan'), findsOneWidget);
    map = tester.widget(find.byType(MapView));
    expect(map.highlightedSegmentIds, isNull);

    await tester.tap(find.text('Fokus Perjalanan'));
    await tester.pump();
    expect(find.text('Semua Line'), findsOneWidget);
    map = tester.widget(find.byType(MapView));
    expect(map.highlightedSegmentIds, isNotNull);
  });

  test('Dukuh Atas to Cikoko highlights only the travelled LRT edges', () {
    final route = _route(const [
      RouteStation(
        stationId: 'dukuh-atas',
        name: 'Dukuh Atas Bank Syariah Indonesia',
        nodeCode: 'CB01',
        line: _lrtCibubur,
      ),
      RouteStation(
        stationId: 'cikoko',
        name: 'Cikoko',
        nodeCode: 'CB06',
        line: _lrtCibubur,
      ),
    ]);

    final segments = routeMapSegmentIds(route);
    expect(segments, hasLength(7));
    expect(
      segments.every((segment) => segment.startsWith('lrt_cibubur|')),
      isTrue,
    );
    expect(
      segments,
      isNot(contains(mapRouteSegmentKey('lrt_cibubur', 'CB06', 'CB07'))),
    );
  });

  test('Dukuh Atas to Tebet skips the Cikoko-Cawang walking transfer', () {
    final route = _route(const [
      RouteStation(
        stationId: 'dukuh-atas',
        name: 'Dukuh Atas Bank Syariah Indonesia',
        nodeCode: 'CB01',
        line: _lrtCibubur,
      ),
      RouteStation(
        stationId: 'cikoko',
        name: 'Cikoko',
        nodeCode: 'CB06',
        line: _lrtCibubur,
      ),
      RouteStation(
        stationId: 'cawang',
        name: 'Cawang',
        nodeCode: 'B11',
        line: _krlBogor,
      ),
      RouteStation(
        stationId: 'tebet',
        name: 'Tebet',
        nodeCode: 'B10',
        line: _krlBogor,
      ),
    ]);

    final segments = routeMapSegmentIds(route);
    expect(segments, hasLength(8));
    expect(segments, contains(mapRouteSegmentKey('bogor', 'B11', 'B10')));
    expect(
      segments,
      isNot(contains(mapRouteSegmentKey('lrt_cibubur', 'CB06', 'CB07'))),
    );
  });

  test('single-line route highlights only its direct edge', () {
    final route = _route(const [
      RouteStation(
        stationId: 'cawang',
        name: 'Cawang',
        nodeCode: 'B11',
        line: _krlBogor,
      ),
      RouteStation(
        stationId: 'tebet',
        name: 'Tebet',
        nodeCode: 'B10',
        line: _krlBogor,
      ),
    ]);

    expect(routeMapSegmentIds(route), {
      mapRouteSegmentKey('bogor', 'B11', 'B10'),
    });
  });

  test('walking transfer does not highlight a rail segment across Cikoko', () {
    const route = RoutePlan(
      from: 'Dukuh Atas Bank Syariah Indonesia',
      to: 'Tebet',
      travelTime: 29,
      fare: 4000,
      unitFare: 4000,
      currency: 'IDR',
      passengerCount: 1,
      stops: 7,
      serviceInfo: 'Layanan normal',
      hasTransit: true,
      transferCount: 1,
      preference: RoutePreference.fastest,
      steps: [],
      stationSequence: [
        RouteStation(
          stationId: 'cikoko',
          name: 'Cikoko',
          nodeCode: 'CB06',
          line: RouteLine(
            id: 'line-lrt-cibubur',
            slug: 'lrt_cibubur',
            name: 'LRT Jabodebek (Cibubur)',
            color: '#003399',
            serviceType: 'LRT',
          ),
        ),
        RouteStation(
          stationId: 'cawang',
          name: 'Cawang',
          nodeCode: 'B11',
          line: RouteLine(
            id: 'line-bogor',
            slug: 'bogor',
            name: 'KRL Lin Bogor',
            color: '#E53935',
            serviceType: 'KRL',
          ),
        ),
        RouteStation(
          stationId: 'tebet',
          name: 'Tebet',
          nodeCode: 'B10',
          line: RouteLine(
            id: 'line-bogor',
            slug: 'bogor',
            name: 'KRL Lin Bogor',
            color: '#E53935',
            serviceType: 'KRL',
          ),
        ),
      ],
      exitGateA: 'Pintu utama',
      exitGateB: 'Area antar-jemput',
    );

    final segments = routeMapSegmentIds(route);
    expect(segments, contains(mapRouteSegmentKey('bogor', 'B11', 'B10')));
    expect(
      segments,
      isNot(contains(mapRouteSegmentKey('lrt_cibubur', 'CB06', 'CB07'))),
    );
  });
}
