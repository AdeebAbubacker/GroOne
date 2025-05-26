part of 'upload_rc_truck_file_bloc.dart';

@immutable
sealed class UploadRcTruckFileState {}

final class UploadRcTruckFileInitial extends UploadRcTruckFileState {}

// Upload Rc Truck Document State
class UploadRcTruckFileLoading extends UploadRcTruckFileState {}

class UploadRcTruckFileSuccess extends UploadRcTruckFileState {
  final UploadRcTruckFileModel fileModel;
  UploadRcTruckFileSuccess(this.fileModel);
}

class UploadRcTruckFileError extends UploadRcTruckFileState {
  final ErrorType errorType;
  UploadRcTruckFileError(this.errorType);
}
