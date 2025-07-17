import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/constants/app_constants.dart';
import 'package:gro_one_app/features/gps_feature/cubit/get_vehicle_extra_info_cubit.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_combined_vehicle_model.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_vehicle_extra_info_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../service/firebase_secondary_service.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/common_widgets.dart';

class EditVehicleInfoScreen extends StatefulWidget {
  final Map<String, dynamic>? vehicleData;

  const EditVehicleInfoScreen({super.key, this.vehicleData});

  @override
  State<EditVehicleInfoScreen> createState() => _EditVehicleInfoScreenState();
}

class _EditVehicleInfoScreenState extends State<EditVehicleInfoScreen> {
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _dateAddedController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _chassisNumberController = TextEditingController();
  final TextEditingController _registrationCertificateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _insuranceExpDateController = TextEditingController();
  final TextEditingController _insuranceImageController = TextEditingController();
  final TextEditingController _pollutionExpDateController = TextEditingController();
  final TextEditingController _pollutionImageController = TextEditingController();
  final TextEditingController _fitnessExpDateController = TextEditingController();
  final TextEditingController _fitnessCertificateController = TextEditingController();
  final TextEditingController _resetOdometerController = TextEditingController();

  GpsCombinedVehicleData? vehicle;
  List<GpsVehicleExtraInfo>? vehicleExtraInfoList;
  GpsVehicleExtraInfo? selectedVehicleExtraInfo;

  final FirebaseFirestore secondaryFirestore = FirebaseFirestore.instanceFor(app: FirebaseService.secondaryApp);
  final FirebaseStorage secondaryStorage = FirebaseStorage.instanceFor(app: FirebaseService.secondaryApp);


  final List<String> brands = [
    "Aston Martin", "Audi", "BMW", "Bentley", "Bugatti", "Datsun",
    "DC", "Ferrari", "Fiat", "Force", "Ford", "Honda", "Hyundai", "ICML", "Isuzu",
    "Jaguar", "Jeep", "Lamborghini", "Land Rover", "Lexus", "Mahindra", "Maruti",
    "Maserati", "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan",
    "Porsche", "Premier", "Renault", "Rolls-Royce", "Skoda",
    "Tata", "Toyota", "Volkswagen", "Volvo"
  ];

  final List<String> models = [
    "DB11", "Rapide", "Vanquish", "Vantage", "A3", "A3 cabriolet",
    "A4", "A5", "A6", "A8", "Q3", "Q5", "Q7", "R8", "RS5",
    "RS6 Avant", "RS7", "S5", "TT", "3 Series", "5 Series", "6 Series", "7 Series", "M Series",
    "X1", "X3", "X5", "X6", "Z4", "i8", "Rolls-Royce", "Skoda", "Tata", "Toyota", "Volkswagen", "Volvo",
    "Bentayga", "Continental", "Flying Spur", "Mulsanne", "Veyron", "GO", "GO Plus", "redi-GO", "Avanti",
    "458 Speciale", "488", "812 Superfast", "California T", "FF", "GTC4Lusso",
    "500", "Abarth Avventura", "Abarth Punto", "Avventura", "Avventura Urban Cross", "Linea", "Linea Classic",
    "Punto EVO", "Punto", "Gurkha", "One",
    "Aspire", "EcoSport", "Endeavour", "Figo", "Freestyle", "Mustang", "Accord", "Amaze", "BRV", "Brio", "CR-V", "City", "Jazz", "Mobilio", "WRV",
    "Creta", "EON", "Elantra", "Elite i20", "Grand i10", "Tucson", "Verna", "Xcent", "Xcent 2016-2017", "i10", "120", "i20 Active",
    "Extreme", "ISUZU D-MAX V-Cross", "ISUZU MUX", "F Type", "F-Pace", "XE", "XF", "XJ", "Compass", "Grand Cherokee", "Wrangler Unlimited",
    "Aventador", "Huracan", "Urus", "Discovery", "Discovery Sport", "Range Rover", "Range Rover Evoque", "Range Rover Sport", "Range Rover Velar",
    "ES", "LS", "LX", "NX", "RX", "Bolero", "E Verito", "KUV100", "KUV100 NXT", "NuvoSport", "Scorpio", "Supro", "TUV 300", "Thar", "Verito", "Verito Vibe", "XUV500", "Xylo", "e2oPlus",
    "Alto 800", "Alto K10", "Baleno", "Baleno RS", "Celerio", "Celerio X", "Ciaz", "Ciaz S", "Dzire", "Eeco", "Ertiga", "Gypsy", "Ignis", "Omni", "S-Cross", "Swift", "Vitara Brezza", "Wagon R",
    "Ghibli", "Gran Cabrio", "Gran Turismo", "Levante", "Quattroporte", "A-Class", "AMG GT", "B-Class", "C-Class", "CLA", "E-Class", "G-Class", "GLA-45 AMG", "GLA Class", "GLC", "GLE", "GLS", "S-Class", "S-Class Cabriolet", "SLC",
    "Clubman", "Cooper 3 DOOR", "Cooper 5 DOOR", "Cooper Convertible", "Countryman", "Pajero Sport", "GT-R", "Micra", "Micra Active", "Sunny", "Terrano", "718", "911", "Cayenne", "Macan", "Panamera",
    "Rio", "Captur", "Duster", "KWID", "Lodgy", "Rolls Royce Dawn", "Rolls Royce Ghost", "Rolls Royce Phantom", "Rolls Royce Wraith", "Kodiaq", "Octavia", "Rapid", "Superb",
    "Bolt", "Hexa", "Indica eV2", "Indigo eCS", "Nano", "Nexon", "Safari", "Safari Storme", "Sumo", "Tiago", "Tigor", "Zest", "Camry", "Corolla Altis", "Etios Cross", "Etios Liva", "Fortuner", "Innova Crysta", "Land Cruiser", "Land Cruiser Prado", "Platinum Etios", "Prius", "Yaris",
    "Ameo", "GTI", "Passat", "Polo", "Tiguan", "Vento", "S60", "S60 Cross Country", "S90", "V40", "V40 Cross Country", "V90 Cross Country", "XC60", "XC90"
  ];

