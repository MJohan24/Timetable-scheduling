class DeviceTicketCheckout {
  const DeviceTicketCheckout({required this.ticketId, required this.email});

  final String ticketId;
  final String email;

  DeviceTicketCheckout normalized() => DeviceTicketCheckout(
    ticketId: ticketId.trim(),
    email: email.trim().toLowerCase(),
  );
}
