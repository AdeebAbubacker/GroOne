import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/get_vehicle_extra_info_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_vehicle_extra_info_model.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../../../service/firebase_secondary_service.dart';

part 'edit_vehicle_info_event.dart';
part 'edit_vehicle_info_state.dart';

class EditVehicleInfoBloc
    extends Bloc<EditVehicleInfoEvent, EditVehicleInfoState> {
  final FirebaseFirestore secondaryFirestore = FirebaseFirestore.instanceFor(
    app: FirebaseService.secondaryApp,
  );
  final FirebaseStorage secondaryStorage = FirebaseStorage.instanceFor(
    app: FirebaseService.secondaryApp,
  );

  EditVehicleInfoBloc() : super(const EditVehicleInfoLoaded()) {
    on<InitializeEditVehicleInfo>(_onInitializeEditVehicleInfo);
    on<UpdateTextField>(_onUpdateTextField);
    on<PickDate>(_onPickDate);
    on<PickDateTime>(_onPickDateTime);
    on<UploadFile>(_onUploadFile);
    on<ViewFile>(_onViewFile);
    on<ApplyChanges>(_onApplyChanges);
    on<UpdateBrand>(_onUpdateBrand);
    on<UpdateModel>(_onUpdateModel);
  }

  void _onInitializeEditVehicleInfo(
    InitializeEditVehicleInfo event,
    Emitter<EditVehicleInfoState> emit,
  ) {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;

      print('🔍 Initializing EditVehicleInfo with:');
      print('🔍 Vehicle: ${event.vehicle?.vehicleNumber}');
      print(
        '🔍 SelectedVehicleExtraInfo: ${event.selectedVehicleExtraInfo?.vehicleRegistrationNumber}',
      );

      // Extract data from vehicle and extra info
      String? vehicleNumber = event.vehicle?.vehicleNumber;
      String? plateNumber;
      String? chassisNumber;
      String? selectedBrand;
      String? selectedModel;
      DateTime? dateAdded;
      String? insuranceExpDate;
      String? pollutionExpDate;
      String? fitnessExpDate;
      String? registrationCertificate;
      String? insuranceImage;
      String? pollutionImage;
      String? fitnessCertificate;

      // Get data from extra info if available
      if (event.selectedVehicleExtraInfo != null) {
        final extraInfo = event.selectedVehicleExtraInfo!;
        print('🔍 ExtraInfo data:');
        print(
          '🔍 - vehicleRegistrationNumber: ${extraInfo.vehicleRegistrationNumber}',
        );
        print('🔍 - plateNumber: ${extraInfo.plateNumber}');
        print('🔍 - chasisNumber: ${extraInfo.chasisNumber}');
        print('🔍 - vehicleBrand: ${extraInfo.vehicleBrand}');
        print('🔍 - vehicleModel: ${extraInfo.vehicleModel}');
        print('🔍 - insuranceExpiryDate: ${extraInfo.insuranceExpiryDate}');
        print('🔍 - pollutionExpiryDate: ${extraInfo.pollutionExpiryDate}');
        print('🔍 - fitnessExpiryDate: ${extraInfo.fitnessExpiryDate}');

        vehicleNumber =
            extraInfo.vehicleRegistrationNumber?.toString() ?? vehicleNumber;
        plateNumber = extraInfo.plateNumber?.toString();
        chassisNumber = extraInfo.chasisNumber?.toString();
        selectedBrand = extraInfo.vehicleBrand?.toString();
        selectedModel = extraInfo.vehicleModel?.toString();

        print('🔍 Extracted brand: "$selectedBrand"');
        print('🔍 Extracted model: "$selectedModel"');

        insuranceExpDate = extraInfo.insuranceExpiryDate?.toString();
        pollutionExpDate = extraInfo.pollutionExpiryDate?.toString();
        fitnessExpDate = extraInfo.fitnessExpiryDate?.toString();
        registrationCertificate =
            extraInfo.vehicleRegCertificateUrl?.toString();
        insuranceImage = extraInfo.insuranceUpload?.toString();
        pollutionImage = extraInfo.pollutionCertificateUpload?.toString();
        fitnessCertificate = extraInfo.fitnessCertificateUrl?.toString();

        // Parse dateAdded if available
        if (extraInfo.dateAdded != null) {
          try {
            dateAdded = DateTime.parse(extraInfo.dateAdded.toString());
            print('🔍 Parsed dateAdded: $dateAdded');
          } catch (e) {
            print(
              '🔍 Failed to parse extraInfo.dateAdded: ${extraInfo.dateAdded}',
            );
            // If parsing fails, try to parse from vehicle data
            if (event.vehicle?.dateAdded != null) {
              try {
                dateAdded = DateTime.parse(event.vehicle!.dateAdded!);
                print('🔍 Parsed vehicle.dateAdded: $dateAdded');
              } catch (e) {
                print(
                  '🔍 Failed to parse vehicle.dateAdded: ${event.vehicle!.dateAdded}',
                );
                // If both fail, use current date
                dateAdded = DateTime.now();
              }
            }
          }
        } else if (event.vehicle?.dateAdded != null) {
          try {
            dateAdded = DateTime.parse(event.vehicle!.dateAdded!);
            print('🔍 Parsed vehicle.dateAdded: $dateAdded');
          } catch (e) {
            print(
              '🔍 Failed to parse vehicle.dateAdded: ${event.vehicle!.dateAdded}',
            );
            dateAdded = DateTime.now();
          }
        }

        // Parse expiry dates if they are in string format
        if (insuranceExpDate != null && insuranceExpDate.isNotEmpty) {
          try {
            // Try to parse as ISO date first
            DateTime.parse(insuranceExpDate);
          } catch (e) {
            // If it's not a valid ISO date, keep as is (might be formatted)
            // The UI will handle the display formatting
          }
        }

        if (pollutionExpDate != null && pollutionExpDate.isNotEmpty) {
          try {
            DateTime.parse(pollutionExpDate);
          } catch (e) {
            // Keep as is for UI formatting
          }
        }

        if (fitnessExpDate != null && fitnessExpDate.isNotEmpty) {
          try {
            DateTime.parse(fitnessExpDate);
          } catch (e) {
            // Keep as is for UI formatting
          }
        }
      }

      print('🔍 Final state values:');
      print('🔍 - vehicleNumber: $vehicleNumber');
      print('🔍 - plateNumber: $plateNumber');
      print('🔍 - chassisNumber: $chassisNumber');
      print('🔍 - selectedBrand: $selectedBrand');
      print('🔍 - selectedModel: $selectedModel');
      print('🔍 - dateAdded: $dateAdded');
      print('🔍 - insuranceExpDate: $insuranceExpDate');
      print('🔍 - pollutionExpDate: $pollutionExpDate');
      print('🔍 - fitnessExpDate: $fitnessExpDate');

      emit(
        currentState.copyWith(
          vehicle: event.vehicle,
          vehicleExtraInfoList: event.vehicleExtraInfoList,
          selectedVehicleExtraInfo: event.selectedVehicleExtraInfo,
          vehicleNumber: vehicleNumber,
          plateNumber: plateNumber,
          chassisNumber: chassisNumber,
          selectedBrand: selectedBrand,
          selectedModel: selectedModel,
          dateAdded: dateAdded,
          insuranceExpDate: insuranceExpDate,
          pollutionExpDate: pollutionExpDate,
          fitnessExpDate: fitnessExpDate,
          registrationCertificate: registrationCertificate,
          insuranceImage: insuranceImage,
          pollutionImage: pollutionImage,
          fitnessCertificate: fitnessCertificate,
          isLoading: false,
        ),
      );
    }
  }

  void _onUpdateTextField(
    UpdateTextField event,
    Emitter<EditVehicleInfoState> emit,
  ) {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(
        currentState.copyWith(
          vehicleNumber:
              event.field == 'vehicleNumber'
                  ? event.value
                  : currentState.vehicleNumber,
          plateNumber:
              event.field == 'plateNumber'
                  ? event.value
                  : currentState.plateNumber,
          chassisNumber:
              event.field == 'chassisNumber'
                  ? event.value
                  : currentState.chassisNumber,
          registrationCertificate:
              event.field == 'registrationCertificate'
                  ? event.value
                  : currentState.registrationCertificate,
          insuranceExpDate:
              event.field == 'insuranceExpDate'
                  ? event.value
                  : currentState.insuranceExpDate,
          insuranceImage:
              event.field == 'insuranceImage'
                  ? event.value
                  : currentState.insuranceImage,
          pollutionExpDate:
              event.field == 'pollutionExpDate'
                  ? event.value
                  : currentState.pollutionExpDate,
          pollutionImage:
              event.field == 'pollutionImage'
                  ? event.value
                  : currentState.pollutionImage,
          fitnessExpDate:
              event.field == 'fitnessExpDate'
                  ? event.value
                  : currentState.fitnessExpDate,
          fitnessCertificate:
              event.field == 'fitnessCertificate'
                  ? event.value
                  : currentState.fitnessCertificate,
        ),
      );
    }
  }

  void _onPickDate(PickDate event, Emitter<EditVehicleInfoState> emit) {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(
        currentState.copyWith(
          insuranceExpDate:
              event.field == 'insuranceExpDate'
                  ? event.date.toString()
                  : currentState.insuranceExpDate,
          pollutionExpDate:
              event.field == 'pollutionExpDate'
                  ? event.date.toString()
                  : currentState.pollutionExpDate,
          fitnessExpDate:
              event.field == 'fitnessExpDate'
                  ? event.date.toString()
                  : currentState.fitnessExpDate,
        ),
      );
    }
  }

  void _onPickDateTime(PickDateTime event, Emitter<EditVehicleInfoState> emit) {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(currentState.copyWith(dateAdded: event.dateTime));
    }
  }

  Future<void> _onUploadFile(
    UploadFile event,
    Emitter<EditVehicleInfoState> emit,
  ) async {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(currentState.copyWith(isUploading: true, uploadProgress: 0.0));

      try {
        File fileToUpload = event.file;

        if (event.isImage) {
          fileToUpload = await _compressImage(event.file);
        }

        final uniqueFileName = event.fileName;
        final storageRef = secondaryStorage.ref().child(
          'uploads/$uniqueFileName',
        );
        final uploadTask = storageRef.putFile(fileToUpload);

        uploadTask.snapshotEvents.listen((snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          if (state is EditVehicleInfoLoaded) {
            final currentState = state as EditVehicleInfoLoaded;
            emit(currentState.copyWith(uploadProgress: progress));
          }
        });

        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        if (event.isImage && fileToUpload != event.file) {
          try {
            await fileToUpload.delete();
          } catch (e) {
            // Ignore deletion errors
          }
        }

        // Update the appropriate field based on the controller
        String? fieldKey;
        if (event.field == 'registrationCertificate') {
          fieldKey = 'registration_certificate_url';
        } else if (event.field == 'insuranceImage') {
          fieldKey = 'insurance_upload';
        } else if (event.field == 'pollutionImage') {
          fieldKey = 'pollution_certificate_upload';
        } else if (event.field == 'fitnessCertificate') {
          fieldKey = 'fitness_certificate_url';
        }

        if (fieldKey != null) {
          Map<String, String> apiData = {fieldKey: downloadUrl};

          final cubit = locator<GpsVehicleExtraInfoCubit>();
          await cubit.updateDeviceExtraInfo(
            deviceId:
                currentState.selectedVehicleExtraInfo?.id?.toString() ?? '',
            data: apiData,
          );
        }

        emit(
          currentState.copyWith(
            isUploading: false,
            uploadProgress: 1.0,
            registrationCertificate:
                event.field == 'registrationCertificate'
                    ? downloadUrl
                    : currentState.registrationCertificate,
            insuranceImage:
                event.field == 'insuranceImage'
                    ? downloadUrl
                    : currentState.insuranceImage,
            pollutionImage:
                event.field == 'pollutionImage'
                    ? downloadUrl
                    : currentState.pollutionImage,
            fitnessCertificate:
                event.field == 'fitnessCertificate'
                    ? downloadUrl
                    : currentState.fitnessCertificate,
          ),
        );
      } catch (e) {
        emit(
          currentState.copyWith(
            isUploading: false,
            uploadProgress: 0.0,
            error: 'Failed to upload file: $e',
          ),
        );
      }
    }
  }

  void _onViewFile(ViewFile event, Emitter<EditVehicleInfoState> emit) {
    // This event is handled in the UI layer
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(currentState.copyWith());
    }
  }

  Future<void> _onApplyChanges(
    ApplyChanges event,
    Emitter<EditVehicleInfoState> emit,
  ) async {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(currentState.copyWith(isLoading: true));

      try {
        Map<String, dynamic> apiPayload = {
          "vehicle_registration_number": currentState.vehicleNumber?.trim(),
          "plate_number": currentState.plateNumber?.trim(),
          "chasis_number": currentState.chassisNumber?.trim(),
          "vehicle_brand": currentState.selectedBrand?.trim(),
          "vehicle_model": currentState.selectedModel?.trim(),
          "date_added": currentState.dateAdded?.toString(),
          "insurance_expiry_date": currentState.insuranceExpDate?.toString(),
          "pollution_expiry_date": currentState.pollutionExpDate?.toString(),
          "fitness_expiry_date": currentState.fitnessExpDate?.toString(),
        };

        // Add file URLs if they exist
        if (currentState.registrationCertificate?.isNotEmpty == true) {
          apiPayload["registration_certificate_url"] =
              currentState.registrationCertificate;
        }
        if (currentState.insuranceImage?.isNotEmpty == true) {
          apiPayload["insurance_upload"] = currentState.insuranceImage;
        }
        if (currentState.pollutionImage?.isNotEmpty == true) {
          apiPayload["pollution_certificate_upload"] =
              currentState.pollutionImage;
        }
        if (currentState.fitnessCertificate?.isNotEmpty == true) {
          apiPayload["fitness_certificate_url"] =
              currentState.fitnessCertificate;
        }

        Map<String, String> apiData = {};
        apiPayload.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            apiData[key] = value.toString();
          }
        });

        final cubit = locator<GpsVehicleExtraInfoCubit>();
        await cubit.updateDeviceExtraInfo(
          deviceId: currentState.selectedVehicleExtraInfo?.id?.toString() ?? '',
          data: apiData,
        );

        emit(currentState.copyWith(isLoading: false, isSuccess: true));
      } catch (e) {
        emit(
          currentState.copyWith(
            isLoading: false,
            error: 'Failed to update vehicle information: $e',
          ),
        );
      }
    }
  }

  void _onUpdateBrand(UpdateBrand event, Emitter<EditVehicleInfoState> emit) {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(currentState.copyWith(selectedBrand: event.brand));
    }
  }

  void _onUpdateModel(UpdateModel event, Emitter<EditVehicleInfoState> emit) {
    if (state is EditVehicleInfoLoaded) {
      final currentState = state as EditVehicleInfoLoaded;
      emit(currentState.copyWith(selectedModel: event.model));
    }
  }

  Future<File> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      img.Image resizedImage = image;
      if (image.width > 1024 || image.height > 1024) {
        resizedImage = img.copyResize(
          image,
          width: 1024,
          height: 1024,
          interpolation: img.Interpolation.linear,
        );
      }

      final compressedBytes = img.encodeJpg(resizedImage, quality: 70);

      final tempDir = await getTemporaryDirectory();
      final compressedFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      return file;
    }
  }
}
