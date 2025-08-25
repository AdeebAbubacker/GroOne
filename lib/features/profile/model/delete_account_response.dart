class DeleteAccountModel {
    DeleteAccountModel({
        required this.message,
    });

    final String message;
    static const String messageKey = "message";
    

    DeleteAccountModel copyWith({
        String? message,
    }) {
        return DeleteAccountModel(
            message: message ?? this.message,
        );
    }

    factory DeleteAccountModel.fromJson(Map<String, dynamic> json){ 
        return DeleteAccountModel(
            message: json["message"] ?? "",
        );
    }

    Map<String, dynamic> toJson() => {
        "message": message,
    };

    @override
    String toString(){
        return "$message, ";
    }
}
