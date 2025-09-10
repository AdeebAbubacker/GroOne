import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../../data/model/result.dart';
import '../../../../data/ui_state/status.dart';
import '../../../../dependency_injection/locator.dart';
import '../../../../features/login/repository/user_information_repository.dart';
import '../../../../utils/app_bottom_sheet_body.dart' show AppBottomSheetBody;
import '../../../../utils/common_functions.dart';
import '../../../../utils/toast_messages.dart';
import '../../../../utils/validator.dart';
import '../../cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import '../../cubit/gps_vehicle_cubit/gps_vehicle_state.dart';
import '../../gps_order_request/gps_order_api_request.dart';
import '../../models/gps_truck_length_model.dart';
import '../../models/gps_vehicle_models.dart';

// --- GPS Vehicle List Screen ---
class GpsVehicleSelectionScreen extends StatefulWidget {
  final String? currentlySelectedVehicle;

  const GpsVehicleSelectionScreen({super.key, this.currentlySelectedVehicle});

  @override
  State<GpsVehicleSelectionScreen> createState() =>
      _GpsVehicleSelectionScreenState();
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

  /// Helper method to get truck type display text
  String _getTruckTypeDisplayText(GpsVehicleModel vehicle) {
    // For GPS vehicles, we'll use a simple mapping since we don't have the full truck type API data here
    // This can be enhanced later if needed
    switch (vehicle.truckTypeId) {
      case 1:
        return 'Open - 20ft SXL';
      case 2:
        return 'Open - 22ft SXL';
      case 3:
        return 'Open - 24ft SXL';
      case 4:
        return 'Closed - 20ft SXL';
      case 5:
        return 'Closed - 22ft SXL';
      case 6:
        return 'Closed - 24ft SXL';
      case 7:
        return 'Trailer - 20ft SXL';
      case 8:
        return 'Trailer - 22ft SXL';
      case 9:
        return 'Trailer - 24ft SXL';
      default:
        return 'Truck - ${vehicle.truckLength}ft';
    }
  }

