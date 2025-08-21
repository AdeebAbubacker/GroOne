import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart' hide LoadStatus;
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/tracking_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/tracking_distance_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/repository/lp_all_loads_repository.dart';
import 'package:gro_one_app/features/trip_tracking/helper/trip_tracking_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/create_document_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/settlement_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/api_request/update_damage_api_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/create_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/delete_damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/delete_load_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/get_damage_list_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/settlement_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/update_damage_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/upload_damage_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/view_document_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/repository/load_details_repository.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/api_request/schedule_trip_request.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/direction_api_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/schedule_trip_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_load_accept_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/repository/vp_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:mime/mime.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart' as lpHelper;
import 'load_details_state.dart';

class LoadDetailsCubit extends BaseCubit<LoadDetailsState> {
  final LoadDetailsRepository _loadDetailsRepository;
  final VpHomeRepository _vHomeRepository;
  final LpLoadRepository _lpLoadRepository;
  final LpLoadRepository _lpLoadsrepository;

  LoadDetailsCubit(this._loadDetailsRepository, this._vHomeRepository,this._lpLoadRepository,this._lpLoadsrepository)
      : super(LoadDetailsState(tripDocumentList:[]));


  void setIsUpdateDamage(bool value){
    emit(state.copyWith(isUpdateDamage: value));
  }

  void setDamageId(String value){
    emit(state.copyWith(damageId: value));
    CustomLog.debug(this, "Damage Id Set : ${state.damageId}");
  }

  void skipPodView({bool? value}){
    emit(state.copyWith(iPodSkip: value??false));
  }

  acceptLoad(int? status) {
    LoadStatus? loadStatus;
    loadStatus = getLoadStatus(status);
    loadStatus = getLoadStatus(status);

    emit(state.copyWith(
        loadStatusId: status,
        loadStatus: loadStatus));

    if(status==7){
      final currentList = List<DocumentEntity>.from(state.tripDocumentList ?? []);
      final podDocumentIndex = currentList.indexWhere((element) => element.documentType==DocumentFileType.proofOfDelivery.documentType,);
      final uploadOtherDocumentIndex = currentList.indexWhere((element) => element.documentType==DocumentFileType.uploadOtherDocument.documentType,);

      final updatedDocument = currentList[podDocumentIndex].copyWith(
        visible: true
      );
      final updateOtherDocument = currentList[uploadOtherDocumentIndex].copyWith(
        visible: false
      );
      currentList[podDocumentIndex] = updatedDocument;
      currentList[uploadOtherDocumentIndex] = updateOtherDocument;
      emit(state.copyWith(tripDocumentList: currentList));
    }
  }

  setDocumentState(){
    emit(state.copyWith(
      tripDocumentList: DocumentDataModel.documentTypeList
    ));
  }


  void resetTripDocumentState(){
    emit(state.copyWith(
       iPodSkip: false,
        tripDocumentList: DocumentDataModel.documentTypeList));
  }


  Future<void> getLoadDetails(String loadId) async {
    emit(state.copyWith(

        loadDetailsUIState: UIState.loading()));
    Result result = await _loadDetailsRepository.fetchLoadDetails(
        loadId.toString());
    if (result is Success<LoadDetailModel>) {
      emit(state.copyWith(
          loadDetailsUIState: UIState.success(result.value)));
      getAllDamagesImages(getFromDetails: true);

      acceptLoad(state.loadDetailsUIState?.data?.data?.loadStatusId);

      /// SET TRIP DOCUMENT

      setTripDocuments(
          state.loadDetailsUIState?.data?.data?.loadDocument ?? []);
      _handleTrackingBasedOnStatus(state.loadDetailsUIState?.data?.data);
    }
    if (result is Error) {
      emit(state.copyWith(loadDetailsUIState: UIState.error(result.type)));
    }
  }

