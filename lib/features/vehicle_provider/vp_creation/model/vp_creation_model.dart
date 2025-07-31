class UserModel {
    UserModel({
        required this.message,
        required this.customer,
        required this.address,
        required this.bankDetails,
        required this.vpvehiclesDetails,
    });

    final String message;
    final VpCustomerModel? customer;
    final VpAddressModel? address;
    final BankDetails? bankDetails;
    final VpvehiclesDetails? vpvehiclesDetails;

    UserModel copyWith({
        String? message,
        VpCustomerModel? customer,
        VpAddressModel? address,
        BankDetails? bankDetails,
        VpvehiclesDetails? vpvehiclesDetails,
    }) {
        return UserModel(
            message: message ?? this.message,
            customer: customer ?? this.customer,
            address: address ?? this.address,
            bankDetails: bankDetails ?? this.bankDetails,
            vpvehiclesDetails: vpvehiclesDetails ?? this.vpvehiclesDetails,
        );
    }

    factory UserModel.fromJson(Map<String, dynamic> json){
        return UserModel(
            message: json["message"] ?? "",
            customer: json["customer"] == null ? null : VpCustomerModel.fromJson(json["customer"]),
            address: json["address"] == null ? null : VpAddressModel.fromJson(json["address"]),
            bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
            vpvehiclesDetails: json["vpvehiclesDetails"] == null ? null : VpvehiclesDetails.fromJson(json["vpvehiclesDetails"]),
        );
    }

}

