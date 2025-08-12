class NotificationData {
  final String? toUser;
  final String? osType;
  final String? token;
  final String? title;
  final String? body;
  final String? screen;
  final NotificationExtraData? data;

  NotificationData({
    this.toUser,
    this.osType,
    this.token,
    this.title,
    this.body,
    this.screen,
    this.data,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      toUser: json['to_user'] as String?,
      osType: json['os_type'] as String?,
      token: json['token'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      screen: json['screen'] as String?,
      data: json['data'] != null
          ? NotificationExtraData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'to_user': toUser,
      'os_type': osType,
      'token': token,
      'title': title,
      'body': body,
      'screen': screen,
      'data': data?.toJson(),
    };
  }
}

class NotificationExtraData {
  final String? id;
  final String? userType;

  NotificationExtraData({
    this.id,
    this.userType,
  });

  factory NotificationExtraData.fromJson(Map<String, dynamic> json) {
    return NotificationExtraData(
      id: json['id'] as String?,
      userType: json['user_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type': userType,
    };
  }
}
