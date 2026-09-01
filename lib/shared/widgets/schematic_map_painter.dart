import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// ════════════════════════════════════════════════════════════════════
// DATA MODELS
// ════════════════════════════════════════════════════════════════════

/// Data model untuk setiap stasiun di peta skematik
class StationData {
  final String id;
  final String name;
  final String code; // Kode stasiun resmi (e.g. "C08", "M01")
  final Offset position;
  final bool isTransit;
  final List<String> lines;
  final bool isWaypoint;

  const StationData({
    required this.id,
    required this.name,
    this.code = '',
    required this.position,
    this.isTransit = false,
    this.lines = const [],
    this.isWaypoint = false,
  });
}

/// Data model untuk satu jalur transit
class LineData {
  final String id;
  final String name;
  final Color color;
  final double strokeWidth;
  final List<String> stationIds;

  const LineData({
    required this.id,
    required this.name,
    required this.color,
    this.strokeWidth = 6.0,
    required this.stationIds,
  });
}

/// Stable key for one physical line segment between two station nodes.
String mapRouteSegmentKey(String lineId, String firstNode, String secondNode) {
  final nodes = [
    firstNode.trim().toLowerCase(),
    secondNode.trim().toLowerCase(),
  ]..sort();
  return '$lineId|${nodes[0]}|${nodes[1]}';
}

/// Node codes are line-specific. Waypoints do not have a public code, so
/// their stable schematic ID is used to keep every physical edge distinct.
String mapSegmentNodeIdentity(StationData station) {
  final code = station.code.trim();
  return code.isNotEmpty ? code : station.id;
}

/// Koneksi antarmoda yang ditempuh dengan berjalan kaki, bukan jalur rel.
class WalkingConnectionData {
  final String fromStationId;
  final String toStationId;
  final int walkingMinutes;

  const WalkingConnectionData({
    required this.fromStationId,
    required this.toStationId,
    required this.walkingMinutes,
  });
}

const List<WalkingConnectionData> walkingConnections = [
  WalkingConnectionData(
    fromStationId: 'cawang_krl',
    toStationId: 'cikoko_bk',
    walkingMinutes: 5,
  ),
];

/// Data model untuk landmark / tempat penting
class LandmarkData {
  final String id;
  final String name;
  final Offset position;
  final Color color;
  final IconData icon;

  const LandmarkData({
    required this.id,
    required this.name,
    required this.position,
    required this.color,
    required this.icon,
  });
}

// ════════════════════════════════════════════════════════════════════
// CANVAS CONSTANTS
// ════════════════════════════════════════════════════════════════════

const double kMapWidth = 2950.0;
const double kMapHeight = 3100.0;
const double kStationLabelFontSize = 16.0;
const FontWeight kStationLabelFontWeight = FontWeight.w700;
const double kHubStationNameFontSize = 14.0;
const double kStationLabelOutlineWidth = 3.5;
const double kRegularStationLabelOffset = 32.0;
const double kTransitStationLabelOffset = 40.0;

const Set<String> kKrlLineIds = {
  'bogor',
  'bogor_nambo',
  'cikarang_loop',
  'cikarang_east',
  'tangerang',
  'tanjung_priok',
  'rangkasbitung',
};

// Stasiun transit besar — ditampilkan sebagai pill besar dengan nama di tengah
const Set<String> _majorTransitIds = {'duri', 'jakarta_kota', 'cawang_lrt'};

// Dua node dapat mewakili satu stasiun fisik pada line yang berbeda. Posisi
// masing-masing node tetap dipertahankan agar geometri line tidak berubah.
const Map<String, String> kMergedStationPairs = <String, String>{
  'dukuh_atas_lrt_bk': 'dukuh_atas_lrt_cb',
  'setiabudi_lrt_bk': 'setiabudi_lrt_cb',
  'rasuna_said_bk': 'rasuna_said_cb',
  'kuningan_bk': 'kuningan_cb',
  'pancoran_bk': 'pancoran_cb',
  'cikoko_bk': 'cikoko_cb',
  'ciliwung_bk': 'ciliwung_cb',
  'cawang_lrt_bk': 'cawang_lrt_cb',
  'manggarai_bk': 'manggarai_cb',
  'tanah_abang_c': 'tanah_abang_r',
  'jakarta_kota_bk': 'jakarta_kota_tp',
  'kampung_bandan': 'kampung_bandan_tp',
  'duri_c': 'duri_t',
};

// ════════════════════════════════════════════════════════════════════
// STATION DATABASE  (~119 stasiun unik)
// ════════════════════════════════════════════════════════════════════

