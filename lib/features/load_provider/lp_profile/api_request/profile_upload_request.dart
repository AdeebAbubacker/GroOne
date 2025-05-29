class ProfileImageUploadRequest {
  ProfileImageUploadRequest({
    required this.imageUrl,
  });

  final String imageUrl;

  factory ProfileImageUploadRequest.fromJson(Map<String, dynamic> json){
    return ProfileImageUploadRequest(
      imageUrl: json["imageUrl"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
  };

}
