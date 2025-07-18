import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/cubit/edit_vehicle_info_bloc/edit_vehicle_info_bloc.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_vehicle_extra_info_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_button_style.dart';
import '../../../../utils/common_widgets.dart';

class EditVehicleInfoScreen extends StatelessWidget {
  final Map<String, dynamic>? vehicleData;

  const EditVehicleInfoScreen({super.key, this.vehicleData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = EditVehicleInfoBloc();
        _initializeData(bloc);
        return bloc;
      },
      child: const EditVehicleInfoView(),
    );
  }

  void _initializeData(EditVehicleInfoBloc bloc) {
    if (vehicleData != null) {
      final vehicle = vehicleData!['vehicle'] as GpsCombinedVehicleData?;
      final extraInfoState =
          vehicleData!['vehicleExtraInfo']
              as UIState<List<GpsVehicleExtraInfo>>?;

      GpsVehicleExtraInfo? selectedVehicleExtraInfo;
      List<GpsVehicleExtraInfo>? vehicleExtraInfoList;

      if (extraInfoState != null &&
          extraInfoState.status == Status.SUCCESS &&
          extraInfoState.data != null) {
        vehicleExtraInfoList = extraInfoState.data;
        if (vehicle != null && vehicleExtraInfoList != null) {
          selectedVehicleExtraInfo = vehicleExtraInfoList.firstWhere(
            (extraInfo) =>
                extraInfo.deviceId.toString() == vehicle.deviceId.toString(),
            orElse: () => vehicleExtraInfoList!.first,
          );
        }
      }

      bloc.add(
        InitializeEditVehicleInfo(
          vehicle: vehicle,
          vehicleExtraInfoList: vehicleExtraInfoList,
          selectedVehicleExtraInfo: selectedVehicleExtraInfo,
        ),
      );
    }
  }
}

