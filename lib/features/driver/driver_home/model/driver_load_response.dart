// class LoadDetails {
//   final String loadSeriesID;
//   final String loadId;
//   final String laneId;
//   final int rateId;
//   final String customerId;
//   final int commodityId;
//   final int truckTypeId;
//   final String pickUpAddr;
//   final String pickUpLocation;
//   final int assignStatus;
//   final String pickUpLatlon;
//   final String dropAddr;
//   final String dropLocation;
//   final String dropLatlon;
//   final DateTime dueDate;
//   final int consignmentWeight;
//   final String notes;
//   final String rate;
//   final String vpRate;
//   final String vpMaxRate;
//   final int status;
//   final int loadStatus;
//   final String vehicleLength;
//   final String pickUpDateTime;
//   final DateTime expectedDeliveryDateTime;
//   final int handlingCharges;
//   final String acceptedBy;
//   final DateTime createdAt;
//   final DateTime? updatedAt;
//   final DateTime? deletedAt;
//   final dynamic commodity; // You can replace with proper model if available
//   final dynamic truckType; // You can replace with proper model if available
//   final dynamic customer; // You can replace with proper model if available
//   final List<dynamic> timeline; // Replace dynamic with appropriate class if available
//   final dynamic trip; // Replace with Trip model if available

//   LoadDetails({
//     required this.loadSeriesID,
//     required this.loadId,
//     required this.laneId,
//     required this.rateId,
//     required this.customerId,
//     required this.commodityId,
//     required this.truckTypeId,
//     required this.pickUpAddr,
//     required this.pickUpLocation,
//     required this.assignStatus,
//     required this.pickUpLatlon,
//     required this.dropAddr,
//     required this.dropLocation,
//     required this.dropLatlon,
//     required this.dueDate,
//     required this.consignmentWeight,
//     required this.notes,
//     required this.rate,
//     required this.vpRate,
//     required this.vpMaxRate,
//     required this.status,
//     required this.loadStatus,
//     required this.vehicleLength,
//     required this.pickUpDateTime,
//     required this.expectedDeliveryDateTime,
//     required this.handlingCharges,
//     required this.acceptedBy,
//     required this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//     this.commodity,
//     this.truckType,
//     this.customer,
//     required this.timeline,
//     this.trip,
//   });

//   factory LoadDetails.fromJson(Map<String, dynamic> json) {
//     return LoadDetails(
//       loadSeriesID: json['loadSeriesID'],
//       loadId: json['loadId'],
//       laneId: json['laneId'],
//       rateId: json['rateId'],
//       customerId: json['customerId'],
//       commodityId: json['commodityId'],
//       truckTypeId: json['truckTypeId'],
//       pickUpAddr: json['pickUpAddr'],
//       pickUpLocation: json['pickUpLocation'],
//       assignStatus: json['assignStatus'],
//       pickUpLatlon: json['pickUpLatlon'],
//       dropAddr: json['dropAddr'],
//       dropLocation: json['dropLocation'],
//       dropLatlon: json['dropLatlon'],
//       dueDate: DateTime.parse(json['dueDate']),
//       consignmentWeight: json['consignmentWeight'],
//       notes: json['notes'],
//       rate: json['rate'],
//       vpRate: json['vpRate'],
//       vpMaxRate: json['vpMaxRate'],
//       status: json['status'],
//       loadStatus: json['loadStatus'],
//       vehicleLength: json['vehicleLength'],
//       pickUpDateTime: json['pickUpDateTime'],
//       expectedDeliveryDateTime: DateTime.parse(json['expectedDeliveryDateTime']),
//       handlingCharges: json['handlingCharges'],
//       acceptedBy: json['acceptedBy'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//       deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
//       commodity: json['commodity'],
//       truckType: json['truckType'],
//       customer: json['customer'],
//       timeline: json['timeline'] ?? [],
//       trip: json['trip'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'loadSeriesID': loadSeriesID,
//       'loadId': loadId,
//       'laneId': laneId,
//       'rateId': rateId,
//       'customerId': customerId,
//       'commodityId': commodityId,
//       'truckTypeId': truckTypeId,
//       'pickUpAddr': pickUpAddr,
//       'pickUpLocation': pickUpLocation,
//       'assignStatus': assignStatus,
//       'pickUpLatlon': pickUpLatlon,
//       'dropAddr': dropAddr,
//       'dropLocation': dropLocation,
//       'dropLatlon': dropLatlon,
//       'dueDate': dueDate.toIso8601String(),
//       'consignmentWeight': consignmentWeight,
//       'notes': notes,
//       'rate': rate,
//       'vpRate': vpRate,
//       'vpMaxRate': vpMaxRate,
//       'status': status,
//       'loadStatus': loadStatus,
//       'vehicleLength': vehicleLength,
//       'pickUpDateTime': pickUpDateTime,
//       'expectedDeliveryDateTime': expectedDeliveryDateTime.toIso8601String(),
//       'handlingCharges': handlingCharges,
//       'acceptedBy': acceptedBy,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//       'deletedAt': deletedAt?.toIso8601String(),
//       'commodity': commodity,
//       'truckType': truckType,
//       'customer': customer,
//       'timeline': timeline,
//       'trip': trip,
//     };
//   }
// }


