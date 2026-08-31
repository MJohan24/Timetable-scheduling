import '../../../../core/network/access_token_provider.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_remote_data_source.dart';

class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl({
    required AccessTokenProvider tokenProvider,
    TicketRemoteDataSource? remote,
  }) : _tokenProvider = tokenProvider,
       _remote = remote ?? TicketRemoteDataSource();

  final AccessTokenProvider _tokenProvider;
  final TicketRemoteDataSource _remote;

  @override
  Future<TicketPage> listTickets({
    String? contactEmail,
    int page = 1,
    int limit = 20,
  }) => _withAuth(
    (token) => _remote.listTickets(
      accessToken: token,
      contactEmail: token == null ? contactEmail : null,
      page: page,
      limit: limit,
    ),
  );

  @override
  Future<TicketPage> listGuestTickets({
    required String contactEmail,
    int page = 1,
    int limit = 20,
  }) => _remote.listTickets(
    accessToken: null,
    contactEmail: contactEmail,
    page: page,
    limit: limit,
  );

  @override
  Future<Ticket> orderTicket({
    required String origin,
    required String destination,
    required DateTime travelDate,
    int passengerCount = 1,
    String? contactEmail,
  }) => _withAuth(
    (token) => _remote.orderTicket(
      origin: origin,
      destination: destination,
      travelDate: travelDate,
      passengerCount: passengerCount,
      contactEmail: token == null ? contactEmail : null,
      accessToken: token,
    ),
  );

  @override
  Future<TicketPayment> createCheckout({
    required String ticketId,
    String? contactEmail,
  }) => _withAuth(
    (token) => _remote.createCheckout(
      ticketId: ticketId,
      contactEmail: token == null ? contactEmail : null,
      accessToken: token,
    ),
  );

  @override
  Future<PaymentSnapshot> getPaymentStatus({
    required String ticketId,
    String? contactEmail,
  }) => _withAuth(
    (token) => _remote.getPaymentStatus(
      ticketId: ticketId,
      contactEmail: token == null ? contactEmail : null,
      accessToken: token,
    ),
  );

  @override
  Future<PaymentSnapshot> getGuestPaymentStatus({
    required String ticketId,
    required String contactEmail,
  }) => _remote.getPaymentStatus(
    ticketId: ticketId,
    contactEmail: contactEmail,
    accessToken: null,
  );

  Future<T> _withAuth<T>(Future<T> Function(String? token) request) async {
    var token = await _tokenProvider.getAccessToken();
    try {
      return await request(token);
    } on TicketRemoteException catch (error) {
      if (!error.isUnauthorized || token == null) rethrow;
      token = await _tokenProvider.getAccessToken(forceRefresh: true);
      return request(token);
    }
  }
}
