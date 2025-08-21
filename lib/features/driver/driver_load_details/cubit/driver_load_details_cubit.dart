import 'dart:io';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart' as lpHelper;
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
import 'package:gro_one_app/features/driver/driver_load_details/repository/driver_loads_details_repository.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/tracking_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_distance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
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
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:mime/mime.dart';

part 'driver_load_details_state.dart';

class DriverLoadDetailsCubit extends BaseCubit<DriverLoadDetailsState> {
  final DriverLoadsDetailsRepository _repository;
  final LoadDetailsRepository _loadDetailsRepository;
  final LpLoadRepository _lpLoadRepository;
  final UserInformationRepository _userInformationRepository;

  DriverLoadDetailsCubit(
    this._loadDetailsRepository,
    this._repository,
    this._lpLoadRepository,
    this._userInformationRepository,
  ) : super(DriverLoadDetailsState(tripDocumentList: []));

  // Updates the UI state related to loading LP loads by ID.
  void _setLoadByIdUIState(UIState<DriverLoadDetailsModel>? uiState) {
    emit(state.copyWith(lpLoadById: uiState));
  }

  // Fetches the Driver loads filtered by the given [type].
  Future<void> getDriverLoadsById({required String loadId}) async {
    _setLoadByIdUIState(UIState.loading());

    Result result = await _repository.fetchDriversLoadById(loadId: loadId);

    if (result is Success<DriverLoadDetailsModel>) {
      final loadStatus = getLoadStatus(result.value.data?.loadStatusId);
      emit(
        state.copyWith(
          lpLoadById: UIState.success(result.value),
          loadStatusId: result.value.data?.loadStatusId,
          loadStatus: loadStatus,
        ),
      );
      await _handleTrackingBasedOnStatus(result.value);
      setTripDocuments(result.value.data!.loadDocument);
    } else if (result is Error) {
      _setLoadByIdUIState(UIState.error(result.type));
    }
  }

  // // Upload File
  void _setUploadTripDocFileUIState(UIState<UploadDamageFileModel>? uiState) {
    emit(state.copyWith(uploadDamageUIState: uiState));
  }

  Future<void> uptripDocumentFile(File file, String fileType) async {
    _setUploadTripDocFileUIState(UIState.loading());
    // Result result = await _repository.uploadTripDocFileData(file,'lorry_receipt');
    Result result = await _repository.uploadTripDocFileData(file, fileType);
    if (result is Success<UploadDamageFileModel>) {
      _setUploadTripDocFileUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadTripDocFileUIState(UIState.error(result.type));
    }
  }

