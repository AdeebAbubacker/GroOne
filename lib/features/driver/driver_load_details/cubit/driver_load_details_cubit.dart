import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/driver/driver_home/repository/driver_load_repository.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/repository/driver_loads_details_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/tracking_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_distance_response.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/create_document_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/create_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/delete_damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/delete_load_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/update_damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/view_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/repository/load_details_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:mime/mime.dart';

part 'driver_load_details_state.dart';


class DriverLoadDetailsCubit extends BaseCubit<DriverLoadDetailsState> {
  final DriverLoadsDetailsRepository _repository;
  final LoadDetailsRepository _loadDetailsRepository;
  final UserInformationRepository _userInformationRepository;

  DriverLoadDetailsCubit(this._loadDetailsRepository, this._repository,this._userInformationRepository) : super(DriverLoadDetailsState(  tripDocumentList: documentTypeList));


  // Updates the UI state related to loading LP loads by ID.
  void _setLoadByIdUIState(UIState<DriverLoadDetailsModel>? uiState) {
    emit(state.copyWith(lpLoadById: uiState,));
  }

  // Fetches the Driver loads filtered by the given [type].
Future<void> getDriverLoadsById({required String loadId}) async {
  _setLoadByIdUIState(UIState.loading());

  Result result = await _repository.fetchDriversLoadById(loadId: loadId);

  if (result is Success<DriverLoadDetailsModel>) {
    _setLoadByIdUIState(UIState.success(result.value)); 
  } else if (result is Error) {
    _setLoadByIdUIState(UIState.error(result.type));
  }
}

  // // Upload File
  void _setUploadTripDocFileUIState(UIState<UploadDamageFileModel>? uiState){
    emit(state.copyWith(uploadDamageUIState: uiState));
  }
  Future<void> uptripDocumentFile(File file,String fileType) async {
    _setUploadTripDocFileUIState(UIState.loading());
    // Result result = await _repository.uploadTripDocFileData(file,'lorry_receipt');
    Result result = await _repository.uploadTripDocFileData(file,fileType);
    if (result is Success<UploadDamageFileModel>) {
      _setUploadTripDocFileUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadTripDocFileUIState(UIState.error(result.type));
    }
  }

  //  Damage list Api Call
  void _setDamageListUIState(UIState<GetDamageListModel>? uiState){
    emit(state.copyWith(damageListUIState: uiState));
  }
  Future<void> fetchDamageList(String loadId) async {
    _setDamageListUIState(UIState.loading());
    Result result = await _repository.getDamageListData(loadId);
    if (result is Success<GetDamageListModel>) {
      _setDamageListUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setDamageListUIState(UIState.error(result.type));
    }
  }

   //  Update Load Status Api Call
  void _updateloadStatusUIState(UIState<VpLoadAcceptModel>? uiState){
    emit(state.copyWith(loadStatusUiUpdate: uiState));
  }
  Future<void> fupdateLoadStatus({required String customerId,required String loadid,required int loadStatus}) async {
    _updateloadStatusUIState(UIState.loading());
    Result result = await _repository.changeLoadStatus(customerId: customerId,loadId: loadid,loadStatus: loadStatus);
    if (result is Success<VpLoadAcceptModel>) {
      _updateloadStatusUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _updateloadStatusUIState(UIState.error(result.type));
    }
  }


  // // Upload File
  void _setUploadDamageFileUIState(UIState<UploadDamageFileModel>? uiState){
    emit(state.copyWith(uploadDamageUIState: uiState));
  }
  Future<void> uploadDamageFile(File file) async {
    _setUploadDamageFileUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getUploadDamageFileData(file);
    if (result is Success<UploadDamageFileModel>) {
      _setUploadDamageFileUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadDamageFileUIState(UIState.error(result.type));
    }
  }

