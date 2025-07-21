part of 'driver_load_details_cubit.dart';



class DriverLoadDetailsState extends Equatable {
  final UIState<DriverLoadDetailsModel>? lpLoadById;
  final UIState<UploadDamageFileModel>? uploadDamageUIState;



  const DriverLoadDetailsState({
    this.lpLoadById,
    this.uploadDamageUIState,

  });

  DriverLoadDetailsState copyWith({
  UIState<DriverLoadDetailsModel>? lpLoadById,
  UIState<UploadDamageFileModel>? uploadDamageUIState,
}) {
  return DriverLoadDetailsState(
    lpLoadById: lpLoadById ?? this.lpLoadById,
    uploadDamageUIState: uploadDamageUIState ?? this.uploadDamageUIState,
  );
}


  @override
  List<Object?> get props => [
    lpLoadById,
    uploadDamageUIState,
  ];
}
