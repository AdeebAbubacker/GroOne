class StateResponseModel {
    StateResponseModel({
        required this.data,
        required this.total,
        required this.pageMeta,
    });

    final List<StateResponseData> data;
    final int total;
    final StatePageMeta? pageMeta;

    StateResponseModel copyWith({
        List<StateResponseData>? data,
        int? total,
        StatePageMeta? pageMeta,
    }) {
        return StateResponseModel(
            data: data ?? this.data,
            total: total ?? this.total,
            pageMeta: pageMeta ?? this.pageMeta,
        );
    }

    factory StateResponseModel.fromJson(Map<String, dynamic> json){ 
        return StateResponseModel(
            data: json["data"] == null ? [] : List<StateResponseData>.from(json["data"]!.map((x) => StateResponseData.fromJson(x))),
            total: json["total"] ?? 0,
            pageMeta: json["pageMeta"] == null ? null : StatePageMeta.fromJson(json["pageMeta"]),
        );
    }

}

class StateResponseData {
    StateResponseData({
        required this.id,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
        required this.deletedAt,
    });

    final int id;
    final String name;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic deletedAt;

    StateResponseData copyWith({
        int? id,
        String? name,
        DateTime? createdAt,
        DateTime? updatedAt,
        dynamic? deletedAt,
    }) {
        return StateResponseData(
            id: id ?? this.id,
            name: name ?? this.name,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            deletedAt: deletedAt ?? this.deletedAt,
        );
    }

    factory StateResponseData.fromJson(Map<String, dynamic> json){ 
        return StateResponseData(
            id: json["id"] ?? 0,
            name: json["name"] ?? "",
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            deletedAt: json["deletedAt"],
        );
    }

}

class StatePageMeta {
    StatePageMeta({
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

    StatePageMeta copyWith({
        int? page,
        int? pageCount,
        dynamic? nextPage,
        int? pageSize,
        int? total,
    }) {
        return StatePageMeta(
            page: page ?? this.page,
            pageCount: pageCount ?? this.pageCount,
            nextPage: nextPage ?? this.nextPage,
            pageSize: pageSize ?? this.pageSize,
            total: total ?? this.total,
        );
    }

    factory StatePageMeta.fromJson(Map<String, dynamic> json){ 
        return StatePageMeta(
            page: json["page"] ?? 0,
            pageCount: json["pageCount"] ?? 0,
            nextPage: json["nextPage"],
            pageSize: json["pageSize"] ?? 0,
            total: json["total"] ?? 0,
        );
    }

}