  Widget vehicleCard(GpsVehicleModel vehicle) {
    return InkWell(
      onTap: () {
        if (vehicle.vehicleStatus == 1) {
          Navigator.pop(context, vehicle.truckNo);
        } else {
          ToastMessages.alert(
            message: context.appText.vehicleIsCurrentlyInactive,
          );
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
                    _getTruckTypeDisplayText(vehicle),
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
                  context.appText.active,
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
                      context.appText.addedVehicles,
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
                        builder:
                            (modalContext) => BlocProvider.value(
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
                      context.appText.addVehicle,
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
                    if (state.vehicles.status == Status.LOADING) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.vehicles.status == Status.ERROR) {
                      return Center(
                        child: Text(context.appText.failedToLoadVehicles),
                      );
                    } else if (state.vehicles.status == Status.SUCCESS) {
                      final vehicles = state.vehicles.data ?? [];

                      final searchText = searchController.text.toLowerCase();
                      final filteredVehicles =
                          vehicles.where((vehicle) {
                            return vehicle.truckNo.toLowerCase().contains(
                                  searchText,
                                ) ||
                                vehicle.truckMakeAndModel
                                    .toLowerCase()
                                    .contains(searchText) ||
                                vehicle.rcNumber.toLowerCase().contains(
                                  searchText,
                                ) ||
                                vehicle.tonnage.toLowerCase().contains(
                                  searchText,
                                );
                          }).toList();

                      if (filteredVehicles.isEmpty) {
                        return Center(
                          child: Text(context.appText.noVehiclesFound),
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
    super.key,
  });

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
  bool showValidationErrors = false;

  List<Map<String, dynamic>> vehicleDocList = [];
  final MultiSelectController<String> acceptableCommoditiesController =
      MultiSelectController<String>();

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

    if (!context.mounted) {
      // Widget is gone, just return
      return Error(GenericError());
    }

    final status = cubit.state.documentUpload.status;

    if (status == Status.SUCCESS) {
      final url = cubit.state.documentUpload.data?.url ?? '';
      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(
          message: context.appText.fileUploadedSuccessfully,
        );
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
      title: context.appText.addNewVehicle,
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
                  buildWhen:
                      (previous, current) =>
                          previous.vehicleVerification !=
                          current.vehicleVerification,
                  builder: (context, state) {
                    final verificationState = state.vehicleVerification;
                    if (verificationState.status == Status.SUCCESS) {
                      isVerified = true;
                    }
                    return AppTextField(
                      enableInteractiveSelection: true,
                      controller: truckNumberController,
                      mandatoryStar: true,
                      maxLength: 15,
                      labelText: context.appText.truckNumber,
                      textCapitalization: TextCapitalization.characters,
                      validator:
                          (value) => Validator.validateVehicleNumber(
                            value,
                            fieldName: context.appText.truckNumber,
                          ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9 ]'),
                        ),
                      ],
                      readOnly: verificationState.status == Status.SUCCESS,
                      decoration: commonInputDecoration(
                        suffixIcon:
                            verificationState.status == Status.LOADING
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : verificationState.status == Status.SUCCESS
                                ? const Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                )
                                : InkWell(
                                  onTap: () {
                                    final vehicleNumber =
                                        truckNumberController.text
                                            .trim()
                                            .toUpperCase();
                                    final validationMessage =
                                        Validator.validateVehicleNumber(
                                          vehicleNumber,
                                          fieldName:
                                              context.appText.truckNumber,
                                        );
                                    if (validationMessage != null) {
                                      ToastMessages.alert(
                                        message: validationMessage,
                                      );
                                      return;
                                    }
                                    widget.vehicleCubit.verifyVehicle(
                                      vehicleNumber,
                                    );
                                  },
                                  child: Text(
                                    context.appText.verify,
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
                  enableInteractiveSelection: true,
                  controller: truckMakeModelController,
                  mandatoryStar: true,
                  maxLength: 20,
                  labelText: context.appText.truckMakeAndModel,
                  textCapitalization: TextCapitalization.characters,
                  validator:
                      (value) => Validator.noSpecialCharacters(
                        value,
                        fieldName: context.appText.truckMakeAndModel,
                      ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                  ],
                ),
                10.height,
                AppTextField(
                  enableInteractiveSelection: true,
                  controller: licenseNumberController,
                  labelText: context.appText.licenseNumber,
                  maxLength: 16,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'[A-Za-z0-9\-]'),
                    ), // Allow letters, digits, and hyphens only
                  ],
                  mandatoryStar: true,
                  validator:
                      (value) => Validator.licenseNumberValidator(
                        value,
                        fieldName: context.appText.licenseNumber,
                      ),
                ),
                10.height,
                Row(
                  children: [
                    Text(
                      context.appText.uploadRcBookCopy,
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
                        await _uploadGSTDocumentApiCall(
                          context,
                          vehicleDocList,
                        );
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
                            labelText: context.appText.truckType,
                            dropdownValue: truckTypeDropdownValue,
                            dropDownList:
                                state.truckTypes.data!
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ),
                                    )
                                    .toList(),
                            hintText: context.appText.selectTruckType,
                            mandatoryStar: true,
                            onChanged: (selected) {
                              setState(() {
                                truckTypeDropdownValue = selected;
                                truckLengthDropdownValue = null;
                              });
                              cubit.fetchTruckLengths(selected!);
                            },
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? context.appText.pleaseSelectTruckType
                                        : null,
                          ),
                        15.height,
                        if (state.truckLengths.status == Status.SUCCESS)
                          AppDropdown(
                            labelText: context.appText.truckLength,
                            dropdownValue: truckLengthDropdownValue,
                            dropDownList:
                                state.truckLengths.data!
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e.subType,
                                        child: Text(e.subType),
                                      ),
                                    )
                                    .toList(),
                            hintText: context.appText.truckLength,
                            mandatoryStar: true,
                            onChanged: (selected) {
                              setState(() {
                                truckLengthDropdownValue = selected;
                                final selectedModel = state.truckLengths.data!
                                    .firstWhere(
                                      (e) => e.subType == selected,
                                      orElse:
                                          () => GpsTruckLengthModel(
                                            id: 0,
                                            type: '',
                                            subType: '',
                                          ),
                                    );
                                selectedTruckTypeId = selectedModel.id;
                              });
                            },
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? context
                                            .appText
                                            .pleaseSelectTruckLength
                                        : null,
                          ),
                      ],
                    );
                  },
                ),
                10.height,
                AppTextField(
                  enableInteractiveSelection: true,
                  controller: capacityController,
                  labelText: context.appText.capacity,
                  mandatoryStar: true,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator:
                      (value) => Validator.positiveNumber(
                        value,
                        fieldName: context.appText.capacity,
                      ),
                  decoration: commonInputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        context.appText.metricTons,
                        style: AppTextStyle.textGreyColor12w400,
                      ),
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
                      final items =
                          state.commodities.data!.map((commodity) {
                            return DropdownItem<String>(
                              label: commodity.name,
                              value: commodity.id.toString(),
                            );
                          }).toList();
                      return AppMultiSelectionDropdown<String>(
                        labelText: context.appText.acceptableCommodities,
                        hintText: context.appText.select,
                        mandatoryStar: true,
                        controller: acceptableCommoditiesController,
                        items: items,
                        onSelectionChange: (selected) {},
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? context.appText.pleaseSelectCommodity
                                    : null,
                        showValidationError: showValidationErrors,
                      );
                    } else if (state.commodities.status == Status.ERROR) {
                      return Text(
                        context.appText.noData,
                        style: AppTextStyle.h6.copyWith(
                          color: AppColors.grayColor,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.appText.active),
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
                      title: context.appText.cancel,
                      style: AppButtonStyle.outline,
                    ).expand(),
                    20.width,
                    AppButton(
                      onPressed: () async {
                        setState(() {
                          showValidationErrors = true;
                        });
                        if (!formKey.currentState!.validate()) return;
                        if (vehicleDocList.isEmpty) {
                          ToastMessages.alert(
                            message: context.appText.pleaseUploadRcBookCopy,
                          );
                          return;
                        }
                        if (isVerified == false) {
                          ToastMessages.alert(
                            message:
                                context.appText.pleaseVerifyYourVehicleNumber,
                          );
                          return;
                        }
                        // Get user ID from repository (it's a UUID string, not an integer)
                        final userInfoRepo =
                            locator<UserInformationRepository>();
                        final userIDString = await userInfoRepo.getUserID();

                        if (userIDString == null || userIDString.isEmpty) {
                          if (!context.mounted) return;
                          ToastMessages.error(
                            message:
                                context.appText.userIdNotFoundPleaseLoginAgain,
                          );
                          return;
                        }
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
                          truckMakeAndModel:
                              truckMakeModelController.text.trim(),
                          acceptableCommodities: selectedCommoditiesIds,
                          truckLength: selectedTruckTypeId ?? 0,
                          vehicleStatus: isActive ? 1 : 0,
                        );
                        final result = await widget.vehicleCubit.addVehicle(
                          request,
                        );
                        if (!context.mounted) return;
                        if (result is Success) {
                          Navigator.of(context).pop();
                          widget.onVehicleAdded();
                          ToastMessages.success(
                            message: context.appText.vehicleSavedSuccessfully,
                          );
                        } else {
                          ToastMessages.error(
                            message: context.appText.failedToAddVehicle,
                          );
                        }
                      },
                      title: context.appText.save,
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
