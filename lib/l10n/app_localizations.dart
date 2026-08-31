import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('id'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @languagePageTitle.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get languagePageTitle;

  /// No description provided for @languagePageSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Bahasa yang sedang digunakan'**
  String get languagePageSubtitle;

  /// No description provided for @languageApp.
  ///
  /// In id, this message translates to:
  /// **'Bahasa aplikasi'**
  String get languageApp;

  /// No description provided for @languageDescription.
  ///
  /// In id, this message translates to:
  /// **'Pilih bahasa untuk navigasi dan pesan aplikasi'**
  String get languageDescription;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageIndonesianDesc.
  ///
  /// In id, this message translates to:
  /// **'Gunakan Bahasa Indonesia untuk label aplikasi'**
  String get languageIndonesianDesc;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageEnglishDesc.
  ///
  /// In id, this message translates to:
  /// **'Gunakan Bahasa Inggris untuk label aplikasi'**
  String get languageEnglishDesc;

  /// No description provided for @languageSimplifiedChinese.
  ///
  /// In id, this message translates to:
  /// **'简体中文'**
  String get languageSimplifiedChinese;

  /// No description provided for @languageSimplifiedChineseDesc.
  ///
  /// In id, this message translates to:
  /// **'Gunakan Bahasa Mandarin Sederhana untuk label aplikasi'**
  String get languageSimplifiedChineseDesc;

  /// No description provided for @languageArabic.
  ///
  /// In id, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageArabicDesc.
  ///
  /// In id, this message translates to:
  /// **'Gunakan Bahasa Arab untuk label aplikasi'**
  String get languageArabicDesc;

  /// No description provided for @preview.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau'**
  String get preview;

  /// No description provided for @previewAccount.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get previewAccount;

  /// No description provided for @previewGuestActive.
  ///
  /// In id, this message translates to:
  /// **'Mode tamu aktif'**
  String get previewGuestActive;

  /// No description provided for @applyLanguage.
  ///
  /// In id, this message translates to:
  /// **'Terapkan bahasa'**
  String get applyLanguage;

  /// No description provided for @languageAppliedNote.
  ///
  /// In id, this message translates to:
  /// **'Perubahan langsung diterapkan dan disimpan untuk kunjungan berikutnya.'**
  String get languageAppliedNote;

  /// No description provided for @languageAppliedSnackbar.
  ///
  /// In id, this message translates to:
  /// **'Bahasa diterapkan.'**
  String get languageAppliedSnackbar;

  /// No description provided for @languageSaveFailedSnackbar.
  ///
  /// In id, this message translates to:
  /// **'Bahasa diubah untuk sesi ini, tetapi preferensi Anda tidak dapat disimpan.'**
  String get languageSaveFailedSnackbar;

  /// No description provided for @profileAccount.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get profileAccount;

  /// No description provided for @profileGuestModeActive.
  ///
  /// In id, this message translates to:
  /// **'Mode tamu aktif'**
  String get profileGuestModeActive;

  /// No description provided for @profileGuest.
  ///
  /// In id, this message translates to:
  /// **'Tamu'**
  String get profileGuest;

  /// No description provided for @profileGuestDesc.
  ///
  /// In id, this message translates to:
  /// **'Tidak perlu login untuk peta, ETA. jadwal, dan beli tiket.'**
  String get profileGuestDesc;

  /// No description provided for @profileOptionalLogin.
  ///
  /// In id, this message translates to:
  /// **'Masuk atau Buat Akun'**
  String get profileOptionalLogin;

  /// No description provided for @profileLocalTicketHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat tiket lokal'**
  String get profileLocalTicketHistory;

  /// No description provided for @profileSavedOnDevice.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan di perangkat ini'**
  String get profileSavedOnDevice;

  /// No description provided for @profileAccessibility.
  ///
  /// In id, this message translates to:
  /// **'Aksesibilitas'**
  String get profileAccessibility;

  /// No description provided for @profileLargeText.
  ///
  /// In id, this message translates to:
  /// **'Teks besar dan bacakan rute'**
  String get profileLargeText;

  /// No description provided for @profileBlindGuide.
  ///
  /// In id, this message translates to:
  /// **'Pemandu Tunanetra'**
  String get profileBlindGuide;

  /// No description provided for @profileBlindGuideDescription.
  ///
  /// In id, this message translates to:
  /// **'Buka kamera dengan panduan suara otomatis'**
  String get profileBlindGuideDescription;

  /// No description provided for @cameraGuideActiveAnnouncement.
  ///
  /// In id, this message translates to:
  /// **'Pemandu kamera aktif. Arahkan kamera ke depan.'**
  String get cameraGuideActiveAnnouncement;

  /// No description provided for @cameraGuideTitle.
  ///
  /// In id, this message translates to:
  /// **'Pemandu Kamera'**
  String get cameraGuideTitle;

  /// No description provided for @cameraGuideBack.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get cameraGuideBack;

  /// No description provided for @cameraGuideStatus.
  ///
  /// In id, this message translates to:
  /// **'Status kamera: {status}'**
  String cameraGuideStatus(String status);

  /// No description provided for @cameraGuideStateLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat'**
  String get cameraGuideStateLoading;

  /// No description provided for @cameraGuideStateActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get cameraGuideStateActive;

  /// No description provided for @cameraGuideStatePermissionDenied.
  ///
  /// In id, this message translates to:
  /// **'Izin diperlukan'**
  String get cameraGuideStatePermissionDenied;

  /// No description provided for @cameraGuideStateOffline.
  ///
  /// In id, this message translates to:
  /// **'Offline'**
  String get cameraGuideStateOffline;

  /// No description provided for @cameraGuideStateError.
  ///
  /// In id, this message translates to:
  /// **'Kesalahan'**
  String get cameraGuideStateError;

  /// No description provided for @cameraGuideStateStopped.
  ///
  /// In id, this message translates to:
  /// **'Dihentikan'**
  String get cameraGuideStateStopped;

  /// No description provided for @cameraGuidePermissionRequired.
  ///
  /// In id, this message translates to:
  /// **'Izin kamera diperlukan. Aktifkan dari Pengaturan jika sebelumnya ditolak permanen.'**
  String get cameraGuidePermissionRequired;

  /// No description provided for @cameraGuideSafetyWarning.
  ///
  /// In id, this message translates to:
  /// **'Deteksi dapat keliru. Gunakan tongkat, pendamping, atau bantuan petugas.'**
  String get cameraGuideSafetyWarning;

  /// No description provided for @cameraGuideRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get cameraGuideRetry;

  /// No description provided for @cameraGuideStart.
  ///
  /// In id, this message translates to:
  /// **'Mulai Pemandu'**
  String get cameraGuideStart;

  /// No description provided for @cameraGuideStop.
  ///
  /// In id, this message translates to:
  /// **'Hentikan Pemandu'**
  String get cameraGuideStop;

  /// No description provided for @cameraGuideLoadingMessage.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan kamera…'**
  String get cameraGuideLoadingMessage;

  /// No description provided for @cameraGuideActiveMessage.
  ///
  /// In id, this message translates to:
  /// **'Arahkan kamera ke depan. Pemandu aktif.'**
  String get cameraGuideActiveMessage;

  /// No description provided for @cameraGuideUnavailableMessage.
  ///
  /// In id, this message translates to:
  /// **'Kamera tidak dapat digunakan.'**
  String get cameraGuideUnavailableMessage;

  /// No description provided for @cameraGuideOfflineMessage.
  ///
  /// In id, this message translates to:
  /// **'Deteksi lokal terbatas; koneksi AI tidak tersedia.'**
  String get cameraGuideOfflineMessage;

  /// No description provided for @cameraGuideStoppedMessage.
  ///
  /// In id, this message translates to:
  /// **'Pemandu kamera dihentikan.'**
  String get cameraGuideStoppedMessage;

  /// No description provided for @cameraGuideNoClearObject.
  ///
  /// In id, this message translates to:
  /// **'Belum ada objek jelas di depan.'**
  String get cameraGuideNoClearObject;

  /// No description provided for @cameraGuideObjectCount.
  ///
  /// In id, this message translates to:
  /// **'{count} objek terdeteksi di depan.'**
  String cameraGuideObjectCount(int count);

  /// No description provided for @cameraGuideLabelsDetected.
  ///
  /// In id, this message translates to:
  /// **'{labels} terdeteksi di depan.'**
  String cameraGuideLabelsDetected(String labels);

  /// No description provided for @profileHelpCenter.
  ///
  /// In id, this message translates to:
  /// **'Pusat Bantuan'**
  String get profileHelpCenter;

  /// No description provided for @profileContactOfficer.
  ///
  /// In id, this message translates to:
  /// **'Kontak petugas dan laporan info salah'**
  String get profileContactOfficer;

  /// No description provided for @authSignInTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke akun'**
  String get authSignInTitle;

  /// No description provided for @authSignInSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Akun bersifat opsional. Gunakan untuk menyinkronkan profil dan riwayat tiket.'**
  String get authSignInSubtitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In id, this message translates to:
  /// **'Buat akun'**
  String get authRegisterTitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar tanpa mengubah akses guest untuk jadwal, rute, dan pembelian tiket.'**
  String get authRegisterSubtitle;

  /// No description provided for @authName.
  ///
  /// In id, this message translates to:
  /// **'Nama lengkap'**
  String get authName;

  /// No description provided for @authEmail.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPhoneOptional.
  ///
  /// In id, this message translates to:
  /// **'Nomor telepon (opsional)'**
  String get authPhoneOptional;

  /// No description provided for @authPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi'**
  String get authPassword;

  /// No description provided for @authPasswordConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Ulangi kata sandi'**
  String get authPasswordConfirmation;

  /// No description provided for @authEmailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Masukkan alamat email yang valid.'**
  String get authEmailInvalid;

  /// No description provided for @authNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama minimal 2 karakter.'**
  String get authNameRequired;

  /// No description provided for @authPasswordMin.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi minimal 8 karakter.'**
  String get authPasswordMin;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi belum sama.'**
  String get authPasswordMismatch;

  /// No description provided for @authShowPassword.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan kata sandi'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan kata sandi'**
  String get authHidePassword;

  /// No description provided for @authSubmitLogin.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get authSubmitLogin;

  /// No description provided for @authSubmitRegister.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get authSubmitRegister;

  /// No description provided for @authCreateAccount.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun? Daftar'**
  String get authCreateAccount;

  /// No description provided for @authBackToLogin.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun? Masuk'**
  String get authBackToLogin;

  /// No description provided for @authGuestStillAvailable.
  ///
  /// In id, this message translates to:
  /// **'Tanpa akun, kamu tetap bisa melihat jadwal, mencari rute, dan membeli tiket sebagai guest.'**
  String get authGuestStillAvailable;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In id, this message translates to:
  /// **'Email atau kata sandi tidak sesuai.'**
  String get authInvalidCredentials;

  /// No description provided for @authEmailUsed.
  ///
  /// In id, this message translates to:
  /// **'Email ini sudah terdaftar.'**
  String get authEmailUsed;

  /// No description provided for @authNetworkError.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat terhubung ke server. Periksa koneksi dan coba lagi.'**
  String get authNetworkError;

  /// No description provided for @authGenericError.
  ///
  /// In id, this message translates to:
  /// **'Permintaan belum dapat diproses. Coba lagi.'**
  String get authGenericError;

  /// No description provided for @profileSignedIn.
  ///
  /// In id, this message translates to:
  /// **'Akun aktif'**
  String get profileSignedIn;

  /// No description provided for @profileOfflineSession.
  ///
  /// In id, this message translates to:
  /// **'Akun tersimpan • sedang offline'**
  String get profileOfflineSession;

  /// No description provided for @profileOfflineHint.
  ///
  /// In id, this message translates to:
  /// **'Beberapa perubahan akan tersedia saat koneksi kembali.'**
  String get profileOfflineHint;

  /// No description provided for @profileEdit.
  ///
  /// In id, this message translates to:
  /// **'Edit profil'**
  String get profileEdit;

  /// No description provided for @profileLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari akun di perangkat ini? Fitur guest tetap dapat digunakan.'**
  String get profileLogoutConfirm;

  /// No description provided for @profileCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get profileCancel;

  /// No description provided for @profileAccountTicketHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat tiket akun'**
  String get profileAccountTicketHistory;

  /// No description provided for @profileSyncedAccount.
  ///
  /// In id, this message translates to:
  /// **'Tersinkron dengan akun ini'**
  String get profileSyncedAccount;

  /// No description provided for @editProfileTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit profil'**
  String get editProfileTitle;

  /// No description provided for @saveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan perubahan'**
  String get saveChanges;

  /// No description provided for @navHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// No description provided for @navSchedule.
  ///
  /// In id, this message translates to:
  /// **'Jadwal'**
  String get navSchedule;

  /// No description provided for @navTickets.
  ///
  /// In id, this message translates to:
  /// **'Tiket'**
  String get navTickets;

  /// No description provided for @navAssistant.
  ///
  /// In id, this message translates to:
  /// **'Asisten'**
  String get navAssistant;

  /// No description provided for @navAccount.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get navAccount;

  /// No description provided for @filterArea.
  ///
  /// In id, this message translates to:
  /// **'Filter Kawasan'**
  String get filterArea;

  /// No description provided for @areaJabodetabek.
  ///
  /// In id, this message translates to:
  /// **'Seluruh Jabodetabek'**
  String get areaJabodetabek;

  /// No description provided for @filterAreaComingSoon.
  ///
  /// In id, this message translates to:
  /// **'Filter spesifik kawasan segera hadir'**
  String get filterAreaComingSoon;

  /// No description provided for @filterLine.
  ///
  /// In id, this message translates to:
  /// **'Filter Jalur Transportasi'**
  String get filterLine;

  /// No description provided for @searchStationHint.
  ///
  /// In id, this message translates to:
  /// **'Ketik nama stasiun, jalur, atau area'**
  String get searchStationHint;

  /// No description provided for @startFrom.
  ///
  /// In id, this message translates to:
  /// **'Mulai dari: {station}'**
  String startFrom(String station);

  /// No description provided for @selectedStation.
  ///
  /// In id, this message translates to:
  /// **'Stasiun Terpilih'**
  String get selectedStation;

  /// No description provided for @from.
  ///
  /// In id, this message translates to:
  /// **'Dari'**
  String get from;

  /// No description provided for @to.
  ///
  /// In id, this message translates to:
  /// **'Ke'**
  String get to;

  /// No description provided for @selectFromFirst.
  ///
  /// In id, this message translates to:
  /// **'Pilih stasiun asal (Dari) terlebih dahulu!'**
  String get selectFromFirst;

  /// No description provided for @nearestDepartures.
  ///
  /// In id, this message translates to:
  /// **'Keberangkatan Terdekat'**
  String get nearestDepartures;

  /// No description provided for @allStations.
  ///
  /// In id, this message translates to:
  /// **'Semua Stasiun'**
  String get allStations;

  /// No description provided for @all.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get all;

  /// No description provided for @selectOriginStation.
  ///
  /// In id, this message translates to:
  /// **'Pilih Stasiun Asal'**
  String get selectOriginStation;

  /// No description provided for @searchStationHint2.
  ///
  /// In id, this message translates to:
  /// **'Cari nama stasiun (misal: Manggarai, Halim...)'**
  String get searchStationHint2;

  /// No description provided for @weekday.
  ///
  /// In id, this message translates to:
  /// **'Hari Kerja'**
  String get weekday;

  /// No description provided for @weekend.
  ///
  /// In id, this message translates to:
  /// **'Akhir Pekan'**
  String get weekend;

  /// No description provided for @trainSchedule.
  ///
  /// In id, this message translates to:
  /// **'Jadwal Kereta'**
  String get trainSchedule;

  /// No description provided for @searchDestinationHint.
  ///
  /// In id, this message translates to:
  /// **'Cari stasiun tujuan atau nomor kereta...'**
  String get searchDestinationHint;

  /// No description provided for @filterOriginAll.
  ///
  /// In id, this message translates to:
  /// **'Filter Stasiun Asal (Semua Stasiun)'**
  String get filterOriginAll;

  /// No description provided for @originStation.
  ///
  /// In id, this message translates to:
  /// **'Stasiun Asal: {station}'**
  String originStation(String station);

  /// No description provided for @scheduleNotFound.
  ///
  /// In id, this message translates to:
  /// **'Jadwal tidak ditemukan'**
  String get scheduleNotFound;

  /// No description provided for @tryChangingFilter.
  ///
  /// In id, this message translates to:
  /// **'Cobalah mengubah filter stasiun atau hari.'**
  String get tryChangingFilter;

  /// No description provided for @alarmActivated.
  ///
  /// In id, this message translates to:
  /// **'Alarm perjalanan diaktifkan'**
  String get alarmActivated;

  /// No description provided for @alarmDeactivated.
  ///
  /// In id, this message translates to:
  /// **'Alarm perjalanan dinonaktifkan'**
  String get alarmDeactivated;

  /// No description provided for @tickets.
  ///
  /// In id, this message translates to:
  /// **'Tiket'**
  String get tickets;

  /// No description provided for @validUntil.
  ///
  /// In id, this message translates to:
  /// **'Berlaku sampai 23:59'**
  String get validUntil;

  /// No description provided for @payBefore.
  ///
  /// In id, this message translates to:
  /// **'Bayar sebelum 23:59'**
  String get payBefore;

  /// No description provided for @usedToday.
  ///
  /// In id, this message translates to:
  /// **'Digunakan hari ini, 09:12'**
  String get usedToday;

  /// No description provided for @unpaid.
  ///
  /// In id, this message translates to:
  /// **'Belum bayar'**
  String get unpaid;

  /// No description provided for @active.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get active;

  /// No description provided for @completed.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get completed;

  /// No description provided for @travelTicket.
  ///
  /// In id, this message translates to:
  /// **'Tiket perjalanan'**
  String get travelTicket;

  /// No description provided for @ticketStatusSummary.
  ///
  /// In id, this message translates to:
  /// **'{active} tiket aktif · {pending} belum dibayar · {completed} selesai'**
  String ticketStatusSummary(int active, int pending, int completed);

  /// No description provided for @notPaid.
  ///
  /// In id, this message translates to:
  /// **'Belum dibayar'**
  String get notPaid;

  /// No description provided for @alreadyUsed.
  ///
  /// In id, this message translates to:
  /// **'Sudah digunakan'**
  String get alreadyUsed;

  /// No description provided for @readyToScan.
  ///
  /// In id, this message translates to:
  /// **'Siap scan'**
  String get readyToScan;

  /// No description provided for @payNow.
  ///
  /// In id, this message translates to:
  /// **'Bayar sekarang'**
  String get payNow;

  /// No description provided for @detail.
  ///
  /// In id, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @viewQR.
  ///
  /// In id, this message translates to:
  /// **'Lihat QR'**
  String get viewQR;

  /// No description provided for @ticketAlreadyUsed.
  ///
  /// In id, this message translates to:
  /// **'Tiket ini sudah selesai digunakan.'**
  String get ticketAlreadyUsed;

  /// No description provided for @qrValidUntil.
  ///
  /// In id, this message translates to:
  /// **'QR berlaku sampai'**
  String get qrValidUntil;

  /// No description provided for @choosePayment.
  ///
  /// In id, this message translates to:
  /// **'Pilih pembayaran'**
  String get choosePayment;

  /// No description provided for @qrisDesc.
  ///
  /// In id, this message translates to:
  /// **'Tanpa akun, semua e-wallet'**
  String get qrisDesc;

  /// No description provided for @creditCard.
  ///
  /// In id, this message translates to:
  /// **'Kartu debit/kredit'**
  String get creditCard;

  /// No description provided for @virtualAccount.
  ///
  /// In id, this message translates to:
  /// **'VA / transfer'**
  String get virtualAccount;

  /// No description provided for @vaDesc.
  ///
  /// In id, this message translates to:
  /// **'Kode bayar sekali pakai'**
  String get vaDesc;

  /// No description provided for @optionalContact.
  ///
  /// In id, this message translates to:
  /// **'Nomor HP/email opsional'**
  String get optionalContact;

  /// No description provided for @optionalContactDesc.
  ///
  /// In id, this message translates to:
  /// **'Hanya untuk mengirim salinan tiket. Tidak membuat akun.'**
  String get optionalContactDesc;

  /// No description provided for @payAmount.
  ///
  /// In id, this message translates to:
  /// **'Bayar {amount}'**
  String payAmount(String amount);

  /// No description provided for @paymentSuccess.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran berhasil'**
  String get paymentSuccess;

  /// No description provided for @scanQrAtGate.
  ///
  /// In id, this message translates to:
  /// **'Scan QR di gate masuk.'**
  String get scanQrAtGate;

  /// No description provided for @validGateInBefore.
  ///
  /// In id, this message translates to:
  /// **'Berlaku gate-in sebelum'**
  String get validGateInBefore;

  /// No description provided for @today2359.
  ///
  /// In id, this message translates to:
  /// **'23:59 hari ini'**
  String get today2359;

  /// No description provided for @withoutAccount.
  ///
  /// In id, this message translates to:
  /// **'Tanpa akun'**
  String get withoutAccount;

  /// No description provided for @guest.
  ///
  /// In id, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @ticketSaved.
  ///
  /// In id, this message translates to:
  /// **'Tiket disimpan ke galeri ponsel!'**
  String get ticketSaved;

  /// No description provided for @saveTicket.
  ///
  /// In id, this message translates to:
  /// **'Simpan tiket'**
  String get saveTicket;

  /// No description provided for @sharingTicketLink.
  ///
  /// In id, this message translates to:
  /// **'Membagikan tautan tiket...'**
  String get sharingTicketLink;

  /// No description provided for @share.
  ///
  /// In id, this message translates to:
  /// **'Bagikan'**
  String get share;

  /// No description provided for @a11yQrInfo.
  ///
  /// In id, this message translates to:
  /// **'A11Y: QR memiliki kode tiket teks cadangan untuk bantuan petugas.'**
  String get a11yQrInfo;

  /// No description provided for @assistantReady.
  ///
  /// In id, this message translates to:
  /// **'Siap membantu'**
  String get assistantReady;

  /// No description provided for @assistantListening.
  ///
  /// In id, this message translates to:
  /// **'Mendengarkan'**
  String get assistantListening;

  /// No description provided for @assistantProcessing.
  ///
  /// In id, this message translates to:
  /// **'Memproses'**
  String get assistantProcessing;

  /// No description provided for @assistantSpeaking.
  ///
  /// In id, this message translates to:
  /// **'Berbicara'**
  String get assistantSpeaking;

  /// No description provided for @assistantWaiting.
  ///
  /// In id, this message translates to:
  /// **'Menunggu konfirmasi'**
  String get assistantWaiting;

  /// No description provided for @assistantError.
  ///
  /// In id, this message translates to:
  /// **'Perlu dicoba lagi'**
  String get assistantError;

  /// No description provided for @voiceStart.
  ///
  /// In id, this message translates to:
  /// **'Mulai percakapan suara'**
  String get voiceStart;

  /// No description provided for @voiceStop.
  ///
  /// In id, this message translates to:
  /// **'Hentikan percakapan suara'**
  String get voiceStop;

  /// No description provided for @voiceProcessing.
  ///
  /// In id, this message translates to:
  /// **'Permintaan sedang diproses'**
  String get voiceProcessing;

  /// No description provided for @voiceStopSpeaking.
  ///
  /// In id, this message translates to:
  /// **'Hentikan suara asisten'**
  String get voiceStopSpeaking;

  /// No description provided for @voiceNew.
  ///
  /// In id, this message translates to:
  /// **'Mulai percakapan baru'**
  String get voiceNew;

  /// No description provided for @voiceRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba percakapan suara lagi'**
  String get voiceRetry;

  /// No description provided for @quickActions.
  ///
  /// In id, this message translates to:
  /// **'Tindakan cepat'**
  String get quickActions;

  /// No description provided for @planTrip.
  ///
  /// In id, this message translates to:
  /// **'Rencanakan perjalanan'**
  String get planTrip;

  /// No description provided for @nextTrain.
  ///
  /// In id, this message translates to:
  /// **'Kereta berikutnya'**
  String get nextTrain;

  /// No description provided for @myTickets.
  ///
  /// In id, this message translates to:
  /// **'Tiket saya'**
  String get myTickets;

  /// No description provided for @officerHelp.
  ///
  /// In id, this message translates to:
  /// **'Bantuan petugas'**
  String get officerHelp;

  /// No description provided for @travelAssistant.
  ///
  /// In id, this message translates to:
  /// **'Asisten Perjalanan'**
  String get travelAssistant;

  /// No description provided for @assistantStatusLabel.
  ///
  /// In id, this message translates to:
  /// **'Status asisten: {status}'**
  String assistantStatusLabel(String status);

  /// No description provided for @wakeWordMode.
  ///
  /// In id, this message translates to:
  /// **'Mode kata pemicu Halo Asisten'**
  String get wakeWordMode;

  /// No description provided for @inactive.
  ///
  /// In id, this message translates to:
  /// **'nonaktif'**
  String get inactive;

  /// No description provided for @listenWakeWord.
  ///
  /// In id, this message translates to:
  /// **'Dengarkan \"Halo Asisten\"'**
  String get listenWakeWord;

  /// No description provided for @wakeWordActiveText.
  ///
  /// In id, this message translates to:
  /// **'Kata pemicu aktif'**
  String get wakeWordActiveText;

  /// No description provided for @wakeWordPageOnly.
  ///
  /// In id, this message translates to:
  /// **'Aktif hanya di halaman ini'**
  String get wakeWordPageOnly;

  /// No description provided for @back.
  ///
  /// In id, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @selectDestination.
  ///
  /// In id, this message translates to:
  /// **'Pilih stasiun tujuan'**
  String get selectDestination;

  /// No description provided for @searchStationTitle.
  ///
  /// In id, this message translates to:
  /// **'Cari stasiun'**
  String get searchStationTitle;

  /// No description provided for @startTripFrom.
  ///
  /// In id, this message translates to:
  /// **'Mulai perjalanan dari: {station}'**
  String startTripFrom(String station);

  /// No description provided for @serviceFilter.
  ///
  /// In id, this message translates to:
  /// **'Filter layanan'**
  String get serviceFilter;

  /// No description provided for @accessible.
  ///
  /// In id, this message translates to:
  /// **'Aksesibel'**
  String get accessible;

  /// No description provided for @quickResults.
  ///
  /// In id, this message translates to:
  /// **'Hasil cepat'**
  String get quickResults;

  /// No description provided for @stationNotFound.
  ///
  /// In id, this message translates to:
  /// **'Stasiun tidak ditemukan'**
  String get stationNotFound;

  /// No description provided for @stationVoiceGuide.
  ///
  /// In id, this message translates to:
  /// **'Panduan suara'**
  String get stationVoiceGuide;

  /// No description provided for @stationVoiceGuideStop.
  ///
  /// In id, this message translates to:
  /// **'Hentikan panduan suara'**
  String get stationVoiceGuideStop;

  /// No description provided for @stationVoiceGuideError.
  ///
  /// In id, this message translates to:
  /// **'Panduan suara tidak dapat digunakan. Coba lagi.'**
  String get stationVoiceGuideError;

  /// No description provided for @withoutLogin.
  ///
  /// In id, this message translates to:
  /// **'Tanpa login'**
  String get withoutLogin;

  /// No description provided for @favoriteHistoryLocal.
  ///
  /// In id, this message translates to:
  /// **'Favorit dan riwayat disimpan lokal di perangkat.'**
  String get favoriteHistoryLocal;

  /// No description provided for @routeGuideTitle.
  ///
  /// In id, this message translates to:
  /// **'Panduan Rute Perjalanan'**
  String get routeGuideTitle;

  /// No description provided for @fastest.
  ///
  /// In id, this message translates to:
  /// **'Tercepat'**
  String get fastest;

  /// No description provided for @minTransit.
  ///
  /// In id, this message translates to:
  /// **'Minim transit'**
  String get minTransit;

  /// No description provided for @travelEstimate.
  ///
  /// In id, this message translates to:
  /// **'Estimasi Perjalanan'**
  String get travelEstimate;

  /// No description provided for @minutesOnly.
  ///
  /// In id, this message translates to:
  /// **'menit'**
  String get minutesOnly;

  /// No description provided for @stopsAndService.
  ///
  /// In id, this message translates to:
  /// **'{stops} Stasiun · {serviceInfo}'**
  String stopsAndService(int stops, String serviceInfo);

  /// No description provided for @travelFare.
  ///
  /// In id, this message translates to:
  /// **'Tarif Perjalanan'**
  String get travelFare;

  /// No description provided for @routeTimeline.
  ///
  /// In id, this message translates to:
  /// **'Timeline Rute Perjalanan'**
  String get routeTimeline;

  /// No description provided for @exitGateInfo.
  ///
  /// In id, this message translates to:
  /// **'Informasi Pintu Keluar Stasiun {to}'**
  String exitGateInfo(String to);

  /// No description provided for @buyTicketDirect.
  ///
  /// In id, this message translates to:
  /// **'Beli Tiket Langsung ({fare})'**
  String buyTicketDirect(String fare);

  /// No description provided for @readRouteToast.
  ///
  /// In id, this message translates to:
  /// **'Membacakan rute dari {from} ke {to}: Durasi {travelTime} menit.'**
  String readRouteToast(String from, String to, int travelTime);

  /// No description provided for @readRouteBtn.
  ///
  /// In id, this message translates to:
  /// **'Bacakan Rute'**
  String get readRouteBtn;

  /// No description provided for @viewOnMapBtn.
  ///
  /// In id, this message translates to:
  /// **'Lihat di Peta'**
  String get viewOnMapBtn;

  /// No description provided for @a11yAudioRoute.
  ///
  /// In id, this message translates to:
  /// **'A11Y Audio: Rute {from} ke {to} ({travelTime} mnt, {stops} stop).'**
  String a11yAudioRoute(String from, String to, int travelTime, int stops);

  /// No description provided for @nextTrainLive.
  ///
  /// In id, this message translates to:
  /// **'KERETA BERIKUTNYA (LIVE REALTIME)'**
  String get nextTrainLive;

  /// No description provided for @noTripNeeded.
  ///
  /// In id, this message translates to:
  /// **'Tidak butuh perjalanan'**
  String get noTripNeeded;

  /// No description provided for @sameOriginDest.
  ///
  /// In id, this message translates to:
  /// **'Asal dan tujuan sama.'**
  String get sameOriginDest;

  /// No description provided for @alreadyAtDest.
  ///
  /// In id, this message translates to:
  /// **'Anda sudah berada di lokasi stasiun tujuan.'**
  String get alreadyAtDest;

  /// No description provided for @minuteShort.
  ///
  /// In id, this message translates to:
  /// **'mnt'**
  String get minuteShort;

  /// No description provided for @lineNoTransit.
  ///
  /// In id, this message translates to:
  /// **'{lineName} · Tanpa transit'**
  String lineNoTransit(String lineName);

  /// No description provided for @boardLineFrom.
  ///
  /// In id, this message translates to:
  /// **'Naik {lineName} dari Stasiun {from}'**
  String boardLineFrom(String lineName, String from);

  /// No description provided for @departureTime.
  ///
  /// In id, this message translates to:
  /// **'Keberangkatan: 08:35 WIB'**
  String get departureTime;

  /// No description provided for @platformDirection.
  ///
  /// In id, this message translates to:
  /// **'Peron {platform} · Arah {to}'**
  String platformDirection(int platform, String to);

  /// No description provided for @directTripTo.
  ///
  /// In id, this message translates to:
  /// **'Perjalanan langsung menuju {to} ({stops} stasiun)'**
  String directTripTo(String to, int stops);

  /// No description provided for @estDuration.
  ///
  /// In id, this message translates to:
  /// **'estimasi {duration} mnt'**
  String estDuration(int duration);

  /// No description provided for @skipStops.
  ///
  /// In id, this message translates to:
  /// **'Lewati {stops} stasiun perhentian secara langsung'**
  String skipStops(int stops);

  /// No description provided for @arriveAtDest.
  ///
  /// In id, this message translates to:
  /// **'Tiba di Stasiun tujuan {to}'**
  String arriveAtDest(String to);

  /// No description provided for @totalDuration.
  ///
  /// In id, this message translates to:
  /// **'Total {duration} mnt'**
  String totalDuration(int duration);

  /// No description provided for @elevatedStation.
  ///
  /// In id, this message translates to:
  /// **'Stasiun Layang (Elevated)'**
  String get elevatedStation;

  /// No description provided for @gateA.
  ///
  /// In id, this message translates to:
  /// **'Pintu A (Utara): {gate}'**
  String gateA(String gate);

  /// No description provided for @gateB.
  ///
  /// In id, this message translates to:
  /// **'Pintu B (Selatan): {gate}'**
  String gateB(String gate);

  /// No description provided for @mainAccessGate.
  ///
  /// In id, this message translates to:
  /// **'Akses Utama Jalan Utama & Integrasi Halte TransJakarta'**
  String get mainAccessGate;

  /// No description provided for @dropOffGate.
  ///
  /// In id, this message translates to:
  /// **'Area Drop-off Ojek Online, Pangkalan Taksi & Parkir'**
  String get dropOffGate;

  /// No description provided for @oneTransitAt.
  ///
  /// In id, this message translates to:
  /// **'1 transit · Berpindah di {station}'**
  String oneTransitAt(String station);

  /// No description provided for @alightAt.
  ///
  /// In id, this message translates to:
  /// **'Turun di Stasiun {station} ({stops} stop perhentian)'**
  String alightAt(String station, int stops);

  /// No description provided for @prepareTransitAt.
  ///
  /// In id, this message translates to:
  /// **'Persiapan berpindah jalur di Stasiun {station}'**
  String prepareTransitAt(String station);

  /// No description provided for @transitToLine.
  ///
  /// In id, this message translates to:
  /// **'Transit di {station}: Pindah ke peron {line}'**
  String transitToLine(String station, String line);

  /// No description provided for @transitPlatform1To2.
  ///
  /// In id, this message translates to:
  /// **'Berpindah dari Peron 1 ke Peron 2 (Lift Aksesibel & Guiding Block)'**
  String get transitPlatform1To2;

  /// No description provided for @boardLineTo.
  ///
  /// In id, this message translates to:
  /// **'Naik {line} ke arah Stasiun {to} ({stops} stop perhentian)'**
  String boardLineTo(String line, String to, int stops);

  /// No description provided for @nextTrainAtPlatform.
  ///
  /// In id, this message translates to:
  /// **'Kereta berikutnya tiba {minutes} menit lagi di Peron {platform}'**
  String nextTrainAtPlatform(int minutes, int platform);

  /// No description provided for @a11yReadingPreview.
  ///
  /// In id, this message translates to:
  /// **'Membacakan: Dukuh Atas ke Harjamukti, Peron 2, tiba 4 menit lagi.'**
  String get a11yReadingPreview;

  /// No description provided for @a11yTitle.
  ///
  /// In id, this message translates to:
  /// **'Aksesibilitas'**
  String get a11yTitle;

  /// No description provided for @a11ySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Teks dan suara'**
  String get a11ySubtitle;

  /// No description provided for @a11yDisplaySettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan tampilan'**
  String get a11yDisplaySettings;

  /// No description provided for @a11yMakeEasier.
  ///
  /// In id, this message translates to:
  /// **'Buat aplikasi lebih mudah dibaca dan didengar'**
  String get a11yMakeEasier;

  /// No description provided for @a11yLargeText.
  ///
  /// In id, this message translates to:
  /// **'Teks besar'**
  String get a11yLargeText;

  /// No description provided for @a11yLargeTextDesc.
  ///
  /// In id, this message translates to:
  /// **'Perbesar label dan informasi rute'**
  String get a11yLargeTextDesc;

  /// No description provided for @a11yReadRoute.
  ///
  /// In id, this message translates to:
  /// **'Bacakan rute'**
  String get a11yReadRoute;

  /// No description provided for @a11yReadRouteDesc.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan pembacaan stasiun dan arah'**
  String get a11yReadRouteDesc;

  /// No description provided for @a11yRoutePreviewSemantic.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau rute. Dukuh Atas ke Harjamukti. Peron 2, tiba 4 menit lagi.'**
  String get a11yRoutePreviewSemantic;

  /// No description provided for @a11yRoutePreviewTitle.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau rute'**
  String get a11yRoutePreviewTitle;

  /// No description provided for @a11yRoutePreviewRoute.
  ///
  /// In id, this message translates to:
  /// **'Dukuh Atas → Harjamukti'**
  String get a11yRoutePreviewRoute;

  /// No description provided for @a11yRoutePreviewDetail.
  ///
  /// In id, this message translates to:
  /// **'Peron 2, tiba 4 menit lagi'**
  String get a11yRoutePreviewDetail;

  /// No description provided for @a11yReadBtn.
  ///
  /// In id, this message translates to:
  /// **'Baca'**
  String get a11yReadBtn;

  /// No description provided for @historyCleared.
  ///
  /// In id, this message translates to:
  /// **'Riwayat tiket dibersihkan dari perangkat ini.'**
  String get historyCleared;

  /// No description provided for @historyTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat tiket'**
  String get historyTitle;

  /// No description provided for @historyCompleted.
  ///
  /// In id, this message translates to:
  /// **'Riwayat selesai'**
  String get historyCompleted;

  /// No description provided for @historySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan di perangkat ini'**
  String get historySubtitle;

  /// No description provided for @historyLastTicket.
  ///
  /// In id, this message translates to:
  /// **'Tiket terakhir'**
  String get historyLastTicket;

  /// No description provided for @historySortRecent.
  ///
  /// In id, this message translates to:
  /// **'Urut dari perjalanan terbaru'**
  String get historySortRecent;

  /// No description provided for @historyKrl.
  ///
  /// In id, this message translates to:
  /// **'KRL Commuter Line'**
  String get historyKrl;

  /// No description provided for @historyKrlRoute.
  ///
  /// In id, this message translates to:
  /// **'Bogor → Jakarta Kota'**
  String get historyKrlRoute;

  /// No description provided for @historyKrlDate.
  ///
  /// In id, this message translates to:
  /// **'Hari ini, 08:12 WIB'**
  String get historyKrlDate;

  /// No description provided for @historyLrt.
  ///
  /// In id, this message translates to:
  /// **'LRT Jabodebek'**
  String get historyLrt;

  /// No description provided for @historyLrtRoute.
  ///
  /// In id, this message translates to:
  /// **'Dukuh Atas → Harjamukti'**
  String get historyLrtRoute;

  /// No description provided for @historyLrtDate.
  ///
  /// In id, this message translates to:
  /// **'Selasa, 7 Jul 2026'**
  String get historyLrtDate;

  /// No description provided for @historyGuestMode.
  ///
  /// In id, this message translates to:
  /// **'Mode tamu'**
  String get historyGuestMode;

  /// No description provided for @historyGuestDesc.
  ///
  /// In id, this message translates to:
  /// **'Riwayat ini hanya ada di perangkat ini.'**
  String get historyGuestDesc;

  /// No description provided for @historyNoTickets.
  ///
  /// In id, this message translates to:
  /// **'Belum ada riwayat tiket'**
  String get historyNoTickets;

  /// No description provided for @historyClearHistory.
  ///
  /// In id, this message translates to:
  /// **'Bersihkan riwayat'**
  String get historyClearHistory;

  /// No description provided for @historyClearDesc.
  ///
  /// In id, this message translates to:
  /// **'Hapus data dari perangkat ini.'**
  String get historyClearDesc;

  /// No description provided for @helpTopicBuyTicket.
  ///
  /// In id, this message translates to:
  /// **'Cara membeli tiket lokal'**
  String get helpTopicBuyTicket;

  /// No description provided for @helpTopicBuyTicketDesc.
  ///
  /// In id, this message translates to:
  /// **'Panduan untuk KRL dan LRT'**
  String get helpTopicBuyTicketDesc;

  /// No description provided for @helpTopicScheduleIssue.
  ///
  /// In id, this message translates to:
  /// **'Jadwal atau ETA tidak sesuai'**
  String get helpTopicScheduleIssue;

  /// No description provided for @helpTopicScheduleIssueDesc.
  ///
  /// In id, this message translates to:
  /// **'Kirim laporan dari detail rute'**
  String get helpTopicScheduleIssueDesc;

  /// No description provided for @helpTopicPaymentIssue.
  ///
  /// In id, this message translates to:
  /// **'Masalah pembayaran'**
  String get helpTopicPaymentIssue;

  /// No description provided for @helpTopicPaymentIssueDesc.
  ///
  /// In id, this message translates to:
  /// **'Cek status transaksi terakhir'**
  String get helpTopicPaymentIssueDesc;

  /// No description provided for @helpCenterTitle.
  ///
  /// In id, this message translates to:
  /// **'Pusat Bantuan'**
  String get helpCenterTitle;

  /// No description provided for @helpCenterSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kontak petugas dan laporan'**
  String get helpCenterSubtitle;

  /// No description provided for @helpSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari bantuan, stasiun, atau tiket'**
  String get helpSearchHint;

  /// No description provided for @helpQuickActions.
  ///
  /// In id, this message translates to:
  /// **'Aksi cepat'**
  String get helpQuickActions;

  /// No description provided for @helpQuickActionsDesc.
  ///
  /// In id, this message translates to:
  /// **'Pilih bantuan yang paling sering dipakai'**
  String get helpQuickActionsDesc;

  /// No description provided for @helpChatStaff.
  ///
  /// In id, this message translates to:
  /// **'Chat petugas'**
  String get helpChatStaff;

  /// No description provided for @helpReportInfo.
  ///
  /// In id, this message translates to:
  /// **'Lapor info salah'**
  String get helpReportInfo;

  /// No description provided for @helpTopicsTitle.
  ///
  /// In id, this message translates to:
  /// **'Topik bantuan'**
  String get helpTopicsTitle;

  /// No description provided for @helpNoTopicsFound.
  ///
  /// In id, this message translates to:
  /// **'Topik bantuan tidak ditemukan.'**
  String get helpNoTopicsFound;

  /// No description provided for @helpCallKaiSnack.
  ///
  /// In id, this message translates to:
  /// **'Menghubungi KAI melalui 121.'**
  String get helpCallKaiSnack;

  /// No description provided for @helpCallKai.
  ///
  /// In id, this message translates to:
  /// **'Hubungi KAI: 121'**
  String get helpCallKai;

  /// No description provided for @chatLiveHelp.
  ///
  /// In id, this message translates to:
  /// **'Bantuan langsung'**
  String get chatLiveHelp;

  /// No description provided for @chatWithStaff.
  ///
  /// In id, this message translates to:
  /// **'Chat dengan petugas'**
  String get chatWithStaff;

  /// No description provided for @chatActiveTopic.
  ///
  /// In id, this message translates to:
  /// **'Topik aktif: {topic}'**
  String chatActiveTopic(String topic);

  /// No description provided for @chatContentTailored.
  ///
  /// In id, this message translates to:
  /// **'Konten chat disesuaikan dengan pilihan Anda.'**
  String get chatContentTailored;

  /// No description provided for @chatServiceStatus.
  ///
  /// In id, this message translates to:
  /// **'Status layanan'**
  String get chatServiceStatus;

  /// No description provided for @chatWaitEstimate.
  ///
  /// In id, this message translates to:
  /// **'Estimasi tunggu saat ini'**
  String get chatWaitEstimate;

  /// No description provided for @chatSelectTopic.
  ///
  /// In id, this message translates to:
  /// **'Pilih topik'**
  String get chatSelectTopic;

  /// No description provided for @chatInitialMessage.
  ///
  /// In id, this message translates to:
  /// **'Pesan awal'**
  String get chatInitialMessage;

  /// No description provided for @chatSharedData.
  ///
  /// In id, this message translates to:
  /// **'Data yang dikirim'**
  String get chatSharedData;

  /// No description provided for @chatReceivedData.
  ///
  /// In id, this message translates to:
  /// **'Data yang diterima:\n{data}'**
  String chatReceivedData(String data);

  /// No description provided for @issueLateEtaTitle.
  ///
  /// In id, this message translates to:
  /// **'ETA Terlambat'**
  String get issueLateEtaTitle;

  /// No description provided for @issueLateEtaLabel.
  ///
  /// In id, this message translates to:
  /// **'ETA terlambat'**
  String get issueLateEtaLabel;

  /// No description provided for @issueLateEtaActive.
  ///
  /// In id, this message translates to:
  /// **'ETA terlambat'**
  String get issueLateEtaActive;

  /// No description provided for @issueLateEtaRoute.
  ///
  /// In id, this message translates to:
  /// **'Bogor → Jakarta Kota'**
  String get issueLateEtaRoute;

  /// No description provided for @issueLateEtaRouteDetail.
  ///
  /// In id, this message translates to:
  /// **'ETA aplikasi: 09:32 WIB'**
  String get issueLateEtaRouteDetail;

  /// No description provided for @issueLateEtaNote.
  ///
  /// In id, this message translates to:
  /// **'Papan stasiun menunjukkan 09:40 WIB.'**
  String get issueLateEtaNote;

  /// No description provided for @issueLateEtaGuidance.
  ///
  /// In id, this message translates to:
  /// **'Koreksi membantu akurasi ETA rute ini.'**
  String get issueLateEtaGuidance;

  /// No description provided for @issueLateEtaAction.
  ///
  /// In id, this message translates to:
  /// **'Kirim koreksi ETA'**
  String get issueLateEtaAction;

  /// No description provided for @issueMissingTrainTitle.
  ///
  /// In id, this message translates to:
  /// **'Kereta Hilang'**
  String get issueMissingTrainTitle;

  /// No description provided for @issueMissingTrainLabel.
  ///
  /// In id, this message translates to:
  /// **'Kereta hilang'**
  String get issueMissingTrainLabel;

  /// No description provided for @issueMissingTrainActive.
  ///
  /// In id, this message translates to:
  /// **'Kereta tidak muncul'**
  String get issueMissingTrainActive;

  /// No description provided for @issueMissingTrainRoute.
  ///
  /// In id, this message translates to:
  /// **'Bekasi → Manggarai'**
  String get issueMissingTrainRoute;

  /// No description provided for @issueMissingTrainRouteDetail.
  ///
  /// In id, this message translates to:
  /// **'Kereta terdekat tidak tampil'**
  String get issueMissingTrainRouteDetail;

  /// No description provided for @issueMissingTrainNote.
  ///
  /// In id, this message translates to:
  /// **'Kereta terlihat di stasiun, tetapi tidak ada di aplikasi.'**
  String get issueMissingTrainNote;

  /// No description provided for @issueMissingTrainGuidance.
  ///
  /// In id, this message translates to:
  /// **'Laporan melengkapi data keberangkatan.'**
  String get issueMissingTrainGuidance;

  /// No description provided for @issueMissingTrainAction.
  ///
  /// In id, this message translates to:
  /// **'Laporkan kereta hilang'**
  String get issueMissingTrainAction;

  /// No description provided for @issueChangedScheduleTitle.
  ///
  /// In id, this message translates to:
  /// **'Jadwal Berubah'**
  String get issueChangedScheduleTitle;

  /// No description provided for @issueChangedScheduleLabel.
  ///
  /// In id, this message translates to:
  /// **'Jadwal berubah'**
  String get issueChangedScheduleLabel;

  /// No description provided for @issueChangedScheduleActive.
  ///
  /// In id, this message translates to:
  /// **'Jadwal berubah'**
  String get issueChangedScheduleActive;

  /// No description provided for @issueChangedScheduleRoute.
  ///
  /// In id, this message translates to:
  /// **'Dukuh Atas → Harjamukti'**
  String get issueChangedScheduleRoute;

  /// No description provided for @issueChangedScheduleRouteDetail.
  ///
  /// In id, this message translates to:
  /// **'Jadwal aplikasi: 15:18 WIB'**
  String get issueChangedScheduleRouteDetail;

  /// No description provided for @issueChangedScheduleNote.
  ///
  /// In id, this message translates to:
  /// **'Jadwal di stasiun berubah menjadi 15:30 WIB.'**
  String get issueChangedScheduleNote;

  /// No description provided for @issueChangedScheduleGuidance.
  ///
  /// In id, this message translates to:
  /// **'Laporan membantu sinkronisasi jadwal.'**
  String get issueChangedScheduleGuidance;

  /// No description provided for @issueChangedScheduleAction.
  ///
  /// In id, this message translates to:
  /// **'Kirim perubahan jadwal'**
  String get issueChangedScheduleAction;

  /// No description provided for @issueDiffPlatformTitle.
  ///
  /// In id, this message translates to:
  /// **'Peron Berbeda'**
  String get issueDiffPlatformTitle;

  /// No description provided for @issueDiffPlatformLabel.
  ///
  /// In id, this message translates to:
  /// **'Peron berbeda'**
  String get issueDiffPlatformLabel;

  /// No description provided for @issueDiffPlatformActive.
  ///
  /// In id, this message translates to:
  /// **'Peron berbeda'**
  String get issueDiffPlatformActive;

  /// No description provided for @issueDiffPlatformRoute.
  ///
  /// In id, this message translates to:
  /// **'Bogor → Jakarta Kota'**
  String get issueDiffPlatformRoute;

  /// No description provided for @issueDiffPlatformRouteDetail.
  ///
  /// In id, this message translates to:
  /// **'Peron aplikasi: Peron 2'**
  String get issueDiffPlatformRouteDetail;

  /// No description provided for @issueDiffPlatformNote.
  ///
  /// In id, this message translates to:
  /// **'Petugas mengarahkan penumpang ke Peron 4.'**
  String get issueDiffPlatformNote;

  /// No description provided for @issueDiffPlatformGuidance.
  ///
  /// In id, this message translates to:
  /// **'Laporan membantu memperbaiki info peron.'**
  String get issueDiffPlatformGuidance;

  /// No description provided for @issueDiffPlatformAction.
  ///
  /// In id, this message translates to:
  /// **'Kirim koreksi peron'**
  String get issueDiffPlatformAction;

  /// No description provided for @issueReportMismatch.
  ///
  /// In id, this message translates to:
  /// **'Laporkan ketidaksesuaian'**
  String get issueReportMismatch;

  /// No description provided for @issueScheduleAndEta.
  ///
  /// In id, this message translates to:
  /// **'Jadwal & ETA'**
  String get issueScheduleAndEta;

  /// No description provided for @issueActiveProblem.
  ///
  /// In id, this message translates to:
  /// **'Masalah aktif: {problem}'**
  String issueActiveProblem(String problem);

  /// No description provided for @issueDetailFollows.
  ///
  /// In id, this message translates to:
  /// **'Detail laporan mengikuti masalah yang dipilih.'**
  String get issueDetailFollows;

  /// No description provided for @issueMonitoredRoute.
  ///
  /// In id, this message translates to:
  /// **'Rute dipantau'**
  String get issueMonitoredRoute;

  /// No description provided for @issueProblemOccurred.
  ///
  /// In id, this message translates to:
  /// **'Masalah yang terjadi'**
  String get issueProblemOccurred;

  /// No description provided for @issueNotes.
  ///
  /// In id, this message translates to:
  /// **'Catatan'**
  String get issueNotes;

  /// No description provided for @issueCorrectionPrepared.
  ///
  /// In id, this message translates to:
  /// **'Koreksi {problem} berhasil disiapkan.'**
  String issueCorrectionPrepared(String problem);

  /// No description provided for @topicTicketLabel.
  ///
  /// In id, this message translates to:
  /// **'Tiket'**
  String get topicTicketLabel;

  /// No description provided for @topicTicketTitle.
  ///
  /// In id, this message translates to:
  /// **'Chat Tiket'**
  String get topicTicketTitle;

  /// No description provided for @topicTicketAgent.
  ///
  /// In id, this message translates to:
  /// **'Petugas tiket'**
  String get topicTicketAgent;

  /// No description provided for @topicTicketAvailability.
  ///
  /// In id, this message translates to:
  /// **'Petugas tiket tersedia'**
  String get topicTicketAvailability;

  /// No description provided for @topicTicketWait.
  ///
  /// In id, this message translates to:
  /// **'Biasanya membalas dalam 2 menit'**
  String get topicTicketWait;

  /// No description provided for @topicTicketOpening.
  ///
  /// In id, this message translates to:
  /// **'Saya butuh bantuan terkait tiket'**
  String get topicTicketOpening;

  /// No description provided for @topicTicketShared.
  ///
  /// In id, this message translates to:
  /// **'Mode tamu, ID tiket, dan rute terakhir'**
  String get topicTicketShared;

  /// No description provided for @topicTicketSampleData.
  ///
  /// In id, this message translates to:
  /// **'Kode tiket: TKT-20260827-001\nRute: Manggarai – Tanah Abang\nTanggal perjalanan: 27 Agustus 2026\nStatus: Aktif'**
  String get topicTicketSampleData;

  /// No description provided for @topicTicketAction.
  ///
  /// In id, this message translates to:
  /// **'Mulai chat tiket'**
  String get topicTicketAction;

  /// No description provided for @topicTicketGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, saya Rani dari layanan tiket. Data tiket dan rute terakhir Anda sudah saya terima. Apa kendala yang ingin diperiksa?'**
  String get topicTicketGreeting;

  /// No description provided for @topicScheduleLabel.
  ///
  /// In id, this message translates to:
  /// **'Jadwal'**
  String get topicScheduleLabel;

  /// No description provided for @topicScheduleTitle.
  ///
  /// In id, this message translates to:
  /// **'Chat Jadwal'**
  String get topicScheduleTitle;

  /// No description provided for @topicScheduleAgent.
  ///
  /// In id, this message translates to:
  /// **'Petugas jadwal'**
  String get topicScheduleAgent;

  /// No description provided for @topicScheduleAvailability.
  ///
  /// In id, this message translates to:
  /// **'Petugas jadwal tersedia'**
  String get topicScheduleAvailability;

  /// No description provided for @topicScheduleWait.
  ///
  /// In id, this message translates to:
  /// **'Biasanya membalas dalam 3 menit'**
  String get topicScheduleWait;

  /// No description provided for @topicScheduleOpening.
  ///
  /// In id, this message translates to:
  /// **'Saya butuh bantuan terkait jadwal atau ETA kereta'**
  String get topicScheduleOpening;

  /// No description provided for @topicScheduleShared.
  ///
  /// In id, this message translates to:
  /// **'Rute terakhir, stasiun asal-tujuan, dan waktu perjalanan'**
  String get topicScheduleShared;

  /// No description provided for @topicScheduleSampleData.
  ///
  /// In id, this message translates to:
  /// **'Stasiun asal: Manggarai\nTujuan: Jakarta Kota\nNomor kereta: KA 1184\nKeberangkatan: 10.25 WIB\nPeron: 3'**
  String get topicScheduleSampleData;

  /// No description provided for @topicScheduleAction.
  ///
  /// In id, this message translates to:
  /// **'Mulai chat jadwal'**
  String get topicScheduleAction;

  /// No description provided for @topicScheduleGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, saya Dimas dari layanan jadwal. Rute terakhir Anda sudah terlihat. Jadwal atau ETA mana yang ingin diperiksa?'**
  String get topicScheduleGreeting;

  /// No description provided for @topicPaymentLabel.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran'**
  String get topicPaymentLabel;

  /// No description provided for @topicPaymentTitle.
  ///
  /// In id, this message translates to:
  /// **'Chat Pembayaran'**
  String get topicPaymentTitle;

  /// No description provided for @topicPaymentAgent.
  ///
  /// In id, this message translates to:
  /// **'Petugas pembayaran'**
  String get topicPaymentAgent;

  /// No description provided for @topicPaymentAvailability.
  ///
  /// In id, this message translates to:
  /// **'Petugas pembayaran tersedia'**
  String get topicPaymentAvailability;

  /// No description provided for @topicPaymentWait.
  ///
  /// In id, this message translates to:
  /// **'Biasanya membalas dalam 4 menit'**
  String get topicPaymentWait;

  /// No description provided for @topicPaymentOpening.
  ///
  /// In id, this message translates to:
  /// **'Saya butuh bantuan terkait pembayaran tiket'**
  String get topicPaymentOpening;

  /// No description provided for @topicPaymentShared.
  ///
  /// In id, this message translates to:
  /// **'Status transaksi terakhir, kode tiket, dan waktu pembayaran'**
  String get topicPaymentShared;

  /// No description provided for @topicPaymentSampleData.
  ///
  /// In id, this message translates to:
  /// **'ID transaksi: TRX-20260827-001\nMetode: QRIS\nNominal: Rp7.800\nWaktu: 27 Agustus 2026, 10.20 WIB\nStatus: Berhasil'**
  String get topicPaymentSampleData;

  /// No description provided for @topicPaymentAction.
  ///
  /// In id, this message translates to:
  /// **'Mulai chat pembayaran'**
  String get topicPaymentAction;

  /// No description provided for @topicPaymentGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, saya Sari dari layanan pembayaran. Status transaksi terakhir Anda sudah saya terima. Apa kendala pembayarannya?'**
  String get topicPaymentGreeting;

  /// No description provided for @chatReplyTicketNotFound.
  ///
  /// In id, this message translates to:
  /// **'Baik, saya bantu periksa. Coba buka Tiket Saya dan muat ulang halaman. Jika tiket tetap belum muncul, kirimkan kode tiket Anda di sini.'**
  String get chatReplyTicketNotFound;

  /// No description provided for @chatReplyTicketBuy.
  ///
  /// In id, this message translates to:
  /// **'Untuk membeli tiket, pilih rute dari Beranda, tentukan perjalanan, lalu lanjutkan ke pembayaran. Tiket akan tampil di menu Tiket setelah pembayaran berhasil.'**
  String get chatReplyTicketBuy;

  /// No description provided for @chatReplyTicketActive.
  ///
  /// In id, this message translates to:
  /// **'Tiket aktif dapat dibuka dari menu Tiket. Pastikan kode QR terlihat jelas sebelum dipindai di gerbang.'**
  String get chatReplyTicketActive;

  /// No description provided for @chatReplyTicketDefault.
  ///
  /// In id, this message translates to:
  /// **'Saya siap membantu memeriksa tiket Anda. Jelaskan status tiket atau langkah yang mengalami kendala.'**
  String get chatReplyTicketDefault;

  /// No description provided for @chatReplyScheduleLate.
  ///
  /// In id, this message translates to:
  /// **'ETA dapat berubah mengikuti posisi kereta. Beri tahu rute dan stasiun Anda agar saya dapat membantu mencocokkan informasi terakhir.'**
  String get chatReplyScheduleLate;

  /// No description provided for @chatReplySchedulePlatform.
  ///
  /// In id, this message translates to:
  /// **'Informasi peron dapat berubah di stasiun. Ikuti pengumuman petugas dan kirim nama stasiun jika informasi aplikasi berbeda.'**
  String get chatReplySchedulePlatform;

  /// No description provided for @chatReplyScheduleMissing.
  ///
  /// In id, this message translates to:
  /// **'Saya bantu catat kereta yang tidak muncul. Kirim stasiun, tujuan, dan perkiraan waktu keberangkatannya.'**
  String get chatReplyScheduleMissing;

  /// No description provided for @chatReplyScheduleDefault.
  ///
  /// In id, this message translates to:
  /// **'Silakan kirim rute, stasiun, dan waktu perjalanan yang ingin diperiksa.'**
  String get chatReplyScheduleDefault;

  /// No description provided for @chatReplyPaymentDeducted.
  ///
  /// In id, this message translates to:
  /// **'Jika saldo terpotong tetapi tiket belum aktif, tunggu dua menit lalu periksa Riwayat Tiket. Kirim kode transaksi jika status belum berubah.'**
  String get chatReplyPaymentDeducted;

  /// No description provided for @chatReplyPaymentRefund.
  ///
  /// In id, this message translates to:
  /// **'Saya bantu memeriksa pengembalian dana. Kirim kode transaksi dan alasan pengajuan refund.'**
  String get chatReplyPaymentRefund;

  /// No description provided for @chatReplyPaymentFailed.
  ///
  /// In id, this message translates to:
  /// **'Coba ulangi dengan jaringan stabil atau gunakan metode pembayaran lain. Kirim pesan kegagalan yang tampil jika masalah berlanjut.'**
  String get chatReplyPaymentFailed;

  /// No description provided for @chatReplyPaymentDefault.
  ///
  /// In id, this message translates to:
  /// **'Jelaskan status transaksi atau metode pembayaran yang mengalami kendala agar saya dapat membantu.'**
  String get chatReplyPaymentDefault;

  /// No description provided for @payDeductedLabel.
  ///
  /// In id, this message translates to:
  /// **'Saldo terpotong'**
  String get payDeductedLabel;

  /// No description provided for @payDeductedTitle.
  ///
  /// In id, this message translates to:
  /// **'Saldo Terpotong'**
  String get payDeductedTitle;

  /// No description provided for @payDeductedStatus.
  ///
  /// In id, this message translates to:
  /// **'Diproses'**
  String get payDeductedStatus;

  /// No description provided for @payDeductedDetail.
  ///
  /// In id, this message translates to:
  /// **'Rp 8.000 terpotong, tiket belum aktif'**
  String get payDeductedDetail;

  /// No description provided for @payDeductedAdvice.
  ///
  /// In id, this message translates to:
  /// **'Cek Riwayat tiket setelah 2 menit.\nKirim bantuan jika status belum berubah.'**
  String get payDeductedAdvice;

  /// No description provided for @payDeductedAction.
  ///
  /// In id, this message translates to:
  /// **'Laporkan saldo terpotong'**
  String get payDeductedAction;

  /// No description provided for @payMissingLabel.
  ///
  /// In id, this message translates to:
  /// **'Tiket belum muncul'**
  String get payMissingLabel;

  /// No description provided for @payMissingTitle.
  ///
  /// In id, this message translates to:
  /// **'Tiket Belum Muncul'**
  String get payMissingTitle;

  /// No description provided for @payMissingStatus.
  ///
  /// In id, this message translates to:
  /// **'Berhasil'**
  String get payMissingStatus;

  /// No description provided for @payMissingDetail.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran berhasil, tiket belum tampil'**
  String get payMissingDetail;

  /// No description provided for @payMissingAdvice.
  ///
  /// In id, this message translates to:
  /// **'Muat ulang halaman Tiket Saya.\nJika tetap kosong, kirim kode transaksi.'**
  String get payMissingAdvice;

  /// No description provided for @payMissingAction.
  ///
  /// In id, this message translates to:
  /// **'Laporkan tiket belum muncul'**
  String get payMissingAction;

  /// No description provided for @payRefundLabel.
  ///
  /// In id, this message translates to:
  /// **'Refund'**
  String get payRefundLabel;

  /// No description provided for @payRefundTitle.
  ///
  /// In id, this message translates to:
  /// **'Refund'**
  String get payRefundTitle;

  /// No description provided for @payRefundStatus.
  ///
  /// In id, this message translates to:
  /// **'Diajukan'**
  String get payRefundStatus;

  /// No description provided for @payRefundDetail.
  ///
  /// In id, this message translates to:
  /// **'Pengembalian dana untuk tiket'**
  String get payRefundDetail;

  /// No description provided for @payRefundAdvice.
  ///
  /// In id, this message translates to:
  /// **'Refund mengikuti status transaksi terakhir.\nSimpan kode tiket sampai proses selesai.'**
  String get payRefundAdvice;

  /// No description provided for @payRefundAction.
  ///
  /// In id, this message translates to:
  /// **'Ajukan refund'**
  String get payRefundAction;

  /// No description provided for @payMethodLabel.
  ///
  /// In id, this message translates to:
  /// **'Metode bayar'**
  String get payMethodLabel;

  /// No description provided for @payMethodTitle.
  ///
  /// In id, this message translates to:
  /// **'Metode Bayar'**
  String get payMethodTitle;

  /// No description provided for @payMethodStatus.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get payMethodStatus;

  /// No description provided for @payMethodDetail.
  ///
  /// In id, this message translates to:
  /// **'Metode pembayaran tidak dapat digunakan'**
  String get payMethodDetail;

  /// No description provided for @payMethodAdvice.
  ///
  /// In id, this message translates to:
  /// **'Coba metode pembayaran lain.\nLaporkan jika semua metode gagal.'**
  String get payMethodAdvice;

  /// No description provided for @payMethodAction.
  ///
  /// In id, this message translates to:
  /// **'Laporkan metode bayar'**
  String get payMethodAction;

  /// No description provided for @payCheckStatusSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Cek status transaksi'**
  String get payCheckStatusSubtitle;

  /// No description provided for @payIssueTitle.
  ///
  /// In id, this message translates to:
  /// **'Masalah pembayaran'**
  String get payIssueTitle;

  /// No description provided for @payActiveIssue.
  ///
  /// In id, this message translates to:
  /// **'Kendala aktif: {issue}'**
  String payActiveIssue(String issue);

  /// No description provided for @payIssueDescription.
  ///
  /// In id, this message translates to:
  /// **'Saran dan tindakan mengikuti kendala yang dipilih.'**
  String get payIssueDescription;

  /// No description provided for @payLastTransaction.
  ///
  /// In id, this message translates to:
  /// **'Transaksi terakhir'**
  String get payLastTransaction;

  /// No description provided for @paySelectIssue.
  ///
  /// In id, this message translates to:
  /// **'Pilih kendala'**
  String get paySelectIssue;

  /// No description provided for @payQuickAdvice.
  ///
  /// In id, this message translates to:
  /// **'Saran cepat'**
  String get payQuickAdvice;

  /// No description provided for @payHelpPrepared.
  ///
  /// In id, this message translates to:
  /// **'Bantuan {issue} berhasil disiapkan.'**
  String payHelpPrepared(String issue);

  /// No description provided for @reportScheduleLabel.
  ///
  /// In id, this message translates to:
  /// **'Jadwal'**
  String get reportScheduleLabel;

  /// No description provided for @reportScheduleTitle.
  ///
  /// In id, this message translates to:
  /// **'Lapor Jadwal'**
  String get reportScheduleTitle;

  /// No description provided for @reportScheduleFirstLabel.
  ///
  /// In id, this message translates to:
  /// **'Rute terkait'**
  String get reportScheduleFirstLabel;

  /// No description provided for @reportScheduleFirstValue.
  ///
  /// In id, this message translates to:
  /// **'Bogor → Jakarta Kota'**
  String get reportScheduleFirstValue;

  /// No description provided for @reportScheduleSecondLabel.
  ///
  /// In id, this message translates to:
  /// **'Lokasi / stasiun'**
  String get reportScheduleSecondLabel;

  /// No description provided for @reportScheduleSecondValue.
  ///
  /// In id, this message translates to:
  /// **'Bogor'**
  String get reportScheduleSecondValue;

  /// No description provided for @reportScheduleDesc.
  ///
  /// In id, this message translates to:
  /// **'ETA di aplikasi berbeda dengan papan informasi stasiun.'**
  String get reportScheduleDesc;

  /// No description provided for @reportScheduleAction.
  ///
  /// In id, this message translates to:
  /// **'Kirim laporan jadwal'**
  String get reportScheduleAction;

  /// No description provided for @reportRouteLabel.
  ///
  /// In id, this message translates to:
  /// **'Rute'**
  String get reportRouteLabel;

  /// No description provided for @reportRouteTitle.
  ///
  /// In id, this message translates to:
  /// **'Lapor Rute'**
  String get reportRouteTitle;

  /// No description provided for @reportRouteFirstLabel.
  ///
  /// In id, this message translates to:
  /// **'Rute bermasalah'**
  String get reportRouteFirstLabel;

  /// No description provided for @reportRouteFirstValue.
  ///
  /// In id, this message translates to:
  /// **'Dukuh Atas → Harjamukti'**
  String get reportRouteFirstValue;

  /// No description provided for @reportRouteSecondLabel.
  ///
  /// In id, this message translates to:
  /// **'Titik rute'**
  String get reportRouteSecondLabel;

  /// No description provided for @reportRouteSecondValue.
  ///
  /// In id, this message translates to:
  /// **'Stasiun transit'**
  String get reportRouteSecondValue;

  /// No description provided for @reportRouteDesc.
  ///
  /// In id, this message translates to:
  /// **'Rute yang tampil tidak melewati stasiun transit yang benar.'**
  String get reportRouteDesc;

  /// No description provided for @reportRouteAction.
  ///
  /// In id, this message translates to:
  /// **'Kirim laporan rute'**
  String get reportRouteAction;

  /// No description provided for @reportStationLabel.
  ///
  /// In id, this message translates to:
  /// **'Stasiun'**
  String get reportStationLabel;

  /// No description provided for @reportStationTitle.
  ///
  /// In id, this message translates to:
  /// **'Lapor Stasiun'**
  String get reportStationTitle;

  /// No description provided for @reportStationFirstLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama stasiun'**
  String get reportStationFirstLabel;

  /// No description provided for @reportStationFirstValue.
  ///
  /// In id, this message translates to:
  /// **'Jakarta Kota'**
  String get reportStationFirstValue;

  /// No description provided for @reportStationSecondLabel.
  ///
  /// In id, this message translates to:
  /// **'Info yang salah'**
  String get reportStationSecondLabel;

  /// No description provided for @reportStationSecondValue.
  ///
  /// In id, this message translates to:
  /// **'Peron / fasilitas'**
  String get reportStationSecondValue;

  /// No description provided for @reportStationDesc.
  ///
  /// In id, this message translates to:
  /// **'Informasi stasiun tidak sesuai dengan kondisi di lokasi.'**
  String get reportStationDesc;

  /// No description provided for @reportStationAction.
  ///
  /// In id, this message translates to:
  /// **'Kirim laporan stasiun'**
  String get reportStationAction;

  /// No description provided for @reportSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Koreksi data perjalanan'**
  String get reportSubtitle;

  /// No description provided for @reportWrongInfo.
  ///
  /// In id, this message translates to:
  /// **'Lapor info salah'**
  String get reportWrongInfo;

  /// No description provided for @reportTypePrefix.
  ///
  /// In id, this message translates to:
  /// **'Jenis laporan: {type}'**
  String reportTypePrefix(String type);

  /// No description provided for @reportFieldsDesc.
  ///
  /// In id, this message translates to:
  /// **'Isian mengikuti jenis laporan yang dipilih.'**
  String get reportFieldsDesc;

  /// No description provided for @reportTypeHeading.
  ///
  /// In id, this message translates to:
  /// **'Jenis laporan'**
  String get reportTypeHeading;

  /// No description provided for @reportDescLabel.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi laporan'**
  String get reportDescLabel;

  /// No description provided for @reportAttachScreenshot.
  ///
  /// In id, this message translates to:
  /// **'Lampirkan screenshot'**
  String get reportAttachScreenshot;

  /// No description provided for @reportAttachScreenshotMsg.
  ///
  /// In id, this message translates to:
  /// **'Pilih screenshot dari perangkat untuk dilampirkan.'**
  String get reportAttachScreenshotMsg;

  /// No description provided for @reportPrepared.
  ///
  /// In id, this message translates to:
  /// **'Laporan {type} berhasil disiapkan.'**
  String reportPrepared(String type);

  /// No description provided for @chatOnline.
  ///
  /// In id, this message translates to:
  /// **'Online'**
  String get chatOnline;

  /// No description provided for @chatLocalReply.
  ///
  /// In id, this message translates to:
  /// **'Balasan lokal'**
  String get chatLocalReply;

  /// No description provided for @chatToday.
  ///
  /// In id, this message translates to:
  /// **'Hari ini'**
  String get chatToday;

  /// No description provided for @chatUser.
  ///
  /// In id, this message translates to:
  /// **'Anda'**
  String get chatUser;

  /// No description provided for @chatAgent.
  ///
  /// In id, this message translates to:
  /// **'Petugas'**
  String get chatAgent;

  /// No description provided for @chatAgentTyping.
  ///
  /// In id, this message translates to:
  /// **'Petugas sedang mengetik…'**
  String get chatAgentTyping;

  /// No description provided for @chatWriteMessage.
  ///
  /// In id, this message translates to:
  /// **'Tulis pesan…'**
  String get chatWriteMessage;

  /// No description provided for @chatWaitReply.
  ///
  /// In id, this message translates to:
  /// **'Menunggu balasan petugas…'**
  String get chatWaitReply;

  /// No description provided for @chatSendMessage.
  ///
  /// In id, this message translates to:
  /// **'Kirim pesan'**
  String get chatSendMessage;

  /// No description provided for @activeTicketReadyShare.
  ///
  /// In id, this message translates to:
  /// **'Kode tiket aktif siap dibagikan.'**
  String get activeTicketReadyShare;

  /// No description provided for @activeTicketTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail tiket aktif'**
  String get activeTicketTitle;

  /// No description provided for @activeTicketShareCode.
  ///
  /// In id, this message translates to:
  /// **'Bagikan kode'**
  String get activeTicketShareCode;

  /// No description provided for @activeTicketNeedHelp.
  ///
  /// In id, this message translates to:
  /// **'Butuh bantuan'**
  String get activeTicketNeedHelp;

  /// No description provided for @activeTicketOfflineOnly.
  ///
  /// In id, this message translates to:
  /// **'Data tiket hanya tersimpan di perangkat ini.'**
  String get activeTicketOfflineOnly;

  /// No description provided for @activeTicketStatus.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get activeTicketStatus;

  /// No description provided for @activeTicketCodeTitle.
  ///
  /// In id, this message translates to:
  /// **'Kode tiket aktif'**
  String get activeTicketCodeTitle;

  /// No description provided for @activeTicketShowToStaff.
  ///
  /// In id, this message translates to:
  /// **'Tunjukkan kode ini kepada petugas'**
  String get activeTicketShowToStaff;

  /// No description provided for @activeTicketCodeSemantic.
  ///
  /// In id, this message translates to:
  /// **'Kode tiket aktif {code}'**
  String activeTicketCodeSemantic(String code);

  /// No description provided for @activeTicketSavedOffline.
  ///
  /// In id, this message translates to:
  /// **'Tersimpan offline'**
  String get activeTicketSavedOffline;

  /// No description provided for @ticketStationOrigin.
  ///
  /// In id, this message translates to:
  /// **'Stasiun asal'**
  String get ticketStationOrigin;

  /// No description provided for @ticketStationDest.
  ///
  /// In id, this message translates to:
  /// **'Tujuan'**
  String get ticketStationDest;

  /// No description provided for @ticketStationDestFull.
  ///
  /// In id, this message translates to:
  /// **'Stasiun tujuan'**
  String get ticketStationDestFull;

  /// No description provided for @ticketEta.
  ///
  /// In id, this message translates to:
  /// **'Perkiraan tiba'**
  String get ticketEta;

  /// No description provided for @ticketType.
  ///
  /// In id, this message translates to:
  /// **'Jenis tiket'**
  String get ticketType;

  /// No description provided for @ticketTypeActive.
  ///
  /// In id, this message translates to:
  /// **'Tiket aktif'**
  String get ticketTypeActive;

  /// No description provided for @completedTicketReceiptReady.
  ///
  /// In id, this message translates to:
  /// **'Bukti perjalanan berhasil disiapkan.'**
  String get completedTicketReceiptReady;

  /// No description provided for @completedTicketTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail tiket selesai'**
  String get completedTicketTitle;

  /// No description provided for @completedTicketDownload.
  ///
  /// In id, this message translates to:
  /// **'Unduh bukti'**
  String get completedTicketDownload;

  /// No description provided for @completedTicketReport.
  ///
  /// In id, this message translates to:
  /// **'Laporkan masalah'**
  String get completedTicketReport;

  /// No description provided for @completedTicketLocalHistory.
  ///
  /// In id, this message translates to:
  /// **'Detail selesai tetap tersimpan di riwayat lokal.'**
  String get completedTicketLocalHistory;

  /// No description provided for @completedTicketStatus.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get completedTicketStatus;

  /// No description provided for @completedTicketSummary.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan perjalanan'**
  String get completedTicketSummary;

  /// No description provided for @completedTicketDepart.
  ///
  /// In id, this message translates to:
  /// **'Berangkat'**
  String get completedTicketDepart;

  /// No description provided for @completedTicketArrive.
  ///
  /// In id, this message translates to:
  /// **'Tiba'**
  String get completedTicketArrive;

  /// No description provided for @completedTicketDuration.
  ///
  /// In id, this message translates to:
  /// **'Durasi {minutes} menit'**
  String completedTicketDuration(String minutes);

  /// No description provided for @completedTicketJourneyDone.
  ///
  /// In id, this message translates to:
  /// **'Perjalanan selesai'**
  String get completedTicketJourneyDone;

  /// No description provided for @completedTicketCode.
  ///
  /// In id, this message translates to:
  /// **'Kode perjalanan'**
  String get completedTicketCode;

  /// No description provided for @completedTicketTypeLocal.
  ///
  /// In id, this message translates to:
  /// **'Tiket lokal'**
  String get completedTicketTypeLocal;

  /// No description provided for @actionBack.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get actionBack;

  /// No description provided for @departureDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Keberangkatan'**
  String get departureDetailTitle;

  /// No description provided for @departureFinalDestination.
  ///
  /// In id, this message translates to:
  /// **'Tujuan Akhir'**
  String get departureFinalDestination;

  /// No description provided for @departureArrivingIn.
  ///
  /// In id, this message translates to:
  /// **'Tiba Dalam'**
  String get departureArrivingIn;

  /// No description provided for @departurePlatformNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor Peron'**
  String get departurePlatformNumber;

  /// No description provided for @departurePlatform.
  ///
  /// In id, this message translates to:
  /// **'Peron {platform}'**
  String departurePlatform(String platform);

  /// No description provided for @departureStatusNormal.
  ///
  /// In id, this message translates to:
  /// **'Kereta beroperasi normal. Fasilitas prioritas tersedia di gerbong 3 dan 4.'**
  String get departureStatusNormal;

  /// No description provided for @departureNextStations.
  ///
  /// In id, this message translates to:
  /// **'Stasiun Berikutnya'**
  String get departureNextStations;

  /// No description provided for @departureArriveAt.
  ///
  /// In id, this message translates to:
  /// **'Tiba di {platform}'**
  String departureArriveAt(String platform);

  /// No description provided for @departurePromoBadge.
  ///
  /// In id, this message translates to:
  /// **'PROMO'**
  String get departurePromoBadge;

  /// No description provided for @departurePromoTitle.
  ///
  /// In id, this message translates to:
  /// **'Diskon 50% Tiket Kereta Antarkota'**
  String get departurePromoTitle;

  /// No description provided for @departurePromoDesc.
  ///
  /// In id, this message translates to:
  /// **'Beli tiket mudik sekarang dan dapatkan potongan harga spesial menggunakan KAI Pay.'**
  String get departurePromoDesc;

  /// No description provided for @durationMinutes.
  ///
  /// In id, this message translates to:
  /// **'{minutes} Menit'**
  String durationMinutes(String minutes);

  /// No description provided for @stationTransit.
  ///
  /// In id, this message translates to:
  /// **'{station} (Transit)'**
  String stationTransit(String station);

  /// No description provided for @mapSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari stasiun atau favorit'**
  String get mapSearchHint;

  /// No description provided for @mapSubtitleLrtKrl.
  ///
  /// In id, this message translates to:
  /// **'LRT Jabodebek · KRL akses integrasi'**
  String get mapSubtitleLrtKrl;

  /// No description provided for @mapSubtitleKrlTransit.
  ///
  /// In id, this message translates to:
  /// **'KRL · Transit utama'**
  String get mapSubtitleKrlTransit;

  /// No description provided for @mapSubtitleKrl.
  ///
  /// In id, this message translates to:
  /// **'KRL Jabodetabek'**
  String get mapSubtitleKrl;

  /// No description provided for @mapSubtitleLrt.
  ///
  /// In id, this message translates to:
  /// **'LRT Jabodebek'**
  String get mapSubtitleLrt;

  /// No description provided for @mapActionFrom.
  ///
  /// In id, this message translates to:
  /// **'Dari'**
  String get mapActionFrom;

  /// No description provided for @mapActionVia.
  ///
  /// In id, this message translates to:
  /// **'Lewat'**
  String get mapActionVia;

  /// No description provided for @mapActionTo.
  ///
  /// In id, this message translates to:
  /// **'Ke'**
  String get mapActionTo;

  /// No description provided for @mapActionInfo.
  ///
  /// In id, this message translates to:
  /// **'Info'**
  String get mapActionInfo;

  /// No description provided for @mapLegendTitle.
  ///
  /// In id, this message translates to:
  /// **'Legenda Rute Utama'**
  String get mapLegendTitle;

  /// No description provided for @mapLegendBogor.
  ///
  /// In id, this message translates to:
  /// **'KRL Bogor'**
  String get mapLegendBogor;

  /// No description provided for @mapLegendCikarang.
  ///
  /// In id, this message translates to:
  /// **'KRL Cikarang Loop'**
  String get mapLegendCikarang;

  /// No description provided for @mapLegendRangkasbitung.
  ///
  /// In id, this message translates to:
  /// **'KRL Rangkasbitung'**
  String get mapLegendRangkasbitung;

  /// No description provided for @mapLegendTangerang.
  ///
  /// In id, this message translates to:
  /// **'KRL Tangerang'**
  String get mapLegendTangerang;

  /// No description provided for @mapLegendTanjungPriok.
  ///
  /// In id, this message translates to:
  /// **'KRL Tanjung Priok'**
  String get mapLegendTanjungPriok;

  /// No description provided for @mapLegendMrt.
  ///
  /// In id, this message translates to:
  /// **'MRT Utara Selatan'**
  String get mapLegendMrt;

  /// No description provided for @mapLegendLrtBekasi.
  ///
  /// In id, this message translates to:
  /// **'LRT Lin Bekasi'**
  String get mapLegendLrtBekasi;

  /// No description provided for @mapLegendLrtCibubur.
  ///
  /// In id, this message translates to:
  /// **'LRT Lin Cibubur'**
  String get mapLegendLrtCibubur;

  /// No description provided for @mapLegendLrtJakarta.
  ///
  /// In id, this message translates to:
  /// **'LRT Jakarta Selatan'**
  String get mapLegendLrtJakarta;

  /// No description provided for @trainTypesJakarta.
  ///
  /// In id, this message translates to:
  /// **'KRL · LRT · MRT Jakarta'**
  String get trainTypesJakarta;

  /// No description provided for @departFromStation.
  ///
  /// In id, this message translates to:
  /// **'Berangkat dari {station}'**
  String departFromStation(String station);

  /// No description provided for @estimatedArrival.
  ///
  /// In id, this message translates to:
  /// **'Estimasi Tiba'**
  String get estimatedArrival;

  /// No description provided for @alarmActiveSemantics.
  ///
  /// In id, this message translates to:
  /// **'Alarm perjalanan aktif, ketuk untuk menonaktifkan'**
  String get alarmActiveSemantics;

  /// No description provided for @alarmInactiveSemantics.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan alarm perjalanan'**
  String get alarmInactiveSemantics;

  /// No description provided for @alarmActiveTooltip.
  ///
  /// In id, this message translates to:
  /// **'Alarm aktif'**
  String get alarmActiveTooltip;

  /// No description provided for @alarmInactiveTooltip.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan alarm'**
  String get alarmInactiveTooltip;

  /// No description provided for @alarmDisableBoth.
  ///
  /// In id, this message translates to:
  /// **'Pengingat kereta datang dan pengingat turun atau transit akan dinonaktifkan.'**
  String get alarmDisableBoth;

  /// No description provided for @alarmDisableDeparture.
  ///
  /// In id, this message translates to:
  /// **'Pengingat kereta datang akan dinonaktifkan.'**
  String get alarmDisableDeparture;

  /// No description provided for @alarmDisableDestination.
  ///
  /// In id, this message translates to:
  /// **'Pengingat turun atau transit akan dinonaktifkan.'**
  String get alarmDisableDestination;

  /// No description provided for @alarmDisableNone.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada pengingat perjalanan yang aktif.'**
  String get alarmDisableNone;

  /// No description provided for @alarmDisableTitle.
  ///
  /// In id, this message translates to:
  /// **'Matikan alarm perjalanan?'**
  String get alarmDisableTitle;

  /// No description provided for @alarmDisableAction.
  ///
  /// In id, this message translates to:
  /// **'Matikan alarm'**
  String get alarmDisableAction;

  /// No description provided for @alarmSetupTitle.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan pengingat perjalanan?'**
  String get alarmSetupTitle;

  /// No description provided for @routeFromTo.
  ///
  /// In id, this message translates to:
  /// **'{from} ke {to}'**
  String routeFromTo(String from, String to);

  /// No description provided for @alarmDepartureSemantics.
  ///
  /// In id, this message translates to:
  /// **'Pengingat kereta datang'**
  String get alarmDepartureSemantics;

  /// No description provided for @alarmDepartureTitle.
  ///
  /// In id, this message translates to:
  /// **'Kereta datang'**
  String get alarmDepartureTitle;

  /// No description provided for @alarmDepartureDesc.
  ///
  /// In id, this message translates to:
  /// **'Ingatkan 5 menit dan 1 menit sebelumnya'**
  String get alarmDepartureDesc;

  /// No description provided for @alarmDestinationSemantics.
  ///
  /// In id, this message translates to:
  /// **'Pengingat turun atau transit'**
  String get alarmDestinationSemantics;

  /// No description provided for @alarmDestinationTitle.
  ///
  /// In id, this message translates to:
  /// **'Turun atau transit'**
  String get alarmDestinationTitle;

  /// No description provided for @alarmDestinationDesc.
  ///
  /// In id, this message translates to:
  /// **'Ingatkan 1 stasiun sebelum tujuan'**
  String get alarmDestinationDesc;

  /// No description provided for @alarmSimulationNote.
  ///
  /// In id, this message translates to:
  /// **'Pengingat ini merupakan simulasi dan aktif selama aplikasi dibuka.'**
  String get alarmSimulationNote;

  /// No description provided for @alarmActivateBtn.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan alarm'**
  String get alarmActivateBtn;

  /// No description provided for @actionSkip.
  ///
  /// In id, this message translates to:
  /// **'Lewati'**
  String get actionSkip;

  /// No description provided for @stateActive.
  ///
  /// In id, this message translates to:
  /// **'aktif'**
  String get stateActive;

  /// No description provided for @stateInactive.
  ///
  /// In id, this message translates to:
  /// **'nonaktif'**
  String get stateInactive;

  /// No description provided for @alarmDepartureActive.
  ///
  /// In id, this message translates to:
  /// **'Kereta datang aktif'**
  String get alarmDepartureActive;

  /// No description provided for @alarmDepartureInactive.
  ///
  /// In id, this message translates to:
  /// **'Kereta datang nonaktif'**
  String get alarmDepartureInactive;

  /// No description provided for @alarmDestinationActive.
  ///
  /// In id, this message translates to:
  /// **'Turun atau transit aktif'**
  String get alarmDestinationActive;

  /// No description provided for @alarmDestinationInactive.
  ///
  /// In id, this message translates to:
  /// **'Turun atau transit nonaktif'**
  String get alarmDestinationInactive;

  /// No description provided for @viewTicketBtn.
  ///
  /// In id, this message translates to:
  /// **'Lihat tiket'**
  String get viewTicketBtn;

  /// No description provided for @cancelAlarmBtn.
  ///
  /// In id, this message translates to:
  /// **'Batalkan alarm'**
  String get cancelAlarmBtn;

  /// No description provided for @assistantChatAssistant.
  ///
  /// In id, this message translates to:
  /// **'Asisten'**
  String get assistantChatAssistant;

  /// No description provided for @assistantTypeMessage.
  ///
  /// In id, this message translates to:
  /// **'Ketik pesan untuk Asisten'**
  String get assistantTypeMessage;

  /// No description provided for @assistantSendMessage.
  ///
  /// In id, this message translates to:
  /// **'Kirim pesan'**
  String get assistantSendMessage;

  /// No description provided for @assistantUseThisRoute.
  ///
  /// In id, this message translates to:
  /// **'Pakai rute ini'**
  String get assistantUseThisRoute;

  /// No description provided for @assistantRepeat.
  ///
  /// In id, this message translates to:
  /// **'Ulangi'**
  String get assistantRepeat;

  /// No description provided for @assistantCancel.
  ///
  /// In id, this message translates to:
  /// **'Batalkan'**
  String get assistantCancel;

  /// No description provided for @assistantBuyTicketToUseAlarm.
  ///
  /// In id, this message translates to:
  /// **'Beli atau pilih tiket aktif untuk menggunakan alarm perjalanan.'**
  String get assistantBuyTicketToUseAlarm;

  /// No description provided for @assistantSearchTrip.
  ///
  /// In id, this message translates to:
  /// **'Cari perjalanan'**
  String get assistantSearchTrip;

  /// No description provided for @assistantOpenQuickAction.
  ///
  /// In id, this message translates to:
  /// **'Buka {action}'**
  String assistantOpenQuickAction(String action);

  /// No description provided for @assistantRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get assistantRetry;

  /// No description provided for @assistantUnknownDestination.
  ///
  /// In id, this message translates to:
  /// **'Saya belum memahami tujuanmu.'**
  String get assistantUnknownDestination;

  /// No description provided for @assistantDemoTranscript.
  ///
  /// In id, this message translates to:
  /// **'Saya ingin ke {destination} dari {origin}.'**
  String assistantDemoTranscript(String destination, String origin);

  /// No description provided for @assistantDemoResponse.
  ///
  /// In id, this message translates to:
  /// **'Rute tercepat membutuhkan 7 menit. Kereta tiba 5 menit lagi.'**
  String get assistantDemoResponse;

  /// No description provided for @assistantUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Asisten sedang tidak tersedia. Coba lagi atau cek informasi resmi stasiun.'**
  String get assistantUnavailable;

  /// No description provided for @assistantUnknownCommand.
  ///
  /// In id, this message translates to:
  /// **'Saya belum memahami perintah itu. Coba: “Alarm berikutnya kapan?” atau “Aktifkan semua alarm tiket saya”.'**
  String get assistantUnknownCommand;

  /// No description provided for @assistantNoActiveTicket.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tiket aktif'**
  String get assistantNoActiveTicket;

  /// No description provided for @assistantNoActiveAlarm.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada alarm aktif.'**
  String get assistantNoActiveAlarm;

  /// No description provided for @assistantAllAlarmsCancelled.
  ///
  /// In id, this message translates to:
  /// **'Semua alarm perjalanan dibatalkan.'**
  String get assistantAllAlarmsCancelled;

  /// No description provided for @assistantDestinationAlarmAlreadyOff.
  ///
  /// In id, this message translates to:
  /// **'Alarm tujuan sudah nonaktif.'**
  String get assistantDestinationAlarmAlreadyOff;

  /// No description provided for @assistantDestinationAlarmDisabled.
  ///
  /// In id, this message translates to:
  /// **'Alarm tujuan dinonaktifkan.'**
  String get assistantDestinationAlarmDisabled;

  /// No description provided for @assistantAllAlarmsActive.
  ///
  /// In id, this message translates to:
  /// **'Semua alarm perjalanan aktif.'**
  String get assistantAllAlarmsActive;

  /// No description provided for @travelAlarmTrainArrivesIn.
  ///
  /// In id, this message translates to:
  /// **'Kereta datang {minutes} menit lagi'**
  String travelAlarmTrainArrivesIn(int minutes);

  /// No description provided for @travelAlarmNoActive.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada alarm aktif'**
  String get travelAlarmNoActive;

  /// No description provided for @travelAlarmExitAt.
  ///
  /// In id, this message translates to:
  /// **'Turun di {destination}, {stations} stasiun lagi'**
  String travelAlarmExitAt(String destination, int stations);

  /// No description provided for @travelAlarmTransferAt.
  ///
  /// In id, this message translates to:
  /// **'Transit di {station}, {stations} stasiun lagi'**
  String travelAlarmTransferAt(String station, int stations);

  /// No description provided for @travelAlarmDestinationFallback.
  ///
  /// In id, this message translates to:
  /// **'tujuan'**
  String get travelAlarmDestinationFallback;

  /// No description provided for @assistantCameraGuideAction.
  ///
  /// In id, this message translates to:
  /// **'Pemandu Kamera'**
  String get assistantCameraGuideAction;

  /// No description provided for @assistantMessageSemantics.
  ///
  /// In id, this message translates to:
  /// **'{sender}, {message}'**
  String assistantMessageSemantics(String sender, String message);

  /// No description provided for @voiceTapToSpeak.
  ///
  /// In id, this message translates to:
  /// **'Ketuk untuk bicara'**
  String get voiceTapToSpeak;

  /// No description provided for @voiceWhereToToday.
  ///
  /// In id, this message translates to:
  /// **'Mau ke mana hari ini?'**
  String get voiceWhereToToday;

  /// No description provided for @voiceStartConversation.
  ///
  /// In id, this message translates to:
  /// **'Mulai percakapan suara'**
  String get voiceStartConversation;

  /// No description provided for @voiceListening.
  ///
  /// In id, this message translates to:
  /// **'Mendengarkan'**
  String get voiceListening;

  /// No description provided for @voicePleaseStateDestination.
  ///
  /// In id, this message translates to:
  /// **'Silakan sebutkan tujuan perjalanan'**
  String get voicePleaseStateDestination;

  /// No description provided for @voiceStopConversation.
  ///
  /// In id, this message translates to:
  /// **'Hentikan percakapan suara'**
  String get voiceStopConversation;

  /// No description provided for @voiceProcessingRequest.
  ///
  /// In id, this message translates to:
  /// **'Memproses permintaan'**
  String get voiceProcessingRequest;

  /// No description provided for @voiceSearchingForTrips.
  ///
  /// In id, this message translates to:
  /// **'Mencari pilihan perjalanan yang sesuai'**
  String get voiceSearchingForTrips;

  /// No description provided for @voiceRequestBeingProcessed.
  ///
  /// In id, this message translates to:
  /// **'Permintaan sedang diproses'**
  String get voiceRequestBeingProcessed;

  /// No description provided for @voiceAgentSpeaking.
  ///
  /// In id, this message translates to:
  /// **'Agent sedang berbicara'**
  String get voiceAgentSpeaking;

  /// No description provided for @voiceReadingAnswer.
  ///
  /// In id, this message translates to:
  /// **'Jawaban perjalanan sedang dibacakan'**
  String get voiceReadingAnswer;

  /// No description provided for @voiceStopAssistant.
  ///
  /// In id, this message translates to:
  /// **'Hentikan suara asisten'**
  String get voiceStopAssistant;

  /// No description provided for @voiceNeedsConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Perlu konfirmasi'**
  String get voiceNeedsConfirmation;

  /// No description provided for @voiceChooseActionBeforeRoute.
  ///
  /// In id, this message translates to:
  /// **'Pilih tindakan sebelum membuka rute'**
  String get voiceChooseActionBeforeRoute;

  /// No description provided for @voiceStartNewConversation.
  ///
  /// In id, this message translates to:
  /// **'Mulai percakapan baru'**
  String get voiceStartNewConversation;

  /// No description provided for @voiceUseVoiceOrQuickAction.
  ///
  /// In id, this message translates to:
  /// **'Gunakan suara atau pilih aksi cepat.'**
  String get voiceUseVoiceOrQuickAction;

  /// No description provided for @voiceRetryConversation.
  ///
  /// In id, this message translates to:
  /// **'Coba percakapan suara lagi'**
  String get voiceRetryConversation;

  /// No description provided for @homeNextTrainFrom.
  ///
  /// In id, this message translates to:
  /// **'Kereta berikutnya dari {station}'**
  String homeNextTrainFrom(String station);

  /// No description provided for @homeClose.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get homeClose;

  /// No description provided for @homeShowAll.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan Semua ({count})'**
  String homeShowAll(int count);

  /// No description provided for @homeTravelDuration.
  ///
  /// In id, this message translates to:
  /// **'Perjalanan {duration}'**
  String homeTravelDuration(String duration);

  /// No description provided for @homePlatform.
  ///
  /// In id, this message translates to:
  /// **'Peron {platform}'**
  String homePlatform(String platform);

  /// No description provided for @homeDestination.
  ///
  /// In id, this message translates to:
  /// **'Tujuan {destination}'**
  String homeDestination(String destination);

  /// No description provided for @homeArrivingIn.
  ///
  /// In id, this message translates to:
  /// **'Datang {duration} lagi'**
  String homeArrivingIn(String duration);

  /// No description provided for @homeAtStation.
  ///
  /// In id, this message translates to:
  /// **'di stasiun'**
  String get homeAtStation;

  /// No description provided for @homeStationFacilities.
  ///
  /// In id, this message translates to:
  /// **'Fasilitas Stasiun {station}'**
  String homeStationFacilities(String station);

  /// No description provided for @homeStationInformation.
  ///
  /// In id, this message translates to:
  /// **'Informasi Stasiun {station}'**
  String homeStationInformation(String station);

  /// No description provided for @homeConstructionType.
  ///
  /// In id, this message translates to:
  /// **'Tipe Konstruksi'**
  String get homeConstructionType;

  /// No description provided for @homeConstructionTypeDesc.
  ///
  /// In id, this message translates to:
  /// **'Stasiun Layang (Elevated) · Ramah Aksesibilitas'**
  String get homeConstructionTypeDesc;

  /// No description provided for @homeOperationalHours.
  ///
  /// In id, this message translates to:
  /// **'Jam Operasional'**
  String get homeOperationalHours;

  /// No description provided for @homeOperationalHoursDesc.
  ///
  /// In id, this message translates to:
  /// **'05:00 - 23:30 WIB (Buka Setiap Hari)'**
  String get homeOperationalHoursDesc;

  /// No description provided for @homeTicketServices.
  ///
  /// In id, this message translates to:
  /// **'Layanan Tiket'**
  String get homeTicketServices;

  /// No description provided for @homeTicketServicesDesc.
  ///
  /// In id, this message translates to:
  /// **'Kartu E-Money, KMT, QRIS, & Vending Machine'**
  String get homeTicketServicesDesc;

  /// No description provided for @homeAccessibilityFeatures.
  ///
  /// In id, this message translates to:
  /// **'Fitur Aksesibilitas'**
  String get homeAccessibilityFeatures;

  /// No description provided for @homeAccessibilityFeaturesDesc.
  ///
  /// In id, this message translates to:
  /// **'Guiding Block, Ramp Khusus, & Pengumuman Audio TTS'**
  String get homeAccessibilityFeaturesDesc;

  /// No description provided for @homeExitGateGuide.
  ///
  /// In id, this message translates to:
  /// **'Panduan Pintu Keluar (Exit Gate)'**
  String get homeExitGateGuide;

  /// No description provided for @homeExitNorth.
  ///
  /// In id, this message translates to:
  /// **'Pintu A (Utara)'**
  String get homeExitNorth;

  /// No description provided for @homeExitNorthDesc.
  ///
  /// In id, this message translates to:
  /// **'Akses Utama Jalan Utama / Kebon Sirih'**
  String get homeExitNorthDesc;

  /// No description provided for @homeExitNorthIntegration.
  ///
  /// In id, this message translates to:
  /// **'Integrasi TransJakarta & Halte Busway'**
  String get homeExitNorthIntegration;

  /// No description provided for @homeExitSouth.
  ///
  /// In id, this message translates to:
  /// **'Pintu B (Selatan)'**
  String get homeExitSouth;

  /// No description provided for @homeExitSouthDesc.
  ///
  /// In id, this message translates to:
  /// **'Akses Jalan Srikaya & Area Komersial'**
  String get homeExitSouthDesc;

  /// No description provided for @homeExitSouthIntegration.
  ///
  /// In id, this message translates to:
  /// **'Area Drop-off Ojek Online & Parkir Kendaraan'**
  String get homeExitSouthIntegration;

  /// No description provided for @homeCustomerServiceHeader.
  ///
  /// In id, this message translates to:
  /// **'Layanan Pelanggan & Bantuan CS'**
  String get homeCustomerServiceHeader;

  /// No description provided for @homeCSStation.
  ///
  /// In id, this message translates to:
  /// **'Customer Service Stasiun {station}'**
  String homeCSStation(String station);

  /// No description provided for @homeContactCenter.
  ///
  /// In id, this message translates to:
  /// **'Contact Center: 121 / (021) 121'**
  String get homeContactCenter;

  /// No description provided for @homeWhatsApp.
  ///
  /// In id, this message translates to:
  /// **'WhatsApp Aksesibilitas: +62 811-1211-121'**
  String get homeWhatsApp;

  /// No description provided for @homeCallCSBtn.
  ///
  /// In id, this message translates to:
  /// **'Hubungi CS'**
  String get homeCallCSBtn;

  /// No description provided for @homeCallCSSnackbar.
  ///
  /// In id, this message translates to:
  /// **'Menghubungi CS Stasiun {station} (121)...'**
  String homeCallCSSnackbar(String station);

  /// No description provided for @homeAskHelpBtn.
  ///
  /// In id, this message translates to:
  /// **'Minta Bantuan'**
  String get homeAskHelpBtn;

  /// No description provided for @homeAskHelpSnackbar.
  ///
  /// In id, this message translates to:
  /// **'Permintaan pendampingan petugas di {station} telah dikirim!'**
  String homeAskHelpSnackbar(String station);

  /// No description provided for @homeLineKRL.
  ///
  /// In id, this message translates to:
  /// **'KRL Commuter Line'**
  String get homeLineKRL;

  /// No description provided for @homeLineMRTJ.
  ///
  /// In id, this message translates to:
  /// **'MRT Jakarta'**
  String get homeLineMRTJ;

  /// No description provided for @homeLineLRTJabo.
  ///
  /// In id, this message translates to:
  /// **'LRT Jabodebek'**
  String get homeLineLRTJabo;

  /// No description provided for @homeLineLRTJakarta.
  ///
  /// In id, this message translates to:
  /// **'LRT Jakarta'**
  String get homeLineLRTJakarta;

  /// No description provided for @homeFilterBogor.
  ///
  /// In id, this message translates to:
  /// **'Lin Bogor & Nambo'**
  String get homeFilterBogor;

  /// No description provided for @homeFilterCikarang.
  ///
  /// In id, this message translates to:
  /// **'Lin Cikarang'**
  String get homeFilterCikarang;

  /// No description provided for @homeFilterRangkas.
  ///
  /// In id, this message translates to:
  /// **'Lin Rangkasbitung'**
  String get homeFilterRangkas;

  /// No description provided for @homeFilterTangerang.
  ///
  /// In id, this message translates to:
  /// **'Lin Tangerang'**
  String get homeFilterTangerang;

  /// No description provided for @homeFilterPriok.
  ///
  /// In id, this message translates to:
  /// **'Lin Tanjung Priok'**
  String get homeFilterPriok;

  /// No description provided for @homeFilterMRTNorthSouth.
  ///
  /// In id, this message translates to:
  /// **'MRT Lin Utara - Selatan'**
  String get homeFilterMRTNorthSouth;

  /// No description provided for @homeFilterLRTBekasi.
  ///
  /// In id, this message translates to:
  /// **'Lin Bekasi'**
  String get homeFilterLRTBekasi;

  /// No description provided for @homeFilterLRTCibubur.
  ///
  /// In id, this message translates to:
  /// **'Lin Cibubur'**
  String get homeFilterLRTCibubur;

  /// No description provided for @homeFilterLRTPegangsaan.
  ///
  /// In id, this message translates to:
  /// **'Lin Pegangsaan Dua - Velodrome'**
  String get homeFilterLRTPegangsaan;

  /// No description provided for @actionRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get actionRetry;

  /// No description provided for @homeAreaCentral.
  ///
  /// In id, this message translates to:
  /// **'Jakarta Pusat'**
  String get homeAreaCentral;

  /// No description provided for @homeAreaSouth.
  ///
  /// In id, this message translates to:
  /// **'Jakarta Selatan'**
  String get homeAreaSouth;

  /// No description provided for @homeAreaWest.
  ///
  /// In id, this message translates to:
  /// **'Jakarta Barat'**
  String get homeAreaWest;

  /// No description provided for @homeAreaEast.
  ///
  /// In id, this message translates to:
  /// **'Jakarta Timur'**
  String get homeAreaEast;

  /// No description provided for @homeAreaNorth.
  ///
  /// In id, this message translates to:
  /// **'Jakarta Utara'**
  String get homeAreaNorth;

  /// No description provided for @homeAreaGreaterJakarta.
  ///
  /// In id, this message translates to:
  /// **'Bodetabek (Penyangga)'**
  String get homeAreaGreaterJakarta;

  /// No description provided for @mapNearStation.
  ///
  /// In id, this message translates to:
  /// **'Anda berada di dekat Stasiun {station}'**
  String mapNearStation(String station);

  /// No description provided for @mapNearestMarkerNote.
  ///
  /// In id, this message translates to:
  /// **'Penanda biru menunjukkan titik stasiun terdekat, bukan posisi GPS persis di peta skematik.'**
  String get mapNearestMarkerNote;

  /// No description provided for @mapLocateMe.
  ///
  /// In id, this message translates to:
  /// **'Temukan lokasi saya'**
  String get mapLocateMe;

  /// No description provided for @routePreviewTitle.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Perjalanan'**
  String get routePreviewTitle;

  /// No description provided for @routePreviewUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau line tidak tersedia.'**
  String get routePreviewUnavailable;

  /// No description provided for @routePreviewLineTitle.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Line Perjalanan'**
  String get routePreviewLineTitle;

  /// No description provided for @routeCurrentLocation.
  ///
  /// In id, this message translates to:
  /// **'Anda Di Sini: {station}'**
  String routeCurrentLocation(String station);

  /// No description provided for @routeDimmedLinesNote.
  ///
  /// In id, this message translates to:
  /// **'Line lain diredupkan agar rute perjalanan lebih mudah dilihat.'**
  String get routeDimmedLinesNote;

  /// No description provided for @routeBackToResults.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke hasil perjalanan'**
  String get routeBackToResults;

  /// No description provided for @routeShowLineMap.
  ///
  /// In id, this message translates to:
  /// **'Lihat Line di Peta'**
  String get routeShowLineMap;

  /// No description provided for @routeColdStartHint.
  ///
  /// In id, this message translates to:
  /// **'Jika baru membuka server gratis, tunggu cold start lalu coba lagi.'**
  String get routeColdStartHint;

  /// No description provided for @routeSummarySemantics.
  ///
  /// In id, this message translates to:
  /// **'{minutes} menit, {stops} stasiun, tarif {fare}'**
  String routeSummarySemantics(int minutes, int stops, String fare);

  /// No description provided for @routeTransferCount.
  ///
  /// In id, this message translates to:
  /// **'{count} transit'**
  String routeTransferCount(int count);

  /// No description provided for @routeVoiceGuide.
  ///
  /// In id, this message translates to:
  /// **'Panduan suara perjalanan'**
  String get routeVoiceGuide;

  /// No description provided for @routeFromStation.
  ///
  /// In id, this message translates to:
  /// **'Dari {station}'**
  String routeFromStation(String station);

  /// No description provided for @routeToStation.
  ///
  /// In id, this message translates to:
  /// **'Ke {station}'**
  String routeToStation(String station);

  /// No description provided for @routeLiveEta.
  ///
  /// In id, this message translates to:
  /// **'Live ETA'**
  String get routeLiveEta;

  /// No description provided for @routeFocusJourney.
  ///
  /// In id, this message translates to:
  /// **'Fokus Perjalanan'**
  String get routeFocusJourney;

  /// No description provided for @routeAllLines.
  ///
  /// In id, this message translates to:
  /// **'Semua Line'**
  String get routeAllLines;

  /// No description provided for @stationLoadError.
  ///
  /// In id, this message translates to:
  /// **'Server sedang aktif atau koneksi terputus. Data stasiun belum dapat dimuat.'**
  String get stationLoadError;

  /// No description provided for @ticketSelectedTrip.
  ///
  /// In id, this message translates to:
  /// **'Perjalanan dipilih'**
  String get ticketSelectedTrip;

  /// No description provided for @ticketPaymentConfirmation.
  ///
  /// In id, this message translates to:
  /// **'Tiket aktif hanya setelah Xendit mengonfirmasi pembayaran ke server.'**
  String get ticketPaymentConfirmation;

  /// No description provided for @ticketOpenPayment.
  ///
  /// In id, this message translates to:
  /// **'Buka pembayaran'**
  String get ticketOpenPayment;

  /// No description provided for @ticketCheckStatus.
  ///
  /// In id, this message translates to:
  /// **'Cek status'**
  String get ticketCheckStatus;

  /// No description provided for @ticketOwnerEmail.
  ///
  /// In id, this message translates to:
  /// **'Email: {email}'**
  String ticketOwnerEmail(String email);

  /// No description provided for @ticketGateInstruction.
  ///
  /// In id, this message translates to:
  /// **'Tunjukkan kode ini di gerbang'**
  String get ticketGateInstruction;

  /// No description provided for @ticketDepartureAt.
  ///
  /// In id, this message translates to:
  /// **'Berangkat {time}'**
  String ticketDepartureAt(String time);

  /// No description provided for @ticketDeviceHeader.
  ///
  /// In id, this message translates to:
  /// **'Menampilkan tiket dari perangkat ini'**
  String get ticketDeviceHeader;

  /// No description provided for @ticketDeviceSemantics.
  ///
  /// In id, this message translates to:
  /// **'Menampilkan tiket dari perangkat ini, {count}'**
  String ticketDeviceSemantics(String count);

  /// No description provided for @ticketEmailHeader.
  ///
  /// In id, this message translates to:
  /// **'Menampilkan tiket untuk'**
  String get ticketEmailHeader;

  /// No description provided for @ticketEmailSemantics.
  ///
  /// In id, this message translates to:
  /// **'Menampilkan tiket untuk {email}'**
  String ticketEmailSemantics(String email);

  /// No description provided for @ticketPartialHistoryError.
  ///
  /// In id, this message translates to:
  /// **'Sebagian riwayat belum dapat dimuat'**
  String get ticketPartialHistoryError;

  /// No description provided for @ticketEmptyCategory.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tiket pada kategori ini.'**
  String get ticketEmptyCategory;

  /// No description provided for @ticketShowHistory.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan riwayat'**
  String get ticketShowHistory;

  /// No description provided for @ticketReload.
  ///
  /// In id, this message translates to:
  /// **'Muat ulang tiket'**
  String get ticketReload;

  /// No description provided for @ticketBackToList.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke daftar tiket'**
  String get ticketBackToList;

  /// No description provided for @scheduleStatusUpcoming.
  ///
  /// In id, this message translates to:
  /// **'Berangkat {minutes} menit lagi'**
  String scheduleStatusUpcoming(int minutes);

  /// No description provided for @scheduleStatusSoon.
  ///
  /// In id, this message translates to:
  /// **'Segera berangkat'**
  String get scheduleStatusSoon;

  /// No description provided for @scheduleStatusNow.
  ///
  /// In id, this message translates to:
  /// **'Berangkat sekarang'**
  String get scheduleStatusNow;

  /// No description provided for @scheduleStatusPassed.
  ///
  /// In id, this message translates to:
  /// **'Jadwal lewat'**
  String get scheduleStatusPassed;

  /// No description provided for @scheduleStatusUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Status jadwal tidak tersedia'**
  String get scheduleStatusUnavailable;

  /// No description provided for @scheduleStatusDisclaimer.
  ///
  /// In id, this message translates to:
  /// **'Status berdasarkan jadwal (bukan posisi kereta live)'**
  String get scheduleStatusDisclaimer;

  /// No description provided for @scheduleServerActive.
  ///
  /// In id, this message translates to:
  /// **'Server sedang aktif'**
  String get scheduleServerActive;

  /// No description provided for @scheduleBackendError.
  ///
  /// In id, this message translates to:
  /// **'Koneksi ke backend masih disiapkan atau terputus. Coba lagi tanpa menganggap jadwal kosong.'**
  String get scheduleBackendError;

  /// No description provided for @scheduleDatasetNote.
  ///
  /// In id, this message translates to:
  /// **'Jadwal Commuter Line Februari 2026 · status otomatis berdasarkan jadwal (bukan real-time KAI)'**
  String get scheduleDatasetNote;

  /// No description provided for @actionRepeat.
  ///
  /// In id, this message translates to:
  /// **'Ulangi'**
  String get actionRepeat;

  /// No description provided for @actionPause.
  ///
  /// In id, this message translates to:
  /// **'Jeda'**
  String get actionPause;

  /// No description provided for @actionStop.
  ///
  /// In id, this message translates to:
  /// **'Hentikan'**
  String get actionStop;

  /// No description provided for @facilityAccessibleLift.
  ///
  /// In id, this message translates to:
  /// **'Lift Aksesibel'**
  String get facilityAccessibleLift;

  /// No description provided for @facilityEscalator.
  ///
  /// In id, this message translates to:
  /// **'Eskalator'**
  String get facilityEscalator;

  /// No description provided for @facilityPrayerRoom.
  ///
  /// In id, this message translates to:
  /// **'Musala'**
  String get facilityPrayerRoom;

  /// No description provided for @facilityAccessibleToilet.
  ///
  /// In id, this message translates to:
  /// **'Toilet Difabel'**
  String get facilityAccessibleToilet;

  /// No description provided for @facilityCharger.
  ///
  /// In id, this message translates to:
  /// **'Pengisi Daya'**
  String get facilityCharger;

  /// No description provided for @facilityMinimarket.
  ///
  /// In id, this message translates to:
  /// **'Minimarket'**
  String get facilityMinimarket;

  /// No description provided for @facilityNursingRoom.
  ///
  /// In id, this message translates to:
  /// **'Ruang Menyusui'**
  String get facilityNursingRoom;

  /// No description provided for @facilityAtmCenter.
  ///
  /// In id, this message translates to:
  /// **'Pusat ATM'**
  String get facilityAtmCenter;

  /// No description provided for @mapLocationServiceDisabled.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan layanan lokasi perangkat, lalu coba lagi.'**
  String get mapLocationServiceDisabled;

  /// No description provided for @mapLocationPermissionDenied.
  ///
  /// In id, this message translates to:
  /// **'Izin lokasi dibutuhkan untuk menemukan stasiun terdekat.'**
  String get mapLocationPermissionDenied;

  /// No description provided for @stationVoiceEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada stasiun yang sesuai dengan pencarian.'**
  String get stationVoiceEmpty;

  /// No description provided for @stationVoiceFound.
  ///
  /// In id, this message translates to:
  /// **'Ditemukan {count} stasiun. Hasil teratas:'**
  String stationVoiceFound(int count);

  /// No description provided for @routeNarrationSummary.
  ///
  /// In id, this message translates to:
  /// **'Rute dari {from} menuju {to}. Estimasi waktu {minutes} menit. Tarif {currency}{fare}.'**
  String routeNarrationSummary(
    String from,
    String to,
    int minutes,
    String currency,
    String fare,
  );

  /// No description provided for @ticketStatusPending.
  ///
  /// In id, this message translates to:
  /// **'Belum dibayar'**
  String get ticketStatusPending;

  /// No description provided for @ticketStatusPaid.
  ///
  /// In id, this message translates to:
  /// **'Dibayar'**
  String get ticketStatusPaid;

  /// No description provided for @ticketStatusUsed.
  ///
  /// In id, this message translates to:
  /// **'Sudah digunakan'**
  String get ticketStatusUsed;

  /// No description provided for @ticketStatusExpired.
  ///
  /// In id, this message translates to:
  /// **'Kedaluwarsa'**
  String get ticketStatusExpired;

  /// No description provided for @ticketStatusCancelled.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get ticketStatusCancelled;

  /// No description provided for @ticketStatusUnknown.
  ///
  /// In id, this message translates to:
  /// **'Tidak diketahui'**
  String get ticketStatusUnknown;

  /// No description provided for @travelAlarmInactive.
  ///
  /// In id, this message translates to:
  /// **'Alarm perjalanan belum diaktifkan'**
  String get travelAlarmInactive;

  /// No description provided for @routeLoadError.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat memuat rute. Periksa koneksi dan coba lagi.'**
  String get routeLoadError;

  /// No description provided for @routeNoTransit.
  ///
  /// In id, this message translates to:
  /// **'Tanpa transit'**
  String get routeNoTransit;

  /// No description provided for @ticketEmailInputLabel.
  ///
  /// In id, this message translates to:
  /// **'Email untuk tiket dan riwayat'**
  String get ticketEmailInputLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'id', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
