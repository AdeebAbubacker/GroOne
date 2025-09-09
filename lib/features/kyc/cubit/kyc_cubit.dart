import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/addhar_verify_otp_request.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/kyc/api_request/init_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/submit_kyc_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_gst_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_pan_request.dart';
import 'package:gro_one_app/features/kyc/api_request/verify_tan_request.dart';
import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';
import 'package:gro_one_app/features/kyc/model/aadhar_status_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/addhar_verify_otp_response.dart';
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/create_document_model.dart';
import 'package:gro_one_app/features/kyc/model/delete_document_model.dart';
import 'package:gro_one_app/features/kyc/model/doc_verification_model.dart';
import 'package:gro_one_app/features/kyc/model/file_upload_response.dart';
import 'package:gro_one_app/features/kyc/model/kyc_init_response.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
import 'package:gro_one_app/features/kyc/model/submit_kyc_response.dart';
import 'package:gro_one_app/features/kyc/model/upload_aadhhar_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_cancelled_check_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_gstin_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_pan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tan_document_model.dart';
import 'package:gro_one_app/features/kyc/model/upload_tds_document_model.dart';
import 'package:gro_one_app/features/kyc/repository/kyc_repository.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/utils/app_string.dart';
part 'kyc_state.dart';

class KycCubit extends BaseCubit<KycState> {
  final KycRepository _repo;
  KycCubit(this._repo, UserInformationRepository userInformationRepository)
    : super(KycState());

  // fetch user role
  int? userRole;
  Future<int?> fetchUserRole() async {
    userRole = await _repo.getUserRole();
    return userRole;
  }

  // fetch user if
  String? userId;
  Future<String?> fetchUserId() async {
    userId = await _repo.getUserId();
    return userId;
  }

  // fetch company Type Id
  String? companyTypeId;
  Future<String?> fetchCompanyTypeId() async {
    companyTypeId = await _repo.getCompanyTypeId();
    return companyTypeId;
  }

  int _stateCurrentPage = 1;
  bool _stateIsLastPage = false;
  bool _stateIsLoadingMore = false;

  // Fetch State Api Call
  void _setStateUIState(UIState<List<StateModelList>>? uiState) {
    emit(state.copyWith(stateUIState: uiState));
  }

  Future<void> fetchStateList({
    bool isLoading = true,
    String? search,
    bool loadMore = false,
  }) async {
    // Prevent multiple simultaneous loadMore calls
    if (_stateIsLoadingMore && loadMore) return;

    // Reset when it's a fresh call (not loadMore)
    if (!loadMore) {
      _stateIsLastPage = false;
    } else if (_stateIsLastPage) {
      return;
    }

    if (loadMore) {
      _stateIsLoadingMore = true;
      _stateCurrentPage++;
    } else {
      _stateCurrentPage = 1;
      _stateIsLastPage = false;
      if (isLoading) _setStateUIState(UIState.loading());
    }

    try {
      final result = await _repo.getStateData(
        filter: search,
        page:
            (search != null && search.trim().isNotEmpty)
                ? null
                : _stateCurrentPage,
        limit: (search != null && search.trim().isNotEmpty) ? null : 10,
      );

      if (result is Success<StateModel>) {
        final newList = result.value.data;

        if (loadMore) {
          final existing = state.stateUIState?.data ?? <StateModelList>[];
          final combined = [...existing, ...newList];

          _setStateUIState(UIState.success(combined));
        } else {
          _setStateUIState(UIState.success(newList));
        }

        // Check if last page 
        if (search == null || search.trim().isEmpty) {
          final totalPages = ((result.value.total) / (10)).ceil();
          _stateIsLastPage = _stateCurrentPage >= totalPages;
        } else {
          _stateIsLastPage = true; 
        }
      }

      if (result is Error<StateModel>) {
        _setStateUIState(UIState.error(result.type));
      }
    } finally {
      _stateIsLoadingMore = false;
    }
  }

  Future<Result<StateModel>> getFilteredStateList({
    required String filter,
  }) async {
    return await _repo.getStateData(filter: filter);
  }

  // Fetch City Api Call
  void _setCityUIState(UIState<List<CityModelList>>? uiState) {
    emit(state.copyWith(cityUIState: uiState));
  }

  // In your Cubit
  int _cityCurrentPage = 1;
  bool _cityIsLastPage = false;
  bool _cityIsLoadingMore = false;

