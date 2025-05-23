class LoginApiRequest {
  String mobile;
  int role;

  LoginApiRequest({required this.mobile, required this.role});

  Map<String, dynamic> toJson() => {"mobile": mobile, "role": role};
}
