// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languagePageTitle => 'Language';

  @override
  String get languagePageSubtitle => 'Currently used language';

  @override
  String get languageApp => 'App Language';

  @override
  String get languageDescription =>
      'Choose a language for app navigation and messages';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get languageIndonesianDesc => 'Use Indonesian for app labels';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishDesc => 'Use English for app labels';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageSimplifiedChineseDesc =>
      'Use Simplified Chinese for app labels';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageArabicDesc => 'Use Arabic for app labels';

  @override
  String get preview => 'Preview';

  @override
  String get previewAccount => 'Account';

  @override
  String get previewGuestActive => 'Guest mode active';

  @override
  String get applyLanguage => 'Apply language';

  @override
  String get languageAppliedNote =>
      'Changes are applied immediately and saved for future visits.';

  @override
  String get languageAppliedSnackbar => 'Language applied.';

  @override
  String get languageSaveFailedSnackbar =>
      'Language changed for this session, but your preference could not be saved.';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileGuestModeActive => 'Guest mode active';

  @override
  String get profileGuest => 'Guest';

  @override
  String get profileGuestDesc =>
      'No login needed for maps, ETA, schedules, and tickets.';

  @override
  String get profileOptionalLogin => 'Sign in or Create Account';

  @override
  String get profileLocalTicketHistory => 'Local ticket history';

  @override
  String get profileSavedOnDevice => 'Saved on this device';

  @override
  String get profileAccessibility => 'Accessibility';

  @override
  String get profileLargeText => 'Large text and read routes';

  @override
  String get profileBlindGuide => 'Blind Guide';

  @override
  String get profileBlindGuideDescription =>
      'Open the camera with automatic voice guidance';

  @override
  String get cameraGuideActiveAnnouncement =>
      'Camera guide active. Point the camera forward.';

  @override
  String get cameraGuideTitle => 'Camera Guide';

  @override
  String get cameraGuideBack => 'Back';

  @override
  String cameraGuideStatus(String status) {
    return 'Camera status: $status';
  }

  @override
  String get cameraGuideStateLoading => 'Loading';

  @override
  String get cameraGuideStateActive => 'Active';

  @override
  String get cameraGuideStatePermissionDenied => 'Permission required';

  @override
  String get cameraGuideStateOffline => 'Offline';

  @override
  String get cameraGuideStateError => 'Error';

  @override
  String get cameraGuideStateStopped => 'Stopped';

  @override
  String get cameraGuidePermissionRequired =>
      'Camera permission is required. Enable it in Settings if it was permanently denied.';

  @override
  String get cameraGuideSafetyWarning =>
      'Detection can be wrong. Use a cane, companion, or ask staff for help.';

  @override
  String get cameraGuideRetry => 'Try Again';

  @override
  String get cameraGuideStart => 'Start Guide';

  @override
  String get cameraGuideStop => 'Stop Guide';

  @override
  String get cameraGuideLoadingMessage => 'Preparing camera…';

  @override
  String get cameraGuideActiveMessage =>
      'Point the camera forward. Guide is active.';

  @override
  String get cameraGuideUnavailableMessage => 'The camera cannot be used.';

  @override
  String get cameraGuideOfflineMessage =>
      'Local detection is limited; the AI connection is unavailable.';

  @override
  String get cameraGuideStoppedMessage => 'Camera guide stopped.';

  @override
  String get cameraGuideNoClearObject => 'No clear object detected ahead yet.';

  @override
  String cameraGuideObjectCount(int count) {
    return '$count objects detected ahead.';
  }

  @override
  String cameraGuideLabelsDetected(String labels) {
    return '$labels detected ahead.';
  }

  @override
  String get profileHelpCenter => 'Help Center';

  @override
  String get profileContactOfficer => 'Contact officer and report errors';

  @override
  String get authSignInTitle => 'Sign in';

  @override
  String get authSignInSubtitle =>
      'Accounts are optional. Sign in to sync your profile and ticket history.';

  @override
  String get authRegisterTitle => 'Create an account';

  @override
  String get authRegisterSubtitle =>
      'Register without changing guest access to schedules, routes, and ticket purchase.';

  @override
  String get authName => 'Full name';

  @override
  String get authEmail => 'Email';

  @override
  String get authPhoneOptional => 'Phone number (optional)';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordConfirmation => 'Confirm password';

  @override
  String get authEmailInvalid => 'Enter a valid email address.';

  @override
  String get authNameRequired => 'Name must contain at least 2 characters.';

  @override
  String get authPasswordMin => 'Password must contain at least 8 characters.';

  @override
  String get authPasswordMismatch => 'Password confirmation does not match.';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authSubmitLogin => 'Sign in';

  @override
  String get authSubmitRegister => 'Register';

  @override
  String get authCreateAccount => 'No account yet? Register';

  @override
  String get authBackToLogin => 'Already have an account? Sign in';

  @override
  String get authGuestStillAvailable =>
      'Without an account, you can still view schedules, find routes, and purchase tickets as a guest.';

  @override
  String get authInvalidCredentials => 'The email or password is incorrect.';

  @override
  String get authEmailUsed => 'This email is already registered.';

  @override
  String get authNetworkError =>
      'Cannot connect to the server. Check your connection and try again.';

  @override
  String get authGenericError =>
      'The request could not be processed. Try again.';

  @override
  String get profileSignedIn => 'Account active';

  @override
  String get profileOfflineSession => 'Account saved • currently offline';

  @override
  String get profileOfflineHint =>
      'Some changes will be available when the connection returns.';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileLogoutConfirm =>
      'Sign out on this device? Guest features will remain available.';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileAccountTicketHistory => 'Account ticket history';

  @override
  String get profileSyncedAccount => 'Synced with this account';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get navHome => 'Home';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navTickets => 'Tickets';

  @override
  String get navAssistant => 'Assistant';

  @override
  String get navAccount => 'Account';

  @override
  String get filterArea => 'Area Filter';

  @override
  String get areaJabodetabek => 'Greater Jakarta Area';

  @override
  String get filterAreaComingSoon => 'Specific area filters coming soon';

  @override
  String get filterLine => 'Transportation Line Filter';

  @override
  String get searchStationHint => 'Type station name, line, or area';

  @override
  String startFrom(String station) {
    return 'Start from: $station';
  }

  @override
  String get selectedStation => 'Selected Station';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get selectFromFirst =>
      'Please select a starting station (From) first!';

  @override
  String get nearestDepartures => 'Nearest Departures';

  @override
  String get allStations => 'All Stations';

  @override
  String get all => 'All';

  @override
  String get selectOriginStation => 'Select Origin Station';

  @override
  String get searchStationHint2 =>
      'Search station name (e.g., Manggarai, Halim...)';

  @override
  String get weekday => 'Weekday';

  @override
  String get weekend => 'Weekend';

  @override
  String get trainSchedule => 'Train Schedule';

  @override
  String get searchDestinationHint =>
      'Search destination station or train number...';

  @override
  String get filterOriginAll => 'Origin Station Filter (All Stations)';

  @override
  String originStation(String station) {
    return 'Origin Station: $station';
  }

  @override
  String get scheduleNotFound => 'Schedule not found';

  @override
  String get tryChangingFilter => 'Try changing the station or day filter.';

  @override
  String get alarmActivated => 'Travel alarm activated';

  @override
  String get alarmDeactivated => 'Travel alarm deactivated';

  @override
  String get tickets => 'Tickets';

  @override
  String get validUntil => 'Valid until 23:59';

  @override
  String get payBefore => 'Pay before 23:59';

  @override
  String get usedToday => 'Used today, 09:12';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get active => 'Active';

  @override
  String get completed => 'Completed';

  @override
  String get travelTicket => 'Travel ticket';

  @override
  String ticketStatusSummary(int active, int pending, int completed) {
    return '$active active tickets · $pending unpaid · $completed completed';
  }

  @override
  String get notPaid => 'Not paid';

  @override
  String get alreadyUsed => 'Already used';

  @override
  String get readyToScan => 'Ready to scan';

  @override
  String get payNow => 'Pay now';

  @override
  String get detail => 'Detail';

  @override
  String get viewQR => 'View QR';

  @override
  String get ticketAlreadyUsed => 'This ticket has already been used.';

  @override
  String get qrValidUntil => 'QR valid until';

  @override
  String get choosePayment => 'Choose payment';

  @override
  String get qrisDesc => 'No account, all e-wallets';

  @override
  String get creditCard => 'Debit/credit card';

  @override
  String get virtualAccount => 'VA / transfer';

  @override
  String get vaDesc => 'One-time payment code';

  @override
  String get optionalContact => 'Optional phone/email';

  @override
  String get optionalContactDesc =>
      'Only for sending ticket copy. No account created.';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get paymentSuccess => 'Payment successful';

  @override
  String get scanQrAtGate => 'Scan QR at entrance gate.';

  @override
  String get validGateInBefore => 'Valid for gate-in before';

  @override
  String get today2359 => '23:59 today';

  @override
  String get withoutAccount => 'No account';

  @override
  String get guest => 'Guest';

  @override
  String get ticketSaved => 'Ticket saved to phone gallery!';

  @override
  String get saveTicket => 'Save ticket';

  @override
  String get sharingTicketLink => 'Sharing ticket link...';

  @override
  String get share => 'Share';

  @override
  String get a11yQrInfo =>
      'A11Y: QR has backup text code for staff assistance.';

  @override
  String get assistantReady => 'Ready to help';

  @override
  String get assistantListening => 'Listening';

  @override
  String get assistantProcessing => 'Processing';

  @override
  String get assistantSpeaking => 'Speaking';

  @override
  String get assistantWaiting => 'Waiting for confirmation';

  @override
  String get assistantError => 'Needs to try again';

  @override
  String get voiceStart => 'Start voice conversation';

  @override
  String get voiceStop => 'Stop voice conversation';

  @override
  String get voiceProcessing => 'Request is processing';

  @override
  String get voiceStopSpeaking => 'Stop assistant voice';

  @override
  String get voiceNew => 'Start new conversation';

  @override
  String get voiceRetry => 'Try voice conversation again';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get planTrip => 'Plan a trip';

  @override
  String get nextTrain => 'Next train';

  @override
  String get myTickets => 'My tickets';

  @override
  String get officerHelp => 'Staff assistance';

  @override
  String get travelAssistant => 'Travel Assistant';

  @override
  String assistantStatusLabel(String status) {
    return 'Assistant status: $status';
  }

  @override
  String get wakeWordMode => 'Wake word mode Hello Assistant';

  @override
  String get inactive => 'inactive';

  @override
  String get listenWakeWord => 'Listen for \"Hello Assistant\"';

  @override
  String get wakeWordActiveText => 'Wake word active';

  @override
  String get wakeWordPageOnly => 'Active only on this page';

  @override
  String get back => 'Back';

  @override
  String get selectDestination => 'Select destination station';

  @override
  String get searchStationTitle => 'Search station';

  @override
  String startTripFrom(String station) {
    return 'Start trip from: $station';
  }

  @override
  String get serviceFilter => 'Service filter';

  @override
  String get accessible => 'Accessible';

  @override
  String get quickResults => 'Quick results';

  @override
  String get stationNotFound => 'Station not found';

  @override
  String get stationVoiceGuide => 'Voice guide';

  @override
  String get stationVoiceGuideStop => 'Stop voice guide';

  @override
  String get stationVoiceGuideError => 'Voice guide is unavailable. Try again.';

  @override
  String get withoutLogin => 'No login';

  @override
  String get favoriteHistoryLocal =>
      'Favorites and history are saved locally on the device.';

  @override
  String get routeGuideTitle => 'Journey Route Guide';

  @override
  String get fastest => 'Fastest';

  @override
  String get minTransit => 'Min transits';

  @override
  String get travelEstimate => 'Travel Estimate';

  @override
  String get minutesOnly => 'minutes';

  @override
  String stopsAndService(int stops, String serviceInfo) {
    return '$stops Stops · $serviceInfo';
  }

  @override
  String get travelFare => 'Travel Fare';

  @override
  String get routeTimeline => 'Route Timeline';

  @override
  String exitGateInfo(String to) {
    return 'Exit Gate Info at $to';
  }

  @override
  String buyTicketDirect(String fare) {
    return 'Buy Ticket Direct ($fare)';
  }

  @override
  String readRouteToast(String from, String to, int travelTime) {
    return 'Reading route from $from to $to: Duration $travelTime minutes.';
  }

  @override
  String get readRouteBtn => 'Read Route';

  @override
  String get viewOnMapBtn => 'View on Map';

  @override
  String a11yAudioRoute(String from, String to, int travelTime, int stops) {
    return 'A11Y Audio: Route $from to $to ($travelTime min, $stops stops).';
  }

  @override
  String get nextTrainLive => 'NEXT TRAIN (LIVE REALTIME)';

  @override
  String get noTripNeeded => 'No trip needed';

  @override
  String get sameOriginDest => 'Origin and destination are the same.';

  @override
  String get alreadyAtDest => 'You are already at the destination station.';

  @override
  String get minuteShort => 'min';

  @override
  String lineNoTransit(String lineName) {
    return '$lineName · No transit';
  }

  @override
  String boardLineFrom(String lineName, String from) {
    return 'Board $lineName from $from Station';
  }

  @override
  String get departureTime => 'Departure: 08:35 AM';

  @override
  String platformDirection(int platform, String to) {
    return 'Platform $platform · Towards $to';
  }

  @override
  String directTripTo(String to, int stops) {
    return 'Direct trip to $to ($stops stations)';
  }

  @override
  String estDuration(int duration) {
    return 'est. $duration min';
  }

  @override
  String skipStops(int stops) {
    return 'Skip $stops stations directly';
  }

  @override
  String arriveAtDest(String to) {
    return 'Arrive at destination $to';
  }

  @override
  String totalDuration(int duration) {
    return 'Total $duration min';
  }

  @override
  String get elevatedStation => 'Elevated Station';

  @override
  String gateA(String gate) {
    return 'Gate A (North): $gate';
  }

  @override
  String gateB(String gate) {
    return 'Gate B (South): $gate';
  }

  @override
  String get mainAccessGate => 'Main Road Access & TransJakarta Integration';

  @override
  String get dropOffGate => 'Ojek Online Drop-off, Taxi Stand & Parking';

  @override
  String oneTransitAt(String station) {
    return '1 transit · Change at $station';
  }

  @override
  String alightAt(String station, int stops) {
    return 'Alight at $station Station ($stops stops)';
  }

  @override
  String prepareTransitAt(String station) {
    return 'Prepare to change lines at $station Station';
  }

  @override
  String transitToLine(String station, String line) {
    return 'Transit at $station: Transfer to $line platform';
  }

  @override
  String get transitPlatform1To2 =>
      'Transfer from Platform 1 to Platform 2 (Accessible Lift & Guiding Block)';

  @override
  String boardLineTo(String line, String to, int stops) {
    return 'Board $line towards $to Station ($stops stops)';
  }

  @override
  String nextTrainAtPlatform(int minutes, int platform) {
    return 'Next train arrives in $minutes minutes at Platform $platform';
  }

  @override
  String get a11yReadingPreview =>
      'Reading: Dukuh Atas to Harjamukti, Platform 2, arriving in 4 minutes.';

  @override
  String get a11yTitle => 'Accessibility';

  @override
  String get a11ySubtitle => 'Text and voice';

  @override
  String get a11yDisplaySettings => 'Display settings';

  @override
  String get a11yMakeEasier => 'Make the app easier to read and hear';

  @override
  String get a11yLargeText => 'Large text';

  @override
  String get a11yLargeTextDesc => 'Enlarge labels and route information';

  @override
  String get a11yReadRoute => 'Read route';

  @override
  String get a11yReadRouteDesc => 'Enable station and direction reading';

  @override
  String get a11yRoutePreviewSemantic =>
      'Route preview. Dukuh Atas to Harjamukti. Platform 2, arriving in 4 minutes.';

  @override
  String get a11yRoutePreviewTitle => 'Route preview';

  @override
  String get a11yRoutePreviewRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get a11yRoutePreviewDetail => 'Platform 2, arriving in 4 mins';

  @override
  String get a11yReadBtn => 'Read';

  @override
  String get historyCleared => 'Ticket history cleared from this device.';

  @override
  String get historyTitle => 'Ticket history';

  @override
  String get historyCompleted => 'History completed';

  @override
  String get historySubtitle => 'Saved on this device';

  @override
  String get historyLastTicket => 'Last ticket';

  @override
  String get historySortRecent => 'Sorted by recent trips';

  @override
  String get historyKrl => 'KRL Commuter Line';

  @override
  String get historyKrlRoute => 'Bogor → Jakarta Kota';

  @override
  String get historyKrlDate => 'Today, 08:12';

  @override
  String get historyLrt => 'LRT Jabodebek';

  @override
  String get historyLrtRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get historyLrtDate => 'Tuesday, 7 Jul 2026';

  @override
  String get historyGuestMode => 'Guest mode';

  @override
  String get historyGuestDesc => 'This history only exists on this device.';

  @override
  String get historyNoTickets => 'No ticket history yet';

  @override
  String get historyClearHistory => 'Clear history';

  @override
  String get historyClearDesc => 'Delete data from this device.';

  @override
  String get helpTopicBuyTicket => 'How to buy local tickets';

  @override
  String get helpTopicBuyTicketDesc => 'Guide for KRL and LRT';

  @override
  String get helpTopicScheduleIssue => 'Schedule or ETA mismatch';

  @override
  String get helpTopicScheduleIssueDesc => 'Send report from route details';

  @override
  String get helpTopicPaymentIssue => 'Payment issue';

  @override
  String get helpTopicPaymentIssueDesc => 'Check last transaction status';

  @override
  String get helpCenterTitle => 'Help Center';

  @override
  String get helpCenterSubtitle => 'Contact staff and reports';

  @override
  String get helpSearchHint => 'Search help, station, or ticket';

  @override
  String get helpQuickActions => 'Quick actions';

  @override
  String get helpQuickActionsDesc => 'Choose frequently used help';

  @override
  String get helpChatStaff => 'Chat with staff';

  @override
  String get helpReportInfo => 'Report wrong info';

  @override
  String get helpTopicsTitle => 'Help topics';

  @override
  String get helpNoTopicsFound => 'No help topics found.';

  @override
  String get helpCallKaiSnack => 'Contacting KAI via 121.';

  @override
  String get helpCallKai => 'Contact KAI: 121';

  @override
  String get chatLiveHelp => 'Live assistance';

  @override
  String get chatWithStaff => 'Chat with staff';

  @override
  String chatActiveTopic(String topic) {
    return 'Active topic: $topic';
  }

  @override
  String get chatContentTailored => 'Chat content tailored to your choice.';

  @override
  String get chatServiceStatus => 'Service status';

  @override
  String get chatWaitEstimate => 'Current wait estimate';

  @override
  String get chatSelectTopic => 'Select topic';

  @override
  String get chatInitialMessage => 'Initial message';

  @override
  String get chatSharedData => 'Shared data';

  @override
  String chatReceivedData(String data) {
    return 'Data received:\n$data';
  }

  @override
  String get issueLateEtaTitle => 'Late ETA';

  @override
  String get issueLateEtaLabel => 'Late ETA';

  @override
  String get issueLateEtaActive => 'ETA is late';

  @override
  String get issueLateEtaRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueLateEtaRouteDetail => 'App ETA: 09:32';

  @override
  String get issueLateEtaNote => 'Station board shows 09:40.';

  @override
  String get issueLateEtaGuidance =>
      'Correction helps ETA accuracy for this route.';

  @override
  String get issueLateEtaAction => 'Send ETA correction';

  @override
  String get issueMissingTrainTitle => 'Missing Train';

  @override
  String get issueMissingTrainLabel => 'Missing train';

  @override
  String get issueMissingTrainActive => 'Train didn\'t appear';

  @override
  String get issueMissingTrainRoute => 'Bekasi → Manggarai';

  @override
  String get issueMissingTrainRouteDetail => 'Nearest train not showing';

  @override
  String get issueMissingTrainNote =>
      'Train is seen at the station, but not in the app.';

  @override
  String get issueMissingTrainGuidance => 'Report completes departure data.';

  @override
  String get issueMissingTrainAction => 'Report missing train';

  @override
  String get issueChangedScheduleTitle => 'Changed Schedule';

  @override
  String get issueChangedScheduleLabel => 'Schedule changed';

  @override
  String get issueChangedScheduleActive => 'Schedule changed';

  @override
  String get issueChangedScheduleRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get issueChangedScheduleRouteDetail => 'App schedule: 15:18';

  @override
  String get issueChangedScheduleNote =>
      'Schedule at station changed to 15:30.';

  @override
  String get issueChangedScheduleGuidance =>
      'Report helps schedule synchronization.';

  @override
  String get issueChangedScheduleAction => 'Send schedule change';

  @override
  String get issueDiffPlatformTitle => 'Different Platform';

  @override
  String get issueDiffPlatformLabel => 'Different platform';

  @override
  String get issueDiffPlatformActive => 'Different platform';

  @override
  String get issueDiffPlatformRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueDiffPlatformRouteDetail => 'App platform: Platform 2';

  @override
  String get issueDiffPlatformNote => 'Staff directs passengers to Platform 4.';

  @override
  String get issueDiffPlatformGuidance => 'Report helps fix platform info.';

  @override
  String get issueDiffPlatformAction => 'Send platform correction';

  @override
  String get issueReportMismatch => 'Report mismatch';

  @override
  String get issueScheduleAndEta => 'Schedule & ETA';

  @override
  String issueActiveProblem(String problem) {
    return 'Active problem: $problem';
  }

  @override
  String get issueDetailFollows =>
      'Report details follow the selected problem.';

  @override
  String get issueMonitoredRoute => 'Monitored route';

  @override
  String get issueProblemOccurred => 'Problem occurred';

  @override
  String get issueNotes => 'Notes';

  @override
  String issueCorrectionPrepared(String problem) {
    return 'Correction for $problem prepared successfully.';
  }

  @override
  String get topicTicketLabel => 'Ticket';

  @override
  String get topicTicketTitle => 'Ticket Chat';

  @override
  String get topicTicketAgent => 'Ticket staff';

  @override
  String get topicTicketAvailability => 'Ticket staff available';

  @override
  String get topicTicketWait => 'Usually replies in 2 minutes';

  @override
  String get topicTicketOpening => 'I need help with a ticket';

  @override
  String get topicTicketShared => 'Guest mode, ticket ID, and last route';

  @override
  String get topicTicketSampleData =>
      'Ticket code: TKT-20260827-001\nRoute: Manggarai – Tanah Abang\nTravel date: August 27, 2026\nStatus: Active';

  @override
  String get topicTicketAction => 'Start ticket chat';

  @override
  String get topicTicketGreeting =>
      'Hello, I\'m Rani from ticket service. I received your ticket data. What do you want to check?';

  @override
  String get topicScheduleLabel => 'Schedule';

  @override
  String get topicScheduleTitle => 'Schedule Chat';

  @override
  String get topicScheduleAgent => 'Schedule staff';

  @override
  String get topicScheduleAvailability => 'Schedule staff available';

  @override
  String get topicScheduleWait => 'Usually replies in 3 minutes';

  @override
  String get topicScheduleOpening => 'I need help with schedule or ETA';

  @override
  String get topicScheduleShared =>
      'Last route, origin-destination, and travel time';

  @override
  String get topicScheduleSampleData =>
      'Origin station: Manggarai\nDestination: Jakarta Kota\nTrain number: KA 1184\nDeparture: 10:25 WIB\nPlatform: 3';

  @override
  String get topicScheduleAction => 'Start schedule chat';

  @override
  String get topicScheduleGreeting =>
      'Hello, I\'m Dimas from schedule service. I saw your route. Which schedule or ETA do you want to check?';

  @override
  String get topicPaymentLabel => 'Payment';

  @override
  String get topicPaymentTitle => 'Payment Chat';

  @override
  String get topicPaymentAgent => 'Payment staff';

  @override
  String get topicPaymentAvailability => 'Payment staff available';

  @override
  String get topicPaymentWait => 'Usually replies in 4 minutes';

  @override
  String get topicPaymentOpening => 'I need help with ticket payment';

  @override
  String get topicPaymentShared =>
      'Last transaction status, ticket code, and payment time';

  @override
  String get topicPaymentSampleData =>
      'Transaction ID: TRX-20260827-001\nMethod: QRIS\nAmount: Rp7,800\nTime: August 27, 2026, 10:20 WIB\nStatus: Successful';

  @override
  String get topicPaymentAction => 'Start payment chat';

  @override
  String get topicPaymentGreeting =>
      'Hello, I\'m Sari from payment service. I received your transaction status. What\'s the problem?';

  @override
  String get chatReplyTicketNotFound =>
      'Alright, I\'ll help check. Try opening My Tickets and reloading the page. If the ticket still doesn\'t appear, send your ticket code here.';

  @override
  String get chatReplyTicketBuy =>
      'To buy a ticket, select a route from Home, set the trip, then proceed to payment. Tickets will appear in the Tickets menu after successful payment.';

  @override
  String get chatReplyTicketActive =>
      'Active tickets can be opened from the Tickets menu. Ensure the QR code is clearly visible before scanning at the gate.';

  @override
  String get chatReplyTicketDefault =>
      'I am ready to help check your ticket. Explain the ticket status or steps you are having trouble with.';

  @override
  String get chatReplyScheduleLate =>
      'ETA can change following train position. Let me know your route and station so I can help match the latest information.';

  @override
  String get chatReplySchedulePlatform =>
      'Platform info can change at the station. Follow staff announcements and send the station name if app info is different.';

  @override
  String get chatReplyScheduleMissing =>
      'I\'ll help note the missing train. Send the station, destination, and estimated departure time.';

  @override
  String get chatReplyScheduleDefault =>
      'Please send the route, station, and travel time you want to check.';

  @override
  String get chatReplyPaymentDeducted =>
      'If balance is deducted but ticket is not active, wait two minutes then check Ticket History. Send transaction code if status hasn\'t changed.';

  @override
  String get chatReplyPaymentRefund =>
      'I\'ll help check the refund. Send the transaction code and reason for refund request.';

  @override
  String get chatReplyPaymentFailed =>
      'Try again with stable network or use another payment method. Send the failure message shown if problem persists.';

  @override
  String get chatReplyPaymentDefault =>
      'Explain the transaction status or payment method you are having trouble with so I can help.';

  @override
  String get payDeductedLabel => 'Balance deducted';

  @override
  String get payDeductedTitle => 'Balance Deducted';

  @override
  String get payDeductedStatus => 'Processing';

  @override
  String get payDeductedDetail => 'Rp 8.000 deducted, ticket not active';

  @override
  String get payDeductedAdvice =>
      'Check Ticket History after 2 minutes.\nSend help if status doesn\'t change.';

  @override
  String get payDeductedAction => 'Report deducted balance';

  @override
  String get payMissingLabel => 'Ticket missing';

  @override
  String get payMissingTitle => 'Ticket Missing';

  @override
  String get payMissingStatus => 'Success';

  @override
  String get payMissingDetail => 'Payment successful, ticket not showing';

  @override
  String get payMissingAdvice =>
      'Reload My Tickets page.\nIf still empty, send transaction code.';

  @override
  String get payMissingAction => 'Report missing ticket';

  @override
  String get payRefundLabel => 'Refund';

  @override
  String get payRefundTitle => 'Refund';

  @override
  String get payRefundStatus => 'Submitted';

  @override
  String get payRefundDetail => 'Ticket refund';

  @override
  String get payRefundAdvice =>
      'Refund follows last transaction status.\nKeep ticket code until process finishes.';

  @override
  String get payRefundAction => 'Submit refund';

  @override
  String get payMethodLabel => 'Payment method';

  @override
  String get payMethodTitle => 'Payment Method';

  @override
  String get payMethodStatus => 'Failed';

  @override
  String get payMethodDetail => 'Payment method cannot be used';

  @override
  String get payMethodAdvice =>
      'Try another payment method.\nReport if all methods fail.';

  @override
  String get payMethodAction => 'Report payment method';

  @override
  String get payCheckStatusSubtitle => 'Check transaction status';

  @override
  String get payIssueTitle => 'Payment issue';

  @override
  String payActiveIssue(String issue) {
    return 'Active issue: $issue';
  }

  @override
  String get payIssueDescription =>
      'Advice and actions follow the selected issue.';

  @override
  String get payLastTransaction => 'Last transaction';

  @override
  String get paySelectIssue => 'Select issue';

  @override
  String get payQuickAdvice => 'Quick advice';

  @override
  String payHelpPrepared(String issue) {
    return '$issue help prepared successfully.';
  }

  @override
  String get reportScheduleLabel => 'Schedule';

  @override
  String get reportScheduleTitle => 'Report Schedule';

  @override
  String get reportScheduleFirstLabel => 'Related route';

  @override
  String get reportScheduleFirstValue => 'Bogor → Jakarta Kota';

  @override
  String get reportScheduleSecondLabel => 'Location / station';

  @override
  String get reportScheduleSecondValue => 'Bogor';

  @override
  String get reportScheduleDesc => 'App ETA is different from station board.';

  @override
  String get reportScheduleAction => 'Send schedule report';

  @override
  String get reportRouteLabel => 'Route';

  @override
  String get reportRouteTitle => 'Report Route';

  @override
  String get reportRouteFirstLabel => 'Problematic route';

  @override
  String get reportRouteFirstValue => 'Dukuh Atas → Harjamukti';

  @override
  String get reportRouteSecondLabel => 'Route point';

  @override
  String get reportRouteSecondValue => 'Transit station';

  @override
  String get reportRouteDesc =>
      'Displayed route doesn\'t pass the correct transit station.';

  @override
  String get reportRouteAction => 'Send route report';

  @override
  String get reportStationLabel => 'Station';

  @override
  String get reportStationTitle => 'Report Station';

  @override
  String get reportStationFirstLabel => 'Station name';

  @override
  String get reportStationFirstValue => 'Jakarta Kota';

  @override
  String get reportStationSecondLabel => 'Incorrect info';

  @override
  String get reportStationSecondValue => 'Platform / facility';

  @override
  String get reportStationDesc =>
      'Station info doesn\'t match location conditions.';

  @override
  String get reportStationAction => 'Send station report';

  @override
  String get reportSubtitle => 'Correct travel data';

  @override
  String get reportWrongInfo => 'Report wrong info';

  @override
  String reportTypePrefix(String type) {
    return 'Report type: $type';
  }

  @override
  String get reportFieldsDesc => 'Fields follow the selected report type.';

  @override
  String get reportTypeHeading => 'Report type';

  @override
  String get reportDescLabel => 'Report description';

  @override
  String get reportAttachScreenshot => 'Attach screenshot';

  @override
  String get reportAttachScreenshotMsg =>
      'Select screenshot from device to attach.';

  @override
  String reportPrepared(String type) {
    return '$type report prepared successfully.';
  }

  @override
  String get chatOnline => 'Online';

  @override
  String get chatLocalReply => 'Local reply';

  @override
  String get chatToday => 'Today';

  @override
  String get chatUser => 'You';

  @override
  String get chatAgent => 'Staff';

  @override
  String get chatAgentTyping => 'Staff is typing…';

  @override
  String get chatWriteMessage => 'Write a message…';

  @override
  String get chatWaitReply => 'Waiting for staff reply…';

  @override
  String get chatSendMessage => 'Send message';

  @override
  String get activeTicketReadyShare => 'Active ticket code is ready to share.';

  @override
  String get activeTicketTitle => 'Active ticket detail';

  @override
  String get activeTicketShareCode => 'Share code';

  @override
  String get activeTicketNeedHelp => 'Need help';

  @override
  String get activeTicketOfflineOnly =>
      'Ticket data is only saved on this device.';

  @override
  String get activeTicketStatus => 'Active';

  @override
  String get activeTicketCodeTitle => 'Active ticket code';

  @override
  String get activeTicketShowToStaff => 'Show this code to staff';

  @override
  String activeTicketCodeSemantic(String code) {
    return 'Active ticket code $code';
  }

  @override
  String get activeTicketSavedOffline => 'Saved offline';

  @override
  String get ticketStationOrigin => 'Origin station';

  @override
  String get ticketStationDest => 'Destination';

  @override
  String get ticketStationDestFull => 'Destination station';

  @override
  String get ticketEta => 'Estimated arrival';

  @override
  String get ticketType => 'Ticket type';

  @override
  String get ticketTypeActive => 'Active ticket';

  @override
  String get completedTicketReceiptReady =>
      'Journey receipt prepared successfully.';

  @override
  String get completedTicketTitle => 'Completed ticket detail';

  @override
  String get completedTicketDownload => 'Download receipt';

  @override
  String get completedTicketReport => 'Report issue';

  @override
  String get completedTicketLocalHistory =>
      'Completed details remain in local history.';

  @override
  String get completedTicketStatus => 'Completed';

  @override
  String get completedTicketSummary => 'Journey summary';

  @override
  String get completedTicketDepart => 'Depart';

  @override
  String get completedTicketArrive => 'Arrive';

  @override
  String completedTicketDuration(String minutes) {
    return 'Duration $minutes minutes';
  }

  @override
  String get completedTicketJourneyDone => 'Journey completed';

  @override
  String get completedTicketCode => 'Journey code';

  @override
  String get completedTicketTypeLocal => 'Local ticket';

  @override
  String get actionBack => 'Back';

  @override
  String get departureDetailTitle => 'Departure Detail';

  @override
  String get departureFinalDestination => 'Final Destination';

  @override
  String get departureArrivingIn => 'Arriving In';

  @override
  String get departurePlatformNumber => 'Platform Number';

  @override
  String departurePlatform(String platform) {
    return 'Platform $platform';
  }

  @override
  String get departureStatusNormal =>
      'Train operating normally. Priority facilities available in carriages 3 and 4.';

  @override
  String get departureNextStations => 'Next Stations';

  @override
  String departureArriveAt(String platform) {
    return 'Arrive at $platform';
  }

  @override
  String get departurePromoBadge => 'PROMO';

  @override
  String get departurePromoTitle => '50% Off Intercity Train Tickets';

  @override
  String get departurePromoDesc =>
      'Buy homecoming tickets now and get a special discount using KAI Pay.';

  @override
  String durationMinutes(String minutes) {
    return '$minutes Minutes';
  }

  @override
  String stationTransit(String station) {
    return '$station (Transit)';
  }

  @override
  String get mapSearchHint => 'Search station or favorite';

  @override
  String get mapSubtitleLrtKrl => 'LRT Jabodebek · KRL integration access';

  @override
  String get mapSubtitleKrlTransit => 'KRL · Main transit';

  @override
  String get mapSubtitleKrl => 'KRL Jabodetabek';

  @override
  String get mapSubtitleLrt => 'LRT Jabodebek';

  @override
  String get mapActionFrom => 'From';

  @override
  String get mapActionVia => 'Via';

  @override
  String get mapActionTo => 'To';

  @override
  String get mapActionInfo => 'Info';

  @override
  String get mapLegendTitle => 'Main Route Legend';

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
  String get mapLegendLrtJakarta => 'South Jakarta LRT';

  @override
  String get trainTypesJakarta => 'KRL · LRT · MRT Jakarta';

  @override
  String departFromStation(String station) {
    return 'Departing from $station';
  }

  @override
  String get estimatedArrival => 'Estimated Arrival';

  @override
  String get alarmActiveSemantics => 'Travel alarm active, tap to disable';

  @override
  String get alarmInactiveSemantics => 'Activate travel alarm';

  @override
  String get alarmActiveTooltip => 'Alarm active';

  @override
  String get alarmInactiveTooltip => 'Activate alarm';

  @override
  String get alarmDisableBoth =>
      'Train arrival and alighting/transit reminders will be disabled.';

  @override
  String get alarmDisableDeparture =>
      'Train arrival reminder will be disabled.';

  @override
  String get alarmDisableDestination =>
      'Alighting or transit reminder will be disabled.';

  @override
  String get alarmDisableNone => 'No active travel reminders.';

  @override
  String get alarmDisableTitle => 'Disable travel alarm?';

  @override
  String get alarmDisableAction => 'Disable alarm';

  @override
  String get alarmSetupTitle => 'Activate travel reminder?';

  @override
  String routeFromTo(String from, String to) {
    return '$from to $to';
  }

  @override
  String get alarmDepartureSemantics => 'Train arrival reminder';

  @override
  String get alarmDepartureTitle => 'Train arrival';

  @override
  String get alarmDepartureDesc => 'Remind me 5 minutes and 1 minute before';

  @override
  String get alarmDestinationSemantics => 'Alighting or transit reminder';

  @override
  String get alarmDestinationTitle => 'Alight or transit';

  @override
  String get alarmDestinationDesc => 'Remind me 1 station before destination';

  @override
  String get alarmSimulationNote =>
      'These reminders are a simulation and active while the app is open.';

  @override
  String get alarmActivateBtn => 'Activate alarm';

  @override
  String get actionSkip => 'Skip';

  @override
  String get stateActive => 'active';

  @override
  String get stateInactive => 'inactive';

  @override
  String get alarmDepartureActive => 'Train arrival active';

  @override
  String get alarmDepartureInactive => 'Train arrival inactive';

  @override
  String get alarmDestinationActive => 'Alight or transit active';

  @override
  String get alarmDestinationInactive => 'Alight or transit inactive';

  @override
  String get viewTicketBtn => 'View ticket';

  @override
  String get cancelAlarmBtn => 'Cancel alarm';

  @override
  String get assistantChatAssistant => 'Assistant';

  @override
  String get assistantTypeMessage => 'Type a message for Assistant';

  @override
  String get assistantSendMessage => 'Send message';

  @override
  String get assistantUseThisRoute => 'Use this route';

  @override
  String get assistantRepeat => 'Repeat';

  @override
  String get assistantCancel => 'Cancel';

  @override
  String get assistantBuyTicketToUseAlarm =>
      'Buy or select an active ticket to use the travel alarm.';

  @override
  String get assistantSearchTrip => 'Search trip';

  @override
  String assistantOpenQuickAction(String action) {
    return 'Open $action';
  }

  @override
  String get assistantRetry => 'Retry';

  @override
  String get assistantUnknownDestination =>
      'I couldn\'t understand your destination.';

  @override
  String assistantDemoTranscript(String destination, String origin) {
    return 'I want to go to $destination from $origin.';
  }

  @override
  String get assistantDemoResponse =>
      'The fastest route takes 7 minutes. The train arrives in 5 minutes.';

  @override
  String get assistantUnavailable =>
      'The assistant is unavailable. Try again or check official station information.';

  @override
  String get assistantUnknownCommand =>
      'I couldn\'t understand that command. Try: “When is my next alarm?” or “Enable all my ticket alarms.”';

  @override
  String get assistantNoActiveTicket => 'No active ticket';

  @override
  String get assistantNoActiveAlarm => 'No active alarm.';

  @override
  String get assistantAllAlarmsCancelled => 'All travel alarms were cancelled.';

  @override
  String get assistantDestinationAlarmAlreadyOff =>
      'The destination alarm is already off.';

  @override
  String get assistantDestinationAlarmDisabled =>
      'The destination alarm was disabled.';

  @override
  String get assistantAllAlarmsActive => 'All travel alarms are active.';

  @override
  String travelAlarmTrainArrivesIn(int minutes) {
    return 'Train arrives in $minutes minutes';
  }

  @override
  String get travelAlarmNoActive => 'No active alarm';

  @override
  String travelAlarmExitAt(String destination, int stations) {
    return 'Alight at $destination, $stations stations remaining';
  }

  @override
  String travelAlarmTransferAt(String station, int stations) {
    return 'Transfer at $station, $stations stations remaining';
  }

  @override
  String get travelAlarmDestinationFallback => 'destination';

  @override
  String get assistantCameraGuideAction => 'Camera Guide';

  @override
  String assistantMessageSemantics(String sender, String message) {
    return '$sender, $message';
  }

  @override
  String get voiceTapToSpeak => 'Tap to speak';

  @override
  String get voiceWhereToToday => 'Where to today?';

  @override
  String get voiceStartConversation => 'Start voice conversation';

  @override
  String get voiceListening => 'Listening';

  @override
  String get voicePleaseStateDestination => 'Please state your destination';

  @override
  String get voiceStopConversation => 'Stop voice conversation';

  @override
  String get voiceProcessingRequest => 'Processing request';

  @override
  String get voiceSearchingForTrips => 'Searching for suitable travel options';

  @override
  String get voiceRequestBeingProcessed => 'Request is being processed';

  @override
  String get voiceAgentSpeaking => 'Agent is speaking';

  @override
  String get voiceReadingAnswer => 'Travel answer is being read';

  @override
  String get voiceStopAssistant => 'Stop assistant voice';

  @override
  String get voiceNeedsConfirmation => 'Needs confirmation';

  @override
  String get voiceChooseActionBeforeRoute =>
      'Choose an action before opening route';

  @override
  String get voiceStartNewConversation => 'Start new conversation';

  @override
  String get voiceUseVoiceOrQuickAction => 'Use voice or choose quick action.';

  @override
  String get voiceRetryConversation => 'Try voice conversation again';

  @override
  String homeNextTrainFrom(String station) {
    return 'Next train from $station';
  }

  @override
  String get homeClose => 'Close';

  @override
  String homeShowAll(int count) {
    return 'Show All ($count)';
  }

  @override
  String homeTravelDuration(String duration) {
    return 'Travel $duration';
  }

  @override
  String homePlatform(String platform) {
    return 'Platform $platform';
  }

  @override
  String homeDestination(String destination) {
    return 'Destination $destination';
  }

  @override
  String homeArrivingIn(String duration) {
    return 'Arriving in $duration';
  }

  @override
  String get homeAtStation => 'at station';

  @override
  String homeStationFacilities(String station) {
    return 'Station Facilities $station';
  }

  @override
  String homeStationInformation(String station) {
    return 'Station Information $station';
  }

  @override
  String get homeConstructionType => 'Construction Type';

  @override
  String get homeConstructionTypeDesc =>
      'Elevated Station · Accessibility Friendly';

  @override
  String get homeOperationalHours => 'Operational Hours';

  @override
  String get homeOperationalHoursDesc => '05:00 - 23:30 WIB (Open Everyday)';

  @override
  String get homeTicketServices => 'Ticket Services';

  @override
  String get homeTicketServicesDesc =>
      'E-Money Card, KMT, QRIS, & Vending Machine';

  @override
  String get homeAccessibilityFeatures => 'Accessibility Features';

  @override
  String get homeAccessibilityFeaturesDesc =>
      'Guiding Block, Special Ramp, & TTS Audio Announcements';

  @override
  String get homeExitGateGuide => 'Exit Gate Guide';

  @override
  String get homeExitNorth => 'Gate A (North)';

  @override
  String get homeExitNorthDesc => 'Main Access Main Road / Kebon Sirih';

  @override
  String get homeExitNorthIntegration =>
      'TransJakarta & Busway Stop Integration';

  @override
  String get homeExitSouth => 'Gate B (South)';

  @override
  String get homeExitSouthDesc => 'Srikaya Road & Commercial Area Access';

  @override
  String get homeExitSouthIntegration =>
      'Online Motorcycle Taxi Drop-off & Vehicle Parking';

  @override
  String get homeCustomerServiceHeader => 'Customer Service & Assistance';

  @override
  String homeCSStation(String station) {
    return 'Customer Service Station $station';
  }

  @override
  String get homeContactCenter => 'Contact Center: 121 / (021) 121';

  @override
  String get homeWhatsApp => 'Accessibility WhatsApp: +62 811-1211-121';

  @override
  String get homeCallCSBtn => 'Call CS';

  @override
  String homeCallCSSnackbar(String station) {
    return 'Calling CS Station $station (121)...';
  }

  @override
  String get homeAskHelpBtn => 'Ask for Help';

  @override
  String homeAskHelpSnackbar(String station) {
    return 'Assistance request for staff at $station has been sent!';
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
  String get homeFilterBogor => 'Bogor & Nambo Line';

  @override
  String get homeFilterCikarang => 'Cikarang Line';

  @override
  String get homeFilterRangkas => 'Rangkasbitung Line';

  @override
  String get homeFilterTangerang => 'Tangerang Line';

  @override
  String get homeFilterPriok => 'Tanjung Priok Line';

  @override
  String get homeFilterMRTNorthSouth => 'North - South MRT Line';

  @override
  String get homeFilterLRTBekasi => 'Bekasi Line';

  @override
  String get homeFilterLRTCibubur => 'Cibubur Line';

  @override
  String get homeFilterLRTPegangsaan => 'Pegangsaan Dua - Velodrome Line';

  @override
  String get actionRetry => 'Try Again';

  @override
  String get homeAreaCentral => 'Central Jakarta';

  @override
  String get homeAreaSouth => 'South Jakarta';

  @override
  String get homeAreaWest => 'West Jakarta';

  @override
  String get homeAreaEast => 'East Jakarta';

  @override
  String get homeAreaNorth => 'North Jakarta';

  @override
  String get homeAreaGreaterJakarta => 'Greater Jakarta (surrounding cities)';

  @override
  String mapNearStation(String station) {
    return 'You are near $station Station';
  }

  @override
  String get mapNearestMarkerNote =>
      'The blue marker shows the nearest station point, not your exact GPS position on the schematic map.';

  @override
  String get mapLocateMe => 'Find my location';

  @override
  String get routePreviewTitle => 'Journey Preview';

  @override
  String get routePreviewUnavailable => 'The line preview is unavailable.';

  @override
  String get routePreviewLineTitle => 'Journey Line Preview';

  @override
  String routeCurrentLocation(String station) {
    return 'You Are Here: $station';
  }

  @override
  String get routeDimmedLinesNote =>
      'Other lines are dimmed to make the journey route easier to see.';

  @override
  String get routeBackToResults => 'Back to journey results';

  @override
  String get routeShowLineMap => 'View Line on Map';

  @override
  String get routeColdStartHint =>
      'If the free server has just started, wait for the cold start and try again.';

  @override
  String routeSummarySemantics(int minutes, int stops, String fare) {
    return '$minutes minutes, $stops stations, fare $fare';
  }

  @override
  String routeTransferCount(int count) {
    return '$count transfers';
  }

  @override
  String get routeVoiceGuide => 'Journey voice guidance';

  @override
  String routeFromStation(String station) {
    return 'From $station';
  }

  @override
  String routeToStation(String station) {
    return 'To $station';
  }

  @override
  String get routeLiveEta => 'Live ETA';

  @override
  String get routeFocusJourney => 'Focus Journey';

  @override
  String get routeAllLines => 'All Lines';

  @override
  String get stationLoadError =>
      'The server is starting or the connection was interrupted. Station data could not be loaded.';

  @override
  String get ticketSelectedTrip => 'Selected journey';

  @override
  String get ticketPaymentConfirmation =>
      'The ticket becomes active only after Xendit confirms payment with the server.';

  @override
  String get ticketOpenPayment => 'Open payment';

  @override
  String get ticketCheckStatus => 'Check status';

  @override
  String ticketOwnerEmail(String email) {
    return 'Email: $email';
  }

  @override
  String get ticketGateInstruction => 'Show this code at the gate';

  @override
  String ticketDepartureAt(String time) {
    return 'Departs $time';
  }

  @override
  String get ticketDeviceHeader => 'Showing tickets from this device';

  @override
  String ticketDeviceSemantics(String count) {
    return 'Showing tickets from this device, $count';
  }

  @override
  String get ticketEmailHeader => 'Showing tickets for';

  @override
  String ticketEmailSemantics(String email) {
    return 'Showing tickets for $email';
  }

  @override
  String get ticketPartialHistoryError =>
      'Some ticket history could not be loaded';

  @override
  String get ticketEmptyCategory => 'No tickets in this category.';

  @override
  String get ticketShowHistory => 'Show history';

  @override
  String get ticketReload => 'Reload tickets';

  @override
  String get ticketBackToList => 'Back to ticket list';

  @override
  String scheduleStatusUpcoming(int minutes) {
    return 'Departs in $minutes minutes';
  }

  @override
  String get scheduleStatusSoon => 'Departing soon';

  @override
  String get scheduleStatusNow => 'Departing now';

  @override
  String get scheduleStatusPassed => 'Schedule passed';

  @override
  String get scheduleStatusUnavailable => 'Schedule status unavailable';

  @override
  String get scheduleStatusDisclaimer =>
      'Status is based on the schedule, not the live train position';

  @override
  String get scheduleServerActive => 'Server is starting';

  @override
  String get scheduleBackendError =>
      'The backend connection is still starting or was interrupted. Try again without treating the schedule as empty.';

  @override
  String get scheduleDatasetNote =>
      'Commuter Line schedule for February 2026 · automatic status based on the schedule (not real-time KAI)';

  @override
  String get actionRepeat => 'Repeat';

  @override
  String get actionPause => 'Pause';

  @override
  String get actionStop => 'Stop';

  @override
  String get facilityAccessibleLift => 'Accessible Lift';

  @override
  String get facilityEscalator => 'Escalator';

  @override
  String get facilityPrayerRoom => 'Prayer Room';

  @override
  String get facilityAccessibleToilet => 'Accessible Toilet';

  @override
  String get facilityCharger => 'Charger';

  @override
  String get facilityMinimarket => 'Minimarket';

  @override
  String get facilityNursingRoom => 'Nursing Room';

  @override
  String get facilityAtmCenter => 'ATM Center';

  @override
  String get mapLocationServiceDisabled =>
      'Turn on the device location service, then try again.';

  @override
  String get mapLocationPermissionDenied =>
      'Location permission is required to find the nearest station.';

  @override
  String get stationVoiceEmpty => 'No stations match your search.';

  @override
  String stationVoiceFound(int count) {
    return 'Found $count stations. Top results:';
  }

  @override
  String routeNarrationSummary(
    String from,
    String to,
    int minutes,
    String currency,
    String fare,
  ) {
    return 'Route from $from to $to. Estimated travel time is $minutes minutes. Fare is $currency $fare.';
  }

  @override
  String get ticketStatusPending => 'Not paid';

  @override
  String get ticketStatusPaid => 'Paid';

  @override
  String get ticketStatusUsed => 'Used';

  @override
  String get ticketStatusExpired => 'Expired';

  @override
  String get ticketStatusCancelled => 'Cancelled';

  @override
  String get ticketStatusUnknown => 'Unknown';

  @override
  String get travelAlarmInactive => 'Travel alarm is not active';

  @override
  String get routeLoadError =>
      'Unable to load the route. Check your connection and try again.';

  @override
  String get routeNoTransit => 'No transfers';

  @override
  String get ticketEmailInputLabel => 'Email for tickets and history';
}
