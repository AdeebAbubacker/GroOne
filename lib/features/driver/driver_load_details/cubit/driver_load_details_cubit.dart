import 'dart:io';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart'
    as lpHelper;
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
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
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
          iPodSkip: state.iPodSkip,
        ),
      );
       getAllDamagesImages(getFromDetails: true);
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
  
  /// Fetch Damage list
  Future<void> fetchDamageList(String loadId) async {
    _setDamageListUIState(UIState.loading());
    Result result = await _repository.getDamageListData(loadId);
    if (result is Success<GetDamageListModel>) {
      _setDamageListUIState(UIState.success(result.value));
      getAllDamagesImages();
    }
    if (result is Error) {
      _setDamageListUIState(UIState.error(result.type));
    }
  }
  
  /// Get All Damages Images
  Future getAllDamagesImages({bool getFromDetails=false})async{
    List<DamageReport> damageListData=  getFromDetails ? List.from(state.lpLoadById?.data?.data?.damageShortage??[]):List.from(state.damageListUIState?.data?.data??[]);
   List<String> imageList=[];
   for(int i=0;i<(damageListData.length);i++){
     final getDamageData= damageListData[i];
     if((getDamageData.image??[]).isEmpty){
       return;
     }
     String typeId=getDamageData.image!.first;
     await fetchDocumentById(typeId).then((value) {
       imageList.add(value?.filePath??"");
       },);}
       emit(state.copyWith(
     allDamageImageList: imageList
    ));
  }
   
  /// Fetch Document By Id 
   Future<ViewDocumentResponse?> fetchDocumentById(String documentId) async {
   return _loadDetailsRepository.viewDocument(
      documentId: documentId,
    ).then((result) => (result is Success<ViewDocumentResponse>) ? result.value:null);
  }
  //  Update Load Status Api Call
  void _updateloadStatusUIState(UIState<VpLoadAcceptModel>? uiState) {
    emit(state.copyWith(loadStatusUIState: uiState));
  }

  // set Trip Document List
  setDocumentState() {
    emit(state.copyWith(tripDocumentList: DocumentDataModel.documentTypeList));
  }
  
  /// Update Load Status
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
          iPodSkip: state.iPodSkip,
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
  Future<void> deleteLoadDocument(
    String loadDocumentID,
    int index, {
    bool otherDocument = false,
  }) async {
    if (!otherDocument) {
      uploadDeleteLoaderStatus(index);
    }

    Result result = await _loadDetailsRepository.deleteLoadDocument(
      loadDocumentID,
    );
    if (result is Success<DeleteLoadDocumentResponse>) {
      /// delete from local
      if (otherDocument) {
        print('local deleete called');
        deleteOtherDocumentFromLocal(index);
      } else {
        print('not ------------deleetd from local');
        uploadDeleteLoaderStatus(index, isDelete: true);
      }
    }
    if (result is Error) {
      uploadDeleteLoaderStatus(index);
    }
  }

  deleteOtherDocumentFromLocal(int index) {
    final currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    int currentDocumentIndex = currentList.indexWhere(
      (element) =>
          element.documentType ==
          DocumentFileType.uploadOtherDocument.documentType,
    );
    List<LoadDocument> loadDocument = List.from(
      currentList[currentDocumentIndex].loadDocument ?? [],
    );
    loadDocument.removeAt(index);

    final updatedDocument = currentList[currentDocumentIndex].copyWith(
      clearLoadData: false,
      loadDocument: loadDocument,
      isLoading: false,
      deleteLoading: false,
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
            await saveDocument(value, loadId,fileType).then((value) {
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
    if(index==-1){
      return;
    }
    List<DocumentEntity> currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
    final currentDocument = currentList[index];

    final updatedDocument = currentDocument.copyWith(
      loadDocument: [
        ...currentDocument.loadDocument??[],
        if(loadDocument!=null) ...[loadDocument]
      ],
      isLoading: !(currentDocument.isLoading ?? false),
    );
    currentList[index] = updatedDocument;

    /// TODO:
    /// This is for multiple documents

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
 
  /// Skip Pod
  void skipPodView({bool? value}) {
    emit(state.copyWith(iPodSkip: value ?? false));
  }

  Future<LoadDocument?> saveDocument(
    CreateDocumentResponse createDocumentResponse,
    String loadId,
      String? fileType,
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
 
  /// Reset DamageState
  void resetDeleteDamageUIState() {
    emit(
      state.copyWith(
        deleteDamageUIState: resetUIState<DeleteDamageModel>(
          state.deleteDamageUIState,
        ),
      ),
    );
  }
 
  /// Reset Load Status
  void resetLoadStatuUpdateReset() {
    emit(
      state.copyWith(
        loadStatusUIState: resetUIState<VpLoadAcceptModel>(
          state.loadStatusUIState,
        ),
      ),
    );
  }
 
  /// Reset Upload Damage File
  void resetUploadDamageFileUIState() {
    emit(
      state.copyWith(
        uploadDamageUIState: resetUIState<UploadDamageFileModel>(
          state.uploadDamageUIState,
        ),
      ),
    );
  }
 
  /// Reset Submitted Damage
  void resetSubmitDamageUIState() {
    emit(
      state.copyWith(
        createDamageUIState: resetUIState<DamageModel>(
          state.createDamageUIState,
        ),
      ),
    );
  }
 
  /// Reset Settlement State
  void resetSettlementUIState() {
    emit(
      state.copyWith(
        settlementUIState: resetUIState<DamageModel>(state.settlementUIState),
      ),
    );
  }
  
  /// Reset Updated damage state
  void resetUpdateDamageUIState() {
    emit(
      state.copyWith(
        updateDamageUIState: resetUIState<UpdateDamageModel>(
          state.updateDamageUIState,
        ),
      ),
    );
  }
 
  /// Reset State
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
 
  /// Set Trip Documents
  setTripDocuments(List<LoadDocument>? loadDocument) {
    List<DocumentEntity> documentList = List.from(state.tripDocumentList ?? []);
    for (DocumentEntity item in documentList) {
      /// find load item for api response set into local document entity
      item.loadDocument = filterLoadDocumentById(loadDocument, item);
    }
    emit(state.copyWith(tripDocumentList: documentList));
  }

  List<LoadDocument> filterLoadDocumentById(
    List<LoadDocument>? loadDocument,
    DocumentEntity item,
  ) {
    try {
      if (item.documentType !=
          DocumentFileType.uploadOtherDocument.documentType) {
        LoadDocument? foundedDocument = loadDocument!.firstWhere(
          (element) =>
              element.documentDetails?.documentType == item.documentType,
        );

        return [foundedDocument];
      } else {
        return loadDocument!
            .where(
              (element) =>
                  element.documentDetails?.documentType == item.documentType,
            )
            .toList();
      }
    } catch (e) {
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
  
  /// Get Total Distance
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

    if (status != null && route != null) {
      late final TrackingDistanceApiRequest request;

      if (status.index <= LoadStatus.assigned.index) {
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
          originLong: tracking?.originLong ?? 0,
          currentLat: tracking?.currentLat ?? 0,
          currentLong: tracking?.currentLong ?? 0,
          destLat: tracking?.destinationLat ?? 0,
          destLong: tracking?.destinationLong ?? 0,
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
  
  // POD Doc File upload field
  void updatePODVisibilityBasedOnStatus(int? status) {
  final currentList = state.tripDocumentList ?? [];
  final podIndex = currentList.indexWhere((doc) => doc.documentType == DocumentFileType.proofOfDelivery.documentType);
  if (podIndex != -1) {
    final updatedDoc = currentList[podIndex].copyWith(visible: status != null && status >= 7);
    currentList[podIndex] = updatedDoc;
    emit(state.copyWith(tripDocumentList: currentList));
  }
}


  final Map<LoadStatus, List<DocumentFileType>> requiredDocsByStatus = {
    LoadStatus.loading: [
      DocumentFileType.lorryReceipt,
      DocumentFileType.ewayBill,
      DocumentFileType.materialInvoice,
    ],
    LoadStatus.unloading: [DocumentFileType.proofOfDelivery],
  };
  
  /// Trip Document uploaded or not check
  bool areRequiredDocsUploaded(
    List<DocumentEntity> tripDocumentList,
    LoadStatus? status,
  ) {
    if (status == null || !requiredDocsByStatus.containsKey(status))
      return true;

    final requiredDocs = requiredDocsByStatus[status]!;

    for (final docType in requiredDocs) {
      final entity = tripDocumentList.firstWhere(
        (d) => d.documentType == docType.documentType,
      );
      if (entity == null) return false;

      final docs = entity.loadDocument ?? [];
      if (docs.isEmpty || !docs.any((doc) => doc.status == 1)) {
        return false;
      }
    }
    return true;
  }
  
  /// Check if we can add more document or not
  bool canAddMoreOtherDocuments() {
    try {
      final otherDocEntity = state.tripDocumentList?.firstWhere(
        (doc) =>
            doc.documentType ==
            DocumentFileType.uploadOtherDocument.documentType,
      );
      return (otherDocEntity?.loadDocument?.length ?? 0) < 5;
    } catch (e) {
      return false;
    }
  }

  /// Is Pod Uploaded or not
  bool isPODUploaded(List<DocumentEntity> tripDocumentList) {
    final podDocEntity = tripDocumentList.firstWhere(
      (doc) =>
          doc.documentType == DocumentFileType.proofOfDelivery.documentType,
    );

    if (podDocEntity == null || podDocEntity.loadDocument == null) {
      return false;
    }

    return podDocEntity.loadDocument!.any((loadDoc) => loadDoc.status == 1);
  }
  
  /// Is memo uploaded or not
  bool isMemoUploaded(DriverLoadDetailsModel? load) {
    final currentStatus = load?.data?.loadStatusId ?? 0;
    if (currentStatus == 4) {
      return load?.data?.loadMemo != null;
    }
    return true;
  }

  String? _userId;

  String? get userId => _userId;
  /// Get customer Id
  Future<String?> getUserId() async {
    _userId = await _userInformationRepository.getUserID();
    return _userId;
  }
}