  Future fetchCityList(
    String stateName, {
    String? search,
    bool isLoading = true,
    bool loadMore = false,
  }) async {
    if (_cityIsLoadingMore && loadMore) return;

    if (!loadMore) {
      _cityIsLastPage = false;
    } else if (_cityIsLastPage) {
      return;
    }

    if (loadMore) {
      _cityIsLoadingMore = true;
      _cityCurrentPage++;
    } else {
      _cityCurrentPage = 1;
      _cityIsLastPage = false;
      if (isLoading) _setCityUIState(UIState.loading());
    }

    try {
      final result = await _repo.getCityData(
        stateName,
        filter: search,
        page: _cityCurrentPage,
        limit: 10,
      );

      if (result is Success<CityModel>) {
        final newList = result.value.data;

        if (loadMore) {
          final existing = state.cityUIState?.data ?? [];
          final combined = [...existing, ...newList];
          _setCityUIState(UIState.success(combined));
        } else {
          _setCityUIState(UIState.success(newList));
        }

        if (search == null || search.trim().isEmpty) {
          final totalPages = ((result.value.total) / (10)).ceil();
          _cityIsLastPage = _cityCurrentPage >= totalPages;
        } else {
          _cityIsLastPage = true; 
        }
      }

      if (result is Error<CityModel>) {
        _setCityUIState(UIState.error(result.type));
      }
    } finally {
      _cityIsLoadingMore = false;
    }
  }


