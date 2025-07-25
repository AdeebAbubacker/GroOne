// class GetDamageListModel {
//   GetDamageListModel({
//     required this.data,
//     required this.total,
//     required this.pageMeta,
//   });

//   final List<GetDamageData> data;
//   final int total;
//   final PageMeta? pageMeta;

//   factory GetDamageListModel.fromJson(Map<String, dynamic> json){
//     return GetDamageListModel(
//       data: json["data"] == null ? [] : List<GetDamageData>.from(json["data"]!.map((x) => GetDamageData.fromJson(x))),
//       total: json["total"] ?? 0,
//       pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
//     );
//   }

// }

// class GetDamageData {
//   GetDamageData({
//     required this.damageId,
//     required this.vehicleId,
//     required this.loadId,
//     required this.itemName,
//     required this.quantity,
//     required this.image,
//     required this.description,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.deletedAt,
//   });

//   final String damageId;
//   final String vehicleId;
//   final String loadId;
//   final String itemName;
//   final int quantity;
//   final List<String> image;
//   final String description;
//   final DateTime? createdAt;
//   final dynamic updatedAt;
//   final dynamic deletedAt;

//   factory GetDamageData.fromJson(Map<String, dynamic> json){
//     return GetDamageData(
//       damageId: json["damageId"] ?? "",
//       vehicleId: json["vehicleId"] ?? "",
//       loadId: json["loadId"] ?? "",
//       itemName: json["itemName"] ?? "",
//       quantity: json["quantity"] ?? 0,
//       image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
//       description: json["description"] ?? "",
//       createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
//       updatedAt: json["updatedAt"],
//       deletedAt: json["deletedAt"],
//     );
//   }

// }

// class PageMeta {
//   PageMeta({
//     required this.page,
//     required this.pageCount,
//     required this.nextPage,
//     required this.pageSize,
//     required this.total,
//   });

//   final int page;
//   final int pageCount;
//   final dynamic nextPage;
//   final int pageSize;
//   final int total;

//   factory PageMeta.fromJson(Map<String, dynamic> json){
//     return PageMeta(
//       page: json["page"] ?? 0,
//       pageCount: json["pageCount"] ?? 0,
//       nextPage: json["nextPage"],
//       pageSize: json["pageSize"] ?? 0,
//       total: json["total"] ?? 0,
//     );
//   }

// }


class GetDamageListModel {
    GetDamageListModel({
        required this.success,
        required this.message,
        required this.data,
    });

    final bool success;
    final String message;
    final Data? data;

    GetDamageListModel copyWith({
        bool? success,
        String? message,
        Data? data,
    }) {
        return GetDamageListModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
        );
    }

    factory GetDamageListModel.fromJson(Map<String, dynamic> json){ 
        return GetDamageListModel(
            success: json["success"] ?? false,
            message: json["message"] ?? "",
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<Datum> data;
    final int total;
    final PageMeta? pageMeta;

    Data copyWith({
        List<Datum>? data,
        int? total,
        PageMeta? pageMeta,
    }) {
        return Data(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : PageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class Datum {
    Datum({
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
    final DateTime? updatedAt;
    final dynamic deletedAt;

    Datum copyWith({
        String? damageId,
        String? vehicleId,
        String? loadId,
        String? itemName,
        int? quantity,
        int? status,
        List<String>? image,
        String? description,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return Datum(
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

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            damageId: json["damageId"] ?? "",
            vehicleId: json["vehicleId"] ?? "",
            loadId: json["loadId"] ?? "",
            itemName: json["itemName"] ?? "",
            quantity: json["quantity"] ?? 0,
            status: json["status"] ?? 0,
            image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
            description: json["description"] ?? "",
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
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