  Future<void> changedLoadStatus(String load, {
    String? customerId,
    int? loadStatus,
  }) async {
    emit(state.copyWith(vpLoadStatus: UIState.loading()));
    Result result = await _loadDetailsRepository.changeLoadStatus(
      customerId: customerId.toString(),
      loadStatus: loadStatus,
      loadId: load.toString(),
    );
    if (result is Success<VpLoadAcceptModel>) {
      emit(state.copyWith(vpLoadStatus: UIState.success(result.value)));
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // slight delay to ensure UI handles it
      acceptLoad(result.value.data?.loadStatus);
    }

    if (result is Error) {
      emit(state.copyWith(vpLoadStatus: UIState.error(result.type)));
      ToastMessages.error(
          message: getErrorMsg(errorType: state.vpLoadStatus!.errorType!));
    }
  }


  Future<void> _handleTrackingBasedOnStatus(LoadDetailModelData? data) async {
    final status = getVPLoadStatusFromString(data?.loadStatusDetails?.loadStatus);
    final route = data?.loadRoute;
    final tracking = data?.trackingDetails;

    if (status != null && route != null ) {
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
          originLat: tracking?.originLat??0,
          originLong: tracking?.originLong??0,
          currentLat: tracking?.currentLat ?? 0,
          currentLong: tracking?.currentLong ??0,
          destLat: tracking?.destinationLat ??0,
          destLong: tracking?.destinationLong ?? 0
        );
      }

      await getTrackingDistance(request: request);
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

  updatePossibleDeliveryDateDate(String? possibleDeliveryTime) {
    emit(state.copyWith(possibleDeliveryDate: possibleDeliveryTime));
  }


  Future scheduleTripApi(ScheduleTripRequest scheduleTripRequest) async {
    emit(state.copyWith(scheduleTripResponse: UIState.loading()));
    Result result = await _vHomeRepository.scheduleTripResponse(
      apiRequest: scheduleTripRequest,
    );
    if (result is Success<ScheduleTripResponse>) {
      emit(state.copyWith(
          scheduleTripResponse: UIState.success(result.value)));
      Navigator.pop(navigatorKey.currentState!.context);
    } else if (result is Error) {
      emit(state.copyWith(scheduleTripResponse: UIState.error(result.type)));
      ToastMessages.error(message: getErrorMsg(
          errorType: state.scheduleTripResponse?.errorType ??
              GenericError()));
    }
  }


  Future getMapRouting({String? pickUpLat,String? pickUpLong,String? dropLat,String? dropLong}) async {
    emit(state.copyWith(directionApiResponse: UIState.loading()));
    try{
      DirectionResponse? directionResponse = await _vHomeRepository.getGoogleDirectionResponse(
          pickUpLat,
          pickUpLong,
          dropLat,
          dropLong
      );
      if (directionResponse!=null) {
        emit(state.copyWith(directionApiResponse: UIState.success(directionResponse)));
      }
    }catch(e){
      ToastMessages.error(message:e.toString(),);
      emit(state.copyWith(directionApiResponse: UIState.error(DeserializationError())));
    }
  }


  // Submit Settlement Api Call
  void _setSettlementUIState(UIState<SettlementApiResponse>? uiState){
    emit(state.copyWith(settlementUIState: uiState));
  }
  Future<void> submitSettlement(SettlementApiRequest req) async {
    _setSettlementUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getSubmitSettlementData(req);
    if (result is Success<SettlementApiResponse>) {
      _setSettlementUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setSettlementUIState(UIState.error(result.type));
    }
  }


  // Create Damage Api Call
  void _setDamageUIState(UIState<DamageModel>? uiState) {
    emit(state.copyWith(createDamageUIState: uiState));
  }

  Future<void> createDamage(DamageApiRequest req) async {
    _setDamageUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getSubmitDamageData(req);
    if (result is Success<DamageModel>) {
      _setDamageUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setDamageUIState(UIState.error(result.type));
    }
  }


