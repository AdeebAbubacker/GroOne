part of 'edit_vehicle_info_bloc.dart';

abstract class EditVehicleInfoEvent extends Equatable {
  const EditVehicleInfoEvent();

  @override
  List<Object?> get props => [];
}

class InitializeEditVehicleInfo extends EditVehicleInfoEvent {
  final GpsCombinedVehicleData? vehicle;
  final List<GpsVehicleExtraInfo>? vehicleExtraInfoList;
  final GpsVehicleExtraInfo? selectedVehicleExtraInfo;

  const InitializeEditVehicleInfo({
    this.vehicle,
    this.vehicleExtraInfoList,
    this.selectedVehicleExtraInfo,
  });

  @override
  List<Object?> get props => [
    vehicle,
    vehicleExtraInfoList,
    selectedVehicleExtraInfo,
  ];
}

class UpdateTextField extends EditVehicleInfoEvent {
  final String field;
  final String value;

  const UpdateTextField({required this.field, required this.value});

  @override
  List<Object> get props => [field, value];
}

class PickDate extends EditVehicleInfoEvent {
  final String field;
  final DateTime date;

  const PickDate({required this.field, required this.date});

  @override
  List<Object> get props => [field, date];
}

class PickDateTime extends EditVehicleInfoEvent {
  final DateTime dateTime;

  const PickDateTime({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class UploadFile extends EditVehicleInfoEvent {
  final File file;
  final String fileName;
  final String field;
  final bool isImage;

  const UploadFile({
    required this.file,
    required this.fileName,
    required this.field,
    this.isImage = false,
  });

  @override
  List<Object> get props => [file, fileName, field, isImage];
}

class ViewFile extends EditVehicleInfoEvent {
  final String url;

  const ViewFile({required this.url});

  @override
  List<Object> get props => [url];
}

class ApplyChanges extends EditVehicleInfoEvent {
  const ApplyChanges();
}

class UpdateBrand extends EditVehicleInfoEvent {
  final String? brand;

  const UpdateBrand({this.brand});

  @override
  List<Object?> get props => [brand];
}

class UpdateModel extends EditVehicleInfoEvent {
  final String? model;

  const UpdateModel({this.model});

  @override
  List<Object?> get props => [model];
}
