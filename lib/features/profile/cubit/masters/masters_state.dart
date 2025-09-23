part of 'masters_cubit.dart';


class MastersState {
  final UIState<bool> vehicleVerification;
  final UIState<bool> licenseVerification;
  final UIState<UploadLicenseDocumentModel>? uploadlicenseDocUIState;
  final UIState<CreateDocumentModel>? createDocumentUIState;
  final UIState<DeleteDocumentModel>? deleteDocumentUIState;
  final UIState<EditUserResponse>? editUserUIState;
  final UIState<List<IssueCategoryResponse>>? issueCategoryResponseUIState;
  const MastersState({
    required this.vehicleVerification,
     required this.licenseVerification,
     this.createDocumentUIState,
    this.deleteDocumentUIState,
    this.uploadlicenseDocUIState,
    this.editUserUIState,
    this.issueCategoryResponseUIState,
  });

  factory MastersState.initial() => MastersState(
    vehicleVerification: UIState.initial(),
    licenseVerification: UIState.initial(),
    issueCategoryResponseUIState: UIState.initial(),
  );

  MastersState copyWith({
    UIState<bool>? vehicleVerification,
    UIState<bool>? licenseVerification,
    UIState<CreateDocumentModel>? createDocumentUIState,
    UIState<DeleteDocumentModel>? deleteDocumentUIState,
    UIState<UploadLicenseDocumentModel>? uploadlicenseDocUIState,
    UIState<EditUserResponse>? editUserUIState,
    UIState<List<IssueCategoryResponse>>? issueCategoryResponseUIState
  }) {
    return MastersState(
      editUserUIState: editUserUIState??this.editUserUIState,
      vehicleVerification: vehicleVerification ?? this.vehicleVerification,
      licenseVerification: licenseVerification ?? this.licenseVerification,
      uploadlicenseDocUIState :uploadlicenseDocUIState ?? this.uploadlicenseDocUIState,
      createDocumentUIState: createDocumentUIState ?? this.createDocumentUIState,
      deleteDocumentUIState: deleteDocumentUIState ?? this.deleteDocumentUIState,
      issueCategoryResponseUIState: issueCategoryResponseUIState ?? this.issueCategoryResponseUIState,
    );
  }
}

