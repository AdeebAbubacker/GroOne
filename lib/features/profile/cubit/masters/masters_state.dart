part of 'masters_cubit.dart';


class MastersState {
  final UIState<bool> vehicleVerification;
  final UIState<bool> licenseVerification;
  final UIState<UploadLicenseDocumentModel>? uploadlicenseDocUIState;
  final UIState<CreateDocumentModel>? createDocumentUIState;
  final UIState<DeleteDocumentModel>? deleteDocumentUIState;
  const MastersState({
    required this.vehicleVerification,
     required this.licenseVerification,
     this.createDocumentUIState,
    this.deleteDocumentUIState,
    this.uploadlicenseDocUIState,
  });

  factory MastersState.initial() => MastersState(
    vehicleVerification: UIState.initial(),
    licenseVerification: UIState.initial(),
  );

  MastersState copyWith({
    UIState<bool>? vehicleVerification,
    UIState<bool>? licenseVerification,
    UIState<CreateDocumentModel>? createDocumentUIState,
    UIState<DeleteDocumentModel>? deleteDocumentUIState,
    UIState<UploadLicenseDocumentModel>? uploadlicenseDocUIState,
  }) {
    return MastersState(
      vehicleVerification: vehicleVerification ?? this.vehicleVerification,
      licenseVerification: licenseVerification ?? this.licenseVerification,
      uploadlicenseDocUIState :uploadlicenseDocUIState ?? this.uploadlicenseDocUIState,
      createDocumentUIState: createDocumentUIState ?? this.createDocumentUIState,
      deleteDocumentUIState: deleteDocumentUIState ?? this.deleteDocumentUIState,
    );
  }
}

