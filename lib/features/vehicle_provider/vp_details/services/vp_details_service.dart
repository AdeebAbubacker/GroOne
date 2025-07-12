import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/create_document_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_home_bloc/vp_home_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/custom_log.dart';


/// TODO:
/// New to change response of create Document
/// add upload

class VpDetailsService{
  final ApiService _apiService;
  const VpDetailsService(this._apiService);


   Future<Result<LoadDetailsResponseModel>> fetchLoadDetails(String? loadId) async {
    try {
      final url =  "${ApiUrls.getLoadById}$loadId";
      final result = await _apiService.get(url);
      if (result is Success) {
        final loadDetailsResponse=LoadDetailsResponseModel.fromJson(result.value);
        return Success(loadDetailsResponse);
      } else if (result is Error) {

        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch(e){

      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<VpLoadAcceptModel>> changeLoadStatus({required String? userId,required String loadId,required int? loadStatus}) async {
    try {
      final statusUpdateUrl=(loadStatus??0)>4?ApiUrls.updateLoadStatus:ApiUrls.vpAcceptLoad;
      final result = await _apiService.put(
        queryParams: {
          "loadStatus":loadStatus
        },
          '$statusUpdateUrl/$userId/$loadId');
      if (result is Success) {
       final changeLoadStatusResponse= VpLoadAcceptModel.fromJson(result.value);
        return Success(changeLoadStatusResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<VpLoadAcceptModel>> createNewDocument({required CreateDocumentRequest createDocumentRequest}) async {
    try {
      final statusUpdateUrl=ApiUrls.createDocument;
      final result = await _apiService.post(statusUpdateUrl,queryParams: createDocumentRequest.toJson());
      if (result is Success) {
       final changeLoadStatusResponse= VpLoadAcceptModel.fromJson(result.value);
        return Success(changeLoadStatusResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  Future<Result<VpLoadAcceptModel>> saveLoadDocument({required String? documentUrl,String? loadId}) async {
    try {
      final statusUpdateUrl=ApiUrls.loadDocument;
      final result = await _apiService.post(statusUpdateUrl,queryParams:{
        "documentId":documentUrl,
        "loadId":loadId
      });
      if (result is Success) {
        final changeLoadStatusResponse= VpLoadAcceptModel.fromJson(result.value);
        return Success(changeLoadStatusResponse);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      CustomLog.error(this, AppString.error.deserializationError, e);
      return Error(DeserializationError());
    }
  }

  // Future<Result<UploadRcTruckFileModel>> fetchUploadRcTruckFileData(File files,String? userId) async {
  //   try {
  //     final url = ApiUrls.upload;
  //     final result = await _apiService.multipart(
  //       url,
  //       files,
  //       fields: {"fileType":"upload_rc", "userId": userId ?? ""},
  //       pathName: "file",
  //     );
  //     if (result is Success) {
  //       final data = UploadRcTruckFileModel.fromJson(result.value);
  //       return   Success(data);
  //     } else if (result is Error) {
  //       return Error(result.type);
  //     } else {
  //       return Error(GenericError());
  //     }
  //   } catch(e) {
  //     CustomLog.error(this, AppString.error.deserializationError, e);
  //     return Error(DeserializationError());
  //   }
  // }






}