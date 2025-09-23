// fastag_state.dart
part of 'fastag_cubit.dart';

class FastagState extends Equatable {
  final List<List<Map<String, String>>> frontRcDocuments;
  final List<List<Map<String, String>>> backRcDocuments;
  final bool isFrontRcUploaded;
  final bool isBackRcUploaded;
  final UIState<DocumentUploadResponse?> documentUploadUIState;
  final UIState<FleetPincodeVerifyModel?> pincodeVerifyUIState;
  final UIState<FastagListResponse?> fastagListUIState;
  final bool shouldNavigateToBuyFastag;

  const FastagState({
    this.frontRcDocuments = const [[]],
    this.backRcDocuments = const [[]],
    required this.isFrontRcUploaded,
    required this.isBackRcUploaded,
    required this.documentUploadUIState,
    required this.pincodeVerifyUIState,
    required this.fastagListUIState,
    required this.shouldNavigateToBuyFastag,
  });

  factory FastagState.initial() => FastagState(
    frontRcDocuments: [[]],
    backRcDocuments: [[]],
    isFrontRcUploaded: false,
    isBackRcUploaded: false,
    documentUploadUIState: UIState.initial(),
    pincodeVerifyUIState: UIState.initial(),
    fastagListUIState: UIState.initial(),
    shouldNavigateToBuyFastag: false,
  );

  FastagState copyWith({
    final List<List<Map<String, String>>>? frontRcDocuments,
    final List<List<Map<String, String>>>? backRcDocuments,
    bool? isFrontRcUploaded,
    bool? isBackRcUploaded,
    UIState<DocumentUploadResponse?>? documentUploadUIState,
    UIState<FleetPincodeVerifyModel?>? pincodeVerifyUIState,
    UIState<FastagListResponse?>? fastagListUIState,
    bool? shouldNavigateToBuyFastag,
  }) {
    return FastagState(
      frontRcDocuments: frontRcDocuments ?? this.frontRcDocuments,
      backRcDocuments: backRcDocuments ?? this.backRcDocuments,
      isFrontRcUploaded: isFrontRcUploaded ?? this.isFrontRcUploaded,
      isBackRcUploaded: isBackRcUploaded ?? this.isBackRcUploaded,
      documentUploadUIState:
          documentUploadUIState ?? this.documentUploadUIState,
      pincodeVerifyUIState: pincodeVerifyUIState ?? this.pincodeVerifyUIState,
      fastagListUIState: fastagListUIState ?? this.fastagListUIState,
      shouldNavigateToBuyFastag:
          shouldNavigateToBuyFastag ?? this.shouldNavigateToBuyFastag,
    );
  }

  @override
  List<Object?> get props => [
    frontRcDocuments,
    backRcDocuments,
    isFrontRcUploaded,
    isBackRcUploaded,
    documentUploadUIState,
    fastagListUIState,
    shouldNavigateToBuyFastag,
    pincodeVerifyUIState,
  ];
}
