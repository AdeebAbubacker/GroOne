class NotificationPayload {
  String? route;
  String? eventType;
  String? mode;

  NotificationPayload({this.route, this.eventType, this.mode});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      route: json['route'],
      eventType: json['eventType'],
      mode: json['mode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'route': route, 'eventType': eventType, 'mode': mode};
  }
}
