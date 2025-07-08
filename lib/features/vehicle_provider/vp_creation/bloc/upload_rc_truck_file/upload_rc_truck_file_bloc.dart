import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/upload_rc_truck_file_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/repository/vp_creation_repository.dart';
import 'package:meta/meta.dart';

part 'upload_rc_truck_file_event.dart';
part 'upload_rc_truck_file_state.dart';

class UploadRcTruckFileBloc extends Bloc<UploadRcTruckFileEvent, UploadRcTruckFileState> {
  final VpCreationRepository _repository;
  UploadRcTruckFileBloc(this._repository) : super(UploadRcTruckFileInitial()) {
    on<UploadRcTruckFileRequested>(uploadTruckRcDocumentFile);
    on<ResetUploadRcDocumentEvent>(resetUIState);
  }

  // Upload Rc truck document api call
  Future<void> uploadTruckRcDocumentFile(UploadRcTruckFileRequested event, Emitter<UploadRcTruckFileState> emit) async {
    emit(UploadRcTruckFileLoading());
    Result result = await _repository.getUploadRcTruckData(event.file,event.userId);
    if (result is Success<UploadRcTruckFileModel>) {

      emit(UploadRcTruckFileSuccess(result.value));
    } else if (result is Error) {
      emit(UploadRcTruckFileError(result.type));
    } else {
      emit(UploadRcTruckFileError(GenericError()));
    }
  }


  // Reset UI State
  void resetUIState(ResetUploadRcDocumentEvent event, Emitter emit) {
    emit(UploadRcTruckFileInitial());
  }



}
