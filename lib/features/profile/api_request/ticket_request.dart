import 'package:gro_one_app/data/model/serializable.dart';

class TicketRequest extends Serializable<TicketRequest>{
  final String? ticketStatus;
  final int? page;
  final int? limit;
  final String? customerId;
  final String? search;

  TicketRequest({
    this.ticketStatus,
    this.page,
    this.limit,
    this.customerId,
    this.search,
  });

  Map<String, dynamic> toJson() => {
    if (ticketStatus != null) 'ticketStatus': ticketStatus,
    if (page != null) 'page': page,
    if (limit != null) 'limit': limit,
    if (customerId != null) 'customerId': customerId,
    if (search != null) 'search': search,
  };

  TicketRequest copyWith({
    String? ticketStatus,
    int? page,
    int? limit,
    String? customerId,
    String? search,
  }) {
    return TicketRequest(
      ticketStatus: ticketStatus ?? this.ticketStatus,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      customerId: customerId ?? this.customerId,
      search: search ?? this.search,
    );
  }
}
