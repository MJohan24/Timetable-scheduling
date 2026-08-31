import '../entities/ticket.dart';

abstract interface class TicketRepository {
  Future<TicketPage> listTickets({
    String? contactEmail,
    int page = 1,
    int limit = 20,
  });

  Future<TicketPage> listGuestTickets({
    required String contactEmail,
    int page = 1,
    int limit = 20,
  });

  Future<Ticket> orderTicket({
    required String origin,
    required String destination,
    required DateTime travelDate,
    int passengerCount = 1,
    String? contactEmail,
  });

  Future<TicketPayment> createCheckout({
    required String ticketId,
    String? contactEmail,
  });

  Future<PaymentSnapshot> getPaymentStatus({
    required String ticketId,
    String? contactEmail,
  });

  Future<PaymentSnapshot> getGuestPaymentStatus({
    required String ticketId,
    required String contactEmail,
  });
}