  //  Damage list Api Call
  void _setDamageListUIState(UIState<GetDamageListModel>? uiState) {
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
  void _updateloadStatusUIState(UIState<VpLoadAcceptModel>? uiState) {
    emit(state.copyWith(loadStatusUIState: uiState));
  }

  // set Trip Document List
  setDocumentState(){
    emit(state.copyWith(
        tripDocumentList: DocumentDataModel.documentTypeList
    ));
  }
 
  Future<void> fupdateLoadStatus({
    required String customerId,
    required String loadid,
    required int loadStatus,
  }) async {
    _updateloadStatusUIState(UIState.loading());
    Result result = await _repository.changeLoadStatus(
      customerId: customerId,
      loadId: loadid,
      loadStatus: loadStatus,
    );
    if (result is Success<VpLoadAcceptModel>) {
      final newStatus = result.value.data?.loadStatus;

      emit(
        state.copyWith(
          loadStatusId: newStatus,
          loadStatusUIState: UIState.success(result.value),
        ),
      );
    }
    if (result is Error) {
      _updateloadStatusUIState(UIState.error(result.type));
    }
  }

  // // Upload File
  void _setUploadDamageFileUIState(UIState<UploadDamageFileModel>? uiState) {
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
  // Future<void> deleteLoadDocument(String loadDocumentID, int index) async {
  //   uploadDeleteLoaderStatus(index);
  //   Result result = await _loadDetailsRepository.deleteLoadDocument(
  //     loadDocumentID,
  //   );
  //   if (result is Success<DeleteLoadDocumentResponse>) {
  //     /// delete from local
  //     uploadDeleteLoaderStatus(index, isDelete: true);
  //   }
  //   if (result is Error) {
  //     uploadDeleteLoaderStatus(index);
  //   }
  // }
    /// DELETE LOAD DOCUMENT
  Future<void> deleteLoadDocument(String loadDocumentID,int index,{bool otherDocument=false}) async {
    if(!otherDocument){
      uploadDeleteLoaderStatus(index);
    }

    Result result = await _loadDetailsRepository.deleteLoadDocument(loadDocumentID);
    if (result is Success<DeleteLoadDocumentResponse>) {
      /// delete from local
      if(otherDocument){
         print('local deleete called');
        deleteOtherDocumentFromLocal(index);
      }else{
         print('not ------------deleetd from local');
        uploadDeleteLoaderStatus(index,isDelete: true);
      }

    }
    if (result is Error) {
      uploadDeleteLoaderStatus(index);
    }
  }

    deleteOtherDocumentFromLocal(int index){

    final currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    int currentDocumentIndex = currentList.indexWhere((element) => element.documentType==DocumentFileType.uploadOtherDocument.documentType);
    List<LoadDocument> loadDocument =  List.from(currentList[currentDocumentIndex].loadDocument??[]);
    loadDocument.removeAt(index);

    final updatedDocument = currentList[currentDocumentIndex].copyWith(
      clearLoadData: false,
      loadDocument: loadDocument,
      isLoading: false,
      deleteLoading:false,
    );
    currentList[currentDocumentIndex] = updatedDocument;
    emit(state.copyWith(tripDocumentList: currentList));
  }


  Future<void> uploadDocument(
    File file,
    String fileType,
    String? title,
    int? documentTypeId,
    String loadId,
    int index,
  ) async {
    /// upload document = > Create Document = > Map Document with load
    try {
      uploadLoadingStatus(index, null);
      Result result = await _loadDetailsRepository.uploadDocument(
        file,
        fileType,
      );
      if (result is Success<UploadDamageFileModel>) {
        ///Create Document
        await createDocument(
          title ?? "",
          documentTypeId ?? 1,
          result.value,
        ).then((value) async {
          if (value != null) {
            /// Map document with load
            await saveDocument(value, loadId).then((value) {
              uploadLoadingStatus(index, value);
            });
          } else {
            uploadLoadingStatus(index, null);
          }
        });
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
    List<DocumentEntity> currentList = List<DocumentEntity>.from(
      state.tripDocumentList ?? [],
    );
    final currentDocument = currentList[index];

    // Build a new list of documents by adding the new one if passed
    final updatedLoadDocuments =
        loadDocument != null
            ? [
              ...?currentDocument.loadDocument, // existing documents (nullable)
              loadDocument,
            ]
            : currentDocument.loadDocument;

    final updatedDocument = currentDocument.copyWith(
      loadDocument: updatedLoadDocuments,
      isLoading: !(currentDocument.isLoading ?? false),
    );

    currentList[index] = updatedDocument;

    emit(state.copyWith(tripDocumentList: currentList));
  }

  void uploadDeleteLoaderStatus(int index, {bool isDelete = false}) {
    final currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    final currentDocument = currentList[index];
    final updatedDocument = currentDocument.copyWith(
      clearLoadData: isDelete,
      loadDocument: isDelete ? null : currentDocument.loadDocument,
      deleteLoading: !(currentDocument.deleteLoading ?? false),
    );
    currentList[index] = updatedDocument;
    emit(state.copyWith(tripDocumentList: currentList));
  }

  /// add option for add more other documents
  DocumentEntity addOthersDocumentUploadOption(
    List<DocumentEntity> currentList,
  ) {
    final currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    final otherDocumentObj = currentList.firstWhere(
      (element) =>
          element.fileType == DocumentFileType.uploadOtherDocument.value,
    );
    final currentDocument = otherDocumentObj.copyWith(loadDocument: null);

    return currentDocument;
  }

  Future<CreateDocumentResponse?> createDocument(
    String title,
    int documentTypeId,
    UploadDamageFileModel uploadImage,
  ) async {
    try {
      final mimeType = lookupMimeType(uploadImage.filePath);
      return await _loadDetailsRepository
          .createNewDocument(
            CreateDocumentRequest(
              title: title,
              description: title,
              documentTypeId: documentTypeId,
              filePath: uploadImage.filePath,
              fileSize: uploadImage.size,
              mimeType: mimeType,
              originalFilename: uploadImage.originalName,
              fileExtension: uploadImage.originalName.split(".").last,
            ),
          )
          .then((value) {
            if (value is Success<CreateDocumentResponse>) {
              return value.value;
            } else if (value is Error<CreateDocumentResponse>) {
              ToastMessages.error(message: getErrorMsg(errorType: value.type));
            }

            return null;
          });
    } catch (e) {
      return null;
    }
  }

  Future<LoadDocument?> saveDocument(
    CreateDocumentResponse createDocumentResponse,
    String loadId,
  ) async {
    try {
      return await _loadDetailsRepository
          .saveLoadDocument(
            documentId: createDocumentResponse.documentId ?? "",
            loadId: loadId,
          )
          .then((value) {
            if (value is Success<LoadDocument>) {
              return value.value;
            }
            return null;
          });
    } catch (e) {
      return null;
    }
  }

  Future viewDocument(String documentId, int index) async {
    try {
      uploadLoadingStatus(index, null);
      return await _loadDetailsRepository
          .viewDocument(documentId: documentId)
          .then((result) {
            if (result is Success<ViewDocumentResponse>) {
              downloadAndOpenFile(
                result.value.filePath ?? "",
                originalFileName: result.value.originalFilename,
              );
              uploadLoadingStatus(index, null);
            }
            if (result is Error) {
              uploadLoadingStatus(index, null);
            }
          });
    } catch (e) {
      uploadLoadingStatus(index, null);
      return null;
    }
  }

  Future downloadDocument(String documentId, int index) async {
    try {
      uploadLoadingStatus(index, null);
      return await _loadDetailsRepository
          .viewDocument(documentId: documentId)
          .then((result) {
            if (result is Success<ViewDocumentResponse>) {
              downloadAndOpenFile(
                result.value.filePath ?? "",
                originalFileName: result.value.originalFilename,
              );
              uploadLoadingStatus(index, null);
            }
            if (result is Error) {
              uploadLoadingStatus(index, null);
            }
          });
    } catch (e) {
      uploadLoadingStatus(index, null);
      return null;
    }
  }

  void resetDeleteDamageUIState() {
    emit(
      state.copyWith(
        deleteDamageUIState: resetUIState<DeleteDamageModel>(
          state.deleteDamageUIState,
        ),
      ),
    );
  }

  void resetLoadStatuUpdateReset() {
    emit(
      state.copyWith(
        loadStatusUIState: resetUIState<VpLoadAcceptModel>(
          state.loadStatusUIState,
        ),
      ),
    );
  }

  void resetUploadDamageFileUIState() {
    emit(
      state.copyWith(
        uploadDamageUIState: resetUIState<UploadDamageFileModel>(
          state.uploadDamageUIState,
        ),
      ),
    );
  }

  void resetSubmitDamageUIState() {
    emit(
      state.copyWith(
        createDamageUIState: resetUIState<DamageModel>(
          state.createDamageUIState,
        ),
      ),
    );
  }

  void resetSettlementUIState() {
    emit(
      state.copyWith(
        settlementUIState: resetUIState<DamageModel>(state.settlementUIState),
      ),
    );
  }

  void resetUpdateDamageUIState() {
    emit(
      state.copyWith(
        updateDamageUIState: resetUIState<UpdateDamageModel>(
          state.updateDamageUIState,
        ),
      ),
    );
  }

  void resetState() {
    emit(
      state.copyWith(
        uploadDamageUIState: resetUIState<UploadDamageFileModel>(
          state.uploadDamageUIState,
        ),
        createDamageUIState: resetUIState<DamageModel>(
          state.createDamageUIState,
        ),
        deleteDamageUIState: resetUIState<DeleteDamageModel>(
          state.deleteDamageUIState,
        ),
        updateDamageUIState: resetUIState<UpdateDamageModel>(
          state.updateDamageUIState,
        ),
        isUpdateDamage: false,
      ),
    );
  }

  setTripDocuments(List<LoadDocument>? loadDocument) {
    List<DocumentEntity> documentList = List.from(state.tripDocumentList ?? []);
    print("loadDocument from api ${loadDocument?.length} and document list is ${documentList}");
    for (DocumentEntity item in documentList) {
      print("working loop perfect");
      /// find load item for api response set into local document entity
      item.loadDocument = filterLoadDocumentById(loadDocument, item);
    }
    emit(state.copyWith(tripDocumentList: documentList));
  }

  List<LoadDocument> filterLoadDocumentById(List<LoadDocument>? loadDocument,DocumentEntity item){
    try {
      if(item.documentType!=DocumentFileType.uploadOtherDocument.documentType){
        LoadDocument? foundedDocument = loadDocument!.firstWhere(
              (element) =>
          element.documentDetails?.documentType == item.documentType,
        );

        return [foundedDocument];
      } else {
        return loadDocument!.where(
              (element) =>
          element.documentDetails?.documentType == item.documentType,
        ).toList();
      }} catch (e) {
      return [];
    }
  }

  bool checkIsDocumentUploaded(List<DocumentEntity> documentEntity) {
    try {
      DocumentEntity? document = documentEntity.firstWhere(
        (element) => element.loadDocument == null && element.visible == true,
      );
      return document == null;
    } catch (e) {
      return true;
    }
  }

  String getDistance(String pickUpLatLong, dropLatLong) {
    final pickupLatLng = TripTrackingHelper.getLatLngFromString(pickUpLatLong);
    final dropLatLng = TripTrackingHelper.getLatLngFromString(dropLatLong);
    double distanceInMeters = Geolocator.distanceBetween(
      pickupLatLng.latitude,
      pickupLatLng.longitude,
      dropLatLng.latitude,
      dropLatLng.longitude,
    );
    return (distanceInMeters / 1000).toStringAsFixed(2);
  }

 
     Future<void> _handleTrackingBasedOnStatus(DriverLoadDetailsModel? data) async {
    final status =  getVPLoadStatusFromString(data?.data?.loadStatusDetails?.loadStatus);
    final route = data?.data?.loadRoute;
    final tracking = data?.data?.trackingDetails;

    if (status != null && route != null ) {
      late final TrackingDistanceApiRequest request;

      if (status.index <= LoadStatus.assigned.index ) {
        // Use pickup & drop coordinates
        final pickup = route.pickUpLatlon.split(',');
        final drop = route.dropLatlon.split(',');

        request = TrackingDistanceApiRequest(
          originLat: double.tryParse(pickup.first) ?? 0.0,
          originLong: double.tryParse(pickup.last) ?? 0.0,
          currentLat: double.tryParse(pickup.first) ?? 0.0,
          currentLong: double.tryParse(pickup.last) ?? 0.0,
          destLat: double.tryParse(drop.first) ?? 0.0,
          destLong: double.tryParse(drop.last) ?? 0.0,
        );
      } else {
        request = TrackingDistanceApiRequest(
          originLat: tracking?.originLat ?? 0,
          originLong: tracking?.originLong ??0,
          currentLat: tracking?.currentLat ??0,
          currentLong: tracking?.currentLong ??0,
          destLat: tracking?.destinationLat ?? 0,
          destLong: tracking?.destinationLong ??0
        );
      }

      await getTrackingDistance(request: request);
    }
  }
  // Updates the UI state related to tracking distance.
  void _setTrackingDistanceState(UIState<TrackingDistanceResponse>? uiState) {
    emit(state.copyWith(trackingDistance: uiState));
  }

  // Lp load tracking distance
  Future<void> getTrackingDistance({
    required TrackingDistanceApiRequest request,
  }) async {
    _setTrackingDistanceState(UIState.loading());

    Result result = await _lpLoadRepository.getTrackingDistance(
      request: request,
    );

    if (result is Success<TrackingDistanceResponse>) {
      emit(state.copyWith(locationDistance: result.value.overalldistance));
      _setTrackingDistanceState(UIState.success(result.value));
    } else if (result is Error) {
      _setTrackingDistanceState(UIState.error(result.type));
    }
  }

  bool isNextProcessButtonEnabled({
    required List<DocumentEntity> documentEntity,
    required int driverConsent,
    dynamic memo,
    int? loadStatus,
  }) {
    switch (loadStatus) {
      case LoadStatus.assigned:
        return memo != null;
      case LoadStatus.loading:
        return driverConsent == 1 && checkIsDocumentUploaded(documentEntity);
      case LoadStatus.unloading:
        return checkIsDocumentUploaded(documentEntity);
      default:
        return true;
    }
  }

  // POD Doc File upload field
  void updatePODVisibilityBasedOnStatus(int? status) {
    final currentList = state.tripDocumentList ?? [];

    // Check if POD (TypeId = 331) exists
    final podIndex = currentList.indexWhere((doc) => doc.documentType ==  DocumentFileType.proofOfDelivery.documentType);
    if (podIndex != -1 && status != null && status > 6) {
      final updatedDoc = currentList[podIndex].copyWith(visible: true);
      currentList[podIndex] = updatedDoc;
      emit(state.copyWith(tripDocumentList: currentList));
    }
  }

  bool areRequiredDocsUploaded(List<DocumentEntity> tripDocumentList) {
    const requiredDocsMap = {
      5: 'Lorry Receipt',
      6: 'E-Way Bill',
      7: 'Material Invoice',
    };

    for (final typeId in requiredDocsMap.keys) {
      final entity = tripDocumentList.firstWhere(
        (d) => d.documentTypeId == typeId,
      );
      if (entity == null) {
        return false;
      }
      if (entity.loadDocument == null || entity.loadDocument!.isEmpty) {
        return false;
      }
      if (!entity.loadDocument!.any((doc) => doc.status == 1)) {
        return false;
      }
    }
    return true;
  }

  bool canAddMoreOtherDocuments() {
    try {
      final otherDocEntity = state.tripDocumentList?.firstWhere(
        (doc) => doc.documentType==DocumentFileType.uploadOtherDocument.documentType,
      );
      return (otherDocEntity?.loadDocument?.length ?? 0) < 5;
    } catch (e) {
      return false;
    }
  }

  bool isPODUploaded(List<DocumentEntity> tripDocumentList) {
    const podTypeId = 331;

    final podDocEntity = tripDocumentList.firstWhere(
      (doc) => doc.documentTypeId == podTypeId,
    );

    if (podDocEntity == null || podDocEntity.loadDocument == null) {
      return false;
    }

    return podDocEntity.loadDocument!.any((loadDoc) => loadDoc.status == 1);
  }

  bool isMemoUploaded(DriverLoadDetailsModel? load) {
    final currentStatus = load?.data?.loadStatusId ?? 0;
    if (currentStatus == 4) {
      return load?.data?.loadMemo != null;
    }
    return true;
  }

  String? _userId;

  String? get userId => _userId;

  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
