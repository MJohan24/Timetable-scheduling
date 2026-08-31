import '../../../../../l10n/app_localizations.dart';

enum SupportChatTopic {
  ticket(key: 'ticket'),
  schedule(key: 'schedule'),
  payment(key: 'payment');

  const SupportChatTopic({required this.key});

  final String key;

  static SupportChatTopic fromKey(String? key) {
    return SupportChatTopic.values.firstWhere(
      (topic) => topic.key == key,
      orElse: () => SupportChatTopic.ticket,
    );
  }

  String replyTo(String message, AppLocalizations l10n) {
    final normalized = message.toLowerCase();

    return switch (this) {
      SupportChatTopic.ticket => _ticketReply(normalized, l10n),
      SupportChatTopic.schedule => _scheduleReply(normalized, l10n),
      SupportChatTopic.payment => _paymentReply(normalized, l10n),
    };
  }

  static String _ticketReply(String message, AppLocalizations l10n) {
    if (message.contains('belum muncul') ||
        message.contains('tidak muncul') ||
        message.contains('doesn\'t appear')) {
      return l10n.chatReplyTicketNotFound;
    }
    if (message.contains('beli') ||
        message.contains('membeli') ||
        message.contains('buy')) {
      return l10n.chatReplyTicketBuy;
    }
    if (message.contains('aktif') ||
        message.contains('scan') ||
        message.contains('active')) {
      return l10n.chatReplyTicketActive;
    }
    return l10n.chatReplyTicketDefault;
  }

  static String _scheduleReply(String message, AppLocalizations l10n) {
    if (message.contains('terlambat') ||
        message.contains('eta') ||
        message.contains('late')) {
      return l10n.chatReplyScheduleLate;
    }
    if (message.contains('peron') || message.contains('platform')) {
      return l10n.chatReplySchedulePlatform;
    }
    if (message.contains('hilang') ||
        message.contains('tidak muncul') ||
        message.contains('missing')) {
      return l10n.chatReplyScheduleMissing;
    }
    return l10n.chatReplyScheduleDefault;
  }

  static String _paymentReply(String message, AppLocalizations l10n) {
    if (message.contains('saldo') ||
        message.contains('terpotong') ||
        message.contains('balance')) {
      return l10n.chatReplyPaymentDeducted;
    }
    if (message.contains('refund') || message.contains('kembali')) {
      return l10n.chatReplyPaymentRefund;
    }
    if (message.contains('gagal') ||
        message.contains('metode') ||
        message.contains('failed')) {
      return l10n.chatReplyPaymentFailed;
    }
    return l10n.chatReplyPaymentDefault;
  }
}

extension SupportChatTopicL10n on SupportChatTopic {
  String label(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketLabel,
      SupportChatTopic.schedule => l10n.topicScheduleLabel,
      SupportChatTopic.payment => l10n.topicPaymentLabel,
    };
  }

  String title(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketTitle,
      SupportChatTopic.schedule => l10n.topicScheduleTitle,
      SupportChatTopic.payment => l10n.topicPaymentTitle,
    };
  }

  String agentName(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketAgent,
      SupportChatTopic.schedule => l10n.topicScheduleAgent,
      SupportChatTopic.payment => l10n.topicPaymentAgent,
    };
  }

  String availability(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketAvailability,
      SupportChatTopic.schedule => l10n.topicScheduleAvailability,
      SupportChatTopic.payment => l10n.topicPaymentAvailability,
    };
  }

  String waitTime(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketWait,
      SupportChatTopic.schedule => l10n.topicScheduleWait,
      SupportChatTopic.payment => l10n.topicPaymentWait,
    };
  }

  String openingMessage(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketOpening,
      SupportChatTopic.schedule => l10n.topicScheduleOpening,
      SupportChatTopic.payment => l10n.topicPaymentOpening,
    };
  }

  String sharedData(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketShared,
      SupportChatTopic.schedule => l10n.topicScheduleShared,
      SupportChatTopic.payment => l10n.topicPaymentShared,
    };
  }

  String sampleData(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketSampleData,
      SupportChatTopic.schedule => l10n.topicScheduleSampleData,
      SupportChatTopic.payment => l10n.topicPaymentSampleData,
    };
  }

  String actionLabel(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketAction,
      SupportChatTopic.schedule => l10n.topicScheduleAction,
      SupportChatTopic.payment => l10n.topicPaymentAction,
    };
  }

  String greeting(AppLocalizations l10n) {
    return switch (this) {
      SupportChatTopic.ticket => l10n.topicTicketGreeting,
      SupportChatTopic.schedule => l10n.topicScheduleGreeting,
      SupportChatTopic.payment => l10n.topicPaymentGreeting,
    };
  }
}
