part of 'edit_vehicle_info_bloc.dart';

abstract class EditVehicleInfoState extends Equatable {
  const EditVehicleInfoState();

  @override
  List<Object?> get props => [];
}

class EditVehicleInfoInitial extends EditVehicleInfoState {
  const EditVehicleInfoInitial();
}

class EditVehicleInfoLoaded extends EditVehicleInfoState {
  final GpsCombinedVehicleData? vehicle;
  final List<GpsVehicleExtraInfo>? vehicleExtraInfoList;
  final GpsVehicleExtraInfo? selectedVehicleExtraInfo;
  final String? vehicleNumber;
  final String? plateNumber;
  final String? chassisNumber;
  final String? registrationCertificate;
  final String? insuranceExpDate;
  final String? insuranceImage;
  final String? pollutionExpDate;
  final String? pollutionImage;
  final String? fitnessExpDate;
  final String? fitnessCertificate;
  final DateTime? dateAdded;
  final String? selectedBrand;
  final String? selectedModel;
  final bool isLoading;
  final bool isUploading;
  final double uploadProgress;
  final bool isSuccess;
  final String? error;

  const EditVehicleInfoLoaded({
    this.vehicle,
    this.vehicleExtraInfoList,
    this.selectedVehicleExtraInfo,
    this.vehicleNumber,
    this.plateNumber,
    this.chassisNumber,
    this.registrationCertificate,
    this.insuranceExpDate,
    this.insuranceImage,
    this.pollutionExpDate,
    this.pollutionImage,
    this.fitnessExpDate,
    this.fitnessCertificate,
    this.dateAdded,
    this.selectedBrand,
    this.selectedModel,
    this.isLoading = false,
    this.isUploading = false,
    this.uploadProgress = 0.0,
    this.isSuccess = false,
    this.error,
  });

  EditVehicleInfoLoaded copyWith({
    GpsCombinedVehicleData? vehicle,
    List<GpsVehicleExtraInfo>? vehicleExtraInfoList,
    GpsVehicleExtraInfo? selectedVehicleExtraInfo,
    String? vehicleNumber,
    String? plateNumber,
    String? chassisNumber,
    String? registrationCertificate,
    String? insuranceExpDate,
    String? insuranceImage,
    String? pollutionExpDate,
    String? pollutionImage,
    String? fitnessExpDate,
    String? fitnessCertificate,
    DateTime? dateAdded,
    String? selectedBrand,
    String? selectedModel,
    bool? isLoading,
    bool? isUploading,
    double? uploadProgress,
    bool? isSuccess,
    String? error,
  }) {
    return EditVehicleInfoLoaded(
      vehicle: vehicle ?? this.vehicle,
      vehicleExtraInfoList: vehicleExtraInfoList ?? this.vehicleExtraInfoList,
      selectedVehicleExtraInfo:
          selectedVehicleExtraInfo ?? this.selectedVehicleExtraInfo,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      plateNumber: plateNumber ?? this.plateNumber,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      registrationCertificate:
          registrationCertificate ?? this.registrationCertificate,
      insuranceExpDate: insuranceExpDate ?? this.insuranceExpDate,
      insuranceImage: insuranceImage ?? this.insuranceImage,
      pollutionExpDate: pollutionExpDate ?? this.pollutionExpDate,
      pollutionImage: pollutionImage ?? this.pollutionImage,
      fitnessExpDate: fitnessExpDate ?? this.fitnessExpDate,
      fitnessCertificate: fitnessCertificate ?? this.fitnessCertificate,
      dateAdded: dateAdded ?? this.dateAdded,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedModel ?? this.selectedModel,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    vehicle,
    vehicleExtraInfoList,
    selectedVehicleExtraInfo,
    vehicleNumber,
    plateNumber,
    chassisNumber,
    registrationCertificate,
    insuranceExpDate,
    insuranceImage,
    pollutionExpDate,
    pollutionImage,
    fitnessExpDate,
    fitnessCertificate,
    dateAdded,
    selectedBrand,
    selectedModel,
    isLoading,
    isUploading,
    uploadProgress,
    isSuccess,
    error,
  ];
}
