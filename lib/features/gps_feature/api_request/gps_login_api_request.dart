class GpsLoginApiRequest {
  final String appName;
  final String password;
  final String packageName;
  final String deviceType;
  final String username;

  GpsLoginApiRequest({
    required this.appName,
    required this.password,
    required this.packageName,
    required this.deviceType,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
    "app_name": appName,
    "password": password,
    "package_name": packageName,
    "device_type": deviceType,
    "username": username,
  };
}
