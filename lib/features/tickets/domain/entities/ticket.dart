enum TicketStatus {
  pending,
  paymentPending,
  paid,
  active,
  used,
  expired,
  cancelled,
  unknown,
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  expired,
  cancelled,
  unknown,
}

class TicketStation {
  const TicketStation({required this.id, required this.name});

  final String id;
  final String name;
}

class TicketPayment {
  const TicketPayment({
    required this.id,
    required this.referenceId,
    required this.amount,
    required this.currency,
    required this.status,
    this.checkoutUrl,
    this.expiresAt,
  });

  final String id;
  final String referenceId;
  final int amount;
  final String currency;
  final PaymentStatus status;
  final Uri? checkoutUrl;
  final DateTime? expiresAt;
}

class Ticket {
  const Ticket({
    required this.id,
    required this.publicCode,
    required this.origin,
    required this.destination,
    required this.passengerCount,
    required this.unitPrice,
    required this.price,
    required this.status,
    required this.travelDate,
    required this.payments,
    this.contactEmail,
    this.qrCode,
    this.departureTime,
    this.arrivalTime,
    this.expiresAt,
  });

  final String id;
  final String publicCode;
  final String? contactEmail;
  final TicketStation origin;
  final TicketStation destination;
  final int passengerCount;
  final int unitPrice;
  final int price;
  final TicketStatus status;
  final String? qrCode;
  final DateTime travelDate;
  final String? departureTime;
  final String? arrivalTime;
  final DateTime? expiresAt;
  final List<TicketPayment> payments;

  TicketPayment? get latestPayment => payments.isEmpty ? null : payments.first;
  bool get isCompleted => status == TicketStatus.used;
  bool get isActive => status == TicketStatus.active;
  bool get isPending =>
      status == TicketStatus.pending || status == TicketStatus.paymentPending;
}

class TicketPage {
  const TicketPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<Ticket> items;
  final int page;
  final int limit;
  final int total;
}

class PaymentSnapshot {
  const PaymentSnapshot({required this.ticketStatus, this.payment});

  final TicketStatus ticketStatus;
  final TicketPayment? payment;
}
