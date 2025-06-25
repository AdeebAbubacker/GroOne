import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/kavach/cubit/kavach_add_vehicle_cubit/kavach_add_vehicle_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../data/model/result.dart';
import '../../../data/ui_state/status.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_multi_selection_dropdown.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/toast_messages.dart';
import '../../../utils/upload_attachment_files.dart';
import '../../../utils/validator.dart';
import '../api_request/kavach_add_vehicle_request.dart';
import '../cubit/kavach_add_vehicle_cubit/kavach_add_vehicle_state.dart';
import '../model/kavach_truck_length_model.dart';

class KavachAddVehicleBottomSheet extends StatefulWidget {
  const KavachAddVehicleBottomSheet({super.key});

  @override
  State<KavachAddVehicleBottomSheet> createState() =>
      _KavachAddVehicleBottomSheetState();
}

class _KavachAddVehicleBottomSheetState
    extends State<KavachAddVehicleBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final truckNumberController = TextEditingController();
  final truckMakeModelController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final capacityController = TextEditingController();

  List<Map<String, dynamic>> vehicleDocList = []; // Add this at state level

  final MultiSelectController<String> acceptableCommoditiesController =
      MultiSelectController<String>();

  String? truckTypeDropdownValue;
  String? truckLengthDropdownValue;
  int? selectedTruckTypeId;
  String? commoditiesDropdownValue;
  bool isActive = true;
  final kavachAddNewVehicleCubit = locator<KavachAddVehicleFormCubit>();

  @override
  void initState() {
    kavachAddNewVehicleCubit.fetchCommodities();
    kavachAddNewVehicleCubit.fetchTruckTypes();
    super.initState();
  }

  Future<Result<bool>> _uploadGSTDocumentApiCall(
    BuildContext context,
    List<Map<String, dynamic>> multiFilesList,
  ) async {
    final cubit = context.read<KavachAddVehicleFormCubit>();
    await cubit.uploadVehicleDoc(File(multiFilesList.first['path']));
    final status = cubit.state.vehicleDocUpload.status;

    if (status == Status.SUCCESS) {
      final url = cubit.state.vehicleDocUpload.data?.data?.url ?? '';
      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    } else if (status == Status.ERROR) {
      final errorType = cubit.state.vehicleDocUpload.errorType;
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
        height: 550,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: truckNumberController,
                        labelText: context.appText.truckNumber,
                        validator:
                            (value) => Validator.fieldRequired(
                              value,
                              fieldName: context.appText.truckNumber,
                            ),
                      ),
                      10.height,
                      AppTextField(
                        controller: truckMakeModelController,
                        labelText: context.appText.truckMakeModel,
                        validator:
                            (value) => Validator.fieldRequired(
                              value,
                              fieldName: context.appText.truckMakeModel,
                            ),
                      ),
                      10.height,
                      AppTextField(
                        controller: licenseNumberController,
                        labelText: context.appText.licenseNumber,
                        validator:
                            (value) => Validator.fieldRequired(
                              value,
                              fieldName: context.appText.licenseNumber,
                            ),
                      ),
                      10.height,

                      /// Upload RC (custom logic required to implement file picker)
                      UploadAttachmentFiles(
                        title: context.appText.uploadRC,
                        multiFilesList: vehicleDocList,
                        isSingleFile: true,
                        isLoading: context.watch<KavachAddVehicleFormCubit>().state.vehicleDocUpload.status ==
                            Status.LOADING,
                        thenUploadFileToSever: () async {
                          await _uploadGSTDocumentApiCall(
                            context,
                            vehicleDocList,
                          );
                        },
                      ),

                      10.height,
                      BlocBuilder<KavachAddVehicleFormCubit, KavachAddVehicleFormState>(
                        builder: (context, state) {
                          final cubit = context.read<KavachAddVehicleFormCubit>();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Truck Type Dropdown
                              if (state.truckTypes.status == Status.SUCCESS)
                                AppDropdown(
                                  labelText: context.appText.truckType,
                                  dropdownValue: truckTypeDropdownValue,
                                  dropDownList: state.truckTypes.data!
                                      .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
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
                                  validator: (value) =>
                                  value == null || value.isEmpty ? context.appText.pleaseSelectTruckType : null,
                                ),

                              15.height,

                              /// Truck Length Dropdown
                              if (state.truckLengths.status == Status.SUCCESS)
                                AppDropdown(
                                  labelText:  context.appText.truckLength,
                                  dropdownValue: truckLengthDropdownValue,
                                  dropDownList: state.truckLengths.data!
                                      .map((e) => DropdownMenuItem(
                                    value: e.subType,
                                    child: Text(e.subType),
                                  ))
                                      .toList(),
                                  hintText:  context.appText.truckLength,
                                  mandatoryStar: true,
                                  onChanged: (selected) {
                                    setState(() {
                                      truckLengthDropdownValue = selected;

                                      final selectedModel = state.truckLengths.data!
                                          .firstWhere((e) => e.subType == selected, orElse: () => TruckLengthModel(id: 0, type: '', subType: ''));

                                      selectedTruckTypeId = selectedModel.id;
                                    });
                                  },

                                  validator: (value) =>
                                  value == null || value.isEmpty ? context.appText.pleaseSelectTruckLength : null,
                                ),
                            ],
                          );
                        },
                      ),
                      10.height,

                      /// Capacity field
                      AppTextField(
                        controller: capacityController,
                        labelText: context.appText.capacity,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator:
                            (value) => Validator.fieldRequired(
                              value,
                              fieldName: context.appText.capacity,
                            ),
                      ),
                      10.height,

                      /// Acceptable Commodities Dropdown
                      BlocBuilder<KavachAddVehicleFormCubit, KavachAddVehicleFormState>(
                        builder: (context, state) {
                          if (state.commodities.status == Status.LOADING) {
                            return const SizedBox.shrink(); // or CircularProgressIndicator()
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
                              controller: acceptableCommoditiesController,
                              // <- You need to define this
                              items: items,
                              onSelectionChange: (selected) {
                                print('Selected Commodities: $selected');
                              },
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? context.appText.pleaseSelectCommodity
                                          : null,
                            );
                          } else if (state.commodities.status == Status.ERROR) {
                            return Text('Error: ${state.commodities.errorType}');
                          }

                          return const SizedBox.shrink();
                        },
                      ),

                      10.height,

                      /// Active Switch
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
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                AppButton(
                  onPressed: () => context.pop(),
                  title: context.appText.cancel,
                  style: AppButtonStyle.outline,
                ).expand(),
                20.width,
                AppButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    if(vehicleDocList.isEmpty){
                      ToastMessages.alert(message: context.appText.pleaseUploadRc);
                      return;
                    }

                    final userId = int.tryParse(await context.read<KavachAddVehicleFormCubit>().repository.userInfoRepo.getUserID() ?? '') ?? 0;
                    final selectedCommoditiesIds = acceptableCommoditiesController.selectedItems
                        .map((idStr) => int.tryParse(idStr.value))
                        .whereType<int>() // filters out null
                        .toList();
                    final rcDocLink = vehicleDocList.first['path'];

                    final request = KavachAddVehicleRequest(
                      customerId: userId,
                      vehicleNumber: truckNumberController.text.trim(),
                      vehicleTypeId: 1,
                      rcNumber: licenseNumberController.text.trim(),
                      rcDocLink: rcDocLink,
                      truckMakeAndModel: truckMakeModelController.text.trim(),
                      truckType: selectedTruckTypeId??0,
                      truckLength: selectedTruckTypeId??0,
                      capacity: int.tryParse(capacityController.text.trim()) ?? 0,
                      acceptableCommodities: selectedCommoditiesIds,
                      vehicleStatus: isActive ? 1 : 0,
                    );

                    print(jsonEncode(request));
                    final result = await kavachAddNewVehicleCubit.addVehicle(request);

                    if (result is Success) {
                      context.pop();
                      ToastMessages.success(message: context.appText.vehicleSavedSuccess);
                    } else if (result is Error) {
                      ToastMessages.error(
                        message: getErrorMsg(errorType: result.type),
                      );
                    }

                  },

                  title: context.appText.save,
                  style: AppButtonStyle.primary,
                ).expand(),
              ],
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
