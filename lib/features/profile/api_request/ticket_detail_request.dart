class TicketDetailRequest {
  final String ticketNo;
  final String ticketId;
  final String title;
  final String description;
  final String? attachment;
  final DateTime? time;

  TicketDetailRequest({
    required this.ticketNo,
    required this.ticketId,
    required this.title,
    required this.description,
    this.attachment,
    this.time,
  });
}