  // Edit Damage Api Call
  void _setUpdateDamageUIState(UIState<UpdateDamageModel>? uiState){
    emit(state.copyWith(updateDamageUIState: uiState));
  }
  Future<void> updateDamage(UpdateDamageApiRequest req, String damageId) async {
    _setUpdateDamageUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getUpdateDamageData(req, damageId);
    if (result is Success<UpdateDamageModel>) {
      _setUpdateDamageUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUpdateDamageUIState(UIState.error(result.type));
    }
  }


  // Delete Damage Api Call
  void _setDeleteDamageUIState(UIState<DeleteDamageModel>? uiState){
    emit(state.copyWith(deleteDamageUIState: uiState));
  }
  Future<void> deleteDamage(String damageId) async {
    _setDeleteDamageUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getDeleteDamageData(damageId);
    if (result is Success<DeleteDamageModel>) {
      _setDeleteDamageUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setDeleteDamageUIState(UIState.error(result.type));
    }
  }


  //  Damage list Api Call
  void _setDamageListUIState(UIState<GetDamageListModel>? uiState){
    emit(state.copyWith(damageListUIState: uiState));
  }
  Future<void> fetchDamageList(String loadId) async {
    _setDamageListUIState(UIState.loading());
    Result result = await _loadDetailsRepository.getDamageListData(loadId);
    if (result is Success<GetDamageListModel>) {
      _setDamageListUIState(UIState.success(result.value));
      getAllDamagesImages();
    }
    if (result is Error) {
      _setDamageListUIState(UIState.error(result.type));
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
  Future<void> deleteLoadDocument(String loadDocumentID,int index,{bool otherDocument=false}) async {
    if(!otherDocument){
      uploadDeleteLoaderStatus(index);
    }

    Result result = await _loadDetailsRepository.deleteLoadDocument(loadDocumentID);
    if (result is Success<DeleteLoadDocumentResponse>) {
      /// delete from local
      if(otherDocument){
        deleteOtherDocumentFromLocal(index);
      }else{
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


  Future<void> uploadDocument(File file, String fileType, String? title,
      int? documentTypeId, String loadId, int index) async {
    /// upload document = > Create Document = > Map Document with load
    try {
      uploadLoadingStatus(index, null);
      Result result = await _loadDetailsRepository.uploadDocument(file, fileType);
      if (result is Success<UploadDamageFileModel>) {
        ///Create Document
        await createDocument(title ?? "", documentTypeId ?? 1, result.value).then((value) async {
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

   // Updates the UI state related to tracking distance.
  void _setTrackingDistanceState(UIState<TrackingDistanceResponse>? uiState) {
    emit(state.copyWith(trackingDistance: uiState));
  }



  // Lp load tracking distance
  Future<void> getTrackingDistance({required TrackingDistanceApiRequest request}) async {
    _setTrackingDistanceState(UIState.loading(),);
    emit(state.copyWith(locationDistance: ""));
    Result result = await _lpLoadsrepository.getTrackingDistance(request: request);

    if (result is Success<TrackingDistanceResponse>) {
      emit(state.copyWith(locationDistance: result.value.overalldistance));
      _setTrackingDistanceState(UIState.success(result.value));
    } else if (result is Error) {
      _setTrackingDistanceState(UIState.error(result.type));
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

  Future downloadDocument(String documentId, int index) async {
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


  Future<ViewDocumentResponse?> fetchDocumentById(String documentId) async {
   return _loadDetailsRepository.viewDocument(
      documentId: documentId,
    ).then((result) => (result is Success<ViewDocumentResponse>) ? result.value:null);
  }


  Future getAllDamagesImages({bool getFromDetails=false})async{
    List<DamageReport> damageListData=  getFromDetails ? List.from(state.loadDetailsUIState?.data?.data?.damageShortage??[]):List.from(state.damageListUIState?.data?.data??[]);
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
    emit(state.copyWith(settlementUIState: resetUIState<SettlementApiResponse>(
        state.settlementUIState)));
  }

  void resetUpdateDamageUIState(){
    emit(state.copyWith(updateDamageUIState: resetUIState<UpdateDamageModel>(state.updateDamageUIState)));
  }


  void resetState(){
    emit(state.copyWith(
      possibleDeliveryDate: "",
      scheduleTripResponse: resetUIState<ScheduleTripResponse>(state.scheduleTripResponse),
      uploadDamageUIState: resetUIState<UploadDamageFileModel>(state.uploadDamageUIState),
      createDamageUIState : resetUIState<DamageModel>(state.createDamageUIState),
      deleteDamageUIState : resetUIState<DeleteDamageModel>(state.deleteDamageUIState),
      updateDamageUIState : resetUIState<UpdateDamageModel>(state.updateDamageUIState),
      isUpdateDamage : false,
      damageId: null
    ));
  }




  void resetTripScheduleUIState(){
    emit(state.copyWith(scheduleTripResponse: resetUIState<ScheduleTripResponse>(state.scheduleTripResponse)));
  }


    setTripDocuments(List<LoadDocument>? loadDocument) {
    List<DocumentEntity> documentList = List.from(state.tripDocumentList ?? []);
      for (DocumentEntity item in documentList) {
        /// find load item for api response set into local document entity
        item.loadDocument=filterLoadDocumentById(loadDocument,item);
      }
      emit(state.copyWith(
          tripDocumentList: documentList
      ));
    }


  bool checkIsDocumentUploaded(List<DocumentEntity> documentEntity) {
    try {
      DocumentEntity? document = documentEntity.firstWhere((element) {
        return (element.loadDocument??[]).isEmpty && element.visible==true;
      });
      print("document.fileType is ${document.fileType}");
      return document == null || document.fileType==DocumentFileType.uploadOtherDocument.value;
    } catch (e) {
      return true;
    }
  }

 bool isNextProcessButtonEnabled({required List<
     DocumentEntity> documentEntity, required int driverConsent, dynamic memo, LoadStatus? loadStatus,bool? checkMemo=true,bool? isAgreed}) {
    switch(loadStatus){
      case LoadStatus.assigned:
        return (checkMemo??true) ? memo!=null && (isAgreed??false):true;
        case LoadStatus.loading:
          return  checkIsDocumentUploaded(documentEntity);
      case LoadStatus.unloading:
        return checkIsDocumentUploaded(documentEntity);
      default:
        return true;
    }
  }

  bool checkAllDocumentAddedOrNot({required List<LoadDocument> documentList,  MemoDetails? memo , LoadStatus? loadStatus,int? isAgreed}) {
    switch(loadStatus){
      case LoadStatus.loading:
      return  checkLoadingDocumentAddedOrNot(documentList,true);

      case LoadStatus.unloading:
        return checkLoadingDocumentAddedOrNot(documentList,false);

      case LoadStatus.assigned:
        return memo!=null && isAgreed==1;

      default:
        return true;
    }


  }
  bool checkLoadingDocumentAddedOrNot(List<LoadDocument> loadDocumentList,bool? checkPod){
    List<String> requiredDocument= (checkPod??false)   ?  [
      DocumentFileType.lorryReceipt.documentType??"",
      DocumentFileType.ewayBill.documentType??"",
      DocumentFileType.materialInvoice.documentType??"",
    ]:[
      DocumentFileType.proofOfDelivery.documentType??""
    ];

    bool isAdded=false;
    for(var item in requiredDocument){

      try{
        loadDocumentList.firstWhere((element) => element.documentDetails?.documentType==item);
        isAdded=true;
      }catch(e){
        return false;
      }
    }
    return isAdded;
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


  bool isVisibleAddMoreDocument(){
    try{
      DocumentEntity? tripDocumentList= state.tripDocumentList?.firstWhere((element) => element.documentType==DocumentFileType.uploadOtherDocument.documentType,);
      return (tripDocumentList?.loadDocument?.length??0)<5;
    }catch(e){
      return false;
    }
  }
}
