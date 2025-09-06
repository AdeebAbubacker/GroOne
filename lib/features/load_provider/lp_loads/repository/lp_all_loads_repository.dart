import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/consignee_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/create_orderid_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/initiate_payment_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/lp_loads_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/tracking_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/load_status_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_consignee_add_success_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_create_order_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_check_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_credit_update_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_feedback_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_get_by_id_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_otp_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_route_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_verify_advance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_order_added_success_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_distance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/trip_statement_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/service/lp_all_loads_service.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/app_string.dart';


class  LpLoadRepository {
  final LpLoadService service;
  final UserInformationRepository userRepo;
  final SecuredSharedPreferences securedSharedPreferences;

  LpLoadRepository(this.service, this.userRepo, this.securedSharedPreferences);

  Future<Result<LpLoadResponse>> fetchLoads({required LoadListApiRequest request, bool forceRefresh = false}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.fetchLoads(request: request.copyWith(customerId: customerId), forceRefresh: forceRefresh);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LoadGetByIdResponse>> fetchLoadById({required String loadId, bool forceRefresh = false}) async {
    try {
      return service.fetchLoadsById(loadId: loadId,forceRefresh: forceRefresh);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadMemoResponse>> fetchMemoDetails({required String loadId, bool forceRefresh = false}) async {
    try {
      return service.fetchMemoDetails(loadId: loadId, forceRefresh: forceRefresh);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<TripStatementResponse>> fetchTripDetails({required String loadId}) async {
    try {
      return service.fetchTripDetails(loadId: loadId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<LoadTruckTypeListModel>>> fetchTruckTypeList({int? page, int? limit}) async {
    try {
      return service.fetchTruckTypeList(page: page ?? 1,pageSize: limit ?? 10);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadRouteResponse>> fetchRouteList({int? page, int? limit,String? search}) async {
    try {
      return service.fetchRouteList(page: page ?? 1,pageSize: limit ?? 10,search: search);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<List<LoadStatusResponse>>> fetchLoadStatus() async {
    try {
      return service.fetchLoadStatus();
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadMemoOtpResponse>> sendOtp({required String loadId}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.sendOtp(customerId: customerId, loadId: loadId);

    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadMemoVerifyOtpResponse>> verifyOtp({required String otp, required String loadId}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.verifyOtp(customerId: customerId, otp: otp, loadId: loadId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<CreditCheckApiResponse>> getCreditCheck() async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.getCreditCheck(customerId: customerId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadCreditUpdateResponse>> updateCreditCheck({required String creditLimit, required String creditUsed}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.updateCreditCheck(creditLimit: creditLimit, creditUsed: creditUsed, customerId: customerId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<void> saveFirstPostedLoadId(String loadId) async {
    return await securedSharedPreferences.saveKey(
      AppString.sessionKey.firstPostedLoadId,
      loadId,
    );
  }

  Future<String?> getFirstPostedLoadId() async {
    return await securedSharedPreferences.get(AppString.sessionKey.firstPostedLoadId);
  }

  Future<void> clearFirstPostedLoadId() async {
    return await securedSharedPreferences.deleteKey(AppString.sessionKey.firstPostedLoadId);
  }

  Future<void> setFirstPostedLoadIdIfAbsent(String loadId) async {
    final existingId = await securedSharedPreferences.get(AppString.sessionKey.firstPostedLoadId);
    if (existingId == null) {
      await saveFirstPostedLoadId(loadId);
    }
  }


  Future<Result<LpLoadAgreeResponse>> loadAgree({required String loadId}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.loadAgree(customerId: customerId, loadId: loadId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadVerifyAdvanceResponse>> verifyAdvance({required String loadId, required String percentageId}) async {
    try {
      final customerId = await userRepo.getUserID() ?? '';
      return service.verifyAdvance(customerId: customerId, loadId: loadId, percentageId: percentageId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<LpLoadFeedbackResponse>> updateFeedback({required String loadId, required String feedback}) async {
    try {
      return service.updateFeedback(loadId: loadId, feedback: feedback);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<DocumentDetails>> getDocumentById({required String docId}) async {
    try {
      return service.getDocumentById(docId: docId);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<TrackingDistanceResponse>> getTrackingDistance({required TrackingDistanceApiRequest request}) async {
    try {
      return service.getTrackingDistance(request: request);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<ConsigneAddedSuccessModel>> addConsignee({
  required AddConsigneeApiRequest addConsigneeReq,}) async {
    try {
      return service.addConsignee(addConsigneeReq: addConsigneeReq);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<ConsigneAddedSuccessModel>> updateConsignee({
  required String consigneeId,
  required UpdateConsigneeApiRequest updateConsigneeReq,
  }) async {
    try {
      return service.updateConsignee(consigneId: consigneeId, request: updateConsigneeReq);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


Future<Result<OrderAddedSuccess>> initiatePayment({
  required InitiatePaymentRequest initiatePaymentRequest,
}) async {
  try {
 
    return service.addCustomerPaymentOption(
      initiatePaymentRequest: initiatePaymentRequest
    );
  } catch (e) {
    return Error(ErrorWithMessage(message: e.toString()));
  }
}

Future<Result<LpCreateOrderResponse>> createOrder({
  required String loadId,
  required CreateOrderIdRequest createOrderIdRequest, 
}) async {
  try {
    return service.createLpOrder(loadId: loadId, createOrderIdRequest: createOrderIdRequest);
  } catch (e) {
    return Error(ErrorWithMessage(message: e.toString()));
  }
}
}
