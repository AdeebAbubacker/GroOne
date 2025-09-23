import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';

import '../../model/kavach_order_list_model.dart';

abstract class KavachOrderListState {}

class KavachOrderListInitial extends KavachOrderListState {}

class KavachOrderListLoading extends KavachOrderListState {}

class KavachOrderListLoaded extends KavachOrderListState {
  final List<KavachOrderListOrderItem> orders;
  final bool? kycStatusUpdated;
  bool hasReachedMax;
  final int page;
  final int? totalPage;

  KavachOrderListLoaded({
    required this.orders,
    this.kycStatusUpdated,
    required this.hasReachedMax,
    required this.page,
    this.totalPage,
  });

  KavachOrderListLoaded copyWith({
    List<KavachOrderListOrderItem>? orders,
    List<GpsKycCheckResponseModel>? kycModelData,
    bool? hasReachedMax,
    int? page,
  }) {
    return KavachOrderListLoaded(
      orders: orders ?? this.orders,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      kycStatusUpdated: kycStatusUpdated ?? this.kycStatusUpdated,
    );
  }
}

class KavachOrderListError extends KavachOrderListState {
  final String message;

  KavachOrderListError(this.message);
}

class InvoiceDownloading extends KavachOrderListState {}

class InvoiceDownloaded extends KavachOrderListState {
  final String url;

  InvoiceDownloaded(this.url);
}
