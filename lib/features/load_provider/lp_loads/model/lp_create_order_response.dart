class LpCreateOrderResponse {
    LpCreateOrderResponse({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool success;
    final String message;
    final LpCreateOrderResponseData? data;

    LpCreateOrderResponse copyWith({
        bool? success,
        String? message,
        LpCreateOrderResponseData? data,
    }) {
        return LpCreateOrderResponse(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory LpCreateOrderResponse.fromJson(Map<String, dynamic> json){
        return LpCreateOrderResponse(
            success: json["success"] ?? false,
            message: json["message"] ?? "",
            data: json["data"] == null ? null : LpCreateOrderResponseData.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };

}

class LpCreateOrderResponseData {
    LpCreateOrderResponseData({
        required this.data,
    });

    final DataData? data;

    LpCreateOrderResponseData copyWith({
        DataData? data,
    }) {
        return LpCreateOrderResponseData(
            data: data ?? this.data,
        );
    }

    factory LpCreateOrderResponseData.fromJson(Map<String, dynamic> json){
        return LpCreateOrderResponseData(
            data: json["data"] == null ? null : DataData.fromJson(json["data"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
    };

}

class DataData {
    DataData({
        required this.errorDesc,
        required this.invoiceId,
        required this.tinyUrl,
        required this.qrCode,
        required this.invoiceStatus,
        required this.errorCode,
        required this.merchantReferenceNo,
    });

    final String errorDesc;
    final String invoiceId;
    final String tinyUrl;
    final String qrCode;
    final int invoiceStatus;
    final String errorCode;
    final String merchantReferenceNo;

    DataData copyWith({
        String? errorDesc,
        String? invoiceId,
        String? tinyUrl,
        String? qrCode,
        int? invoiceStatus,
        String? errorCode,
        String? merchantReferenceNo,
    }) {
        return DataData(
            errorDesc: errorDesc ?? this.errorDesc,
            invoiceId: invoiceId ?? this.invoiceId,
            tinyUrl: tinyUrl ?? this.tinyUrl,
            qrCode: qrCode ?? this.qrCode,
            invoiceStatus: invoiceStatus ?? this.invoiceStatus,
            errorCode: errorCode ?? this.errorCode,
            merchantReferenceNo: merchantReferenceNo ?? this.merchantReferenceNo,
        );
    }

    factory DataData.fromJson(Map<String, dynamic> json){
        return DataData(
            errorDesc: json["error_desc"] ?? "",
            invoiceId: json["invoice_id"] ?? "",
            tinyUrl: json["tiny_url"] ?? "",
            qrCode: json["qr_code"] ?? "",
            invoiceStatus: json["invoice_status"] ?? 0,
            errorCode: json["error_code"] ?? "",
            merchantReferenceNo: json["merchant_reference_no"] ?? "",
        );
    }

    Map<String, dynamic> toJson() => {
        "error_desc": errorDesc,
        "invoice_id": invoiceId,
        "tiny_url": tinyUrl,
        "qr_code": qrCode,
        "invoice_status": invoiceStatus,
        "error_code": errorCode,
        "merchant_reference_no": merchantReferenceNo,
    };

}