  String? selectedBrand;
  String? selectedModel;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }


  void _onViewFile(TextEditingController controller) {
    final url = controller.text.trim();
    if (url.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.network(
              url,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) =>
              progress == null
                  ? child
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      );
    }
  }

  void _onUploadFile(TextEditingController controller, {bool imageOnly = false}) {
    _pickFileOrImage(controller, imageOnly: imageOnly);
  }

  Future<void> _pickDateTime(TextEditingController controller) async {
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
        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(dt);
      } else {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      }
    }
  }

  void _initializeData() {
    if (widget.vehicleData != null) {
      vehicle = widget.vehicleData!['vehicle'] as GpsCombinedVehicleData?;
      final extraInfoState = widget.vehicleData!['vehicleExtraInfo'] as UIState<List<GpsVehicleExtraInfo>>?;

      if (extraInfoState != null && extraInfoState.status == Status.SUCCESS && extraInfoState.data != null) {
        vehicleExtraInfoList = extraInfoState.data;
        if (vehicle != null && vehicleExtraInfoList != null) {
          selectedVehicleExtraInfo = vehicleExtraInfoList!.firstWhere(
            (extraInfo) => extraInfo.deviceId.toString() == vehicle!.deviceId.toString(),
            orElse: () => vehicleExtraInfoList!.first,
          );
        }
      }

      _populateFormFields();
    }
  }

  void _populateFormFields() {
    if (vehicle != null) {
      _vehicleNumberController.text = vehicle!.vehicleNumber ?? '';
    }

    if (selectedVehicleExtraInfo != null) {
      _dateAddedController.text = selectedVehicleExtraInfo!.dateAdded?.toString() ?? '';
      _plateNumberController.text = selectedVehicleExtraInfo!.plateNumber?.toString() ?? '';
      _chassisNumberController.text = selectedVehicleExtraInfo!.chasisNumber?.toString() ?? '';
      _registrationCertificateController.text = selectedVehicleExtraInfo!.vehicleRegCertificateUrl?.toString() ?? '';
      _brandController.text = selectedVehicleExtraInfo!.vehicleBrand?.toString() ?? '';
      _modelController.text = selectedVehicleExtraInfo!.vehicleModel?.toString() ?? '';
      _insuranceExpDateController.text = selectedVehicleExtraInfo!.insuranceExpiryDate?.toString() ?? '';
      _insuranceImageController.text = selectedVehicleExtraInfo!.insuranceUpload?.toString() ?? '';
      _pollutionExpDateController.text = selectedVehicleExtraInfo!.pollutionExpiryDate?.toString() ?? '';
      _pollutionImageController.text = selectedVehicleExtraInfo!.pollutionCertificateUpload?.toString() ?? '';
      _fitnessExpDateController.text = selectedVehicleExtraInfo!.fitnessExpiryDate?.toString() ?? '';
      _fitnessCertificateController.text = selectedVehicleExtraInfo!.fitnessCertificateUrl?.toString() ?? '';
      // _resetOdometerController.text = selectedVehicleExtraInfo!.rese?.toString() ?? '';

      // Set selected brand and model for dropdowns
      selectedBrand = selectedVehicleExtraInfo!.vehicleBrand?.toString();
      selectedModel = selectedVehicleExtraInfo!.vehicleModel?.toString();
    }
  }

  List<DropdownMenuItem<String>> _createDropdownItems(List<String> items) {
    return items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _pickFileOrImage(TextEditingController controller, {bool imageOnly = false}) async {
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
                  await _handleImageSelection(controller, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleImageSelection(controller, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text('Files'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleFileSelection(controller, imageOnly);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImageSelection(TextEditingController controller, ImageSource source) async {
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        await _uploadFileToFirebase(controller, File(picked.path), picked.name, isImage: true);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _handleFileSelection(TextEditingController controller, bool imageOnly) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: imageOnly ? FileType.image : FileType.any,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        await _uploadFileToFirebase(controller, file, result.files.first.name);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick file: $e');
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
      final compressedFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await compressedFile.writeAsBytes(compressedBytes);
      
      return compressedFile;
    } catch (e) {
      debugPrint('Image compression failed: $e');
      return file;
    }
  }

  Future<void> _uploadFileToFirebase(TextEditingController controller, File file, String fileName, {bool isImage = false}) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      );

      File fileToUpload = file;
      
      if (isImage) {
        fileToUpload = await _compressImage(file);
        debugPrint('Original file size: ${await file.length()} bytes');
        debugPrint('Compressed file size: ${await fileToUpload.length()} bytes');
      }

      final uniqueFileName = fileName;
      final storageRef = secondaryStorage.ref().child('uploads/$uniqueFileName');
      final uploadTask = storageRef.putFile(fileToUpload);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      controller.text = downloadUrl;
      debugPrint(downloadUrl);
      
      if (isImage && fileToUpload != file) {
        try {
          await fileToUpload.delete();
        } catch (e) {
          debugPrint('Failed to delete temporary file: $e');
        }
      }
      
      if (mounted) {
        Navigator.of(context).pop();
      }

      await _updateFileInApi(controller, downloadUrl);
      
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        _showErrorSnackBar('Failed to upload file: $e');
      }
    }
  }

  Future<void> _updateFileInApi(TextEditingController controller, String downloadUrl) async {
    try {
      String? fieldKey;
      if (controller == _registrationCertificateController) {
        fieldKey = 'registration_certificate_url';
      } else if (controller == _insuranceImageController) {
        fieldKey = 'insurance_upload';
      } else if (controller == _pollutionImageController) {
        fieldKey = 'pollution_certificate_upload';
      } else if (controller == _fitnessCertificateController) {
        fieldKey = 'fitness_certificate_url';
      }

      if (fieldKey != null) {
        Map<String, String> apiData = {
          fieldKey: downloadUrl,
        };

        final cubit = locator<GpsVehicleExtraInfoCubit>();
        await cubit.updateDeviceExtraInfo(
          deviceId: selectedVehicleExtraInfo?.id?.toString() ?? '',
          data: apiData,
        );

        debugPrint('API called for $fieldKey with URL: $downloadUrl');
        if(mounted){
          Navigator.of(context).pop();
        _showSuccessSnackBar('File uploaded successfully!');
          Navigator.pop(context);
        }

      }
    } catch (e) {
      debugPrint('Failed to update file in API: $e');
      _showErrorSnackBar('Failed to update file in API: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBarBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Vehicle Info'),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.smallPadding),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSubscriptionSection(),
                _buildFormSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    String subscriptionExpiryDate = 'N/A'; // Default value

    if (selectedVehicleExtraInfo?.subscriptionExpiryDate != null) {
      try {
        final DateTime parsedDate = DateTime.parse(selectedVehicleExtraInfo!.subscriptionExpiryDate!);
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
            style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: Text('Renew / Extend Subscription', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        AppButton(onPressed: () => Navigator.pop(context), title: context.appText.cancel, style: AppButtonStyle.outline).expand(),
        20.width,
        AppButton(onPressed: _handleApplyChanges, title: context.appText.apply, style: AppButtonStyle.primary).expand(),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        SizedBox(height: AppConstants.defaultPadding),
        AppTextField(
          controller: _vehicleNumberController,
          labelText: 'Vehicle Number',
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: _plateNumberController,
          labelText: 'Plate Number',
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: _chassisNumberController,
          labelText: 'Chassis Number',
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppDropdown(
          dropdownValue: selectedBrand,
          dropDownList: _createDropdownItems(brands),
          labelText: 'Brand',
          onChanged: (String? value) {
            setState(() {
              selectedBrand = value;
              _brandController.text = value ?? '';
            });
          },
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppDropdown(
          dropdownValue: selectedModel,
          dropDownList: _createDropdownItems(models),
          labelText: 'Model',
          onChanged: (String? value) {
            setState(() {
              selectedModel = value;
              _modelController.text = value ?? '';
            });
          },
        ),
        // SizedBox(height: AppConstants.smallPadding),
        // AppTextField(
        //   controller: _resetOdometerController,
        //   labelText: 'Reset Odometer',
        // ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: _dateAddedController,
          labelText: 'Date Added',
          readOnly: true,
          onTextFieldTap: () => _pickDateTime(_dateAddedController),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: _insuranceExpDateController,
          labelText: 'Insurance Exp Date',
          readOnly: true,
          onTextFieldTap: () => _pickDate(_insuranceExpDateController),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: _pollutionExpDateController,
          labelText: 'Pollution Exp Date',
          readOnly: true,
          onTextFieldTap: () => _pickDate(_pollutionExpDateController),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.smallPadding),
        AppTextField(
          controller: _fitnessExpDateController,
          labelText: 'Fitness Expiry Date',
          readOnly: true,
          onTextFieldTap: () => _pickDate(_fitnessExpDateController),
          decoration: commonInputDecoration(
            suffixIcon: Icons.calendar_today,
            iconPadding: 0,
          ),
        ),
        SizedBox(height: AppConstants.largePadding),
        _buildActionButtons(),
        SizedBox(height: AppConstants.smallPadding),
        Divider(height: 50,),
        fileUploadRow(
          controller: _registrationCertificateController,
          label: 'Registration Certificate',
          onView: () => _onViewFile(_registrationCertificateController),
          onUpload: () => _onUploadFile(_registrationCertificateController),
        ),
        SizedBox(height: AppConstants.smallPadding),
        fileUploadRow(
          controller: _insuranceImageController,
          label: 'Insurance Image',
          onView: () => _onViewFile(_insuranceImageController),
          onUpload: () => _onUploadFile(_insuranceImageController, imageOnly: true),
        ),
        SizedBox(height: AppConstants.smallPadding),
        fileUploadRow(
          controller: _pollutionImageController,
          label: 'Pollution Image',
          onView: () => _onViewFile(_pollutionImageController),
          onUpload: () => _onUploadFile(_pollutionImageController, imageOnly: true),
        ),
        SizedBox(height: AppConstants.smallPadding),
        fileUploadRow(
          controller: _fitnessCertificateController,
          label: 'Fitness Certificate Image',
          onView: () => _onViewFile(_fitnessCertificateController),
          onUpload: () => _onUploadFile(_fitnessCertificateController, imageOnly: true),
        ),
        SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  // Create JSON for API
  Map<String, dynamic> _createApiJson() {
    return {
      "vehicle_registration_number": _vehicleNumberController.text.trim(),
      "plate_number": _plateNumberController.text.trim(),
      "chasis_number": _chassisNumberController.text.trim(),
      "vehicle_brand": selectedBrand?.trim(),
      "vehicle_model": selectedModel?.trim(),

      // "reset_odometer": _resetOdometerController.text.trim(),
      "date_added": _dateAddedController.text.trim(),

      "insurance_expiry_date": _insuranceExpDateController.text.trim(),
      "pollution_expiry_date": _pollutionExpDateController.text.trim(),
      "fitness_expiry_date": _fitnessExpDateController.text.trim(),

      // Include file URLs if they exist
      if (_registrationCertificateController.text.trim().isNotEmpty)
        "registration_certificate_url": _registrationCertificateController.text.trim(),
      if (_insuranceImageController.text.trim().isNotEmpty)
        "insurance_upload": _insuranceImageController.text.trim(),
      if (_pollutionImageController.text.trim().isNotEmpty)
        "pollution_certificate_upload": _pollutionImageController.text.trim(),
      if (_fitnessCertificateController.text.trim().isNotEmpty)
        "fitness_certificate_url": _fitnessCertificateController.text.trim(),
    };
  }

  void _handleApplyChanges() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      Map<String, dynamic> apiPayload = _createApiJson();
      
      Map<String, String> apiData = {};
      apiPayload.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          apiData[key] = value.toString();
        }
      });

      final cubit = locator<GpsVehicleExtraInfoCubit>();
      await cubit.updateDeviceExtraInfo(
        deviceId: selectedVehicleExtraInfo?.id?.toString() ?? '',
        data: apiData,
      );


      if(mounted){
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vehicle information updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if(mounted){
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update vehicle information.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

Widget fileUploadRow({
  required TextEditingController controller,
  required String label,
  required VoidCallback onView,
  required VoidCallback onUpload,
}) {
  final hasFile = controller.text.isNotEmpty;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          )),
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
                  icon: const Icon(Icons.visibility_outlined, size: 18,color: Colors.white),
                  label: const Text('View',style: TextStyle(color: Colors.white),),
                  style: AppButtonStyle.primary
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
                style:AppButtonStyle.outline
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