class DriverLoadResponse {
    DriverLoadResponse({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<DriverLoadDetails> data;
    final int total;
    final PageMeta? pageMeta;

    DriverLoadResponse copyWith({
        List<DriverLoadDetails>? data,
        int? total,
        PageMeta? pageMeta,
    }) {
        return DriverLoadResponse(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory DriverLoadResponse.fromJson(Map<String, dynamic> json){ 
        return DriverLoadResponse(
            data: json["data"] == null ? [] : List<DriverLoadDetails>.from(json["data"]!.map((x) => DriverLoadDetails.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class DriverLoadDetails {
    DriverLoadDetails({
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
        required this.scheduleTripDetails,
        required this.loadDocument,
        required this.loadSettlement,
        required this.customer,
        required this.vpCustomer,
        required this.consignees,
        required this.weightage,
        required this.loadApproval,
        required this.podDispatch,
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
    final dynamic notes;
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
    final Commodity? commodity;
    final TruckType? truckType;
    final LoadRoute? loadRoute;
    final LoadStatusDetails? loadStatusDetails;
    final ScheduleTripDetails? scheduleTripDetails;
    final List<List<LoadDocument>> loadDocument;
    final dynamic loadSettlement;
    final Customer? customer;
    final dynamic vpCustomer;
    final List<Consignee> consignees;
    final Weightage? weightage;
    final LoadApproval? loadApproval;
    final PodDispatch? podDispatch;

    DriverLoadDetails copyWith({
        String? loadId,
        String? loadSeriesId,
        int? laneId,
        int? rateId,
        String? customerId,
        int? commodityId,
        DateTime? pickUpDateTime,
        int? truckTypeId,
        int? consignmentWeight,
        dynamic? notes,
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
        Commodity? commodity,
        TruckType? truckType,
        LoadRoute? loadRoute,
        LoadStatusDetails? loadStatusDetails,
        ScheduleTripDetails? scheduleTripDetails,
        List<List<LoadDocument>>? loadDocument,
        dynamic? loadSettlement,
        Customer? customer,
        dynamic? vpCustomer,
        List<Consignee>? consignees,
        Weightage? weightage,
        LoadApproval? loadApproval,
        PodDispatch? podDispatch,
    }) {
        return DriverLoadDetails(
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
            scheduleTripDetails: scheduleTripDetails ?? this.scheduleTripDetails,
            loadDocument: loadDocument ?? this.loadDocument,
            loadSettlement: loadSettlement ?? this.loadSettlement,
            customer: customer ?? this.customer,
            vpCustomer: vpCustomer ?? this.vpCustomer,
            consignees: consignees ?? this.consignees,
            weightage: weightage ?? this.weightage,
            loadApproval: loadApproval ?? this.loadApproval,
            podDispatch: podDispatch ?? this.podDispatch,
        );
    }

    factory DriverLoadDetails.fromJson(Map<String, dynamic> json){ 
        return DriverLoadDetails(
            loadId: json["loadId"] ?? "",
            loadSeriesId: json["loadSeriesId"] ?? "",
            laneId: json["laneId"] ?? 0,
            rateId: json["rateId"] ?? 0,
            customerId: json["customerId"] ?? "",
            commodityId: json["commodityId"] ?? 0,
            pickUpDateTime: DateTime.tryParse(json["pickUpDateTime"] ?? ""),
            truckTypeId: json["truckTypeId"] ?? 0,
            consignmentWeight: json["consignmentWeight"] ?? 0,
            notes: json["notes"],
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
            commodity: json["commodity"] == null ? null : Commodity.fromJson(json["commodity"]),
            truckType: json["truckType"] == null ? null : TruckType.fromJson(json["truckType"]),
            loadRoute: json["loadRoute"] == null ? null : LoadRoute.fromJson(json["loadRoute"]),
            loadStatusDetails: json["loadStatusDetails"] == null ? null : LoadStatusDetails.fromJson(json["loadStatusDetails"]),
            scheduleTripDetails: json["scheduleTripDetails"] == null ? null : ScheduleTripDetails.fromJson(json["scheduleTripDetails"]),
            loadDocument: json["loadDocument"] == null ? [] : List<List<LoadDocument>>.from(json["loadDocument"]!.map((x) => x == null ? [] : List<LoadDocument>.from(x!.map((x) => LoadDocument.fromJson(x))))),
            loadSettlement: json["loadSettlement"],
            customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
            vpCustomer: json["vpCustomer"],
            consignees: json["consignees"] == null ? [] : List<Consignee>.from(json["consignees"]!.map((x) => Consignee.fromJson(x))),
            weightage: json["weightage"] == null ? null : Weightage.fromJson(json["weightage"]),
            loadApproval: json["loadApproval"] == null ? null : LoadApproval.fromJson(json["loadApproval"]),
            podDispatch: json["podDispatch"] == null ? null : PodDispatch.fromJson(json["podDispatch"]),
        );
    }

}

class Commodity {
    Commodity({
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

    Commodity copyWith({
        int? id,
        String? name,
        dynamic? description,
        dynamic? iconUrl,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return Commodity(
            id: id ?? this.id,
            name: name ?? this.name,
            description: description ?? this.description,
            iconUrl: iconUrl ?? this.iconUrl,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory Commodity.fromJson(Map<String, dynamic> json){ 
        return Commodity(
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

class Consignee {
    Consignee({
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

    Consignee copyWith({
        String? id,
        String? name,
        String? email,
        String? mobileNumber,
        String? loadId,
    }) {
        return Consignee(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            loadId: loadId ?? this.loadId,
        );
    }

    factory Consignee.fromJson(Map<String, dynamic> json){ 
        return Consignee(
            id: json["id"] ?? "",
            name: json["name"] ?? "",
            email: json["email"] ?? "",
            mobileNumber: json["mobileNumber"] ?? "",
            loadId: json["loadId"] ?? "",
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
        required this.createdAt,
        required this.deletedAt,
        required this.kycType,
        required this.companyType,
        required this.customerAddress,
        required this.kycDocs,
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
    final DateTime? createdAt;
    final dynamic deletedAt;
    final Type? kycType;
    final Type? companyType;
    final CustomerAddress? customerAddress;
    final KycDocs? kycDocs;

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
        dynamic? preferredLanes,
        int? roleId,
        bool? tempFlg,
        int? status,
        bool? isLogin,
        bool? blueIdFlg,
        DateTime? kycPendingDate,
        DateTime? kycVerificationDate,
        DateTime? createdAt,
        dynamic? deletedAt,
        Type? kycType,
        Type? companyType,
        CustomerAddress? customerAddress,
        KycDocs? kycDocs,
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
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
            kycType: kycType ?? this.kycType,
            companyType: companyType ?? this.companyType,
            customerAddress: customerAddress ?? this.customerAddress,
            kycDocs: kycDocs ?? this.kycDocs,
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
            preferredLanes: json["preferredLanes"],
            roleId: json["roleId"] ?? 0,
            tempFlg: json["tempFlg"] ?? false,
            status: json["status"] ?? 0,
            isLogin: json["isLogin"] ?? false,
            blueIdFlg: json["blueIdFlg"] ?? false,
            kycPendingDate: DateTime.tryParse(json["kycPendingDate"] ?? ""),
            kycVerificationDate: DateTime.tryParse(json["kycVerificationDate"] ?? ""),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            deletedAt: json["deletedAt"],
            kycType: json["kycType"] == null ? null : Type.fromJson(json["kycType"]),
            companyType: json["companyType"] == null ? null : Type.fromJson(json["companyType"]),
            customerAddress: json["customerAddress"] == null ? null : CustomerAddress.fromJson(json["customerAddress"]),
            kycDocs: json["kycDocs"] == null ? null : KycDocs.fromJson(json["kycDocs"]),
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

class LoadApproval {
    LoadApproval({
        required this.id,
        required this.loadId,
        required this.rejectionReason,
        required this.documentApproved,
        required this.damageAndShortagesApproved,
        required this.settlementApproved,
        required this.paymentApproved,
        required this.podApproved,
        required this.approvedBy,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String id;
    final String loadId;
    final dynamic rejectionReason;
    final bool documentApproved;
    final dynamic damageAndShortagesApproved;
    final dynamic settlementApproved;
    final dynamic paymentApproved;
    final dynamic podApproved;
    final String approvedBy;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    LoadApproval copyWith({
        String? id,
        String? loadId,
        dynamic? rejectionReason,
        bool? documentApproved,
        dynamic? damageAndShortagesApproved,
        dynamic? settlementApproved,
        dynamic? paymentApproved,
        dynamic? podApproved,
        String? approvedBy,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return LoadApproval(
            id: id ?? this.id,
            loadId: loadId ?? this.loadId,
            rejectionReason: rejectionReason ?? this.rejectionReason,
            documentApproved: documentApproved ?? this.documentApproved,
            damageAndShortagesApproved: damageAndShortagesApproved ?? this.damageAndShortagesApproved,
            settlementApproved: settlementApproved ?? this.settlementApproved,
            paymentApproved: paymentApproved ?? this.paymentApproved,
            podApproved: podApproved ?? this.podApproved,
            approvedBy: approvedBy ?? this.approvedBy,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory LoadApproval.fromJson(Map<String, dynamic> json){ 
        return LoadApproval(
            id: json["id"] ?? "",
            loadId: json["loadId"] ?? "",
            rejectionReason: json["rejectionReason"],
            documentApproved: json["documentApproved"] ?? false,
            damageAndShortagesApproved: json["damageAndShortagesApproved"],
            settlementApproved: json["settlementApproved"],
            paymentApproved: json["paymentApproved"],
            podApproved: json["podApproved"],
            approvedBy: json["approvedBy"] ?? "",
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class LoadDocument {
    LoadDocument({
        required this.loadDocumentId,
        required this.loadId,
        required this.documentId,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
        required this.documentDetails,
        required this.documentError,
    });

    final String loadDocumentId;
    final String loadId;
    final String documentId;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;
    final DocumentDetails? documentDetails;
    final dynamic documentError;

    LoadDocument copyWith({
        String? loadDocumentId,
        String? loadId,
        String? documentId,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
        DocumentDetails? documentDetails,
        dynamic? documentError,
    }) {
        return LoadDocument(
            loadDocumentId: loadDocumentId ?? this.loadDocumentId,
            loadId: loadId ?? this.loadId,
            documentId: documentId ?? this.documentId,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
            documentDetails: documentDetails ?? this.documentDetails,
            documentError: documentError ?? this.documentError,
        );
    }

    factory LoadDocument.fromJson(Map<String, dynamic> json){ 
        return LoadDocument(
            loadDocumentId: json["loadDocumentId"] ?? "",
            loadId: json["loadId"] ?? "",
            documentId: json["documentId"] ?? "",
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
            documentDetails: json["documentDetails"] == null ? null : DocumentDetails.fromJson(json["documentDetails"]),
            documentError: json["documentError"],
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
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final int id;
    final String loadStatus;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    LoadStatusDetails copyWith({
        int? id,
        String? loadStatus,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return LoadStatusDetails(
            id: id ?? this.id,
            loadStatus: loadStatus ?? this.loadStatus,
            status: status ?? this.status,
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
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class PodDispatch {
    PodDispatch({required this.json});
    final Map<String,dynamic> json;

    factory PodDispatch.fromJson(Map<String, dynamic> json){ 
        return PodDispatch(
        json: json
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
    final Vehicle? vehicle;

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
        Vehicle? vehicle,
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
            vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        );
    }

}

class Driver {
    Driver({
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

    Driver copyWith({
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
    }) {
        return Driver(
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
        );
    }

    factory Driver.fromJson(Map<String, dynamic> json){ 
        return Driver(
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
        );
    }

}

class Vehicle {
    Vehicle({
        required this.vehicleId,
        required this.customerId,
        required this.truckNo,
        required this.ownerName,
        required this.registrationDate,
        required this.tonnage,
        required this.truckTypeId,
        required this.modelNumber,
        required this.insurancePolicyNumber,
        required this.insuranceValidityDate,
        required this.fcExpiryDate,
        required this.pucExpiryDate,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final String vehicleId;
    final String customerId;
    final String truckNo;
    final String ownerName;
    final DateTime? registrationDate;
    final String tonnage;
    final int truckTypeId;
    final String modelNumber;
    final String insurancePolicyNumber;
    final DateTime? insuranceValidityDate;
    final DateTime? fcExpiryDate;
    final DateTime? pucExpiryDate;
    final int status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Vehicle copyWith({
        String? vehicleId,
        String? customerId,
        String? truckNo,
        String? ownerName,
        DateTime? registrationDate,
        String? tonnage,
        int? truckTypeId,
        String? modelNumber,
        String? insurancePolicyNumber,
        DateTime? insuranceValidityDate,
        DateTime? fcExpiryDate,
        DateTime? pucExpiryDate,
        int? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return Vehicle(
            vehicleId: vehicleId ?? this.vehicleId,
            customerId: customerId ?? this.customerId,
            truckNo: truckNo ?? this.truckNo,
            ownerName: ownerName ?? this.ownerName,
            registrationDate: registrationDate ?? this.registrationDate,
            tonnage: tonnage ?? this.tonnage,
            truckTypeId: truckTypeId ?? this.truckTypeId,
            modelNumber: modelNumber ?? this.modelNumber,
            insurancePolicyNumber: insurancePolicyNumber ?? this.insurancePolicyNumber,
            insuranceValidityDate: insuranceValidityDate ?? this.insuranceValidityDate,
            fcExpiryDate: fcExpiryDate ?? this.fcExpiryDate,
            pucExpiryDate: pucExpiryDate ?? this.pucExpiryDate,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory Vehicle.fromJson(Map<String, dynamic> json){ 
        return Vehicle(
            vehicleId: json["vehicleId"] ?? "",
            customerId: json["customerId"] ?? "",
            truckNo: json["truckNo"] ?? "",
            ownerName: json["ownerName"] ?? "",
            registrationDate: DateTime.tryParse(json["registrationDate"] ?? ""),
            tonnage: json["tonnage"] ?? "",
            truckTypeId: json["truckTypeId"] ?? 0,
            modelNumber: json["modelNumber"] ?? "",
            insurancePolicyNumber: json["insurancePolicyNumber"] ?? "",
            insuranceValidityDate: DateTime.tryParse(json["insuranceValidityDate"] ?? ""),
            fcExpiryDate: DateTime.tryParse(json["fcExpiryDate"] ?? ""),
            pucExpiryDate: DateTime.tryParse(json["pucExpiryDate"] ?? ""),
            status: json["status"] ?? 0,
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
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

class Weightage {
    Weightage({
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

    Weightage copyWith({
        int? weightageId,
        int? measurementUnitId,
        int? value,
        dynamic? description,
        int? status,
        DateTime? createdAt,
        dynamic? deletedAt,
    }) {
        return Weightage(
            weightageId: weightageId ?? this.weightageId,
            measurementUnitId: measurementUnitId ?? this.measurementUnitId,
            value: value ?? this.value,
            description: description ?? this.description,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory Weightage.fromJson(Map<String, dynamic> json){ 
        return Weightage(
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

class PageMeta {
    PageMeta({
        required this.page,
        required this.pageCount,
        required this.nextPage,
        required this.pageSize,
        required this.total,
    });

    final int page;
    final int pageCount;
    final dynamic nextPage;
    final int pageSize;
    final int total;

    PageMeta copyWith({
        int? page,
        int? pageCount,
        dynamic? nextPage,
        int? pageSize,
        int? total,
    }) {
        return PageMeta(
            page: page ?? this.page,
            pageCount: pageCount ?? this.pageCount,
            nextPage: nextPage ?? this.nextPage,
            pageSize: pageSize ?? this.pageSize,
            total: total ?? this.total,
        );
    }

    factory PageMeta.fromJson(Map<String, dynamic> json){ 
        return PageMeta(
            page: json["page"] ?? 0,
            pageCount: json["pageCount"] ?? 0,
            nextPage: json["nextPage"],
            pageSize: json["pageSize"] ?? 0,
            total: json["total"] ?? 0,
        );
    }

}
