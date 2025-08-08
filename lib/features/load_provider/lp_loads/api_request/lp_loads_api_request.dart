import 'package:gro_one_app/data/model/serializable.dart';

class LoadListApiRequest extends Serializable<LoadListApiRequest>{
  final int? loadStatus;
  final int? page;
  final int? limit;
  final String? customerId;
  final String? search;
  final int? fromLocationId;
  final int? toLocationId;
  final int? laneId;
  final String? truckTypeId;
  final String? loadPostDate;

  LoadListApiRequest({
    this.loadStatus,
    this.page,
    this.limit,
    this.customerId,
    this.search,
    this.fromLocationId,
    this.toLocationId,
    this.laneId,
    this.truckTypeId,
    this.loadPostDate,
  });

  @override
  Map<String, dynamic> toJson() => {
    if (loadStatus != null) 'loadStatus': loadStatus,
    if (page != null) 'page': page,
    if (limit != null) 'limit': limit,
    if (customerId != null) 'customerId': customerId,
    if (search != null) 'search': search,
    if (fromLocationId != null) 'fromLocationId': fromLocationId,
    if (toLocationId != null) 'toLocationId': toLocationId,
    if (laneId != null) 'laneId': laneId,
    if (truckTypeId != null) 'truckTypeId': truckTypeId,
    if (loadPostDate != null) 'loadPostDate': loadPostDate,
  };

  LoadListApiRequest copyWith({
    int? loadStatus,
    int? page,
    int? limit,
    String? customerId,
    String? search,
    int? fromLocationId,
    int? toLocationId,
    int? laneId,
    String? truckTypeId,
    String? loadPostDate,
  }) {
    return LoadListApiRequest(
      loadStatus: loadStatus ?? this.loadStatus,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      customerId: customerId ?? this.customerId,
      search: search ?? this.search,
      fromLocationId: fromLocationId ?? this.fromLocationId,
      toLocationId: toLocationId ?? this.toLocationId,
      laneId: laneId ?? this.laneId,
      truckTypeId: truckTypeId ?? this.truckTypeId,
      loadPostDate: loadPostDate ?? this.loadPostDate,
    );
  }
}
