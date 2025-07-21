import 'dart:io';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/create_document_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/create_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/settlement_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/update_damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/delete_damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/delete_load_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/update_damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/view_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/services/vp_details_service.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/service/vp_service.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class LoadDetailsRepository {
  final VpDetailsService _vpDetailsService;
  final VpHomeService _vpHomeService;
  final UserInformationRepository _userInformationRepository;
  LoadDetailsRepository(this._vpDetailsService,this._vpHomeService, this._userInformationRepository);

  Future<Result<LoadDetailModel>> fetchLoadDetails(String? loadId) async {
    try {
      return await _vpDetailsService.fetchLoadDetails(loadId);
    } catch (e) {
      CustomLog.error(this, "Failed to get upload loadData", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VpLoadAcceptModel>> changeLoadStatus({
    required String customerId,required String loadId,required int? loadStatus}) async {
    try {
      return await _vpDetailsService.changeLoadStatus(
          loadStatus: loadStatus,
          loadId: loadId,userId: customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<VpLoadAcceptModel>> load({required String customerId,required String loadId,required int? loadStatus}) async {
    try {
      return await _vpDetailsService.changeLoadStatus(loadStatus: loadStatus, loadId: loadId,userId: customerId);
    } catch (e) {
      CustomLog.error(this, "Failed to request Login In", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Submit Settlement Repo
  Future<Result<DamageModel>> getSubmitSettlementData(SettlementApiRequest request) async {
    try {
      return await _vpDetailsService.submitSettlement(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request settlement submit data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Submit Damage Repo
  Future<Result<DamageModel>> getSubmitDamageData(DamageApiRequest request) async {
    try {
      return await _vpDetailsService.submitDamage(request);
    } catch (e) {
      CustomLog.error(this, "Failed to request damage submit data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Update Damage Repo
  Future<Result<UpdateDamageModel>> getUpdateDamageData(UpdateDamageApiRequest request, String damageId) async {
    try {
      return await _vpDetailsService.updateDamage(request, damageId);
    } catch (e) {
      CustomLog.error(this, "Failed to request edit damage submit data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Delete Damage Repo
  Future<Result<DeleteDamageModel>> getDeleteDamageData(String damageId) async {
    try {
      return await _vpDetailsService.deleteDamage(damageId);
    } catch (e) {
      CustomLog.error(this, "Failed to request delete damage submit data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Gat Damage List Repo
  Future<Result<GetDamageListModel>> getDamageListData(String loadId) async {
    try {
      return await _vpDetailsService.fetchDamageList(loadId);
    } catch (e) {
      CustomLog.error(this, "Failed to request damage list data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  /// Upload File Repo
  Future<Result<UploadDamageFileModel>> getUploadDamageFileData(File file) async {
    try {
      return await _vpDetailsService.fetchUploadDamageData(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: DAMAGES_AND_SHORTAGES,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload gst document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<DeleteLoadDocumentResponse>> deleteLoadDocument(String loadDocumentId) async {
    try {
      return await _vpDetailsService.deleteLoadDocument(
       loadDocumentID: loadDocumentId
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload gst document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<UploadDamageFileModel>> uploadDocument(File file,String fileType) async {
    try {
      return await _vpDetailsService.fetchUploadDamageData(
          file : file,
          userId: await _userInformationRepository.getUserID() ?? "",
          fileType: fileType,
          documentType: await _userInformationRepository.getUserRole() == 2 ? VP_DOCUMENT : LP_DOCUMENT
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload gst document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<CreateDocumentResponse>> createNewDocument(CreateDocumentRequest createDocumentRequest) async {
    try {
      final userId=await _userInformationRepository.getUserID() ?? "";
      return await _vpDetailsService.createNewDocument(createDocumentRequest: createDocumentRequest,userId: userId);
    } catch (e) {
      print("error in create document");
      CustomLog.error(this, "Failed to get upload gst document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


  Future<Result<LoadDocument>> saveLoadDocument({required String documentId,String? loadId}) async {
    try {
      return await _vpDetailsService.saveLoadDocument(
        documentId: documentId, loadId: loadId
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload gst document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<ViewDocumentResponse>> viewDocument({required String documentId}) async {
    try {
      return await _vpDetailsService.viewDocument(
      documentId: documentId
      );
    } catch (e) {
      CustomLog.error(this, "Failed to get upload gst document data", e);
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }


}