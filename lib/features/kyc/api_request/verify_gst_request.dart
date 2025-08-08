class VerifyGstApiRequest {
  VerifyGstApiRequest({
    required this.gst,
    required this.force,
  });

  final String gst;
  final bool force;

  factory VerifyGstApiRequest.fromJson(Map<String, dynamic> json){
    return VerifyGstApiRequest(
      gst: json["gst"] ?? "",
      force: json["force"] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    "gst_number": gst,
  };

}