final List<StationData> stations = [
  StationData(
    id: 'manggarai',
    name: '',
    position: Offset(1375.0, 1125.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'bundaran_hi',
    name: 'Bundaran HI Bank Jakarta',
    code: 'M13',
    position: Offset(1075.0, 810.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'dukuh_atas',
    name: 'Dukuh Atas BNI',
    code: 'M12',
    position: Offset(1075.0, 915.0),
    isTransit: true,
    lines: ['mrt', 'lrt_bekasi', 'lrt_cibubur'],
  ),
  StationData(
    id: 'wp_mrt_1',
    name: '',
    position: Offset(1075.0, 1035.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_2',
    name: '',
    position: Offset(1045.0, 1065.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'setiabudi',
    name: 'Setiabudi Astra',
    code: 'M11',
    position: Offset(955.0, 1155.0),
    isTransit: true,
    lines: ['mrt', 'lrt_bekasi', 'lrt_cibubur'],
  ),
  StationData(
    id: 'bendungan_hilir',
    name: 'Bendungan Hilir',
    code: 'M10',
    position: Offset(835.0, 1275.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'istora',
    name: 'Istora Mandiri',
    code: 'M09',
    position: Offset(745.0, 1365.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'wp_mrt_3',
    name: '',
    position: Offset(700.0, 1410.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_4',
    name: '',
    position: Offset(700.0, 1440.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'senayan',
    name: 'Senayan Mastercard',
    code: 'M08',
    position: Offset(700.0, 1530.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'asean',
    name: 'ASEAN Headquarters',
    code: 'M07',
    position: Offset(700.0, 1635.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'blok_m',
    name: 'Blok M BCA',
    code: 'M06',
    position: Offset(700.0, 1740.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'blok_a',
    name: 'Blok A',
    code: 'M05',
    position: Offset(700.0, 1845.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'haji_nawi',
    name: 'Haji Nawi',
    code: 'M04',
    position: Offset(700.0, 1950.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'cipete_raya',
    name: 'Cipete Raya TUKU',
    code: 'M03',
    position: Offset(700.0, 2055.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'wp_mrt_5',
    name: '',
    position: Offset(700.0, 2130.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_6',
    name: '',
    position: Offset(670.0, 2160.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'fatmawati',
    name: 'Fatmawati Indomaret',
    code: 'M02',
    position: Offset(565.0, 2160.0),
    lines: ['mrt'],
  ),
  StationData(
    id: 'lebak_bulus',
    name: 'Lebak Bulus Bank Syariah Indonesia',
    code: 'M01',
    position: Offset(325.0, 2160.0),
    lines: ['mrt'],
  ),

  StationData(
    id: 'wp_mrt_dukuh',
    name: '',
    position: Offset(925.0, 1125.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_istora',
    name: '',
    position: Offset(700.0, 1350.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_fatmawati',
    name: '',
    position: Offset(700.0, 2100.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'tanah_abang_r',
    name: 'Tanah Abang',
    code: 'R01',
    position: Offset(550.0, 825.0),
    isTransit: true,
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'wp_rangkas_1',
    name: '',
    position: Offset(550.0, 865.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'palmerah',
    name: 'Palmerah',
    code: 'R02',
    position: Offset(520.0, 895.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'wp_rangkas_2',
    name: '',
    position: Offset(490.0, 925.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'kebayoran',
    name: 'Kebayoran',
    code: 'R03',
    position: Offset(490.0, 965.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'wp_rangkas_3',
    name: '',
    position: Offset(490.0, 1005.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'pondok_ranji',
    name: 'Pondok Ranji',
    code: 'R04',
    position: Offset(450.0, 1045.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'jurangmangu',
    name: 'Jurangmangu',
    code: 'R05',
    position: Offset(410.0, 1085.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'sudimara',
    name: 'Sudimara',
    code: 'R06',
    position: Offset(370.0, 1125.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'wp_rangkas_4',
    name: '',
    position: Offset(330.0, 1165.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'rawa_buntu',
    name: 'Rawa Buntu',
    code: 'R07',
    position: Offset(270.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'serpong',
    name: 'Serpong',
    code: 'R08',
    position: Offset(230.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cisauk',
    name: 'Cisauk',
    code: 'R09',
    position: Offset(190.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cicayur',
    name: 'Cicayur',
    code: 'R10',
    position: Offset(150.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'parung_panjang',
    name: 'Parung Panjang',
    code: 'R12',
    position: Offset(110.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cilejit',
    name: 'Cilejit',
    code: 'R14',
    position: Offset(70.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'daru',
    name: 'Daru',
    code: 'R15',
    position: Offset(30.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'tenjo',
    name: 'Tenjo',
    code: 'R16',
    position: Offset(-10.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'tigaraksa',
    name: 'Tigaraksa',
    code: 'R18',
    position: Offset(-50.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cikoya',
    name: 'Cikoya',
    code: 'R19',
    position: Offset(-90.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'maja',
    name: 'Maja',
    code: 'R20',
    position: Offset(-130.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'citeras',
    name: 'Citeras',
    code: 'R21',
    position: Offset(-170.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'rangkasbitung',
    name: 'Rangkasbitung',
    code: 'R22',
    position: Offset(-210.0, 1165.0),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'bogor',
    name: 'Bogor',
    code: 'B26',
    position: Offset(2080.0, 2925.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'cilebut',
    name: 'Cilebut',
    code: 'B24',
    position: Offset(1975.0, 2925.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'bojong_gede',
    name: 'Bojong Gede',
    code: 'B23',
    position: Offset(1870.0, 2925.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'citayam',
    name: 'Citayam',
    code: 'B22',
    position: Offset(1765.0, 2925.0),
    lines: ['bogor', 'bogor_nambo'],
  ),
  StationData(
    id: 'depok',
    name: 'Depok',
    code: 'B21',
    position: Offset(1660.0, 2925.0),
    lines: ['bogor'],
  ),

  StationData(
    id: 'wp_curve_depok',
    name: '',
    position: Offset(1555.0, 2925.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_nambo_split',
    name: '',
    position: Offset(1810.0, 2925.0),
    isWaypoint: true,
  ),

  StationData(
    id: 'wp_nambo_up',
    name: '',
    position: Offset(1810.0, 2775.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'pondok_rajeg',
    name: 'Pondok Rajeg',
    code: 'b23',
    position: Offset(1885.0, 2775.0),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'cibinong',
    name: 'Cibinong',
    code: 'b24',
    position: Offset(1960.0, 2775.0),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'gunung_putri',
    name: 'Gunung Putri',
    code: 'b25',
    position: Offset(2035.0, 2775.0),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'nambo',
    name: 'Nambo',
    code: 'b26',
    position: Offset(2110.0, 2775.0),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'depok_baru',
    name: 'Depok Baru',
    code: 'B20',
    position: Offset(1555.0, 2775.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'pondok_cina',
    name: 'Pondok Cina',
    code: 'B19',
    position: Offset(1555.0, 2625.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'univ_indonesia',
    name: 'Universitas Indonesia',
    code: 'B18',
    position: Offset(1555.0, 2475.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'univ_pancasila',
    name: 'Universitas Pancasila',
    code: 'B17',
    position: Offset(1555.0, 2325.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'lenteng_agung',
    name: 'Lenteng Agung',
    code: 'B16',
    position: Offset(1555.0, 2175.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'tanjung_barat',
    name: 'Tanjung Barat',
    code: 'B15',
    position: Offset(1555.0, 2025.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'pasar_minggu',
    name: 'Pasar Minggu',
    code: 'B14',
    position: Offset(1555.0, 1875.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'pasar_minggu_baru',
    name: 'Pasar Minggu Baru',
    code: 'B13',
    position: Offset(1555.0, 1800.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'duren_kalibata',
    name: 'Duren Kalibata',
    code: 'B12',
    position: Offset(1555.0, 1725.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'cawang_krl',
    name: 'Cawang',
    code: 'B11',
    position: Offset(1555.0, 1575.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'tebet',
    name: 'Tebet',
    code: 'B10',
    position: Offset(1555.0, 1425.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'wp_bogor_manggarai_out',
    name: '',
    position: Offset(1555.0, 1275.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'manggarai_bk',
    name: '',
    code: 'B09',
    position: Offset(1390.0, 1110.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'cikini',
    name: 'Cikini',
    code: 'B08',
    position: Offset(1300.0, 1020.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'gondangdia',
    name: 'Gondangdia',
    code: 'B07',
    position: Offset(1225.0, 945.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'wp_bogor_gondangdia',
    name: '',
    position: Offset(1150.0, 870.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'juanda',
    name: 'Juanda',
    code: 'B05',
    position: Offset(1150.0, 705.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'sawah_besar',
    name: 'Sawah Besar',
    code: 'B04',
    position: Offset(1150.0, 585.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'mangga_besar',
    name: 'Mangga Besar',
    code: 'B03',
    position: Offset(1150.0, 465.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'jayakarta',
    name: 'Jayakarta',
    code: 'B02',
    position: Offset(1150.0, 345.0),
    lines: ['bogor'],
  ),
  StationData(
    id: 'wp_bogor_jayakarta',
    name: '',
    position: Offset(1150.0, 264.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'jakarta_kota_bk',
    name: 'Jakarta Kota',
    code: 'B01',
    position: Offset(1000.0, 264.0),
    isTransit: true,
    lines: ['bogor'],
  ),
  StationData(
    id: 'cikarang',
    name: 'Cikarang',
    code: 'C26',
    position: Offset(2770.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'metland_telagamurni',
    name: 'Metland Telaga Murni',
    code: 'C25',
    position: Offset(2680.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'cibitung',
    name: 'Cibitung',
    code: 'C24',
    position: Offset(2590.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'tambun',
    name: 'Tambun',
    code: 'C23',
    position: Offset(2500.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'bekasi_timur',
    name: 'Bekasi Timur',
    code: 'C22',
    position: Offset(2410.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'bekasi',
    name: 'Bekasi',
    code: 'C21',
    position: Offset(2320.0, 1230.0),
    isTransit: true,
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'kranji',
    name: 'Kranji',
    code: 'C20',
    position: Offset(2230.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'cakung',
    name: 'Cakung',
    code: 'C19',
    position: Offset(2140.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'klender_baru',
    name: 'Klender Baru',
    code: 'C18',
    position: Offset(2050.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'buaran',
    name: 'Buaran',
    code: 'C17',
    position: Offset(1960.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'klender',
    name: 'Klender',
    code: 'C16',
    position: Offset(1870.0, 1230.0),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'kampung_bandan',
    name: 'Kampung Bandan',
    code: 'C07',
    position: Offset(1270.0, 255.0),
    isTransit: true,
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'angke',
    name: 'Angke',
    code: 'C08',
    position: Offset(550.0, 525.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'duri_c',
    name: 'Duri',
    code: 'C09',
    position: Offset(550.0, 675.0),
    isTransit: true,
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'duri_t',
    name: 'Duri',
    code: 'T01',
    position: Offset(550.0, 675.0),
    isTransit: true,
    lines: ['tangerang'],
  ),
  StationData(
    id: 'tanah_abang_c',
    name: 'Tanah Abang',
    code: 'C10',
    position: Offset(550.0, 825.0),
    isTransit: true,
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_tanah_abang_c1',
    name: '',
    position: Offset(550.0, 900.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_tanah_abang_c2',
    name: '',
    position: Offset(655.0, 1005.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'grogol',
    name: 'Grogol',
    code: 'T02',
    position: Offset(490.0, 675.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'wp_tangerang_1',
    name: '',
    position: Offset(460.0, 675.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'pesing',
    name: 'Pesing',
    code: 'T03',
    position: Offset(420.0, 715.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'wp_tangerang_2',
    name: '',
    position: Offset(380.0, 755.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'taman_kota',
    name: 'Taman Kota',
    code: 'T04',
    position: Offset(350.0, 755.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'bojong_indah',
    name: 'Bojong Indah',
    code: 'T05',
    position: Offset(270.0, 755.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'rawa_buaya',
    name: 'Rawa Buaya',
    code: 'T06',
    position: Offset(190.0, 755.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'kalideres',
    name: 'Kalideres',
    code: 'T07',
    position: Offset(110.0, 755.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'poris',
    name: 'Poris',
    code: 'T08',
    position: Offset(30.0, 755.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'batu_ceper',
    name: 'Batu Ceper',
    code: 'T09',
    position: Offset(-50.0, 755.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'tanah_tinggi',
    name: 'Tanah Tinggi',
    code: 'T10',
    position: Offset(-130.0, 755.0),
    lines: ['tangerang'],
  ),
  StationData(
    id: 'tangerang',
    name: 'Tangerang',
    code: 'T11',
    position: Offset(-210.0, 755.0),
    lines: ['tangerang'],
  ),

  StationData(
    id: 'karet',
    name: 'Karet',
    code: 'C11',
    position: Offset(700.0, 1005.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'bni_city',
    name: 'BNI City',
    code: 'C11a',
    position: Offset(1000.0, 1005.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'sudirman',
    name: 'Sudirman',
    code: 'C12',
    position: Offset(1105.0, 1005.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_sudirman',
    name: '',
    position: Offset(1255.0, 1005.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'manggarai_cb',
    name: 'Manggarai',
    code: 'C13',
    position: Offset(1375.0, 1125.0),
    isTransit: true,
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_manggarai2',
    name: '',
    position: Offset(1480.0, 1230.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'matraman',
    name: 'Matraman',
    code: 'C14',
    position: Offset(1540.0, 1230.0),
    lines: ['cikarang_loop', 'cikarang_east'],
  ),
  StationData(
    id: 'jatinegara',
    name: 'Jatinegara',
    code: 'C15',
    position: Offset(1690.0, 1230.0),
    isTransit: true,
    lines: ['cikarang_loop', 'cikarang_east'],
  ),
  StationData(
    id: 'wp_cikarang_jatinegara',
    name: '',
    position: Offset(1600.0, 1230.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'pondok_jati',
    name: 'Pondok Jati',
    code: 'C01',
    position: Offset(1600.0, 1110.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_pj_curve',
    name: '',
    position: Offset(1600.0, 1020.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'kramat',
    name: 'Kramat',
    code: 'C02',
    position: Offset(1540.0, 960.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'gang_sentiong',
    name: 'Gang Sentiong',
    code: 'C03',
    position: Offset(1480.0, 900.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_gs_curve',
    name: '',
    position: Offset(1450.0, 870.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'pasar_senen',
    name: 'Pasar Senen',
    code: 'C04',
    position: Offset(1450.0, 690.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'kemayoran',
    name: 'Kemayoran',
    code: 'C05',
    position: Offset(1450.0, 570.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'rajawali',
    name: 'Rajawali',
    code: 'C06',
    position: Offset(1450.0, 450.0),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_s1',
    name: '',
    position: Offset(1450.0, 405.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_s2',
    name: '',
    position: Offset(1405.0, 360.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_s3',
    name: '',
    position: Offset(1315.0, 360.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_s4',
    name: '',
    position: Offset(1270.0, 315.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_kb_top',
    name: '',
    position: Offset(1270.0, 165.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_kb_left',
    name: '',
    position: Offset(550.0, 165.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'jakarta_kota_tp',
    name: 'Jakarta Kota',
    code: 'TP01',
    position: Offset(1000.0, 240.0),
    isTransit: true,
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'kampung_bandan_tp',
    name: '',
    code: 'TP02',
    position: Offset(1270.0, 240.0),
    isTransit: true,
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'ancol',
    name: 'Ancol',
    code: 'TP03',
    position: Offset(1450.0, 240.0),
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'jis',
    name: 'Jakarta Int. Stadium',
    position: Offset(1600.0, 240.0),
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'wp_tp_curve1',
    name: '',
    position: Offset(1660.0, 240.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_tp_curve2',
    name: '',
    position: Offset(1720.0, 180.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'tanjung_priok',
    name: 'Tanjung Priok',
    code: 'TP04',
    position: Offset(1720.0, 90.0),
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'pegangsaan_dua',
    name: 'Pegangsaan Dua',
    code: 'S01',
    position: Offset(1900.0, 375.0),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'boulevard_utara',
    name: 'Boulevard Utara',
    code: 'S02',
    position: Offset(1900.0, 480.0),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'boulevard_selatan',
    name: 'Boulevard Selatan',
    code: 'S03',
    position: Offset(1900.0, 585.0),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'pulomas',
    name: 'Pulomas',
    code: 'S04',
    position: Offset(1900.0, 690.0),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'equestrian',
    name: 'Equestrian',
    code: 'S05',
    position: Offset(1900.0, 795.0),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'velodrome',
    name: 'Velodrome',
    code: 'S06',
    position: Offset(1750.0, 795.0),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'dukuh_atas_lrt_bk',
    name: 'Dukuh Atas Bank Syariah Indonesia',
    code: 'BK01',
    position: Offset(1180.0, 1119.0),
    isTransit: true,
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'dukuh_atas_lrt_cb',
    name: '',
    code: 'CB01',
    position: Offset(1180.0, 1131.0),
    isTransit: true,
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'wp_lrt_dukuh_bk',
    name: '',
    position: Offset(1306.0, 1119.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_lrt_dukuh_cb',
    name: '',
    position: Offset(1294.0, 1131.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'setiabudi_lrt_bk',
    name: 'Setiabudi',
    code: 'BK02',
    position: Offset(1306.0, 1245.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'setiabudi_lrt_cb',
    name: '',
    code: 'CB02',
    position: Offset(1294.0, 1245.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'rasuna_said_bk',
    name: 'Rasuna Said',
    code: 'BK03',
    position: Offset(1306.0, 1365.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'rasuna_said_cb',
    name: '',
    code: 'CB03',
    position: Offset(1294.0, 1365.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'kuningan_bk',
    name: 'Kuningan',
    code: 'BK04',
    position: Offset(1306.0, 1485.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'kuningan_cb',
    name: '',
    code: 'CB04',
    position: Offset(1294.0, 1485.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'wp_lrt_kuningan_bk',
    name: '',
    position: Offset(1306.0, 1644.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_lrt_kuningan_cb',
    name: '',
    position: Offset(1294.0, 1656.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'pancoran_bk',
    name: 'Pancoran bank bjb',
    code: 'BK05',
    position: Offset(1450.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'pancoran_cb',
    name: '',
    code: 'CB05',
    position: Offset(1450.0, 1656.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'cikoko_bk',
    name: 'Cikoko',
    code: 'BK06',
    position: Offset(1600.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cikoko_cb',
    name: '',
    code: 'CB06',
    position: Offset(1600.0, 1656.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'ciliwung_bk',
    name: 'Ciliwung',
    code: 'BK07',
    position: Offset(1750.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'ciliwung_cb',
    name: '',
    code: 'CB07',
    position: Offset(1750.0, 1656.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'cawang_lrt_bk',
    name: 'Cawang',
    code: 'BK08',
    position: Offset(1900.0, 1644.0),
    isTransit: true,
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cawang_lrt_cb',
    name: '',
    code: 'CB08',
    position: Offset(1900.0, 1656.0),
    isTransit: true,
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'halim',
    name: 'Halim',
    code: 'BK09',
    position: Offset(2050.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'jatibening_baru',
    name: 'Jati Bening Baru',
    code: 'BK10',
    position: Offset(2200.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cikunir_1',
    name: 'Cikunir 1',
    code: 'BK11',
    position: Offset(2350.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cikunir_2',
    name: 'Cikunir 2',
    code: 'BK12',
    position: Offset(2500.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'bekasi_barat',
    name: 'Bekasi Barat',
    code: 'BK13',
    position: Offset(2650.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'jatimulya',
    name: 'Jati Mulya',
    code: 'BK14',
    position: Offset(2800.0, 1644.0),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'wp_lrt_cawang_cb',
    name: '',
    position: Offset(1960.0, 1656.0),
    isWaypoint: true,
  ),
  StationData(
    id: 'taman_mini',
    name: 'TMII',
    code: 'CB09',
    position: Offset(1960.0, 1806.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'kampung_rambutan',
    name: 'Kampung Rambutan',
    code: 'CB10',
    position: Offset(1960.0, 1956.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'ciracas',
    name: 'Ciracas',
    code: 'CB11',
    position: Offset(1960.0, 2106.0),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'harjamukti',
    name: 'Harjamukti',
    code: 'CB12',
    position: Offset(1960.0, 2256.0),
    lines: ['lrt_cibubur'],
  ),
];

final Map<String, String> _stationSelectionNames = () {
  final names = <String, String>{
    for (final station in stations) station.id: station.name,
  };
  for (final pair in kMergedStationPairs.entries) {
    final name = names[pair.key]!.isNotEmpty
        ? names[pair.key]!
        : names[pair.value]!;
    names[pair.key] = name;
    names[pair.value] = name;
  }
  return Map<String, String>.unmodifiable(names);
}();

String stationSelectionName(StationData station) =>
    _stationSelectionNames[station.id] ?? station.name;

// ════════════════════════════════════════════════════════════════════
// LINE DATABASE
// ════════════════════════════════════════════════════════════════════

final List<LineData> transitLines = [
  LineData(
    id: 'bogor',
    name: 'KRL Lin Bogor',
    color: AppColors.lineBogor,
    strokeWidth: 8,
    stationIds: [
      'jakarta_kota_bk',
      'wp_bogor_jayakarta',
      'jayakarta',
      'mangga_besar',
      'sawah_besar',
      'juanda',
      'wp_bogor_gondangdia',
      'gondangdia',
      'cikini',
      'manggarai_bk',
      'wp_bogor_manggarai_out',
      'tebet',
      'cawang_krl',
      'duren_kalibata',
      'pasar_minggu_baru',
      'pasar_minggu',
      'tanjung_barat',
      'lenteng_agung',
      'univ_pancasila',
      'univ_indonesia',
      'pondok_cina',
      'depok_baru',
      'wp_curve_depok',
      'depok',
      'citayam',
      'bojong_gede',
      'cilebut',
      'bogor',
    ],
  ),
  LineData(
    id: 'bogor_nambo',
    name: 'KRL Cabang Nambo',
    color: AppColors.lineBogor,
    strokeWidth: 8,
    stationIds: [
      'citayam',
      'wp_nambo_split',
      'wp_nambo_up',
      'pondok_rajeg',
      'cibinong',
      'gunung_putri',
      'nambo',
    ],
  ),
  LineData(
    id: 'cikarang_loop',
    name: 'KRL Cikarang Loop',
    color: AppColors.lineCikarang,
    strokeWidth: 8,
    stationIds: [
      'jatinegara',
      'wp_cikarang_jatinegara',
      'pondok_jati',
      'wp_cikarang_pj_curve',
      'kramat',
      'gang_sentiong',
      'wp_cikarang_gs_curve',
      'pasar_senen',
      'kemayoran',
      'rajawali',
      'wp_s1',
      'wp_s2',
      'wp_s3',
      'wp_s4',
      'kampung_bandan',
      'wp_kb_top',
      'wp_kb_left',
      'angke',
      'duri_c',
      'tanah_abang_c',
      'wp_tanah_abang_c1',
      'wp_tanah_abang_c2',
      'karet',
      'bni_city',
      'sudirman',
      'wp_cikarang_sudirman',
      'manggarai_cb',
      'wp_cikarang_manggarai2',
      'matraman',
      'wp_cikarang_jatinegara',
      'jatinegara',
    ],
  ),
  LineData(
    id: 'cikarang_east',
    name: 'KRL Cikarang Timur',
    color: AppColors.lineCikarang,
    strokeWidth: 8,
    stationIds: [
      'jatinegara',
      'klender',
      'buaran',
      'klender_baru',
      'cakung',
      'kranji',
      'bekasi',
      'bekasi_timur',
      'tambun',
      'cibitung',
      'metland_telagamurni',
      'cikarang',
    ],
  ),
  LineData(
    id: 'tangerang',
    name: 'KRL Lin Tangerang',
    color: AppColors.lineTangerang,
    strokeWidth: 8,
    stationIds: [
      'duri_t',
      'grogol',
      'wp_tangerang_1',
      'pesing',
      'wp_tangerang_2',
      'taman_kota',
      'bojong_indah',
      'rawa_buaya',
      'kalideres',
      'poris',
      'batu_ceper',
      'tanah_tinggi',
      'tangerang',
    ],
  ),
  LineData(
    id: 'tanjung_priok',
    name: 'KRL Lin Tanjung Priok',
    color: AppColors.lineTanjungPriok,
    strokeWidth: 8,
    stationIds: [
      'jakarta_kota_tp',
      'kampung_bandan_tp',
      'ancol',
      'jis',
      'wp_tp_curve1',
      'wp_tp_curve2',
      'tanjung_priok',
    ],
  ),
  LineData(
    id: 'rangkasbitung',
    name: 'KRL Lin Rangkasbitung',
    color: AppColors.lineRangkasbitung,
    strokeWidth: 8,
    stationIds: [
      'tanah_abang_r',
      'wp_rangkas_1',
      'palmerah',
      'wp_rangkas_2',
      'kebayoran',
      'wp_rangkas_3',
      'pondok_ranji',
      'jurangmangu',
      'sudimara',
      'wp_rangkas_4',
      'rawa_buntu',
      'serpong',
      'cisauk',
      'cicayur',
      'parung_panjang',
      'cilejit',
      'daru',
      'tenjo',
      'tigaraksa',
      'cikoya',
      'maja',
      'citeras',
      'rangkasbitung',
    ],
  ),
  LineData(
    id: 'mrt',
    name: 'MRT Jakarta',
    color: AppColors.lineMRT,
    strokeWidth: 7,
    stationIds: [
      'bundaran_hi',
      'dukuh_atas',
      'wp_mrt_1',
      'wp_mrt_2',
      'setiabudi',
      'bendungan_hilir',
      'istora',
      'wp_mrt_3',
      'wp_mrt_4',
      'senayan',
      'asean',
      'blok_m',
      'blok_a',
      'haji_nawi',
      'cipete_raya',
      'wp_mrt_5',
      'wp_mrt_6',
      'fatmawati',
      'lebak_bulus',
    ],
  ),
  LineData(
    id: 'lrt_bekasi',
    name: 'LRT Jabodebek (Bekasi)',
    color: AppColors.lineLRTBekasi,
    strokeWidth: 7,
    stationIds: [
      'dukuh_atas_lrt_bk',
      'wp_lrt_dukuh_bk',
      'setiabudi_lrt_bk',
      'rasuna_said_bk',
      'kuningan_bk',
      'wp_lrt_kuningan_bk',
      'pancoran_bk',
      'cikoko_bk',
      'ciliwung_bk',
      'cawang_lrt_bk',
      'halim',
      'jatibening_baru',
      'cikunir_1',
      'cikunir_2',
      'bekasi_barat',
      'jatimulya',
    ],
  ),
  LineData(
    id: 'lrt_cibubur',
    name: 'LRT Jabodebek (Cibubur)',
    color: AppColors.lineLRTCibubur,
    strokeWidth: 7,
    stationIds: [
      'dukuh_atas_lrt_cb',
      'wp_lrt_dukuh_cb',
      'setiabudi_lrt_cb',
      'rasuna_said_cb',
      'kuningan_cb',
      'wp_lrt_kuningan_cb',
      'pancoran_cb',
      'cikoko_cb',
      'ciliwung_cb',
      'cawang_lrt_cb',
      'wp_lrt_cawang_cb',
      'taman_mini',
      'kampung_rambutan',
      'ciracas',
      'harjamukti',
    ],
  ),
  LineData(
    id: 'lrt_jakarta',
    name: 'LRT Jakarta',
    color: AppColors.lineLRTJakarta,
    strokeWidth: 7,
    stationIds: [
      'pegangsaan_dua',
      'boulevard_utara',
      'boulevard_selatan',
      'pulomas',
      'equestrian',
      'velodrome',
    ],
  ),
];

// ════════════════════════════════════════════════════════════════════
// LANDMARK / POI DATABASE
// ════════════════════════════════════════════════════════════════════

const List<LandmarkData> landmarks = [];

// ════════════════════════════════════════════════════════════════════
// HELPER FUNCTIONS
// ════════════════════════════════════════════════════════════════════

StationData? _findStation(String id) {
  for (final s in stations) {
    if (s.id == id) return s;
  }
  return null;
}

Color _getStationColor(StationData station) {
  for (final line in transitLines) {
    if (line.stationIds.contains(station.id)) {
      return line.color;
    }
  }
  return AppColors.textSecondary;
}

bool _isKrlStation(StationData station) =>
    station.lines.any(kKrlLineIds.contains) ||
    transitLines.any(
      (line) =>
          kKrlLineIds.contains(line.id) && line.stationIds.contains(station.id),
    );

double stationNodeRadius(StationData station) {
  if (!_isKrlStation(station)) {
    return station.code.isNotEmpty
        ? (station.isTransit ? 14 : 12)
        : (station.isTransit ? 8 : 5.5);
  }
  return station.code.isNotEmpty
      ? (station.isTransit ? 15 : 12)
      : (station.isTransit ? 10 : 7);
}

double stationLabelFontSize(StationData _) => kStationLabelFontSize;

// ════════════════════════════════════════════════════════════════════
// SCHEMATIC MAP PAINTER
// ════════════════════════════════════════════════════════════════════

enum LabelPos { top, bottom, left, right, topRotated, bottomRotated }

const Map<String, LabelPos> _majorCodeBadgePos = {
  'lebak_bulus': LabelPos.right,
  'jakarta_kota': LabelPos.top,
  'kampung_bandan': LabelPos.top,
  'duri': LabelPos.top,
  'cawang_lrt': LabelPos.bottom,
};

TextPainter _buildMajorHubTextPainter(
  StationData station, {
  bool isFrom = false,
}) {
  final nameSpan = TextSpan(
    text: station.name,
    style: TextStyle(
      color: isFrom ? AppColors.primaryBlue : AppColors.textPrimary,
      fontSize: kHubStationNameFontSize,
      fontWeight: FontWeight.w800,
    ),
  );
  return TextPainter(text: nameSpan, textDirection: TextDirection.ltr)
    ..layout();
}

Rect _majorHubRect(StationData station) {
  final nameTp = _buildMajorHubTextPainter(station);
  return Rect.fromCenter(
    center: station.position,
    width: nameTp.width + 18,
    height: 24,
  );
}

String _mergedStationName(StationData primary, StationData secondary) =>
    primary.name.isNotEmpty ? primary.name : secondary.name;

TextPainter _buildMergedHubTextPainter(
  StationData primary,
  StationData secondary,
) => TextPainter(
  text: TextSpan(
    text: _mergedStationName(primary, secondary),
    style: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: kHubStationNameFontSize,
      fontWeight: FontWeight.w800,
    ),
  ),
  textDirection: TextDirection.ltr,
)..layout();

Rect mergedStationHubRect(StationData primary, StationData secondary) {
  final center = Offset(
    (primary.position.dx + secondary.position.dx) / 2,
    (primary.position.dy + secondary.position.dy) / 2,
  );
  final nameWidth = _buildMergedHubTextPainter(primary, secondary).width;
  return Rect.fromCenter(
    center: center,
    width: max(
      nameWidth + 18,
      (primary.position.dx - secondary.position.dx).abs() + 2,
    ),
    height: max(24, (primary.position.dy - secondary.position.dy).abs() + 2),
  );
}

class SchematicMapPainter extends CustomPainter {
  final bool showColors;
  final String? selectedStation;
  final String? fromStation;
  final Set<String>? visibleLineIds;
  final Set<String>? highlightedSegmentIds;
  final String? nearestStation;

  SchematicMapPainter({
    this.showColors = false,
    this.selectedStation,
    this.fromStation,
    this.visibleLineIds,
    this.highlightedSegmentIds,
    this.nearestStation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background text removed based on user request
    // 1. Draw lines with rounded corners
    _drawLines(canvas);
    // 2. Draw pedestrian transfers as an independent overlay
    _drawWalkingConnections(canvas);
    // 3. Draw landmarks
    _drawLandmarks(canvas);
    // 4. Draw station nodes (dots, code badges)
    _drawStations(canvas);
    // 5. Draw the nearest-station marker as a separate overlay
    _drawNearestStationMarker(canvas);
    // 6. Draw station labels
    _drawAllLabels(canvas);
    // 7. Draw line route identity badges
    _drawLineBadges(canvas);
  }

  void _drawNearestStationMarker(Canvas canvas) {
    if (nearestStation == null) return;
    final station = _findStation(nearestStation!);
    if (station == null) return;

    var center = station.position;
    final pairedId =
        kMergedStationPairs[station.id] ??
        kMergedStationPairs.entries
            .where((entry) => entry.value == station.id)
            .map((entry) => entry.key)
            .firstOrNull;
    final paired = pairedId == null ? null : _findStation(pairedId);
    if (paired != null) {
      center = Offset(
        (center.dx + paired.position.dx) / 2,
        (center.dy + paired.position.dy) / 2,
      );
    }

    canvas.drawCircle(
      center,
      23,
      Paint()..color = const Color(0xFF1976D2).withValues(alpha: 0.16),
    );
    canvas.drawCircle(
      center,
      19,
      Paint()
        ..color = const Color(0xFF1976D2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
    canvas.drawCircle(center, 4, Paint()..color = const Color(0xFF1976D2));
  }

  // ── DRAW LINES ──────────────────────────────────────────────────

  void _drawLines(Canvas canvas) {
    final activePaths = <(Path, Color, double)>[];
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final line in transitLines) {
      final bool isVisible =
          visibleLineIds == null || visibleLineIds!.contains(line.id);
      final activeColor = showColors
          ? line.color
          : line.color.withValues(alpha: 0.85);
      final inactiveColor = highlightedSegmentIds != null
          ? const Color(0xFFCDD1DB)
          : line.color.withValues(alpha: 0.08);
      paint.strokeWidth = line.strokeWidth;
      void drawRun(Path path, Color color) {
        // Paint each segment once, with inactive crossings underneath the route.
        if (highlightedSegmentIds != null && color == activeColor) {
          activePaths.add((path, color, line.strokeWidth));
        } else {
          canvas.drawPath(path, paint..color = color);
        }
      }

      final lineStations = <StationData>[];
      for (final stationId in line.stationIds) {
        final station = _findStation(stationId);
        if (station != null) lineStations.add(station);
      }
      final points = lineStations.map((station) => station.position).toList();
      var path = Path();
      var index = 0;
      Color? previousColor;
      // Render each existing edge once; join equal-status edges into one stroke.
      for (final segment in _roundedPathSegments(points)) {
        final from = lineStations[index];
        final to = lineStations[index + 1];
        final active =
            isVisible &&
            (highlightedSegmentIds == null ||
                highlightedSegmentIds!.contains(
                  mapRouteSegmentKey(
                    line.id,
                    mapSegmentNodeIdentity(from),
                    mapSegmentNodeIdentity(to),
                  ),
                ));
        final color = active ? activeColor : inactiveColor;
        if (previousColor != null && color != previousColor) {
          drawRun(path, previousColor);
          path = Path();
        }
        path.extendWithPath(segment, Offset.zero);
        previousColor = color;
        index++;
      }
      if (previousColor != null) {
        drawRun(path, previousColor);
      }
    }
    for (final (path, color, width) in activePaths) {
      canvas.drawPath(
        path,
        paint
          ..color = color
          ..strokeWidth = width,
      );
    }
  }

  void _drawWalkingConnections(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final connection in walkingConnections) {
      final from = _findStation(connection.fromStationId);
      final to = _findStation(connection.toStationId);
      if (from == null || to == null) continue;

      final paired = _findStation(kMergedStationPairs[to.id] ?? '');
      final destination = paired == null
          ? to.position
          : Offset(
              (to.position.dx + paired.position.dx) / 2,
              (to.position.dy + paired.position.dy) / 2,
            );
      final start = from.position.translate(0, 12);
      final end = destination.translate(0, -14);
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(
          start.dx,
          start.dy + 18,
          end.dx,
          start.dy + 18,
          end.dx,
          end.dy,
        );
      canvas.drawPath(path, paint);
    }
  }

  /// Split the original rounded path at each node's curve midpoint so a change
  /// of edge color never replaces a bend with a straight station-to-station line.
  Iterable<Path> _roundedPathSegments(
    List<Offset> points, {
    double cornerRadius = 45,
  }) sync* {
    if (points.length < 2) return;
    var path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length - 1; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];

      final d1 = p1 - p0;
      final d2 = p2 - p1;
      final len1 = d1.distance;
      final len2 = d2.distance;

      // Jangan round kalau segmen terlalu pendek atau lurus
      final maxR = min(len1 / 2, len2 / 2);
      final r = min(cornerRadius, maxR);
      final dot = (d1.dx * d2.dx + d1.dy * d2.dy) / (len1 * len2);

      if (r < 2 || dot.abs() > 0.99) {
        path.lineTo(p1.dx, p1.dy);
        yield path;
        path = Path()..moveTo(p1.dx, p1.dy);
      } else {
        final before = Offset(
          p1.dx - d1.dx / len1 * r,
          p1.dy - d1.dy / len1 * r,
        );
        final after = Offset(
          p1.dx + d2.dx / len2 * r,
          p1.dy + d2.dy / len2 * r,
        );
        // De Casteljau subdivision preserves the exact quadratic curve.
        final firstControl = (before + p1) / 2;
        final secondControl = (p1 + after) / 2;
        final midpoint = (firstControl + secondControl) / 2;
        path.lineTo(before.dx, before.dy);
        path.quadraticBezierTo(
          firstControl.dx,
          firstControl.dy,
          midpoint.dx,
          midpoint.dy,
        );
        yield path;
        path = Path()
          ..moveTo(midpoint.dx, midpoint.dy)
          ..quadraticBezierTo(
            secondControl.dx,
            secondControl.dy,
            after.dx,
            after.dy,
          );
      }
    }
    path.lineTo(points.last.dx, points.last.dy);
    yield path;
  }

  // ── DRAW LANDMARKS ──────────────────────────────────────────────

  void _drawLandmarks(Canvas canvas) {
    for (final lm in landmarks) {
      final dx = lm.position.dx;
      final dy = lm.position.dy;
      const double iconSize = 14.0;

      // Draw background circle for icon to make it pop
      canvas.drawCircle(
        lm.position,
        iconSize / 1.5,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        lm.position,
        iconSize / 1.5,
        Paint()
          ..color = lm.color.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill,
      );

      // Draw Icon using TextPainter
      final iconSpan = TextSpan(
        text: String.fromCharCode(lm.icon.codePoint),
        style: TextStyle(
          color: lm.color,
          fontSize: iconSize,
          fontFamily: lm.icon.fontFamily,
          package: lm.icon.fontPackage,
        ),
      );
      final iconTp = TextPainter(
        text: iconSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      iconTp.paint(
        canvas,
        Offset(dx - iconTp.width / 2, dy - iconTp.height / 2),
      );

      // Label
      final span = TextSpan(
        text: lm.name,
        style: TextStyle(
          color: lm.color,
          fontSize: 8,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
        ),
      );
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(canvas, Offset(dx + 12, dy - tp.height / 2));
    }
  }

  // ── DRAW STATIONS ───────────────────────────────────────────────

  void _drawStations(Canvas canvas) {
    // Track merged pairs yang sudah digambar agar tidak duplikat
    final drawnMerged = <String>{};

    for (final station in stations) {
      if (station.isWaypoint) continue;
      final isSelected =
          selectedStation == station.id || selectedStation == station.name;
      final isFrom = fromStation == station.id || fromStation == station.name;

      bool stationVisible = true;
      if (visibleLineIds != null) {
        stationVisible = transitLines.any(
          (line) =>
              visibleLineIds!.contains(line.id) &&
              line.stationIds.contains(station.id),
        );
        if (!stationVisible && station.lines.isNotEmpty) {
          stationVisible = station.lines.any(
            (l) => visibleLineIds!.contains(l),
          );
        }
      }
      if (!stationVisible) continue;

      // Cek apakah stasiun ini bagian dari pasangan merged
      final isBkPrimary = kMergedStationPairs.containsKey(station.id);
      final isCbSecondary = kMergedStationPairs.containsValue(station.id);

      if (isBkPrimary || isCbSecondary) {
        // Tentukan id primary
        final primaryId = isBkPrimary
            ? station.id
            : kMergedStationPairs.entries
                  .firstWhere((e) => e.value == station.id)
                  .key;
        if (drawnMerged.contains(primaryId)) continue; // Sudah digambar
        drawnMerged.add(primaryId);

        final secondaryId = kMergedStationPairs[primaryId]!;
        final primaryStation = _findStation(primaryId);
        final secondaryStation = _findStation(secondaryId);
        if (primaryStation != null && secondaryStation != null) {
          _drawMergedNode(canvas, primaryStation, secondaryStation);
        }
        continue;
      }

      if (_majorTransitIds.contains(station.id)) {
        _drawMajorTransitHub(
          canvas,
          station,
          isSelected: isSelected,
          isFrom: isFrom,
        );
      } else {
        _drawStationNode(
          canvas,
          station,
          isSelected: isSelected,
          isFrom: isFrom,
        );
      }
    }
  }

  void _drawSelectionHalo(
    Canvas canvas,
    Offset center, {
    required bool isSelected,
    required bool isFrom,
    required double radius,
  }) {
    if (!isSelected && !isFrom) return;
    final color = isSelected ? AppColors.primaryPurple : AppColors.primaryBlue;
    canvas.drawCircle(
      center,
      radius + 7,
      Paint()..color = color.withValues(alpha: 0.16),
    );
    canvas.drawCircle(
      center,
      radius + 3,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    canvas.drawCircle(
      center,
      radius + 5,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  /// Gambar node gabungan:
  /// Rounded rect pill dengan nama stasiun di tengah, badge secondary kiri/bawah & primary kanan/atas
  void _drawMergedNode(
    Canvas canvas,
    StationData primaryStation,
    StationData secondaryStation,
  ) {
    // Hitung titik tengah antara dua posisi stasiun (line tetap terpisah)
    final center = Offset(
      (primaryStation.position.dx + secondaryStation.position.dx) / 2,
      (primaryStation.position.dy + secondaryStation.position.dy) / 2,
    );
    final isSelected =
        selectedStation == primaryStation.id ||
        selectedStation == secondaryStation.id ||
        selectedStation == primaryStation.name ||
        selectedStation == secondaryStation.name;
    final isFrom =
        fromStation == primaryStation.id ||
        fromStation == secondaryStation.id ||
        fromStation == primaryStation.name ||
        fromStation == secondaryStation.name;

    final nameTp = _buildMergedHubTextPainter(primaryStation, secondaryStation);
    final hubRect = mergedStationHubRect(primaryStation, secondaryStation);
    final rrect = RRect.fromRectAndRadius(hubRect, const Radius.circular(12));

    _drawSelectionHalo(
      canvas,
      center,
      isSelected: isSelected,
      isFrom: isFrom,
      radius: 24,
    );

    // White fill
    canvas.drawRRect(rrect, Paint()..color = Colors.white);

    // Border
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = isSelected || isFrom
            ? AppColors.primaryBlue
            : AppColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3 : 2.5,
    );

    // Nama stasiun di tengah
    nameTp.paint(
      canvas,
      Offset(center.dx - nameTp.width / 2, center.dy - nameTp.height / 2),
    );

    // Hitung lebar/tinggi badge untuk posisi yang presisi
    double badgeWidth(String code) {
      final tp = TextPainter(
        text: TextSpan(
          text: code,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      return tp.width + 8;
    }

    const gap = 4.0;
    const badgeH = 15.0;

    // Deteksi orientasi: jika dx beda → garis vertikal → badge kiri/kanan
    //                     jika dy beda → garis horizontal → badge atas/bawah
    final dxDiff = (primaryStation.position.dx - secondaryStation.position.dx)
        .abs();
    final dyDiff = (primaryStation.position.dy - secondaryStation.position.dy)
        .abs();
    final isVerticalLine = dxDiff >= dyDiff;

    if (primaryStation.id == 'kampung_bandan') {
      // Custom Kampung Bandan: Primary di Kiri, Secondary di Kanan
      // Diturunkan sedikit (yOffset) agar tidak menabrak line pink (Tanjung Priok)
      const double customYOffset = 12.0;
      final primaryW = badgeWidth(primaryStation.code);
      _drawMergedBadge(
        canvas,
        code: primaryStation.code,
        color: _getStationColor(primaryStation),
        center: Offset(
          hubRect.left - gap - primaryW / 2,
          center.dy + customYOffset,
        ),
      );
      final secondaryW = badgeWidth(secondaryStation.code);
      _drawMergedBadge(
        canvas,
        code: secondaryStation.code,
        color: _getStationColor(secondaryStation),
        center: Offset(
          hubRect.right + gap + secondaryW / 2,
          center.dy + customYOffset,
        ),
      );
    } else if (primaryStation.id == 'jakarta_kota_bk') {
      // Custom Jakarta Kota: Atas Bawah
      _drawMergedBadge(
        canvas,
        code: primaryStation.code,
        color: _getStationColor(primaryStation),
        center: Offset(center.dx, hubRect.top - gap - badgeH / 2),
      );
      _drawMergedBadge(
        canvas,
        code: secondaryStation.code,
        color: _getStationColor(secondaryStation),
        center: Offset(center.dx, hubRect.bottom + gap + badgeH / 2),
      );
    } else if (primaryStation.id == 'duri_c') {
      // Custom Duri: zigzag (Kiri Atas untuk T01, Kanan Bawah untuk C09)
      // primaryStation = duri_c (C09), secondaryStation = duri_t (T01)
      const double zigzagOffsetTop = 22.0;
      const double zigzagOffsetBottom = 8.0;
      const double zigzagXOffsetLeft = 14.0; // Geser T01 ke kanan
      final cbW = badgeWidth(secondaryStation.code);
      _drawMergedBadge(
        canvas,
        code: secondaryStation.code,
        color: _getStationColor(secondaryStation),
        center: Offset(
          hubRect.left - gap - cbW / 2 + zigzagXOffsetLeft,
          center.dy - zigzagOffsetTop,
        ),
      );
      final bkW = badgeWidth(primaryStation.code);
      _drawMergedBadge(
        canvas,
        code: primaryStation.code,
        color: _getStationColor(primaryStation),
        center: Offset(
          hubRect.right + gap + bkW / 2,
          center.dy + zigzagOffsetBottom,
        ),
      );
    } else if (isVerticalLine) {
      // Garis vertikal → badge secondary di kiri, primary di kanan
      final cbW = badgeWidth(secondaryStation.code);
      _drawMergedBadge(
        canvas,
        code: secondaryStation.code,
        color: _getStationColor(secondaryStation),
        center: Offset(hubRect.left - gap - cbW / 2, center.dy),
      );
      final bkW = badgeWidth(primaryStation.code);
      _drawMergedBadge(
        canvas,
        code: primaryStation.code,
        color: _getStationColor(primaryStation),
        center: Offset(hubRect.right + gap + bkW / 2, center.dy),
      );
    } else {
      // Garis horizontal → badge primary di atas, secondary di bawah
      _drawMergedBadge(
        canvas,
        code: primaryStation.code,
        color: _getStationColor(primaryStation),
        center: Offset(center.dx, hubRect.top - gap - badgeH / 2),
      );
      _drawMergedBadge(
        canvas,
        code: secondaryStation.code,
        color: _getStationColor(secondaryStation),
        center: Offset(center.dx, hubRect.bottom + gap + badgeH / 2),
      );
    }
  }

  /// Helper: gambar pill badge kode stasiun
  void _drawMergedBadge(
    Canvas canvas, {
    required String code,
    required Color color,
    required Offset center,
  }) {
    if (code.isEmpty) return;
    final codeSpan = TextSpan(
      text: code,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
    );
    final codeTp = TextPainter(text: codeSpan, textDirection: TextDirection.ltr)
      ..layout();
    final badgeW = codeTp.width + 8;
    const badgeH = 15.0;
    final badgeRect = Rect.fromCenter(
      center: center,
      width: badgeW,
      height: badgeH,
    );
    final badgeRRect = RRect.fromRectAndRadius(
      badgeRect,
      const Radius.circular(6),
    );
    canvas.drawRRect(badgeRRect, Paint()..color = color);
    codeTp.paint(
      canvas,
      Offset(
        badgeRect.center.dx - codeTp.width / 2,
        badgeRect.center.dy - codeTp.height / 2,
      ),
    );
  }

  /// Stasiun transit besar: rounded rectangle besar dengan nama di tengah
  void _drawMajorTransitHub(
    Canvas canvas,
    StationData station, {
    bool isSelected = false,
    bool isFrom = false,
  }) {
    _drawSelectionHalo(
      canvas,
      station.position,
      isSelected: isSelected,
      isFrom: isFrom,
      radius: 30,
    );

    final nameTp = _buildMajorHubTextPainter(station, isFrom: isFrom);
    final hubRect = Rect.fromCenter(
      center: station.position,
      width: nameTp.width + 18,
      height: 24,
    );

    final rect = RRect.fromRectAndRadius(hubRect, const Radius.circular(12));

    // White fill
    canvas.drawRRect(rect, Paint()..color = Colors.white);

    // Border
    final borderColor = isSelected || isFrom
        ? AppColors.primaryBlue
        : AppColors.textPrimary;
    canvas.drawRRect(
      rect,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 3.0 : 2.5,
    );

    // Name centered
    nameTp.paint(
      canvas,
      Offset(
        station.position.dx - nameTp.width / 2,
        station.position.dy - nameTp.height / 2,
      ),
    );
  }

  /// Stasiun biasa: lingkaran berwarna dengan kode stasiun di dalamnya
  void _drawStationNode(
    Canvas canvas,
    StationData station, {
    bool isSelected = false,
    bool isFrom = false,
  }) {
    _drawSelectionHalo(
      canvas,
      station.position,
      isSelected: isSelected,
      isFrom: isFrom,
      radius: 13,
    );

    // Jika stasiun punya kode, gambar sebagai lingkaran berwarna dengan kode di dalam
    if (station.code.isNotEmpty) {
      final color = _getStationColor(station);
      final radius = stationNodeRadius(station);
      final effectiveR = isSelected || isFrom ? max(radius, 13.0) : radius;

      // Lingkaran putih (latar)
      canvas.drawCircle(
        station.position,
        effectiveR,
        Paint()..color = Colors.white,
      );

      // Lingkaran berwarna (border tebal)
      final borderColor = isSelected || isFrom ? AppColors.primaryBlue : color;
      canvas.drawCircle(
        station.position,
        effectiveR,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );

      // Teks kode stasiun di tengah lingkaran
      // Pisahkan huruf dan angka agar bisa ditampilkan dua baris
      final codeText = station.code;
      final letterPart = codeText.replaceAll(RegExp(r'[0-9]'), '');
      final numberPart = codeText.replaceAll(RegExp(r'[^0-9]'), '');

      if (letterPart.isNotEmpty && numberPart.isNotEmpty) {
        // Dua baris: huruf di atas, angka di bawah
        final letterTp = TextPainter(
          text: TextSpan(
            text: letterPart,
            style: TextStyle(
              color: isSelected || isFrom ? AppColors.primaryBlue : color,
              fontSize: 6.5,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final numberTp = TextPainter(
          text: TextSpan(
            text: numberPart,
            style: TextStyle(
              color: isSelected || isFrom ? AppColors.primaryBlue : color,
              fontSize: 6.5,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final totalH = letterTp.height + numberTp.height + 1;
        final startY = station.position.dy - totalH / 2;
        letterTp.paint(
          canvas,
          Offset(station.position.dx - letterTp.width / 2, startY),
        );
        numberTp.paint(
          canvas,
          Offset(
            station.position.dx - numberTp.width / 2,
            startY + letterTp.height + 1,
          ),
        );
      } else {
        // Satu baris saja (hanya huruf atau hanya angka)
        final codeTp = TextPainter(
          text: TextSpan(
            text: codeText,
            style: TextStyle(
              color: isSelected || isFrom ? AppColors.primaryBlue : color,
              fontSize: 7,
              fontWeight: FontWeight.w900,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        codeTp.paint(
          canvas,
          Offset(
            station.position.dx - codeTp.width / 2,
            station.position.dy - codeTp.height / 2,
          ),
        );
      }
    } else {
      // Stasiun tanpa kode — gambar dot biasa
      final radius = stationNodeRadius(station);
      final effectiveR = isSelected || isFrom ? max(radius, 10.0) : radius;

      canvas.drawCircle(
        station.position,
        effectiveR,
        Paint()..color = Colors.white,
      );

      final borderColor = isSelected || isFrom
          ? AppColors.primaryBlue
          : station.isTransit
          ? AppColors.textPrimary
          : AppColors.textSecondary;
      canvas.drawCircle(
        station.position,
        effectiveR,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = station.isTransit ? 2.5 : 1.5,
      );

      if (station.isTransit || isSelected || isFrom) {
        canvas.drawCircle(
          station.position,
          isSelected || isFrom ? 3 : 2,
          Paint()
            ..color = isFrom ? AppColors.primaryBlue : AppColors.textPrimary,
        );
      }
    }
  }

  Rect _codeBadgeRect(StationData station, [double? textWidth]) {
    final codeWidth =
        textWidth ??
        (TextPainter(
          text: TextSpan(
            text: station.code,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ), // Diperbesar dari 7
          ),
          textDirection: TextDirection.ltr,
        )..layout()).width;
    final badgeW = codeWidth + 8;
    const badgeH = 15.0; // Diperbesar sedikit untuk mengakomodasi font 9

    Offset badgeCenter;
    final isMajor = _majorTransitIds.contains(station.id);
    if (isMajor) {
      final hubRect = _majorHubRect(station);
      final badgePos = _majorCodeBadgePos[station.id] ?? LabelPos.top;
      const gap = 4.0;
      switch (badgePos) {
        case LabelPos.top:
          badgeCenter = Offset(
            hubRect.left + badgeW / 2 + 2,
            hubRect.top - gap - badgeH / 2,
          );
          break;
        case LabelPos.bottom:
          badgeCenter = Offset(
            hubRect.right - badgeW / 2 - 2,
            hubRect.bottom + gap + badgeH / 2,
          );
          break;
        case LabelPos.left:
          badgeCenter = Offset(
            hubRect.left - gap - badgeW / 2,
            station.position.dy,
          );
          break;
        case LabelPos.right:
          badgeCenter = Offset(
            hubRect.right + gap + badgeW / 2,
            station.position.dy,
          );
          break;
        case LabelPos.topRotated:
          badgeCenter = Offset(
            hubRect.left + badgeW / 2 + 2,
            hubRect.top - gap - badgeH / 2,
          );
          break;
        case LabelPos.bottomRotated:
          badgeCenter = Offset(
            hubRect.right - badgeW / 2 - 2,
            hubRect.bottom + gap + badgeH / 2,
          );
          break;
      }
    } else {
      final pos = stationLabelPositionFor(station);
      final offset = station.isTransit ? 14.0 : 10.0;
      switch (pos) {
        case LabelPos.right:
          badgeCenter = Offset(
            station.position.dx - offset - badgeW / 2,
            station.position.dy,
          );
          break;
        case LabelPos.left:
          badgeCenter = Offset(
            station.position.dx + offset + badgeW / 2,
            station.position.dy,
          );
          break;
        case LabelPos.top:
          badgeCenter = Offset(
            station.position.dx,
            station.position.dy + offset + badgeH / 2,
          );
          break;
        case LabelPos.bottom:
          badgeCenter = Offset(
            station.position.dx,
            station.position.dy - offset - badgeH / 2,
          );
          break;
        case LabelPos.topRotated:
          badgeCenter = Offset(
            station.position.dx,
            station.position.dy + offset + badgeH / 2,
          );
          break;
        case LabelPos.bottomRotated:
          badgeCenter = Offset(
            station.position.dx,
            station.position.dy - offset - badgeH / 2,
          );
          break;
      }
    }

    return Rect.fromCenter(center: badgeCenter, width: badgeW, height: badgeH);
  }

  // ── DRAW LABELS ─────────────────────────────────────────────────

  void _drawAllLabels(Canvas canvas) {
    final occupied = <Rect>[];
    for (final station in stations) {
      if (station.isWaypoint) continue;
      bool stationVisible = true;
      if (visibleLineIds != null) {
        stationVisible = transitLines.any(
          (line) =>
              visibleLineIds!.contains(line.id) &&
              line.stationIds.contains(station.id),
        );
      }
      if (!stationVisible) continue;

      if (_majorTransitIds.contains(station.id)) {
        occupied.add(_majorHubRect(station).inflate(7));
      } else {
        final radius = stationNodeRadius(station) + 4;
        occupied.add(Rect.fromCircle(center: station.position, radius: radius));
      }
      if (station.code.isNotEmpty) {
        occupied.add(_codeBadgeRect(station).inflate(3));
      }
    }

    for (final station in stations) {
      if (station.isWaypoint) continue;
      // Skip labels for major transit (nama sudah di dalam pill)
      if (_majorTransitIds.contains(station.id)) continue;
      // Skip labels for merged stations (nama sudah di dalam pill gabungan)
      if (kMergedStationPairs.containsKey(station.id) ||
          kMergedStationPairs.containsValue(station.id)) {
        continue;
      }

      bool stationVisible = true;
      if (visibleLineIds != null) {
        stationVisible = transitLines.any(
          (line) =>
              visibleLineIds!.contains(line.id) &&
              line.stationIds.contains(station.id),
        );
      }
      if (!stationVisible) continue;
      _drawLabel(canvas, station, occupied: occupied);
    }
  }

  void _drawLabel(Canvas canvas, StationData station, {List<Rect>? occupied}) {
    final fontSize = stationLabelFontSize(station);
    final isSelected =
        selectedStation == station.id || selectedStation == station.name;
    final labelColor = isSelected
        ? AppColors.primaryPurple
        : AppColors.textPrimary;

    final preferredPos = stationLabelPositionFor(station);

    // ── Rotated label (diagonal, seperti di PDF) ──
    if (preferredPos == LabelPos.topRotated) {
      final angle = -55 * pi / 180; // -55 derajat

      final strokeTextSpan = TextSpan(
        text: station.name,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: kStationLabelFontWeight,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = kStationLabelOutlineWidth
            ..color = Colors.white.withValues(alpha: 0.9),
        ),
      );
      final strokeTP = TextPainter(
        text: strokeTextSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final textSpan = TextSpan(
        text: station.name,
        style: TextStyle(
          color: labelColor,
          fontSize: fontSize,
          fontWeight: kStationLabelFontWeight,
        ),
      );
      final textTP = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final offset = station.isTransit
          ? kTransitStationLabelOffset
          : kRegularStationLabelOffset;
      // Pivot point = tepat di atas node, lebih jauh agar tidak numpuk line
      final pivotX = station.position.dx;
      final pivotY = station.position.dy - offset;

      canvas.save();
      canvas.translate(pivotX, pivotY);
      canvas.rotate(angle);
      // Gambar teks mulai dari origin (0,0) setelah rotate
      strokeTP.paint(canvas, Offset(0, -textTP.height));
      textTP.paint(canvas, Offset(0, -textTP.height));
      canvas.restore();
      return;
    }

    // ── Bottom Rotated label (diagonal di bawah node) ──
    if (preferredPos == LabelPos.bottomRotated) {
      final angle = -55 * pi / 180; // -55 derajat

      final strokeTextSpan = TextSpan(
        text: station.name,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: kStationLabelFontWeight,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = kStationLabelOutlineWidth
            ..color = Colors.white.withValues(alpha: 0.9),
        ),
      );
      final strokeTP = TextPainter(
        text: strokeTextSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final textSpan = TextSpan(
        text: station.name,
        style: TextStyle(
          color: labelColor,
          fontSize: fontSize,
          fontWeight: kStationLabelFontWeight,
        ),
      );
      final textTP = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final offset = station.isTransit
          ? kTransitStationLabelOffset
          : kRegularStationLabelOffset;
      // Pivot point = tepat di bawah node
      final pivotX = station.position.dx;
      final pivotY = station.position.dy + offset;

      canvas.save();
      canvas.translate(pivotX, pivotY);
      canvas.rotate(angle);
      strokeTP.paint(canvas, Offset(-textTP.width, 0));
      textTP.paint(canvas, Offset(-textTP.width, 0));
      canvas.restore();
      return;
    }

    // ── Normal label (non-rotated) ──
    // Stroke text painter (outline putih) agar tulisan mudah dibaca walau numpuk di garis
    final strokeTextSpan = TextSpan(
      text: station.name,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: kStationLabelFontWeight,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = kStationLabelOutlineWidth
          ..color = Colors.white.withValues(alpha: 0.9),
      ),
    );
    final strokeTextPainter = TextPainter(
      text: strokeTextSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final textSpan = TextSpan(
      text: station.name,
      style: TextStyle(
        color: labelColor,
        fontSize: fontSize,
        fontWeight: kStationLabelFontWeight,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final labelOffset = station.isTransit
        ? kTransitStationLabelOffset
        : kRegularStationLabelOffset;

    Rect rectFor(LabelPos pos) {
      double labelX, labelY;
      switch (pos) {
        case LabelPos.top:
          labelX = station.position.dx - (textPainter.width / 2);
          // Keep Sudirman clear of the MRT line immediately to its left.
          if (station.id == 'sudirman') {
            labelX = max(labelX, station.position.dx - 16);
          }
          labelY = station.position.dy - textPainter.height - labelOffset;
          break;
        case LabelPos.bottom:
          labelX = station.position.dx - (textPainter.width / 2);
          labelY = station.position.dy + labelOffset;
          break;
        case LabelPos.left:
          labelX = station.position.dx - textPainter.width - labelOffset;
          labelY = station.position.dy - (textPainter.height / 2);
          break;
        case LabelPos.right:
          labelX = station.position.dx + labelOffset;
          labelY = station.position.dy - (textPainter.height / 2);
          break;
        case LabelPos.topRotated:
        case LabelPos.bottomRotated:
          // Handled above, should not reach here
          labelX = station.position.dx;
          labelY = station.position.dy;
          break;
      }
      return Rect.fromLTWH(
        labelX,
        labelY,
        textPainter.width,
        textPainter.height,
      );
    }

    final candidates = <LabelPos>{
      preferredPos,
      LabelPos.top,
      LabelPos.bottom,
      LabelPos.right,
      LabelPos.left,
    };

    Rect labelRect = rectFor(preferredPos);
    if (occupied != null) {
      for (final pos in candidates) {
        final candidateRect = rectFor(pos);
        final overlaps = occupied.any(
          (rect) => rect.overlaps(candidateRect.inflate(2)),
        );
        if (!overlaps) {
          labelRect = candidateRect;
          break;
        }
      }
      occupied.add(labelRect.inflate(3));
    }

    strokeTextPainter.paint(canvas, labelRect.topLeft);
    textPainter.paint(canvas, labelRect.topLeft);
  }

  // ── LABEL POSITIONING ────────────────────────────────────────────

  @visibleForTesting
  LabelPos stationLabelPositionFor(StationData station) {
    final id = station.id;

    // ── Specific overrides ──
    const overrides = <String, LabelPos>{
      // Cikarang loop north side (vertical at x=1060) → right
      'pondok_jati': LabelPos.right, 'kramat': LabelPos.right,
      'gang_sentiong': LabelPos.right, 'pasar_senen': LabelPos.right,
      // Cikarang loop top (vertical section) → right
      'kemayoran': LabelPos.right, 'rajawali': LabelPos.right,
      // Bogor horizontal (y=2925) → topRotated
      'bogor': LabelPos.topRotated, 'cilebut': LabelPos.topRotated,
      'bojong_gede': LabelPos.topRotated, 'citayam': LabelPos.topRotated,
      'depok': LabelPos.topRotated,
      // Cikarang south diagonal
      'angke': LabelPos.right, 'matraman': LabelPos.top,
      'jatinegara': LabelPos.bottom,
      'bni_city': LabelPos.bottom,
      // Cikarang east (horizontal at y=1230) → topRotated (miring agar tidak tumpuk)
      'klender': LabelPos.topRotated, 'buaran': LabelPos.topRotated,
      'klender_baru': LabelPos.topRotated, 'cakung': LabelPos.topRotated,
      'kranji': LabelPos.topRotated, 'bekasi': LabelPos.topRotated,
      'bekasi_timur': LabelPos.topRotated, 'tambun': LabelPos.topRotated,
      'cibitung': LabelPos.topRotated,
      'metland_telagamurni': LabelPos.topRotated,
      'cikarang': LabelPos.topRotated,
      // Cikarang horizontal band (y=700) → bottom
      'tanah_abang': LabelPos.left,
      'karet': LabelPos.bottom, 'sudirman': LabelPos.top,
      // Tanjung Priok → topRotated
      'ancol': LabelPos.topRotated, 'jis': LabelPos.topRotated,
      'tanjung_priok': LabelPos.top,
      'kampung_bandan': LabelPos.top,
      // Tangerang horizontal → bottomRotated
      'grogol': LabelPos.top, 'pesing': LabelPos.bottomRotated,
      'taman_kota': LabelPos.bottomRotated,
      'bojong_indah': LabelPos.bottomRotated,
      'rawa_buaya': LabelPos.bottomRotated, 'kalideres': LabelPos.bottomRotated,
      'poris': LabelPos.bottomRotated, 'batu_ceper': LabelPos.bottomRotated,
      'tanah_tinggi': LabelPos.bottomRotated,
      'tangerang': LabelPos.bottomRotated,
      // Rangkasbitung diagonal → left
      'palmerah': LabelPos.left, 'kebayoran': LabelPos.left,
      'pondok_ranji': LabelPos.left, 'jurangmangu': LabelPos.left,
      'sudimara': LabelPos.left,
      // Rangkasbitung horizontal → bottomRotated
      'rawa_buntu': LabelPos.bottomRotated, 'serpong': LabelPos.bottomRotated,
      'cisauk': LabelPos.bottomRotated, 'cicayur': LabelPos.bottomRotated,
      'parung_panjang': LabelPos.bottomRotated,
      'cilejit': LabelPos.bottomRotated,
      'daru': LabelPos.bottomRotated, 'tenjo': LabelPos.bottomRotated,
      'tigaraksa': LabelPos.bottomRotated, 'cikoya': LabelPos.bottomRotated,
      'maja': LabelPos.bottomRotated, 'citeras': LabelPos.bottomRotated,
      'rangkasbitung': LabelPos.bottomRotated,
      // LRT diagonal/horizontal
      'rasuna_said': LabelPos.bottom, 'kuningan': LabelPos.bottom,
      'pancoran': LabelPos.top, 'cikoko': LabelPos.top,
      'ciliwung': LabelPos.top, 'cawang_lrt': LabelPos.bottom,
      // LRT Bekasi horizontal → topRotated
      'halim': LabelPos.topRotated, 'jatibening_baru': LabelPos.topRotated,
      'cikunir_1': LabelPos.topRotated, 'cikunir_2': LabelPos.topRotated,
      'bekasi_barat': LabelPos.topRotated, 'jatimulya': LabelPos.topRotated,
      // LRT Cibubur diagonal → right
      'taman_mini': LabelPos.right, 'kampung_rambutan': LabelPos.right,
      'ciracas': LabelPos.right, 'harjamukti': LabelPos.right,
      // Nambo branch → topRotated
      'pondok_rajeg': LabelPos.topRotated, 'cibinong': LabelPos.topRotated,
      'gunung_putri': LabelPos.topRotated, 'nambo': LabelPos.topRotated,
      // LRT Jakarta → right
      'pegangsaan_dua': LabelPos.right, 'boulevard_utara': LabelPos.right,
      'boulevard_selatan': LabelPos.right, 'pulomas': LabelPos.right,
      'equestrian': LabelPos.right, 'velodrome': LabelPos.bottom,
      // MRT → left
      'bundaran_hi': LabelPos.left,
      'bendungan_hilir': LabelPos.left, 'istora': LabelPos.left,
      'senayan': LabelPos.left, 'asean': LabelPos.left,
      'blok_m': LabelPos.left, 'blok_a': LabelPos.left,
      'haji_nawi': LabelPos.left, 'cipete_raya': LabelPos.left,
      'fatmawati': LabelPos.top, 'lebak_bulus': LabelPos.top,
      'setiabudi': LabelPos.left, 'dukuh_atas': LabelPos.left,
    };

    if (overrides.containsKey(id)) return overrides[id]!;

    // Default: Bogor line → right, others → right
    return LabelPos.right;
  }

  // ── DRAW LINE ROUTE IDENTITY BADGES ─────────────────────────────
  // Lingkaran besar bertuliskan kode rute (B, C, R, T, TP, M, BK, CB, S)
  // langsung di atas garis jalur, sesuai peta PDF resmi.

  void _drawLineBadges(Canvas canvas) {
    // Daftar badge: kode huruf, warna, posisi pada kanvas
    const badges = <_LineBadgeInfo>[
      // KRL Bogor (B) - di sebelah kiri Jakarta Kota, dekat Bogor, dan dekat Nambo
      _LineBadgeInfo('B', AppColors.lineBogor, Offset(870.0, 264.0)),
      _LineBadgeInfo('B', AppColors.lineBogor, Offset(2140.0, 2870.0)),
      _LineBadgeInfo('B', AppColors.lineBogor, Offset(2180.0, 2750.0)),
      // KRL Cikarang Loop (C) - di atas Jatinegara dan di bawah Cikarang
      _LineBadgeInfo('C', AppColors.lineCikarang, Offset(1680.0, 1170.0)),
      _LineBadgeInfo('C', AppColors.lineCikarang, Offset(2770.0, 1300.0)),
      // KRL Rangkasbitung (R) - di sebelah kiri Tanah Abang & di atas Rangkasbitung
      _LineBadgeInfo('R', AppColors.lineRangkasbitung, Offset(415.0, 825.0)),
      _LineBadgeInfo('R', AppColors.lineRangkasbitung, Offset(-210.0, 1120.0)),
      // KRL Tangerang (T) - dekat Duri (kanan) & di atas Tangerang
      _LineBadgeInfo('T', AppColors.lineTangerang, Offset(640.0, 675.0)),
      _LineBadgeInfo('T', AppColors.lineTangerang, Offset(-210.0, 705.0)),
      // KRL Tanjung Priok (TP) - di sebelah kiri Jakarta Kota & di atas Tanjung Priok
      _LineBadgeInfo('TP', AppColors.lineTanjungPriok, Offset(920.0, 264.0)),
      _LineBadgeInfo('TP', AppColors.lineTanjungPriok, Offset(1750.0, 60.0)),
      // MRT Jakarta (M) - dekat Bundaran HI (atas kiri) & dekat Lebak Bulus (kiri)
      _LineBadgeInfo('M', AppColors.lineMRT, Offset(1020.0, 760.0)),
      _LineBadgeInfo('M', AppColors.lineMRT, Offset(265.0, 2150.0)),
      // LRT Bekasi (BK) & Cibubur (CB) - di atas Dukuh Atas LRT, BK di bawah Jatimulya, dan CB di bawah Harjamukti
      _LineBadgeInfo('CB', AppColors.lineLRTCibubur, Offset(1160.0, 1060.0)),
      _LineBadgeInfo('BK', AppColors.lineLRTBekasi, Offset(1200.0, 1060.0)),
      _LineBadgeInfo('BK', AppColors.lineLRTBekasi, Offset(2800.0, 1690.0)),
      _LineBadgeInfo('CB', AppColors.lineLRTCibubur, Offset(1960.0, 2310.0)),
      // LRT Jakarta (S)
      _LineBadgeInfo('S', AppColors.lineLRTJakarta, Offset(1810.0, 690.0)),
    ];

    for (final badge in badges) {
      // Jika ada filter garis aktif, skip badge untuk garis yang tidak aktif
      if (visibleLineIds != null) {
        final lineId = _badgeToLineId(badge.code);
        if (lineId != null &&
            !visibleLineIds!.any((id) => lineId.contains(id))) {
          continue;
        }
      }
      // Preview perjalanan hanya menampilkan badge line yang punya segmen
      // aktif. Badge line lain tidak boleh membuat pengguna mengira line itu
      // ikut dilewati.
      if (highlightedSegmentIds != null) {
        final lineId = _badgeToLineId(badge.code);
        if (lineId == null ||
            !lineId.any(
              (id) => highlightedSegmentIds!.any(
                (segment) => segment.startsWith('$id|'),
              ),
            )) {
          continue;
        }
      }
      _drawSingleLineBadge(canvas, badge);
    }
  }

  /// Mapping kode badge ke line id(s) untuk filtering
  List<String>? _badgeToLineId(String code) {
    switch (code) {
      case 'B':
        return ['bogor', 'bogor_nambo'];
      case 'C':
        return ['cikarang_loop', 'cikarang_east'];
      case 'R':
        return ['rangkasbitung'];
      case 'T':
        return ['tangerang'];
      case 'TP':
        return ['tanjung_priok'];
      case 'M':
        return ['mrt'];
      case 'BK':
        return ['lrt_bekasi'];
      case 'CB':
        return ['lrt_cibubur'];
      case 'S':
        return ['lrt_jakarta'];
      default:
        return null;
    }
  }

  void _drawSingleLineBadge(Canvas canvas, _LineBadgeInfo badge) {
    const double outerRadius = 18.0;
    final center = badge.position;

    // Lingkaran putih (latar)
    canvas.drawCircle(center, outerRadius, Paint()..color = Colors.white);

    // Lingkaran tepi berwarna (border tebal)
    canvas.drawCircle(
      center,
      outerRadius,
      Paint()
        ..color = badge.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );

    // Teks kode rute di tengah lingkaran
    final textSpan = TextSpan(
      text: badge.code,
      style: TextStyle(
        color: badge.color,
        fontSize: badge.code.length > 1 ? 12 : 16,
        fontWeight: FontWeight.w900,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant SchematicMapPainter oldDelegate) {
    return oldDelegate.showColors != showColors ||
        oldDelegate.selectedStation != selectedStation ||
        oldDelegate.fromStation != fromStation ||
        oldDelegate.visibleLineIds != visibleLineIds ||
        oldDelegate.highlightedSegmentIds != highlightedSegmentIds ||
        oldDelegate.nearestStation != nearestStation;
  }
}

/// Data model untuk badge identitas rute
class _LineBadgeInfo {
  final String code;
  final Color color;
  final Offset position;

  const _LineBadgeInfo(this.code, this.color, this.position);
}