  /// DELETE LOAD DOCUMENT
  Future<void> deleteLoadDocument(String loadDocumentID,int index) async {
    uploadDeleteLoaderStatus(index);
    Result result = await _loadDetailsRepository.deleteLoadDocument(loadDocumentID);
    if (result is Success<DeleteLoadDocumentResponse>) {
      /// delete from local
      uploadDeleteLoaderStatus(index,isDelete: true);
    }
    if (result is Error) {
      uploadDeleteLoaderStatus(index);
    }
  }

  Future<void> uploadDocument(File file, String fileType, String? title,
      int? documentTypeId, String loadId, int index) async {
    /// upload document = > Create Document = > Map Document with load
    try {
      uploadLoadingStatus(index, null);
      Result result = await _loadDetailsRepository.uploadDocument(
          file, fileType);
      if (result is Success<UploadDamageFileModel>) {
        ///Create Document
        await createDocument(title ?? "", documentTypeId ?? 1, result.value)
            .then((value) async {
          if (value != null) {
            /// Map document with load
            await saveDocument(value, loadId).then((value) {
              uploadLoadingStatus(index, value);
            },);
          } else{
            uploadLoadingStatus(index, null);
          }
        },);
      }
      if (result is Error) {
        uploadLoadingStatus(index, null);
      }
    } catch (e) {
      uploadLoadingStatus(index, null);
      return;
    }
  }


  void uploadLoadingStatus(int index, LoadDocument? loadDocument) {
    List<DocumentEntity> currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    final currentDocument = currentList[index];

    final updatedDocument = currentDocument.copyWith(
      loadDocument: currentDocument.loadDocument ?? loadDocument,
      isLoading: !(currentDocument.isLoading ?? false),
    );
    currentList[index] = updatedDocument;

    /// TODO:
    /// This is for multiple documents

    // if(loadDocument!=null && updatedDocument.fileType==DocumentFileType.uploadOtherDocument.name){
    //   DocumentEntity updatedDocumentList=   addOthersDocumentUploadOption(currentList);
    //   debugPrint("updatedDocumentList added");
    //   currentList.add(updatedDocumentList);
    // }
    emit(state.copyWith(tripDocumentList: currentList));
  }

  void uploadDeleteLoaderStatus(int index,{bool isDelete=false}) {
    final currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    final currentDocument = currentList[index];
    final updatedDocument = currentDocument.copyWith(
      clearLoadData: isDelete,
      loadDocument: isDelete ? null: currentDocument.loadDocument,
      deleteLoading: !(currentDocument.deleteLoading ?? false),
    );
    currentList[index] = updatedDocument;
    emit(state.copyWith(tripDocumentList: currentList));
  }


  /// add option for add more other documents
  DocumentEntity addOthersDocumentUploadOption(List<DocumentEntity> currentList){
    final currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    final otherDocumentObj=currentList.firstWhere((element) => element.fileType==DocumentFileType.uploadOtherDocument.name);
    final currentDocument = otherDocumentObj.copyWith(
      loadDocument: null
    );

    return currentDocument;
  }

  Future<CreateDocumentResponse?> createDocument(String title,
      int documentTypeId, UploadDamageFileModel uploadImage) async {
    try {
      final mimeType = lookupMimeType(uploadImage.filePath);
      return await _loadDetailsRepository.createNewDocument(
          CreateDocumentRequest(
              title: title,
              description: title,
              documentTypeId: documentTypeId,
              filePath: uploadImage.filePath,
              fileSize: uploadImage.size,
              mimeType: mimeType,
              originalFilename: uploadImage.originalName,
              fileExtension: uploadImage.originalName
                  .split(".")
                  .last)
      ).then((value) {
        if (value is Success<CreateDocumentResponse>) {
          return value.value;
        } else if(value is Error<CreateDocumentResponse>){
          ToastMessages.error(message: getErrorMsg(
              errorType: value.type
          ));
        }


        return null;
      },);
    } catch (e) {

      return null;
    }
  }

  Future<LoadDocument?> saveDocument(
      CreateDocumentResponse createDocumentResponse, String loadId) async {
    try {
      return await _loadDetailsRepository.saveLoadDocument(
          documentId: createDocumentResponse.documentId ?? "",
          loadId: loadId
      ).then((value) {
        if (value is Success<LoadDocument>) {
          return value.value;
        }
        return null;
      },);
    } catch (e) {
      return null;
    }
  }