class VpAddressModel {
    VpAddressModel({
        required this.customersAddressId,
        required this.customerId,
        required this.addressName,
        required this.fullAddress,
        required this.city,
        required this.state,
        required this.pincode,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String customersAddressId;
    final String customerId;
    final String addressName;
    final String fullAddress;
    final String city;
    final String state;
    final String pincode;
    final dynamic status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    VpAddressModel copyWith({
        String? customersAddressId,
        String? customerId,
        String? addressName,
        String? fullAddress,
        String? city,
        String? state,
        String? pincode,
        dynamic? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return VpAddressModel(
            customersAddressId: customersAddressId ?? this.customersAddressId,
            customerId: customerId ?? this.customerId,
            addressName: addressName ?? this.addressName,
            fullAddress: fullAddress ?? this.fullAddress,
            city: city ?? this.city,
            state: state ?? this.state,
            pincode: pincode ?? this.pincode,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory VpAddressModel.fromJson(Map<String, dynamic> json){ 
        return VpAddressModel(
            customersAddressId: json["customers_address_id"] ?? "",
            customerId: json["customer_id"] ?? "",
            addressName: json["addressName"] ?? "",
            fullAddress: json["fullAddress"] ?? "",
            city: json["city"] ?? "",
            state: json["state"] ?? "",
            pincode: json["pincode"] ?? "",
            status: json["status"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
        );
    }

}

class BankDetails {
    BankDetails({
        required this.bankDetailsId,
        required this.customerId,
        required this.bankAccount,
        required this.bankName,
        required this.branchName,
        required this.ifscCode,
        required this.status,
        required this.deletedAt,
        required this.createdAt,
        required this.updatedAt,
    });

    final String bankDetailsId;
    final String customerId;
    final String bankAccount;
    final String bankName;
    final String branchName;
    final String ifscCode;
    final int status;
    final dynamic deletedAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    BankDetails copyWith({
        String? bankDetailsId,
        String? customerId,
        String? bankAccount,
        String? bankName,
        String? branchName,
        String? ifscCode,
        int? status,
        dynamic? deletedAt,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) {
        return BankDetails(
            bankDetailsId: bankDetailsId ?? this.bankDetailsId,
            customerId: customerId ?? this.customerId,
            bankAccount: bankAccount ?? this.bankAccount,
            bankName: bankName ?? this.bankName,
            branchName: branchName ?? this.branchName,
            ifscCode: ifscCode ?? this.ifscCode,
            status: status ?? this.status,
            deletedAt: deletedAt ?? this.deletedAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );
    }

    factory BankDetails.fromJson(Map<String, dynamic> json){ 
        return BankDetails(
            bankDetailsId: json["bank_details_id"] ?? "",
            customerId: json["customer_id"] ?? "",
            bankAccount: json["bankAccount"] ?? "",
            bankName: json["bankName"] ?? "",
            branchName: json["branchName"] ?? "",
            ifscCode: json["ifscCode"] ?? "",
            status: json["status"] ?? 0,
            deletedAt: json["deletedAt"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
        );
    }

}

class VpCustomerModel {
    VpCustomerModel({
        required this.customerId,
        required this.customerName,
        required this.mobileNumber,
        required this.companyTypeId,
        required this.emailId,
        required this.password,
        required this.companyName,
        required this.otp,
        required this.otpAttempt,
        required this.isKyc,
        required this.roleId,
        required this.tempFlg,
        required this.status,
        required this.isLogin,
        required this.blueId,
        required this.kycRejectReason,
        required this.preferredLanes,
        required this.createdAt,
        required this.deletedAt,
    });

    final String customerId;
    final String customerName;
    final String mobileNumber;
    final int companyTypeId;
    final String emailId;
    final String password;
    final String companyName;
    final int otp;
    final dynamic otpAttempt;
    final int isKyc;
    final int roleId;
    final bool tempFlg;
    final int status;
    final bool isLogin;
    final dynamic blueId;
    final dynamic kycRejectReason;
    final dynamic preferredLanes;
    final DateTime? createdAt;
    final dynamic deletedAt;

    VpCustomerModel copyWith({
        String? customerId,
        String? customerName,
        String? mobileNumber,
        int? companyTypeId,
        String? emailId,
        String? password,
        String? companyName,
        int? otp,
        dynamic? otpAttempt,
        int? isKyc,
        int? roleId,
        bool? tempFlg,
        int? status,
        bool? isLogin,
        dynamic? blueId,
        dynamic? kycRejectReason,
        dynamic? preferredLanes,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return VpCustomerModel(
            customerId: customerId ?? this.customerId,
            customerName: customerName ?? this.customerName,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            companyTypeId: companyTypeId ?? this.companyTypeId,
            emailId: emailId ?? this.emailId,
            password: password ?? this.password,
            companyName: companyName ?? this.companyName,
            otp: otp ?? this.otp,
            otpAttempt: otpAttempt ?? this.otpAttempt,
            isKyc: isKyc ?? this.isKyc,
            roleId: roleId ?? this.roleId,
            tempFlg: tempFlg ?? this.tempFlg,
            status: status ?? this.status,
            isLogin: isLogin ?? this.isLogin,
            blueId: blueId ?? this.blueId,
            kycRejectReason: kycRejectReason ?? this.kycRejectReason,
            preferredLanes: preferredLanes ?? this.preferredLanes,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory VpCustomerModel.fromJson(Map<String, dynamic> json){ 
        return VpCustomerModel(
            customerId: json["customer_id"] ?? "",
            customerName: json["customerName"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            companyTypeId: json["companyTypeId"] ?? 0,
            emailId: json["emailId"] ?? "",
            password: json["password"] ?? "",
            companyName: json["companyName"] ?? "",
            otp: json["otp"] ?? 0,
            otpAttempt: json["otpAttempt"],
            isKyc: json["isKyc"] ?? 0,
            roleId: json["roleId"] ?? 0,
            tempFlg: json["tempFlg"] ?? false,
            status: json["status"] ?? 0,
            isLogin: json["isLogin"] ?? false,
            blueId: json["blueId"],
            kycRejectReason: json["kycRejectReason"],
            preferredLanes: json["preferredLanes"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class VpvehiclesDetails {
    VpvehiclesDetails({
        required this.vpVehiclesId,
        required this.customerId,
        required this.truckType,
        required this.ownedTrucks,
        required this.attachedTrucks,
        required this.preferredLanes,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String vpVehiclesId;
    final String customerId;
    final List<int> truckType;
    final int ownedTrucks;
    final int attachedTrucks;
    final List<int> preferredLanes;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    VpvehiclesDetails copyWith({
        String? vpVehiclesId,
        String? customerId,
        List<int>? truckType,
        int? ownedTrucks,
        int? attachedTrucks,
        List<int>? preferredLanes,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return VpvehiclesDetails(
            vpVehiclesId: vpVehiclesId ?? this.vpVehiclesId,
            customerId: customerId ?? this.customerId,
            truckType: truckType ?? this.truckType,
            ownedTrucks: ownedTrucks ?? this.ownedTrucks,
            attachedTrucks: attachedTrucks ?? this.attachedTrucks,
            preferredLanes: preferredLanes ?? this.preferredLanes,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory VpvehiclesDetails.fromJson(Map<String, dynamic> json){ 
        return VpvehiclesDetails(
            vpVehiclesId: json["vp_vehicles_id"] ?? "",
            customerId: json["customer_id"] ?? "",
            truckType: json["truckType"] == null ? [] : List<int>.from(json["truckType"]!.map((x) => x)),
            ownedTrucks: json["ownedTrucks"] ?? 0,
            attachedTrucks: json["attachedTrucks"] ?? 0,
            preferredLanes: json["preferredLanes"] == null ? [] : List<int>.from(json["preferredLanes"]!.map((x) => x)),
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
        );
    }

}
