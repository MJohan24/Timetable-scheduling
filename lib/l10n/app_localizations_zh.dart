// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get languagePageTitle => '语言';

  @override
  String get languagePageSubtitle => '当前使用的语言';

  @override
  String get languageApp => '应用程序语言';

  @override
  String get languageDescription => '选择应用程序导航和消息的语言';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get languageIndonesianDesc => '使用印度尼西亚语作为应用标签';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishDesc => '使用英文作为应用标签';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageSimplifiedChineseDesc => '使用简体中文作为应用标签';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageArabicDesc => '使用阿拉伯语作为应用标签';

  @override
  String get preview => '预览';

  @override
  String get previewAccount => '帐户';

  @override
  String get previewGuestActive => '访客模式已激活';

  @override
  String get applyLanguage => '应用语言';

  @override
  String get languageAppliedNote => '更改会立即生效，并保存供下次使用。';

  @override
  String get languageAppliedSnackbar => '语言已应用。';

  @override
  String get languageSaveFailedSnackbar => '此会话的语言已更改，但无法保存您的首选项。';

  @override
  String get profileAccount => '帐户';

  @override
  String get profileGuestModeActive => '访客模式已激活';

  @override
  String get profileGuest => '客人';

  @override
  String get profileGuestDesc => '地图、ETA、时间表和门票无需登录。';

  @override
  String get profileOptionalLogin => '可选登录';

  @override
  String get profileLocalTicketHistory => '当地门票历史记录';

  @override
  String get profileSavedOnDevice => '已保存在此设备上';

  @override
  String get profileAccessibility => '无障碍';

  @override
  String get profileLargeText => '大文本和阅读路线';

  @override
  String get profileBlindGuide => '盲人向导';

  @override
  String get profileBlindGuideDescription => '打开摄像头并自动启用语音引导';

  @override
  String get cameraGuideActiveAnnouncement => '摄像头向导已启用。请将摄像头朝向前方。';

  @override
  String get cameraGuideTitle => '相机向导';

  @override
  String get cameraGuideBack => '返回';

  @override
  String cameraGuideStatus(String status) {
    return '相机状态：$status';
  }

  @override
  String get cameraGuideStateLoading => '加载中';

  @override
  String get cameraGuideStateActive => '已启用';

  @override
  String get cameraGuideStatePermissionDenied => '需要权限';

  @override
  String get cameraGuideStateOffline => '离线';

  @override
  String get cameraGuideStateError => '错误';

  @override
  String get cameraGuideStateStopped => '已停止';

  @override
  String get cameraGuidePermissionRequired => '需要相机权限。如果之前已永久拒绝，请在设置中启用。';

  @override
  String get cameraGuideSafetyWarning => '检测结果可能有误。请使用手杖、由他人陪同或向工作人员求助。';

  @override
  String get cameraGuideRetry => '重试';

  @override
  String get cameraGuideStart => '启动向导';

  @override
  String get cameraGuideStop => '停止向导';

  @override
  String get cameraGuideLoadingMessage => '正在准备相机…';

  @override
  String get cameraGuideActiveMessage => '请将相机朝向前方。向导已启用。';

  @override
  String get cameraGuideUnavailableMessage => '无法使用相机。';

  @override
  String get cameraGuideOfflineMessage => '本地检测能力有限；AI 连接不可用。';

  @override
  String get cameraGuideStoppedMessage => '相机向导已停止。';

  @override
  String get cameraGuideNoClearObject => '前方尚未检测到清晰物体。';

  @override
  String cameraGuideObjectCount(int count) {
    return '前方检测到 $count 个物体。';
  }

  @override
  String cameraGuideLabelsDetected(String labels) {
    return '前方检测到 $labels。';
  }

  @override
  String get profileHelpCenter => '帮助中心';

  @override
  String get profileContactOfficer => '联系官员并报告错误';

  @override
  String get authSignInTitle => '登录';

  @override
  String get authSignInSubtitle => '账户为可选项。登录后可同步个人资料和车票记录。';

  @override
  String get authRegisterTitle => '创建账户';

  @override
  String get authRegisterSubtitle => '注册不会影响访客查看时刻表、查询路线和购票。';

  @override
  String get authName => '姓名';

  @override
  String get authEmail => '电子邮箱';

  @override
  String get authPhoneOptional => '手机号码（可选）';

  @override
  String get authPassword => '密码';

  @override
  String get authPasswordConfirmation => '确认密码';

  @override
  String get authEmailInvalid => '请输入有效的电子邮箱地址。';

  @override
  String get authNameRequired => '姓名至少需要 2 个字符。';

  @override
  String get authPasswordMin => '密码至少需要 8 个字符。';

  @override
  String get authPasswordMismatch => '两次输入的密码不一致。';

  @override
  String get authShowPassword => '显示密码';

  @override
  String get authHidePassword => '隐藏密码';

  @override
  String get authSubmitLogin => '登录';

  @override
  String get authSubmitRegister => '注册';

  @override
  String get authCreateAccount => '还没有账户？立即注册';

  @override
  String get authBackToLogin => '已有账户？登录';

  @override
  String get authGuestStillAvailable => '无需账户，您仍可查看时刻表、查询路线并以访客身份购票。';

  @override
  String get authInvalidCredentials => '电子邮箱或密码不正确。';

  @override
  String get authEmailUsed => '此电子邮箱已注册。';

  @override
  String get authNetworkError => '无法连接服务器。请检查网络后重试。';

  @override
  String get authGenericError => '无法处理请求，请重试。';

  @override
  String get profileSignedIn => '账户已启用';

  @override
  String get profileOfflineSession => '账户已保存 · 当前离线';

  @override
  String get profileOfflineHint => '恢复连接后即可使用部分更改。';

  @override
  String get profileEdit => '编辑个人资料';

  @override
  String get profileLogout => '退出登录';

  @override
  String get profileLogoutConfirm => '要在此设备上退出吗？访客功能仍可使用。';

  @override
  String get profileCancel => '取消';

  @override
  String get profileAccountTicketHistory => '账户车票记录';

  @override
  String get profileSyncedAccount => '已与此账户同步';

  @override
  String get editProfileTitle => '编辑个人资料';

  @override
  String get saveChanges => '保存更改';

  @override
  String get navHome => '首页';

  @override
  String get navSchedule => '时刻表';

  @override
  String get navTickets => '车票';

  @override
  String get navAssistant => '助手';

  @override
  String get navAccount => '帐户';

  @override
  String get filterArea => '区域过滤器';

  @override
  String get areaJabodetabek => 'Greater Jakarta Area';

  @override
  String get filterAreaComingSoon => '特定区域过滤器即将推出';

  @override
  String get filterLine => '运输线路过滤器';

  @override
  String get searchStationHint => '输入车站名称、线路或区域';

  @override
  String startFrom(String station) {
    return '开始于：$station';
  }

  @override
  String get selectedStation => '所选车站';

  @override
  String get from => '从';

  @override
  String get to => '到';

  @override
  String get selectFromFirst => '请先选择起始站（From）！';

  @override
  String get nearestDepartures => '最近的出发地';

  @override
  String get allStations => '所有车站';

  @override
  String get all => '全部';

  @override
  String get selectOriginStation => '选择始发站';

  @override
  String get searchStationHint2 => '搜索电台名称（例如，Manggarai、Halim...）';

  @override
  String get weekday => '工作日';

  @override
  String get weekend => '周末';

  @override
  String get trainSchedule => '列车时刻表';

  @override
  String get searchDestinationHint => '搜索目的地车站或火车号码...';

  @override
  String get filterOriginAll => '始发站过滤器（所有站）';

  @override
  String originStation(String station) {
    return '始发站：$station';
  }

  @override
  String get scheduleNotFound => '未找到时间表';

  @override
  String get tryChangingFilter => '尝试更换电台或日过滤器。';

  @override
  String get alarmActivated => '旅行警报已启动';

  @override
  String get alarmDeactivated => '旅行警报已停用';

  @override
  String get tickets => '门票';

  @override
  String get validUntil => '有效期至23:59';

  @override
  String get payBefore => '23:59前付款';

  @override
  String get usedToday => '今天使用，09:12';

  @override
  String get unpaid => '未付';

  @override
  String get active => '积极的';

  @override
  String get completed => '完全的';

  @override
  String get travelTicket => '旅游票';

  @override
  String ticketStatusSummary(int active, int pending, int completed) {
    return '$active 有效票 · $pending 未付款 · $completed 已完成';
  }

  @override
  String get notPaid => '未付款';

  @override
  String get alreadyUsed => '已使用';

  @override
  String get readyToScan => '准备扫描';

  @override
  String get payNow => '立即付款';

  @override
  String get detail => '细节';

  @override
  String get viewQR => '查看QR';

  @override
  String get ticketAlreadyUsed => '这张票已经被使用过。';

  @override
  String get qrValidUntil => 'QR 有效期至';

  @override
  String get choosePayment => '选择付款方式';

  @override
  String get qrisDesc => '没有账户，全是电子钱包';

  @override
  String get creditCard => '借记卡/信用卡';

  @override
  String get virtualAccount => 'VA/转移';

  @override
  String get vaDesc => '一次性付款代码';

  @override
  String get optionalContact => '可选电话/电子邮件';

  @override
  String get optionalContactDesc => '仅用于发送门票副本。没有创建帐户。';

  @override
  String payAmount(String amount) {
    return '支付$amount';
  }

  @override
  String get paymentSuccess => '付款成功';

  @override
  String get scanQrAtGate => '在入口处扫描QR。';

  @override
  String get validGateInBefore => '之前登机有效';

  @override
  String get today2359 => '今天 23:59';

  @override
  String get withoutAccount => '没有账户';

  @override
  String get guest => '客人';

  @override
  String get ticketSaved => '门票已保存至手机图库！';

  @override
  String get saveTicket => '保存门票';

  @override
  String get sharingTicketLink => '分享门票链接...';

  @override
  String get share => '分享';

  @override
  String get a11yQrInfo => 'A11Y：QR 有备用文本代码供工作人员协助。';

  @override
  String get assistantReady => '准备好提供帮助';

  @override
  String get assistantListening => '听力';

  @override
  String get assistantProcessing => '加工';

  @override
  String get assistantSpeaking => '请讲';

  @override
  String get assistantWaiting => '等待确认';

  @override
  String get assistantError => '需要再试一次';

  @override
  String get voiceStart => '开始语音对话';

  @override
  String get voiceStop => '停止语音对话';

  @override
  String get voiceProcessing => '请求正在处理中';

  @override
  String get voiceStopSpeaking => '停止助手声音';

  @override
  String get voiceNew => '开始新的对话';

  @override
  String get voiceRetry => '再次尝试语音对话';

  @override
  String get quickActions => '快速行动';

  @override
  String get planTrip => '计划一次旅行';

  @override
  String get nextTrain => '下一趟列车';

  @override
  String get myTickets => '我的车票';

  @override
  String get officerHelp => '工作人员协助';

  @override
  String get travelAssistant => '旅行助理';

  @override
  String assistantStatusLabel(String status) {
    return '助理状态：$status';
  }

  @override
  String get wakeWordMode => '唤醒词模式 Hello Assistant';

  @override
  String get inactive => '不活跃的';

  @override
  String get listenWakeWord => '聆听“你好助理”';

  @override
  String get wakeWordActiveText => '唤醒词激活';

  @override
  String get wakeWordPageOnly => '仅在此页面有效';

  @override
  String get back => '后退';

  @override
  String get selectDestination => '选择目的地车站';

  @override
  String get searchStationTitle => '搜寻站';

  @override
  String startTripFrom(String station) {
    return '行程起点：$station';
  }

  @override
  String get serviceFilter => '服务过滤器';

  @override
  String get accessible => '无障碍';

  @override
  String get quickResults => '快速见效';

  @override
  String get stationNotFound => '找不到车站';

  @override
  String get stationVoiceGuide => '语音导览';

  @override
  String get stationVoiceGuideStop => '停止语音导览';

  @override
  String get stationVoiceGuideError => '语音导览暂不可用，请重试。';

  @override
  String get withoutLogin => '没有登录';

  @override
  String get favoriteHistoryLocal => '收藏夹和历史记录保存在设备本地。';

  @override
  String get routeGuideTitle => '旅程路线指南';

  @override
  String get fastest => '最快';

  @override
  String get minTransit => '分钟过境次数';

  @override
  String get travelEstimate => '行程预估';

  @override
  String get minutesOnly => '分钟';

  @override
  String stopsAndService(int stops, String serviceInfo) {
    return '$stops 停止 · $serviceInfo';
  }

  @override
  String get travelFare => '旅行费用';

  @override
  String get routeTimeline => '路线时间表';

  @override
  String exitGateInfo(String to) {
    return '出口信息：$to';
  }

  @override
  String buyTicketDirect(String fare) {
    return '直接买票 ($fare)';
  }

  @override
  String readRouteToast(String from, String to, int travelTime) {
    return '从$from到$to的读取路线：持续时间$travelTime分钟。';
  }

  @override
  String get readRouteBtn => '读取路线';

  @override
  String get viewOnMapBtn => '在地图上查看';

  @override
  String a11yAudioRoute(String from, String to, int travelTime, int stops) {
    return 'A11Y 音频：将 $from 路由到 $to（$travelTime 分钟，$stops 停止）。';
  }

  @override
  String get nextTrainLive => '下一趟列车（实时直播）';

  @override
  String get noTripNeeded => '无需出差';

  @override
  String get sameOriginDest => '出发地和目的地是相同的。';

  @override
  String get alreadyAtDest => '您已经到达目的地车站了。';

  @override
  String get minuteShort => '分钟';

  @override
  String lineNoTransit(String lineName) {
    return '$lineName·无中转';
  }

  @override
  String boardLineFrom(String lineName, String from) {
    return '从$from站搭乘$lineName';
  }

  @override
  String get departureTime => '出发：上午 08:35';

  @override
  String platformDirection(int platform, String to) {
    return '平台$platform · 走向$to';
  }

  @override
  String directTripTo(String to, int stops) {
    return '直达$to（$stops站）';
  }

  @override
  String estDuration(int duration) {
    return '预计最小 $duration';
  }

  @override
  String skipStops(int stops) {
    return '直接跳过$stops站';
  }

  @override
  String arriveAtDest(String to) {
    return '到达目的地$to';
  }

  @override
  String totalDuration(int duration) {
    return '总计 $duration 分钟';
  }

  @override
  String get elevatedStation => '高架车站';

  @override
  String gateA(String gate) {
    return 'A 门（北）：$gate';
  }

  @override
  String gateB(String gate) {
    return 'B 门（南）：$gate';
  }

  @override
  String get mainAccessGate => '主要道路通道和 TransJakarta 集成';

  @override
  String get dropOffGate => 'Ojek 在线还车、出租车站和停车场';

  @override
  String oneTransitAt(String station) {
    return '1 次转机 · 在 $station 换乘';
  }

  @override
  String alightAt(String station, int stops) {
    return '$station站（$stops站）下车';
  }

  @override
  String prepareTransitAt(String station) {
    return '$station站换乘准备';
  }

  @override
  String transitToLine(String station, String line) {
    return '$station中转：转至$line平台';
  }

  @override
  String get transitPlatform1To2 => '由1号月台转乘至2号月台（无障碍升降机及导引台）';

  @override
  String boardLineTo(String line, String to, int stops) {
    return '搭乘$line前往$to站（$stops站）';
  }

  @override
  String nextTrainAtPlatform(int minutes, int platform) {
    return '下一趟列车在 $minutes 分钟后抵达站台 $platform';
  }

  @override
  String get a11yReadingPreview => '读取：Dukuh Atas 至 Harjamukti，2 号站台，4 分钟内到达。';

  @override
  String get a11yTitle => '无障碍';

  @override
  String get a11ySubtitle => '文字和语音';

  @override
  String get a11yDisplaySettings => '显示设置';

  @override
  String get a11yMakeEasier => '让应用程序更易于阅读和聆听';

  @override
  String get a11yLargeText => '大文字';

  @override
  String get a11yLargeTextDesc => '放大标签和路线信息';

  @override
  String get a11yReadRoute => '读取路线';

  @override
  String get a11yReadRouteDesc => '启用车站和方向读取';

  @override
  String get a11yRoutePreviewSemantic =>
      '路线预览。 Dukuh Atas 至 Harjamukti。 2号站台，4分钟后到达。';

  @override
  String get a11yRoutePreviewTitle => '路线预览';

  @override
  String get a11yRoutePreviewRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get a11yRoutePreviewDetail => '2号站台，4分钟到达';

  @override
  String get a11yReadBtn => '读';

  @override
  String get historyCleared => '已从此设备中清除票证历史记录。';

  @override
  String get historyTitle => '门票历史记录';

  @override
  String get historyCompleted => '历史完成';

  @override
  String get historySubtitle => '已保存在此设备上';

  @override
  String get historyLastTicket => '最后一张票';

  @override
  String get historySortRecent => '按最近旅行排序';

  @override
  String get historyKrl => 'KRL Commuter Line';

  @override
  String get historyKrlRoute => 'Bogor → Jakarta Kota';

  @override
  String get historyKrlDate => '今天 08:12';

  @override
  String get historyLrt => 'LRT Jabodebek';

  @override
  String get historyLrtRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get historyLrtDate => '星期二, 7 七月 2026';

  @override
  String get historyGuestMode => '访客模式';

  @override
  String get historyGuestDesc => '该历史记录仅存在于该设备上。';

  @override
  String get historyNoTickets => '还没有购票记录';

  @override
  String get historyClearHistory => '清除历史记录';

  @override
  String get historyClearDesc => '从此设备中删除数据。';

  @override
  String get helpTopicBuyTicket => '如何购买当地门票';

  @override
  String get helpTopicBuyTicketDesc => 'KRL 和 LRT 指南';

  @override
  String get helpTopicScheduleIssue => '时间表或 ETA 不匹配';

  @override
  String get helpTopicScheduleIssueDesc => '从路线详细信息发送报告';

  @override
  String get helpTopicPaymentIssue => '付款问题';

  @override
  String get helpTopicPaymentIssueDesc => '查看最后交易状态';

  @override
  String get helpCenterTitle => '帮助中心';

  @override
  String get helpCenterSubtitle => '联系工作人员和报告';

  @override
  String get helpSearchHint => '搜索帮助、车站或车票';

  @override
  String get helpQuickActions => '快速行动';

  @override
  String get helpQuickActionsDesc => '选择常用帮助';

  @override
  String get helpChatStaff => '与工作人员聊天';

  @override
  String get helpReportInfo => '报告错误信息';

  @override
  String get helpTopicsTitle => '帮助主题';

  @override
  String get helpNoTopicsFound => '未找到帮助主题。';

  @override
  String get helpCallKaiSnack => '通过121联系KAI。';

  @override
  String get helpCallKai => '联系方式KAI：121';

  @override
  String get chatLiveHelp => '现场协助';

  @override
  String get chatWithStaff => '与工作人员聊天';

  @override
  String chatActiveTopic(String topic) {
    return '活跃主题：$topic';
  }

  @override
  String get chatContentTailored => '根据您的选择定制聊天内容。';

  @override
  String get chatServiceStatus => '服务状态';

  @override
  String get chatWaitEstimate => '当前等待估计';

  @override
  String get chatSelectTopic => '选择主题';

  @override
  String get chatInitialMessage => '初始消息';

  @override
  String get chatSharedData => '共享数据';

  @override
  String chatReceivedData(String data) {
    return '已收到的数据：\n$data';
  }

  @override
  String get issueLateEtaTitle => '已晚 ETA';

  @override
  String get issueLateEtaLabel => '已晚 ETA';

  @override
  String get issueLateEtaActive => 'ETA 迟到了';

  @override
  String get issueLateEtaRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueLateEtaRouteDetail => '应用程序ETA：09:32';

  @override
  String get issueLateEtaNote => '车站牌显示 09:40。';

  @override
  String get issueLateEtaGuidance => '校正有助于 ETA 这条路线的准确性。';

  @override
  String get issueLateEtaAction => '发送ETA修正';

  @override
  String get issueMissingTrainTitle => '失踪的火车';

  @override
  String get issueMissingTrainLabel => '失踪的火车';

  @override
  String get issueMissingTrainActive => '火车没有出现';

  @override
  String get issueMissingTrainRoute => '勿加泗 → Manggarai';

  @override
  String get issueMissingTrainRouteDetail => '最近的火车未显示';

  @override
  String get issueMissingTrainNote => '在车站可以看到火车，但在应用程序中看不到。';

  @override
  String get issueMissingTrainGuidance => '报告完成出发数据。';

  @override
  String get issueMissingTrainAction => '报告失踪火车';

  @override
  String get issueChangedScheduleTitle => '更改时间表';

  @override
  String get issueChangedScheduleLabel => '时间表已更改';

  @override
  String get issueChangedScheduleActive => '时间表已更改';

  @override
  String get issueChangedScheduleRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get issueChangedScheduleRouteDetail => '应用时间表：15:18';

  @override
  String get issueChangedScheduleNote => '车站时刻表改为15:30。';

  @override
  String get issueChangedScheduleGuidance => '报告有助于安排同步。';

  @override
  String get issueChangedScheduleAction => '发送日程变更';

  @override
  String get issueDiffPlatformTitle => '不同平台';

  @override
  String get issueDiffPlatformLabel => '不同平台';

  @override
  String get issueDiffPlatformActive => '不同平台';

  @override
  String get issueDiffPlatformRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueDiffPlatformRouteDetail => '应用平台：平台2';

  @override
  String get issueDiffPlatformNote => '工作人员引导乘客前往4号站台。';

  @override
  String get issueDiffPlatformGuidance => '报告有助于修复平台信息。';

  @override
  String get issueDiffPlatformAction => '发送平台修正';

  @override
  String get issueReportMismatch => '报告不匹配';

  @override
  String get issueScheduleAndEta => '时间表 & ETA';

  @override
  String issueActiveProblem(String problem) {
    return '活跃问题：$problem';
  }

  @override
  String get issueDetailFollows => '报告详细信息遵循所选问题。';

  @override
  String get issueMonitoredRoute => '监控路线';

  @override
  String get issueProblemOccurred => '出现问题';

  @override
  String get issueNotes => '笔记';

  @override
  String issueCorrectionPrepared(String problem) {
    return '$problem 的更正准备成功。';
  }

  @override
  String get topicTicketLabel => '票';

  @override
  String get topicTicketTitle => '票务聊天';

  @override
  String get topicTicketAgent => '售票人员';

  @override
  String get topicTicketAvailability => '有售票人员';

  @override
  String get topicTicketWait => '通常2分钟内回复';

  @override
  String get topicTicketOpening => '我需要机票方面的帮助';

  @override
  String get topicTicketShared => '访客模式、票证 ID 和最后路线';

  @override
  String get topicTicketSampleData =>
      '车票代码：TKT-20260827-001\n路线：Manggarai – Tanah Abang\n出行日期：2026年8月27日\n状态：有效';

  @override
  String get topicTicketAction => '开始票务聊天';

  @override
  String get topicTicketGreeting => '大家好，我是票务服务部的 Rani。我收到了您的票证数据。您想检查什么？';

  @override
  String get topicScheduleLabel => '日程';

  @override
  String get topicScheduleTitle => '安排聊天';

  @override
  String get topicScheduleAgent => '安排人员';

  @override
  String get topicScheduleAvailability => '安排可用人员';

  @override
  String get topicScheduleWait => '通常3分钟内回复';

  @override
  String get topicScheduleOpening => '我需要日程安排或 ETA 方面的帮助';

  @override
  String get topicScheduleShared => '最后路线、出发地、目的地、行程时间';

  @override
  String get topicScheduleSampleData =>
      '出发站：Manggarai\n目的地：Jakarta Kota\n列车编号：KA 1184\n发车时间：10:25 WIB\n站台：3';

  @override
  String get topicScheduleAction => '开始安排聊天';

  @override
  String get topicScheduleGreeting =>
      '大家好，我是日程服务部的迪马斯。我看到了你的路线。您想查看哪个时间表或 ETA？';

  @override
  String get topicPaymentLabel => '支付';

  @override
  String get topicPaymentTitle => '付款聊天';

  @override
  String get topicPaymentAgent => '付款人员';

  @override
  String get topicPaymentAvailability => '付款人员可用';

  @override
  String get topicPaymentWait => '通常在 4 分钟内回复';

  @override
  String get topicPaymentOpening => '我需要门票付款方面的帮助';

  @override
  String get topicPaymentShared => '最后交易状态、票证代码和时间';

  @override
  String get topicPaymentSampleData =>
      '交易编号：TRX-20260827-001\n方式：QRIS\n金额：Rp7.800\n时间：2026年8月27日 10:20 WIB\n状态：成功';

  @override
  String get topicPaymentAction => '开始付款聊天';

  @override
  String get topicPaymentGreeting => '大家好，我是支付服务部门的 Sari。我收到了您的交易状态。有什么问题吗？';

  @override
  String get chatReplyTicketNotFound =>
      '好的，我帮忙查一下。尝试打开“我的票证”并重新加载页面。如果票证仍未出现，请在此处发送您的票证代码。';

  @override
  String get chatReplyTicketBuy =>
      '要购买车票，请从主页选择路线，设置行程，然后继续付款。付款成功后，门票将出现在门票菜单中。';

  @override
  String get chatReplyTicketActive => '可以从“票证”菜单打开有效票证。在登机口扫描之前，确保 QR 代码清晰可见。';

  @override
  String get chatReplyTicketDefault => '我已准备好帮助检查您的机票。解释您遇到问题的票证状态或步骤。';

  @override
  String get chatReplyScheduleLate => 'ETA可以改变跟车位置。让我知道您的路线和车站，以便我帮助匹配最新信息。';

  @override
  String get chatReplySchedulePlatform =>
      '站台信息可能会在车站发生变化。遵循工作人员公告，如果应用程序信息不同，请发送电台名称。';

  @override
  String get chatReplyScheduleMissing => '我会帮忙记下失踪的火车。发送车站、目的地和预计出发时间。';

  @override
  String get chatReplyScheduleDefault => '请发送您要查询的路线、车站和行车时间。';

  @override
  String get chatReplyPaymentDeducted =>
      '如果余额已扣除但票证未激活，请等待两分钟，然后检查票证历史记录。如果状态未更改，则发送交易代码。';

  @override
  String get chatReplyPaymentRefund => '我会帮忙查看退款情况。发送交易代码和退款请求原因。';

  @override
  String get chatReplyPaymentFailed =>
      '请使用稳定的网络重试或使用其他付款方式。如果问题仍然存在，请发送显示的失败消息。';

  @override
  String get chatReplyPaymentDefault => '请解释您遇到问题的交易状态或付款方式，以便我可以提供帮助。';

  @override
  String get payDeductedLabel => '扣除余额';

  @override
  String get payDeductedTitle => '扣除余额';

  @override
  String get payDeductedStatus => '处理中';

  @override
  String get payDeductedDetail => '扣除 Rp 8.000，门票未激活';

  @override
  String get payDeductedAdvice => '2 分钟后查看票证历史记录。\n如果状态没有改变，请发送帮助。';

  @override
  String get payDeductedAction => '报告扣除余额';

  @override
  String get payMissingLabel => '票不见了';

  @override
  String get payMissingTitle => '票丢失';

  @override
  String get payMissingStatus => '成功';

  @override
  String get payMissingDetail => '支付成功，票未显示';

  @override
  String get payMissingAdvice => '重新加载“我的门票”页面。\n如果仍为空，则发送交易代码。';

  @override
  String get payMissingAction => '报告遗失车票';

  @override
  String get payRefundLabel => '退款';

  @override
  String get payRefundTitle => '退款';

  @override
  String get payRefundStatus => '已提交';

  @override
  String get payRefundDetail => '退票';

  @override
  String get payRefundAdvice => '退款遵循最后的交易状态。\n保留票证代码直至流程完成。';

  @override
  String get payRefundAction => '提交退款';

  @override
  String get payMethodLabel => '付款方式';

  @override
  String get payMethodTitle => '付款方式';

  @override
  String get payMethodStatus => '失败的';

  @override
  String get payMethodDetail => '无法使用付款方式';

  @override
  String get payMethodAdvice => '尝试其他付款方式。\n如果所有方法均失败，请报告。';

  @override
  String get payMethodAction => '报告付款方式';

  @override
  String get payCheckStatusSubtitle => '检查交易状态';

  @override
  String get payIssueTitle => '付款问题';

  @override
  String payActiveIssue(String issue) {
    return '活跃问题：$issue';
  }

  @override
  String get payIssueDescription => '建议和行动遵循选定的问题。';

  @override
  String get payLastTransaction => '最后一笔交易';

  @override
  String get paySelectIssue => '选择问题';

  @override
  String get payQuickAdvice => '快速建议';

  @override
  String payHelpPrepared(String issue) {
    return '$issue 帮助准备成功。';
  }

  @override
  String get reportScheduleLabel => '日程';

  @override
  String get reportScheduleTitle => '报告时间表';

  @override
  String get reportScheduleFirstLabel => '相关路线';

  @override
  String get reportScheduleFirstValue => 'Bogor → Jakarta Kota';

  @override
  String get reportScheduleSecondLabel => '地点/车站';

  @override
  String get reportScheduleSecondValue => 'Bogor';

  @override
  String get reportScheduleDesc => '应用程序ETA与站板不同。';

  @override
  String get reportScheduleAction => '发送日程报告';

  @override
  String get reportRouteLabel => '路线';

  @override
  String get reportRouteTitle => '举报路线';

  @override
  String get reportRouteFirstLabel => '有问题的路线';

  @override
  String get reportRouteFirstValue => 'Dukuh Atas → Harjamukti';

  @override
  String get reportRouteSecondLabel => '路线点';

  @override
  String get reportRouteSecondValue => '中转站';

  @override
  String get reportRouteDesc => '显示的路线未经过正确的公交站。';

  @override
  String get reportRouteAction => '发送路线报告';

  @override
  String get reportStationLabel => '车站';

  @override
  String get reportStationTitle => '报告站';

  @override
  String get reportStationFirstLabel => '站名';

  @override
  String get reportStationFirstValue => 'Jakarta Kota';

  @override
  String get reportStationSecondLabel => '信息不正确';

  @override
  String get reportStationSecondValue => '平台/设施';

  @override
  String get reportStationDesc => '车站信息与位置条件不匹配。';

  @override
  String get reportStationAction => '发送站报告';

  @override
  String get reportSubtitle => '正确的旅行数据';

  @override
  String get reportWrongInfo => '报告错误信息';

  @override
  String reportTypePrefix(String type) {
    return '报告类型：$type';
  }

  @override
  String get reportFieldsDesc => '字段遵循所选的报告类型。';

  @override
  String get reportTypeHeading => '报告类型';

  @override
  String get reportDescLabel => '报告说明';

  @override
  String get reportAttachScreenshot => '附上截图';

  @override
  String get reportAttachScreenshotMsg => '选择要附加的设备屏幕截图。';

  @override
  String reportPrepared(String type) {
    return '$type 报告准备成功。';
  }

  @override
  String get chatOnline => '在线的';

  @override
  String get chatLocalReply => '本地回复';

  @override
  String get chatToday => '今天';

  @override
  String get chatUser => '你';

  @override
  String get chatAgent => '职员';

  @override
  String get chatAgentTyping => '工作人员正在打字……';

  @override
  String get chatWriteMessage => '写留言...';

  @override
  String get chatWaitReply => '等待工作人员回复...';

  @override
  String get chatSendMessage => '发送消息';

  @override
  String get activeTicketReadyShare => '有效票证代码已准备好分享。';

  @override
  String get activeTicketTitle => '有效票证详细信息';

  @override
  String get activeTicketShareCode => '分享代码';

  @override
  String get activeTicketNeedHelp => '需要帮助';

  @override
  String get activeTicketOfflineOnly => '票证数据仅保存在此设备上。';

  @override
  String get activeTicketStatus => '积极的';

  @override
  String get activeTicketCodeTitle => '有效票证代码';

  @override
  String get activeTicketShowToStaff => '向工作人员出示此代码';

  @override
  String activeTicketCodeSemantic(String code) {
    return '有效票证代码 $code';
  }

  @override
  String get activeTicketSavedOffline => '离线保存';

  @override
  String get ticketStationOrigin => '始发站';

  @override
  String get ticketStationDest => '目的地';

  @override
  String get ticketStationDestFull => '目的地站';

  @override
  String get ticketEta => '预计抵达';

  @override
  String get ticketType => '门票类型';

  @override
  String get ticketTypeActive => '有效票证';

  @override
  String get completedTicketReceiptReady => '旅程收据已成功准备。';

  @override
  String get completedTicketTitle => '已完成的票证详细信息';

  @override
  String get completedTicketDownload => '下载收据';

  @override
  String get completedTicketReport => '报告问题';

  @override
  String get completedTicketLocalHistory => '完整的细节保留在当地历史中。';

  @override
  String get completedTicketStatus => '已完成';

  @override
  String get completedTicketSummary => '旅程总结';

  @override
  String get completedTicketDepart => '出发';

  @override
  String get completedTicketArrive => '到达';

  @override
  String completedTicketDuration(String minutes) {
    return '持续时间 $minutes 分钟';
  }

  @override
  String get completedTicketJourneyDone => '旅程完成';

  @override
  String get completedTicketCode => '旅程代码';

  @override
  String get completedTicketTypeLocal => '当地门票';

  @override
  String get actionBack => '返回';

  @override
  String get departureDetailTitle => '出发详情';

  @override
  String get departureFinalDestination => '最终目的地';

  @override
  String get departureArrivingIn => '抵达';

  @override
  String get departurePlatformNumber => '站台号';

  @override
  String departurePlatform(String platform) {
    return '平台 $platform';
  }

  @override
  String get departureStatusNormal => '列车运行正常。 3 号和 4 号车厢提供优先设施。';

  @override
  String get departureNextStations => '下一站';

  @override
  String departureArriveAt(String platform) {
    return '到达$platform';
  }

  @override
  String get departurePromoBadge => '促销';

  @override
  String get departurePromoTitle => '城际火车票 50% 折扣';

  @override
  String get departurePromoDesc => '立即购买返校票并使用 KAI Pay 获得特别折扣。';

  @override
  String durationMinutes(String minutes) {
    return '$minutes 分钟';
  }

  @override
  String stationTransit(String station) {
    return '$station（中转）';
  }

  @override
  String get mapSearchHint => '搜索电台或收藏夹';

  @override
  String get mapSubtitleLrtKrl => 'LRT Jabodebek·KRL集成接入';

  @override
  String get mapSubtitleKrlTransit => 'KRL · 主要交通';

  @override
  String get mapSubtitleKrl => 'KRL Jabodetabek';

  @override
  String get mapSubtitleLrt => 'LRT Jabodebek';

  @override
  String get mapActionFrom => '从';

  @override
  String get mapActionVia => '通过';

  @override
  String get mapActionTo => '到';

  @override
  String get mapActionInfo => '信息';

  @override
  String get mapLegendTitle => '主要路线图例';

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
  String get mapLegendLrtJakarta => '南Jakarta LRT';

  @override
  String get trainTypesJakarta => 'KRL · LRT · MRT Jakarta';

  @override
  String departFromStation(String station) {
    return '$station 出发';
  }

  @override
  String get estimatedArrival => '预计抵达';

  @override
  String get alarmActiveSemantics => '旅行警报已激活，点击即可禁用';

  @override
  String get alarmInactiveSemantics => '启动旅行警报';

  @override
  String get alarmActiveTooltip => '警报激活';

  @override
  String get alarmInactiveTooltip => '启动警报';

  @override
  String get alarmDisableBoth => '火车到站和下车/过境提醒将被禁用。';

  @override
  String get alarmDisableDeparture => '列车到站提醒将被禁用。';

  @override
  String get alarmDisableDestination => '下车或过境提醒将被禁用。';

  @override
  String get alarmDisableNone => '没有主动旅行提醒。';

  @override
  String get alarmDisableTitle => '禁用旅行警报？';

  @override
  String get alarmDisableAction => '禁用警报';

  @override
  String get alarmSetupTitle => '启动旅行提醒？';

  @override
  String routeFromTo(String from, String to) {
    return '$from 至 $to';
  }

  @override
  String get alarmDepartureSemantics => '火车到站提醒';

  @override
  String get alarmDepartureTitle => '火车到达';

  @override
  String get alarmDepartureDesc => '提前 5 分钟和 1 分钟提醒我';

  @override
  String get alarmDestinationSemantics => '下车或转乘提醒';

  @override
  String get alarmDestinationTitle => '下车或转乘';

  @override
  String get alarmDestinationDesc => '提醒我目的地前 1 站';

  @override
  String get alarmSimulationNote => '这些提醒是模拟的，并且在应用程序打开时处于活动状态。';

  @override
  String get alarmActivateBtn => '启动警报';

  @override
  String get actionSkip => '跳过';

  @override
  String get stateActive => '积极的';

  @override
  String get stateInactive => '不活跃的';

  @override
  String get alarmDepartureActive => '列车到达活动';

  @override
  String get alarmDepartureInactive => '列车到达未激活';

  @override
  String get alarmDestinationActive => '下车或转乘活动';

  @override
  String get alarmDestinationInactive => '下车或转乘无效';

  @override
  String get viewTicketBtn => '查看门票';

  @override
  String get cancelAlarmBtn => '取消闹钟';

  @override
  String get assistantChatAssistant => '助手';

  @override
  String get assistantTypeMessage => '为 Google 助理输入消息';

  @override
  String get assistantSendMessage => '发送消息';

  @override
  String get assistantUseThisRoute => '使用此路线';

  @override
  String get assistantRepeat => '重复';

  @override
  String get assistantCancel => '取消';

  @override
  String get assistantBuyTicketToUseAlarm => '购买或选择有效票证以使用旅行警报。';

  @override
  String get assistantSearchTrip => '搜索行程';

  @override
  String assistantOpenQuickAction(String action) {
    return '打开$action';
  }

  @override
  String get assistantRetry => '重试';

  @override
  String get assistantUnknownDestination => '我不明白您的目的地。';

  @override
  String assistantDemoTranscript(String destination, String origin) {
    return '我想从 $origin 前往 $destination。';
  }

  @override
  String get assistantDemoResponse => '最快路线需要 7 分钟。列车将在 5 分钟后到达。';

  @override
  String get assistantUnavailable => '助手暂时不可用。请重试或查看车站官方信息。';

  @override
  String get assistantVoiceDestinationPrompt => '你好，你想去哪里？';

  @override
  String get assistantVoiceUnavailable => '语音输入不可用。请检查麦克风权限后重试。';

  @override
  String get assistantVoiceNoSpeech => '我没有听到你的目的地。请再说一次。';

  @override
  String get assistantUnknownCommand =>
      '我不明白该指令。请尝试：“下一个提醒是什么时候？”或“启用我车票的所有提醒”。';

  @override
  String get assistantNoActiveTicket => '没有有效车票';

  @override
  String get assistantNoActiveAlarm => '没有启用的提醒。';

  @override
  String get assistantAllAlarmsCancelled => '所有行程提醒均已取消。';

  @override
  String get assistantDestinationAlarmAlreadyOff => '目的地提醒已关闭。';

  @override
  String get assistantDestinationAlarmDisabled => '目的地提醒已停用。';

  @override
  String get assistantAllAlarmsActive => '所有行程提醒均已启用。';

  @override
  String travelAlarmTrainArrivesIn(int minutes) {
    return '列车将在 $minutes 分钟后到达';
  }

  @override
  String get travelAlarmNoActive => '没有启用的提醒';

  @override
  String travelAlarmExitAt(String destination, int stations) {
    return '在 $destination 下车，还有 $stations 站';
  }

  @override
  String travelAlarmTransferAt(String station, int stations) {
    return '在 $station 换乘，还有 $stations 站';
  }

  @override
  String get travelAlarmDestinationFallback => '目的地';

  @override
  String get assistantCameraGuideAction => '相机向导';

  @override
  String assistantMessageSemantics(String sender, String message) {
    return '$sender，$message';
  }

  @override
  String get voiceTapToSpeak => '点击即可说话';

  @override
  String get voiceWhereToToday => '今天去哪儿？';

  @override
  String get voiceStartConversation => '开始语音对话';

  @override
  String get voiceListening => '听力';

  @override
  String get voicePleaseStateDestination => '请注明您的目的地';

  @override
  String get voiceStopConversation => '停止语音对话';

  @override
  String get voiceProcessingRequest => '处理请求';

  @override
  String get voiceSearchingForTrips => '寻找合适的旅行选择';

  @override
  String get voiceRequestBeingProcessed => '请求正在处理中';

  @override
  String get voiceAgentSpeaking => '代理正在发言';

  @override
  String get voiceReadingAnswer => '旅游解答正在阅读中';

  @override
  String get voiceStopAssistant => '停止助手声音';

  @override
  String get voiceNeedsConfirmation => '需要确认';

  @override
  String get voiceChooseActionBeforeRoute => '在打开路线之前选择一个操作';

  @override
  String get voiceStartNewConversation => '开始新的对话';

  @override
  String get voiceUseVoiceOrQuickAction => '使用语音或选择快速操作。';

  @override
  String get voiceRetryConversation => '再次尝试语音对话';

  @override
  String homeNextTrainFrom(String station) {
    return '下一趟列车从 $station 出发';
  }

  @override
  String get homeClose => '关闭';

  @override
  String homeShowAll(int count) {
    return '显示全部 ($count)';
  }

  @override
  String homeTravelDuration(String duration) {
    return '旅行$duration';
  }

  @override
  String homePlatform(String platform) {
    return '平台 $platform';
  }

  @override
  String homeDestination(String destination) {
    return '目的地 $destination';
  }

  @override
  String homeArrivingIn(String duration) {
    return '到达$duration';
  }

  @override
  String get homeAtStation => '在车站';

  @override
  String homeStationFacilities(String station) {
    return '车站设施 $station';
  }

  @override
  String homeStationInformation(String station) {
    return '车站信息 $station';
  }

  @override
  String get homeConstructionType => '建筑类型';

  @override
  String get homeConstructionTypeDesc => '高架车站 · 无障碍设施';

  @override
  String get homeOperationalHours => '营业时间';

  @override
  String get homeOperationalHoursDesc => '05:00 - 23:30 WIB（每天开放）';

  @override
  String get homeTicketServices => '票务服务';

  @override
  String get homeTicketServicesDesc => '电子货币卡、KMT、QRIS 和自动售货机';

  @override
  String get homeAccessibilityFeatures => '辅助功能';

  @override
  String get homeAccessibilityFeaturesDesc => '导向块、特殊坡道和 TTS 音频公告';

  @override
  String get homeExitGateGuide => '出口门指南';

  @override
  String get homeExitNorth => 'A 门（北）';

  @override
  String get homeExitNorthDesc => '主要通道 / Kebon Sirih';

  @override
  String get homeExitNorthIntegration => 'TransJakarta 与母线槽站集成';

  @override
  String get homeExitSouth => 'B 门（南）';

  @override
  String get homeExitSouthDesc => 'Srikaya Road & 商业区通道';

  @override
  String get homeExitSouthIntegration => '在线摩托车出租车还车和停车场';

  @override
  String get homeCustomerServiceHeader => '客户服务与协助';

  @override
  String homeCSStation(String station) {
    return '客户服务站$station';
  }

  @override
  String get homeContactCenter => '联络中心：121 / (021) 121';

  @override
  String get homeWhatsApp => '无障碍 WhatsApp：+62 811-1211-121';

  @override
  String get homeCallCSBtn => '致电客服';

  @override
  String homeCallCSSnackbar(String station) {
    return '呼叫 CS 站 $station (121)...';
  }

  @override
  String get homeAskHelpBtn => '求人';

  @override
  String homeAskHelpSnackbar(String station) {
    return '对 $station 工作人员的协助请求已发送！';
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
  String get homeFilterMRTNorthSouth => '北-South MRT Line';

  @override
  String get homeFilterLRTBekasi => 'Bekasi Line';

  @override
  String get homeFilterLRTCibubur => 'Cibubur Line';

  @override
  String get homeFilterLRTPegangsaan => 'Pegangsaan Dua - Velodrome Line';

  @override
  String get actionRetry => '重试';

  @override
  String get homeAreaCentral => '雅加达中部';

  @override
  String get homeAreaSouth => '雅加达南部';

  @override
  String get homeAreaWest => '雅加达西部';

  @override
  String get homeAreaEast => '雅加达东部';

  @override
  String get homeAreaNorth => '雅加达北部';

  @override
  String get homeAreaGreaterJakarta => '大雅加达（周边城市）';

  @override
  String mapNearStation(String station) {
    return '您位于 $station 站附近';
  }

  @override
  String get mapNearestMarkerNote => '蓝色标记表示最近的车站点，并非您在示意图上的精确 GPS 位置。';

  @override
  String get mapLocateMe => '查找我的位置';

  @override
  String get routePreviewTitle => '行程预览';

  @override
  String get routePreviewUnavailable => '线路预览不可用。';

  @override
  String get routePreviewLineTitle => '行程线路预览';

  @override
  String routeCurrentLocation(String station) {
    return '您在这里：$station';
  }

  @override
  String get routeDimmedLinesNote => '其他线路已变暗，以便更清楚地查看行程路线。';

  @override
  String get routeBackToResults => '返回行程结果';

  @override
  String get routeShowLineMap => '在地图上查看线路';

  @override
  String get routeColdStartHint => '如果免费服务器刚刚启动，请等待冷启动后重试。';

  @override
  String routeSummarySemantics(int minutes, int stops, String fare) {
    return '$minutes 分钟，$stops 站，票价 $fare';
  }

  @override
  String routeTransferCount(int count) {
    return '换乘 $count 次';
  }

  @override
  String get routeVoiceGuide => '行程语音指南';

  @override
  String routeFromStation(String station) {
    return '从 $station';
  }

  @override
  String routeToStation(String station) {
    return '到 $station';
  }

  @override
  String get routeLiveEta => '实时预计到达时间';

  @override
  String get routeFocusJourney => '聚焦行程';

  @override
  String get routeAllLines => '所有线路';

  @override
  String get stationLoadError => '服务器正在启动或连接已中断。无法加载车站数据。';

  @override
  String get ticketSelectedTrip => '已选行程';

  @override
  String get ticketPaymentConfirmation => '只有在 Xendit 向服务器确认付款后，车票才会生效。';

  @override
  String get ticketOpenPayment => '打开付款';

  @override
  String get ticketCheckStatus => '检查状态';

  @override
  String ticketOwnerEmail(String email) {
    return '电子邮件：$email';
  }

  @override
  String get ticketGateInstruction => '请在闸机处出示此代码';

  @override
  String ticketDepartureAt(String time) {
    return '$time 发车';
  }

  @override
  String get ticketDeviceHeader => '显示此设备上的车票';

  @override
  String ticketDeviceSemantics(String count) {
    return '显示此设备上的车票，$count';
  }

  @override
  String get ticketEmailHeader => '显示以下账户的车票';

  @override
  String ticketEmailSemantics(String email) {
    return '显示 $email 的车票';
  }

  @override
  String get ticketPartialHistoryError => '部分车票记录无法加载';

  @override
  String get ticketEmptyCategory => '此类别中没有车票。';

  @override
  String get ticketShowHistory => '显示记录';

  @override
  String get ticketReload => '重新加载车票';

  @override
  String get ticketBackToList => '返回车票列表';

  @override
  String scheduleStatusUpcoming(int minutes) {
    return '$minutes 分钟后发车';
  }

  @override
  String get scheduleStatusSoon => '即将发车';

  @override
  String get scheduleStatusNow => '正在发车';

  @override
  String get scheduleStatusPassed => '班次已过';

  @override
  String get scheduleStatusUnavailable => '班次状态不可用';

  @override
  String get scheduleStatusDisclaimer => '状态基于时刻表，而非列车实时位置';

  @override
  String get scheduleServerActive => '服务器正在启动';

  @override
  String get scheduleBackendError => '后端连接仍在启动或已中断。请重试，不要将时刻表视为空。';

  @override
  String get scheduleDatasetNote =>
      '2026 年 2 月通勤线时刻表 · 状态根据时刻表自动计算（非 KAI 实时数据）';

  @override
  String get actionRepeat => '重复';

  @override
  String get actionPause => '暂停';

  @override
  String get actionStop => '停止';

  @override
  String get facilityAccessibleLift => '无障碍电梯';

  @override
  String get facilityEscalator => '扶梯';

  @override
  String get facilityPrayerRoom => '祈祷室';

  @override
  String get facilityAccessibleToilet => '无障碍洗手间';

  @override
  String get facilityCharger => '充电设施';

  @override
  String get facilityMinimarket => '便利店';

  @override
  String get facilityNursingRoom => '母婴室';

  @override
  String get facilityAtmCenter => 'ATM 中心';

  @override
  String get mapLocationServiceDisabled => '请开启设备定位服务，然后重试。';

  @override
  String get mapLocationPermissionDenied => '需要定位权限才能查找最近的车站。';

  @override
  String get stationVoiceEmpty => '没有符合搜索条件的车站。';

  @override
  String stationVoiceFound(int count) {
    return '找到 $count 个车站。热门结果：';
  }

  @override
  String routeNarrationSummary(
    String from,
    String to,
    int minutes,
    String currency,
    String fare,
  ) {
    return '从 $from 到 $to。预计行程时间 $minutes 分钟。票价为 $currency $fare。';
  }

  @override
  String get ticketStatusPending => '未付款';

  @override
  String get ticketStatusPaid => '已付款';

  @override
  String get ticketStatusUsed => '已使用';

  @override
  String get ticketStatusExpired => '已过期';

  @override
  String get ticketStatusCancelled => '已取消';

  @override
  String get ticketStatusUnknown => '未知';

  @override
  String get travelAlarmInactive => '行程闹钟未启用';

  @override
  String get routeLoadError => '无法加载路线。请检查网络连接后重试。';

  @override
  String get routeNoTransit => '无需换乘';

  @override
  String get ticketEmailInputLabel => '用于车票和历史记录的邮箱';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get languagePageTitle => '语言';

  @override
  String get languagePageSubtitle => '当前使用的语言';

  @override
  String get languageApp => '应用程序语言';

  @override
  String get languageDescription => '选择应用程序导航和消息的语言';

  @override
  String get languageIndonesian => 'Indonesia';

  @override
  String get languageIndonesianDesc => '使用印度尼西亚语作为应用标签';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageEnglishDesc => '使用英文作为应用标签';

  @override
  String get languageSimplifiedChinese => '简体中文';

  @override
  String get languageSimplifiedChineseDesc => '使用简体中文作为应用标签';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageArabicDesc => '使用阿拉伯语作为应用标签';

  @override
  String get preview => '预览';

  @override
  String get previewAccount => '帐户';

  @override
  String get previewGuestActive => '访客模式已激活';

  @override
  String get applyLanguage => '应用语言';

  @override
  String get languageAppliedNote => '更改会立即生效，并保存供下次使用。';

  @override
  String get languageAppliedSnackbar => '语言已应用。';

  @override
  String get languageSaveFailedSnackbar => '此会话的语言已更改，但无法保存您的首选项。';

  @override
  String get profileAccount => '帐户';

  @override
  String get profileGuestModeActive => '访客模式已激活';

  @override
  String get profileGuest => '客人';

  @override
  String get profileGuestDesc => '地图、ETA、时间表和门票无需登录。';

  @override
  String get profileOptionalLogin => '可选登录';

  @override
  String get profileLocalTicketHistory => '当地门票历史记录';

  @override
  String get profileSavedOnDevice => '已保存在此设备上';

  @override
  String get profileAccessibility => '无障碍';

  @override
  String get profileLargeText => '大文本和阅读路线';

  @override
  String get profileBlindGuide => '盲人向导';

  @override
  String get profileBlindGuideDescription => '打开摄像头并自动启用语音引导';

  @override
  String get cameraGuideActiveAnnouncement => '摄像头向导已启用。请将摄像头朝向前方。';

  @override
  String get cameraGuideTitle => '相机向导';

  @override
  String get cameraGuideBack => '返回';

  @override
  String cameraGuideStatus(String status) {
    return '相机状态：$status';
  }

  @override
  String get cameraGuideStateLoading => '加载中';

  @override
  String get cameraGuideStateActive => '已启用';

  @override
  String get cameraGuideStatePermissionDenied => '需要权限';

  @override
  String get cameraGuideStateOffline => '离线';

  @override
  String get cameraGuideStateError => '错误';

  @override
  String get cameraGuideStateStopped => '已停止';

  @override
  String get cameraGuidePermissionRequired => '需要相机权限。如果之前已永久拒绝，请在设置中启用。';

  @override
  String get cameraGuideSafetyWarning => '检测结果可能有误。请使用手杖、由他人陪同或向工作人员求助。';

  @override
  String get cameraGuideRetry => '重试';

  @override
  String get cameraGuideStart => '启动向导';

  @override
  String get cameraGuideStop => '停止向导';

  @override
  String get cameraGuideLoadingMessage => '正在准备相机…';

  @override
  String get cameraGuideActiveMessage => '请将相机朝向前方。向导已启用。';

  @override
  String get cameraGuideUnavailableMessage => '无法使用相机。';

  @override
  String get cameraGuideOfflineMessage => '本地检测能力有限；AI 连接不可用。';

  @override
  String get cameraGuideStoppedMessage => '相机向导已停止。';

  @override
  String get cameraGuideNoClearObject => '前方尚未检测到清晰物体。';

  @override
  String cameraGuideObjectCount(int count) {
    return '前方检测到 $count 个物体。';
  }

  @override
  String cameraGuideLabelsDetected(String labels) {
    return '前方检测到 $labels。';
  }

  @override
  String get profileHelpCenter => '帮助中心';

  @override
  String get profileContactOfficer => '联系官员并报告错误';

  @override
  String get authSignInTitle => '登录';

  @override
  String get authSignInSubtitle => '账户为可选项。登录后可同步个人资料和车票记录。';

  @override
  String get authRegisterTitle => '创建账户';

  @override
  String get authRegisterSubtitle => '注册不会影响访客查看时刻表、查询路线和购票。';

  @override
  String get authName => '姓名';

  @override
  String get authEmail => '电子邮箱';

  @override
  String get authPhoneOptional => '手机号码（可选）';

  @override
  String get authPassword => '密码';

  @override
  String get authPasswordConfirmation => '确认密码';

  @override
  String get authEmailInvalid => '请输入有效的电子邮箱地址。';

  @override
  String get authNameRequired => '姓名至少需要 2 个字符。';

  @override
  String get authPasswordMin => '密码至少需要 8 个字符。';

  @override
  String get authPasswordMismatch => '两次输入的密码不一致。';

  @override
  String get authShowPassword => '显示密码';

  @override
  String get authHidePassword => '隐藏密码';

  @override
  String get authSubmitLogin => '登录';

  @override
  String get authSubmitRegister => '注册';

  @override
  String get authCreateAccount => '还没有账户？立即注册';

  @override
  String get authBackToLogin => '已有账户？登录';

  @override
  String get authGuestStillAvailable => '无需账户，您仍可查看时刻表、查询路线并以访客身份购票。';

  @override
  String get authInvalidCredentials => '电子邮箱或密码不正确。';

  @override
  String get authEmailUsed => '此电子邮箱已注册。';

  @override
  String get authNetworkError => '无法连接服务器。请检查网络后重试。';

  @override
  String get authGenericError => '无法处理请求，请重试。';

  @override
  String get profileSignedIn => '账户已启用';

  @override
  String get profileOfflineSession => '账户已保存 · 当前离线';

  @override
  String get profileOfflineHint => '恢复连接后即可使用部分更改。';

  @override
  String get profileEdit => '编辑个人资料';

  @override
  String get profileLogout => '退出登录';

  @override
  String get profileLogoutConfirm => '要在此设备上退出吗？访客功能仍可使用。';

  @override
  String get profileCancel => '取消';

  @override
  String get profileAccountTicketHistory => '账户车票记录';

  @override
  String get profileSyncedAccount => '已与此账户同步';

  @override
  String get editProfileTitle => '编辑个人资料';

  @override
  String get saveChanges => '保存更改';

  @override
  String get navHome => '首页';

  @override
  String get navSchedule => '时刻表';

  @override
  String get navTickets => '车票';

  @override
  String get navAssistant => '助手';

  @override
  String get navAccount => '帐户';

  @override
  String get filterArea => '区域过滤器';

  @override
  String get areaJabodetabek => 'Greater Jakarta Area';

  @override
  String get filterAreaComingSoon => '特定区域过滤器即将推出';

  @override
  String get filterLine => '运输线路过滤器';

  @override
  String get searchStationHint => '输入车站名称、线路或区域';

  @override
  String startFrom(String station) {
    return '开始于：$station';
  }

  @override
  String get selectedStation => '所选车站';

  @override
  String get from => '从';

  @override
  String get to => '到';

  @override
  String get selectFromFirst => '请先选择起始站（From）！';

  @override
  String get nearestDepartures => '最近的出发地';

  @override
  String get allStations => '所有车站';

  @override
  String get all => '全部';

  @override
  String get selectOriginStation => '选择始发站';

  @override
  String get searchStationHint2 => '搜索电台名称（例如，Manggarai、Halim...）';

  @override
  String get weekday => '工作日';

  @override
  String get weekend => '周末';

  @override
  String get trainSchedule => '列车时刻表';

  @override
  String get searchDestinationHint => '搜索目的地车站或火车号码...';

  @override
  String get filterOriginAll => '始发站过滤器（所有站）';

  @override
  String originStation(String station) {
    return '始发站：$station';
  }

  @override
  String get scheduleNotFound => '未找到时间表';

  @override
  String get tryChangingFilter => '尝试更换电台或日过滤器。';

  @override
  String get alarmActivated => '旅行警报已启动';

  @override
  String get alarmDeactivated => '旅行警报已停用';

  @override
  String get tickets => '门票';

  @override
  String get validUntil => '有效期至23:59';

  @override
  String get payBefore => '23:59前付款';

  @override
  String get usedToday => '今天使用，09:12';

  @override
  String get unpaid => '未付';

  @override
  String get active => '积极的';

  @override
  String get completed => '完全的';

  @override
  String get travelTicket => '旅游票';

  @override
  String ticketStatusSummary(int active, int pending, int completed) {
    return '$active 有效票 · $pending 未付款 · $completed 已完成';
  }

  @override
  String get notPaid => '未付款';

  @override
  String get alreadyUsed => '已使用';

  @override
  String get readyToScan => '准备扫描';

  @override
  String get payNow => '立即付款';

  @override
  String get detail => '细节';

  @override
  String get viewQR => '查看QR';

  @override
  String get ticketAlreadyUsed => '这张票已经被使用过。';

  @override
  String get qrValidUntil => 'QR 有效期至';

  @override
  String get choosePayment => '选择付款方式';

  @override
  String get qrisDesc => '没有账户，全是电子钱包';

  @override
  String get creditCard => '借记卡/信用卡';

  @override
  String get virtualAccount => 'VA/转移';

  @override
  String get vaDesc => '一次性付款代码';

  @override
  String get optionalContact => '可选电话/电子邮件';

  @override
  String get optionalContactDesc => '仅用于发送门票副本。没有创建帐户。';

  @override
  String payAmount(String amount) {
    return '支付$amount';
  }

  @override
  String get paymentSuccess => '付款成功';

  @override
  String get scanQrAtGate => '在入口处扫描QR。';

  @override
  String get validGateInBefore => '之前登机有效';

  @override
  String get today2359 => '今天 23:59';

  @override
  String get withoutAccount => '没有账户';

  @override
  String get guest => '客人';

  @override
  String get ticketSaved => '门票已保存至手机图库！';

  @override
  String get saveTicket => '保存门票';

  @override
  String get sharingTicketLink => '分享门票链接...';

  @override
  String get share => '分享';

  @override
  String get a11yQrInfo => 'A11Y：QR 有备用文本代码供工作人员协助。';

  @override
  String get assistantReady => '准备好提供帮助';

  @override
  String get assistantListening => '听力';

  @override
  String get assistantProcessing => '加工';

  @override
  String get assistantSpeaking => '请讲';

  @override
  String get assistantWaiting => '等待确认';

  @override
  String get assistantError => '需要再试一次';

  @override
  String get voiceStart => '开始语音对话';

  @override
  String get voiceStop => '停止语音对话';

  @override
  String get voiceProcessing => '请求正在处理中';

  @override
  String get voiceStopSpeaking => '停止助手声音';

  @override
  String get voiceNew => '开始新的对话';

  @override
  String get voiceRetry => '再次尝试语音对话';

  @override
  String get quickActions => '快速行动';

  @override
  String get planTrip => '计划一次旅行';

  @override
  String get nextTrain => '下一趟列车';

  @override
  String get myTickets => '我的车票';

  @override
  String get officerHelp => '工作人员协助';

  @override
  String get travelAssistant => '旅行助理';

  @override
  String assistantStatusLabel(String status) {
    return '助理状态：$status';
  }

  @override
  String get wakeWordMode => '唤醒词模式 Hello Assistant';

  @override
  String get inactive => '不活跃的';

  @override
  String get listenWakeWord => '聆听“你好助理”';

  @override
  String get wakeWordActiveText => '唤醒词激活';

  @override
  String get wakeWordPageOnly => '仅在此页面有效';

  @override
  String get back => '后退';

  @override
  String get selectDestination => '选择目的地车站';

  @override
  String get searchStationTitle => '搜寻站';

  @override
  String startTripFrom(String station) {
    return '行程起点：$station';
  }

  @override
  String get serviceFilter => '服务过滤器';

  @override
  String get accessible => '无障碍';

  @override
  String get quickResults => '快速见效';

  @override
  String get stationNotFound => '找不到车站';

  @override
  String get stationVoiceGuide => '语音导览';

  @override
  String get stationVoiceGuideStop => '停止语音导览';

  @override
  String get stationVoiceGuideError => '语音导览暂不可用，请重试。';

  @override
  String get withoutLogin => '没有登录';

  @override
  String get favoriteHistoryLocal => '收藏夹和历史记录保存在设备本地。';

  @override
  String get routeGuideTitle => '旅程路线指南';

  @override
  String get fastest => '最快';

  @override
  String get minTransit => '分钟过境次数';

  @override
  String get travelEstimate => '行程预估';

  @override
  String get minutesOnly => '分钟';

  @override
  String stopsAndService(int stops, String serviceInfo) {
    return '$stops 停止 · $serviceInfo';
  }

  @override
  String get travelFare => '旅行费用';

  @override
  String get routeTimeline => '路线时间表';

  @override
  String exitGateInfo(String to) {
    return '出口信息：$to';
  }

  @override
  String buyTicketDirect(String fare) {
    return '直接买票 ($fare)';
  }

  @override
  String readRouteToast(String from, String to, int travelTime) {
    return '从$from到$to的读取路线：持续时间$travelTime分钟。';
  }

  @override
  String get readRouteBtn => '读取路线';

  @override
  String get viewOnMapBtn => '在地图上查看';

  @override
  String a11yAudioRoute(String from, String to, int travelTime, int stops) {
    return 'A11Y 音频：将 $from 路由到 $to（$travelTime 分钟，$stops 停止）。';
  }

  @override
  String get nextTrainLive => '下一趟列车（实时直播）';

  @override
  String get noTripNeeded => '无需出差';

  @override
  String get sameOriginDest => '出发地和目的地是相同的。';

  @override
  String get alreadyAtDest => '您已经到达目的地车站了。';

  @override
  String get minuteShort => '分钟';

  @override
  String lineNoTransit(String lineName) {
    return '$lineName·无中转';
  }

  @override
  String boardLineFrom(String lineName, String from) {
    return '从$from站搭乘$lineName';
  }

  @override
  String get departureTime => '出发：上午 08:35';

  @override
  String platformDirection(int platform, String to) {
    return '平台$platform · 走向$to';
  }

  @override
  String directTripTo(String to, int stops) {
    return '直达$to（$stops站）';
  }

  @override
  String estDuration(int duration) {
    return '预计最小 $duration';
  }

  @override
  String skipStops(int stops) {
    return '直接跳过$stops站';
  }

  @override
  String arriveAtDest(String to) {
    return '到达目的地$to';
  }

  @override
  String totalDuration(int duration) {
    return '总计 $duration 分钟';
  }

  @override
  String get elevatedStation => '高架车站';

  @override
  String gateA(String gate) {
    return 'A 门（北）：$gate';
  }

  @override
  String gateB(String gate) {
    return 'B 门（南）：$gate';
  }

  @override
  String get mainAccessGate => '主要道路通道和 TransJakarta 集成';

  @override
  String get dropOffGate => 'Ojek 在线还车、出租车站和停车场';

  @override
  String oneTransitAt(String station) {
    return '1 次转机 · 在 $station 换乘';
  }

  @override
  String alightAt(String station, int stops) {
    return '$station站（$stops站）下车';
  }

  @override
  String prepareTransitAt(String station) {
    return '$station站换乘准备';
  }

  @override
  String transitToLine(String station, String line) {
    return '$station中转：转至$line平台';
  }

  @override
  String get transitPlatform1To2 => '由1号月台转乘至2号月台（无障碍升降机及导引台）';

  @override
  String boardLineTo(String line, String to, int stops) {
    return '搭乘$line前往$to站（$stops站）';
  }

  @override
  String nextTrainAtPlatform(int minutes, int platform) {
    return '下一趟列车在 $minutes 分钟后抵达站台 $platform';
  }

  @override
  String get a11yReadingPreview => '读取：Dukuh Atas 至 Harjamukti，2 号站台，4 分钟内到达。';

  @override
  String get a11yTitle => '无障碍';

  @override
  String get a11ySubtitle => '文字和语音';

  @override
  String get a11yDisplaySettings => '显示设置';

  @override
  String get a11yMakeEasier => '让应用程序更易于阅读和聆听';

  @override
  String get a11yLargeText => '大文字';

  @override
  String get a11yLargeTextDesc => '放大标签和路线信息';

  @override
  String get a11yReadRoute => '读取路线';

  @override
  String get a11yReadRouteDesc => '启用车站和方向读取';

  @override
  String get a11yRoutePreviewSemantic =>
      '路线预览。 Dukuh Atas 至 Harjamukti。 2号站台，4分钟后到达。';

  @override
  String get a11yRoutePreviewTitle => '路线预览';

  @override
  String get a11yRoutePreviewRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get a11yRoutePreviewDetail => '2号站台，4分钟到达';

  @override
  String get a11yReadBtn => '读';

  @override
  String get historyCleared => '已从此设备中清除票证历史记录。';

  @override
  String get historyTitle => '门票历史记录';

  @override
  String get historyCompleted => '历史完成';

  @override
  String get historySubtitle => '已保存在此设备上';

  @override
  String get historyLastTicket => '最后一张票';

  @override
  String get historySortRecent => '按最近旅行排序';

  @override
  String get historyKrl => 'KRL Commuter Line';

  @override
  String get historyKrlRoute => 'Bogor → Jakarta Kota';

  @override
  String get historyKrlDate => '今天 08:12';

  @override
  String get historyLrt => 'LRT Jabodebek';

  @override
  String get historyLrtRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get historyLrtDate => '星期二, 7 七月 2026';

  @override
  String get historyGuestMode => '访客模式';

  @override
  String get historyGuestDesc => '该历史记录仅存在于该设备上。';

  @override
  String get historyNoTickets => '还没有购票记录';

  @override
  String get historyClearHistory => '清除历史记录';

  @override
  String get historyClearDesc => '从此设备中删除数据。';

  @override
  String get helpTopicBuyTicket => '如何购买当地门票';

  @override
  String get helpTopicBuyTicketDesc => 'KRL 和 LRT 指南';

  @override
  String get helpTopicScheduleIssue => '时间表或 ETA 不匹配';

  @override
  String get helpTopicScheduleIssueDesc => '从路线详细信息发送报告';

  @override
  String get helpTopicPaymentIssue => '付款问题';

  @override
  String get helpTopicPaymentIssueDesc => '查看最后交易状态';

  @override
  String get helpCenterTitle => '帮助中心';

  @override
  String get helpCenterSubtitle => '联系工作人员和报告';

  @override
  String get helpSearchHint => '搜索帮助、车站或车票';

  @override
  String get helpQuickActions => '快速行动';

  @override
  String get helpQuickActionsDesc => '选择常用帮助';

  @override
  String get helpChatStaff => '与工作人员聊天';

  @override
  String get helpReportInfo => '报告错误信息';

  @override
  String get helpTopicsTitle => '帮助主题';

  @override
  String get helpNoTopicsFound => '未找到帮助主题。';

  @override
  String get helpCallKaiSnack => '通过121联系KAI。';

  @override
  String get helpCallKai => '联系方式KAI：121';

  @override
  String get chatLiveHelp => '现场协助';

  @override
  String get chatWithStaff => '与工作人员聊天';

  @override
  String chatActiveTopic(String topic) {
    return '活跃主题：$topic';
  }

  @override
  String get chatContentTailored => '根据您的选择定制聊天内容。';

  @override
  String get chatServiceStatus => '服务状态';

  @override
  String get chatWaitEstimate => '当前等待估计';

  @override
  String get chatSelectTopic => '选择主题';

  @override
  String get chatInitialMessage => '初始消息';

  @override
  String get chatSharedData => '共享数据';

  @override
  String chatReceivedData(String data) {
    return '已收到的数据：\n$data';
  }

  @override
  String get issueLateEtaTitle => '已晚 ETA';

  @override
  String get issueLateEtaLabel => '已晚 ETA';

  @override
  String get issueLateEtaActive => 'ETA 迟到了';

  @override
  String get issueLateEtaRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueLateEtaRouteDetail => '应用程序ETA：09:32';

  @override
  String get issueLateEtaNote => '车站牌显示 09:40。';

  @override
  String get issueLateEtaGuidance => '校正有助于 ETA 这条路线的准确性。';

  @override
  String get issueLateEtaAction => '发送ETA修正';

  @override
  String get issueMissingTrainTitle => '失踪的火车';

  @override
  String get issueMissingTrainLabel => '失踪的火车';

  @override
  String get issueMissingTrainActive => '火车没有出现';

  @override
  String get issueMissingTrainRoute => '勿加泗 → Manggarai';

  @override
  String get issueMissingTrainRouteDetail => '最近的火车未显示';

  @override
  String get issueMissingTrainNote => '在车站可以看到火车，但在应用程序中看不到。';

  @override
  String get issueMissingTrainGuidance => '报告完成出发数据。';

  @override
  String get issueMissingTrainAction => '报告失踪火车';

  @override
  String get issueChangedScheduleTitle => '更改时间表';

  @override
  String get issueChangedScheduleLabel => '时间表已更改';

  @override
  String get issueChangedScheduleActive => '时间表已更改';

  @override
  String get issueChangedScheduleRoute => 'Dukuh Atas → Harjamukti';

  @override
  String get issueChangedScheduleRouteDetail => '应用时间表：15:18';

  @override
  String get issueChangedScheduleNote => '车站时刻表改为15:30。';

  @override
  String get issueChangedScheduleGuidance => '报告有助于安排同步。';

  @override
  String get issueChangedScheduleAction => '发送日程变更';

  @override
  String get issueDiffPlatformTitle => '不同平台';

  @override
  String get issueDiffPlatformLabel => '不同平台';

  @override
  String get issueDiffPlatformActive => '不同平台';

  @override
  String get issueDiffPlatformRoute => 'Bogor → Jakarta Kota';

  @override
  String get issueDiffPlatformRouteDetail => '应用平台：平台2';

  @override
  String get issueDiffPlatformNote => '工作人员引导乘客前往4号站台。';

  @override
  String get issueDiffPlatformGuidance => '报告有助于修复平台信息。';

  @override
  String get issueDiffPlatformAction => '发送平台修正';

  @override
  String get issueReportMismatch => '报告不匹配';

  @override
  String get issueScheduleAndEta => '时间表 & ETA';

  @override
  String issueActiveProblem(String problem) {
    return '活跃问题：$problem';
  }

  @override
  String get issueDetailFollows => '报告详细信息遵循所选问题。';

  @override
  String get issueMonitoredRoute => '监控路线';

  @override
  String get issueProblemOccurred => '出现问题';

  @override
  String get issueNotes => '笔记';

  @override
  String issueCorrectionPrepared(String problem) {
    return '$problem 的更正准备成功。';
  }

  @override
  String get topicTicketLabel => '票';

  @override
  String get topicTicketTitle => '票务聊天';

  @override
  String get topicTicketAgent => '售票人员';

  @override
  String get topicTicketAvailability => '有售票人员';

  @override
  String get topicTicketWait => '通常2分钟内回复';

  @override
  String get topicTicketOpening => '我需要机票方面的帮助';

  @override
  String get topicTicketShared => '访客模式、票证 ID 和最后路线';

  @override
  String get topicTicketSampleData =>
      '车票代码：TKT-20260827-001\n路线：Manggarai – Tanah Abang\n出行日期：2026年8月27日\n状态：有效';

  @override
  String get topicTicketAction => '开始票务聊天';

  @override
  String get topicTicketGreeting => '大家好，我是票务服务部的 Rani。我收到了您的票证数据。您想检查什么？';

  @override
  String get topicScheduleLabel => '日程';

  @override
  String get topicScheduleTitle => '安排聊天';

  @override
  String get topicScheduleAgent => '安排人员';

  @override
  String get topicScheduleAvailability => '安排可用人员';

  @override
  String get topicScheduleWait => '通常3分钟内回复';

  @override
  String get topicScheduleOpening => '我需要日程安排或 ETA 方面的帮助';

  @override
  String get topicScheduleShared => '最后路线、出发地、目的地、行程时间';

  @override
  String get topicScheduleSampleData =>
      '出发站：Manggarai\n目的地：Jakarta Kota\n列车编号：KA 1184\n发车时间：10:25 WIB\n站台：3';

  @override
  String get topicScheduleAction => '开始安排聊天';

  @override
  String get topicScheduleGreeting =>
      '大家好，我是日程服务部的迪马斯。我看到了你的路线。您想查看哪个时间表或 ETA？';

  @override
  String get topicPaymentLabel => '支付';

  @override
  String get topicPaymentTitle => '付款聊天';

  @override
  String get topicPaymentAgent => '付款人员';

  @override
  String get topicPaymentAvailability => '付款人员可用';

  @override
  String get topicPaymentWait => '通常在 4 分钟内回复';

  @override
  String get topicPaymentOpening => '我需要门票付款方面的帮助';

  @override
  String get topicPaymentShared => '最后交易状态、票证代码和时间';

  @override
  String get topicPaymentSampleData =>
      '交易编号：TRX-20260827-001\n方式：QRIS\n金额：Rp7.800\n时间：2026年8月27日 10:20 WIB\n状态：成功';

  @override
  String get topicPaymentAction => '开始付款聊天';

  @override
  String get topicPaymentGreeting => '大家好，我是支付服务部门的 Sari。我收到了您的交易状态。有什么问题吗？';

  @override
  String get chatReplyTicketNotFound =>
      '好的，我帮忙查一下。尝试打开“我的票证”并重新加载页面。如果票证仍未出现，请在此处发送您的票证代码。';

  @override
  String get chatReplyTicketBuy =>
      '要购买车票，请从主页选择路线，设置行程，然后继续付款。付款成功后，门票将出现在门票菜单中。';

  @override
  String get chatReplyTicketActive => '可以从“票证”菜单打开有效票证。在登机口扫描之前，确保 QR 代码清晰可见。';

  @override
  String get chatReplyTicketDefault => '我已准备好帮助检查您的机票。解释您遇到问题的票证状态或步骤。';

  @override
  String get chatReplyScheduleLate => 'ETA可以改变跟车位置。让我知道您的路线和车站，以便我帮助匹配最新信息。';

  @override
  String get chatReplySchedulePlatform =>
      '站台信息可能会在车站发生变化。遵循工作人员公告，如果应用程序信息不同，请发送电台名称。';

  @override
  String get chatReplyScheduleMissing => '我会帮忙记下失踪的火车。发送车站、目的地和预计出发时间。';

  @override
  String get chatReplyScheduleDefault => '请发送您要查询的路线、车站和行车时间。';

  @override
  String get chatReplyPaymentDeducted =>
      '如果余额已扣除但票证未激活，请等待两分钟，然后检查票证历史记录。如果状态未更改，则发送交易代码。';

  @override
  String get chatReplyPaymentRefund => '我会帮忙查看退款情况。发送交易代码和退款请求原因。';

  @override
  String get chatReplyPaymentFailed =>
      '请使用稳定的网络重试或使用其他付款方式。如果问题仍然存在，请发送显示的失败消息。';

  @override
  String get chatReplyPaymentDefault => '请解释您遇到问题的交易状态或付款方式，以便我可以提供帮助。';

  @override
  String get payDeductedLabel => '扣除余额';

  @override
  String get payDeductedTitle => '扣除余额';

  @override
  String get payDeductedStatus => '处理中';

  @override
  String get payDeductedDetail => '扣除 Rp 8.000，门票未激活';

  @override
  String get payDeductedAdvice => '2 分钟后查看票证历史记录。\n如果状态没有改变，请发送帮助。';

  @override
  String get payDeductedAction => '报告扣除余额';

  @override
  String get payMissingLabel => '票不见了';

  @override
  String get payMissingTitle => '票丢失';

  @override
  String get payMissingStatus => '成功';

  @override
  String get payMissingDetail => '支付成功，票未显示';

  @override
  String get payMissingAdvice => '重新加载“我的门票”页面。\n如果仍为空，则发送交易代码。';

  @override
  String get payMissingAction => '报告遗失车票';

  @override
  String get payRefundLabel => '退款';

  @override
  String get payRefundTitle => '退款';

  @override
  String get payRefundStatus => '已提交';

  @override
  String get payRefundDetail => '退票';

  @override
  String get payRefundAdvice => '退款遵循最后的交易状态。\n保留票证代码直至流程完成。';

  @override
  String get payRefundAction => '提交退款';

  @override
  String get payMethodLabel => '付款方式';

  @override
  String get payMethodTitle => '付款方式';

  @override
  String get payMethodStatus => '失败的';

  @override
  String get payMethodDetail => '无法使用付款方式';

  @override
  String get payMethodAdvice => '尝试其他付款方式。\n如果所有方法均失败，请报告。';

  @override
  String get payMethodAction => '报告付款方式';

  @override
  String get payCheckStatusSubtitle => '检查交易状态';

  @override
  String get payIssueTitle => '付款问题';

  @override
  String payActiveIssue(String issue) {
    return '活跃问题：$issue';
  }

  @override
  String get payIssueDescription => '建议和行动遵循选定的问题。';

  @override
  String get payLastTransaction => '最后一笔交易';

  @override
  String get paySelectIssue => '选择问题';

  @override
  String get payQuickAdvice => '快速建议';

  @override
  String payHelpPrepared(String issue) {
    return '$issue 帮助准备成功。';
  }

  @override
  String get reportScheduleLabel => '日程';

  @override
  String get reportScheduleTitle => '报告时间表';

  @override
  String get reportScheduleFirstLabel => '相关路线';

  @override
  String get reportScheduleFirstValue => 'Bogor → Jakarta Kota';

  @override
  String get reportScheduleSecondLabel => '地点/车站';

  @override
  String get reportScheduleSecondValue => 'Bogor';

  @override
  String get reportScheduleDesc => '应用程序ETA与站板不同。';

  @override
  String get reportScheduleAction => '发送日程报告';

  @override
  String get reportRouteLabel => '路线';

  @override
  String get reportRouteTitle => '举报路线';

  @override
  String get reportRouteFirstLabel => '有问题的路线';

  @override
  String get reportRouteFirstValue => 'Dukuh Atas → Harjamukti';

  @override
  String get reportRouteSecondLabel => '路线点';

  @override
  String get reportRouteSecondValue => '中转站';

  @override
  String get reportRouteDesc => '显示的路线未经过正确的公交站。';

  @override
  String get reportRouteAction => '发送路线报告';

  @override
  String get reportStationLabel => '车站';

  @override
  String get reportStationTitle => '报告站';

  @override
  String get reportStationFirstLabel => '站名';

  @override
  String get reportStationFirstValue => 'Jakarta Kota';

  @override
  String get reportStationSecondLabel => '信息不正确';

  @override
  String get reportStationSecondValue => '平台/设施';

  @override
  String get reportStationDesc => '车站信息与位置条件不匹配。';

  @override
  String get reportStationAction => '发送站报告';

  @override
  String get reportSubtitle => '正确的旅行数据';

  @override
  String get reportWrongInfo => '报告错误信息';

  @override
  String reportTypePrefix(String type) {
    return '报告类型：$type';
  }

  @override
  String get reportFieldsDesc => '字段遵循所选的报告类型。';

  @override
  String get reportTypeHeading => '报告类型';

  @override
  String get reportDescLabel => '报告说明';

  @override
  String get reportAttachScreenshot => '附上截图';

  @override
  String get reportAttachScreenshotMsg => '选择要附加的设备屏幕截图。';

  @override
  String reportPrepared(String type) {
    return '$type 报告准备成功。';
  }

  @override
  String get chatOnline => '在线的';

  @override
  String get chatLocalReply => '本地回复';

  @override
  String get chatToday => '今天';

  @override
  String get chatUser => '你';

  @override
  String get chatAgent => '职员';

  @override
  String get chatAgentTyping => '工作人员正在打字……';

  @override
  String get chatWriteMessage => '写留言...';

  @override
  String get chatWaitReply => '等待工作人员回复...';

  @override
  String get chatSendMessage => '发送消息';

  @override
  String get activeTicketReadyShare => '有效票证代码已准备好分享。';

  @override
  String get activeTicketTitle => '有效票证详细信息';

  @override
  String get activeTicketShareCode => '分享代码';

  @override
  String get activeTicketNeedHelp => '需要帮助';

  @override
  String get activeTicketOfflineOnly => '票证数据仅保存在此设备上。';

  @override
  String get activeTicketStatus => '积极的';

  @override
  String get activeTicketCodeTitle => '有效票证代码';

  @override
  String get activeTicketShowToStaff => '向工作人员出示此代码';

  @override
  String activeTicketCodeSemantic(String code) {
    return '有效票证代码 $code';
  }

  @override
  String get activeTicketSavedOffline => '离线保存';

  @override
  String get ticketStationOrigin => '始发站';

  @override
  String get ticketStationDest => '目的地';

  @override
  String get ticketStationDestFull => '目的地站';

  @override
  String get ticketEta => '预计抵达';

  @override
  String get ticketType => '门票类型';

  @override
  String get ticketTypeActive => '有效票证';

  @override
  String get completedTicketReceiptReady => '旅程收据已成功准备。';

  @override
  String get completedTicketTitle => '已完成的票证详细信息';

  @override
  String get completedTicketDownload => '下载收据';

  @override
  String get completedTicketReport => '报告问题';

  @override
  String get completedTicketLocalHistory => '完整的细节保留在当地历史中。';

  @override
  String get completedTicketStatus => '已完成';

  @override
  String get completedTicketSummary => '旅程总结';

  @override
  String get completedTicketDepart => '出发';

  @override
  String get completedTicketArrive => '到达';

  @override
  String completedTicketDuration(String minutes) {
    return '持续时间 $minutes 分钟';
  }

  @override
  String get completedTicketJourneyDone => '旅程完成';

  @override
  String get completedTicketCode => '旅程代码';

  @override
  String get completedTicketTypeLocal => '当地门票';

  @override
  String get actionBack => '返回';

  @override
  String get departureDetailTitle => '出发详情';

  @override
  String get departureFinalDestination => '最终目的地';

  @override
  String get departureArrivingIn => '抵达';

  @override
  String get departurePlatformNumber => '站台号';

  @override
  String departurePlatform(String platform) {
    return '平台 $platform';
  }

  @override
  String get departureStatusNormal => '列车运行正常。 3 号和 4 号车厢提供优先设施。';

  @override
  String get departureNextStations => '下一站';

  @override
  String departureArriveAt(String platform) {
    return '到达$platform';
  }

  @override
  String get departurePromoBadge => '促销';

  @override
  String get departurePromoTitle => '城际火车票 50% 折扣';

  @override
  String get departurePromoDesc => '立即购买返校票并使用 KAI Pay 获得特别折扣。';

  @override
  String durationMinutes(String minutes) {
    return '$minutes 分钟';
  }

  @override
  String stationTransit(String station) {
    return '$station（中转）';
  }

  @override
  String get mapSearchHint => '搜索电台或收藏夹';

  @override
  String get mapSubtitleLrtKrl => 'LRT Jabodebek·KRL集成接入';

  @override
  String get mapSubtitleKrlTransit => 'KRL · 主要交通';

  @override
  String get mapSubtitleKrl => 'KRL Jabodetabek';

  @override
  String get mapSubtitleLrt => 'LRT Jabodebek';

  @override
  String get mapActionFrom => '从';

  @override
  String get mapActionVia => '通过';

  @override
  String get mapActionTo => '到';

  @override
  String get mapActionInfo => '信息';

  @override
  String get mapLegendTitle => '主要路线图例';

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
  String get mapLegendLrtJakarta => '南Jakarta LRT';

  @override
  String get trainTypesJakarta => 'KRL · LRT · MRT Jakarta';

  @override
  String departFromStation(String station) {
    return '$station 出发';
  }

  @override
  String get estimatedArrival => '预计抵达';

  @override
  String get alarmActiveSemantics => '旅行警报已激活，点击即可禁用';

  @override
  String get alarmInactiveSemantics => '启动旅行警报';

  @override
  String get alarmActiveTooltip => '警报激活';

  @override
  String get alarmInactiveTooltip => '启动警报';

  @override
  String get alarmDisableBoth => '火车到站和下车/过境提醒将被禁用。';

  @override
  String get alarmDisableDeparture => '列车到站提醒将被禁用。';

  @override
  String get alarmDisableDestination => '下车或过境提醒将被禁用。';

  @override
  String get alarmDisableNone => '没有主动旅行提醒。';

  @override
  String get alarmDisableTitle => '禁用旅行警报？';

  @override
  String get alarmDisableAction => '禁用警报';

  @override
  String get alarmSetupTitle => '启动旅行提醒？';

  @override
  String routeFromTo(String from, String to) {
    return '$from 至 $to';
  }

  @override
  String get alarmDepartureSemantics => '火车到站提醒';

  @override
  String get alarmDepartureTitle => '火车到达';

  @override
  String get alarmDepartureDesc => '提前 5 分钟和 1 分钟提醒我';

  @override
  String get alarmDestinationSemantics => '下车或转乘提醒';

  @override
  String get alarmDestinationTitle => '下车或转乘';

  @override
  String get alarmDestinationDesc => '提醒我目的地前 1 站';

  @override
  String get alarmSimulationNote => '这些提醒是模拟的，并且在应用程序打开时处于活动状态。';

  @override
  String get alarmActivateBtn => '启动警报';

  @override
  String get actionSkip => '跳过';

  @override
  String get stateActive => '积极的';

  @override
  String get stateInactive => '不活跃的';

  @override
  String get alarmDepartureActive => '列车到达活动';

  @override
  String get alarmDepartureInactive => '列车到达未激活';

  @override
  String get alarmDestinationActive => '下车或转乘活动';

  @override
  String get alarmDestinationInactive => '下车或转乘无效';

  @override
  String get viewTicketBtn => '查看门票';

  @override
  String get cancelAlarmBtn => '取消闹钟';

  @override
  String get assistantChatAssistant => '助手';

  @override
  String get assistantTypeMessage => '为 Google 助理输入消息';

  @override
  String get assistantSendMessage => '发送消息';

  @override
  String get assistantUseThisRoute => '使用此路线';

  @override
  String get assistantRepeat => '重复';

  @override
  String get assistantCancel => '取消';

  @override
  String get assistantBuyTicketToUseAlarm => '购买或选择有效票证以使用旅行警报。';

  @override
  String get assistantSearchTrip => '搜索行程';

  @override
  String assistantOpenQuickAction(String action) {
    return '打开$action';
  }

  @override
  String get assistantRetry => '重试';

  @override
  String get assistantUnknownDestination => '我不明白您的目的地。';

  @override
  String assistantDemoTranscript(String destination, String origin) {
    return '我想从 $origin 前往 $destination。';
  }

  @override
  String get assistantDemoResponse => '最快路线需要 7 分钟。列车将在 5 分钟后到达。';

  @override
  String get assistantUnavailable => '助手暂时不可用。请重试或查看车站官方信息。';

  @override
  String get assistantVoiceDestinationPrompt => '你好，你想去哪里？';

  @override
  String get assistantVoiceUnavailable => '语音输入不可用。请检查麦克风权限后重试。';

  @override
  String get assistantVoiceNoSpeech => '我没有听到你的目的地。请再说一次。';

  @override
  String get assistantUnknownCommand =>
      '我不明白该指令。请尝试：“下一个提醒是什么时候？”或“启用我车票的所有提醒”。';

  @override
  String get assistantNoActiveTicket => '没有有效车票';

  @override
  String get assistantNoActiveAlarm => '没有启用的提醒。';

  @override
  String get assistantAllAlarmsCancelled => '所有行程提醒均已取消。';

  @override
  String get assistantDestinationAlarmAlreadyOff => '目的地提醒已关闭。';

  @override
  String get assistantDestinationAlarmDisabled => '目的地提醒已停用。';

  @override
  String get assistantAllAlarmsActive => '所有行程提醒均已启用。';

  @override
  String travelAlarmTrainArrivesIn(int minutes) {
    return '列车将在 $minutes 分钟后到达';
  }

  @override
  String get travelAlarmNoActive => '没有启用的提醒';

  @override
  String travelAlarmExitAt(String destination, int stations) {
    return '在 $destination 下车，还有 $stations 站';
  }

  @override
  String travelAlarmTransferAt(String station, int stations) {
    return '在 $station 换乘，还有 $stations 站';
  }

  @override
  String get travelAlarmDestinationFallback => '目的地';

  @override
  String get assistantCameraGuideAction => '相机向导';

  @override
  String assistantMessageSemantics(String sender, String message) {
    return '$sender，$message';
  }

  @override
  String get voiceTapToSpeak => '点击即可说话';

  @override
  String get voiceWhereToToday => '今天去哪儿？';

  @override
  String get voiceStartConversation => '开始语音对话';

  @override
  String get voiceListening => '听力';

  @override
  String get voicePleaseStateDestination => '请注明您的目的地';

  @override
  String get voiceStopConversation => '停止语音对话';

  @override
  String get voiceProcessingRequest => '处理请求';

  @override
  String get voiceSearchingForTrips => '寻找合适的旅行选择';

  @override
  String get voiceRequestBeingProcessed => '请求正在处理中';

  @override
  String get voiceAgentSpeaking => '代理正在发言';

  @override
  String get voiceReadingAnswer => '旅游解答正在阅读中';

  @override
  String get voiceStopAssistant => '停止助手声音';

  @override
  String get voiceNeedsConfirmation => '需要确认';

  @override
  String get voiceChooseActionBeforeRoute => '在打开路线之前选择一个操作';

  @override
  String get voiceStartNewConversation => '开始新的对话';

  @override
  String get voiceUseVoiceOrQuickAction => '使用语音或选择快速操作。';

  @override
  String get voiceRetryConversation => '再次尝试语音对话';

  @override
  String homeNextTrainFrom(String station) {
    return '下一趟列车从 $station 出发';
  }

  @override
  String get homeClose => '关闭';

  @override
  String homeShowAll(int count) {
    return '显示全部 ($count)';
  }

  @override
  String homeTravelDuration(String duration) {
    return '旅行$duration';
  }

  @override
  String homePlatform(String platform) {
    return '平台 $platform';
  }

  @override
  String homeDestination(String destination) {
    return '目的地 $destination';
  }

  @override
  String homeArrivingIn(String duration) {
    return '到达$duration';
  }

  @override
  String get homeAtStation => '在车站';

  @override
  String homeStationFacilities(String station) {
    return '车站设施 $station';
  }

  @override
  String homeStationInformation(String station) {
    return '车站信息 $station';
  }

  @override
  String get homeConstructionType => '建筑类型';

  @override
  String get homeConstructionTypeDesc => '高架车站 · 无障碍设施';

  @override
  String get homeOperationalHours => '营业时间';

  @override
  String get homeOperationalHoursDesc => '05:00 - 23:30 WIB（每天开放）';

  @override
  String get homeTicketServices => '票务服务';

  @override
  String get homeTicketServicesDesc => '电子货币卡、KMT、QRIS 和自动售货机';

  @override
  String get homeAccessibilityFeatures => '辅助功能';

  @override
  String get homeAccessibilityFeaturesDesc => '导向块、特殊坡道和 TTS 音频公告';

  @override
  String get homeExitGateGuide => '出口门指南';

  @override
  String get homeExitNorth => 'A 门（北）';

  @override
  String get homeExitNorthDesc => '主要通道 / Kebon Sirih';

  @override
  String get homeExitNorthIntegration => 'TransJakarta 与母线槽站集成';

  @override
  String get homeExitSouth => 'B 门（南）';

  @override
  String get homeExitSouthDesc => 'Srikaya Road & 商业区通道';

  @override
  String get homeExitSouthIntegration => '在线摩托车出租车还车和停车场';

  @override
  String get homeCustomerServiceHeader => '客户服务与协助';

  @override
  String homeCSStation(String station) {
    return '客户服务站$station';
  }

  @override
  String get homeContactCenter => '联络中心：121 / (021) 121';

  @override
  String get homeWhatsApp => '无障碍 WhatsApp：+62 811-1211-121';

  @override
  String get homeCallCSBtn => '致电客服';

  @override
  String homeCallCSSnackbar(String station) {
    return '呼叫 CS 站 $station (121)...';
  }

  @override
  String get homeAskHelpBtn => '求人';

  @override
  String homeAskHelpSnackbar(String station) {
    return '对 $station 工作人员的协助请求已发送！';
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
  String get homeFilterMRTNorthSouth => '北-South MRT Line';

  @override
  String get homeFilterLRTBekasi => 'Bekasi Line';

  @override
  String get homeFilterLRTCibubur => 'Cibubur Line';

  @override
  String get homeFilterLRTPegangsaan => 'Pegangsaan Dua - Velodrome Line';

  @override
  String get actionRetry => '重试';

  @override
  String get homeAreaCentral => '雅加达中部';

  @override
  String get homeAreaSouth => '雅加达南部';

  @override
  String get homeAreaWest => '雅加达西部';

  @override
  String get homeAreaEast => '雅加达东部';

  @override
  String get homeAreaNorth => '雅加达北部';

  @override
  String get homeAreaGreaterJakarta => '大雅加达（周边城市）';

  @override
  String mapNearStation(String station) {
    return '您位于 $station 站附近';
  }

  @override
  String get mapNearestMarkerNote => '蓝色标记表示最近的车站点，并非您在示意图上的精确 GPS 位置。';

  @override
  String get mapLocateMe => '查找我的位置';

  @override
  String get routePreviewTitle => '行程预览';

  @override
  String get routePreviewUnavailable => '线路预览不可用。';

  @override
  String get routePreviewLineTitle => '行程线路预览';

  @override
  String routeCurrentLocation(String station) {
    return '您在这里：$station';
  }

  @override
  String get routeDimmedLinesNote => '其他线路已变暗，以便更清楚地查看行程路线。';

  @override
  String get routeBackToResults => '返回行程结果';

  @override
  String get routeShowLineMap => '在地图上查看线路';

  @override
  String get routeColdStartHint => '如果免费服务器刚刚启动，请等待冷启动后重试。';

  @override
  String routeSummarySemantics(int minutes, int stops, String fare) {
    return '$minutes 分钟，$stops 站，票价 $fare';
  }

  @override
  String routeTransferCount(int count) {
    return '换乘 $count 次';
  }

  @override
  String get routeVoiceGuide => '行程语音指南';

  @override
  String routeFromStation(String station) {
    return '从 $station';
  }

  @override
  String routeToStation(String station) {
    return '到 $station';
  }

  @override
  String get routeLiveEta => '实时预计到达时间';

  @override
  String get routeFocusJourney => '聚焦行程';

  @override
  String get routeAllLines => '所有线路';

  @override
  String get stationLoadError => '服务器正在启动或连接已中断。无法加载车站数据。';

  @override
  String get ticketSelectedTrip => '已选行程';

  @override
  String get ticketPaymentConfirmation => '只有在 Xendit 向服务器确认付款后，车票才会生效。';

  @override
  String get ticketOpenPayment => '打开付款';

  @override
  String get ticketCheckStatus => '检查状态';

  @override
  String ticketOwnerEmail(String email) {
    return '电子邮件：$email';
  }

  @override
  String get ticketGateInstruction => '请在闸机处出示此代码';

  @override
  String ticketDepartureAt(String time) {
    return '$time 发车';
  }

  @override
  String get ticketDeviceHeader => '显示此设备上的车票';

  @override
  String ticketDeviceSemantics(String count) {
    return '显示此设备上的车票，$count';
  }

  @override
  String get ticketEmailHeader => '显示以下账户的车票';

  @override
  String ticketEmailSemantics(String email) {
    return '显示 $email 的车票';
  }

  @override
  String get ticketPartialHistoryError => '部分车票记录无法加载';

  @override
  String get ticketEmptyCategory => '此类别中没有车票。';

  @override
  String get ticketShowHistory => '显示记录';

  @override
  String get ticketReload => '重新加载车票';

  @override
  String get ticketBackToList => '返回车票列表';

  @override
  String scheduleStatusUpcoming(int minutes) {
    return '$minutes 分钟后发车';
  }

  @override
  String get scheduleStatusSoon => '即将发车';

  @override
  String get scheduleStatusNow => '正在发车';

  @override
  String get scheduleStatusPassed => '班次已过';

  @override
  String get scheduleStatusUnavailable => '班次状态不可用';

  @override
  String get scheduleStatusDisclaimer => '状态基于时刻表，而非列车实时位置';

  @override
  String get scheduleServerActive => '服务器正在启动';

  @override
  String get scheduleBackendError => '后端连接仍在启动或已中断。请重试，不要将时刻表视为空。';

  @override
  String get scheduleDatasetNote =>
      '2026 年 2 月通勤线时刻表 · 状态根据时刻表自动计算（非 KAI 实时数据）';

  @override
  String get actionRepeat => '重复';

  @override
  String get actionPause => '暂停';

  @override
  String get actionStop => '停止';

  @override
  String get facilityAccessibleLift => '无障碍电梯';

  @override
  String get facilityEscalator => '扶梯';

  @override
  String get facilityPrayerRoom => '祈祷室';

  @override
  String get facilityAccessibleToilet => '无障碍洗手间';

  @override
  String get facilityCharger => '充电设施';

  @override
  String get facilityMinimarket => '便利店';

  @override
  String get facilityNursingRoom => '母婴室';

  @override
  String get facilityAtmCenter => 'ATM 中心';

  @override
  String get mapLocationServiceDisabled => '请开启设备定位服务，然后重试。';

  @override
  String get mapLocationPermissionDenied => '需要定位权限才能查找最近的车站。';

  @override
  String get stationVoiceEmpty => '没有符合搜索条件的车站。';

  @override
  String stationVoiceFound(int count) {
    return '找到 $count 个车站。热门结果：';
  }

  @override
  String routeNarrationSummary(
    String from,
    String to,
    int minutes,
    String currency,
    String fare,
  ) {
    return '从 $from 到 $to。预计行程时间 $minutes 分钟。票价为 $currency $fare。';
  }

  @override
  String get ticketStatusPending => '未付款';

  @override
  String get ticketStatusPaid => '已付款';

  @override
  String get ticketStatusUsed => '已使用';

  @override
  String get ticketStatusExpired => '已过期';

  @override
  String get ticketStatusCancelled => '已取消';

  @override
  String get ticketStatusUnknown => '未知';

  @override
  String get travelAlarmInactive => '行程闹钟未启用';

  @override
  String get routeLoadError => '无法加载路线。请检查网络连接后重试。';

  @override
  String get routeNoTransit => '无需换乘';

  @override
  String get ticketEmailInputLabel => '用于车票和历史记录的邮箱';
}
