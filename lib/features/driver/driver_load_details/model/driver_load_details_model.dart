import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';

class DamageShortage {
    DamageShortage({
        required this.damageId,
        required this.vehicleId,
        required this.loadId,
        required this.itemName,
        required this.quantity,
        required this.status,
        required this.image,
        required this.description,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String damageId;
    final String vehicleId;
    final String loadId;
    final String itemName;
    final int quantity;
    final int status;
    final List<String> image;
    final String description;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final dynamic deletedAt;

    DamageShortage copyWith({
        String? damageId,
        String? vehicleId,
        String? loadId,
        String? itemName,
        int? quantity,
        int? status,
        List<String>? image,
        String? description,
        DateTime? createdAt,
        dynamic? updatedAt,
        dynamic? deletedAt,
    }) {
        return DamageShortage(
            damageId: damageId ?? this.damageId,
            vehicleId: vehicleId ?? this.vehicleId,
            loadId: loadId ?? this.loadId,
            itemName: itemName ?? this.itemName,
            quantity: quantity ?? this.quantity,
            status: status ?? this.status,
            image: image ?? this.image,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory DamageShortage.fromJson(Map<String, dynamic> json){ 
        return DamageShortage(
            damageId: json["damageId"] ?? "",
            vehicleId: json["vehicleId"] ?? "",
            loadId: json["loadId"] ?? "",
            itemName: json["itemName"] ?? "",
            quantity: json["quantity"] ?? 0,
            status: json["status"] ?? 0,
            image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
            description: json["description"] ?? "",
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: json["updatedAt"],
            deletedAt: json["deletedAt"],
        );
    }

}


class DriverLoadDetailsModel {
    DriverLoadDetailsModel({
        required this.message,
        required this.data,
    });

    final String message;
    final DriverLoadDetailsModelData? data;

    DriverLoadDetailsModel copyWith({
        String? message,
        DriverLoadDetailsModelData? data,
    }) {
        return DriverLoadDetailsModel(
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory DriverLoadDetailsModel.fromJson(Map<String, dynamic> json){ 
        return DriverLoadDetailsModel(
            message: json["message"] ?? "",
            data: json["data"] == null ? null : DriverLoadDetailsModelData.fromJson(json["data"]),
        );
    }

}

class DriverLoadDetailsModelData {
    DriverLoadDetailsModelData({
        required this.loadId,
        required this.loadSeriesId,
        required this.laneId,
        required this.rateId,
        required this.customerId,
        required this.commodityId,
        required this.pickUpDateTime,
        required this.truckTypeId,
        required this.consignmentWeight,
        required this.notes,
        required this.loadStatusId,
        required this.expectedDeliveryDateTime,
        required this.isAgreed,
        required this.acceptedBy,
        required this.createdPlatform,
        required this.updatedPlatform,
        required this.status,
        required this.driverConsent,
        required this.driverConsentDate,
        required this.matchingStartDate,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.loadOnhold,
        required this.commodity,
        required this.truckType,
        required this.loadRoute,
        required this.loadStatusDetails,
        required this.loadPrice,
        required this.scheduleTripDetails,
        required this.loadMemo,
        required this.loadDocument,
        required this.loadSettlement,
        required this.podDispatch,
        required this.loadApproval,
        required this.damageShortage,
        required this.trackingDetails,
        required this.customer,
        required this.vpCustomer,
        required this.weight,
        required this.consignees,
        required this.timeline,
    });

    final String loadId;
    final String loadSeriesId;
    final int laneId;
    final int rateId;
    final String customerId;
    final int commodityId;
    final DateTime? pickUpDateTime;
    final int truckTypeId;
    final int consignmentWeight;
    final String notes;
    final int loadStatusId;
    final DateTime? expectedDeliveryDateTime;
    final int isAgreed;
    final String acceptedBy;
    final int createdPlatform;
    final int updatedPlatform;
    final int status;
    final int driverConsent;
    final dynamic driverConsentDate;
    final DateTime? matchingStartDate;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final bool loadOnhold;
    final DataCommodity? commodity;
    final DataTruckType? truckType;
    final LoadRoute? loadRoute;
    final LoadStatusDetails? loadStatusDetails;
    final LoadPrice? loadPrice;
    final ScheduleTripDetails? scheduleTripDetails;
    final LoadMemo? loadMemo;
    final List<LoadDocument> loadDocument;
    final DriverloadSettlement? loadSettlement;
    final PodDispatchModel? podDispatch;
    final dynamic loadApproval;
     final List<DamageReport>? damageShortage;
    final TrackingDetails? trackingDetails;
    final Customer? customer;
    final Customer? vpCustomer;
    final Weight? weight;
      final List<DriverConsignee> consignees;
    final List<Timeline> timeline;

    DriverLoadDetailsModelData copyWith({
        String? loadId,
        String? loadSeriesId,
        int? laneId,
        int? rateId,
        String? customerId,
        int? commodityId,
        DateTime? pickUpDateTime,
        int? truckTypeId,
        int? consignmentWeight,
        String? notes,
        int? loadStatusId,
        DateTime? expectedDeliveryDateTime,
        int? isAgreed,
        String? acceptedBy,
        int? createdPlatform,
        int? updatedPlatform,
        int? status,
        int? driverConsent,
        dynamic? driverConsentDate,
        DateTime? matchingStartDate,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
        bool? loadOnhold,
        DataCommodity? commodity,
        DataTruckType? truckType,
        LoadRoute? loadRoute,
        LoadStatusDetails? loadStatusDetails,
        LoadPrice? loadPrice,
        ScheduleTripDetails? scheduleTripDetails,
        LoadMemo? loadMemo,
        List<LoadDocument>? loadDocument,
        DriverloadSettlement? loadSettlement,
        PodDispatchModel? podDispatch,
        dynamic? loadApproval,
        List<DamageReport>? damageShortage,
        TrackingDetails? trackingDetails,
        Customer? customer,
        Customer? vpCustomer,
        Weight? weight,
        List<DriverConsignee>? consignees,
        List<Timeline>? timeline,
    }) {
        return DriverLoadDetailsModelData(
            loadId: loadId ?? this.loadId,
            loadSeriesId: loadSeriesId ?? this.loadSeriesId,
            laneId: laneId ?? this.laneId,
            rateId: rateId ?? this.rateId,
            customerId: customerId ?? this.customerId,
            commodityId: commodityId ?? this.commodityId,
            pickUpDateTime: pickUpDateTime ?? this.pickUpDateTime,
            truckTypeId: truckTypeId ?? this.truckTypeId,
            consignmentWeight: consignmentWeight ?? this.consignmentWeight,
            notes: notes ?? this.notes,
            loadStatusId: loadStatusId ?? this.loadStatusId,
            expectedDeliveryDateTime: expectedDeliveryDateTime ?? this.expectedDeliveryDateTime,
            isAgreed: isAgreed ?? this.isAgreed,
            acceptedBy: acceptedBy ?? this.acceptedBy,
            createdPlatform: createdPlatform ?? this.createdPlatform,
            updatedPlatform: updatedPlatform ?? this.updatedPlatform,
            status: status ?? this.status,
            driverConsent: driverConsent ?? this.driverConsent,
            driverConsentDate: driverConsentDate ?? this.driverConsentDate,
            matchingStartDate: matchingStartDate ?? this.matchingStartDate,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
            loadOnhold: loadOnhold ?? this.loadOnhold,
            commodity: commodity ?? this.commodity,
            truckType: truckType ?? this.truckType,
            loadRoute: loadRoute ?? this.loadRoute,
            loadStatusDetails: loadStatusDetails ?? this.loadStatusDetails,
            loadPrice: loadPrice ?? this.loadPrice,
            scheduleTripDetails: scheduleTripDetails ?? this.scheduleTripDetails,
            loadMemo: loadMemo ?? this.loadMemo,
            loadDocument: loadDocument ?? this.loadDocument,
            loadSettlement: loadSettlement ?? this.loadSettlement,
            podDispatch: podDispatch ?? this.podDispatch,
            loadApproval: loadApproval ?? this.loadApproval,
             damageShortage:damageShortage ?? this.damageShortage,
            trackingDetails: trackingDetails ?? this.trackingDetails,
            customer: customer ?? this.customer,
            vpCustomer: vpCustomer ?? this.vpCustomer,
            weight: weight ?? this.weight,
            consignees: consignees ?? this.consignees,
            timeline: timeline ?? this.timeline,
        );
    }

    factory DriverLoadDetailsModelData.fromJson(Map<String, dynamic> json){
        List<Timeline> timeLine= json["timeline"] == null ? [] : List<Timeline>.from(json["timeline"]!.map((x) => Timeline.fromJson(x)));
        return DriverLoadDetailsModelData(
            loadId: json["loadId"] ?? "",
            loadSeriesId: json["loadSeriesId"] ?? "",
            laneId: json["laneId"] ?? 0,
            rateId: json["rateId"] ?? 0,
            customerId: json["customerId"] ?? "",
            commodityId: json["commodityId"] ?? 0,
            pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
            truckTypeId: json["truckTypeId"] ?? 0,
            consignmentWeight: json["consignmentWeight"] ?? 0,
            notes: json["notes"] ?? "",
            loadStatusId: json["loadStatusId"] ?? 0,
            expectedDeliveryDateTime: DateTime.tryParse(json["expectedDeliveryDateTime"] ?? ""),
            isAgreed: json["isAgreed"] ?? 0,
            acceptedBy: json["acceptedBy"] ?? "",
            createdPlatform: json["createdPlatform"] ?? 0,
            updatedPlatform: json["updatedPlatform"] ?? 0,
            status: json["status"] ?? 0,
            driverConsent: json["driverConsent"] ?? 0,
            driverConsentDate: json["driverConsentDate"],
            matchingStartDate: DateTime.tryParse(json["matchingStartDate"] ?? ""),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
            loadOnhold: json["loadOnhold"] ?? false,
            commodity: json["commodity"] == null ? null : DataCommodity.fromJson(json["commodity"]),
            truckType: json["truckType"] == null ? null : DataTruckType.fromJson(json["truckType"]),
            loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
            loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
            loadPrice: json["loadPrice"] == null ? null : LoadPrice.fromJson(json["loadPrice"]),
            scheduleTripDetails: json["scheduleTripDetails"] == null ? null : ScheduleTripDetails.fromJson(json["scheduleTripDetails"]),
            loadMemo: json["loadMemo"] == null ? null : LoadMemo.fromJson(json["loadMemo"]),
            loadDocument: json["loadDocument"] == null ? [] : List<LoadDocument>.from(json["loadDocument"]!.map((x) => LoadDocument.fromJson(x))),
            loadSettlement: json["loadSettlement"] == null ? null : DriverloadSettlement.fromJson(json["loadSettlement"]),
            podDispatch: json["podDispatch"] == null ? null : PodDispatchModel.fromJson(json["podDispatch"]),
            loadApproval: json["loadApproval"],
             damageShortage: json["damageShortage"] == null ? [] : List<DamageReport>.from(json["damageShortage"]!.map((x) => DamageReport.fromJson(x))),
            trackingDetails: (json["trackingDetails"] is Map<String, dynamic>)
            ? TrackingDetails.fromJson(json["trackingDetails"])
            : null,
            customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
            vpCustomer: json["vpCustomer"] == null ? null : Customer.fromJson(json["vpCustomer"]),
            weight: json["weight"] == null ? null : Weight.fromJson(json["weight"]),
            consignees: json["consignees"] == null ? [] : List<DriverConsignee>.from(json["consignees"]!.map((x) => DriverConsignee.fromJson(x))),
            timeline:timeLine

        );
    }

}

class DataCommodity {
    DataCommodity({
        required this.id,
        required this.name,
        required this.description,
        required this.iconUrl,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int id;
    final String name;
    final dynamic description;
    final dynamic iconUrl;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    DataCommodity copyWith({
        int? id,
        String? name,
        dynamic? description,
        dynamic? iconUrl,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return DataCommodity(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            iconUrl: iconUrl ?? this.iconUrl,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory DataCommodity.fromJson(Map<String, dynamic> json){ 
        return DataCommodity(
            id: json["id"] ?? 0,
            name: json["name"] ?? "",
            description: json["description"],
            iconUrl: json["iconUrl"],
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class Customer {
    Customer({
        required this.customerId,
        required this.customerName,
        required this.mobileNumber,
        required this.companyTypeId,
        required this.emailId,
        required this.blueId,
        required this.kycRejectReason,
        required this.password,
        required this.companyName,
        required this.otp,
        required this.ememoOtp,
        required this.otpAttempt,
        required this.isKyc,
        required this.preferredLanes,
        required this.roleId,
        required this.tempFlg,
        required this.status,
        required this.isLogin,
        required this.blueIdFlg,
        required this.kycPendingDate,
        required this.kycVerificationDate,
        required this.accessToken,
        required this.refreshToken,
        required this.createdAt,
        required this.deletedAt,
        required this.kycType,
        required this.companyType,
        required this.customerAddress,
        required this.kycDocs,
        required this.vehicle,
    });

    final String customerId;
    final String customerName;
    final String mobileNumber;
    final int companyTypeId;
    final String emailId;
    final String blueId;
    final dynamic kycRejectReason;
    final dynamic password;
    final String companyName;
    final String otp;
    final dynamic ememoOtp;
    final String otpAttempt;
    final int isKyc;
    final List<int> preferredLanes;
    final int roleId;
    final bool tempFlg;
    final int status;
    final bool isLogin;
    final bool blueIdFlg;
    final DateTime? kycPendingDate;
    final DateTime? kycVerificationDate;
    final dynamic accessToken;
    final dynamic refreshToken;
    final DateTime? createdAt;
    final dynamic deletedAt;
    final Type? kycType;
    final Type? companyType;
    final CustomerAddress? customerAddress;
    final KycDocs? kycDocs;
    final List<Vehicle> vehicle;

    Customer copyWith({
        String? customerId,
        String? customerName,
        String? mobileNumber,
        int? companyTypeId,
        String? emailId,
        String? blueId,
        dynamic? kycRejectReason,
        dynamic? password,
        String? companyName,
        String? otp,
        dynamic? ememoOtp,
        String? otpAttempt,
        int? isKyc,
        List<int>? preferredLanes,
        int? roleId,
        bool? tempFlg,
        int? status,
        bool? isLogin,
        bool? blueIdFlg,
        DateTime? kycPendingDate,
        DateTime? kycVerificationDate,
        dynamic? accessToken,
        dynamic? refreshToken,
        DateTime? createdAt,
        dynamic? deletedAt,
        Type? kycType,
        Type? companyType,
        CustomerAddress? customerAddress,
        KycDocs? kycDocs,
        List<Vehicle>? vehicle,
    }) {
        return Customer(
            customerId: customerId ?? this.customerId,
            customerName: customerName ?? this.customerName,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            companyTypeId: companyTypeId ?? this.companyTypeId,
            emailId: emailId ?? this.emailId,
            blueId: blueId ?? this.blueId,
            kycRejectReason: kycRejectReason ?? this.kycRejectReason,
            password: password ?? this.password,
            companyName: companyName ?? this.companyName,
            otp: otp ?? this.otp,
            ememoOtp: ememoOtp ?? this.ememoOtp,
            otpAttempt: otpAttempt ?? this.otpAttempt,
            isKyc: isKyc ?? this.isKyc,
            preferredLanes: preferredLanes ?? this.preferredLanes,
            roleId: roleId ?? this.roleId,
            tempFlg: tempFlg ?? this.tempFlg,
            status: status ?? this.status,
            isLogin: isLogin ?? this.isLogin,
            blueIdFlg: blueIdFlg ?? this.blueIdFlg,
            kycPendingDate: kycPendingDate ?? this.kycPendingDate,
            kycVerificationDate: kycVerificationDate ?? this.kycVerificationDate,
            accessToken: accessToken ?? this.accessToken,
            refreshToken: refreshToken ?? this.refreshToken,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
            kycType: kycType ?? this.kycType,
            companyType: companyType ?? this.companyType,
            customerAddress: customerAddress ?? this.customerAddress,
            kycDocs: kycDocs ?? this.kycDocs,
            vehicle: vehicle ?? this.vehicle,
        );
    }

    factory Customer.fromJson(Map<String, dynamic> json){ 
        return Customer(
            customerId: json["customer_id"] ?? "",
            customerName: json["customerName"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            companyTypeId: json["companyTypeId"] ?? 0,
            emailId: json["emailId"] ?? "",
            blueId: json["blueId"] ?? "",
            kycRejectReason: json["kycRejectReason"],
            password: json["password"],
            companyName: json["companyName"] ?? "",
            otp: json["otp"] ?? "",
            ememoOtp: json["ememo_otp"],
            otpAttempt: json["otpAttempt"] ?? "",
            isKyc: json["isKyc"] ?? 0,
            preferredLanes: json["preferredLanes"] == null ? [] : List<int>.from(json["preferredLanes"]!.map((x) => x)),
            roleId: json["roleId"] ?? 0,
            tempFlg: json["tempFlg"] ?? false,
            status: json["status"] ?? 0,
            isLogin: json["isLogin"] ?? false,
            blueIdFlg: json["blueIdFlg"] ?? false,
            kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
            kycVerificationDate: DateTime.tryParse(json["kycVerificationDate"] ?? ""),
            accessToken: json["accessToken"],
            refreshToken: json["refreshToken"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
            kycType: json["kycType"] == null ? null : Type.fromJson(json["kycType"]),
            companyType: json["companyType"] == null ? null : Type.fromJson(json["companyType"]),
            customerAddress: json["customerAddress"] == null ? null : CustomerAddress.fromJson(json["customerAddress"]),
            kycDocs: json["kycDocs"] == null ? null : KycDocs.fromJson(json["kycDocs"]),
            vehicle: json["vehicle"] == null ? [] : List<Vehicle>.from(json["vehicle"]!.map((x) => Vehicle.fromJson(x))),
        );
    }

}

class Type {
    Type({
        required this.id,
        required this.companyType,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
        required this.kycType,
    });

    final int id;
    final String companyType;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;
    final String kycType;

    Type copyWith({
        int? id,
        String? companyType,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
        String? kycType,
    }) {
        return Type(
            id: id ?? this.id,
            companyType: companyType ?? this.companyType,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
            kycType: kycType ?? this.kycType,
        );
    }

    factory Type.fromJson(Map<String, dynamic> json){ 
        return Type(
            id: json["id"] ?? 0,
            companyType: json["companyType"] ?? "",
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
            kycType: json["kycType"] ?? "",
        );
    }

}

class CustomerAddress {
    CustomerAddress({
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

    CustomerAddress copyWith({
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
        return CustomerAddress(
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

    factory CustomerAddress.fromJson(Map<String, dynamic> json){ 
        return CustomerAddress(
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

class KycDocs {
    KycDocs({
        required this.kycDocsId,
        required this.customerId,
        required this.docType,
        required this.docNo,
        required this.docLink,
        required this.uploadRc,
        required this.isApproved,
        required this.approvedBy,
        required this.approvedAt,
        required this.status,
        required this.gstin,
        required this.gstinDocLink,
        required this.aadhar,
        required this.aadharDocLink,
        required this.pan,
        required this.panDocLink,
        required this.cheque,
        required this.chequeDocLink,
        required this.drivingLicense,
        required this.drivingLicenseDocLink,
        required this.tds,
        required this.tdsDocLink,
        required this.tan,
        required this.tanDocLink,
        required this.isAadhar,
        required this.isGstin,
        required this.isTan,
        required this.isPan,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String kycDocsId;
    final String customerId;
    final dynamic docType;
    final dynamic docNo;
    final dynamic docLink;
    final dynamic uploadRc;
    final bool isApproved;
    final dynamic approvedBy;
    final dynamic approvedAt;
    final int status;
    final dynamic gstin;
    final dynamic gstinDocLink;
    final String aadhar;
    final dynamic aadharDocLink;
    final dynamic pan;
    final dynamic panDocLink;
    final dynamic cheque;
    final dynamic chequeDocLink;
    final dynamic drivingLicense;
    final dynamic drivingLicenseDocLink;
    final dynamic tds;
    final dynamic tdsDocLink;
    final dynamic tan;
    final dynamic tanDocLink;
    final bool isAadhar;
    final bool isGstin;
    final bool isTan;
    final bool isPan;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    KycDocs copyWith({
        String? kycDocsId,
        String? customerId,
        dynamic? docType,
        dynamic? docNo,
        dynamic? docLink,
        dynamic? uploadRc,
        bool? isApproved,
        dynamic? approvedBy,
        dynamic? approvedAt,
        int? status,
        dynamic? gstin,
        dynamic? gstinDocLink,
        String? aadhar,
        dynamic? aadharDocLink,
        dynamic? pan,
        dynamic? panDocLink,
        dynamic? cheque,
        dynamic? chequeDocLink,
        dynamic? drivingLicense,
        dynamic? drivingLicenseDocLink,
        dynamic? tds,
        dynamic? tdsDocLink,
        dynamic? tan,
        dynamic? tanDocLink,
        bool? isAadhar,
        bool? isGstin,
        bool? isTan,
        bool? isPan,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return KycDocs(
            kycDocsId: kycDocsId ?? this.kycDocsId,
            customerId: customerId ?? this.customerId,
            docType: docType ?? this.docType,
            docNo: docNo ?? this.docNo,
            docLink: docLink ?? this.docLink,
            uploadRc: uploadRc ?? this.uploadRc,
            isApproved: isApproved ?? this.isApproved,
            approvedBy: approvedBy ?? this.approvedBy,
            approvedAt: approvedAt ?? this.approvedAt,
            status: status ?? this.status,
            gstin: gstin ?? this.gstin,
            gstinDocLink: gstinDocLink ?? this.gstinDocLink,
            aadhar: aadhar ?? this.aadhar,
            aadharDocLink: aadharDocLink ?? this.aadharDocLink,
            pan: pan ?? this.pan,
            panDocLink: panDocLink ?? this.panDocLink,
            cheque: cheque ?? this.cheque,
            chequeDocLink: chequeDocLink ?? this.chequeDocLink,
            drivingLicense: drivingLicense ?? this.drivingLicense,
            drivingLicenseDocLink: drivingLicenseDocLink ?? this.drivingLicenseDocLink,
            tds: tds ?? this.tds,
            tdsDocLink: tdsDocLink ?? this.tdsDocLink,
            tan: tan ?? this.tan,
            tanDocLink: tanDocLink ?? this.tanDocLink,
            isAadhar: isAadhar ?? this.isAadhar,
            isGstin: isGstin ?? this.isGstin,
            isTan: isTan ?? this.isTan,
            isPan: isPan ?? this.isPan,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory KycDocs.fromJson(Map<String, dynamic> json){ 
        return KycDocs(
            kycDocsId: json["kyc_docs_id"] ?? "",
            customerId: json["customer_id"] ?? "",
            docType: json["doc_type"],
            docNo: json["doc_no"],
            docLink: json["doc_link"],
            uploadRc: json["upload_rc"],
            isApproved: json["is_approved"] ?? false,
            approvedBy: json["approved_by"],
            approvedAt: json["approved_at"],
            status: json["status"] ?? 0,
            gstin: json["gstin"],
            gstinDocLink: json["gstin_doc_link"],
            aadhar: json["aadhar"] ?? "",
            aadharDocLink: json["aadhar_doc_link"],
            pan: json["pan"],
            panDocLink: json["pan_doc_link"],
            cheque: json["cheque"],
            chequeDocLink: json["cheque_doc_link"],
            drivingLicense: json["driving_license"],
            drivingLicenseDocLink: json["driving_license_doc_link"],
            tds: json["tds"],
            tdsDocLink: json["tds_doc_link"],
            tan: json["tan"],
            tanDocLink: json["tan_doc_link"],
            isAadhar: json["is_aadhar"] ?? false,
            isGstin: json["is_gstin"] ?? false,
            isTan: json["is_tan"] ?? false,
            isPan: json["is_pan"] ?? false,
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            deletedAt: json["deleted_at"],
        );
    }

}

class Vehicle {
    Vehicle({
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

    Vehicle copyWith({
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
        return Vehicle(
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

    factory Vehicle.fromJson(Map<String, dynamic> json){ 
        return Vehicle(
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


class DocumentDetails {
    DocumentDetails({
        required this.documentId,
        required this.title,
        required this.documentType,
        required this.fileSize,
        required this.originalFilename,
    });

    final String documentId;
    final String title;
    final String documentType;
    final String fileSize;
    final String originalFilename;

    DocumentDetails copyWith({
        String? documentId,
        String? title,
        String? documentType,
        String? fileSize,
        String? originalFilename,
    }) {
        return DocumentDetails(
            documentId: documentId ?? this.documentId,
            title: title ?? this.title,
            documentType: documentType ?? this.documentType,
            fileSize: fileSize ?? this.fileSize,
            originalFilename: originalFilename ?? this.originalFilename,
        );
    }

    factory DocumentDetails.fromJson(Map<String, dynamic> json){ 
        return DocumentDetails(
            documentId: json["documentId"] ?? "",
            title: json["title"] ?? "",
            documentType: json["documentType"] ?? "",
            fileSize: json["fileSize"] ?? "",
            originalFilename: json["originalFilename"] ?? "",
        );
    }

}

class LoadMemo {
    LoadMemo({
        required this.id,
        required this.loadId,
        required this.memoNumber,
        required this.netFreight,
        required this.advance,
        required this.advancePercentage,
        required this.balance,
        required this.balancePercentage,
        required this.status,
        required this.createAt,
        required this.deletedAt,
    });

    final String id;
    final String loadId;
    final String memoNumber;
    final String netFreight;
    final String advance;
    final String advancePercentage;
    final String balance;
    final String balancePercentage;
    final int status;
    final DateTime? createAt;
    final dynamic deletedAt;

    LoadMemo copyWith({
        String? id,
        String? loadId,
        String? memoNumber,
        String? netFreight,
        String? advance,
        String? advancePercentage,
        String? balance,
        String? balancePercentage,
        int? status,
        DateTime? createAt,
        dynamic? deletedAt,
    }) {
        return LoadMemo(
            id: id ?? this.id,
            loadId: loadId ?? this.loadId,
            memoNumber: memoNumber ?? this.memoNumber,
            netFreight: netFreight ?? this.netFreight,
            advance: advance ?? this.advance,
            advancePercentage: advancePercentage ?? this.advancePercentage,
            balance: balance ?? this.balance,
            balancePercentage: balancePercentage ?? this.balancePercentage,
            status: status ?? this.status,
            createAt: createAt ?? this.createAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory LoadMemo.fromJson(Map<String, dynamic> json){ 
        return LoadMemo(
            id: json["id"] ?? "",
            loadId: json["loadId"] ?? "",
            memoNumber: json["memoNumber"] ?? "",
            netFreight: json["netFreight"] ?? "",
            advance: json["advance"] ?? "",
            advancePercentage: json["advancePercentage"] ?? "",
            balance: json["balance"] ?? "",
            balancePercentage: json["balancePercentage"] ?? "",
            status: json["status"] ?? 0,
            createAt: DateTime.tryParse(json["createAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class LoadPrice {
    LoadPrice({
        required this.loadPriceId,
        required this.loadId,
        required this.rate,
        required this.maxRate,
        required this.vpRate,
        required this.vpMaxRate,
        required this.margin,
        required this.maxMargin,
        required this.marginPercentage,
        required this.handlingCharges,
        required this.status,
        required this.createAt,
        required this.updateAt,
        required this.deletedAt,
    });

    final String loadPriceId;
    final String loadId;
    final int rate;
    final int maxRate;
    final int vpRate;
    final int vpMaxRate;
    final int margin;
    final int maxMargin;
    final int marginPercentage;
    final int handlingCharges;
    final int status;
    final DateTime? createAt;
    final DateTime? updateAt;
    final dynamic deletedAt;

    LoadPrice copyWith({
        String? loadPriceId,
        String? loadId,
        int? rate,
        int? maxRate,
        int? vpRate,
        int? vpMaxRate,
        int? margin,
        int? maxMargin,
        int? marginPercentage,
        int? handlingCharges,
        int? status,
        DateTime? createAt,
        DateTime? updateAt,
        dynamic? deletedAt,
    }) {
        return LoadPrice(
            loadPriceId: loadPriceId ?? this.loadPriceId,
            loadId: loadId ?? this.loadId,
            rate: rate ?? this.rate,
            maxRate: maxRate ?? this.maxRate,
            vpRate: vpRate ?? this.vpRate,
            vpMaxRate: vpMaxRate ?? this.vpMaxRate,
            margin: margin ?? this.margin,
            maxMargin: maxMargin ?? this.maxMargin,
            marginPercentage: marginPercentage ?? this.marginPercentage,
            handlingCharges: handlingCharges ?? this.handlingCharges,
            status: status ?? this.status,
            createAt: createAt ?? this.createAt,
            updateAt: updateAt ?? this.updateAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory LoadPrice.fromJson(Map<String, dynamic> json){ 
        return LoadPrice(
            loadPriceId: json["loadPriceId"] ?? "",
            loadId: json["loadId"] ?? "",
            rate: json["rate"] ?? 0,
            maxRate: json["maxRate"] ?? 0,
            vpRate: json["vpRate"] ?? 0,
            vpMaxRate: json["vpMaxRate"] ?? 0,
            margin:  parseInt(json["margin"]) ?? 0,
            maxMargin: parseInt(json["maxMargin"]) ?? 0,
            marginPercentage: json["marginPercentage"] ?? 0,
            handlingCharges: json["handlingCharges"] ?? 0,
            status: json["status"] ?? 0,
            createAt: DateTime.tryParse(json["createAt"] ?? ""),
            updateAt: DateTime.tryParse(json["updateAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class LoadRoute {
    LoadRoute({
        required this.loadRouteId,
        required this.loadId,
        required this.pickUpAddr,
        required this.pickUpLocation,
        required this.pickUpLatlon,
        required this.dropAddr,
        required this.dropLocation,
        required this.dropLatlon,
        required this.pickUpWholeAddr,
        required this.dropWholeAddr,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String loadRouteId;
    final String loadId;
    final String pickUpAddr;
    final String pickUpLocation;
    final String pickUpLatlon;
    final String dropAddr;
    final String dropLocation;
    final String dropLatlon;
    final String pickUpWholeAddr;
    final String dropWholeAddr;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    LoadRoute copyWith({
        String? loadRouteId,
        String? loadId,
        String? pickUpAddr,
        String? pickUpLocation,
        String? pickUpLatlon,
        String? dropAddr,
        String? dropLocation,
        String? dropLatlon,
        String? pickUpWholeAddr,
        String? dropWholeAddr,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return LoadRoute(
            loadRouteId: loadRouteId ?? this.loadRouteId,
            loadId: loadId ?? this.loadId,
            pickUpAddr: pickUpAddr ?? this.pickUpAddr,
            pickUpLocation: pickUpLocation ?? this.pickUpLocation,
            pickUpLatlon: pickUpLatlon ?? this.pickUpLatlon,
            dropAddr: dropAddr ?? this.dropAddr,
            dropLocation: dropLocation ?? this.dropLocation,
            dropLatlon: dropLatlon ?? this.dropLatlon,
            pickUpWholeAddr: pickUpWholeAddr ?? this.pickUpWholeAddr,
            dropWholeAddr: dropWholeAddr ?? this.dropWholeAddr,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory LoadRoute.fromJson(Map<String, dynamic> json){ 
        return LoadRoute(
            loadRouteId: json["loadRouteId"] ?? "",
            loadId: json["loadId"] ?? "",
            pickUpAddr: json["pickUpAddr"] ?? "",
            pickUpLocation: json["pickUpLocation"] ?? "",
            pickUpLatlon: json["pickUpLatlon"] ?? "",
            dropAddr: json["dropAddr"] ?? "",
            dropLocation: json["dropLocation"] ?? "",
            dropLatlon: json["dropLatlon"] ?? "",
            pickUpWholeAddr: json["pickUpWholeAddr"] ?? "",
            dropWholeAddr: json["dropWholeAddr"] ?? "",
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class LoadStatusDetails {
  LoadStatusDetails({
    required this.id,
    required this.loadStatus,
    required this.status,
    required this.statusBgColor,
    required this.statusTxtColor,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  final int id;
  final String loadStatus;
  final int status;
  final String statusBgColor;
  final String statusTxtColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  LoadStatusDetails copyWith({
    int? id,
    String? loadStatus,
    int? status,
    String? statusBgColor,
    String? statusTxtColor,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
  }) {
    return LoadStatusDetails(
      id: id ?? this.id,
      loadStatus: loadStatus ?? this.loadStatus,
      status: status ?? this.status,
      statusBgColor: statusBgColor ?? this.statusBgColor,
      statusTxtColor: statusTxtColor ?? this.statusTxtColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  factory LoadStatusDetails.fromJson(Map<String, dynamic> json){
    return LoadStatusDetails(
      id: json["id"] ?? 0,
      loadStatus: json["loadStatus"] ?? "",
      status: json["status"] ?? 0,
      statusBgColor: json["statusBgColor"] ?? "",
      statusTxtColor: json["statusTxtColor"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      deletedAt: json["deletedAt"],
    );
  }

}
class ScheduleTripDetails {
    ScheduleTripDetails({
        required this.scheduleTripId,
        required this.vehicleId,
        required this.driverId,
        required this.acceptedBy,
        required this.etaForPickUp,
        required this.expectedDeliveryDate,
        required this.possibleDeliveryDate,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
        required this.loadId,
        required this.driver,
        required this.vehicle,
    });

    final String scheduleTripId;
    final String vehicleId;
    final String driverId;
    final String acceptedBy;
    final DateTime? etaForPickUp;
    final DateTime? expectedDeliveryDate;
    final DateTime? possibleDeliveryDate;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;
    final String loadId;
    final Driver? driver;
    final ScheduleTripDetailVehicle? vehicle;

    ScheduleTripDetails copyWith({
        String? scheduleTripId,
        String? vehicleId,
        String? driverId,
        String? acceptedBy,
        DateTime? etaForPickUp,
        DateTime? expectedDeliveryDate,
        DateTime? possibleDeliveryDate,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
        String? loadId,
        Driver? driver,
        ScheduleTripDetailVehicle? vehicle,
    }) {
        return ScheduleTripDetails(
            scheduleTripId: scheduleTripId ?? this.scheduleTripId,
            vehicleId: vehicleId ?? this.vehicleId,
            driverId: driverId ?? this.driverId,
            acceptedBy: acceptedBy ?? this.acceptedBy,
            etaForPickUp: etaForPickUp ?? this.etaForPickUp,
            expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
            possibleDeliveryDate: possibleDeliveryDate ?? this.possibleDeliveryDate,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
            loadId: loadId ?? this.loadId,
            driver: driver ?? this.driver,
            vehicle: vehicle ?? this.vehicle,
        );
    }

    factory ScheduleTripDetails.fromJson(Map<String, dynamic> json){ 
        return ScheduleTripDetails(
            scheduleTripId: json["scheduleTripId"] ?? "",
            vehicleId: json["vehicleId"] ?? "",
            driverId: json["driverId"] ?? "",
            acceptedBy: json["acceptedBy"] ?? "",
            etaForPickUp: DateTime.tryParse(json["etaForPickUp"] ?? ""),
            expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
            possibleDeliveryDate: DateTime.tryParse(json["possibleDeliveryDate"] ?? ""),
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
            loadId: json["loadId"] ?? "",
            driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]),
            vehicle: json["vehicle"] == null ? null : ScheduleTripDetailVehicle.fromJson(json["vehicle"]),
        );
    }

}

class DriverData {
    DriverData({
        required this.driverId,
        required this.name,
        required this.mobile,
        required this.email,
        required this.licenseNumber,
        required this.licenseDocLink,
        required this.licenseExpiryDate,
        required this.customerId,
        required this.dateOfBirth,
        required this.driverStatus,
        required this.experience,
        required this.bloodGroup,
        required this.licenseCategory,
        required this.specialLicense,
        required this.communicationPreference,
        required this.companyDetails,
    });

    final String driverId;
    final String name;
    final String mobile;
    final String email;
    final String licenseNumber;
    final dynamic licenseDocLink;
    final DateTime? licenseExpiryDate;
    final String customerId;
    final DateTime? dateOfBirth;
    final int driverStatus;
    final String experience;
    final int bloodGroup;
    final int licenseCategory;
    final int specialLicense;
    final String communicationPreference;
    final CompanyDetails? companyDetails;

    DriverData copyWith({
        String? driverId,
        String? name,
        String? mobile,
        String? email,
        String? licenseNumber,
        dynamic? licenseDocLink,
        DateTime? licenseExpiryDate,
        String? customerId,
        DateTime? dateOfBirth,
        int? driverStatus,
        String? experience,
        int? bloodGroup,
        int? licenseCategory,
        int? specialLicense,
        String? communicationPreference,
        CompanyDetails? companyDetails,
    }) {
        return DriverData(
            driverId: driverId ?? this.driverId,
            name: name ?? this.name,
            mobile: mobile ?? this.mobile,
            email: email ?? this.email,
            licenseNumber: licenseNumber ?? this.licenseNumber,
            licenseDocLink: licenseDocLink ?? this.licenseDocLink,
            licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
            customerId: customerId ?? this.customerId,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            driverStatus: driverStatus ?? this.driverStatus,
            experience: experience ?? this.experience,
            bloodGroup: bloodGroup ?? this.bloodGroup,
            licenseCategory: licenseCategory ?? this.licenseCategory,
            specialLicense: specialLicense ?? this.specialLicense,
            communicationPreference: communicationPreference ?? this.communicationPreference,
            companyDetails: companyDetails ?? this.companyDetails,
        );
    }

    factory DriverData.fromJson(Map<String, dynamic> json){ 
        return DriverData(
            driverId: json["driverId"] ?? "",
            name: json["name"] ?? "",
            mobile: json["mobile"] ?? "",
            email: json["email"] ?? "",
            licenseNumber: json["licenseNumber"] ?? "",
            licenseDocLink: json["licenseDocLink"],
            licenseExpiryDate: DateTime.tryParse(json["licenseExpiryDate"] ?? ""),
            customerId: json["customerId"] ?? "",
            dateOfBirth: DateTime.tryParse(json["dateOfBirth"] ?? ""),
            driverStatus: json["driverStatus"] ?? 0,
            experience: json["experience"] ?? "",
            bloodGroup: json["bloodGroup"] ?? 0,
            licenseCategory: json["licenseCategory"] ?? 0,
            specialLicense: json["specialLicense"] ?? 0,
            communicationPreference: json["communicationPreference"] ?? "",
            companyDetails: json["companyDetails"] == null ? null : CompanyDetails.fromJson(json["companyDetails"]),
        );
    }

}

class CompanyDetails {
    CompanyDetails({
        required this.companyName,
        required this.companyTypeId,
        required this.mobile,
        required this.gstin,
    });

    final String companyName;
    final int companyTypeId;
    final String mobile;
    final String gstin;

    CompanyDetails copyWith({
        String? companyName,
        int? companyTypeId,
        String? mobile,
        String? gstin,
    }) {
        return CompanyDetails(
            companyName: companyName ?? this.companyName,
            companyTypeId: companyTypeId ?? this.companyTypeId,
            mobile: mobile ?? this.mobile,
            gstin: gstin ?? this.gstin,
        );
    }

    factory CompanyDetails.fromJson(Map<String, dynamic> json){ 
        return CompanyDetails(
            companyName: json["companyName"] ?? "",
            companyTypeId: json["companyTypeId"] ?? 0,
            mobile: json["mobile"] ?? "",
            gstin: json["gstin"] ?? "",
        );
    }

}

class ScheduleTripDetailVehicle {
    ScheduleTripDetailVehicle({
        required this.vehicle,
        required this.companyName,
        required this.truckType,
    });

    final VehicleVehicle? vehicle;
    final String companyName;
    final TruckType? truckType;

    ScheduleTripDetailVehicle copyWith({
        VehicleVehicle? vehicle,
        String? companyName,
        TruckType? truckType,
    }) {
        return ScheduleTripDetailVehicle(
            vehicle: vehicle ?? this.vehicle,
            companyName: companyName ?? this.companyName,
            truckType: truckType ?? this.truckType,
        );
    }

    factory ScheduleTripDetailVehicle.fromJson(Map<String, dynamic> json){ 
        return ScheduleTripDetailVehicle(
            vehicle: json["vehicle"] == null ? null : VehicleVehicle.fromJson(json["vehicle"]),
            companyName: json["companyName"] ?? "",
            truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
        );
    }

}

class TruckType {
    TruckType({
        required this.id,
        required this.type,
        required this.subType,
        required this.iconUrl,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int id;
    final String type;
    final String subType;
    final dynamic iconUrl;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    TruckType copyWith({
        int? id,
        String? type,
        String? subType,
        dynamic? iconUrl,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return TruckType(
            id: id ?? this.id,
            type: type ?? this.type,
            subType: subType ?? this.subType,
            iconUrl: iconUrl ?? this.iconUrl,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory TruckType.fromJson(Map<String, dynamic> json){ 
        return TruckType(
            id: json["id"] ?? 0,
            type: json["type"] ?? "",
            subType: json["subType"] ?? "",
            iconUrl: json["iconUrl"],
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class VehicleVehicle {
    VehicleVehicle({
        required this.vehicleId,
        required this.customerId,
        required this.truckNo,
        required this.ownerName,
        required this.registrationDate,
        required this.tonnage,
        required this.truckTypeId,
        required this.modelNumber,
        required this.rcNumber,
        required this.rcDocLink,
        required this.insurancePolicyNumber,
        required this.insuranceValidityDate,
        required this.fcExpiryDate,
        required this.pucExpiryDate,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.customer,
    });

    final String vehicleId;
    final String customerId;
    final String truckNo;
    final String ownerName;
    final DateTime? registrationDate;
    final String tonnage;
    final int truckTypeId;
    final String modelNumber;
    final dynamic rcNumber;
    final dynamic rcDocLink;
    final String insurancePolicyNumber;
    final DateTime? insuranceValidityDate;
    final DateTime? fcExpiryDate;
    final DateTime? pucExpiryDate;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final Customer? customer;

    VehicleVehicle copyWith({
        String? vehicleId,
        String? customerId,
        String? truckNo,
        String? ownerName,
        DateTime? registrationDate,
        String? tonnage,
        int? truckTypeId,
        String? modelNumber,
        dynamic? rcNumber,
        dynamic? rcDocLink,
        String? insurancePolicyNumber,
        DateTime? insuranceValidityDate,
        DateTime? fcExpiryDate,
        DateTime? pucExpiryDate,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
        Customer? customer,
    }) {
        return VehicleVehicle(
            vehicleId: vehicleId ?? this.vehicleId,
            customerId: customerId ?? this.customerId,
            truckNo: truckNo ?? this.truckNo,
            ownerName: ownerName ?? this.ownerName,
            registrationDate: registrationDate ?? this.registrationDate,
            tonnage: tonnage ?? this.tonnage,
            truckTypeId: truckTypeId ?? this.truckTypeId,
            modelNumber: modelNumber ?? this.modelNumber,
            rcNumber: rcNumber ?? this.rcNumber,
            rcDocLink: rcDocLink ?? this.rcDocLink,
            insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
            insuranceValidityDate: insuranceValidityDate ?? this.insuranceValidityDate,
            fcExpiryDate: fcExpiryDate ?? this.fcExpiryDate,
            pucExpiryDate: pucExpiryDate ?? this.pucExpiryDate,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
            customer: customer ?? this.customer,
        );
    }

    factory VehicleVehicle.fromJson(Map<String, dynamic> json){ 
        return VehicleVehicle(
            vehicleId: json["vehicleId"] ?? "",
            customerId: json["customerId"] ?? "",
            truckNo: json["truckNo"] ?? "",
            ownerName: json["ownerName"] ?? "",
            registrationDate: DateTime.tryParse(json["registrationDate"] ?? ""),
            tonnage: json["tonnage"] ?? "",
            truckTypeId: json["truckTypeId"] ?? 0,
            modelNumber: json["modelNumber"] ?? "",
            rcNumber: json["rcNumber"],
            rcDocLink: json["rcDocLink"],
            insurancePolicyNumber: json["insurancePolicyNumber"] ?? "",
            insuranceValidityDate: DateTime.tryParse(json["insuranceValidityDate"] ?? ""),
            fcExpiryDate: DateTime.tryParse(json["fcExpiryDate"] ?? ""),
            pucExpiryDate: DateTime.tryParse(json["pucExpiryDate"] ?? ""),
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
            customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        );
    }

}

class DriverCustomer {
    DriverCustomer({
        required this.customerId,
        required this.customerName,
        required this.mobileNumber,
        required this.companyTypeId,
        required this.emailId,
        required this.blueId,
        required this.kycRejectReason,
        required this.password,
        required this.companyName,
        required this.otp,
        required this.ememoOtp,
        required this.otpAttempt,
        required this.isKyc,
        required this.preferredLanes,
        required this.roleId,
        required this.tempFlg,
        required this.status,
        required this.isLogin,
        required this.blueIdFlg,
        required this.kycPendingDate,
        required this.kycVerificationDate,
        required this.customerSeriesNo,
        required this.createdAt,
        required this.deletedAt,
        required this.isErpSynced,
        required this.virtualAccountId,
    });

    final String customerId;
    final String customerName;
    final String mobileNumber;
    final int companyTypeId;
    final String emailId;
    final String blueId;
    final dynamic kycRejectReason;
    final dynamic password;
    final String companyName;
    final String otp;
    final dynamic ememoOtp;
    final String otpAttempt;
    final int isKyc;
    final dynamic preferredLanes;
    final int roleId;
    final bool tempFlg;
    final int status;
    final bool isLogin;
    final bool blueIdFlg;
    final DateTime? kycPendingDate;
    final DateTime? kycVerificationDate;
    final int customerSeriesNo;
    final DateTime? createdAt;
    final dynamic deletedAt;
    final bool isErpSynced;
    final String virtualAccountId;

    DriverCustomer copyWith({
        String? customerId,
        String? customerName,
        String? mobileNumber,
        int? companyTypeId,
        String? emailId,
        String? blueId,
        dynamic? kycRejectReason,
        dynamic? password,
        String? companyName,
        String? otp,
        dynamic? ememoOtp,
        String? otpAttempt,
        int? isKyc,
        dynamic? preferredLanes,
        int? roleId,
        bool? tempFlg,
        int? status,
        bool? isLogin,
        bool? blueIdFlg,
        DateTime? kycPendingDate,
        DateTime? kycVerificationDate,
        int? customerSeriesNo,
        DateTime? createdAt,
        dynamic? deletedAt,
        bool? isErpSynced,
        String? virtualAccountId,
    }) {
        return DriverCustomer(
            customerId: customerId ?? this.customerId,
            customerName: customerName ?? this.customerName,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            companyTypeId: companyTypeId ?? this.companyTypeId,
            emailId: emailId ?? this.emailId,
            blueId: blueId ?? this.blueId,
            kycRejectReason: kycRejectReason ?? this.kycRejectReason,
            password: password ?? this.password,
            companyName: companyName ?? this.companyName,
            otp: otp ?? this.otp,
            ememoOtp: ememoOtp ?? this.ememoOtp,
            otpAttempt: otpAttempt ?? this.otpAttempt,
            isKyc: isKyc ?? this.isKyc,
            preferredLanes: preferredLanes ?? this.preferredLanes,
            roleId: roleId ?? this.roleId,
            tempFlg: tempFlg ?? this.tempFlg,
            status: status ?? this.status,
            isLogin: isLogin ?? this.isLogin,
            blueIdFlg: blueIdFlg ?? this.blueIdFlg,
            kycPendingDate: kycPendingDate ?? this.kycPendingDate,
            kycVerificationDate: kycVerificationDate ?? this.kycVerificationDate,
            customerSeriesNo: customerSeriesNo ?? this.customerSeriesNo,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
            isErpSynced: isErpSynced ?? this.isErpSynced,
            virtualAccountId: virtualAccountId ?? this.virtualAccountId,
        );
    }

    factory DriverCustomer.fromJson(Map<String, dynamic> json){ 
        return DriverCustomer(
            customerId: json["customer_id"] ?? "",
            customerName: json["customerName"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            companyTypeId: json["companyTypeId"] ?? 0,
            emailId: json["emailId"] ?? "",
            blueId: json["blueId"] ?? "",
            kycRejectReason: json["kycRejectReason"],
            password: json["password"],
            companyName: json["companyName"] ?? "",
            otp: json["otp"] ?? "",
            ememoOtp: json["ememo_otp"],
            otpAttempt: json["otpAttempt"] ?? "",
            isKyc: json["isKyc"] ?? 0,
            preferredLanes: json["preferredLanes"],
            roleId: json["roleId"] ?? 0,
            tempFlg: json["tempFlg"] ?? false,
            status: json["status"] ?? 0,
            isLogin: json["isLogin"] ?? false,
            blueIdFlg: json["blueIdFlg"] ?? false,
            kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
            kycVerificationDate: DateTime.tryParse(json["kycVerificationDate"] ?? ""),
            customerSeriesNo: json["customerSeriesNo"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
            isErpSynced: json["isErpSynced"] ?? false,
            virtualAccountId: json["virtualAccountId"] ?? "",
        );
    }

}

class Timeline {
  Timeline({
    required this.id,
    required this.label,
    required this.status,
    required this.statusBgColor,
    required this.timestamp,
    required this.commodity,
    required this.truckType,
    required this.loadProvider,
    required this.latestTransitData,
  });

  final int id;
  final String label;
  final String status;
  final String statusBgColor;
  final DateTime? timestamp;
  final TimelineCommodity? commodity;
  final TimelineTruckType? truckType;
  final LoadProvider? loadProvider;
  final LatestTransitData? latestTransitData;

  Timeline copyWith({
    int? id,
    String? label,
    String? status,
    String? statusBgColor,
    DateTime? timestamp,
    TimelineCommodity? commodity,
    TimelineTruckType? truckType,
    LoadProvider? loadProvider,
    LatestTransitData? latestTransitData,
  }) {
    return Timeline(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      statusBgColor: statusBgColor ?? this.statusBgColor,
      timestamp: timestamp ?? this.timestamp,
      commodity: commodity ?? this.commodity,
      truckType: truckType ?? this.truckType,
      loadProvider: loadProvider ?? this.loadProvider,
      latestTransitData: latestTransitData ?? this.latestTransitData,
    );
  }

  factory Timeline.fromJson(Map<String, dynamic> json){
    return Timeline(
      id: json["id"] ?? 0,
      label: json["label"] ?? "",
      status: json["status"] ?? "",
      statusBgColor: json["statusBgColor"] ?? "",
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      commodity: json["commodity"] == null ? null : TimelineCommodity.fromJson(json["commodity"]),
      truckType: json["truckType"] == null ? null : TimelineTruckType.fromJson(json["truckType"]),
      loadProvider: json["loadProvider"] == null ? null : LoadProvider.fromJson(json["loadProvider"]),
      latestTransitData: json["latestTransitData"] == null ? null : LatestTransitData.fromJson(json["latestTransitData"]),
    );
  }

}

class LatestTransitData {
  LatestTransitData({
    required this.location,
    required this.latestDate,
  });

  final String location;
  final DateTime? latestDate;

  LatestTransitData copyWith({
    String? location,
    DateTime? latestDate,
  }) {
    return LatestTransitData(
      location: location ?? this.location,
      latestDate: latestDate ?? this.latestDate,
    );
  }

  factory LatestTransitData.fromJson(Map<String, dynamic> json){
    return LatestTransitData(
      location: json["location"] ?? "",
      latestDate: DateTime.tryParse(json["latestDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "location": location,
    "latestDate": latestDate?.toIso8601String(),
  };

}

class TimelineCommodity {
    TimelineCommodity({
        required this.id,
        required this.name,
        required this.description,
    });

    final int id;
    final String name;
    final dynamic description;

    TimelineCommodity copyWith({
        int? id,
        String? name,
        dynamic? description,
    }) {
        return TimelineCommodity(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
        );
    }

    factory TimelineCommodity.fromJson(Map<String, dynamic> json){ 
        return TimelineCommodity(
            id: json["id"] ?? 0,
            name: json["name"] ?? "",
            description: json["description"],
        );
    }

}

class LoadProvider {
    LoadProvider({
        required this.companyName,
    });

    final String companyName;

    LoadProvider copyWith({
        String? companyName,
    }) {
        return LoadProvider(
            companyName: companyName ?? this.companyName,
        );
    }

    factory LoadProvider.fromJson(Map<String, dynamic> json){ 
        return LoadProvider(
            companyName: json["companyName"] ?? "",
        );
    }

}

class TimelineTruckType {
    TimelineTruckType({
        required this.id,
        required this.type,
        required this.subType,
    });

    final int id;
    final String type;
    final String subType;

    TimelineTruckType copyWith({
        int? id,
        String? type,
        String? subType,
    }) {
        return TimelineTruckType(
            id: id ?? this.id,
            type: type ?? this.type,
            subType: subType ?? this.subType,
        );
    }

    factory TimelineTruckType.fromJson(Map<String, dynamic> json){ 
        return TimelineTruckType(
            id: json["id"] ?? 0,
            type: json["type"] ?? "",
            subType: json["subType"] ?? "",
        );
    }

}

class TrackingDetails {
    TrackingDetails({
        required this.uuid,
        required this.shipperId,
        required this.supplierId,
        required this.tripId,
        required this.trackMode,
        required this.tripStatus,
        required this.currentLat,
        required this.currentLong,
        required this.currentAddress,
        required this.originLat,
        required this.originLong,
        required this.destinationLat,
        required this.destinationLong,
        required this.intugineId,
        required this.driverName,
        required this.driverNumber,
        required this.truckNumber,
        required this.createdAt,
        required this.updatedAt,
        required this.lastTrackDt,
        required this.flaggedTrip,
    });

    final String uuid;
    final String shipperId;
    final String supplierId;
    final String tripId;
    final String trackMode;
    final String tripStatus;
    final double currentLat;
    final double currentLong;
    final dynamic currentAddress;
    final double originLat;
    final double originLong;
    final double destinationLat;
    final double destinationLong;
    final String intugineId;
    final String driverName;
    final String driverNumber;
    final String truckNumber;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final DateTime? lastTrackDt;
    final bool flaggedTrip;

    TrackingDetails copyWith({
        String? uuid,
        String? shipperId,
        String? supplierId,
        String? tripId,
        String? trackMode,
        String? tripStatus,
        double? currentLat,
        double? currentLong,
        dynamic? currentAddress,
        double? originLat,
        double? originLong,
        double? destinationLat,
        double? destinationLong,
        String? intugineId,
        String? driverName,
        String? driverNumber,
        String? truckNumber,
        DateTime? createdAt,
        DateTime? updatedAt,
        DateTime? lastTrackDt,
        bool? flaggedTrip,
    }) {
        return TrackingDetails(
            uuid: uuid ?? this.uuid,
            shipperId: shipperId ?? this.shipperId,
            supplierId: supplierId ?? this.supplierId,
            tripId: tripId ?? this.tripId,
            trackMode: trackMode ?? this.trackMode,
            tripStatus: tripStatus ?? this.tripStatus,
            currentLat: currentLat ?? this.currentLat,
            currentLong: currentLong ?? this.currentLong,
            currentAddress: currentAddress ?? this.currentAddress,
            originLat: originLat ?? this.originLat,
            originLong: originLong ?? this.originLong,
            destinationLat: destinationLat ?? this.destinationLat,
            destinationLong: destinationLong ?? this.destinationLong,
            intugineId: intugineId ?? this.intugineId,
            driverName: driverName ?? this.driverName,
            driverNumber: driverNumber ?? this.driverNumber,
            truckNumber: truckNumber ?? this.truckNumber,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            lastTrackDt: lastTrackDt ?? this.lastTrackDt,
            flaggedTrip: flaggedTrip ?? this.flaggedTrip,
        );
    }

    factory TrackingDetails.fromJson(Map<String, dynamic> json){ 
        return TrackingDetails(
            uuid: json["uuid"] ?? "",
            shipperId: json["shipperId"] ?? "",
            supplierId: json["supplierId"] ?? "",
            tripId: json["tripId"] ?? "",
            trackMode: json["trackMode"] ?? "",
            tripStatus: json["tripStatus"] ?? "",
            currentLat: json["currentLat"] ?? 0.0,
            currentLong: json["currentLong"] ?? 0.0,
            currentAddress: json["currentAddress"],
            originLat: json["originLat"] ?? 0.0,
            originLong: json["originLong"] ?? 0.0,
            destinationLat: json["destinationLat"] ?? 0.0,
            destinationLong: json["destinationLong"] ?? 0.0,
            intugineId: json["intugineId"] ?? "",
            driverName: json["driverName"] ?? "",
            driverNumber: json["driverNumber"] ?? "",
            truckNumber: json["truckNumber"] ?? "",
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            lastTrackDt: DateTime.tryParse(json["lastTrackDt"] ?? ""),
            flaggedTrip: json["flaggedTrip"] ?? false,
        );
    }

}

class DataTruckType {
    DataTruckType({
        required this.id,
        required this.type,
        required this.subType,
        required this.iconUrl,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int id;
    final String type;
    final String subType;
    final dynamic iconUrl;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    DataTruckType copyWith({
        int? id,
        String? type,
        String? subType,
        dynamic? iconUrl,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return DataTruckType(
            id: id ?? this.id,
            type: type ?? this.type,
            subType: subType ?? this.subType,
            iconUrl: iconUrl ?? this.iconUrl,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory DataTruckType.fromJson(Map<String, dynamic> json){ 
        return DataTruckType(
            id: json["id"] ?? 0,
            type: json["type"] ?? "",
            subType: json["subType"] ?? "",
            iconUrl: json["iconUrl"],
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class Weight {
    Weight({
        required this.weightageId,
        required this.measurementUnitId,
        required this.value,
        required this.description,
        required this.status,
        required this.createdAt,
        required this.deletedAt,
    });

    final int weightageId;
    final int measurementUnitId;
    final int value;
    final dynamic description;
    final int status;
    final DateTime? createdAt;
    final dynamic deletedAt;

    Weight copyWith({
        int? weightageId,
        int? measurementUnitId,
        int? value,
        dynamic? description,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return Weight(
            weightageId: weightageId ?? this.weightageId,
            measurementUnitId: measurementUnitId ?? this.measurementUnitId,
            value: value ?? this.value,
            description: description ?? this.description,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory Weight.fromJson(Map<String, dynamic> json){ 
        return Weight(
            weightageId: json["weightageId"] ?? 0,
            measurementUnitId: json["measurementUnitId"] ?? 0,
            value: json["value"] ?? 0,
            description: json["description"],
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}


class DriverConsignee {
    DriverConsignee({
        required this.id,
        required this.name,
        required this.email,
        required this.mobileNumber,
        required this.loadId,
    });

    final String id;
    final String name;
    final String email;
    final String mobileNumber;
    final String loadId;

    DriverConsignee copyWith({
        String? id,
        String? name,
        String? email,
        String? mobileNumber,
        String? loadId,
    }) {
        return DriverConsignee(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            loadId: loadId ?? this.loadId,
        );
    }

    factory DriverConsignee.fromJson(Map<String, dynamic> json){ 
        return DriverConsignee(
            id: json["id"] ?? "",
            name: json["name"] ?? "",
            email: json["email"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            loadId: json["loadId"] ?? "",
        );
    }

}

class DriverloadSettlement {
    DriverloadSettlement({
        required this.settlementId,
        required this.vehicleId,
        required this.loadId,
        required this.noOfDays,
        required this.amountPerDay,
        required this.loadingCharge,
        required this.unloadingCharge,
        required this.debitDamages,
        required this.debitShortages,
        required this.debitPenalities,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String settlementId;
    final String vehicleId;
    final String loadId;
    final int noOfDays;
    final int amountPerDay;
    final int loadingCharge;
    final int unloadingCharge;
    final int debitDamages;
    final int debitShortages;
    final int debitPenalities;
    final DateTime? createdAt;
    final dynamic updatedAt;
    final dynamic deletedAt;

    DriverloadSettlement copyWith({
        String? settlementId,
        String? vehicleId,
        String? loadId,
        int? noOfDays,
        int? amountPerDay,
        int? loadingCharge,
        int? unloadingCharge,
        int? debitDamages,
        int? debitShortages,
        int? debitPenalities,
        DateTime? createdAt,
        dynamic? updatedAt,
        dynamic? deletedAt,
    }) {
        return DriverloadSettlement(
            settlementId: settlementId ?? this.settlementId,
            vehicleId: vehicleId ?? this.vehicleId,
            loadId: loadId ?? this.loadId,
            noOfDays: noOfDays ?? this.noOfDays,
            amountPerDay: amountPerDay ?? this.amountPerDay,
            loadingCharge: loadingCharge ?? this.loadingCharge,
            unloadingCharge: unloadingCharge ?? this.unloadingCharge,
            debitDamages: debitDamages ?? this.debitDamages,
            debitShortages: debitShortages ?? this.debitShortages,
            debitPenalities: debitPenalities ?? this.debitPenalities,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory DriverloadSettlement.fromJson(Map<String, dynamic> json){ 
        return DriverloadSettlement(
            settlementId: json["settlementId"] ?? "",
            vehicleId: json["vehicleId"] ?? "",
            loadId: json["loadId"] ?? "",
            noOfDays: json["noOfDays"] ?? 0,
            amountPerDay: json["amountPerDay"] ?? 0,
            loadingCharge: json["loadingCharge"] ?? 0,
            unloadingCharge: json["unloadingCharge"] ?? 0,
            debitDamages: json["debitDamages"] ?? 0,
            debitShortages: json["debitShortages"] ?? 0,
            debitPenalities: json["debitPenalities"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: json["updatedAt"],
            deletedAt: json["deletedAt"],
        );
    }

}


class PodDispatchModel {
    PodDispatchModel({
        required this.loadPodId,
        required this.loadId,
        required this.courierCompany,
        required this.awbNumber,
        required this.podTrackingLink,
        required this.podCenterId,
        required this.podCenterName,
        required this.status,
        required this.createAt,
        required this.deletedAt,
    });

    final String loadPodId;
    final String loadId;
    final String courierCompany;
    final String awbNumber;
    final dynamic podTrackingLink;
    final String podCenterId;
    final String podCenterName;
    final int status;
    final DateTime? createAt;
    final dynamic deletedAt;

    PodDispatchModel copyWith({
        String? loadPodId,
        String? loadId,
        String? courierCompany,
        String? awbNumber,
        dynamic? podTrackingLink,
        String? podCenterId,
        String? podCenterName,
        int? status,
        DateTime? createAt,
        dynamic? deletedAt,
    }) {
        return PodDispatchModel(
            loadPodId: loadPodId ?? this.loadPodId,
            loadId: loadId ?? this.loadId,
            courierCompany: courierCompany ?? this.courierCompany,
            awbNumber: awbNumber ?? this.awbNumber,
            podTrackingLink: podTrackingLink ?? this.podTrackingLink,
            podCenterId: podCenterId ?? this.podCenterId,
            podCenterName: podCenterName ?? this.podCenterName,
            status: status ?? this.status,
            createAt: createAt ?? this.createAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory PodDispatchModel.fromJson(Map<String, dynamic> json){ 
        return PodDispatchModel(
            loadPodId: json["loadPodId"] ?? "",
            loadId: json["loadId"] ?? "",
            courierCompany: json["courierCompany"] ?? "",
            awbNumber: json["awbNumber"] ?? "",
            podTrackingLink: json["podTrackingLink"],
            podCenterId: json["podCenterId"] ?? "",
            podCenterName: json["podCenterName"] ?? "",
            status: json["status"] ?? 0,
            createAt: DateTime.tryParse(json["createAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}


int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt(); 
  if (value is String) {
    return double.tryParse(value)?.toInt() ?? 0; 
  }
  return 0; 
}