class EditVehicleInfoView extends StatelessWidget {
  const EditVehicleInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Vehicle Info'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<EditVehicleInfoBloc, EditVehicleInfoState>(
        listener: (context, state) {
          if (state is EditVehicleInfoLoaded) {
            if (state.isSuccess) {
              _showSuccessSnackBar(
                context,
                'Vehicle information updated successfully!',
              );
              Navigator.pop(context);
            }
            if (state.error != null) {
              _showErrorSnackBar(context, state.error!);
            }
          }
        },
        builder: (context, state) {
          if (state is EditVehicleInfoLoaded) {
            return Padding(
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubscriptionSection(context, state),
                      _buildFormSection(context, state),
                    ],
                  ),
                ),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSubscriptionSection(
    BuildContext context,
    EditVehicleInfoLoaded state,
  ) {
    String subscriptionExpiryDate = 'N/A'; // Default value

    if (state.selectedVehicleExtraInfo?.subscriptionExpiryDate != null) {
      try {
        final DateTime parsedDate = DateTime.parse(
          state.selectedVehicleExtraInfo!.subscriptionExpiryDate!,
        );
        subscriptionExpiryDate = DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        subscriptionExpiryDate = 'Invalid date'; // Or keep 'N/A'
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Subscription Expiry Date',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subscriptionExpiryDate,
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: Text(
                'Renew / Extend Subscription',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        AppButton(
          onPressed: () => Navigator.pop(context),
          title: context.appText.cancel,
          style: AppButtonStyle.outline,
        ).expand(),
        20.width,
        AppButton(
          onPressed: () {
            context.read<EditVehicleInfoBloc>().add(ApplyChanges());
          },
          title: context.appText.apply,
          style: AppButtonStyle.primary,
        ).expand(),
      ],
    );
  }

  Widget _buildFormSection(BuildContext context, EditVehicleInfoLoaded state) {
    final List<String> brands = [
      "Aston Martin",
      "Audi",
      "BMW",
      "Bentley",
      "Bugatti",
      "Datsun",
      "DC",
      "Ferrari",
      "Fiat",
      "Force",
      "Ford",
      "Honda",
      "Hyundai",
      "ICML",
      "Isuzu",
      "Jaguar",
      "Jeep",
      "Lamborghini",
      "Land Rover",
      "Lexus",
      "Mahindra",
      "Maruti",
      "Maserati",
      "Mercedes-Benz",
      "Mini",
      "Mitsubishi",
      "Nissan",
      "Porsche",
      "Premier",
      "Renault",
      "Rolls-Royce",
      "Skoda",
      "Tata",
      "Toyota",
      "Volkswagen",
      "Volvo",
    ];

    final List<String> models = [
      "DB11",
      "Rapide",
      "Vanquish",
      "Vantage",
      "A3",
      "A3 cabriolet",
      "A4",
      "A5",
      "A6",
      "A8",
      "Q3",
      "Q5",
      "Q7",
      "R8",
      "RS5",
      "RS6 Avant",
      "RS7",
      "S5",
      "TT",
      "3 Series",
      "5 Series",
      "6 Series",
      "7 Series",
      "M Series",
      "X1",
      "X3",
      "X5",
      "X6",
      "Z4",
      "i8",
      "Rolls-Royce",
      "Skoda",
      "Tata",
      "Toyota",
      "Volkswagen",
      "Volvo",
      "Bentayga",
      "Continental",
      "Flying Spur",
      "Mulsanne",
      "Veyron",
      "GO",
      "GO Plus",
      "redi-GO",
      "Avanti",
      "458 Speciale",
      "488",
      "812 Superfast",
      "California T",
      "FF",
      "GTC4Lusso",
      "500",
      "Abarth Avventura",
      "Abarth Punto",
      "Avventura",
      "Avventura Urban Cross",
      "Linea",
      "Linea Classic",
      "Punto EVO",
      "Punto",
      "Gurkha",
      "One",
      "Aspire",
      "EcoSport",
      "Endeavour",
      "Figo",
      "Freestyle",
      "Mustang",
      "Accord",
      "Amaze",
      "BRV",
      "Brio",
      "CR-V",
      "City",
      "Jazz",
      "Mobilio",
      "WRV",
      "Creta",
      "EON",
      "Elantra",
      "Elite i20",
      "Grand i10",
      "Tucson",
      "Verna",
      "Xcent",
      "Xcent 2016-2017",
      "i10",
      "120",
      "i20 Active",
      "Extreme",
      "ISUZU D-MAX V-Cross",
      "ISUZU MUX",
      "F Type",
      "F-Pace",
      "XE",
      "XF",
      "XJ",
      "Compass",
      "Grand Cherokee",
      "Wrangler Unlimited",
      "Aventador",
      "Huracan",
      "Urus",
      "Discovery",
      "Discovery Sport",
      "Range Rover",
      "Range Rover Evoque",
      "Range Rover Sport",
      "Range Rover Velar",
      "ES",
      "LS",
      "LX",
      "NX",
      "RX",
      "Bolero",
      "E Verito",
      "KUV100",
      "KUV100 NXT",
      "NuvoSport",
      "Scorpio",
      "Supro",
      "TUV 300",
      "Thar",
      "Verito",
      "Verito Vibe",
      "XUV500",
      "Xylo",
      "e2oPlus",
      "Alto 800",
      "Alto K10",
      "Baleno",
      "Baleno RS",
      "Celerio",
      "Celerio X",
      "Ciaz",
      "Ciaz S",
      "Dzire",
      "Eeco",
      "Ertiga",
      "Gypsy",
      "Ignis",
      "Omni",
      "S-Cross",
      "Swift",
      "Vitara Brezza",
      "Wagon R",
      "Ghibli",
      "Gran Cabrio",
      "Gran Turismo",
      "Levante",
      "Quattroporte",
      "A-Class",
      "AMG GT",
      "B-Class",
      "C-Class",
      "CLA",
      "E-Class",
      "G-Class",
      "GLA-45 AMG",
      "GLA Class",
      "GLC",
      "GLE",
      "GLS",
      "S-Class",
      "S-Class Cabriolet",
      "SLC",
      "Clubman",
      "Cooper 3 DOOR",
      "Cooper 5 DOOR",
      "Cooper Convertible",
      "Countryman",
      "Pajero Sport",
      "GT-R",
      "Micra",
      "Micra Active",
      "Sunny",
      "Terrano",
      "718",
      "911",
      "Cayenne",
      "Macan",
      "Panamera",
      "Rio",
      "Captur",
      "Duster",
      "KWID",
      "Lodgy",
      "Rolls Royce Dawn",
      "Rolls Royce Ghost",
      "Rolls Royce Phantom",
      "Rolls Royce Wraith",
      "Kodiaq",
      "Octavia",
      "Rapid",
      "Superb",
      "Bolt",
      "Hexa",
      "Indica eV2",
      "Indigo eCS",
      "Nano",
      "Nexon",
      "Safari",
      "Safari Storme",
      "Sumo",
      "Tiago",
      "Tigor",
      "Zest",
      "Camry",
      "Corolla Altis",
      "Etios Cross",
      "Etios Liva",
      "Fortuner",
      "Innova Crysta",
      "Land Cruiser",
      "Land Cruiser Prado",
      "Platinum Etios",
      "Prius",
      "Yaris",
      "Ameo",
      "GTI",
      "Passat",
      "Polo",
      "Tiguan",
      "Vento",
      "S60",
      "S60 Cross Country",
      "S90",
      "V40",
      "V40 Cross Country",
      "V90 Cross Country",
      "XC60",
      "XC90",
    ];

    return Column(
      children: [
        SizedBox(height: AppConstants.defaultPadding),
        AppTextField(
          controller: TextEditingController(text: state.vehicleNumber),
          labelText: 'Vehicle Number',
          onChanged: (value) {
            context.read<EditVehicleInfoBloc>().add(
              UpdateTextField(field: 'vehicleNumber', value: value),
            );
          },
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: TextEditingController(text: state.plateNumber),
          labelText: 'Plate Number',
          onChanged: (value) {
            context.read<EditVehicleInfoBloc>().add(
              UpdateTextField(field: 'plateNumber', value: value),
            );
          },
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: TextEditingController(text: state.chassisNumber),
          labelText: 'Chassis Number',
          onChanged: (value) {
            context.read<EditVehicleInfoBloc>().add(
              UpdateTextField(field: 'chassisNumber', value: value),
            );
          },
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppDropdown(
          dropdownValue: state.selectedBrand,
          dropDownList: _createDropdownItems(brands),
          labelText: 'Brand',
          onChanged: (String? value) {
            context.read<EditVehicleInfoBloc>().add(UpdateBrand(brand: value));
          },
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppDropdown(
          dropdownValue: state.selectedModel,
          dropDownList: _createDropdownItems(models),
          labelText: 'Model',
          onChanged: (String? value) {
            context.read<EditVehicleInfoBloc>().add(UpdateModel(model: value));
          },
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: TextEditingController(text: state.dateAdded?.toString()),
          labelText: 'Date Added',
          readOnly: true,
          onTextFieldTap: () => _pickDateTime(context),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: TextEditingController(text: state.insuranceExpDate),
          labelText: 'Insurance Exp Date',
          readOnly: true,
          onTextFieldTap: () => _pickDate(context, 'insuranceExpDate'),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: TextEditingController(text: state.pollutionExpDate),
          labelText: 'Pollution Exp Date',
          readOnly: true,
          onTextFieldTap: () => _pickDate(context, 'pollutionExpDate'),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: TextEditingController(text: state.fitnessExpDate),
          labelText: 'Fitness Expiry Date',
          readOnly: true,
          onTextFieldTap: () => _pickDate(context, 'fitnessExpDate'),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.largePadding),
        _buildActionButtons(context),
        SizedBox(height: AppConstants.smallPadding),
        Divider(height: 50),
        fileUploadRow(
          url: state.registrationCertificate,
          label: 'Registration Certificate',
          onView: () => _onViewFile(context, state.registrationCertificate),
          onUpload: () => _onUploadFile(context, 'registrationCertificate'),
        ),
        SizedBox(height: AppConstants.smallPadding),
        fileUploadRow(
          url: state.insuranceImage,
          label: 'Insurance Image',
          onView: () => _onViewFile(context, state.insuranceImage),
          onUpload:
              () => _onUploadFile(context, 'insuranceImage', imageOnly: true),
        ),
        SizedBox(height: AppConstants.smallPadding),
        fileUploadRow(
          url: state.pollutionImage,
          label: 'Pollution Image',
          onView: () => _onViewFile(context, state.pollutionImage),
          onUpload:
              () => _onUploadFile(context, 'pollutionImage', imageOnly: true),
        ),
        SizedBox(height: AppConstants.smallPadding),
        fileUploadRow(
          url: state.fitnessCertificate,
          label: 'Fitness Certificate Image',
          onView: () => _onViewFile(context, state.fitnessCertificate),
          onUpload:
              () =>
                  _onUploadFile(context, 'fitnessCertificate', imageOnly: true),
        ),
        SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  List<DropdownMenuItem<String>> _createDropdownItems(List<String> items) {
    return items.map((String item) {
      return DropdownMenuItem<String>(value: item, child: Text(item));
    }).toList();
  }

  Future<void> _pickDate(BuildContext context, String field) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      context.read<EditVehicleInfoBloc>().add(
        PickDate(field: field, date: picked),
      );
    }
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final dt = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        context.read<EditVehicleInfoBloc>().add(PickDateTime(dateTime: dt));
      } else {
        context.read<EditVehicleInfoBloc>().add(
          PickDateTime(dateTime: pickedDate),
        );
      }
    }
  }

  void _onViewFile(BuildContext context, String? url) {
    if (url != null && url.isNotEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              backgroundColor: Colors.transparent,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder:
                      (context, child, progress) =>
                          progress == null
                              ? child
                              : const Center(
                                child: CircularProgressIndicator(),
                              ),
                ),
              ),
            ),
      );
    }
  }

  void _onUploadFile(
    BuildContext context,
    String field, {
    bool imageOnly = false,
  }) {
    _pickFileOrImage(context, field, imageOnly: imageOnly);
  }

  Future<void> _pickFileOrImage(
    BuildContext context,
    String field, {
    bool imageOnly = false,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleImageSelection(
                    context,
                    field,
                    ImageSource.camera,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleImageSelection(
                    context,
                    field,
                    ImageSource.gallery,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text('Files'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleFileSelection(context, field, imageOnly);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImageSelection(
    BuildContext context,
    String field,
    ImageSource source,
  ) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        await _uploadFileToFirebase(
          context,
          field,
          File(picked.path),
          picked.name,
          isImage: true,
        );
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick image: $e');
    }
  }

  Future<void> _handleFileSelection(
    BuildContext context,
    String field,
    bool imageOnly,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: imageOnly ? FileType.image : FileType.any,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        await _uploadFileToFirebase(
          context,
          field,
          file,
          result.files.first.name,
        );
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Failed to pick file: $e');
    }
  }

  Future<void> _uploadFileToFirebase(
    BuildContext context,
    String field,
    File file,
    String fileName, {
    bool isImage = false,
  }) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator()],
            ),
          );
        },
      );

      context.read<EditVehicleInfoBloc>().add(
        UploadFile(
          file: file,
          fileName: fileName,
          field: field,
          isImage: isImage,
        ),
      );

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        _showErrorSnackBar(context, 'Failed to upload file: $e');
      }
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

Widget fileUploadRow({
  required String? url,
  required String label,
  required VoidCallback onView,
  required VoidCallback onUpload,
}) {
  final hasFile = url != null && url.isNotEmpty;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hasFile) ...[
              Flexible(
                flex: 1,
                child: ElevatedButton.icon(
                  onPressed: onView,
                  icon: const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'View',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: AppButtonStyle.primary,
                ),
              ),
              20.width,
            ],
            Flexible(
              flex: 1,
              child: ElevatedButton.icon(
                onPressed: onUpload,
                icon: Icon(hasFile ? Icons.upload_file : Icons.add),
                label: Text(hasFile ? 'Replace' : 'Add File'),
                style: AppButtonStyle.outline,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
