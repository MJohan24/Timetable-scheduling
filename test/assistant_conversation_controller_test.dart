import 'package:flutter_test/flutter_test.dart';
import 'package:timetable/features/assistant/domain/entities/assistant_conversation_item.dart';
import 'package:timetable/features/assistant/domain/repositories/assistant_chat_repository.dart';
import 'package:timetable/features/assistant/presentation/controllers/assistant_conversation_controller.dart';
import 'package:timetable/features/travel_alarm/presentation/controllers/travel_alarm_controller.dart';

class _CapturingChatRepository implements AssistantChatRepository {
  String? message;
  List<AssistantChatTurn> history = const [];
  String? lang;

  @override
  Future<AssistantChatAnswer> ask(
    String value, {
    List<AssistantChatTurn> history = const [],
    String? lang,
  }) async {
    message = value;
    this.history = history;
    this.lang = lang;
    return const AssistantChatAnswer(reply: 'Siap, mau ke stasiun mana?');
  }
}

void main() {
  test('typed command activates every alarm and appends ordered messages', () {
    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai');
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('Aktifkan semua alarm tiket saya');

    expect(chat.items.first.author, AssistantMessageAuthor.user);
    expect(chat.items.first.text, 'Aktifkan semua alarm tiket saya');
    expect(chat.items.last.kind, AssistantConversationItemKind.alarmStatus);
    expect(alarms.state.departureAlarmEnabled, isTrue);
    expect(alarms.state.destinationAlarmEnabled, isTrue);
  });

  test('arrival and next-alarm questions report the current countdown', () {
    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai')
      ..configureAlarms(departure: true, destination: true);
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('Kereta saya datang berapa menit lagi?');
    expect(chat.items.last.text, 'Kereta datang 5 menit lagi');

    chat.submitText('Alarm berikutnya kapan?');
    expect(chat.items.last.text, 'Kereta datang 5 menit lagi');
    expect(chat.items.last.kind, AssistantConversationItemKind.alarmStatus);
  });

  test('arrival question is independent from enabled alarm categories', () {
    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai')
      ..configureAlarms(departure: false, destination: true);
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('Kereta saya datang berapa menit lagi?');

    expect(chat.items.last.text, 'Kereta datang 5 menit lagi');
  });

  test('destination and all alarms can be cancelled through chat', () {
    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai')
      ..configureAlarms(departure: true, destination: true);
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('Matikan alarm tujuan');
    expect(alarms.state.destinationAlarmEnabled, isFalse);
    expect(alarms.state.departureAlarmEnabled, isTrue);

    chat.submitText('Batalkan semua alarm');
    expect(alarms.state.hasAnyAlarm, isFalse);
    expect(chat.items.last.text, 'Semua alarm perjalanan dibatalkan.');
  });

  test('unknown command returns concise command examples', () {
    final alarms = TravelAlarmController();
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('Pesan yang tidak dikenali');

    expect(chat.items.last.text, contains('Saya belum memahami perintah itu'));
    expect(chat.items.last.text, contains('Alarm berikutnya kapan?'));
  });

  test('alarm command without a ticket adds an empty-ticket item', () {
    final alarms = TravelAlarmController();
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('Aktifkan semua alarm tiket saya');

    expect(chat.items.last.kind, AssistantConversationItemKind.noActiveTicket);
    expect(chat.items.last.text, 'Belum ada tiket aktif');
  });

  test('empty messages are ignored and voice uses the same timeline', () {
    final alarms = TravelAlarmController();
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('   ');
    expect(chat.items, isEmpty);

    chat.addVoiceExchange(
      transcript: 'Saya ingin ke Manggarai dari Setiabudi.',
      response: 'Kereta datang 5 menit lagi.',
    );

    expect(chat.items, hasLength(2));
    expect(chat.items.first.author, AssistantMessageAuthor.user);
    expect(chat.items.last.author, AssistantMessageAuthor.assistant);
  });

  test('spoken alarm commands use the same intent handler as text', () {
    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai');
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.addVoiceExchange(
      transcript: 'Aktifkan semua alarm tiket saya',
      response: 'Respons rute yang tidak boleh dipakai.',
    );

    expect(alarms.state.hasAnyAlarm, isTrue);
    expect(chat.items.last.kind, AssistantConversationItemKind.alarmStatus);
    expect(chat.items.last.text, 'Semua alarm perjalanan aktif.');
  });

  test('alarm status items retain their state snapshot', () {
    final alarms = TravelAlarmController()
      ..completePurchase(from: 'Setiabudi', to: 'Manggarai');
    final chat = AssistantConversationController(alarmController: alarms);
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    chat.submitText('Aktifkan semua alarm tiket saya');
    final activation = chat.items.last;
    chat.submitText('Batalkan semua alarm');

    expect(activation.alarmSnapshot?.departureAlarmEnabled, isTrue);
    expect(activation.alarmSnapshot?.destinationAlarmEnabled, isTrue);
    expect(alarms.state.hasAnyAlarm, isFalse);
  });

  test('typed chat sends recent turns as temporary context', () async {
    final alarms = TravelAlarmController();
    final repository = _CapturingChatRepository();
    final chat = AssistantConversationController(
      alarmController: alarms,
      chatRepository: repository,
    );
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    await chat.submitText('Aku mau naik dari Pondok Ranji');
    await chat.submitText('Tujuannya ke Jakarta Kota');

    expect(repository.message, 'Tujuannya ke Jakarta Kota');
    expect(repository.history.map((turn) => (turn.role, turn.text)), [
      (AssistantChatRole.user, 'Aku mau naik dari Pondok Ranji'),
      (AssistantChatRole.assistant, 'Siap, mau ke stasiun mana?'),
    ]);
  });

  test('voice submission returns the assistant reply for TTS', () async {
    final alarms = TravelAlarmController();
    final repository = _CapturingChatRepository();
    final chat = AssistantConversationController(
      alarmController: alarms,
      chatRepository: repository,
    );
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    final reply = await chat.submitText('Saya mau ke Bogor', lang: 'id');

    expect(reply, 'Siap, mau ke stasiun mana?');
    expect(repository.message, 'Saya mau ke Bogor');
    expect(repository.lang, 'id');
    expect(chat.items.last.text, reply);
  });

  test('typed chat bounds temporary context to six prior turns', () async {
    final alarms = TravelAlarmController();
    final repository = _CapturingChatRepository();
    final chat = AssistantConversationController(
      alarmController: alarms,
      chatRepository: repository,
    );
    addTearDown(chat.dispose);
    addTearDown(alarms.dispose);

    for (var index = 0; index < 4; index++) {
      await chat.submitText('Pesan $index');
    }
    await chat.submitText('Pesan terakhir');

    expect(repository.history, hasLength(6));
    expect(repository.history.first.text, 'Pesan 1');
    expect(repository.history.last.text, 'Siap, mau ke stasiun mana?');
  });
}
