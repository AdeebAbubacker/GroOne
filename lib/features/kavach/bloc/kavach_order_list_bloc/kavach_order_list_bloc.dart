import 'package:bloc/bloc.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import '../../../../data/model/result.dart';
import '../../model/kavach_invoice_response_model.dart';
import '../../model/kavach_order_list_model.dart';
import '../../repository/kavach_repository.dart';
import 'kavach_order_list_event.dart';
import 'kavach_order_list_state.dart';

class KavachOrderListBloc
    extends Bloc<KavachOrderListEvent, KavachOrderListState> {
  final KavachRepository _repository;
  final GpsOrderApiRepository gpsOrderApiRepository;
  final UserInformationRepository userInformationRepository;

  KavachOrderListBloc(
    this._repository,
    this.gpsOrderApiRepository,
    this.userInformationRepository,
  ) : super(KavachOrderListInitial()) {
    on<FetchKavachOrderList>(_onFetchOrders);
    on<DownloadInvoiceEvent>(_onDownloadInvoice);
  }

  Future<void> _onFetchOrders(
    FetchKavachOrderList event,
    Emitter<KavachOrderListState> emit, {
    String customerId = '',
  }) async {
    final currentState = state;
    int nextPage = 1;

    if (event.isRefresh) {
      nextPage = 1;
    } else if (currentState is KavachOrderListLoaded) {
      if (currentState.hasReachedMax) return;
      nextPage = currentState.page + 1;
    }

    try {
      if (nextPage == 1) {
        emit(KavachOrderListLoading());
      }

      final result = await _repository.fetchCustomerOrders(
        page: nextPage,
        status: event.status,
        forceRefresh: event.forceRefresh,
      );

      if (result is Success<KavachOrderListResponse>) {
        final response = result.value;
        final orders = response.orders;
        final hasReachedMax = orders.length < response.meta.limit;
        final String? id = await userInformationRepository.getUserID();
        if (id != null && id.isNotEmpty) {
          final checkKycUpdateRes = await gpsOrderApiRepository
              .checkKycDocuments(id);
          if (checkKycUpdateRes is Success<GpsKycCheckResponseModel>) {
            kavachOrderListEmitMethod(
              emit,
              result,
              currentState is KavachOrderListLoaded,
              event.isRefresh,
              nextPage,
              checkKycUpdateRes.value.documents != null &&
                  checkKycUpdateRes.value.documents!.panDocLink != null &&
                  checkKycUpdateRes.value.documents!.panDocLink!.isNotEmpty,
              (currentState is KavachOrderListLoaded)
                  ? KavachOrderListLoaded(
                    orders: currentState.orders + orders,
                    hasReachedMax: hasReachedMax,
                    page: nextPage,
                  )
                  : KavachOrderListLoaded(
                    orders: orders,
                    hasReachedMax: hasReachedMax,
                    page: nextPage,
                  ),
            );
            return;
          } else {
            kavachOrderListEmitMethod(
              emit,
              result,
              currentState is KavachOrderListLoaded,
              event.isRefresh,
              nextPage,
              false,
              (currentState is KavachOrderListLoaded)
                  ? KavachOrderListLoaded(
                    orders: currentState.orders + orders,
                    hasReachedMax: hasReachedMax,
                    page: nextPage,
                  )
                  : KavachOrderListLoaded(
                    orders: orders,
                    hasReachedMax: hasReachedMax,
                    page: nextPage,
                  ),
            );
            return;
          }
        } else {
          kavachOrderListEmitMethod(
            emit,
            result,
            currentState is KavachOrderListLoaded,
            event.isRefresh,
            nextPage,
            false,
            (currentState is KavachOrderListLoaded)
                ? KavachOrderListLoaded(
                  orders: currentState.orders + orders,
                  hasReachedMax: hasReachedMax,
                  page: nextPage,
                )
                : KavachOrderListLoaded(
                  orders: orders,
                  hasReachedMax: hasReachedMax,
                  page: nextPage,
                ),
          );
          return;
        }
      } else if (result is Error) {
        emit(KavachOrderListError("Failed to fetch orders"));
      }
    } catch (e) {
      emit(KavachOrderListError("Unexpected error: $e"));
    }
  }

  kavachOrderListEmitMethod(
    Emitter<KavachOrderListState> emit,
    Success<KavachOrderListResponse> result,
    bool currentStateIsKavachOrderList,
    bool isRefresh,
    int nextPage,
    bool kycUpdateStatus,
    KavachOrderListLoaded kavachOrderListLoaded,
  ) async {
    final response = result.value;
    List<KavachOrderListOrderItem> orders = [];
    orders = response.orders;
    final hasReachedMax = orders.length < response.meta.limit;
    if (currentStateIsKavachOrderList && isRefresh) {
      emit(
        KavachOrderListLoaded(
          kycStatusUpdated: kycUpdateStatus,
          orders: kavachOrderListLoaded.orders + orders,
          hasReachedMax: hasReachedMax,
          page: nextPage,
        ),
      );
    } else {
      emit(
        KavachOrderListLoaded(
          orders: orders,
          kycStatusUpdated: kycUpdateStatus,
          hasReachedMax: hasReachedMax,
          page: nextPage,
        ),
      );
    }
  }

  Future<void> _onDownloadInvoice(
    DownloadInvoiceEvent event,
    Emitter<KavachOrderListState> emit,
  ) async {
    emit(InvoiceDownloading());
    final result = await _repository.downloadInvoice(event.orderId);

    if (result is Success<KavachInvoiceResponse>) {
      emit(InvoiceDownloaded(result.value.url));
    } else {
      emit(KavachOrderListError("Failed to download invoice"));
    }
  }
}
