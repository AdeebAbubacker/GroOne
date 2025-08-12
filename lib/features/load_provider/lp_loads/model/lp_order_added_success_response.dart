class OrderAddedSuccess {
    OrderAddedSuccess({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool success;
    final String message;
    final OrderAddedSuccessData? data;

    OrderAddedSuccess copyWith({
        bool? success,
        String? message,
        OrderAddedSuccessData? data,
    }) {
        return OrderAddedSuccess(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory OrderAddedSuccess.fromJson(Map<String, dynamic> json){ 
        return OrderAddedSuccess(
            success: json["success"] ?? false,
            message: json["message"] ?? "",
            data: json["data"] == null ? null : OrderAddedSuccessData.fromJson(json["data"]),
        );
    }

}

class OrderAddedSuccessData {
    OrderAddedSuccessData({
        required this.data,
    });

    final DataData? data;

    OrderAddedSuccessData copyWith({
        DataData? data,
    }) {
        return OrderAddedSuccessData(
            data: data ?? this.data,
        );
    }

    factory OrderAddedSuccessData.fromJson(Map<String, dynamic> json){ 
        return OrderAddedSuccessData(
            data: json["data"] == null ? null : DataData.fromJson(json["data"]),
        );
    }

}

class DataData {
    DataData({
        required this.errorDesc,
        required this.invoiceId,
        required this.tinyUrl,
        required this.qrCode,
        required this.invoiceStatus,
        required this.errorCode,
        this.paymentRequestId,
    });

    final String errorDesc;
    final String invoiceId;
    final String tinyUrl;
    final String qrCode;
    final int invoiceStatus;
    final String errorCode;
    final String? paymentRequestId;

    DataData copyWith({
        String? errorDesc,
        String? invoiceId,
        String? tinyUrl,
        String? qrCode,
        int? invoiceStatus,
        String? errorCode,
    }) {
        return DataData(
            errorDesc: errorDesc ?? this.errorDesc,
            invoiceId: invoiceId ?? this.invoiceId,
            tinyUrl: tinyUrl ?? this.tinyUrl,
            qrCode: qrCode ?? this.qrCode,
            invoiceStatus: invoiceStatus ?? this.invoiceStatus,
            errorCode: errorCode ?? this.errorCode,
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
            paymentRequestId: json["payment_request_id"]??"",
        );
    }

}