  Future viewDocument(String documentId, int index) async {
    try {
      uploadLoadingStatus(index, null);
      return await _loadDetailsRepository.viewDocument(
        documentId: documentId,
      ).then((result) {
        if (result is Success<ViewDocumentResponse>) {
          downloadAndOpenFile(result.value.filePath ?? "",
              originalFileName: result.value.originalFilename);
          uploadLoadingStatus(index, null);
        }
        if (result is Error) {
          uploadLoadingStatus(index, null);
        }
      },);
    } catch (e) {
      uploadLoadingStatus(index, null);
      return null;
    }
  }


  void resetDeleteDamageUIState(){
    emit(state.copyWith(deleteDamageUIState: resetUIState<DeleteDamageModel>(state.deleteDamageUIState)));
  }


  void resetUploadDamageFileUIState() {
    emit(state.copyWith(uploadDamageUIState: resetUIState<UploadDamageFileModel>(state.uploadDamageUIState)));
  }


  void resetSubmitDamageUIState() {
    emit(state.copyWith(createDamageUIState: resetUIState<DamageModel>(
        state.createDamageUIState)));
  }

  void resetSettlementUIState() {
    emit(state.copyWith(settlementUIState: resetUIState<DamageModel>(
        state.settlementUIState)));
  }

  void resetUpdateDamageUIState(){
    emit(state.copyWith(updateDamageUIState: resetUIState<UpdateDamageModel>(state.updateDamageUIState)));
  }


  void resetState(){
    emit(state.copyWith(
      uploadDamageUIState: resetUIState<UploadDamageFileModel>(state.uploadDamageUIState),
      createDamageUIState : resetUIState<DamageModel>(state.createDamageUIState),
      deleteDamageUIState : resetUIState<DeleteDamageModel>(state.deleteDamageUIState),
      updateDamageUIState : resetUIState<UpdateDamageModel>(state.updateDamageUIState),
      isUpdateDamage : false,

    ));
  }

    setTripDocuments(List<LoadDocument>? loadDocument) {
      List<DocumentEntity> documentList = List.from(state.tripDocumentList ?? []);
      for (DocumentEntity item in documentList) {
        /// find load item for api response set into local document entity
        try {
          item.loadDocument = loadDocument!.firstWhere(
                (element) =>
            element.documentDetails?.documentType == item.documentType,
          );
        } catch (e) {
          item.loadDocument = null;
        }
      }
      emit(state.copyWith(
          tripDocumentList: documentList
      ));
    }


  bool checkIsDocumentUploaded(List<DocumentEntity> documentEntity) {
    try {
      DocumentEntity? document = documentEntity.firstWhere((element) =>
      element.loadDocument == null && element.visible==true);
      return document == null;
    } catch (e) {
      return true;
    }
  }

 bool isNextProcessButtonEnabled({required List<
     DocumentEntity> documentEntity, required int driverConsent, dynamic memo, LoadStatus? loadStatus}) {
    switch(loadStatus){
      case LoadStatus.assigned:
        return memo!=null;
        case LoadStatus.loading:
      return driverConsent==1 && checkIsDocumentUploaded(documentEntity);
      case LoadStatus.unloading:
        return checkIsDocumentUploaded(documentEntity);
      default:
        return true;
    }
  }

  void updatePODVisibilityBasedOnStatus(int? status) {
  final currentList = state.tripDocumentList ?? [];

  // Check if POD (TypeId = 8) exists
  final podIndex = currentList.indexWhere((doc) => doc.documentTypeId == 8);
  if (podIndex != -1 && status != null && status > 6) {
    final updatedDoc = currentList[podIndex].copyWith(visible: true);
    currentList[podIndex] = updatedDoc;
    emit(state.copyWith(tripDocumentList: currentList));
  }
}

  String? _userId;

  String? get userId => _userId;

  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
  


