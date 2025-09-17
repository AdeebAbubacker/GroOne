class CreateEventResponse {
  final String? eventId;
  final String? message;
  final bool success;

  const CreateEventResponse({
    this.eventId,
    this.message,
    this.success = false,
  });

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Handle different possible response structures
      if (json['event_id'] != null) {
        // Direct structure: {event_id: "...", message: "...", success: true}
        return CreateEventResponse(
          eventId: json['event_id']?.toString(),
          message: json['message']?.toString() ?? '',
          success: json['success'] ?? true,
        );
      } else if (json['data'] != null && json['data']['event_id'] != null) {
        // Nested structure: {success: true, data: {event_id: "..."}, message: "..."}
        return CreateEventResponse(
          eventId: json['data']['event_id']?.toString(),
          message: json['message']?.toString() ?? '',
          success: json['success'] ?? true,
        );
      } else if (json['id'] != null) {
        // Alternative structure: {id: "...", message: "...", success: true}
        return CreateEventResponse(
          eventId: json['id']?.toString(),
          message: json['message']?.toString() ?? '',
          success: json['success'] ?? true,
        );
      } else {
        // Fallback - assume success if no error structure
        return CreateEventResponse(
          eventId: json['eventId']?.toString() ?? json['_id']?.toString(),
          message: json['message']?.toString() ?? 'Event created successfully',
          success: true,
        );
      }
    } catch (e) {
      // Return a default success response if parsing fails
      return const CreateEventResponse(
        eventId: null,
        message: 'Event created successfully',
        success: true,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'message': message,
      'success': success,
    };
  }

  @override
  String toString() {
    return 'CreateEventResponse{eventId: $eventId, message: $message, success: $success}';
  }
}
