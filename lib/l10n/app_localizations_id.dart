// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get languagePageTitle => 'Bahasa';

  @override
  String get languagePageSubtitle => 'Bahasa yang sedang digunakan';

  @override
  String get languageApp => 'Bahasa aplikasi';

  @override
  String get languageDescription =>
      'Pilih bahasa untuk navigasi dan pesan aplikasi';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get languageIndonesianDesc =>
      'Gunakan Bahasa Indonesia untuk label aplikasi';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishDesc =>
      'Gunakan Bahasa Inggris untuk label aplikasi';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageSimplifiedChineseDesc =>
      'Gunakan Bahasa Mandarin Sederhana untuk label aplikasi';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageArabicDesc => 'Gunakan Bahasa Arab untuk label aplikasi';

  @override
  String get preview => 'Pratinjau';

  @override
  String get previewAccount => 'Akun';

  @override
  String get previewGuestActive => 'Mode tamu aktif';

  @override
  String get applyLanguage => 'Terapkan bahasa';

  @override
  String get languageAppliedNote =>
      'Perubahan langsung diterapkan dan disimpan untuk kunjungan berikutnya.';

  @override
  String get languageAppliedSnackbar => 'Bahasa diterapkan.';

  @override
  String get languageSaveFailedSnackbar =>
      'Bahasa diubah untuk sesi ini, tetapi preferensi Anda tidak dapat disimpan.';

  @override
  String get profileAccount => 'Akun';

  @override
  String get profileGuestModeActive => 'Mode tamu aktif';

  @override
  String get profileGuest => 'Tamu';

  @override
  String get profileGuestDesc =>
      'Tidak perlu login untuk peta, ETA. jadwal, dan beli tiket.';

  @override
  String get profileOptionalLogin => 'Masuk atau Buat Akun';

  @override
  String get profileLocalTicketHistory => 'Riwayat tiket lokal';

  @override
  String get profileSavedOnDevice => 'Tersimpan di perangkat ini';

  @override
  String get profileAccessibility => 'Aksesibilitas';

  @override
  String get profileLargeText => 'Teks besar dan bacakan rute';

  @override
  String get profileBlindGuide => 'Pemandu Tunanetra';

  @override
  String get profileBlindGuideDescription =>
      'Buka kamera dengan panduan suara otomatis';

  @override
  String get cameraGuideActiveAnnouncement =>
      'Pemandu kamera aktif. Arahkan kamera ke depan.';

  @override
  String get cameraGuideTitle => 'Pemandu Kamera';

  @override
  String get cameraGuideBack => 'Kembali';

  @override
  String cameraGuideStatus(String status) {
    return 'Status kamera: $status';
  }

  @override
  String get cameraGuideStateLoading => 'Memuat';

  @override
  String get cameraGuideStateActive => 'Aktif';

  @override
  String get cameraGuideStatePermissionDenied => 'Izin diperlukan';

  @override
  String get cameraGuideStateOffline => 'Offline';

  @override
  String get cameraGuideStateError => 'Kesalahan';

  @override
  String get cameraGuideStateStopped => 'Dihentikan';

  @override
  String get cameraGuidePermissionRequired =>
      'Izin kamera diperlukan. Aktifkan dari Pengaturan jika sebelumnya ditolak permanen.';

  @override
  String get cameraGuideSafetyWarning =>
      'Deteksi dapat keliru. Gunakan tongkat, pendamping, atau bantuan petugas.';

  @override
  String get cameraGuideRetry => 'Coba Lagi';

  @override
  String get cameraGuideStart => 'Mulai Pemandu';

  @override
  String get cameraGuideStop => 'Hentikan Pemandu';

  @override
  String get cameraGuideLoadingMessage => 'Menyiapkan kamera…';

  @override
  String get cameraGuideActiveMessage =>
      'Arahkan kamera ke depan. Pemandu aktif.';

  @override
  String get cameraGuideUnavailableMessage => 'Kamera tidak dapat digunakan.';

  @override
  String get cameraGuideOfflineMessage =>
      'Deteksi lokal terbatas; koneksi AI tidak tersedia.';

  @override
  String get cameraGuideStoppedMessage => 'Pemandu kamera dihentikan.';

  @override
  String get cameraGuideNoClearObject => 'Belum ada objek jelas di depan.';

  @override
  String cameraGuideObjectCount(int count) {
    return '$count objek terdeteksi di depan.';
  }

  @override
  String cameraGuideLabelsDetected(String labels) {
    return '$labels terdeteksi di depan.';
  }

  @override
  String get profileHelpCenter => 'Pusat Bantuan';

  @override
  String get profileContactOfficer => 'Kontak petugas dan laporan info salah';

  @override
  String get authSignInTitle => 'Masuk ke akun';

  @override
  String get authSignInSubtitle =>
      'Akun bersifat opsional. Gunakan untuk menyinkronkan profil dan riwayat tiket.';

  @override
  String get authRegisterTitle => 'Buat akun';

  @override
  String get authRegisterSubtitle =>
      'Daftar tanpa mengubah akses guest untuk jadwal, rute, dan pembelian tiket.';

  @override
  String get authName => 'Nama lengkap';

  @override
  String get authEmail => 'Email';

  @override
  String get authPhoneOptional => 'Nomor telepon (opsional)';

  @override
  String get authPassword => 'Kata sandi';

  @override
  String get authPasswordConfirmation => 'Ulangi kata sandi';

  @override
  String get authEmailInvalid => 'Masukkan alamat email yang valid.';

  @override
  String get authNameRequired => 'Nama minimal 2 karakter.';

  @override
  String get authPasswordMin => 'Kata sandi minimal 8 karakter.';

  @override
  String get authPasswordMismatch => 'Konfirmasi kata sandi belum sama.';

  @override
  String get authShowPassword => 'Tampilkan kata sandi';

  @override
  String get authHidePassword => 'Sembunyikan kata sandi';

  @override
  String get authSubmitLogin => 'Masuk';

  @override
  String get authSubmitRegister => 'Daftar';

  @override
  String get authCreateAccount => 'Belum punya akun? Daftar';

  @override
  String get authBackToLogin => 'Sudah punya akun? Masuk';

  @override
  String get authGuestStillAvailable =>
      'Tanpa akun, kamu tetap bisa melihat jadwal, mencari rute, dan membeli tiket sebagai guest.';

  @override
  String get authInvalidCredentials => 'Email atau kata sandi tidak sesuai.';

  @override
  String get authEmailUsed => 'Email ini sudah terdaftar.';

  @override
  String get authNetworkError =>
      'Tidak dapat terhubung ke server. Periksa koneksi dan coba lagi.';

  @override
  String get authGenericError => 'Permintaan belum dapat diproses. Coba lagi.';

  @override
  String get profileSignedIn => 'Akun aktif';

  @override
  String get profileOfflineSession => 'Akun tersimpan • sedang offline';

  @override
  String get profileOfflineHint =>
      'Beberapa perubahan akan tersedia saat koneksi kembali.';

  @override
  String get profileEdit => 'Edit profil';

  @override
  String get profileLogout => 'Keluar';

  @override
  String get profileLogoutConfirm =>
      'Keluar dari akun di perangkat ini? Fitur guest tetap dapat digunakan.';

  @override
  String get profileCancel => 'Batal';

  @override
  String get profileAccountTicketHistory => 'Riwayat tiket akun';

  @override
  String get profileSyncedAccount => 'Tersinkron dengan akun ini';

  @override
  String get editProfileTitle => 'Edit profil';

  @override
  String get saveChanges => 'Simpan perubahan';

  @override
  String get navHome => 'Beranda';

  @override
  String get navSchedule => 'Jadwal';

  @override
  String get navTickets => 'Tiket';

  @override
  String get navAssistant => 'Asisten';

  @override
  String get navAccount => 'Akun';

  @override
  String get filterArea => 'Filter Kawasan';

  @override
  String get areaJabodetabek => 'Seluruh Jabodetabek';

  @override
  String get filterAreaComingSoon => 'Filter spesifik kawasan segera hadir';

  @override
  String get filterLine => 'Filter Jalur Transportasi';

  @override
  String get searchStationHint => 'Ketik nama stasiun, jalur, atau area';

  @override
  String startFrom(String station) {
    return 'Mulai dari: $station';
  }

  @override
  String get selectedStation => 'Stasiun Terpilih';

  @override
  String get from => 'Dari';

  @override
  String get to => 'Ke';

  @override
  String get selectFromFirst => 'Pilih stasiun asal (Dari) terlebih dahulu!';

  @override
  String get nearestDepartures => 'Keberangkatan Terdekat';

  @override
  String get allStations => 'Semua Stasiun';

  @override
  String get all => 'Semua';

  @override
  String get selectOriginStation => 'Pilih Stasiun Asal';

  @override
  String get searchStationHint2 =>
      'Cari nama stasiun (misal: Manggarai, Halim...)';

  @override
  String get weekday => 'Hari Kerja';

  @override
  String get weekend => 'Akhir Pekan';

  @override
  String get trainSchedule => 'Jadwal Kereta';

  @override
  String get searchDestinationHint =>
      'Cari stasiun tujuan atau nomor kereta...';

  @override
  String get filterOriginAll => 'Filter Stasiun Asal (Semua Stasiun)';

  @override
  String originStation(String station) {
    return 'Stasiun Asal: $station';
  }

  @override
  String get scheduleNotFound => 'Jadwal tidak ditemukan';

  @override
  String get tryChangingFilter => 'Cobalah mengubah filter stasiun atau hari.';

  @override
  String get alarmActivated => 'Alarm perjalanan diaktifkan';

  @override
  String get alarmDeactivated => 'Alarm perjalanan dinonaktifkan';

  @override
  String get tickets => 'Tiket';

  @override
  String get validUntil => 'Berlaku sampai 23:59';

  @override
  String get payBefore => 'Bayar sebelum 23:59';

  @override
  String get usedToday => 'Digunakan hari ini, 09:12';

  @override
  String get unpaid => 'Belum bayar';

  @override
  String get active => 'Aktif';

  @override
  String get completed => 'Selesai';

  @override
  String get travelTicket => 'Tiket perjalanan';

  @override
  String ticketStatusSummary(int active, int pending, int completed) {
    return '$active tiket aktif · $pending belum dibayar · $completed selesai';
  }

  @override
  String get notPaid => 'Belum dibayar';

  @override
  String get alreadyUsed => 'Sudah digunakan';

  @override
  String get readyToScan => 'Siap scan';

  @override
  String get payNow => 'Bayar sekarang';

  @override
  String get detail => 'Detail';

  @override
  String get viewQR => 'Lihat QR';

  @override
  String get ticketAlreadyUsed => 'Tiket ini sudah selesai digunakan.';

  @override
  String get qrValidUntil => 'QR berlaku sampai';

  @override
  String get choosePayment => 'Pilih pembayaran';

  @override
  String get qrisDesc => 'Tanpa akun, semua e-wallet';

  @override
  String get creditCard => 'Kartu debit/kredit';

  @override
  String get virtualAccount => 'VA / transfer';

  @override
  String get vaDesc => 'Kode bayar sekali pakai';

  @override
  String get optionalContact => 'Nomor HP/email opsional';

  @override
  String get optionalContactDesc =>
      'Hanya untuk mengirim salinan tiket. Tidak membuat akun.';

  @override
  String payAmount(String amount) {
    return 'Bayar $amount';
  }

  @override
  String get paymentSuccess => 'Pembayaran berhasil';

  @override
  String get scanQrAtGate => 'Scan QR di gate masuk.';

  @override
  String get validGateInBefore => 'Berlaku gate-in sebelum';

  @override
  String get today2359 => '23:59 hari ini';

  @override
  String get withoutAccount => 'Tanpa akun';

  @override
  String get guest => 'Guest';

  @override
  String get ticketSaved => 'Tiket disimpan ke galeri ponsel!';

  @override
  String get saveTicket => 'Simpan tiket';

  @override
  String get sharingTicketLink => 'Membagikan tautan tiket...';

  @override
  String get share => 'Bagikan';

  @override
  String get a11yQrInfo =>
      'A11Y: QR memiliki kode tiket teks cadangan untuk bantuan petugas.';

  @override
  String get assistantReady => 'Siap membantu';

  @override
  String get assistantListening => 'Mendengarkan';

  @override
  String get assistantProcessing => 'Memproses';

  @override
  String get assistantSpeaking => 'Berbicara';

  @override
  String get assistantWaiting => 'Menunggu konfirmasi';

  @override
  String get assistantError => 'Perlu dicoba lagi';

  @override
  String get voiceStart => 'Mulai percakapan suara';

  @override
  String get voiceStop => 'Hentikan percakapan suara';

  @override
  String get voiceProcessing => 'Permintaan sedang diproses';

  @override
  String get voiceStopSpeaking => 'Hentikan suara asisten';

  @override
  String get voiceNew => 'Mulai percakapan baru';

  @override
  String get voiceRetry => 'Coba percakapan suara lagi';

  @override
  String get quickActions => 'Tindakan cepat';

  @override
  String get planTrip => 'Rencanakan perjalanan';

  @override
  String get nextTrain => 'Kereta berikutnya';

  @override
  String get myTickets => 'Tiket saya';

  @override
  String get officerHelp => 'Bantuan petugas';

  @override
  String get travelAssistant => 'Asisten Perjalanan';

  @override
  String assistantStatusLabel(String status) {
    return 'Status asisten: $status';
  }

  @override
  String get wakeWordMode => 'Mode kata pemicu Halo Asisten';

  @override
  String get inactive => 'nonaktif';

  @override
  String get listenWakeWord => 'Dengarkan \"Halo Asisten\"';

  @override
  String get wakeWordActiveText => 'Kata pemicu aktif';

  @override
  String get wakeWordPageOnly => 'Aktif hanya di halaman ini';

  @override
  String get back => 'Back';

  @override
  String get selectDestination => 'Pilih stasiun tujuan';

  @override
  String get searchStationTitle => 'Cari stasiun';

  @override
  String startTripFrom(String station) {
    return 'Mulai perjalanan dari: $station';
  }

  @override
  String get serviceFilter => 'Filter layanan';

  @override
  String get accessible => 'Aksesibel';

  @override
  String get quickResults => 'Hasil cepat';

  @override
  String get stationNotFound => 'Stasiun tidak ditemukan';

  @override
  String get stationVoiceGuide => 'Panduan suara';

  @override
  String get stationVoiceGuideStop => 'Hentikan panduan suara';

  @override
  String get stationVoiceGuideError =>
      'Panduan suara tidak dapat digunakan. Coba lagi.';

  @override
  String get withoutLogin => 'Tanpa login';

  @override
  String get favoriteHistoryLocal =>
      'Favorit dan riwayat disimpan lokal di perangkat.';

  @override
  String get routeGuideTitle => 'Panduan Rute Perjalanan';

  @override
  String get fastest => 'Tercepat';

  @override
  String get minTransit => 'Minim transit';

  @override
  String get travelEstimate => 'Estimasi Perjalanan';

  @override
  String get minutesOnly => 'menit';

  @override
  String stopsAndService(int stops, String serviceInfo) {
    return '$stops Stasiun · $serviceInfo';
  }

  @override
  String get travelFare => 'Tarif Perjalanan';

  @override
  String get routeTimeline => 'Timeline Rute Perjalanan';

  @override
  String exitGateInfo(String to) {
    return 'Informasi Pintu Keluar Stasiun $to';
  }

  @override
  String buyTicketDirect(String fare) {
    return 'Beli Tiket Langsung ($fare)';
  }

  @override
  String readRouteToast(String from, String to, int travelTime) {
    return 'Membacakan rute dari $from ke $to: Durasi $travelTime menit.';
  }

  @override
  String get readRouteBtn => 'Bacakan Rute';

  @override
  String get viewOnMapBtn => 'Lihat di Peta';

  @override
  String a11yAudioRoute(String from, String to, int travelTime, int stops) {
    return 'A11Y Audio: Rute $from ke $to ($travelTime mnt, $stops stop).';
  }

  @override
  String get nextTrainLive => 'KERETA BERIKUTNYA (LIVE REALTIME)';

  @override
  String get noTripNeeded => 'Tidak butuh perjalanan';

  @override
  String get sameOriginDest => 'Asal dan tujuan sama.';

  @override
  String get alreadyAtDest => 'Anda sudah berada di lokasi stasiun tujuan.';

  @override
  String get minuteShort => 'mnt';

  @override
  String lineNoTransit(String lineName) {
    return '$lineName · Tanpa transit';
  }

  @override
  String boardLineFrom(String lineName, String from) {
    return 'Naik $lineName dari Stasiun $from';
  }

  @override
  String get departureTime => 'Keberangkatan: 08:35 WIB';

  @override
  String platformDirection(int platform, String to) {
    return 'Peron $platform · Arah $to';
  }

  @override
  String directTripTo(String to, int stops) {
    return 'Perjalanan langsung menuju $to ($stops stasiun)';
  }

  @override
  String estDuration(int duration) {
    return 'estimasi $duration mnt';
  }

  @override
  String skipStops(int stops) {
    return 'Lewati $stops stasiun perhentian secara langsung';
  }

  @override
  String arriveAtDest(String to) {
    return 'Tiba di Stasiun tujuan $to';
  }

  @override
  String totalDuration(int duration) {
    return 'Total $duration mnt';
  }

  @override
  String get elevatedStation => 'Stasiun Layang (Elevated)';

  @override
  String gateA(String gate) {
    return 'Pintu A (Utara): $gate';
  }

  @override
  String gateB(String gate) {
    return 'Pintu B (Selatan): $gate';
  }

  @override
  String get mainAccessGate =>
      'Akses Utama Jalan Utama & Integrasi Halte TransJakarta';

  @override
  String get dropOffGate =>
      'Area Drop-off Ojek Online, Pangkalan Taksi & Parkir';

  @override
  String oneTransitAt(String station) {
    return '1 transit · Berpindah di $station';
  }

  @override
  String alightAt(String station, int stops) {
    return 'Turun di Stasiun $station ($stops stop perhentian)';
  }

  @override
  String prepareTransitAt(String station) {
    return 'Persiapan berpindah jalur di Stasiun $station';
  }

  @override
  String transitToLine(String station, String line) {
    return 'Transit di $station: Pindah ke peron $line';
  }

  @override
  String get transitPlatform1To2 =>
      'Berpindah dari Peron 1 ke Peron 2 (Lift Aksesibel & Guiding Block)';

  @override
  String boardLineTo(String line, String to, int stops) {
    return 'Naik $line ke arah Stasiun $to ($stops stop perhentian)';
  }

  @override
  String nextTrainAtPlatform(int minutes, int platform) {
    return 'Kereta berikutnya tiba $minutes menit lagi di Peron $platform';
  }

  @override
  String get a11yReadingPreview =>
      'Membacakan: Dukuh Atas ke Harjamukti, Peron 2, tiba 4 menit lagi.';

  @override
  String get a11yTitle => 'Aksesibilitas';

  @override
  String get a11ySubtitle => 'Teks dan suara';

  @override
  String get a11yDisplaySettings => 'Pengaturan tampilan';

  @override
  String get a11yMakeEasier => 'Buat aplikasi lebih mudah dibaca dan didengar';

  @override
  String get a11yLargeText => 'Teks besar';

  @override
  String get a11yLargeTextDesc => 'Perbesar label dan informasi rute';

  @override
  String get a11yReadRoute => 'Bacakan rute';

  @override
  String get a11yReadRouteDesc => 'Aktifkan pembacaan stasiun dan arah';

  @override
  String get a11yRoutePreviewSemantic =>
      'Pratinjau rute. Dukuh Atas ke Harjamukti. Peron 2, tiba 4 menit lagi.';

  @override
  String get a11yRoutePreviewTitle => 'Pratinjau rute';

  @override
  String get a11yRoutePreviewRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get a11yRoutePreviewDetail => 'Peron 2, tiba 4 menit lagi';

  @override
  String get a11yReadBtn => 'Baca';

  @override
  String get historyCleared => 'Riwayat tiket dibersihkan dari perangkat ini.';

  @override
  String get historyTitle => 'Riwayat tiket';

  @override
  String get historyCompleted => 'Riwayat selesai';

  @override
  String get historySubtitle => 'Tersimpan di perangkat ini';

  @override
  String get historyLastTicket => 'Tiket terakhir';

  @override
  String get historySortRecent => 'Urut dari perjalanan terbaru';

  @override
  String get historyKrl => 'KRL Commuter Line';

  @override
  String get historyKrlRoute => 'Bogor → Jakarta Kota';

  @override
  String get historyKrlDate => 'Hari ini, 08:12 WIB';

  @override
  String get historyLrt => 'LRT Jabodebek';

  @override
  String get historyLrtRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get historyLrtDate => 'Selasa, 7 Jul 2026';

  @override
  String get historyGuestMode => 'Mode tamu';

  @override
  String get historyGuestDesc => 'Riwayat ini hanya ada di perangkat ini.';

  @override
  String get historyNoTickets => 'Belum ada riwayat tiket';

  @override
  String get historyClearHistory => 'Bersihkan riwayat';

  @override
  String get historyClearDesc => 'Hapus data dari perangkat ini.';

  @override
  String get helpTopicBuyTicket => 'Cara membeli tiket lokal';

  @override
  String get helpTopicBuyTicketDesc => 'Panduan untuk KRL dan LRT';

  @override
  String get helpTopicScheduleIssue => 'Jadwal atau ETA tidak sesuai';

  @override
  String get helpTopicScheduleIssueDesc => 'Kirim laporan dari detail rute';

  @override
  String get helpTopicPaymentIssue => 'Masalah pembayaran';

  @override
  String get helpTopicPaymentIssueDesc => 'Cek status transaksi terakhir';

  @override
  String get helpCenterTitle => 'Pusat Bantuan';

  @override
  String get helpCenterSubtitle => 'Kontak petugas dan laporan';

  @override
  String get helpSearchHint => 'Cari bantuan, stasiun, atau tiket';

  @override
  String get helpQuickActions => 'Aksi cepat';

  @override
  String get helpQuickActionsDesc => 'Pilih bantuan yang paling sering dipakai';

  @override
  String get helpChatStaff => 'Chat petugas';

  @override
  String get helpReportInfo => 'Lapor info salah';

  @override
  String get helpTopicsTitle => 'Topik bantuan';

  @override
  String get helpNoTopicsFound => 'Topik bantuan tidak ditemukan.';

  @override
  String get helpCallKaiSnack => 'Menghubungi KAI melalui 121.';

  @override
  String get helpCallKai => 'Hubungi KAI: 121';

  @override
  String get chatLiveHelp => 'Bantuan langsung';

  @override
  String get chatWithStaff => 'Chat dengan petugas';

  @override
  String chatActiveTopic(String topic) {
    return 'Topik aktif: $topic';
  }

  @override
  String get chatContentTailored =>
      'Konten chat disesuaikan dengan pilihan Anda.';

  @override
  String get chatServiceStatus => 'Status layanan';

  @override
  String get chatWaitEstimate => 'Estimasi tunggu saat ini';

  @override
  String get chatSelectTopic => 'Pilih topik';

  @override
  String get chatInitialMessage => 'Pesan awal';

  @override
  String get chatSharedData => 'Data yang dikirim';

  @override
  String chatReceivedData(String data) {
    return 'Data yang diterima:\n$data';
  }

  @override
  String get issueLateEtaTitle => 'ETA Terlambat';

  @override
  String get issueLateEtaLabel => 'ETA terlambat';

  @override
  String get issueLateEtaActive => 'ETA terlambat';

  @override
  String get issueLateEtaRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueLateEtaRouteDetail => 'ETA aplikasi: 09:32 WIB';

  @override
  String get issueLateEtaNote => 'Papan stasiun menunjukkan 09:40 WIB.';

  @override
  String get issueLateEtaGuidance => 'Koreksi membantu akurasi ETA rute ini.';

  @override
  String get issueLateEtaAction => 'Kirim koreksi ETA';

  @override
  String get issueMissingTrainTitle => 'Kereta Hilang';

  @override
  String get issueMissingTrainLabel => 'Kereta hilang';

  @override
  String get issueMissingTrainActive => 'Kereta tidak muncul';

  @override
  String get issueMissingTrainRoute => 'Bekasi → Manggarai';

  @override
  String get issueMissingTrainRouteDetail => 'Kereta terdekat tidak tampil';

  @override
  String get issueMissingTrainNote =>
      'Kereta terlihat di stasiun, tetapi tidak ada di aplikasi.';

  @override
  String get issueMissingTrainGuidance =>
      'Laporan melengkapi data keberangkatan.';

  @override
  String get issueMissingTrainAction => 'Laporkan kereta hilang';

  @override
  String get issueChangedScheduleTitle => 'Jadwal Berubah';

  @override
  String get issueChangedScheduleLabel => 'Jadwal berubah';

  @override
  String get issueChangedScheduleActive => 'Jadwal berubah';

  @override
  String get issueChangedScheduleRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get issueChangedScheduleRouteDetail => 'Jadwal aplikasi: 15:18 WIB';

  @override
  String get issueChangedScheduleNote =>
      'Jadwal di stasiun berubah menjadi 15:30 WIB.';

  @override
  String get issueChangedScheduleGuidance =>
      'Laporan membantu sinkronisasi jadwal.';

  @override
  String get issueChangedScheduleAction => 'Kirim perubahan jadwal';

  @override
  String get issueDiffPlatformTitle => 'Peron Berbeda';

  @override
  String get issueDiffPlatformLabel => 'Peron berbeda';

  @override
  String get issueDiffPlatformActive => 'Peron berbeda';

  @override
  String get issueDiffPlatformRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueDiffPlatformRouteDetail => 'Peron aplikasi: Peron 2';

  @override
  String get issueDiffPlatformNote =>
      'Petugas mengarahkan penumpang ke Peron 4.';

  @override
  String get issueDiffPlatformGuidance =>
      'Laporan membantu memperbaiki info peron.';

  @override
  String get issueDiffPlatformAction => 'Kirim koreksi peron';

  @override
  String get issueReportMismatch => 'Laporkan ketidaksesuaian';

  @override
  String get issueScheduleAndEta => 'Jadwal & ETA';

  @override
  String issueActiveProblem(String problem) {
    return 'Masalah aktif: $problem';
  }

  @override
  String get issueDetailFollows =>
      'Detail laporan mengikuti masalah yang dipilih.';

  @override
  String get issueMonitoredRoute => 'Rute dipantau';

  @override
  String get issueProblemOccurred => 'Masalah yang terjadi';

  @override
  String get issueNotes => 'Catatan';

  @override
  String issueCorrectionPrepared(String problem) {
    return 'Koreksi $problem berhasil disiapkan.';
  }

  @override
  String get topicTicketLabel => 'Tiket';

  @override
  String get topicTicketTitle => 'Chat Tiket';

  @override
  String get topicTicketAgent => 'Petugas tiket';

  @override
  String get topicTicketAvailability => 'Petugas tiket tersedia';

  @override
  String get topicTicketWait => 'Biasanya membalas dalam 2 menit';

  @override
  String get topicTicketOpening => 'Saya butuh bantuan terkait tiket';

  @override
  String get topicTicketShared => 'Mode tamu, ID tiket, dan rute terakhir';

  @override
  String get topicTicketSampleData =>
      'Kode tiket: TKT-20260827-001\nRute: Manggarai – Tanah Abang\nTanggal perjalanan: 27 Agustus 2026\nStatus: Aktif';

  @override
  String get topicTicketAction => 'Mulai chat tiket';

  @override
  String get topicTicketGreeting =>
      'Halo, saya Rani dari layanan tiket. Data tiket dan rute terakhir Anda sudah saya terima. Apa kendala yang ingin diperiksa?';

  @override
  String get topicScheduleLabel => 'Jadwal';

  @override
  String get topicScheduleTitle => 'Chat Jadwal';

  @override
  String get topicScheduleAgent => 'Petugas jadwal';

  @override
  String get topicScheduleAvailability => 'Petugas jadwal tersedia';

  @override
  String get topicScheduleWait => 'Biasanya membalas dalam 3 menit';

  @override
  String get topicScheduleOpening =>
      'Saya butuh bantuan terkait jadwal atau ETA kereta';

  @override
  String get topicScheduleShared =>
      'Rute terakhir, stasiun asal-tujuan, dan waktu perjalanan';

  @override
  String get topicScheduleSampleData =>
      'Stasiun asal: Manggarai\nTujuan: Jakarta Kota\nNomor kereta: KA 1184\nKeberangkatan: 10.25 WIB\nPeron: 3';

  @override
  String get topicScheduleAction => 'Mulai chat jadwal';

  @override
  String get topicScheduleGreeting =>
      'Halo, saya Dimas dari layanan jadwal. Rute terakhir Anda sudah terlihat. Jadwal atau ETA mana yang ingin diperiksa?';

  @override
  String get topicPaymentLabel => 'Pembayaran';

  @override
  String get topicPaymentTitle => 'Chat Pembayaran';

  @override
  String get topicPaymentAgent => 'Petugas pembayaran';

  @override
  String get topicPaymentAvailability => 'Petugas pembayaran tersedia';

  @override
  String get topicPaymentWait => 'Biasanya membalas dalam 4 menit';

  @override
  String get topicPaymentOpening =>
      'Saya butuh bantuan terkait pembayaran tiket';

  @override
  String get topicPaymentShared =>
      'Status transaksi terakhir, kode tiket, dan waktu pembayaran';

  @override
  String get topicPaymentSampleData =>
      'ID transaksi: TRX-20260827-001\nMetode: QRIS\nNominal: Rp7.800\nWaktu: 27 Agustus 2026, 10.20 WIB\nStatus: Berhasil';

  @override
  String get topicPaymentAction => 'Mulai chat pembayaran';

  @override
  String get topicPaymentGreeting =>
      'Halo, saya Sari dari layanan pembayaran. Status transaksi terakhir Anda sudah saya terima. Apa kendala pembayarannya?';

  @override
  String get chatReplyTicketNotFound =>
      'Baik, saya bantu periksa. Coba buka Tiket Saya dan muat ulang halaman. Jika tiket tetap belum muncul, kirimkan kode tiket Anda di sini.';

  @override
  String get chatReplyTicketBuy =>
      'Untuk membeli tiket, pilih rute dari Beranda, tentukan perjalanan, lalu lanjutkan ke pembayaran. Tiket akan tampil di menu Tiket setelah pembayaran berhasil.';

  @override
  String get chatReplyTicketActive =>
      'Tiket aktif dapat dibuka dari menu Tiket. Pastikan kode QR terlihat jelas sebelum dipindai di gerbang.';

  @override
  String get chatReplyTicketDefault =>
      'Saya siap membantu memeriksa tiket Anda. Jelaskan status tiket atau langkah yang mengalami kendala.';

  @override
  String get chatReplyScheduleLate =>
      'ETA dapat berubah mengikuti posisi kereta. Beri tahu rute dan stasiun Anda agar saya dapat membantu mencocokkan informasi terakhir.';

  @override
  String get chatReplySchedulePlatform =>
      'Informasi peron dapat berubah di stasiun. Ikuti pengumuman petugas dan kirim nama stasiun jika informasi aplikasi berbeda.';

  @override
  String get chatReplyScheduleMissing =>
      'Saya bantu catat kereta yang tidak muncul. Kirim stasiun, tujuan, dan perkiraan waktu keberangkatannya.';

  @override
  String get chatReplyScheduleDefault =>
      'Silakan kirim rute, stasiun, dan waktu perjalanan yang ingin diperiksa.';

  @override
  String get chatReplyPaymentDeducted =>
      'Jika saldo terpotong tetapi tiket belum aktif, tunggu dua menit lalu periksa Riwayat Tiket. Kirim kode transaksi jika status belum berubah.';

  @override
  String get chatReplyPaymentRefund =>
      'Saya bantu memeriksa pengembalian dana. Kirim kode transaksi dan alasan pengajuan refund.';

  @override
  String get chatReplyPaymentFailed =>
      'Coba ulangi dengan jaringan stabil atau gunakan metode pembayaran lain. Kirim pesan kegagalan yang tampil jika masalah berlanjut.';

  @override
  String get chatReplyPaymentDefault =>
      'Jelaskan status transaksi atau metode pembayaran yang mengalami kendala agar saya dapat membantu.';

  @override
  String get payDeductedLabel => 'Saldo terpotong';

  @override
  String get payDeductedTitle => 'Saldo Terpotong';

  @override
  String get payDeductedStatus => 'Diproses';

  @override
  String get payDeductedDetail => 'Rp 8.000 terpotong, tiket belum aktif';

  @override
  String get payDeductedAdvice =>
      'Cek Riwayat tiket setelah 2 menit.\nKirim bantuan jika status belum berubah.';

  @override
  String get payDeductedAction => 'Laporkan saldo terpotong';

  @override
  String get payMissingLabel => 'Tiket belum muncul';

  @override
  String get payMissingTitle => 'Tiket Belum Muncul';

  @override
  String get payMissingStatus => 'Berhasil';

  @override
  String get payMissingDetail => 'Pembayaran berhasil, tiket belum tampil';

  @override
  String get payMissingAdvice =>
      'Muat ulang halaman Tiket Saya.\nJika tetap kosong, kirim kode transaksi.';

  @override
  String get payMissingAction => 'Laporkan tiket belum muncul';

  @override
  String get payRefundLabel => 'Refund';

  @override
  String get payRefundTitle => 'Refund';

  @override
  String get payRefundStatus => 'Diajukan';

  @override
  String get payRefundDetail => 'Pengembalian dana untuk tiket';

  @override
  String get payRefundAdvice =>
      'Refund mengikuti status transaksi terakhir.\nSimpan kode tiket sampai proses selesai.';

  @override
  String get payRefundAction => 'Ajukan refund';

  @override
  String get payMethodLabel => 'Metode bayar';

  @override
  String get payMethodTitle => 'Metode Bayar';

  @override
  String get payMethodStatus => 'Gagal';

  @override
  String get payMethodDetail => 'Metode pembayaran tidak dapat digunakan';

  @override
  String get payMethodAdvice =>
      'Coba metode pembayaran lain.\nLaporkan jika semua metode gagal.';

  @override
  String get payMethodAction => 'Laporkan metode bayar';

  @override
  String get payCheckStatusSubtitle => 'Cek status transaksi';

  @override
  String get payIssueTitle => 'Masalah pembayaran';

  @override
  String payActiveIssue(String issue) {
    return 'Kendala aktif: $issue';
  }

  @override
  String get payIssueDescription =>
      'Saran dan tindakan mengikuti kendala yang dipilih.';

  @override
  String get payLastTransaction => 'Transaksi terakhir';

  @override
  String get paySelectIssue => 'Pilih kendala';

  @override
  String get payQuickAdvice => 'Saran cepat';

  @override
  String payHelpPrepared(String issue) {
    return 'Bantuan $issue berhasil disiapkan.';
  }

  @override
  String get reportScheduleLabel => 'Jadwal';

  @override
  String get reportScheduleTitle => 'Lapor Jadwal';

  @override
  String get reportScheduleFirstLabel => 'Rute terkait';

  @override
  String get reportScheduleFirstValue => 'Bogor → Jakarta Kota';

  @override
  String get reportScheduleSecondLabel => 'Lokasi / stasiun';

  @override
  String get reportScheduleSecondValue => 'Bogor';

  @override
  String get reportScheduleDesc =>
      'ETA di aplikasi berbeda dengan papan informasi stasiun.';

  @override
  String get reportScheduleAction => 'Kirim laporan jadwal';

  @override
  String get reportRouteLabel => 'Rute';

  @override
  String get reportRouteTitle => 'Lapor Rute';

  @override
  String get reportRouteFirstLabel => 'Rute bermasalah';

  @override
  String get reportRouteFirstValue => 'Dukuh Atas → Harjamukti';

  @override
  String get reportRouteSecondLabel => 'Titik rute';

  @override
  String get reportRouteSecondValue => 'Stasiun transit';

  @override
  String get reportRouteDesc =>
      'Rute yang tampil tidak melewati stasiun transit yang benar.';

  @override
  String get reportRouteAction => 'Kirim laporan rute';

  @override
  String get reportStationLabel => 'Stasiun';

  @override
  String get reportStationTitle => 'Lapor Stasiun';

  @override
  String get reportStationFirstLabel => 'Nama stasiun';

  @override
  String get reportStationFirstValue => 'Jakarta Kota';

  @override
  String get reportStationSecondLabel => 'Info yang salah';

  @override
  String get reportStationSecondValue => 'Peron / fasilitas';

  @override
  String get reportStationDesc =>
      'Informasi stasiun tidak sesuai dengan kondisi di lokasi.';

  @override
  String get reportStationAction => 'Kirim laporan stasiun';

  @override
  String get reportSubtitle => 'Koreksi data perjalanan';

  @override
  String get reportWrongInfo => 'Lapor info salah';

  @override
  String reportTypePrefix(String type) {
    return 'Jenis laporan: $type';
  }

  @override
  String get reportFieldsDesc => 'Isian mengikuti jenis laporan yang dipilih.';

  @override
  String get reportTypeHeading => 'Jenis laporan';

  @override
  String get reportDescLabel => 'Deskripsi laporan';

  @override
  String get reportAttachScreenshot => 'Lampirkan screenshot';

  @override
  String get reportAttachScreenshotMsg =>
      'Pilih screenshot dari perangkat untuk dilampirkan.';

  @override
  String reportPrepared(String type) {
    return 'Laporan $type berhasil disiapkan.';
  }

  @override
  String get chatOnline => 'Online';

  @override
  String get chatLocalReply => 'Balasan lokal';

  @override
  String get chatToday => 'Hari ini';

  @override
  String get chatUser => 'Anda';

  @override
  String get chatAgent => 'Petugas';

  @override
  String get chatAgentTyping => 'Petugas sedang mengetik…';

  @override
  String get chatWriteMessage => 'Tulis pesan…';

  @override
  String get chatWaitReply => 'Menunggu balasan petugas…';

  @override
  String get chatSendMessage => 'Kirim pesan';

  @override
  String get activeTicketReadyShare => 'Kode tiket aktif siap dibagikan.';

  @override
  String get activeTicketTitle => 'Detail tiket aktif';

  @override
  String get activeTicketShareCode => 'Bagikan kode';

  @override
  String get activeTicketNeedHelp => 'Butuh bantuan';

  @override
  String get activeTicketOfflineOnly =>
      'Data tiket hanya tersimpan di perangkat ini.';

  @override
  String get activeTicketStatus => 'Aktif';

  @override
  String get activeTicketCodeTitle => 'Kode tiket aktif';

  @override
  String get activeTicketShowToStaff => 'Tunjukkan kode ini kepada petugas';

  @override
  String activeTicketCodeSemantic(String code) {
    return 'Kode tiket aktif $code';
  }

  @override
  String get activeTicketSavedOffline => 'Tersimpan offline';

  @override
  String get ticketStationOrigin => 'Stasiun asal';

  @override
  String get ticketStationDest => 'Tujuan';

  @override
  String get ticketStationDestFull => 'Stasiun tujuan';

  @override
  String get ticketEta => 'Perkiraan tiba';

  @override
  String get ticketType => 'Jenis tiket';

  @override
  String get ticketTypeActive => 'Tiket aktif';

  @override
  String get completedTicketReceiptReady =>
      'Bukti perjalanan berhasil disiapkan.';

  @override
  String get completedTicketTitle => 'Detail tiket selesai';

  @override
  String get completedTicketDownload => 'Unduh bukti';

  @override
  String get completedTicketReport => 'Laporkan masalah';

  @override
  String get completedTicketLocalHistory =>
      'Detail selesai tetap tersimpan di riwayat lokal.';

  @override
  String get completedTicketStatus => 'Selesai';

  @override
  String get completedTicketSummary => 'Ringkasan perjalanan';

  @override
  String get completedTicketDepart => 'Berangkat';

  @override
  String get completedTicketArrive => 'Tiba';

  @override
  String completedTicketDuration(String minutes) {
    return 'Durasi $minutes menit';
  }

  @override
  String get completedTicketJourneyDone => 'Perjalanan selesai';

  @override
  String get completedTicketCode => 'Kode perjalanan';

  @override
  String get completedTicketTypeLocal => 'Tiket lokal';

  @override
  String get actionBack => 'Kembali';

  @override
  String get departureDetailTitle => 'Detail Keberangkatan';

  @override
  String get departureFinalDestination => 'Tujuan Akhir';

  @override
  String get departureArrivingIn => 'Tiba Dalam';

  @override
  String get departurePlatformNumber => 'Nomor Peron';

  @override
  String departurePlatform(String platform) {
    return 'Peron $platform';
  }

  @override
  String get departureStatusNormal =>
      'Kereta beroperasi normal. Fasilitas prioritas tersedia di gerbong 3 dan 4.';

  @override
  String get departureNextStations => 'Stasiun Berikutnya';

  @override
  String departureArriveAt(String platform) {
    return 'Tiba di $platform';
  }

  @override
  String get departurePromoBadge => 'PROMO';

  @override
  String get departurePromoTitle => 'Diskon 50% Tiket Kereta Antarkota';

  @override
  String get departurePromoDesc =>
      'Beli tiket mudik sekarang dan dapatkan potongan harga spesial menggunakan KAI Pay.';

  @override
  String durationMinutes(String minutes) {
    return '$minutes Menit';
  }

  @override
  String stationTransit(String station) {
    return '$station (Transit)';
  }

  @override
  String get mapSearchHint => 'Cari stasiun atau favorit';

  @override
  String get mapSubtitleLrtKrl => 'LRT Jabodebek · KRL akses integrasi';

  @override
  String get mapSubtitleKrlTransit => 'KRL · Transit utama';

  @override
  String get mapSubtitleKrl => 'KRL Jabodetabek';

  @override
  String get mapSubtitleLrt => 'LRT Jabodebek';

  @override
  String get mapActionFrom => 'Dari';

  @override
  String get mapActionVia => 'Lewat';

  @override
  String get mapActionTo => 'Ke';

  @override
  String get mapActionInfo => 'Info';

  @override
  String get mapLegendTitle => 'Legenda Rute Utama';

  @override
  String get mapLegendBogor => 'KRL Bogor';

  @override
  String get mapLegendCikarang => 'KRL Cikarang Loop';

  @override
  String get mapLegendRangkasbitung => 'KRL Rangkasbitung';

  @override
  String get mapLegendTangerang => 'KRL Tangerang';

  @override
  String get mapLegendTanjungPriok => 'KRL Tanjung Priok';

  @override
  String get mapLegendMrt => 'MRT Utara Selatan';

  @override
  String get mapLegendLrtBekasi => 'LRT Lin Bekasi';

  @override
  String get mapLegendLrtCibubur => 'LRT Lin Cibubur';

  @override
  String get mapLegendLrtJakarta => 'LRT Jakarta Selatan';

  @override
  String get trainTypesJakarta => 'KRL · LRT · MRT Jakarta';

  @override
  String departFromStation(String station) {
    return 'Berangkat dari $station';
  }

  @override
  String get estimatedArrival => 'Estimasi Tiba';

  @override
  String get alarmActiveSemantics =>
      'Alarm perjalanan aktif, ketuk untuk menonaktifkan';

  @override
  String get alarmInactiveSemantics => 'Aktifkan alarm perjalanan';

  @override
  String get alarmActiveTooltip => 'Alarm aktif';

  @override
  String get alarmInactiveTooltip => 'Aktifkan alarm';

  @override
  String get alarmDisableBoth =>
      'Pengingat kereta datang dan pengingat turun atau transit akan dinonaktifkan.';

  @override
  String get alarmDisableDeparture =>
      'Pengingat kereta datang akan dinonaktifkan.';

  @override
  String get alarmDisableDestination =>
      'Pengingat turun atau transit akan dinonaktifkan.';

  @override
  String get alarmDisableNone => 'Tidak ada pengingat perjalanan yang aktif.';

  @override
  String get alarmDisableTitle => 'Matikan alarm perjalanan?';

  @override
  String get alarmDisableAction => 'Matikan alarm';

  @override
  String get alarmSetupTitle => 'Aktifkan pengingat perjalanan?';

  @override
  String routeFromTo(String from, String to) {
    return '$from ke $to';
  }

  @override
  String get alarmDepartureSemantics => 'Pengingat kereta datang';

  @override
  String get alarmDepartureTitle => 'Kereta datang';

  @override
  String get alarmDepartureDesc => 'Ingatkan 5 menit dan 1 menit sebelumnya';

  @override
  String get alarmDestinationSemantics => 'Pengingat turun atau transit';

  @override
  String get alarmDestinationTitle => 'Turun atau transit';

  @override
  String get alarmDestinationDesc => 'Ingatkan 1 stasiun sebelum tujuan';

  @override
  String get alarmSimulationNote =>
      'Pengingat ini merupakan simulasi dan aktif selama aplikasi dibuka.';

  @override
  String get alarmActivateBtn => 'Aktifkan alarm';

  @override
  String get actionSkip => 'Lewati';

  @override
  String get stateActive => 'aktif';

  @override
  String get stateInactive => 'nonaktif';

  @override
  String get alarmDepartureActive => 'Kereta datang aktif';

  @override
  String get alarmDepartureInactive => 'Kereta datang nonaktif';

  @override
  String get alarmDestinationActive => 'Turun atau transit aktif';

  @override
  String get alarmDestinationInactive => 'Turun atau transit nonaktif';

  @override
  String get viewTicketBtn => 'Lihat tiket';

  @override
  String get cancelAlarmBtn => 'Batalkan alarm';

  @override
  String get assistantChatAssistant => 'Asisten';

  @override
  String get assistantTypeMessage => 'Ketik pesan untuk Asisten';

  @override
  String get assistantSendMessage => 'Kirim pesan';

  @override
  String get assistantUseThisRoute => 'Pakai rute ini';

  @override
  String get assistantRepeat => 'Ulangi';

  @override
  String get assistantCancel => 'Batalkan';

  @override
  String get assistantBuyTicketToUseAlarm =>
      'Beli atau pilih tiket aktif untuk menggunakan alarm perjalanan.';

  @override
  String get assistantSearchTrip => 'Cari perjalanan';

  @override
  String assistantOpenQuickAction(String action) {
    return 'Buka $action';
  }

  @override
  String get assistantRetry => 'Coba lagi';

  @override
  String get assistantUnknownDestination => 'Saya belum memahami tujuanmu.';

  @override
  String assistantDemoTranscript(String destination, String origin) {
    return 'Saya ingin ke $destination dari $origin.';
  }

  @override
  String get assistantDemoResponse =>
      'Rute tercepat membutuhkan 7 menit. Kereta tiba 5 menit lagi.';

  @override
  String get assistantUnavailable =>
      'Asisten sedang tidak tersedia. Coba lagi atau cek informasi resmi stasiun.';

  @override
  String get assistantVoiceDestinationPrompt =>
      'Halo, kamu mau melakukan perjalanan ke mana?';

  @override
  String get assistantVoiceUnavailable =>
      'Fitur suara tidak tersedia. Periksa izin mikrofon lalu coba lagi.';

  @override
  String get assistantVoiceNoSpeech =>
      'Saya belum mendengar tujuanmu. Coba ucapkan lagi.';

  @override
  String get assistantUnknownCommand =>
      'Saya belum memahami perintah itu. Coba: “Alarm berikutnya kapan?” atau “Aktifkan semua alarm tiket saya”.';

  @override
  String get assistantNoActiveTicket => 'Belum ada tiket aktif';

  @override
  String get assistantNoActiveAlarm => 'Tidak ada alarm aktif.';

  @override
  String get assistantAllAlarmsCancelled =>
      'Semua alarm perjalanan dibatalkan.';

  @override
  String get assistantDestinationAlarmAlreadyOff =>
      'Alarm tujuan sudah nonaktif.';

  @override
  String get assistantDestinationAlarmDisabled => 'Alarm tujuan dinonaktifkan.';

  @override
  String get assistantAllAlarmsActive => 'Semua alarm perjalanan aktif.';

  @override
  String travelAlarmTrainArrivesIn(int minutes) {
    return 'Kereta datang $minutes menit lagi';
  }

  @override
  String get travelAlarmNoActive => 'Tidak ada alarm aktif';

  @override
  String travelAlarmExitAt(String destination, int stations) {
    return 'Turun di $destination, $stations stasiun lagi';
  }

  @override
  String travelAlarmTransferAt(String station, int stations) {
    return 'Transit di $station, $stations stasiun lagi';
  }

  @override
  String get travelAlarmDestinationFallback => 'tujuan';

  @override
  String get assistantCameraGuideAction => 'Pemandu Kamera';

  @override
  String assistantMessageSemantics(String sender, String message) {
    return '$sender, $message';
  }

  @override
  String get voiceTapToSpeak => 'Ketuk untuk bicara';

  @override
  String get voiceWhereToToday => 'Mau ke mana hari ini?';

  @override
  String get voiceStartConversation => 'Mulai percakapan suara';

  @override
  String get voiceListening => 'Mendengarkan';

  @override
  String get voicePleaseStateDestination =>
      'Silakan sebutkan tujuan perjalanan';

  @override
  String get voiceStopConversation => 'Hentikan percakapan suara';

  @override
  String get voiceProcessingRequest => 'Memproses permintaan';

  @override
  String get voiceSearchingForTrips => 'Mencari pilihan perjalanan yang sesuai';

  @override
  String get voiceRequestBeingProcessed => 'Permintaan sedang diproses';

  @override
  String get voiceAgentSpeaking => 'Agent sedang berbicara';

  @override
  String get voiceReadingAnswer => 'Jawaban perjalanan sedang dibacakan';

  @override
  String get voiceStopAssistant => 'Hentikan suara asisten';

  @override
  String get voiceNeedsConfirmation => 'Perlu konfirmasi';

  @override
  String get voiceChooseActionBeforeRoute =>
      'Pilih tindakan sebelum membuka rute';

  @override
  String get voiceStartNewConversation => 'Mulai percakapan baru';

  @override
  String get voiceUseVoiceOrQuickAction =>
      'Gunakan suara atau pilih aksi cepat.';

  @override
  String get voiceRetryConversation => 'Coba percakapan suara lagi';

  @override
  String homeNextTrainFrom(String station) {
    return 'Kereta berikutnya dari $station';
  }

  @override
  String get homeClose => 'Tutup';

  @override
  String homeShowAll(int count) {
    return 'Tampilkan Semua ($count)';
  }

  @override
  String homeTravelDuration(String duration) {
    return 'Perjalanan $duration';
  }

  @override
  String homePlatform(String platform) {
    return 'Peron $platform';
  }

  @override
  String homeDestination(String destination) {
    return 'Tujuan $destination';
  }

  @override
  String homeArrivingIn(String duration) {
    return 'Datang $duration lagi';
  }

  @override
  String get homeAtStation => 'di stasiun';

  @override
  String homeStationFacilities(String station) {
    return 'Fasilitas Stasiun $station';
  }

  @override
  String homeStationInformation(String station) {
    return 'Informasi Stasiun $station';
  }

  @override
  String get homeConstructionType => 'Tipe Konstruksi';

  @override
  String get homeConstructionTypeDesc =>
      'Stasiun Layang (Elevated) · Ramah Aksesibilitas';

  @override
  String get homeOperationalHours => 'Jam Operasional';

  @override
  String get homeOperationalHoursDesc => '05:00 - 23:30 WIB (Buka Setiap Hari)';

  @override
  String get homeTicketServices => 'Layanan Tiket';

  @override
  String get homeTicketServicesDesc =>
      'Kartu E-Money, KMT, QRIS, & Vending Machine';

  @override
  String get homeAccessibilityFeatures => 'Fitur Aksesibilitas';

  @override
  String get homeAccessibilityFeaturesDesc =>
      'Guiding Block, Ramp Khusus, & Pengumuman Audio TTS';

  @override
  String get homeExitGateGuide => 'Panduan Pintu Keluar (Exit Gate)';

  @override
  String get homeExitNorth => 'Pintu A (Utara)';

  @override
  String get homeExitNorthDesc => 'Akses Utama Jalan Utama / Kebon Sirih';

  @override
  String get homeExitNorthIntegration =>
      'Integrasi TransJakarta & Halte Busway';

  @override
  String get homeExitSouth => 'Pintu B (Selatan)';

  @override
  String get homeExitSouthDesc => 'Akses Jalan Srikaya & Area Komersial';

  @override
  String get homeExitSouthIntegration =>
      'Area Drop-off Ojek Online & Parkir Kendaraan';

  @override
  String get homeCustomerServiceHeader => 'Layanan Pelanggan & Bantuan CS';

  @override
  String homeCSStation(String station) {
    return 'Customer Service Stasiun $station';
  }

  @override
  String get homeContactCenter => 'Contact Center: 121 / (021) 121';

  @override
  String get homeWhatsApp => 'WhatsApp Aksesibilitas: +62 811-1211-121';

  @override
  String get homeCallCSBtn => 'Hubungi CS';

  @override
  String homeCallCSSnackbar(String station) {
    return 'Menghubungi CS Stasiun $station (121)...';
  }

  @override
  String get homeAskHelpBtn => 'Minta Bantuan';

  @override
  String homeAskHelpSnackbar(String station) {
    return 'Permintaan pendampingan petugas di $station telah dikirim!';
  }

  @override
  String get homeLineKRL => 'KRL Commuter Line';

  @override
  String get homeLineMRTJ => 'MRT Jakarta';

  @override
  String get homeLineLRTJabo => 'LRT Jabodebek';

  @override
  String get homeLineLRTJakarta => 'LRT Jakarta';

  @override
  String get homeFilterBogor => 'Lin Bogor & Nambo';

  @override
  String get homeFilterCikarang => 'Lin Cikarang';

  @override
  String get homeFilterRangkas => 'Lin Rangkasbitung';

  @override
  String get homeFilterTangerang => 'Lin Tangerang';

  @override
  String get homeFilterPriok => 'Lin Tanjung Priok';

  @override
  String get homeFilterMRTNorthSouth => 'MRT Lin Utara - Selatan';

  @override
  String get homeFilterLRTBekasi => 'Lin Bekasi';

  @override
  String get homeFilterLRTCibubur => 'Lin Cibubur';

  @override
  String get homeFilterLRTPegangsaan => 'Lin Pegangsaan Dua - Velodrome';

  @override
  String get actionRetry => 'Coba Lagi';

  @override
  String get homeAreaCentral => 'Jakarta Pusat';

  @override
  String get homeAreaSouth => 'Jakarta Selatan';

  @override
  String get homeAreaWest => 'Jakarta Barat';

  @override
  String get homeAreaEast => 'Jakarta Timur';

  @override
  String get homeAreaNorth => 'Jakarta Utara';

  @override
  String get homeAreaGreaterJakarta => 'Bodetabek (Penyangga)';

  @override
  String mapNearStation(String station) {
    return 'Anda berada di dekat Stasiun $station';
  }

  @override
  String get mapNearestMarkerNote =>
      'Penanda biru menunjukkan titik stasiun terdekat, bukan posisi GPS persis di peta skematik.';

  @override
  String get mapLocateMe => 'Temukan lokasi saya';

  @override
  String get routePreviewTitle => 'Pratinjau Perjalanan';

  @override
  String get routePreviewUnavailable => 'Pratinjau line tidak tersedia.';

  @override
  String get routePreviewLineTitle => 'Pratinjau Line Perjalanan';

  @override
  String routeCurrentLocation(String station) {
    return 'Anda Di Sini: $station';
  }

  @override
  String get routeDimmedLinesNote =>
      'Line lain diredupkan agar rute perjalanan lebih mudah dilihat.';

  @override
  String get routeBackToResults => 'Kembali ke hasil perjalanan';

  @override
  String get routeShowLineMap => 'Lihat Line di Peta';

  @override
  String get routeColdStartHint =>
      'Jika baru membuka server gratis, tunggu cold start lalu coba lagi.';

  @override
  String routeSummarySemantics(int minutes, int stops, String fare) {
    return '$minutes menit, $stops stasiun, tarif $fare';
  }

  @override
  String routeTransferCount(int count) {
    return '$count transit';
  }

  @override
  String get routeVoiceGuide => 'Panduan suara perjalanan';

  @override
  String routeFromStation(String station) {
    return 'Dari $station';
  }

  @override
  String routeToStation(String station) {
    return 'Ke $station';
  }

  @override
  String get routeLiveEta => 'Live ETA';

  @override
  String get routeFocusJourney => 'Fokus Perjalanan';

  @override
  String get routeAllLines => 'Semua Line';

  @override
  String get stationLoadError =>
      'Server sedang aktif atau koneksi terputus. Data stasiun belum dapat dimuat.';

  @override
  String get ticketSelectedTrip => 'Perjalanan dipilih';

  @override
  String get ticketPaymentConfirmation =>
      'Tiket aktif hanya setelah Xendit mengonfirmasi pembayaran ke server.';

  @override
  String get ticketOpenPayment => 'Buka pembayaran';

  @override
  String get ticketCheckStatus => 'Cek status';

  @override
  String ticketOwnerEmail(String email) {
    return 'Email: $email';
  }

  @override
  String get ticketGateInstruction => 'Tunjukkan kode ini di gerbang';

  @override
  String ticketDepartureAt(String time) {
    return 'Berangkat $time';
  }

  @override
  String get ticketDeviceHeader => 'Menampilkan tiket dari perangkat ini';

  @override
  String ticketDeviceSemantics(String count) {
    return 'Menampilkan tiket dari perangkat ini, $count';
  }

  @override
  String get ticketEmailHeader => 'Menampilkan tiket untuk';

  @override
  String ticketEmailSemantics(String email) {
    return 'Menampilkan tiket untuk $email';
  }

  @override
  String get ticketPartialHistoryError => 'Sebagian riwayat belum dapat dimuat';

  @override
  String get ticketEmptyCategory => 'Belum ada tiket pada kategori ini.';

  @override
  String get ticketShowHistory => 'Tampilkan riwayat';

  @override
  String get ticketReload => 'Muat ulang tiket';

  @override
  String get ticketBackToList => 'Kembali ke daftar tiket';

  @override
  String scheduleStatusUpcoming(int minutes) {
    return 'Berangkat $minutes menit lagi';
  }

  @override
  String get scheduleStatusSoon => 'Segera berangkat';

  @override
  String get scheduleStatusNow => 'Berangkat sekarang';

  @override
  String get scheduleStatusPassed => 'Jadwal lewat';

  @override
  String get scheduleStatusUnavailable => 'Status jadwal tidak tersedia';

  @override
  String get scheduleStatusDisclaimer =>
      'Status berdasarkan jadwal (bukan posisi kereta live)';

  @override
  String get scheduleServerActive => 'Server sedang aktif';

  @override
  String get scheduleBackendError =>
      'Koneksi ke backend masih disiapkan atau terputus. Coba lagi tanpa menganggap jadwal kosong.';

  @override
  String get scheduleDatasetNote =>
      'Jadwal Commuter Line Februari 2026 · status otomatis berdasarkan jadwal (bukan real-time KAI)';

  @override
  String get actionRepeat => 'Ulangi';

  @override
  String get actionPause => 'Jeda';

  @override
  String get actionStop => 'Hentikan';

  @override
  String get facilityAccessibleLift => 'Lift Aksesibel';

  @override
  String get facilityEscalator => 'Eskalator';

  @override
  String get facilityPrayerRoom => 'Musala';

  @override
  String get facilityAccessibleToilet => 'Toilet Difabel';

  @override
  String get facilityCharger => 'Pengisi Daya';

  @override
  String get facilityMinimarket => 'Minimarket';

  @override
  String get facilityNursingRoom => 'Ruang Menyusui';

  @override
  String get facilityAtmCenter => 'Pusat ATM';

  @override
  String get mapLocationServiceDisabled =>
      'Aktifkan layanan lokasi perangkat, lalu coba lagi.';

  @override
  String get mapLocationPermissionDenied =>
      'Izin lokasi dibutuhkan untuk menemukan stasiun terdekat.';

  @override
  String get stationVoiceEmpty =>
      'Tidak ada stasiun yang sesuai dengan pencarian.';

  @override
  String stationVoiceFound(int count) {
    return 'Ditemukan $count stasiun. Hasil teratas:';
  }

  @override
  String routeNarrationSummary(
    String from,
    String to,
    int minutes,
    String currency,
    String fare,
  ) {
    return 'Rute dari $from menuju $to. Estimasi waktu $minutes menit. Tarif $currency$fare.';
  }

  @override
  String get ticketStatusPending => 'Belum dibayar';

  @override
  String get ticketStatusPaid => 'Dibayar';

  @override
  String get ticketStatusUsed => 'Sudah digunakan';

  @override
  String get ticketStatusExpired => 'Kedaluwarsa';

  @override
  String get ticketStatusCancelled => 'Dibatalkan';

  @override
  String get ticketStatusUnknown => 'Tidak diketahui';

  @override
  String get travelAlarmInactive => 'Alarm perjalanan belum diaktifkan';

  @override
  String get routeLoadError =>
      'Tidak dapat memuat rute. Periksa koneksi dan coba lagi.';

  @override
  String get routeNoTransit => 'Tanpa transit';

  @override
  String get ticketEmailInputLabel => 'Email untuk tiket dan riwayat';
}
