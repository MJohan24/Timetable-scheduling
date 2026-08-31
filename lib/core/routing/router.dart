import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/search_station/presentation/pages/search_station_page.dart';
import '../../features/route_result/presentation/pages/route_result_page.dart';
import '../../features/route_result/presentation/pages/route_map_preview_page.dart';
import '../../features/route_result/domain/entities/route_plan.dart';
import '../../features/timetable/presentation/pages/timetable_page.dart';
import '../../features/tickets/presentation/pages/tickets_page.dart';
import '../../features/assistant/presentation/pages/assistant_page.dart';
import '../../features/assistant/presentation/pages/camera_guide_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/ticket_history_page.dart';
import '../../features/profile/presentation/pages/language_page.dart';
import '../../features/profile/presentation/pages/help_center_page.dart';
import '../../features/profile/presentation/pages/help_chat_page.dart';
import '../../features/profile/presentation/pages/support_chat_conversation_page.dart';
import '../../features/profile/presentation/models/support_chat_topic.dart';
import '../../features/profile/presentation/pages/report_incorrect_info_page.dart';
import '../../features/profile/presentation/pages/schedule_issue_page.dart';
import '../../features/profile/presentation/pages/payment_issue_page.dart';
import '../../features/profile/presentation/pages/active_ticket_detail_page.dart';
import '../../features/profile/presentation/pages/completed_ticket_detail_page.dart';
import '../../features/home/presentation/pages/departure_detail_page.dart';
import '../../features/travel_alarm/presentation/widgets/travel_alarm_scope.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/edit_profile_page.dart';

/// Konfigurasi routing utama aplikasi menggunakan GoRouter.
/// Semua rute halaman didefinisikan di sini.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Tab Utama (Menggunakan NoTransitionPage agar panel navigasi bawah tidak ikut ter-slide) ──

    // Tab 0: Beranda
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomePage()),
    ),

    // Tab 1: Jadwal (Timetable)
    GoRoute(
      path: '/timetable',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: TimetablePage()),
    ),

    // Tab 2: Tiket Saya - Tiket QR (dengan opsi parameter query)
    GoRoute(
      path: '/tiket',
      pageBuilder: (context, state) {
        final from = state.uri.queryParameters['from'];
        final to = state.uri.queryParameters['to'];
        final fare = state.uri.queryParameters['fare'];
        final duration = state.uri.queryParameters['duration'];
        final transit = state.uri.queryParameters['transit'];
        return NoTransitionPage(
          child: TicketsPage(
            alarmController: TravelAlarmScope.of(context),
            from: from,
            to: to,
            fare: fare,
            duration: duration,
            transit: transit,
          ),
        );
      },
    ),

    // Tab 3: Asisten
    GoRoute(
      path: '/asisten',
      pageBuilder: (context, state) => NoTransitionPage(
        child: AssistantPage(alarmController: TravelAlarmScope.of(context)),
      ),
    ),
    GoRoute(
      path: '/asisten/pemandu-kamera',
      builder: (context, state) => CameraGuidePage(
        autoAnnounce: state.uri.queryParameters['autoVoice'] == 'true',
      ),
    ),

    // Tautan lama tetap menuju tab Asisten.
    GoRoute(path: '/promo', redirect: (context, state) => '/asisten'),

    // Tab 4: Akun
    GoRoute(
      path: '/akun',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: ProfilePage()),
    ),
    GoRoute(path: '/masuk', builder: (context, state) => const AuthPage()),
    GoRoute(
      path: '/daftar',
      builder: (context, state) => const AuthPage(register: true),
    ),
    GoRoute(
      path: '/profil-saya',
      builder: (context, state) => const EditProfilePage(),
    ),

    // Riwayat Tiket
    GoRoute(
      path: '/riwayat-tiket',
      builder: (context, state) => const TicketHistoryPage(),
    ),

    // Bahasa
    GoRoute(path: '/bahasa', builder: (context, state) => const LanguagePage()),

    // Pusat Bantuan
    GoRoute(
      path: '/pusat-bantuan',
      builder: (context, state) => const HelpCenterPage(),
    ),

    // Chat dengan petugas berdasarkan topik
    GoRoute(
      path: '/bantuan/chat',
      builder: (context, state) => const HelpChatPage(),
    ),

    // Percakapan lokal dengan petugas berdasarkan topik bantuan
    GoRoute(
      path: '/bantuan/chat/percakapan',
      builder: (context, state) => SupportChatConversationPage(
        topic: SupportChatTopic.fromKey(state.uri.queryParameters['topic']),
      ),
    ),

    // Laporan informasi jadwal, rute, atau stasiun yang salah
    GoRoute(
      path: '/bantuan/lapor',
      builder: (context, state) => const ReportIncorrectInfoPage(),
    ),

    // Laporan ketidaksesuaian jadwal dan ETA
    GoRoute(
      path: '/bantuan/jadwal-eta',
      builder: (context, state) => const ScheduleIssuePage(),
    ),

    // Bantuan masalah pembayaran
    GoRoute(
      path: '/bantuan/pembayaran',
      builder: (context, state) => const PaymentIssuePage(),
    ),

    // Detail Tiket Aktif
    GoRoute(
      path: '/detail-tiket-aktif',
      builder: (context, state) => const ActiveTicketDetailPage(),
    ),

    // Detail Tiket Selesai
    GoRoute(
      path: '/detail-tiket-selesai',
      builder: (context, state) => const CompletedTicketDetailPage(),
    ),

    // ── Halaman Detail (Menggunakan transisi bawaan slide standar) ──

    // Cari Stasiun
    GoRoute(
      path: '/cari-stasiun',
      builder: (context, state) => const SearchStationPage(),
    ),

    // Hasil Rute
    GoRoute(
      path: '/rute',
      builder: (context, state) => const RouteResultPage(),
    ),
    GoRoute(
      path: '/rute/peta',
      builder: (context, state) => RouteMapPreviewPage(
        route: state.extra is RoutePlan ? state.extra as RoutePlan : null,
      ),
    ),

    // Detail Keberangkatan
    GoRoute(
      path: '/departure-detail',
      builder: (context, state) {
        final lineType = state.uri.queryParameters['lineType'] ?? '';
        final destination = state.uri.queryParameters['destination'] ?? '';
        final duration = state.uri.queryParameters['duration'] ?? '';
        final platform = state.uri.queryParameters['platform'] ?? '';
        return DepartureDetailPage(
          lineType: lineType,
          destination: destination,
          duration: duration,
          platform: platform,
        );
      },
    ),
  ],
);
