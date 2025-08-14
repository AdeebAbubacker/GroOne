// fastag_state.dart
part of 'fastag_cubit.dart';

class FastagState extends Equatable {
  final List frontRcDocuments;
  final List backRcDocuments;
  final bool isFrontRcUploaded;
  final bool isBackRcUploaded;
  final UIState<DocumentUploadResponse?> documentUploadUIState;
  final UIState<FastagListResponse?> fastagListUIState;
  final bool shouldNavigateToBuyFastag;


  const FastagState({
    required this.frontRcDocuments,
    required this.backRcDocuments,
    required this.isFrontRcUploaded,
    required this.isBackRcUploaded,
    required this.documentUploadUIState,
    required this.fastagListUIState,
    required this.shouldNavigateToBuyFastag,
  });

  factory FastagState.initial() => FastagState(
    frontRcDocuments: [],
    backRcDocuments: [],
    isFrontRcUploaded: false,
    isBackRcUploaded: false,
    documentUploadUIState: UIState.initial(),
    fastagListUIState: UIState.initial(),
    shouldNavigateToBuyFastag: false,
  );

  FastagState copyWith({
    List? frontRcDocuments,
    List? backRcDocuments,
    bool? isFrontRcUploaded,
    bool? isBackRcUploaded,
    UIState<DocumentUploadResponse?>? documentUploadUIState,
    UIState<FastagListResponse?>? fastagListUIState,
    bool? shouldNavigateToBuyFastag,
  }) {
    return FastagState(
      frontRcDocuments: frontRcDocuments ?? this.frontRcDocuments,
      backRcDocuments: backRcDocuments ?? this.backRcDocuments,
      isFrontRcUploaded: isFrontRcUploaded ?? this.isFrontRcUploaded,
      isBackRcUploaded: isBackRcUploaded ?? this.isBackRcUploaded,
      documentUploadUIState: documentUploadUIState ?? this.documentUploadUIState,
      fastagListUIState: fastagListUIState ?? this.fastagListUIState,
      shouldNavigateToBuyFastag: shouldNavigateToBuyFastag ?? this.shouldNavigateToBuyFastag,
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
  ];
}