  // Send Aadhaar Otp
  Future<void> sendAadhaarOtp(AadhaarOtpApiRequest request) async {
    emit(state.copyWith(aadhaarOtpState: UIState.loading()));
    Result result = await _repo.kycSendOtp(request);
    if (result is Success<AadhaarOtpModel>) {
      emit(state.copyWith(aadhaarOtpState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(aadhaarOtpState: UIState.error(result.type)));
    }
  }

  Future<void> sendKycRequest(KycInitRequest request) async {
    emit(
      state.copyWith(
        docVerificationState: resetUIState<DocVerificationModel>(
          state.docVerificationState,
        ),
        kycInitResponse: UIState.loading(),
      ),
    );
    Result result = await _repo.initKycRequest(request);
    if (result is Success<KycInitResponse>) {
      emit(state.copyWith(kycInitResponse: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(kycInitResponse: UIState.error(result.type)));
    }
  }

  Future<void> getKYCStatus(String requestID) async {
    emit(
      state.copyWith(
        docVerificationState: resetUIState<DocVerificationModel>(
          state.docVerificationState,
        ),
        kycInitResponse: resetUIState<KycInitResponse>(state.kycInitResponse),
        aadharVerificationResponse: UIState.loading(),
      ),
    );
    Result result = await _repo.getKYCStatus(requestID);
    if (result is Success<AadharVerificationResponse>) {
      emit(
        state.copyWith(
          aadharVerificationResponse: UIState.success(result.value),
        ),
      );
    }
    if (result is Error) {
      emit(
        state.copyWith(aadharVerificationResponse: UIState.error(result.type)),
      );
    }
  }

  // Verify Aadhaar Otp
  Future<void> verifyAadhaarOtp(AadhaarVerifyOtpApiRequest request) async {
    emit(state.copyWith(aadhaarVerifyOtpState: UIState.loading()));
    Result result = await _repo.verifyAadhaarOtp(request);
    if (result is Success<AadhaarVerifyOtpModel>) {
      emit(
        state.copyWith(aadhaarVerifyOtpState: UIState.success(result.value)),
      );
    }
    if (result is Error) {
      emit(state.copyWith(aadhaarVerifyOtpState: UIState.error(result.type)));
    }
  }

  // Verify Gst
  Future<void> verifyGst(
    VerifyGstApiRequest request,
    SecuredSharedPreferences securePrefs,
  ) async {
    emit(state.copyWith(gstState: UIState.loading()));
    Result result = await _repo.verifyGST(request);
    if (result is Success<bool>) {
      emit(state.copyWith(gstState: UIState.success(result.value)));
      await securePrefs.saveBoolean(
        AppString.sessionKey.isGstNumberVerified,
        true,
      );
    }
    if (result is Error) {
      emit(state.copyWith(gstState: UIState.error(result.type)));
    }
  }

  // Verify Tan
  Future<void> verifyTan(VerifyTanApiRequest request) async {
    emit(state.copyWith(tanState: UIState.loading()));
    Result result = await _repo.verifyTan(request);
    if (result is Success<bool>) {
      emit(state.copyWith(tanState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(tanState: UIState.error(result.type)));
    }
  }

  // Verify Doc
  Future<void> verifyDocId(String aadharNumber) async {
    emit(
      state.copyWith(
        kycInitResponse: resetUIState<KycInitResponse>(state.kycInitResponse),
        docVerificationState: UIState.loading(),
      ),
    );
    Result result = await _repo.verifiedDocID(aadharNumber: aadharNumber);
    if (result is Success<DocVerificationModel>) {
      emit(state.copyWith(docVerificationState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(docVerificationState: UIState.error(result.type)));
    }
  }

  // Verify Pan doc existence
  Future<void> verifyPanExistence(String panNumber) async {
    emit(state.copyWith(panDocVerificationState: UIState.loading()));
    Result result = await _repo.verifiedDocID(panNumber: panNumber);
    if (result is Success<DocVerificationModel>) {
      emit(
        state.copyWith(panDocVerificationState: UIState.success(result.value)),
      );
    }
    if (result is Error) {
      emit(state.copyWith(panDocVerificationState: UIState.error(result.type)));
    }
  }

  // Verify Tan
  Future<void> verifyTanExistence(String tanNumber) async {
    emit(state.copyWith(tanDocVerificationState: UIState.loading()));
    Result result = await _repo.verifiedDocID(tan: tanNumber);
    if (result is Success<DocVerificationModel>) {
      emit(
        state.copyWith(tanDocVerificationState: UIState.success(result.value)),
      );
    }
    if (result is Error) {
      emit(state.copyWith(tanDocVerificationState: UIState.error(result.type)));
    }
  }

  // Verify Gst doc existence
  Future<void> verifyGstDocExistence(String gstNumber) async {
    emit(state.copyWith(gstDocVerificationState: UIState.loading()));
    Result result = await _repo.verifiedDocID(gstNumber: gstNumber);
    if (result is Success<DocVerificationModel>) {
      emit(
        state.copyWith(gstDocVerificationState: UIState.success(result.value)),
      );
    }
    if (result is Error) {
      emit(state.copyWith(gstDocVerificationState: UIState.error(result.type)));
    }
  }

  // Check Kyc Verified
  Future<void> checkIsKycNumberVerified(
    SecuredSharedPreferences securePrefs,
  ) async {
    bool? isPanVerified = await securePrefs.getBooleans(
      AppString.sessionKey.isPanNumberVerified,
    );
    bool? isGtsNumberVerified = await securePrefs.getBooleans(
      AppString.sessionKey.isGstNumberVerified,
    );
    bool? isTanNumberVerified = await securePrefs.getBooleans(
      AppString.sessionKey.isTanNumberVerified,
    );

    emit(
      state.copyWith(
        verifiedGst: isGtsNumberVerified,
        verifiedTan: isTanNumberVerified,
        verifiedPan: isPanVerified,
      ),
    );
  }

  // Verify Pan
  Future<void> verifyPan(VerifyPanApiRequest request) async {
    emit(state.copyWith(panState: UIState.loading()));
    Result result = await _repo.verifyPan(request);
    if (result is Success<bool>) {
      emit(state.copyWith(panState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(panState: UIState.error(result.type)));
    }
  }

  void updatePanVerificationState() {
    emit(state.copyWith(verifiedPan: true));
  }

  void updateTanVerificationState() {
    emit(state.copyWith(verifiedTan: true));
  }

  void updateGstVerificationState() {
    emit(state.copyWith(verifiedGst: true));
  }

  // // Upload GST File
  void _setUploadGstDocUIState(UIState<UploadGSTDocumentModel>? uiState) {
    emit(state.copyWith(uploadGSTDocUIState: uiState));
  }

  Future<void> uploadGstDoc(File file) async {
    _setUploadGstDocUIState(UIState.loading());
    Result result = await _repo.getUploadGstData(file);
    if (result is Success<UploadGSTDocumentModel>) {
      _setUploadGstDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadGstDocUIState(UIState.error(result.type));
    }
  }

  // // Upload TAN File
  void _setUploadTanDocUIState(UIState<UploadTANDocumentModel>? uiState) {
    emit(state.copyWith(uploadTanDocUIState: uiState));
  }

  Future<void> uploadTanDoc(File file) async {
    _setUploadTanDocUIState(UIState.loading());
    Result result = await _repo.getUploadTanData(file);
    if (result is Success<UploadTANDocumentModel>) {
      _setUploadTanDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadTanDocUIState(UIState.error(result.type));
    }
  }

  // // Upload PAN File
  void _setUploadPanDocUIState(UIState<UploadPANDocumentModel>? uiState) {
    emit(state.copyWith(uploadPanDocUIState: uiState));
  }

  Future<void> uploadPanDoc(File file) async {
    _setUploadPanDocUIState(UIState.loading());
    Result result = await _repo.getUploadPanData(file);
    if (result is Success<UploadPANDocumentModel>) {
      _setUploadPanDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadPanDocUIState(UIState.error(result.type));
    }
  }

  void _setUploadAadharDocUIState(UIState<UploadAadharDocumentModel>? uiState) {
    emit(state.copyWith(uploadAadharDocUIState: uiState));
  }

  // Upload Aadhar DOC
  Future<void> uploadAadharDoc(File file) async {
    _setUploadAadharDocUIState(UIState.loading());
    Result result = await _repo.getUploadAadharDocument(file);
    if (result is Success<UploadAadharDocumentModel>) {
      _setUploadAadharDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadAadharDocUIState(UIState.error(result.type));
    }
  }

  // // Upload TDS File
  void _setUploadTdsDocUIState(UIState<UploadTDSDocumentModel>? uiState) {
    emit(state.copyWith(uploadTDSDocUIState: uiState));
  }

  Future<void> uploadTdsDoc(File file) async {
    _setUploadTdsDocUIState(UIState.loading());
    Result result = await _repo.getUploadTdsData(file);
    if (result is Success<UploadTDSDocumentModel>) {
      _setUploadTdsDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadTdsDocUIState(UIState.error(result.type));
    }
  }

  // // Upload TDS File
  void _setUploadCancelledCheckDocUIState(
    UIState<UploadCancelledCheckedDocumentModel>? uiState,
  ) {
    emit(state.copyWith(uploadCancelledUIState: uiState));
  }

  Future<void> uploadCancelledCheckDoc(File file) async {
    _setUploadCancelledCheckDocUIState(UIState.loading());
    Result result = await _repo.getUploadCancelledCheckedData(file);
    if (result is Success<UploadCancelledCheckedDocumentModel>) {
      _setUploadCancelledCheckDocUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setUploadCancelledCheckDocUIState(UIState.error(result.type));
    }
  }

  // Create Document
  void _setCreateDocumentUIState(UIState<CreateDocumentModel>? uiState) {
    emit(state.copyWith(createDocumentUIState: uiState));
  }

  Future<void> createDocument(CreateDocumentApiRequest request) async {
    _setCreateDocumentUIState(UIState.loading());
    Result result = await _repo.getCreateDocumentData(request);
    if (result is Success<CreateDocumentModel>) {
      _setCreateDocumentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setCreateDocumentUIState(UIState.error(result.type));
    }
  }

  // Delete Document
  void _setDeleteDocumentUIState(UIState<DeleteDocumentModel>? uiState) {
    emit(state.copyWith(deleteDocumentUIState: uiState));
  }

  Future<void> deleteDocument(String documentId) async {
    _setDeleteDocumentUIState(UIState.loading());
    Result result = await _repo.getDeleteDocumentData(documentId);
    if (result is Success<DeleteDocumentModel>) {
      _setDeleteDocumentUIState(UIState.success(result.value));
    }
    if (result is Error) {
      _setDeleteDocumentUIState(UIState.error(result.type));
    }
  }

  // Submit Kyc
  Future<void> submitKyc(SubmitKycApiRequest request, String userId) async {
    emit(state.copyWith(submitKycState: UIState.loading()));
    Result result = await _repo.submitKyc(request, userId: userId);
    if (result is Success<SubmitKycModel>) {
      emit(state.copyWith(submitKycState: UIState.success(result.value)));
    }
    if (result is Error) {
      emit(state.copyWith(submitKycState: UIState.error(result.type)));
    }
  }

  // Reset State
  void resetState() {
    emit(
      state.copyWith(
        submitKycState: resetUIState<SubmitKycModel>(state.submitKycState),
        uploadCancelledUIState:
            resetUIState<UploadCancelledCheckedDocumentModel>(
              state.uploadCancelledUIState,
            ),
        uploadTDSDocUIState: resetUIState<UploadTDSDocumentModel>(
          state.uploadTDSDocUIState,
        ),
        uploadPanDocUIState: resetUIState<UploadPANDocumentModel>(
          state.uploadPanDocUIState,
        ),
        uploadTanDocUIState: resetUIState<UploadTANDocumentModel>(
          state.uploadTanDocUIState,
        ),
        uploadGSTDocUIState: resetUIState<UploadGSTDocumentModel>(
          state.uploadGSTDocUIState,
        ),
        aadhaarVerifyOtpState: resetUIState<AadhaarVerifyOtpModel>(
          state.aadhaarVerifyOtpState,
        ),
        aadharVerificationResponse: resetUIState<AadharVerificationResponse>(
          state.aadharVerificationState,
        ),
        kycInitResponse: resetUIState<KycInitResponse>(state.kycInitResponse),

        // stateUIState: resetUIState<List<StateModelList>>(state.stateUIState?.data ?? []),
        // cityUIState: resetUIState<List<CityModel>>(state.cityUIState),
        aadhaarOtpState: resetUIState<AadhaarOtpModel>(state.aadhaarOtpState),
        verifiedPan: false,
        verifiedTan: false,
        verifiedGst: false,
      ),
    );
  }
}
