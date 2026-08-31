import '../../domain/entities/ticket.dart';

TicketStatus _ticketStatus(Object? value) => switch (value) {
  'PENDING' => TicketStatus.pending,
  'PAYMENT_PENDING' => TicketStatus.paymentPending,
  'PAID' => TicketStatus.paid,
  'ACTIVE' => TicketStatus.active,
  'USED' => TicketStatus.used,
  'EXPIRED' => TicketStatus.expired,
  'CANCELLED' => TicketStatus.cancelled,
  _ => TicketStatus.unknown,
};

PaymentStatus _paymentStatus(Object? value) => switch (value) {
  'PENDING' => PaymentStatus.pending,
  'COMPLETED' => PaymentStatus.completed,
  'FAILED' => PaymentStatus.failed,
  'EXPIRED' => PaymentStatus.expired,
  'CANCELLED' => PaymentStatus.cancelled,
  _ => PaymentStatus.unknown,
};

DateTime? _optionalDate(Object? value) => value is String
    ? DateTime.tryParse(value)
    : null;

class TicketStationModel extends TicketStation {
  const TicketStationModel({required super.id, required super.name});

  factory TicketStationModel.fromJson(Map<String, dynamic> json) =>
      TicketStationModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}

class TicketPaymentModel extends TicketPayment {
  const TicketPaymentModel({
    required super.id,
    required super.referenceId,
    required super.amount,
    required super.currency,
    required super.status,
    super.checkoutUrl,
    super.expiresAt,
  });

  factory TicketPaymentModel.fromJson(Map<String, dynamic> json) {
    final checkoutValue = json['checkoutUrl'] as String?;
    return TicketPaymentModel(
      id: json['id'] as String,
      referenceId: json['referenceId'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String? ?? 'IDR',
      status: _paymentStatus(json['status']),
      checkoutUrl: checkoutValue == null ? null : Uri.tryParse(checkoutValue),
      expiresAt: _optionalDate(json['expiresAt']),
    );
  }
}

class TicketModel extends Ticket {
  const TicketModel({
    required super.id,
    required super.publicCode,
    required super.origin,
    required super.destination,
    required super.passengerCount,
    required super.unitPrice,
    required super.price,
    required super.status,
    required super.travelDate,
    required super.payments,
    super.contactEmail,
    super.qrCode,
    super.departureTime,
    super.arrivalTime,
    super.expiresAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    id: json['id'] as String,
    publicCode: json['publicCode'] as String,
    contactEmail: json['contactEmail'] as String?,
    origin: TicketStationModel.fromJson(
      json['originStation'] as Map<String, dynamic>,
    ),
    destination: TicketStationModel.fromJson(
      json['destinationStation'] as Map<String, dynamic>,
    ),
    passengerCount: (json['passengerCount'] as num).toInt(),
    unitPrice: (json['unitPrice'] as num).toInt(),
    price: (json['price'] as num).toInt(),
    status: _ticketStatus(json['status']),
    qrCode: json['qrCode'] as String?,
    travelDate: DateTime.parse(json['travelDate'] as String),
    departureTime: json['departureTime'] as String?,
    arrivalTime: json['arrivalTime'] as String?,
    expiresAt: _optionalDate(json['expiresAt']),
    payments: (json['payments'] as List<dynamic>? ?? const [])
        .map(
          (payment) => TicketPaymentModel.fromJson(
            Map<String, dynamic>.from(payment as Map),
          ),
        )
        .toList(growable: false),
  );
}

class TicketPageModel extends TicketPage {
  const TicketPageModel({
    required super.items,
    required super.page,
    required super.limit,
    required super.total,
  });

  factory TicketPageModel.fromResponse(Map<String, dynamic> response) {
    final meta = response['meta'] as Map<String, dynamic>? ?? const {};
    return TicketPageModel(
      items: (response['data'] as List<dynamic>? ?? const [])
          .map(
            (ticket) => TicketModel.fromJson(
              Map<String, dynamic>.from(ticket as Map),
            ),
          )
          .toList(growable: false),
      page: (meta['page'] as num?)?.toInt() ?? 1,
      limit: (meta['limit'] as num?)?.toInt() ?? 20,
      total: (meta['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class PaymentSnapshotModel extends PaymentSnapshot {
  const PaymentSnapshotModel({required super.ticketStatus, super.payment});

  factory PaymentSnapshotModel.fromJson(Map<String, dynamic> json) {
    final payment = json['payment'];
    return PaymentSnapshotModel(
      ticketStatus: _ticketStatus(json['ticketStatus']),
      payment: payment is Map<String, dynamic>
          ? TicketPaymentModel.fromJson(payment)
          : payment is Map
          ? TicketPaymentModel.fromJson(Map<String, dynamic>.from(payment))
          : null,
    );
  }
}
