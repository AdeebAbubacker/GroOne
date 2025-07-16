import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../data/model/result.dart';
import '../../../../utils/app_bottom_sheet_body.dart' show AppBottomSheetBody;
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_dropdown.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_search_bar.dart';
import '../../../../utils/app_text_field.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/upload_attachment_files.dart';
import '../../../../dependency_injection/locator.dart';
import '../../../../data/ui_state/status.dart';
import '../../cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import '../../cubit/gps_vehicle_cubit/gps_vehicle_state.dart';
import '../../models/gps_vehicle_models.dart';
import '../../models/gps_truck_length_model.dart';
import '../../gps_order_request/gps_order_api_request.dart';
import '../../../../features/login/repository/user_information_repository.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import '../../../../utils/toast_messages.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/validator.dart';

// --- GPS Vehicle List Screen ---
class GpsVehicleSelectionScreen extends StatefulWidget {
  final String? currentlySelectedVehicle;
  const GpsVehicleSelectionScreen({Key? key, this.currentlySelectedVehicle}) : super(key: key);

  @override
  State<GpsVehicleSelectionScreen> createState() => _GpsVehicleSelectionScreenState();
}

class _GpsVehicleSelectionScreenState extends State<GpsVehicleSelectionScreen> {
  final searchController = TextEditingController();
  String? selectedVehicle;
  late GpsVehicleCubit _vehicleCubit;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.currentlySelectedVehicle;
    // Create the cubit manually to avoid dependency injection issues
    final apiRequest = locator<GpsOrderApiRequest>();
    final userRepo = locator<UserInformationRepository>();
    _vehicleCubit = GpsVehicleCubit(apiRequest, userRepo);
    _vehicleCubit.fetchVehicles();
  }

  @override
  void dispose() {
    searchController.dispose();
    _vehicleCubit.close();
    super.dispose();
  }

  Widget vehicleCard(GpsVehicleModel vehicle) {
    return InkWell(
      onTap: () {
        if (vehicle.vehicleStatus == 1) {
          Navigator.pop(context, vehicle.truckNo);
        } else {
          ToastMessages.alert(message: 'Vehicle is currently inactive');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightBlueIconBackgroundColor2,
              child: SvgPicture.asset(
                AppIcons.svg.truck,
                colorFilter: AppColors.svg(AppColors.primaryColor),
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vehicle.truckNo,
                        style: AppTextStyle.h4.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      6.width,
                      Visibility(
                        visible: vehicle.vehicleStatus == 1,
                        child: const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    vehicle.truckMakeAndModel,
                    style: AppTextStyle.bodyBlackColorW500,
                  ),
                  Text(
                    '${vehicle.truckTypeId == 1 ? 'Open' : 'Closed'} Truck - ${vehicle.truckLength}ft',
                    style: AppTextStyle.textGreyColor12w400,
                  ),
                ],
              ),
            ),
            if (vehicle.vehicleStatus == 1)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F8ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _vehicleCubit,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Material(
          color: Colors.white,
          child: Column(
            children: [
              10.height,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Added Vehicles',
                      style: AppTextStyle.appBar.copyWith(
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (modalContext) => BlocProvider.value(
                          value: _vehicleCubit,
                          child: AddGpsVehicleForm(
                            onVehicleAdded: () {
                              Navigator.of(modalContext).pop();
                              _vehicleCubit.fetchVehicles();
                            },
                            vehicleCubit: _vehicleCubit,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      '+ Add Vehicle',
                      style: AppTextStyle.primaryColor14w700,
                    ),
                  ),
                ],
              ),
            AppSearchBar(
              searchController: searchController,
              onChanged: (text) {
                setState(() {});
              },
            ),
            Expanded(
              child: BlocBuilder<GpsVehicleCubit, GpsVehicleState>(
                builder: (context, state) {
                  print('🔍 UI State: ${state.vehicles.status}, data: ${state.vehicles.data?.length ?? 0}');
                  
                  if (state.vehicles.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.vehicles.status == Status.ERROR) {
                    return const Center(child: Text('Failed to load vehicles'));
                  } else if (state.vehicles.status == Status.SUCCESS) {
                    final vehicles = state.vehicles.data ?? [];
                    print('🔍 UI received ${vehicles.length} vehicles');
                    if (vehicles.isNotEmpty) {
                      print('🔍 First vehicle: ${vehicles.first.truckNo}');
                    }
                    
                    final searchText = searchController.text.toLowerCase();
                    final filteredVehicles = vehicles.where((vehicle) {
                      return vehicle.truckNo.toLowerCase().contains(searchText) ||
                        vehicle.truckMakeAndModel.toLowerCase().contains(searchText) ||
                        vehicle.rcNumber.toLowerCase().contains(searchText) ||
                        vehicle.tonnage.toLowerCase().contains(searchText);
                    }).toList();
                    
                    print('🔍 Filtered vehicles: ${filteredVehicles.length}');
                    
                    if (filteredVehicles.isEmpty) {
                      return Center(
                        child: Text('No vehicles found'),
                      );
                    }
                    return ListView.separated(
                      itemCount: filteredVehicles.length,
                      separatorBuilder: (_, __) => 12.height,
                      itemBuilder: (_, index) {
                        final vehicle = filteredVehicles[index];
                        return vehicleCard(vehicle);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
        ),
      ),
    );
  }
}

// --- AddGpsVehicleForm remains as previously adapted ---
class AddGpsVehicleForm extends StatefulWidget {
  final VoidCallback onVehicleAdded;
  final GpsVehicleCubit vehicleCubit;
  const AddGpsVehicleForm({
    required this.onVehicleAdded,
    required this.vehicleCubit,
    Key? key,
  }) : super(key: key);
  @override
  State<AddGpsVehicleForm> createState() => _AddGpsVehicleFormState();
}

class _AddGpsVehicleFormState extends State<AddGpsVehicleForm> {
  final formKey = GlobalKey<FormState>();
  final truckNumberController = TextEditingController();
  final truckMakeModelController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final capacityController = TextEditingController();
  bool isVerified = false;

  List<Map<String, dynamic>> vehicleDocList = [];
  final MultiSelectController<String> acceptableCommoditiesController = MultiSelectController<String>();

  String? truckTypeDropdownValue;
  String? truckLengthDropdownValue;
  int? selectedTruckTypeId;
  bool isActive = true;
  StreamSubscription? _cubitSubscription;

  @override
  void initState() {
    widget.vehicleCubit.resetVehicleVerification();
    widget.vehicleCubit.fetchCommodities();
    widget.vehicleCubit.fetchTruckTypes();
    
    // Listen to cubit state changes to rebuild the form
    _cubitSubscription = widget.vehicleCubit.stream.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });
    
    super.initState();
  }

  @override
  void dispose() {
    _cubitSubscription?.cancel();
    super.dispose();
  }

  Future<Result<bool>> _uploadGSTDocumentApiCall(
    BuildContext context,
    List<Map<String, dynamic>> multiFilesList,
  ) async {
    final cubit = widget.vehicleCubit;
    await cubit.uploadDocument(File(multiFilesList.first['path']));
    final status = cubit.state.documentUpload.status;

    if (status == Status.SUCCESS) {
      final url = cubit.state.documentUpload.data?.url ?? '';
      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    } else if (status == Status.ERROR) {
      final errorType = cubit.state.documentUpload.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: 'Add New Vehicle',
      hideDivider: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.55,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                BlocBuilder<GpsVehicleCubit, GpsVehicleState>(
                  bloc: widget.vehicleCubit,
                  buildWhen: (previous, current) =>
                      previous.vehicleVerification != current.vehicleVerification,
                  builder: (context, state) {
                    final verificationState = state.vehicleVerification;
                    if (verificationState.status == Status.SUCCESS) {
                      isVerified = true;
                    }
                    return AppTextField(
                      controller: truckNumberController,
                      mandatoryStar: true,
                      maxLength: 15,
                      labelText: 'Truck Number',
                      validator: (value) => Validator.validateVehicleNumber(
                        value,
                        fieldName: 'Truck Number',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                      ],
                      readOnly: verificationState.status == Status.SUCCESS,
                      decoration: commonInputDecoration(
                        suffixIcon: verificationState.status == Status.LOADING
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : verificationState.status == Status.SUCCESS
                                ? const Icon(Icons.verified, color: Colors.green)
                                : InkWell(
                                    onTap: () {
                                      final vehicleNumber = truckNumberController.text.trim().toUpperCase();
                                      final validationMessage = Validator.validateVehicleNumber(
                                        vehicleNumber,
                                        fieldName: 'Truck Number',
                                      );
                                      if (validationMessage != null) {
                                        ToastMessages.alert(message: validationMessage);
                                        return;
                                      }
                                      widget.vehicleCubit.verifyVehicle(vehicleNumber);
                                    },
                                    child: Text(
                                      "Verify",
                                      style: AppTextStyle.body3.copyWith(
                                        color: AppColors.primaryColor,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                      ),
                    );
                  },
                ),
                10.height,
                AppTextField(
                  controller: truckMakeModelController,
                  mandatoryStar: true,
                  maxLength: 20,
                  labelText: 'Truck Make and Model',
                  validator: (value) => Validator.noSpecialCharacters(
                    value,
                    fieldName: 'Truck Make and Model',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                  ],
                ),
                10.height,
                AppTextField(
                  controller: licenseNumberController,
                  labelText: 'License Number',
                  maxLength: 16,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 -]')),
                  ],
                  mandatoryStar: true,
                  validator: (value) => Validator.licenseNumberValidator(
                    value,
                    fieldName: 'License Number',
                  ),
                ),
                10.height,
                Row(
                  children: [
                    Text(
                      " Upload RC Book Copy",
                      style: AppTextStyle.textFiled,
                    ),
                    Text(
                      " *",
                      style: AppTextStyle.textFiled.copyWith(color: Colors.red),
                    ),
                  ],
                ),
                5.height,
                BlocBuilder<GpsVehicleCubit, GpsVehicleState>(
                  bloc: widget.vehicleCubit,
                  builder: (context, state) {
                    return UploadAttachmentFiles(
                      multiFilesList: vehicleDocList,
                      isSingleFile: true,
                      isLoading: state.documentUpload.status == Status.LOADING,
                      thenUploadFileToSever: () async {
                        await _uploadGSTDocumentApiCall(context, vehicleDocList);
                      },
                    );
                  },
                ),
                10.height,
                Builder(
                  builder: (context) {
                    final state = widget.vehicleCubit.state;
                    final cubit = widget.vehicleCubit;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.truckTypes.status == Status.SUCCESS)
                          AppDropdown(
                            labelText: 'Truck Type',
                            dropdownValue: truckTypeDropdownValue,
                            dropDownList: state.truckTypes.data!
                                .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ))
                                .toList(),
                            hintText: 'Select Truck Type',
                            mandatoryStar: true,
                            onChanged: (selected) {
                              setState(() {
                                truckTypeDropdownValue = selected;
                                truckLengthDropdownValue = null;
                              });
                              cubit.fetchTruckLengths(selected!);
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please select truck type'
                                : null,
                          ),
                        15.height,
                        if (state.truckLengths.status == Status.SUCCESS)
                          AppDropdown(
                            labelText: 'Truck Length',
                            dropdownValue: truckLengthDropdownValue,
                            dropDownList: state.truckLengths.data!
                                .map((e) => DropdownMenuItem(
                                      value: e.subType,
                                      child: Text(e.subType),
                                    ))
                                .toList(),
                            hintText: 'Truck Length',
                            mandatoryStar: true,
                            onChanged: (selected) {
                              setState(() {
                                truckLengthDropdownValue = selected;
                                final selectedModel = state.truckLengths.data!
                                    .firstWhere(
                                      (e) => e.subType == selected,
                                      orElse: () => GpsTruckLengthModel(
                                        id: 0,
                                        type: '',
                                        subType: '',
                                      ),
                                    );
                                selectedTruckTypeId = selectedModel.id;
                              });
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please select truck length'
                                : null,
                          ),
                      ],
                    );
                  },
                ),
                10.height,
                AppTextField(
                  controller: capacityController,
                  labelText: 'Capacity',
                  mandatoryStar: true,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => Validator.positiveNumber(
                    value,
                    fieldName: 'Capacity',
                  ),
                  decoration: commonInputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text('Metric Tons', style: AppTextStyle.textGreyColor12w400),
                    ),
                  ),
                ),
                10.height,
                Builder(
                  builder: (context) {
                    final state = widget.vehicleCubit.state;
                    
                    if (state.commodities.status == Status.LOADING) {
                      return const SizedBox.shrink();
                    } else if (state.commodities.status == Status.SUCCESS) {
                      final items = state.commodities.data!.map((commodity) {
                        return DropdownItem<String>(
                          label: commodity.name,
                          value: commodity.id.toString(),
                        );
                      }).toList();
                      return AppMultiSelectionDropdown<String>(
                        labelText: 'Acceptable Commodities',
                        hintText: 'Select',
                        mandatoryStar: true,
                        controller: acceptableCommoditiesController,
                        items: items,
                        onSelectionChange: (selected) {},
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please select commodity'
                            : null,
                      );
                    } else if (state.commodities.status == Status.ERROR) {
                      return Text('Error: ${state.commodities.errorType}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Active'),
                    Switch(
                      value: isActive,
                      onChanged: (val) {
                        setState(() {
                          isActive = val;
                        });
                      },
                    ),
                  ],
                ),
                20.height,
                Row(
                  children: [
                    AppButton(
                      onPressed: () => Navigator.of(context).pop(),
                      title: 'Cancel',
                      style: AppButtonStyle.outline,
                    ).expand(),
                    20.width,
                    AppButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        if (vehicleDocList.isEmpty) {
                          ToastMessages.alert(
                            message: 'Please upload RC Book copy',
                          );
                          return;
                        }
                        if (isVerified == false) {
                          ToastMessages.alert(
                            message: 'Please verify your Vehicle Number',
                          );
                          return;
                        }
                        // Get user ID from repository (it's a UUID string, not an integer)
                        final userInfoRepo = locator<UserInformationRepository>();
                        final userIDString = await userInfoRepo.getUserID();
                        print('🔍 User ID from repository: $userIDString');
                        
                        if (userIDString == null || userIDString.isEmpty) {
                          ToastMessages.error(message: 'User ID not found. Please login again.');
                          return;
                        }
                        
                        print('🔍 Using User ID as string: $userIDString');
                        final selectedCommoditiesIds =
                            acceptableCommoditiesController.selectedItems
                                .map((idStr) => int.tryParse(idStr.value))
                                .whereType<int>()
                                .toList();
                        final rcDocLink = vehicleDocList.first['path'];
                        final request = GpsAddVehicleRequest(
                          customerId: userIDString,
                          truckNo: truckNumberController.text.trim(),
                          rcNumber: licenseNumberController.text.trim(),
                          rcDocLink: rcDocLink,
                          tonnage: capacityController.text.trim(),
                          truckTypeId: selectedTruckTypeId ?? 1,
                          truckMakeAndModel: truckMakeModelController.text.trim(),
                          acceptableCommodities: selectedCommoditiesIds,
                          truckLength: selectedTruckTypeId ?? 0,
                          vehicleStatus: isActive ? 1 : 0,
                        );
                        final result = await widget.vehicleCubit.addVehicle(request);
                        if (result is Success) {
                          Navigator.of(context).pop();
                          widget.onVehicleAdded();
                          ToastMessages.success(
                            message: 'Vehicle saved successfully',
                          );
                        } else {
                          ToastMessages.error(
                            message: 'Failed to add vehicle',
                          );
                        }
                      },
                      title: 'Save',
                      style: AppButtonStyle.primary,
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 