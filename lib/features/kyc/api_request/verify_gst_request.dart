class VerifyGstRequest {
  VerifyGstRequest({
    required this.gst,
    required this.force,
  });

  final String gst;
  final bool force;

  factory VerifyGstRequest.fromJson(Map<String, dynamic> json){
    return VerifyGstRequest(
      gst: json["gst"] ?? "",
      force: json["force"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "gst": gst,
    "force": force,
  };

}
