// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get languagePageTitle => 'لغة';

  @override
  String get languagePageSubtitle => 'اللغة المستخدمة حاليا';

  @override
  String get languageApp => 'لغة التطبيق';

  @override
  String get languageDescription => 'اختر لغة للتنقل في التطبيق والرسائل';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get languageIndonesianDesc =>
      'استخدم اللغة الإندونيسية لتسميات التطبيقات';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishDesc => 'استخدم اللغة الإنجليزية لتسميات التطبيق';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageSimplifiedChineseDesc =>
      'استخدم اللغة الصينية المبسطة لتسميات التطبيقات';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageArabicDesc => 'استخدم اللغة العربية لتسميات التطبيق';

  @override
  String get preview => 'معاينة';

  @override
  String get previewAccount => 'حساب';

  @override
  String get previewGuestActive => 'وضع الضيف نشط';

  @override
  String get applyLanguage => 'تطبيق اللغة';

  @override
  String get languageAppliedNote =>
      'تُطبَّق التغييرات فورًا وتُحفظ للزيارات القادمة.';

  @override
  String get languageAppliedSnackbar => 'تم تطبيق اللغة.';

  @override
  String get languageSaveFailedSnackbar =>
      'تم تغيير اللغة لهذه الجلسة، ولكن لا يمكن حفظ تفضيلاتك.';

  @override
  String get profileAccount => 'حساب';

  @override
  String get profileGuestModeActive => 'وضع الضيف نشط';

  @override
  String get profileGuest => 'ضيف';

  @override
  String get profileGuestDesc =>
      'لا حاجة لتسجيل الدخول للخرائط، ETA، والجداول الزمنية، والتذاكر.';

  @override
  String get profileOptionalLogin => 'تسجيل دخول اختياري';

  @override
  String get profileLocalTicketHistory => 'تاريخ التذاكر المحلية';

  @override
  String get profileSavedOnDevice => 'تم الحفظ على هذا الجهاز';

  @override
  String get profileAccessibility => 'إمكانية الوصول';

  @override
  String get profileLargeText => 'نص كبير وطرق القراءة';

  @override
  String get profileBlindGuide => 'دليل المكفوفين';

  @override
  String get profileBlindGuideDescription =>
      'افتح الكاميرا مع إرشادات صوتية تلقائية';

  @override
  String get cameraGuideActiveAnnouncement =>
      'دليل الكاميرا نشط. وجّه الكاميرا إلى الأمام.';

  @override
  String get cameraGuideTitle => 'دليل الكاميرا';

  @override
  String get cameraGuideBack => 'رجوع';

  @override
  String cameraGuideStatus(String status) {
    return 'حالة الكاميرا: $status';
  }

  @override
  String get cameraGuideStateLoading => 'جارٍ التحميل';

  @override
  String get cameraGuideStateActive => 'نشط';

  @override
  String get cameraGuideStatePermissionDenied => 'الإذن مطلوب';

  @override
  String get cameraGuideStateOffline => 'غير متصل';

  @override
  String get cameraGuideStateError => 'خطأ';

  @override
  String get cameraGuideStateStopped => 'متوقف';

  @override
  String get cameraGuidePermissionRequired =>
      'يلزم إذن الكاميرا. فعّله من الإعدادات إذا تم رفضه نهائيًا من قبل.';

  @override
  String get cameraGuideSafetyWarning =>
      'قد يكون الاكتشاف غير دقيق. استخدم عصًا أو مرافقًا أو اطلب مساعدة الموظفين.';

  @override
  String get cameraGuideRetry => 'حاول مرة أخرى';

  @override
  String get cameraGuideStart => 'بدء الدليل';

  @override
  String get cameraGuideStop => 'إيقاف الدليل';

  @override
  String get cameraGuideLoadingMessage => 'جارٍ إعداد الكاميرا…';

  @override
  String get cameraGuideActiveMessage =>
      'وجّه الكاميرا إلى الأمام. الدليل نشط.';

  @override
  String get cameraGuideUnavailableMessage => 'لا يمكن استخدام الكاميرا.';

  @override
  String get cameraGuideOfflineMessage =>
      'الاكتشاف المحلي محدود؛ اتصال الذكاء الاصطناعي غير متاح.';

  @override
  String get cameraGuideStoppedMessage => 'تم إيقاف دليل الكاميرا.';

  @override
  String get cameraGuideNoClearObject =>
      'لم يتم اكتشاف جسم واضح في الأمام بعد.';

  @override
  String cameraGuideObjectCount(int count) {
    return 'تم اكتشاف $count أجسام في الأمام.';
  }

  @override
  String cameraGuideLabelsDetected(String labels) {
    return 'تم اكتشاف $labels في الأمام.';
  }

  @override
  String get profileHelpCenter => 'مركز المساعدة';

  @override
  String get profileContactOfficer => 'الاتصال بالمسؤول والإبلاغ عن الأخطاء';

  @override
  String get authSignInTitle => 'تسجيل الدخول';

  @override
  String get authSignInSubtitle =>
      'الحساب اختياري. سجّل الدخول لمزامنة ملفك الشخصي وسجل التذاكر.';

  @override
  String get authRegisterTitle => 'إنشاء حساب';

  @override
  String get authRegisterSubtitle =>
      'يمكنك التسجيل مع بقاء الوصول كضيف إلى الجداول والمسارات وشراء التذاكر.';

  @override
  String get authName => 'الاسم الكامل';

  @override
  String get authEmail => 'البريد الإلكتروني';

  @override
  String get authPhoneOptional => 'رقم الهاتف (اختياري)';

  @override
  String get authPassword => 'كلمة المرور';

  @override
  String get authPasswordConfirmation => 'تأكيد كلمة المرور';

  @override
  String get authEmailInvalid => 'أدخل عنوان بريد إلكتروني صالحًا.';

  @override
  String get authNameRequired => 'يجب أن يحتوي الاسم على حرفين على الأقل.';

  @override
  String get authPasswordMin =>
      'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل.';

  @override
  String get authPasswordMismatch => 'تأكيد كلمة المرور غير متطابق.';

  @override
  String get authShowPassword => 'إظهار كلمة المرور';

  @override
  String get authHidePassword => 'إخفاء كلمة المرور';

  @override
  String get authSubmitLogin => 'تسجيل الدخول';

  @override
  String get authSubmitRegister => 'التسجيل';

  @override
  String get authCreateAccount => 'ليس لديك حساب؟ سجّل الآن';

  @override
  String get authBackToLogin => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get authGuestStillAvailable =>
      'من دون حساب، يمكنك عرض الجداول والبحث عن المسارات وشراء التذاكر كضيف.';

  @override
  String get authInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get authEmailUsed => 'هذا البريد الإلكتروني مسجل بالفعل.';

  @override
  String get authNetworkError =>
      'تعذر الاتصال بالخادم. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get authGenericError => 'تعذرت معالجة الطلب. حاول مرة أخرى.';

  @override
  String get profileSignedIn => 'الحساب نشط';

  @override
  String get profileOfflineSession => 'تم حفظ الحساب · غير متصل حاليًا';

  @override
  String get profileOfflineHint => 'ستتوفر بعض التغييرات عند عودة الاتصال.';

  @override
  String get profileEdit => 'تعديل الملف الشخصي';

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get profileLogoutConfirm =>
      'هل تريد تسجيل الخروج من هذا الجهاز؟ ستظل ميزات الضيف متاحة.';

  @override
  String get profileCancel => 'إلغاء';

  @override
  String get profileAccountTicketHistory => 'سجل تذاكر الحساب';

  @override
  String get profileSyncedAccount => 'تمت المزامنة مع هذا الحساب';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSchedule => 'المواعيد';

  @override
  String get navTickets => 'التذاكر';

  @override
  String get navAssistant => 'مساعد';

  @override
  String get navAccount => 'حساب';

  @override
  String get filterArea => 'مرشح المنطقة';

  @override
  String get areaJabodetabek => 'Greater Jakarta Area';

  @override
  String get filterAreaComingSoon => 'مرشحات منطقة محددة قريبا';

  @override
  String get filterLine => 'مرشح خط النقل';

  @override
  String get searchStationHint => 'اكتب اسم المحطة أو الخط أو المنطقة';

  @override
  String startFrom(String station) {
    return 'البداية من: $station';
  }

  @override
  String get selectedStation => 'المحطة المختارة';

  @override
  String get from => 'من';

  @override
  String get to => 'ل';

  @override
  String get selectFromFirst => 'الرجاء تحديد محطة البداية (من) أولاً!';

  @override
  String get nearestDepartures => 'أقرب المغادرين';

  @override
  String get allStations => 'جميع المحطات';

  @override
  String get all => 'الجميع';

  @override
  String get selectOriginStation => 'حدد محطة الأصل';

  @override
  String get searchStationHint2 =>
      'اسم محطة البحث (على سبيل المثال، Manggarai، حليم...)';

  @override
  String get weekday => 'أيام الأسبوع';

  @override
  String get weekend => 'عطلة نهاية الأسبوع';

  @override
  String get trainSchedule => 'جدول القطار';

  @override
  String get searchDestinationHint => 'ابحث عن محطة الوجهة أو رقم القطار...';

  @override
  String get filterOriginAll => 'مرشح محطة الأصل (جميع المحطات)';

  @override
  String originStation(String station) {
    return 'محطة الانطلاق: $station';
  }

  @override
  String get scheduleNotFound => 'لم يتم العثور على الجدول الزمني';

  @override
  String get tryChangingFilter => 'حاول تغيير المحطة أو مرشح اليوم.';

  @override
  String get alarmActivated => 'تم تفعيل إنذار السفر';

  @override
  String get alarmDeactivated => 'تم إلغاء تنشيط إنذار السفر';

  @override
  String get tickets => 'التذاكر';

  @override
  String get validUntil => 'صالح حتى الساعة 23:59';

  @override
  String get payBefore => 'ادفع قبل الساعة 23:59';

  @override
  String get usedToday => 'يستخدم اليوم، 09:12';

  @override
  String get unpaid => 'غير مدفوعة الأجر';

  @override
  String get active => 'نشيط';

  @override
  String get completed => 'مكتمل';

  @override
  String get travelTicket => 'تذكرة سفر';

  @override
  String ticketStatusSummary(int active, int pending, int completed) {
    return '$active تذاكر نشطة · $pending غير مدفوعة · $completed مكتملة';
  }

  @override
  String get notPaid => 'لم تدفع';

  @override
  String get alreadyUsed => 'تستخدم بالفعل';

  @override
  String get readyToScan => 'جاهز للمسح';

  @override
  String get payNow => 'ادفع الآن';

  @override
  String get detail => 'التفاصيل';

  @override
  String get viewQR => 'عرض QR';

  @override
  String get ticketAlreadyUsed => 'لقد تم استخدام هذه التذكرة بالفعل.';

  @override
  String get qrValidUntil => 'QR صالحة حتى';

  @override
  String get choosePayment => 'اختر الدفع';

  @override
  String get qrisDesc => 'لا يوجد حساب، جميع المحافظ الإلكترونية';

  @override
  String get creditCard => 'بطاقة الخصم/الائتمان';

  @override
  String get virtualAccount => 'فا / نقل';

  @override
  String get vaDesc => 'رمز الدفع لمرة واحدة';

  @override
  String get optionalContact => 'الهاتف / البريد الإلكتروني الاختياري';

  @override
  String get optionalContactDesc =>
      'فقط لإرسال نسخة التذكرة. لم يتم إنشاء أي حساب.';

  @override
  String payAmount(String amount) {
    return 'ادفع $amount';
  }

  @override
  String get paymentSuccess => 'تم الدفع بنجاح';

  @override
  String get scanQrAtGate => 'قم بمسح QR عند بوابة الدخول.';

  @override
  String get validGateInBefore => 'صالحة للدخول من قبل';

  @override
  String get today2359 => '23:59 اليوم';

  @override
  String get withoutAccount => 'لا يوجد حساب';

  @override
  String get guest => 'ضيف';

  @override
  String get ticketSaved => 'تم حفظ التذكرة في معرض الهاتف!';

  @override
  String get saveTicket => 'حفظ التذكرة';

  @override
  String get sharingTicketLink => 'رابط مشاركة التذكرة...';

  @override
  String get share => 'يشارك';

  @override
  String get a11yQrInfo =>
      'A11Y: يحتوي QR على رمز نصي احتياطي لمساعدة الموظفين.';

  @override
  String get assistantReady => 'على استعداد للمساعدة';

  @override
  String get assistantListening => 'الاستماع';

  @override
  String get assistantProcessing => 'يعالج';

  @override
  String get assistantSpeaking => 'تكلم';

  @override
  String get assistantWaiting => 'في انتظار التأكيد';

  @override
  String get assistantError => 'يحتاج إلى المحاولة مرة أخرى';

  @override
  String get voiceStart => 'ابدأ المحادثة الصوتية';

  @override
  String get voiceStop => 'إيقاف المحادثة الصوتية';

  @override
  String get voiceProcessing => 'الطلب قيد المعالجة';

  @override
  String get voiceStopSpeaking => 'إيقاف صوت المساعد';

  @override
  String get voiceNew => 'ابدأ محادثة جديدة';

  @override
  String get voiceRetry => 'حاول المحادثة الصوتية مرة أخرى';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get planTrip => 'خطط لرحلة';

  @override
  String get nextTrain => 'القطار القادم';

  @override
  String get myTickets => 'التذاكر الخاصة بي';

  @override
  String get officerHelp => 'مساعدة الموظفين';

  @override
  String get travelAssistant => 'مساعد السفر';

  @override
  String assistantStatusLabel(String status) {
    return 'حالة المساعد: $status';
  }

  @override
  String get wakeWordMode => 'وضع كلمة التنبيه مرحبًا بالمساعد';

  @override
  String get inactive => 'غير نشط';

  @override
  String get listenWakeWord => 'الاستماع إلى \"مرحبا مساعد\"';

  @override
  String get wakeWordActiveText => 'كلمة التنبيه مفعّلة';

  @override
  String get wakeWordPageOnly => 'نشط فقط على هذه الصفحة';

  @override
  String get back => 'خلف';

  @override
  String get selectDestination => 'اختر محطة الوجهة';

  @override
  String get searchStationTitle => 'محطة البحث';

  @override
  String startTripFrom(String station) {
    return 'ابدأ الرحلة من: $station';
  }

  @override
  String get serviceFilter => 'مرشح الخدمة';

  @override
  String get accessible => 'يمكن الوصول إليها';

  @override
  String get quickResults => 'نتائج سريعة';

  @override
  String get stationNotFound => 'لم يتم العثور على المحطة';

  @override
  String get stationVoiceGuide => 'الدليل الصوتي';

  @override
  String get stationVoiceGuideStop => 'إيقاف الدليل الصوتي';

  @override
  String get stationVoiceGuideError => 'الدليل الصوتي غير متاح. حاول مرة أخرى.';

  @override
  String get withoutLogin => 'لا تسجيل الدخول';

  @override
  String get favoriteHistoryLocal =>
      'يتم حفظ المفضلة والتاريخ محليًا على الجهاز.';

  @override
  String get routeGuideTitle => 'دليل طريق الرحلة';

  @override
  String get fastest => 'الأسرع';

  @override
  String get minTransit => 'دقيقة العبور';

  @override
  String get travelEstimate => 'تقدير السفر';

  @override
  String get minutesOnly => 'دقائق';

  @override
  String stopsAndService(int stops, String serviceInfo) {
    return '$stops محطات · $serviceInfo';
  }

  @override
  String get travelFare => 'أجرة السفر';

  @override
  String get routeTimeline => 'الجدول الزمني للطريق';

  @override
  String exitGateInfo(String to) {
    return 'معلومات بوابة الخروج عند $to';
  }

  @override
  String buyTicketDirect(String fare) {
    return 'شراء التذكرة مباشرة ($fare)';
  }

  @override
  String readRouteToast(String from, String to, int travelTime) {
    return 'جارٍ قراءة المسار من $from إلى $to: المدة $travelTime دقيقة.';
  }

  @override
  String get readRouteBtn => 'قراءة الطريق';

  @override
  String get viewOnMapBtn => 'عرض على الخريطة';

  @override
  String a11yAudioRoute(String from, String to, int travelTime, int stops) {
    return 'الصوت الميسّر A11Y: المسار من $from إلى $to ($travelTime دقيقة، $stops محطات).';
  }

  @override
  String get nextTrainLive => 'القطار التالي (البث المباشر)';

  @override
  String get noTripNeeded => 'لا حاجة لرحلة';

  @override
  String get sameOriginDest => 'الأصل والوجهة هي نفسها.';

  @override
  String get alreadyAtDest => 'أنت بالفعل في محطة الوجهة.';

  @override
  String get minuteShort => 'دقيقة';

  @override
  String lineNoTransit(String lineName) {
    return '$lineName · لا يوجد نقل عام';
  }

  @override
  String boardLineFrom(String lineName, String from) {
    return 'اركب $lineName من محطة $from.';
  }

  @override
  String get departureTime => 'المغادرة: 08:35 صباحًا';

  @override
  String platformDirection(int platform, String to) {
    return 'الرصيف $platform · باتجاه $to';
  }

  @override
  String directTripTo(String to, int stops) {
    return 'رحلة مباشرة إلى $to (محطات $stops)';
  }

  @override
  String estDuration(int duration) {
    return 'نحو $duration دقيقة';
  }

  @override
  String skipStops(int stops) {
    return 'تخطي محطات $stops مباشرة';
  }

  @override
  String arriveAtDest(String to) {
    return 'الوصول إلى الوجهة $to';
  }

  @override
  String totalDuration(int duration) {
    return 'الإجمالي $duration دقيقة';
  }

  @override
  String get elevatedStation => 'محطة مرتفعة';

  @override
  String gateA(String gate) {
    return 'البوابة A (الشمالية): $gate';
  }

  @override
  String gateB(String gate) {
    return 'البوابة B (الجنوبية): $gate';
  }

  @override
  String get mainAccessGate => 'الوصول إلى الطريق الرئيسي وتكامل TransJakarta';

  @override
  String get dropOffGate =>
      'خدمة التوصيل عبر الإنترنت من Ojek وموقف سيارات الأجرة ومواقف السيارات';

  @override
  String oneTransitAt(String station) {
    return 'وسيلة نقل واحدة · التغيير في $station';
  }

  @override
  String alightAt(String station, int stops) {
    return 'انزل في محطة $station ($stops محطات)';
  }

  @override
  String prepareTransitAt(String station) {
    return 'الاستعداد لتغيير الخطوط في محطة $station.';
  }

  @override
  String transitToLine(String station, String line) {
    return 'بدّل في $station: انتقل إلى رصيف $line';
  }

  @override
  String get transitPlatform1To2 =>
      'النقل من المنصة 1 إلى المنصة 2 (مصعد الوصول وكتلة التوجيه)';

  @override
  String boardLineTo(String line, String to, int stops) {
    return 'اركب $line باتجاه محطة $to ($stops محطات)';
  }

  @override
  String nextTrainAtPlatform(int minutes, int platform) {
    return 'يصل القطار التالي خلال $minutes دقيقة إلى الرصيف $platform';
  }

  @override
  String get a11yReadingPreview =>
      'القراءة: من Dukuh Atas إلى Harjamukti، الرصيف 2، ستصل خلال 4 دقائق.';

  @override
  String get a11yTitle => 'إمكانية الوصول';

  @override
  String get a11ySubtitle => 'النص والصوت';

  @override
  String get a11yDisplaySettings => 'إعدادات العرض';

  @override
  String get a11yMakeEasier => 'اجعل التطبيق أسهل في القراءة والاستماع';

  @override
  String get a11yLargeText => 'نص كبير';

  @override
  String get a11yLargeTextDesc => 'تكبير التسميات ومعلومات الطريق';

  @override
  String get a11yReadRoute => 'قراءة الطريق';

  @override
  String get a11yReadRouteDesc => 'تمكين قراءة المحطة والاتجاه';

  @override
  String get a11yRoutePreviewSemantic =>
      'معاينة الطريق. من Dukuh Atas إلى Harjamukti. الرصيف 2 سيصل خلال 4 دقائق';

  @override
  String get a11yRoutePreviewTitle => 'معاينة الطريق';

  @override
  String get a11yRoutePreviewRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get a11yRoutePreviewDetail => 'الرصيف 2، سيصل خلال 4 دقائق';

  @override
  String get a11yReadBtn => 'يقرأ';

  @override
  String get historyCleared => 'تم مسح سجل التذكرة من هذا الجهاز.';

  @override
  String get historyTitle => 'تاريخ التذاكر';

  @override
  String get historyCompleted => 'اكتمل التاريخ';

  @override
  String get historySubtitle => 'تم الحفظ على هذا الجهاز';

  @override
  String get historyLastTicket => 'التذكرة الأخيرة';

  @override
  String get historySortRecent => 'مرتبة حسب الرحلات الأخيرة';

  @override
  String get historyKrl => 'KRL Commuter Line';

  @override
  String get historyKrlRoute => 'Bogor → Jakarta Kota';

  @override
  String get historyKrlDate => 'اليوم، 08:12';

  @override
  String get historyLrt => 'LRT Jabodebek';

  @override
  String get historyLrtRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get historyLrtDate => 'الثلاثاء 7 يوليو 2026';

  @override
  String get historyGuestMode => 'وضع الضيف';

  @override
  String get historyGuestDesc => 'هذا السجل موجود فقط على هذا الجهاز.';

  @override
  String get historyNoTickets => 'لا يوجد سجل التذاكر بعد';

  @override
  String get historyClearHistory => 'مسح التاريخ';

  @override
  String get historyClearDesc => 'احذف البيانات من هذا الجهاز.';

  @override
  String get helpTopicBuyTicket => 'كيفية شراء التذاكر المحلية';

  @override
  String get helpTopicBuyTicketDesc => 'دليل KRL وLRT';

  @override
  String get helpTopicScheduleIssue => 'الجدول الزمني أو عدم تطابق ETA';

  @override
  String get helpTopicScheduleIssueDesc => 'إرسال تقرير من تفاصيل الطريق';

  @override
  String get helpTopicPaymentIssue => 'مشكلة الدفع';

  @override
  String get helpTopicPaymentIssueDesc => 'التحقق من حالة المعاملة الأخيرة';

  @override
  String get helpCenterTitle => 'مركز المساعدة';

  @override
  String get helpCenterSubtitle => 'الاتصال بالموظفين والتقارير';

  @override
  String get helpSearchHint => 'ابحث عن المساعدة أو المحطة أو التذكرة';

  @override
  String get helpQuickActions => 'إجراءات سريعة';

  @override
  String get helpQuickActionsDesc => 'اختر المساعدة المستخدمة بشكل متكرر';

  @override
  String get helpChatStaff => 'الدردشة مع الموظفين';

  @override
  String get helpReportInfo => 'الإبلاغ عن معلومات خاطئة';

  @override
  String get helpTopicsTitle => 'مواضيع المساعدة';

  @override
  String get helpNoTopicsFound => 'لم يتم العثور على مواضيع مساعدة.';

  @override
  String get helpCallKaiSnack => 'التواصل مع KAI عبر 121.';

  @override
  String get helpCallKai => 'الاتصال KAI: 121';

  @override
  String get chatLiveHelp => 'مساعدة حية';

  @override
  String get chatWithStaff => 'الدردشة مع الموظفين';

  @override
  String chatActiveTopic(String topic) {
    return 'الموضوع النشط: $topic';
  }

  @override
  String get chatContentTailored => 'محتوى الدردشة مصمم حسب اختيارك.';

  @override
  String get chatServiceStatus => 'حالة الخدمة';

  @override
  String get chatWaitEstimate => 'تقدير الانتظار الحالي';

  @override
  String get chatSelectTopic => 'حدد الموضوع';

  @override
  String get chatInitialMessage => 'الرسالة الأولية';

  @override
  String get chatSharedData => 'البيانات المشتركة';

  @override
  String chatReceivedData(String data) {
    return 'البيانات المستلمة:\n$data';
  }

  @override
  String get issueLateEtaTitle => 'أواخر ETA';

  @override
  String get issueLateEtaLabel => 'أواخر ETA';

  @override
  String get issueLateEtaActive => 'ETA متأخر';

  @override
  String get issueLateEtaRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueLateEtaRouteDetail => 'التطبيق ETA: 09:32';

  @override
  String get issueLateEtaNote => 'تظهر لوحة المحطة 09:40.';

  @override
  String get issueLateEtaGuidance => 'يساعد التصحيح على دقة ETA لهذا المسار.';

  @override
  String get issueLateEtaAction => 'إرسال تصحيح ETA';

  @override
  String get issueMissingTrainTitle => 'القطار المفقود';

  @override
  String get issueMissingTrainLabel => 'القطار المفقود';

  @override
  String get issueMissingTrainActive => 'القطار لم يظهر';

  @override
  String get issueMissingTrainRoute => 'بيكاسي → Manggarai';

  @override
  String get issueMissingTrainRouteDetail => 'أقرب قطار لا يظهر';

  @override
  String get issueMissingTrainNote =>
      'وينظر القطار في المحطة، ولكن ليس في التطبيق.';

  @override
  String get issueMissingTrainGuidance => 'التقرير يكمل بيانات المغادرة.';

  @override
  String get issueMissingTrainAction => 'الإبلاغ عن القطار المفقود';

  @override
  String get issueChangedScheduleTitle => 'تم تغيير الجدول الزمني';

  @override
  String get issueChangedScheduleLabel => 'تم تغيير الجدول الزمني';

  @override
  String get issueChangedScheduleActive => 'تم تغيير الجدول الزمني';

  @override
  String get issueChangedScheduleRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get issueChangedScheduleRouteDetail => 'جدول التطبيق: 15:18';

  @override
  String get issueChangedScheduleNote =>
      'تم تغيير الجدول الزمني في المحطة إلى الساعة 15:30.';

  @override
  String get issueChangedScheduleGuidance => 'يساعد التقرير في جدولة المزامنة.';

  @override
  String get issueChangedScheduleAction => 'إرسال تغيير الجدول الزمني';

  @override
  String get issueDiffPlatformTitle => 'منصة مختلفة';

  @override
  String get issueDiffPlatformLabel => 'منصة مختلفة';

  @override
  String get issueDiffPlatformActive => 'منصة مختلفة';

  @override
  String get issueDiffPlatformRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueDiffPlatformRouteDetail => 'منصة التطبيق: المنصة 2';

  @override
  String get issueDiffPlatformNote =>
      'يقوم الموظفون بتوجيه الركاب إلى المنصة 4.';

  @override
  String get issueDiffPlatformGuidance =>
      'يساعد التقرير في إصلاح معلومات النظام الأساسي.';

  @override
  String get issueDiffPlatformAction => 'إرسال تصحيح المنصة';

  @override
  String get issueReportMismatch => 'الإبلاغ عن عدم التطابق';

  @override
  String get issueScheduleAndEta => 'الجدول الزمني وETA';

  @override
  String issueActiveProblem(String problem) {
    return 'المشكلة النشطة: $problem';
  }

  @override
  String get issueDetailFollows => 'تفاصيل التقرير تتبع المشكلة المحددة.';

  @override
  String get issueMonitoredRoute => 'طريق مراقب';

  @override
  String get issueProblemOccurred => 'حدثت مشكلة';

  @override
  String get issueNotes => 'ملحوظات';

  @override
  String issueCorrectionPrepared(String problem) {
    return 'تم إعداد تصحيح $problem بنجاح.';
  }

  @override
  String get topicTicketLabel => 'تذكرة';

  @override
  String get topicTicketTitle => 'دردشة التذاكر';

  @override
  String get topicTicketAgent => 'موظفي التذاكر';

  @override
  String get topicTicketAvailability => 'موظفو التذاكر متاحون';

  @override
  String get topicTicketWait => 'يتم الرد عادةً خلال دقيقتين';

  @override
  String get topicTicketOpening => 'أحتاج إلى مساعدة بشأن التذكرة';

  @override
  String get topicTicketShared => 'وضع الضيف ومعرف التذكرة والمسار الأخير';

  @override
  String get topicTicketSampleData =>
      'رمز التذكرة: TKT-20260827-001\nالمسار: Manggarai – Tanah Abang\nتاريخ الرحلة: 27 أغسطس 2026\nالحالة: نشطة';

  @override
  String get topicTicketAction => 'ابدأ محادثة التذاكر';

  @override
  String get topicTicketGreeting =>
      'مرحبًا، أنا راني من خدمة التذاكر. وصلتني بيانات التذكرة الخاصة بك. ماذا تريد أن تحقق؟';

  @override
  String get topicScheduleLabel => 'جدول';

  @override
  String get topicScheduleTitle => 'جدولة الدردشة';

  @override
  String get topicScheduleAgent => 'جدولة الموظفين';

  @override
  String get topicScheduleAvailability => 'جدول الموظفين المتاحة';

  @override
  String get topicScheduleWait => 'عادة ما يتم الرد خلال 3 دقائق';

  @override
  String get topicScheduleOpening => 'أحتاج إلى مساعدة في الجدول الزمني أو ETA';

  @override
  String get topicScheduleShared => 'المسار الأخير ووجهة الأصل ووقت السفر';

  @override
  String get topicScheduleSampleData =>
      'محطة الانطلاق: Manggarai\nالوجهة: Jakarta Kota\nرقم القطار: KA 1184\nالمغادرة: 10:25 WIB\nالرصيف: 3';

  @override
  String get topicScheduleAction => 'ابدأ جدولة الدردشة';

  @override
  String get topicScheduleGreeting =>
      'مرحبًا، أنا ديماس من خدمة الجدول الزمني. رأيت طريقك. ما هو الجدول الزمني أو ETA الذي تريد التحقق منه؟';

  @override
  String get topicPaymentLabel => 'قسط';

  @override
  String get topicPaymentTitle => 'دردشة الدفع';

  @override
  String get topicPaymentAgent => 'موظفي الدفع';

  @override
  String get topicPaymentAvailability => 'متوفر موظفين الدفع';

  @override
  String get topicPaymentWait => 'عادة ما يتم الرد خلال 4 دقائق';

  @override
  String get topicPaymentOpening => 'أحتاج إلى مساعدة في دفع التذاكر';

  @override
  String get topicPaymentShared => 'حالة المعاملة الأخيرة ورمز التذكرة والوقت';

  @override
  String get topicPaymentSampleData =>
      'معرف المعاملة: TRX-20260827-001\nالطريقة: QRIS\nالمبلغ: Rp7.800\nالوقت: 27 أغسطس 2026، 10:20 WIB\nالحالة: ناجحة';

  @override
  String get topicPaymentAction => 'ابدأ محادثة الدفع';

  @override
  String get topicPaymentGreeting =>
      'مرحبا، أنا ساري من خدمة الدفع. لقد تلقيت حالة المعاملة الخاصة بك. ما هي المشكلة؟';

  @override
  String get chatReplyTicketNotFound =>
      'حسنًا، سأساعدك في التحقق. حاول فتح التذاكر الخاصة بي وإعادة تحميل الصفحة. إذا لم تظهر التذكرة بعد، أرسل رمز التذكرة هنا.';

  @override
  String get chatReplyTicketBuy =>
      'لشراء تذكرة، حدد طريقًا من الصفحة الرئيسية، وقم بتعيين الرحلة، ثم تابع عملية الدفع. ستظهر التذاكر في قائمة التذاكر بعد الدفع الناجح.';

  @override
  String get chatReplyTicketActive =>
      'يمكن فتح التذاكر النشطة من قائمة التذاكر. تأكد من أن رمز QR مرئي بوضوح قبل المسح عند البوابة.';

  @override
  String get chatReplyTicketDefault =>
      'أنا على استعداد للمساعدة في التحقق من تذكرتك. اشرح حالة التذكرة أو الخطوات التي تواجه مشكلة فيها.';

  @override
  String get chatReplyScheduleLate =>
      'يمكن لـ ETA تغيير موضع القطار التالي. اسمحوا لي أن أعرف طريقك والمحطة حتى أتمكن من المساعدة في مطابقة أحدث المعلومات.';

  @override
  String get chatReplySchedulePlatform =>
      'يمكن أن تتغير معلومات النظام الأساسي في المحطة. اتبع إعلانات الموظفين وأرسل اسم المحطة إذا كانت معلومات التطبيق مختلفة.';

  @override
  String get chatReplyScheduleMissing =>
      'سأساعد في ملاحظة القطار المفقود. أرسل المحطة والوجهة ووقت المغادرة المقدر.';

  @override
  String get chatReplyScheduleDefault =>
      'يرجى إرسال المسار والمحطة ووقت السفر الذي تريد التحقق منه.';

  @override
  String get chatReplyPaymentDeducted =>
      'إذا تم خصم الرصيد ولكن التذكرة غير نشطة، فانتظر دقيقتين ثم تحقق من سجل التذكرة. أرسل رمز المعاملة إذا لم تتغير الحالة.';

  @override
  String get chatReplyPaymentRefund =>
      'سأساعدك في التحقق من استرداد الأموال. أرسل رمز المعاملة وسبب طلب استرداد الأموال.';

  @override
  String get chatReplyPaymentFailed =>
      'حاول مرة أخرى باستخدام شبكة مستقرة أو استخدم طريقة دفع أخرى. قم بإرسال رسالة الفشل الموضحة في حالة استمرار المشكلة.';

  @override
  String get chatReplyPaymentDefault =>
      'اشرح حالة المعاملة أو طريقة الدفع التي تواجه مشكلة فيها حتى أتمكن من مساعدتك.';

  @override
  String get payDeductedLabel => 'تم خصم الرصيد';

  @override
  String get payDeductedTitle => 'تم خصم الرصيد';

  @override
  String get payDeductedStatus => 'قيد المعالجة';

  @override
  String get payDeductedDetail => 'تم خصم 8.000 روبية، التذكرة غير نشطة';

  @override
  String get payDeductedAdvice =>
      'تحقق من سجل التذاكر بعد دقيقتين.\nأرسل المساعدة إذا لم تتغير الحالة.';

  @override
  String get payDeductedAction => 'الإبلاغ عن الرصيد المخصوم';

  @override
  String get payMissingLabel => 'التذكرة مفقودة';

  @override
  String get payMissingTitle => 'التذكرة مفقودة';

  @override
  String get payMissingStatus => 'نجاح';

  @override
  String get payMissingDetail => 'تم الدفع بنجاح، التذكرة لا تظهر';

  @override
  String get payMissingAdvice =>
      'إعادة تحميل صفحة التذاكر الخاصة بي.\nإذا كان لا يزال فارغًا، أرسل رمز المعاملة.';

  @override
  String get payMissingAction => 'الإبلاغ عن تذكرة مفقودة';

  @override
  String get payRefundLabel => 'استرداد';

  @override
  String get payRefundTitle => 'استرداد';

  @override
  String get payRefundStatus => 'مُقَدَّم';

  @override
  String get payRefundDetail => 'استرداد التذكرة';

  @override
  String get payRefundAdvice =>
      'استرداد الأموال يتبع حالة المعاملة الأخيرة.\nاحتفظ برمز التذكرة حتى تنتهي العملية.';

  @override
  String get payRefundAction => 'إرسال استرداد';

  @override
  String get payMethodLabel => 'طريقة الدفع';

  @override
  String get payMethodTitle => 'طريقة الدفع';

  @override
  String get payMethodStatus => 'فشل';

  @override
  String get payMethodDetail => 'لا يمكن استخدام طريقة الدفع';

  @override
  String get payMethodAdvice =>
      'حاول طريقة دفع أخرى.\nالإبلاغ في حالة فشل جميع الطرق.';

  @override
  String get payMethodAction => 'الإبلاغ عن طريقة الدفع';

  @override
  String get payCheckStatusSubtitle => 'التحقق من حالة المعاملة';

  @override
  String get payIssueTitle => 'مشكلة الدفع';

  @override
  String payActiveIssue(String issue) {
    return 'العدد النشط: $issue';
  }

  @override
  String get payIssueDescription => 'النصائح والإجراءات تتبع المشكلة المحددة.';

  @override
  String get payLastTransaction => 'المعاملة الأخيرة';

  @override
  String get paySelectIssue => 'حدد المشكلة';

  @override
  String get payQuickAdvice => 'نصيحة سريعة';

  @override
  String payHelpPrepared(String issue) {
    return 'تم إعداد المساعدة $issue بنجاح.';
  }

  @override
  String get reportScheduleLabel => 'جدول';

  @override
  String get reportScheduleTitle => 'جدول التقرير';

  @override
  String get reportScheduleFirstLabel => 'الطريق ذات الصلة';

  @override
  String get reportScheduleFirstValue => 'Bogor → Jakarta Kota';

  @override
  String get reportScheduleSecondLabel => 'الموقع / المحطة';

  @override
  String get reportScheduleSecondValue => 'Bogor';

  @override
  String get reportScheduleDesc => 'يختلف تطبيق ETA عن لوحة المحطة.';

  @override
  String get reportScheduleAction => 'إرسال تقرير الجدول الزمني';

  @override
  String get reportRouteLabel => 'طريق';

  @override
  String get reportRouteTitle => 'الإبلاغ عن المسار';

  @override
  String get reportRouteFirstLabel => 'طريق إشكالي';

  @override
  String get reportRouteFirstValue => 'Dukuh Atas → Harjamukti';

  @override
  String get reportRouteSecondLabel => 'نقطة الطريق';

  @override
  String get reportRouteSecondValue => 'محطة العبور';

  @override
  String get reportRouteDesc => 'المسار المعروض لا يمر بمحطة النقل الصحيحة.';

  @override
  String get reportRouteAction => 'إرسال تقرير الطريق';

  @override
  String get reportStationLabel => 'محطة';

  @override
  String get reportStationTitle => 'محطة التقارير';

  @override
  String get reportStationFirstLabel => 'اسم المحطة';

  @override
  String get reportStationFirstValue => 'Jakarta Kota';

  @override
  String get reportStationSecondLabel => 'معلومات غير صحيحة';

  @override
  String get reportStationSecondValue => 'منصة / منشأة';

  @override
  String get reportStationDesc => 'معلومات المحطة لا تتطابق مع ظروف الموقع.';

  @override
  String get reportStationAction => 'إرسال تقرير المحطة';

  @override
  String get reportSubtitle => 'بيانات السفر الصحيحة';

  @override
  String get reportWrongInfo => 'الإبلاغ عن معلومات خاطئة';

  @override
  String reportTypePrefix(String type) {
    return 'نوع التقرير: $type';
  }

  @override
  String get reportFieldsDesc => 'تتبع الحقول نوع التقرير المحدد.';

  @override
  String get reportTypeHeading => 'نوع التقرير';

  @override
  String get reportDescLabel => 'وصف التقرير';

  @override
  String get reportAttachScreenshot => 'إرفاق لقطة الشاشة';

  @override
  String get reportAttachScreenshotMsg => 'حدد لقطة شاشة من الجهاز لإرفاقها.';

  @override
  String reportPrepared(String type) {
    return 'تم إعداد التقرير $type بنجاح.';
  }

  @override
  String get chatOnline => 'متصل';

  @override
  String get chatLocalReply => 'الرد المحلي';

  @override
  String get chatToday => 'اليوم';

  @override
  String get chatUser => 'أنت';

  @override
  String get chatAgent => 'طاقم عمل';

  @override
  String get chatAgentTyping => 'فريق العمل يكتب…';

  @override
  String get chatWriteMessage => 'اكتب رسالة…';

  @override
  String get chatWaitReply => 'في انتظار رد الموظفين…';

  @override
  String get chatSendMessage => 'أرسل رسالة';

  @override
  String get activeTicketReadyShare => 'رمز التذكرة النشط جاهز للمشاركة.';

  @override
  String get activeTicketTitle => 'تفاصيل التذكرة النشطة';

  @override
  String get activeTicketShareCode => 'رمز المشاركة';

  @override
  String get activeTicketNeedHelp => 'بحاجة الى مساعدة';

  @override
  String get activeTicketOfflineOnly =>
      'يتم حفظ بيانات التذكرة على هذا الجهاز فقط.';

  @override
  String get activeTicketStatus => 'نشيط';

  @override
  String get activeTicketCodeTitle => 'رمز التذكرة النشط';

  @override
  String get activeTicketShowToStaff => 'أظهر هذا الرمز للموظفين';

  @override
  String activeTicketCodeSemantic(String code) {
    return 'رمز التذكرة النشطة $code';
  }

  @override
  String get activeTicketSavedOffline => 'تم الحفظ بلا اتصال';

  @override
  String get ticketStationOrigin => 'محطة الأصل';

  @override
  String get ticketStationDest => 'وجهة';

  @override
  String get ticketStationDestFull => 'محطة الوجهة';

  @override
  String get ticketEta => 'الوصول المقدر';

  @override
  String get ticketType => 'نوع التذكرة';

  @override
  String get ticketTypeActive => 'تذكرة نشطة';

  @override
  String get completedTicketReceiptReady => 'تم إعداد إيصال الرحلة بنجاح.';

  @override
  String get completedTicketTitle => 'تفاصيل التذكرة المكتملة';

  @override
  String get completedTicketDownload => 'تنزيل الإيصال';

  @override
  String get completedTicketReport => 'الإبلاغ عن مشكلة';

  @override
  String get completedTicketLocalHistory =>
      'التفاصيل المكتملة تبقى في التاريخ المحلي.';

  @override
  String get completedTicketStatus => 'مكتمل';

  @override
  String get completedTicketSummary => 'ملخص الرحلة';

  @override
  String get completedTicketDepart => 'المغادرة';

  @override
  String get completedTicketArrive => 'الوصول';

  @override
  String completedTicketDuration(String minutes) {
    return 'المدة $minutes دقيقة';
  }

  @override
  String get completedTicketJourneyDone => 'اكتملت الرحلة';

  @override
  String get completedTicketCode => 'كود الرحلة';

  @override
  String get completedTicketTypeLocal => 'تذكرة محلية';

  @override
  String get actionBack => 'رجوع';

  @override
  String get departureDetailTitle => 'تفاصيل المغادرة';

  @override
  String get departureFinalDestination => 'الوجهة النهائية';

  @override
  String get departureArrivingIn => 'الوصول إلى';

  @override
  String get departurePlatformNumber => 'رقم المنصة';

  @override
  String departurePlatform(String platform) {
    return 'الرصيف $platform';
  }

  @override
  String get departureStatusNormal =>
      'القطار يعمل بشكل طبيعي التسهيلات ذات الأولوية متوفرة في العربات 3 و 4.';

  @override
  String get departureNextStations => 'المحطات القادمة';

  @override
  String departureArriveAt(String platform) {
    return 'الوصول إلى $platform';
  }

  @override
  String get departurePromoBadge => 'عرض ترويجي';

  @override
  String get departurePromoTitle => 'خصم 50% على تذاكر القطار بين المدن';

  @override
  String get departurePromoDesc =>
      'قم بشراء تذاكر العودة للوطن الآن واحصل على خصم خاص باستخدام KAI Pay.';

  @override
  String durationMinutes(String minutes) {
    return '$minutes دقيقة';
  }

  @override
  String stationTransit(String station) {
    return '$station (تبديل)';
  }

  @override
  String get mapSearchHint => 'محطة البحث أو المفضلة';

  @override
  String get mapSubtitleLrtKrl => 'LRT Jabodebek · الوصول إلى التكامل KRL';

  @override
  String get mapSubtitleKrlTransit => 'KRL · العبور الرئيسي';

  @override
  String get mapSubtitleKrl => 'KRL Jabodetabek';

  @override
  String get mapSubtitleLrt => 'LRT Jabodebek';

  @override
  String get mapActionFrom => 'من';

  @override
  String get mapActionVia => 'عبر';

  @override
  String get mapActionTo => 'ل';

  @override
  String get mapActionInfo => 'معلومات';

  @override
  String get mapLegendTitle => 'أسطورة الطريق الرئيسي';

  @override
  String get mapLegendBogor => 'Bogor KRL';

  @override
  String get mapLegendCikarang => 'Cikarang Loop KRL';

  @override
  String get mapLegendRangkasbitung => 'Rangkasbitung KRL';

  @override
  String get mapLegendTangerang => 'Tangerang KRL';

  @override
  String get mapLegendTanjungPriok => 'Tanjung Priok KRL';

  @override
  String get mapLegendMrt => 'North-South MRT';

  @override
  String get mapLegendLrtBekasi => 'Bekasi LRT';

  @override
  String get mapLegendLrtCibubur => 'Cibubur LRT';

  @override
  String get mapLegendLrtJakarta => 'جنوب Jakarta LRT';

  @override
  String get trainTypesJakarta => 'KRL · LRT · MRT Jakarta';

  @override
  String departFromStation(String station) {
    return 'المغادرة من $station';
  }

  @override
  String get estimatedArrival => 'الوصول المتوقع';

  @override
  String get alarmActiveSemantics => 'إنذار السفر نشط، انقر لتعطيله';

  @override
  String get alarmInactiveSemantics => 'تفعيل إنذار السفر';

  @override
  String get alarmActiveTooltip => 'التنبيه نشط';

  @override
  String get alarmInactiveTooltip => 'تفعيل التنبيه';

  @override
  String get alarmDisableBoth =>
      'سيتم تعطيل تذكيرات وصول القطار والنزول/العبور.';

  @override
  String get alarmDisableDeparture => 'سيتم تعطيل تذكير وصول القطار.';

  @override
  String get alarmDisableDestination => 'سيتم تعطيل تذكير النزول أو العبور.';

  @override
  String get alarmDisableNone => 'لا توجد تذكيرات سفر نشطة.';

  @override
  String get alarmDisableTitle => 'هل تريد تعطيل إنذار السفر؟';

  @override
  String get alarmDisableAction => 'تعطيل التنبيه';

  @override
  String get alarmSetupTitle => 'تفعيل تذكير السفر؟';

  @override
  String routeFromTo(String from, String to) {
    return 'من $from إلى $to';
  }

  @override
  String get alarmDepartureSemantics => 'تذكير بوصول القطار';

  @override
  String get alarmDepartureTitle => 'وصول القطار';

  @override
  String get alarmDepartureDesc => 'ذكرني قبل 5 دقائق ودقيقة واحدة';

  @override
  String get alarmDestinationSemantics => 'تذكير بالنزول أو العبور';

  @override
  String get alarmDestinationTitle => 'النزول أو العبور';

  @override
  String get alarmDestinationDesc => 'ذكرني بمحطة واحدة قبل الوجهة';

  @override
  String get alarmSimulationNote =>
      'هذه التذكيرات عبارة عن محاكاة وتكون نشطة عندما يكون التطبيق مفتوحًا.';

  @override
  String get alarmActivateBtn => 'تفعيل التنبيه';

  @override
  String get actionSkip => 'يتخطى';

  @override
  String get stateActive => 'نشيط';

  @override
  String get stateInactive => 'غير نشط';

  @override
  String get alarmDepartureActive => 'وصول القطار نشط';

  @override
  String get alarmDepartureInactive => 'وصول القطار غير نشط';

  @override
  String get alarmDestinationActive => 'النزول أو العبور نشط';

  @override
  String get alarmDestinationInactive => 'النزول أو العبور غير نشط';

  @override
  String get viewTicketBtn => 'عرض التذكرة';

  @override
  String get cancelAlarmBtn => 'إلغاء التنبيه';

  @override
  String get assistantChatAssistant => 'مساعد';

  @override
  String get assistantTypeMessage => 'اكتب رسالة للمساعد';

  @override
  String get assistantSendMessage => 'أرسل رسالة';

  @override
  String get assistantUseThisRoute => 'استخدم هذا الطريق';

  @override
  String get assistantRepeat => 'يكرر';

  @override
  String get assistantCancel => 'يلغي';

  @override
  String get assistantBuyTicketToUseAlarm =>
      'قم بشراء أو تحديد تذكرة نشطة لاستخدام إنذار السفر.';

  @override
  String get assistantSearchTrip => 'رحلة البحث';

  @override
  String assistantOpenQuickAction(String action) {
    return 'فتح $action';
  }

  @override
  String get assistantRetry => 'أعد المحاولة';

  @override
  String get assistantUnknownDestination => 'لم أفهم وجهتك.';

  @override
  String assistantDemoTranscript(String destination, String origin) {
    return 'أريد الذهاب من $origin إلى $destination.';
  }

  @override
  String get assistantDemoResponse =>
      'يستغرق أسرع مسار 7 دقائق. يصل القطار خلال 5 دقائق.';

  @override
  String get assistantUnavailable =>
      'المساعد غير متاح حاليًا. حاول مرة أخرى أو راجع معلومات المحطة الرسمية.';

  @override
  String get assistantVoiceDestinationPrompt => 'مرحبًا، إلى أين تريد السفر؟';

  @override
  String get assistantVoiceUnavailable =>
      'الإدخال الصوتي غير متاح. تحقق من إذن الميكروفون وحاول مرة أخرى.';

  @override
  String get assistantVoiceNoSpeech => 'لم أسمع وجهتك. يرجى قولها مرة أخرى.';

  @override
  String get assistantUnknownCommand =>
      'لم أفهم هذا الأمر. جرّب: «متى التنبيه التالي؟» أو «فعّل كل تنبيهات تذاكري».';

  @override
  String get assistantNoActiveTicket => 'لا توجد تذكرة نشطة';

  @override
  String get assistantNoActiveAlarm => 'لا يوجد تنبيه نشط.';

  @override
  String get assistantAllAlarmsCancelled => 'تم إلغاء جميع تنبيهات الرحلة.';

  @override
  String get assistantDestinationAlarmAlreadyOff =>
      'تنبيه الوجهة متوقف بالفعل.';

  @override
  String get assistantDestinationAlarmDisabled => 'تم تعطيل تنبيه الوجهة.';

  @override
  String get assistantAllAlarmsActive => 'جميع تنبيهات الرحلة نشطة.';

  @override
  String travelAlarmTrainArrivesIn(int minutes) {
    return 'يصل القطار خلال $minutes دقائق';
  }

  @override
  String get travelAlarmNoActive => 'لا يوجد تنبيه نشط';

  @override
  String travelAlarmExitAt(String destination, int stations) {
    return 'انزل في $destination، تبقت $stations محطات';
  }

  @override
  String travelAlarmTransferAt(String station, int stations) {
    return 'انتقل في $station، تبقت $stations محطات';
  }

  @override
  String get travelAlarmDestinationFallback => 'الوجهة';

  @override
  String get assistantCameraGuideAction => 'دليل الكاميرا';

  @override
  String assistantMessageSemantics(String sender, String message) {
    return '$sender، $message';
  }

  @override
  String get voiceTapToSpeak => 'انقر للتحدث';

  @override
  String get voiceWhereToToday => 'إلى أين اليوم؟';

  @override
  String get voiceStartConversation => 'ابدأ المحادثة الصوتية';

  @override
  String get voiceListening => 'الاستماع';

  @override
  String get voicePleaseStateDestination => 'يرجى ذكر وجهتك';

  @override
  String get voiceStopConversation => 'إيقاف المحادثة الصوتية';

  @override
  String get voiceProcessingRequest => 'طلب المعالجة';

  @override
  String get voiceSearchingForTrips => 'البحث عن خيارات السفر المناسبة';

  @override
  String get voiceRequestBeingProcessed => 'جاري معالجة الطلب';

  @override
  String get voiceAgentSpeaking => 'الوكيل يتحدث';

  @override
  String get voiceReadingAnswer => 'تتم قراءة إجابة السفر';

  @override
  String get voiceStopAssistant => 'إيقاف صوت المساعد';

  @override
  String get voiceNeedsConfirmation => 'يحتاج إلى تأكيد';

  @override
  String get voiceChooseActionBeforeRoute => 'اختر إجراءً قبل فتح الطريق';

  @override
  String get voiceStartNewConversation => 'ابدأ محادثة جديدة';

  @override
  String get voiceUseVoiceOrQuickAction =>
      'استخدم الصوت أو اختر الإجراء السريع.';

  @override
  String get voiceRetryConversation => 'حاول المحادثة الصوتية مرة أخرى';

  @override
  String homeNextTrainFrom(String station) {
    return 'القطار التالي من $station';
  }

  @override
  String get homeClose => 'إغلاق';

  @override
  String homeShowAll(int count) {
    return 'إظهار الكل ($count)';
  }

  @override
  String homeTravelDuration(String duration) {
    return 'مدة الرحلة $duration';
  }

  @override
  String homePlatform(String platform) {
    return 'الرصيف $platform';
  }

  @override
  String homeDestination(String destination) {
    return 'الوجهة $destination';
  }

  @override
  String homeArrivingIn(String duration) {
    return 'الوصول خلال $duration';
  }

  @override
  String get homeAtStation => 'في المحطة';

  @override
  String homeStationFacilities(String station) {
    return 'مرافق محطة $station';
  }

  @override
  String homeStationInformation(String station) {
    return 'معلومات محطة $station';
  }

  @override
  String get homeConstructionType => 'نوع البناء';

  @override
  String get homeConstructionTypeDesc => 'محطة مرتفعة · سهولة الوصول';

  @override
  String get homeOperationalHours => 'ساعات العمل';

  @override
  String get homeOperationalHoursDesc =>
      '05:00 - 23:30 بتوقيت غرب إندونيسيا (مفتوح يوميًا)';

  @override
  String get homeTicketServices => 'خدمات التذاكر';

  @override
  String get homeTicketServicesDesc =>
      'بطاقة النقود الإلكترونية، KMT، QRIS، وآلة البيع';

  @override
  String get homeAccessibilityFeatures => 'ميزات إمكانية الوصول';

  @override
  String get homeAccessibilityFeaturesDesc =>
      'الكتلة التوجيهية، والمنحدر الخاص، والإعلانات الصوتية TTS';

  @override
  String get homeExitGateGuide => 'دليل بوابة الخروج';

  @override
  String get homeExitNorth => 'البوابة أ (شمال)';

  @override
  String get homeExitNorthDesc =>
      'الوصول الرئيسي إلى الطريق الرئيسي / Kebon Sirih';

  @override
  String get homeExitNorthIntegration => 'TransJakarta وتكامل إيقاف Busway';

  @override
  String get homeExitSouth => 'البوابة ب (جنوب)';

  @override
  String get homeExitSouthDesc => 'Srikaya Road والوصول إلى المنطقة التجارية';

  @override
  String get homeExitSouthIntegration =>
      'إنزال سيارات الأجرة والدراجات النارية عبر الإنترنت ومواقف السيارات';

  @override
  String get homeCustomerServiceHeader => 'خدمة العملاء والمساعدة';

  @override
  String homeCSStation(String station) {
    return 'خدمة العملاء في محطة $station';
  }

  @override
  String get homeContactCenter => 'مركز الاتصال: 121 / (021) 121';

  @override
  String get homeWhatsApp => 'إمكانية الوصول واتساب: +62 811-1211-121';

  @override
  String get homeCallCSBtn => 'اتصل بـ CS';

  @override
  String homeCallCSSnackbar(String station) {
    return 'جارٍ الاتصال بمحطة CS $station (121)...';
  }

  @override
  String get homeAskHelpBtn => 'اطلب المساعدة';

  @override
  String homeAskHelpSnackbar(String station) {
    return 'تم إرسال طلب المساعدة للموظفين في $station!';
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
  String get homeFilterBogor => 'Bogor وNambo Line';

  @override
  String get homeFilterCikarang => 'Cikarang Line';

  @override
  String get homeFilterRangkas => 'Rangkasbitung Line';

  @override
  String get homeFilterTangerang => 'Tangerang Line';

  @override
  String get homeFilterPriok => 'Tanjung Priok Line';

  @override
  String get homeFilterMRTNorthSouth => 'الشمال - South MRT Line';

  @override
  String get homeFilterLRTBekasi => 'Bekasi Line';

  @override
  String get homeFilterLRTCibubur => 'Cibubur Line';

  @override
  String get homeFilterLRTPegangsaan => 'Pegangsaan Dua - Velodrome Line';

  @override
  String get actionRetry => 'حاول مرة أخرى';

  @override
  String get homeAreaCentral => 'وسط جاكرتا';

  @override
  String get homeAreaSouth => 'جنوب جاكرتا';

  @override
  String get homeAreaWest => 'غرب جاكرتا';

  @override
  String get homeAreaEast => 'شرق جاكرتا';

  @override
  String get homeAreaNorth => 'شمال جاكرتا';

  @override
  String get homeAreaGreaterJakarta => 'جاكرتا الكبرى (المدن المحيطة)';

  @override
  String mapNearStation(String station) {
    return 'أنت بالقرب من محطة $station';
  }

  @override
  String get mapNearestMarkerNote =>
      'تشير العلامة الزرقاء إلى أقرب محطة، وليس إلى موقع GPS الدقيق على الخريطة التخطيطية.';

  @override
  String get mapLocateMe => 'العثور على موقعي';

  @override
  String get routePreviewTitle => 'معاينة الرحلة';

  @override
  String get routePreviewUnavailable => 'معاينة الخط غير متاحة.';

  @override
  String get routePreviewLineTitle => 'معاينة خط الرحلة';

  @override
  String routeCurrentLocation(String station) {
    return 'أنت هنا: $station';
  }

  @override
  String get routeDimmedLinesNote =>
      'تم تعتيم الخطوط الأخرى لتسهيل رؤية مسار الرحلة.';

  @override
  String get routeBackToResults => 'العودة إلى نتائج الرحلة';

  @override
  String get routeShowLineMap => 'عرض الخط على الخريطة';

  @override
  String get routeColdStartHint =>
      'إذا بدأ الخادم المجاني للتو، فانتظر بدء التشغيل ثم حاول مرة أخرى.';

  @override
  String routeSummarySemantics(int minutes, int stops, String fare) {
    return '$minutes دقيقة، $stops محطات، الأجرة $fare';
  }

  @override
  String routeTransferCount(int count) {
    return '$count انتقالات';
  }

  @override
  String get routeVoiceGuide => 'إرشاد صوتي للرحلة';

  @override
  String routeFromStation(String station) {
    return 'من $station';
  }

  @override
  String routeToStation(String station) {
    return 'إلى $station';
  }

  @override
  String get routeLiveEta => 'وقت الوصول المباشر';

  @override
  String get routeFocusJourney => 'التركيز على الرحلة';

  @override
  String get routeAllLines => 'كل الخطوط';

  @override
  String get stationLoadError =>
      'الخادم قيد التشغيل أو انقطع الاتصال. تعذر تحميل بيانات المحطة.';

  @override
  String get ticketSelectedTrip => 'الرحلة المحددة';

  @override
  String get ticketPaymentConfirmation =>
      'تصبح التذكرة نشطة فقط بعد تأكيد Xendit للدفع مع الخادم.';

  @override
  String get ticketOpenPayment => 'فتح الدفع';

  @override
  String get ticketCheckStatus => 'التحقق من الحالة';

  @override
  String ticketOwnerEmail(String email) {
    return 'البريد الإلكتروني: $email';
  }

  @override
  String get ticketGateInstruction => 'اعرض هذا الرمز عند البوابة';

  @override
  String ticketDepartureAt(String time) {
    return 'المغادرة $time';
  }

  @override
  String get ticketDeviceHeader => 'عرض التذاكر من هذا الجهاز';

  @override
  String ticketDeviceSemantics(String count) {
    return 'عرض التذاكر من هذا الجهاز، $count';
  }

  @override
  String get ticketEmailHeader => 'عرض تذاكر';

  @override
  String ticketEmailSemantics(String email) {
    return 'عرض تذاكر $email';
  }

  @override
  String get ticketPartialHistoryError => 'تعذر تحميل بعض سجل التذاكر';

  @override
  String get ticketEmptyCategory => 'لا توجد تذاكر في هذه الفئة.';

  @override
  String get ticketShowHistory => 'عرض السجل';

  @override
  String get ticketReload => 'إعادة تحميل التذاكر';

  @override
  String get ticketBackToList => 'العودة إلى قائمة التذاكر';

  @override
  String scheduleStatusUpcoming(int minutes) {
    return 'المغادرة خلال $minutes دقائق';
  }

  @override
  String get scheduleStatusSoon => 'المغادرة قريبًا';

  @override
  String get scheduleStatusNow => 'المغادرة الآن';

  @override
  String get scheduleStatusPassed => 'انتهى موعد الرحلة';

  @override
  String get scheduleStatusUnavailable => 'حالة الجدول غير متاحة';

  @override
  String get scheduleStatusDisclaimer =>
      'تعتمد الحالة على الجدول، وليس على موقع القطار المباشر';

  @override
  String get scheduleServerActive => 'الخادم قيد التشغيل';

  @override
  String get scheduleBackendError =>
      'اتصال الخادم الخلفي قيد التشغيل أو انقطع. حاول مرة أخرى دون اعتبار الجدول فارغًا.';

  @override
  String get scheduleDatasetNote =>
      'جدول خط الركاب لشهر فبراير 2026 · حالة تلقائية حسب الجدول (وليست بيانات KAI مباشرة)';

  @override
  String get actionRepeat => 'إعادة';

  @override
  String get actionPause => 'إيقاف مؤقت';

  @override
  String get actionStop => 'إيقاف';

  @override
  String get facilityAccessibleLift => 'مصعد مهيأ';

  @override
  String get facilityEscalator => 'سلم متحرك';

  @override
  String get facilityPrayerRoom => 'غرفة صلاة';

  @override
  String get facilityAccessibleToilet => 'دورة مياه مهيأة';

  @override
  String get facilityCharger => 'شاحن';

  @override
  String get facilityMinimarket => 'متجر صغير';

  @override
  String get facilityNursingRoom => 'غرفة رضاعة';

  @override
  String get facilityAtmCenter => 'مركز صراف آلي';

  @override
  String get mapLocationServiceDisabled =>
      'فعّل خدمة الموقع في الجهاز ثم حاول مرة أخرى.';

  @override
  String get mapLocationPermissionDenied =>
      'إذن الموقع مطلوب للعثور على أقرب محطة.';

  @override
  String get stationVoiceEmpty => 'لا توجد محطات تطابق بحثك.';

  @override
  String stationVoiceFound(int count) {
    return 'تم العثور على $count محطة. أبرز النتائج:';
  }

  @override
  String routeNarrationSummary(
    String from,
    String to,
    int minutes,
    String currency,
    String fare,
  ) {
    return 'المسار من $from إلى $to. الوقت المقدر للرحلة $minutes دقيقة. الأجرة $currency $fare.';
  }

  @override
  String get ticketStatusPending => 'غير مدفوع';

  @override
  String get ticketStatusPaid => 'مدفوع';

  @override
  String get ticketStatusUsed => 'مستخدم';

  @override
  String get ticketStatusExpired => 'منتهي الصلاحية';

  @override
  String get ticketStatusCancelled => 'ملغى';

  @override
  String get ticketStatusUnknown => 'غير معروف';

  @override
  String get travelAlarmInactive => 'منبه الرحلة غير مفعّل';

  @override
  String get routeLoadError =>
      'تعذر تحميل المسار. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get routeNoTransit => 'بدون تبديل';

  @override
  String get ticketEmailInputLabel => 'البريد الإلكتروني للتذاكر والسجل';
}
