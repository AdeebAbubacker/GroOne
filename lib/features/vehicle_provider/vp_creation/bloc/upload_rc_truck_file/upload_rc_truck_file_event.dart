part of 'upload_rc_truck_file_bloc.dart';

@immutable
sealed class UploadRcTruckFileEvent {}

class ResetUploadRcDocumentEvent extends UploadRcTruckFileEvent {}

// Upload Rc Truck Event
class UploadRcTruckFileRequested extends UploadRcTruckFileEvent {
  final File file;
  UploadRcTruckFileRequested({required this.file});
}
