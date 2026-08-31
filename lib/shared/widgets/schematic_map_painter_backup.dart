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

const double kMapWidth = 2600.0;
const double kMapHeight = 2200.0;

// Stasiun transit besar — ditampilkan sebagai pill besar dengan nama di tengah
const Set<String> _majorTransitIds = {
  'dukuh_atas',
  'duri',
  'jakarta_kota',
  'jatinegara',
  'cawang_lrt',
};

// ════════════════════════════════════════════════════════════════════
// STATION DATABASE  (~119 stasiun unik)
// ════════════════════════════════════════════════════════════════════

const List<StationData> stations = [
  StationData(
    id: 'manggarai',
    name: '',
    position: Offset(850, 750),
    isWaypoint: true,
  ),
  StationData(
    id: 'bundaran_hi',
    name: 'Bundaran HI Bank Jakarta',
    code: 'M13',
    position: Offset(650, 540),
    lines: ['mrt'],
  ),
  StationData(
    id: 'dukuh_atas',
    name: 'Dukuh Atas BNI',
    code: 'M12',
    position: Offset(650, 610),
    isTransit: true,
    lines: ['mrt', 'lrt_bekasi', 'lrt_cibubur'],
  ),
  StationData(
    id: 'wp_mrt_1',
    name: '',
    position: Offset(650, 690),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_2',
    name: '',
    position: Offset(630, 710),
    isWaypoint: true,
  ),
  StationData(
    id: 'setiabudi',
    name: 'Setiabudi Astra',
    code: 'M11',
    position: Offset(570, 770),
    isTransit: true,
    lines: ['mrt', 'lrt_bekasi', 'lrt_cibubur'],
  ),
  StationData(
    id: 'bendungan_hilir',
    name: 'Bendungan Hilir',
    code: 'M10',
    position: Offset(490, 850),
    lines: ['mrt'],
  ),
  StationData(
    id: 'istora',
    name: 'Istora Mandiri',
    code: 'M09',
    position: Offset(430, 910),
    lines: ['mrt'],
  ),
  StationData(
    id: 'wp_mrt_3',
    name: '',
    position: Offset(400, 940),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_4',
    name: '',
    position: Offset(400, 960),
    isWaypoint: true,
  ),
  StationData(
    id: 'senayan',
    name: 'Senayan Mastercard',
    code: 'M08',
    position: Offset(400, 1020),
    lines: ['mrt'],
  ),
  StationData(
    id: 'asean',
    name: 'ASEAN HQ',
    code: 'M07',
    position: Offset(400, 1090),
    lines: ['mrt'],
  ),
  StationData(
    id: 'blok_m',
    name: 'Blok M BCA',
    code: 'M06',
    position: Offset(400, 1160),
    lines: ['mrt'],
  ),
  StationData(
    id: 'blok_a',
    name: 'Blok A',
    code: 'M05',
    position: Offset(400, 1230),
    lines: ['mrt'],
  ),
  StationData(
    id: 'haji_nawi',
    name: 'Haji Nawi',
    code: 'M04',
    position: Offset(400, 1300),
    lines: ['mrt'],
  ),
  StationData(
    id: 'cipete_raya',
    name: 'Cipete Raya TUKU',
    code: 'M03',
    position: Offset(400, 1370),
    lines: ['mrt'],
  ),
  StationData(
    id: 'wp_mrt_5',
    name: '',
    position: Offset(400, 1420),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_6',
    name: '',
    position: Offset(380, 1440),
    isWaypoint: true,
  ),
  StationData(
    id: 'fatmawati',
    name: 'Fatmawati Indomaret',
    code: 'M02',
    position: Offset(310, 1440),
    lines: ['mrt'],
  ),
  StationData(
    id: 'lebak_bulus',
    name: 'Lebak Bulus BSI',
    code: 'M01',
    position: Offset(150, 1440),
    lines: ['mrt'],
  ),

  StationData(
    id: 'wp_mrt_dukuh',
    name: '',
    position: Offset(550, 750),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_istora',
    name: '',
    position: Offset(400, 900),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_mrt_fatmawati',
    name: '',
    position: Offset(400, 1400),
    isWaypoint: true,
  ),
  StationData(
    id: 'tanah_abang',
    name: 'Tanah Abang',
    code: 'C10',
    position: Offset(300, 670),
    isTransit: true,
    lines: ['cikarang_loop', 'rangkasbitung'],
  ),
  StationData(
    id: 'palmerah',
    name: 'Palmerah',
    code: 'R02',
    position: Offset(100, 770),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'kebayoran',
    name: 'Kebayoran',
    code: 'R03',
    position: Offset(100, 870),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'pondok_ranji',
    name: 'Pondok Ranji',
    code: 'R04',
    position: Offset(100, 970),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'jurangmangu',
    name: 'Jurangmangu',
    code: 'R05',
    position: Offset(100, 1070),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'sudimara',
    name: 'Sudimara',
    code: 'R06',
    position: Offset(100, 1170),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'rawa_buntu',
    name: 'Rawa Buntu',
    code: 'R07',
    position: Offset(100, 1270),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'serpong',
    name: 'Serpong',
    code: 'R08',
    position: Offset(100, 1370),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cisauk',
    name: 'Cisauk',
    code: 'R09',
    position: Offset(100, 1470),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cicayur',
    name: 'Cicayur',
    code: 'R10',
    position: Offset(100, 1540),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'parung_panjang',
    name: 'Parung Panjang',
    code: 'R11',
    position: Offset(100, 1610),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cilejit',
    name: 'Cilejit',
    code: 'R12',
    position: Offset(100, 1680),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'daru',
    name: 'Daru',
    code: 'R13',
    position: Offset(100, 1750),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'tenjo',
    name: 'Tenjo',
    code: 'R14',
    position: Offset(100, 1820),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'tigaraksa',
    name: 'Tigaraksa',
    code: 'R15',
    position: Offset(100, 1890),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'cikoya',
    name: 'Cikoya',
    code: 'R16',
    position: Offset(100, 1960),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'maja',
    name: 'Maja',
    code: 'R17',
    position: Offset(100, 2030),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'citeras',
    name: 'Citeras',
    code: 'R18',
    position: Offset(100, 2100),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'rangkasbitung',
    name: 'Rangkasbitung',
    code: 'R19',
    position: Offset(100, 2170),
    lines: ['rangkasbitung'],
  ),
  StationData(
    id: 'bogor',
    name: 'Bogor',
    code: 'B26',
    position: Offset(1320, 1950),
    lines: ['bogor'],
  ),
  StationData(
    id: 'cilebut',
    name: 'Cilebut',
    code: 'B24',
    position: Offset(1250, 1950),
    lines: ['bogor'],
  ),
  StationData(
    id: 'bojong_gede',
    name: 'Bojong Gede',
    code: 'B23',
    position: Offset(1180, 1950),
    lines: ['bogor'],
  ),
  StationData(
    id: 'citayam',
    name: 'Citayam',
    code: 'B22',
    position: Offset(1110, 1950),
    lines: ['bogor', 'bogor_nambo'],
  ),
  StationData(
    id: 'depok',
    name: 'Depok',
    code: 'B21',
    position: Offset(1040, 1950),
    lines: ['bogor'],
  ),

  StationData(
    id: 'wp_curve_depok',
    name: '',
    position: Offset(970, 1950),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_nambo_split',
    name: '',
    position: Offset(1140, 1950),
    isWaypoint: true,
  ),

  StationData(
    id: 'wp_nambo_up',
    name: '',
    position: Offset(1140, 1850),
    isWaypoint: true,
  ),
  StationData(
    id: 'pondok_rajeg',
    name: 'Pondok Rajeg',
    code: 'b23',
    position: Offset(1190, 1850),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'cibinong',
    name: 'Cibinong',
    code: 'b24',
    position: Offset(1240, 1850),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'gunung_putri',
    name: 'Gunung Putri',
    code: 'b25',
    position: Offset(1290, 1850),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'nambo',
    name: 'Nambo',
    code: 'b26',
    position: Offset(1340, 1850),
    lines: ['bogor_nambo'],
  ),
  StationData(
    id: 'depok_baru',
    name: 'Depok Baru',
    code: 'B20',
    position: Offset(970, 1850),
    lines: ['bogor'],
  ),
  StationData(
    id: 'pondok_cina',
    name: 'Pondok Cina',
    code: 'B19',
    position: Offset(970, 1750),
    lines: ['bogor'],
  ),
  StationData(
    id: 'univ_indonesia',
    name: 'Univ. Indonesia',
    code: 'B18',
    position: Offset(970, 1650),
    lines: ['bogor'],
  ),
  StationData(
    id: 'univ_pancasila',
    name: 'Univ. Pancasila',
    code: 'B17',
    position: Offset(970, 1550),
    lines: ['bogor'],
  ),
  StationData(
    id: 'lenteng_agung',
    name: 'Lenteng Agung',
    code: 'B16',
    position: Offset(970, 1450),
    lines: ['bogor'],
  ),
  StationData(
    id: 'tanjung_barat',
    name: 'Tanjung Barat',
    code: 'B15',
    position: Offset(970, 1350),
    lines: ['bogor'],
  ),
  StationData(
    id: 'pasar_minggu',
    name: 'Pasar Minggu',
    code: 'B14',
    position: Offset(970, 1250),
    lines: ['bogor'],
  ),
  StationData(
    id: 'pasar_minggu_baru',
    name: 'Pasar Minggu Baru',
    code: 'B13',
    position: Offset(970, 1200),
    lines: ['bogor'],
  ),
  StationData(
    id: 'duren_kalibata',
    name: 'Duren Kalibata',
    code: 'B12',
    position: Offset(970, 1150),
    lines: ['bogor'],
  ),
  StationData(
    id: 'cawang_krl',
    name: 'Cawang',
    code: 'B11',
    position: Offset(970, 1050),
    lines: ['bogor'],
  ),
  StationData(
    id: 'tebet',
    name: 'Tebet',
    code: 'B10',
    position: Offset(970, 950),
    lines: ['bogor'],
  ),
  StationData(
    id: 'wp_bogor_manggarai_out',
    name: '',
    position: Offset(970, 850),
    isWaypoint: true,
  ),
  StationData(
    id: 'manggarai_bk',
    name: '',
    code: 'B09',
    position: Offset(860, 740),
    lines: ['bogor'],
  ),
  StationData(
    id: 'cikini',
    name: 'Cikini',
    code: 'B08',
    position: Offset(800, 680),
    lines: ['bogor'],
  ),
  StationData(
    id: 'gondangdia',
    name: 'Gondangdia',
    code: 'B07',
    position: Offset(750, 630),
    lines: ['bogor'],
  ),
  StationData(
    id: 'wp_bogor_gondangdia',
    name: '',
    position: Offset(700, 580),
    isWaypoint: true,
  ),
  StationData(
    id: 'juanda',
    name: 'Juanda',
    code: 'B05',
    position: Offset(700, 470),
    lines: ['bogor'],
  ),
  StationData(
    id: 'sawah_besar',
    name: 'Sawah Besar',
    code: 'B04',
    position: Offset(700, 390),
    lines: ['bogor'],
  ),
  StationData(
    id: 'mangga_besar',
    name: 'Mangga Besar',
    code: 'B03',
    position: Offset(700, 310),
    lines: ['bogor'],
  ),
  StationData(
    id: 'jayakarta',
    name: 'Jayakarta',
    code: 'B02',
    position: Offset(700, 230),
    lines: ['bogor'],
  ),
  StationData(
    id: 'wp_bogor_jayakarta',
    name: '',
    position: Offset(700, 160),
    isWaypoint: true,
  ),
  StationData(
    id: 'jakarta_kota_bk',
    name: 'Jakarta Kota',
    code: 'B01',
    position: Offset(600, 160),
    isTransit: true,
    lines: ['bogor'],
  ),
  StationData(
    id: 'cikarang',
    name: 'Cikarang',
    code: 'C26',
    position: Offset(1780, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'metland_telagamurni',
    name: 'Metland Telagamurni',
    code: 'C25',
    position: Offset(1720, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'cibitung',
    name: 'Cibitung',
    code: 'C24',
    position: Offset(1660, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'tambun',
    name: 'Tambun',
    code: 'C23',
    position: Offset(1600, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'bekasi_timur',
    name: 'Bekasi Timur',
    code: 'C22',
    position: Offset(1540, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'bekasi',
    name: 'Bekasi',
    code: 'C21',
    position: Offset(1480, 820),
    isTransit: true,
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'kranji',
    name: 'Kranji',
    code: 'C20',
    position: Offset(1420, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'cakung',
    name: 'Cakung',
    code: 'C19',
    position: Offset(1360, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'klender_baru',
    name: 'Klender Baru',
    code: 'C18',
    position: Offset(1300, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'buaran',
    name: 'Buaran',
    code: 'C17',
    position: Offset(1240, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'klender',
    name: 'Klender',
    code: 'C16',
    position: Offset(1180, 820),
    lines: ['cikarang_east'],
  ),
  StationData(
    id: 'kampung_bandan',
    name: 'Kp. Bandan',
    code: 'C07',
    position: Offset(780, 170),
    isTransit: true,
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'angke',
    name: 'Angke',
    code: 'C08',
    position: Offset(300, 350),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'duri',
    name: 'Duri',
    code: 'C09',
    position: Offset(300, 450),
    isTransit: true,
    lines: ['cikarang_loop', 'tangerang'],
  ),
  StationData(
    id: 'karet',
    name: 'Karet',
    code: 'C11',
    position: Offset(530, 670),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'bni_city',
    name: 'BNI City',
    code: 'C11a',
    position: Offset(600, 670),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'sudirman',
    name: 'Sudirman',
    code: 'C12',
    position: Offset(670, 670),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_sudirman',
    name: '',
    position: Offset(770, 670),
    isWaypoint: true,
  ),
  StationData(
    id: 'manggarai_cb',
    name: 'Manggarai',
    code: 'C13',
    position: Offset(850, 750),
    isTransit: true,
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_manggarai2',
    name: '',
    position: Offset(920, 820),
    isWaypoint: true,
  ),
  StationData(
    id: 'matraman',
    name: 'Matraman',
    code: 'C14',
    position: Offset(960, 820),
    lines: ['cikarang_loop', 'cikarang_east'],
  ),
  StationData(
    id: 'jatinegara',
    name: 'Jatinegara',
    code: 'C15',
    position: Offset(1060, 820),
    isTransit: true,
    lines: ['cikarang_loop', 'cikarang_east'],
  ),
  StationData(
    id: 'wp_cikarang_jatinegara',
    name: '',
    position: Offset(1000, 820),
    isWaypoint: true,
  ),
  StationData(
    id: 'pondok_jati',
    name: 'Pondok Jati',
    code: 'C01',
    position: Offset(1000, 740),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_pj_curve',
    name: '',
    position: Offset(1000, 680),
    isWaypoint: true,
  ),
  StationData(
    id: 'kramat',
    name: 'Kramat',
    code: 'C02',
    position: Offset(960, 640),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'gang_sentiong',
    name: 'Gang Sentiong',
    code: 'C03',
    position: Offset(920, 600),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_cikarang_gs_curve',
    name: '',
    position: Offset(900, 580),
    isWaypoint: true,
  ),
  StationData(
    id: 'pasar_senen',
    name: 'Pasar Senen',
    code: 'C04',
    position: Offset(900, 460),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'kemayoran',
    name: 'Kemayoran',
    code: 'C05',
    position: Offset(900, 380),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'rajawali',
    name: 'Rajawali',
    code: 'C06',
    position: Offset(900, 300),
    lines: ['cikarang_loop'],
  ),
  StationData(
    id: 'wp_s1',
    name: '',
    position: Offset(900, 270),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_s2',
    name: '',
    position: Offset(870, 240),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_s3',
    name: '',
    position: Offset(810, 240),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_s4',
    name: '',
    position: Offset(780, 210),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_kb_top',
    name: '',
    position: Offset(780, 110),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_kb_left',
    name: '',
    position: Offset(300, 110),
    isWaypoint: true,
  ),
  StationData(
    id: 'jakarta_kota_tp',
    name: 'Jakarta Kota',
    code: 'TP01',
    position: Offset(600, 160),
    isTransit: true,
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'kampung_bandan_tp',
    name: '',
    code: 'TP02',
    position: Offset(780, 160),
    isTransit: true,
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'ancol',
    name: 'Ancol',
    code: 'TP03',
    position: Offset(800, 160),
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'jis',
    name: 'Jakarta Int. Stadium',
    code: 'TP04',
    position: Offset(900, 160),
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'tanjung_priok',
    name: 'Tanjung Priok',
    code: 'TP05',
    position: Offset(1000, 160),
    lines: ['tanjung_priok'],
  ),
  StationData(
    id: 'pegangsaan_dua',
    name: 'Pegangsaan Dua',
    code: 'S01',
    position: Offset(1200, 250),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'boulevard_utara',
    name: 'Boulevard Utara',
    code: 'S02',
    position: Offset(1200, 320),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'boulevard_selatan',
    name: 'Boulevard Selatan',
    code: 'S03',
    position: Offset(1200, 390),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'pulomas',
    name: 'Pulomas',
    code: 'S04',
    position: Offset(1200, 460),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'equestrian',
    name: 'Equestrian',
    code: 'S05',
    position: Offset(1200, 530),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'velodrome',
    name: 'Velodrome',
    code: 'S06',
    position: Offset(1100, 530),
    lines: ['lrt_jakarta'],
  ),
  StationData(
    id: 'dukuh_atas_lrt_bk',
    name: 'Dukuh Atas LRT',
    code: 'BK01',
    position: Offset(720, 746),
    isTransit: true,
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'dukuh_atas_lrt_cb',
    name: '',
    code: 'CB01',
    position: Offset(720, 754),
    isTransit: true,
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'wp_lrt_dukuh_bk',
    name: '',
    position: Offset(804, 746),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_lrt_dukuh_cb',
    name: '',
    position: Offset(796, 754),
    isWaypoint: true,
  ),
  StationData(
    id: 'setiabudi_lrt_bk',
    name: 'Setiabudi LRT',
    code: 'BK02',
    position: Offset(804, 830),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'setiabudi_lrt_cb',
    name: '',
    code: 'CB02',
    position: Offset(796, 830),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'rasuna_said_bk',
    name: 'Rasuna Said',
    code: 'BK03',
    position: Offset(804, 910),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'rasuna_said_cb',
    name: '',
    code: 'CB03',
    position: Offset(796, 910),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'kuningan_bk',
    name: 'Kuningan',
    code: 'BK04',
    position: Offset(804, 990),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'kuningan_cb',
    name: '',
    code: 'CB04',
    position: Offset(796, 990),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'wp_lrt_kuningan_bk',
    name: '',
    position: Offset(804, 1096),
    isWaypoint: true,
  ),
  StationData(
    id: 'wp_lrt_kuningan_cb',
    name: '',
    position: Offset(796, 1104),
    isWaypoint: true,
  ),
  StationData(
    id: 'pancoran_bk',
    name: 'Pancoran',
    code: 'BK05',
    position: Offset(900, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'pancoran_cb',
    name: '',
    code: 'CB05',
    position: Offset(900, 1104),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'cikoko_bk',
    name: 'Cikoko',
    code: 'BK06',
    position: Offset(1000, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cikoko_cb',
    name: '',
    code: 'CB06',
    position: Offset(1000, 1104),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'ciliwung_bk',
    name: 'Ciliwung',
    code: 'BK07',
    position: Offset(1100, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'ciliwung_cb',
    name: '',
    code: 'CB07',
    position: Offset(1100, 1104),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'cawang_lrt_bk',
    name: 'Cawang',
    code: 'BK08',
    position: Offset(1200, 1096),
    isTransit: true,
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cawang_lrt_cb',
    name: '',
    code: 'CB08',
    position: Offset(1200, 1104),
    isTransit: true,
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'halim',
    name: 'Halim',
    code: 'BK09',
    position: Offset(1300, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'jatibening_baru',
    name: 'Jatibening Baru',
    code: 'BK10',
    position: Offset(1400, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cikunir_1',
    name: 'Cikunir 1',
    code: 'BK11',
    position: Offset(1500, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'cikunir_2',
    name: 'Cikunir 2',
    code: 'BK12',
    position: Offset(1600, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'bekasi_barat',
    name: 'Bekasi Barat',
    code: 'BK13',
    position: Offset(1700, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'jatimulya',
    name: 'Jati Mulya',
    code: 'BK14',
    position: Offset(1800, 1096),
    lines: ['lrt_bekasi'],
  ),
  StationData(
    id: 'wp_lrt_cawang_cb',
    name: '',
    position: Offset(1500, 1104),
    isWaypoint: true,
  ),
  StationData(
    id: 'taman_mini',
    name: 'Taman Mini',
    code: 'CB09',
    position: Offset(1500, 1204),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'kampung_rambutan',
    name: 'Kampung Rambutan',
    code: 'CB10',
    position: Offset(1500, 1304),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'ciracas',
    name: 'Ciracas',
    code: 'CB11',
    position: Offset(1500, 1404),
    lines: ['lrt_cibubur'],
  ),
  StationData(
    id: 'harjamukti',
    name: 'Harjamukti',
    code: 'CB12',
    position: Offset(1500, 1504),
    lines: ['lrt_cibubur'],
  ),
];

// ════════════════════════════════════════════════════════════════════
// LINE DATABASE
// ════════════════════════════════════════════════════════════════════

const List<LineData> transitLines = [
  LineData(
    id: 'bogor',
    name: 'KRL Lin Bogor',
    color: AppColors.lineBogor,
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
      'duri',
      'tanah_abang',
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
    stationIds: [
      'duri',
      'grogol',
      'pesing',
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
    stationIds: [
      'jakarta_kota_tp',
      'kampung_bandan_tp',
      'ancol',
      'jis',
      'tanjung_priok',
    ],
  ),
  LineData(
    id: 'rangkasbitung',
    name: 'KRL Lin Rangkasbitung',
    color: AppColors.lineRangkasbitung,
    stationIds: [
      'tanah_abang',
      'palmerah',
      'kebayoran',
      'pondok_ranji',
      'jurangmangu',
      'sudimara',
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

// ════════════════════════════════════════════════════════════════════
// SCHEMATIC MAP PAINTER
// ════════════════════════════════════════════════════════════════════

enum LabelPos { top, bottom, left, right }

const Map<String, LabelPos> _majorCodeBadgePos = {
  'lebak_bulus': LabelPos.right,
  'jakarta_kota': LabelPos.top,
  'kampung_bandan': LabelPos.top,
  'duri': LabelPos.top,
  'dukuh_atas': LabelPos.bottom,
  'manggarai': LabelPos.right,
  'jatinegara': LabelPos.right,
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
      fontSize: 10,
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

class SchematicMapPainter extends CustomPainter {
  final bool showColors;
  final String? selectedStation;
  final String? fromStation;
  final Set<String>? visibleLineIds;

  SchematicMapPainter({
    this.showColors = false,
    this.selectedStation,
    this.fromStation,
    this.visibleLineIds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 0. Draw background text (e.g. Bogor)
    _drawBackgroundTexts(canvas);
    // 1. Draw lines with rounded corners
    _drawLines(canvas);
    // 2. Draw landmarks
    _drawLandmarks(canvas);
    // 3. Draw station nodes (dots, code badges)
    _drawStations(canvas);
    // 4. Draw station labels
    _drawAllLabels(canvas);
  }

  void _drawBackgroundTexts(Canvas canvas) {
    // Draw "Bogor" large background text near Bogor station (x: 1300, y: 1550)
    final textSpanBogor = TextSpan(
      text: 'Bogor',
      style: const TextStyle(
        color: Color(0xFFE0E0E0), // Sangat pudar (abu-abu muda)
        fontSize: 100,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontFamily: 'Helvetica',
      ),
    );
    final textPainterBogor = TextPainter(
      text: textSpanBogor,
      textDirection: TextDirection.ltr,
    );
    textPainterBogor.layout();
    textPainterBogor.paint(canvas, const Offset(1300, 1550));

    // Draw "Bekasi" large background text near Bekasi stations (x: 1450, y: 700)
    final textSpanBekasi = TextSpan(
      text: 'Bekasi',
      style: const TextStyle(
        color: Color(0xFFE0E0E0),
        fontSize: 100,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontFamily: 'Helvetica',
      ),
    );
    final textPainterBekasi = TextPainter(
      text: textSpanBekasi,
      textDirection: TextDirection.ltr,
    );
    textPainterBekasi.layout();
    textPainterBekasi.paint(canvas, const Offset(1450, 680));
  }

  // ── DRAW LINES ──────────────────────────────────────────────────

  void _drawLines(Canvas canvas) {
    for (final line in transitLines) {
      final bool isVisible =
          visibleLineIds == null || visibleLineIds!.contains(line.id);
      final paint = Paint()
        ..color = isVisible
            ? (showColors ? line.color : line.color.withValues(alpha: 0.85))
            : line.color.withValues(alpha: 0.08)
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final points = <Offset>[];
      for (final stationId in line.stationIds) {
        final station = _findStation(stationId);
        if (station != null) points.add(station.position);
      }
      _drawRoundedPath(canvas, points, paint);
    }
  }

  /// Menggambar path dengan sudut rounded (quadratic bezier di setiap belokan)
  void _drawRoundedPath(
    Canvas canvas,
    List<Offset> points,
    Paint paint, {
    double cornerRadius = 14,
  }) {
    if (points.length < 2) return;
    final path = Path();
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
      } else {
        final before = Offset(
          p1.dx - d1.dx / len1 * r,
          p1.dy - d1.dy / len1 * r,
        );
        final after = Offset(
          p1.dx + d2.dx / len2 * r,
          p1.dy + d2.dy / len2 * r,
        );
        path.lineTo(before.dx, before.dy);
        path.quadraticBezierTo(p1.dx, p1.dy, after.dx, after.dy);
      }
    }
    path.lineTo(points.last.dx, points.last.dy);
    canvas.drawPath(path, paint);
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
      // Draw code badge
      _drawCodeBadge(canvas, station);
    }
  }

  /// Stasiun transit besar: rounded rectangle besar dengan nama di tengah
  void _drawMajorTransitHub(
    Canvas canvas,
    StationData station, {
    bool isSelected = false,
    bool isFrom = false,
  }) {
    // Highlight glow
    if (isFrom) {
      final glow = Paint()
        ..color = AppColors.primaryBlue.withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(station.position, 30, glow);
    }

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

  /// Stasiun biasa: circle kecil
  void _drawStationNode(
    Canvas canvas,
    StationData station, {
    bool isSelected = false,
    bool isFrom = false,
  }) {
    // Highlight glow for "from" station
    if (isFrom) {
      canvas.drawCircle(
        station.position,
        16,
        Paint()..color = AppColors.primaryBlue.withValues(alpha: 0.25),
      );
      canvas.drawCircle(
        station.position,
        16,
        Paint()
          ..color = AppColors.primaryBlue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    final double radius = station.isTransit ? 8 : 5.5;
    final double effectiveR = isSelected || isFrom ? 10 : radius;

    // White fill
    canvas.drawCircle(
      station.position,
      effectiveR,
      Paint()..color = Colors.white,
    );

    // Border
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

    // Inner dot
    if (station.isTransit || isSelected || isFrom) {
      canvas.drawCircle(
        station.position,
        isSelected || isFrom ? 3 : 2,
        Paint()..color = isFrom ? AppColors.primaryBlue : AppColors.textPrimary,
      );
    }
  }

  /// Kode stasiun badge (pill kecil berwarna)
  void _drawCodeBadge(Canvas canvas, StationData station) {
    if (station.code.isEmpty) return;

    final color = _getStationColor(station);

    final codeSpan = TextSpan(
      text: station.code,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 7,
        fontWeight: FontWeight.w700,
      ),
    );
    final codeTp = TextPainter(text: codeSpan, textDirection: TextDirection.ltr)
      ..layout();
    final badgeRect = _codeBadgeRect(station, codeTp.width);

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

  Rect _codeBadgeRect(StationData station, [double? textWidth]) {
    final codeWidth =
        textWidth ??
        (TextPainter(
          text: TextSpan(
            text: station.code,
            style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w700),
          ),
          textDirection: TextDirection.ltr,
        )..layout()).width;
    final badgeW = codeWidth + 8;
    const badgeH = 13.0;

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
      }
    } else {
      final pos = _getLabelPos(station);
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
        final radius = station.isTransit ? 11.0 : 8.0;
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
    final isSelected =
        selectedStation == station.id || selectedStation == station.name;
    final isFrom = fromStation == station.id || fromStation == station.name;
    final bool isBold = station.isTransit || isSelected || isFrom;
    final double fontSize = station.isTransit ? 10 : 9;

    final textSpan = TextSpan(
      text: station.name,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final preferredPos = _getLabelPos(station);
    final offset = station.isTransit ? 14.0 : 10.0;

    Rect rectFor(LabelPos pos) {
      double labelX, labelY;
      switch (pos) {
        case LabelPos.top:
          labelX = station.position.dx - (textPainter.width / 2);
          labelY = station.position.dy - textPainter.height - offset;
          break;
        case LabelPos.bottom:
          labelX = station.position.dx - (textPainter.width / 2);
          labelY = station.position.dy + offset;
          break;
        case LabelPos.left:
          labelX = station.position.dx - textPainter.width - offset;
          labelY = station.position.dy - (textPainter.height / 2);
          break;
        case LabelPos.right:
          labelX = station.position.dx + offset;
          labelY = station.position.dy - (textPainter.height / 2);
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

    textPainter.paint(canvas, labelRect.topLeft);
  }

  // ── LABEL POSITIONING ────────────────────────────────────────────

  LabelPos _getLabelPos(StationData station) {
    final id = station.id;

    // ── Specific overrides ──
    const overrides = <String, LabelPos>{
      // Cikarang loop north side (vertical at x=1060) → right
      'pondok_jati': LabelPos.right, 'kramat': LabelPos.right,
      'gang_sentiong': LabelPos.right, 'pasar_senen': LabelPos.right,
      // Cikarang loop top (horizontal) → top
      'kemayoran': LabelPos.top, 'rajawali': LabelPos.top,
      // Cikarang south diagonal
      'angke': LabelPos.right, 'matraman': LabelPos.bottom,
      // Cikarang east (horizontal at y=580) → bottom
      'klender': LabelPos.bottom, 'buaran': LabelPos.bottom,
      'klender_baru': LabelPos.bottom, 'cakung': LabelPos.bottom,
      'kranji': LabelPos.bottom, 'bekasi': LabelPos.bottom,
      'bekasi_timur': LabelPos.bottom, 'tambun': LabelPos.bottom,
      'cibitung': LabelPos.bottom,
      'metland': LabelPos.bottom,
      'cikarang': LabelPos.bottom,
      // Cikarang horizontal band (y=700) → bottom
      'tanah_abang': LabelPos.left,
      'karet': LabelPos.bottom, 'sudirman': LabelPos.top,
      // Tanjung Priok → top
      'ancol': LabelPos.top, 'jis': LabelPos.top,
      'tanjung_priok': LabelPos.top,
      'kampung_bandan': LabelPos.top,
      // Tangerang horizontal → bottom
      'grogol': LabelPos.bottom, 'pesing': LabelPos.bottom,
      'taman_kota': LabelPos.bottom, 'bojong_indah': LabelPos.bottom,
      // Tangerang vertical → left
      'rawa_buaya': LabelPos.left, 'kalideres': LabelPos.left,
      'poris': LabelPos.left, 'batu_ceper': LabelPos.left,
      'tanah_tinggi': LabelPos.left, 'tangerang': LabelPos.left,
      // Rangkasbitung diagonal → left
      'palmerah': LabelPos.left, 'kebayoran': LabelPos.left,
      'pondok_ranji': LabelPos.left, 'jurangmangu': LabelPos.left,
      'sudimara': LabelPos.left,
      // Rangkasbitung vertical → left
      'rawa_buntu': LabelPos.left, 'serpong': LabelPos.left,
      'cisauk': LabelPos.left, 'cicayur': LabelPos.left,
      'parung_panjang': LabelPos.left, 'cilejit': LabelPos.left,
      'daru': LabelPos.left, 'tenjo': LabelPos.left,
      'tigaraksa': LabelPos.left, 'cikoya': LabelPos.left,
      'maja': LabelPos.left, 'citeras': LabelPos.left,
      'rangkasbitung': LabelPos.left,
      // LRT diagonal/horizontal
      'rasuna_said': LabelPos.bottom, 'kuningan': LabelPos.bottom,
      'pancoran': LabelPos.top, 'cikoko': LabelPos.top,
      'ciliwung': LabelPos.top, 'cawang_lrt': LabelPos.bottom,
      // LRT Bekasi horizontal → top
      'halim': LabelPos.top, 'jatibening_baru': LabelPos.top,
      'cikunir_1': LabelPos.top, 'cikunir_2': LabelPos.top,
      'bekasi_barat': LabelPos.top, 'jatimulya': LabelPos.top,
      // LRT Cibubur diagonal → right
      'taman_mini': LabelPos.right, 'kampung_rambutan': LabelPos.right,
      'ciracas': LabelPos.right, 'harjamukti': LabelPos.right,
      // Nambo branch → bottom
      'pondok_rajeg': LabelPos.bottom, 'cibinong': LabelPos.bottom,
      'gunung_putri': LabelPos.bottom, 'nambo': LabelPos.bottom,
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
      'fatmawati': LabelPos.left, 'lebak_bulus': LabelPos.left,
      'setiabudi': LabelPos.left, 'dukuh_atas': LabelPos.left,
    };

    if (overrides.containsKey(id)) return overrides[id]!;

    // Default: Bogor line → right, others → right
    return LabelPos.right;
  }

  @override
  bool shouldRepaint(covariant SchematicMapPainter oldDelegate) {
    return oldDelegate.showColors != showColors ||
        oldDelegate.selectedStation != selectedStation ||
        oldDelegate.fromStation != fromStation ||
        oldDelegate.visibleLineIds != visibleLineIds;
  }
}
