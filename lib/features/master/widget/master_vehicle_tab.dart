import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_event.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/master/helper/date_helper.dart';
import 'package:gro_one_app/features/master/view/master_screen.dart';
import 'package:gro_one_app/features/master/widget/master_vehicle_widget.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/cubit/masters/masters_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/view/widgets/master_dialogue_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/upper_case_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/app_image.dart';

class buildVehicleTab extends StatefulWidget {
  const buildVehicleTab({super.key});

  @override
  State<buildVehicleTab> createState() => _buildVehicleTabState();
}

class _buildVehicleTabState extends State<buildVehicleTab> {
  final profileCubit = locator<ProfileCubit>();
  final mastersCubit = locator<MastersCubit>();
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final lpHomeCubit = locator<LPHomeCubit>();
  List<String> selectedCommodities = [];
  late TabController _tabController;
  final vehicleSearchController = TextEditingController();
  final addressSearchController = TextEditingController();
  final driverSearchController = TextEditingController();
  Timer? vehicleSearchDebounce;
  Timer? addressSearchDebounce;
  Timer? driverSearchDebounce;
  final kycCubit = locator<KycCubit>();
  String? selectedTruckType;
  String? selectedTruckLength;
  String? truckLengthDropdownValue;
  bool showValidationErrors = false;
  List<Map<String, dynamic>> vehicleDocList = [];
  String? insuranceValidityDate;
  String? fcExpiryDate;
  String? pucExpiryDate;
  String? registrationDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.height,
        // Search Bar
        AppSearchBar(
          searchController: vehicleSearchController,
          onChanged: (query) {
            vehicleSearchDebounce?.cancel();
            vehicleSearchDebounce = Timer(
              const Duration(milliseconds: 300),
              () {
                profileCubit.fetchVehicle(isLoading: false,search: query);
              },
            );
          },
          onClear: () {
            setState(() {
              vehicleSearchController.text = '';
              vehicleSearchController.clear();
            });
            profileCubit.fetchVehicle(search: '');
          },
        ).paddingSymmetric(horizontal: 20),
        Expanded(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final uiState = state.vehicleState;

              if (uiState == null || uiState.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }

              if (uiState.status == Status.ERROR) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProfileCubit>().fetchVehicle(isLoading: true);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              genericErrorWidget(error: uiState.errorType),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final vehicleList = uiState.data?.data ?? [];
              final List<VehicleDetailsData> filteredVehicleList =
                  vehicleList
                      .where((v) => v.status == 1 || v.status == 2)
                      .toList();
              final isSearching = vehicleSearchController.text.isNotEmpty;


              if (filteredVehicleList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProfileCubit>().fetchVehicle(isLoading: true);
                  },
                  child: isSearching ? Text(context.appText.noSearchResults).center() :  ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppImage.svg.noSearchFound,
                                height: 120,
                              ),
                              20.height,
                              Text(
                                context.appText.noVehiclesFound,
                                style: AppTextStyle.h5,
                              ),
                              10.height,
                              Text(
                                context.appText.startByAddingANewVehicle,
                                style: AppTextStyle.body3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileCubit>().fetchVehicle(isLoading: true);
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      context.read<ProfileCubit>().fetchVehicle(loadMore: true);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    itemCount: filteredVehicleList.length,
                    itemBuilder: (context, index) {
                      final vehicleDetailsData = filteredVehicleList[index];
                      return masterVehicleInfoWidget(
                        name: vehicleDetailsData.truckNo,
                        phone: vehicleDetailsData.companyName ?? '',
                        driverStatus: vehicleDetailsData.status,
                        onEdit: () async {
                          mastersCubit.resetVehicleVerification();
                          await Future.delayed(
                            const Duration(milliseconds: 50),
                          );
                          showAddVehiclePopup(
                            context,
                            vehcile: vehicleDetailsData,
                          );
                        },
                        onDelete:
                            () => showDeletePopUp(
                              context: context,
                              confirmMessage:
                                  context.appText.areYouSureToDeleteThisVehicle,
                              successMessage:
                                  context.appText.vehicleDeletedSuccessfully,
                              onDelete:
                                  () => profileCubit.deleteVehicle(
                                    vehicleId: vehicleDetailsData.vehicleId,
                                    request: DeleteVehicleRequest(status: 3),
                                  ),
                            ),
                        context: context,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: AppButton(
            title: context.appText.addNewVehicle,
            onPressed: () async {
              mastersCubit.resetVehicleVerification();
              await Future.delayed(
                const Duration(milliseconds: 50),
              ); // make sure state is cleared
              showAddVehiclePopup(context);
            },
          ),
        ),
        20.height,
      ],
    );
  }

  /// Add Vehicle Popup
  void showAddVehiclePopup(
    BuildContext context, {
    VehicleDetailsData? vehcile,
  }) async {
    context.read<MastersCubit>().resetVehicleVerification();
    bool isVehicleVerified = vehcile != null;
    final formKey = GlobalKey<FormState>();
    final isEdit = vehcile != null;
    bool isVehicleActive = vehcile != null ? (vehcile.status == 1) : true;
    final truckNumberController = TextEditingController(
      text: vehcile?.truckNo ?? '',
    );
    final truckMakeModelController = TextEditingController(
      text: vehcile?.modelNumber ?? '',
    );
    final owenerNameController = TextEditingController(
      text: vehcile?.ownerName ?? '',
    );
    final insurancePolicyNumber = TextEditingController(
      text: vehcile?.insurancePolicyNumber ?? '',
    );

    insuranceValidityDate =
        vehcile?.insuranceValidityDate != null
            ? DateFormat('dd/MM/yyyy').format(vehcile!.insuranceValidityDate!)
            : null;
    fcExpiryDate =
        vehcile?.fcExpiryDate != null
            ? DateFormat('dd/MM/yyyy').format(vehcile!.fcExpiryDate!)
            : null;
    pucExpiryDate =
        vehcile?.pucExpiryDate != null
            ? DateFormat('dd/MM/yyyy').format(vehcile!.pucExpiryDate!)
            : null;
    registrationDate =
        vehcile?.registrationDate != null
            ? DateFormat('dd/MM/yyyy').format(vehcile!.registrationDate!)
            : null;
    String? selectedWeightDropDownValue;
    selectedWeightDropDownValue = vehcile?.tonnage;
    TruckTypeModel? selectedTruckType;
    if (vehcile?.truckType != null) {
      selectedTruckType = TruckTypeModel(
        id: vehcile!.truckType!.id,
        type: vehcile.truckType!.type,
        subType: vehcile.truckType!.subType,
        iconUrl: vehcile.truckType!.iconUrl,
        status: vehcile.truckType!.status,
        createdAt: vehcile.truckType!.createdAt,
        deletedAt: vehcile.truckType!.deletedAt,
      );
    }

    MasterDialogueWidget.show(
      dismissible: true,
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
          List<Map<String, dynamic>> localRcDocList = List.from(vehicleDocList);
          final rcDocUpload =
              context.watch<ProfileCubit>().state.vehicleDocUpload;
          final isUploading = rcDocUpload?.status == Status.LOADING;

          return MasterCommonDialogView(
            hideCloseButton: true,
            showYesNoButtonButtons: true,
            yesButtonText:
                isEdit ? context.appText.update : context.appText.save,
            noButtonText: context.appText.cancel,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEdit
                          ? context.appText.editVehicle
                          : context.appText.addNewVehicle,
                      style: AppTextStyle.h4,
                    ),
                    20.height,
                    buildVehicleVerificationFieldWidget(
                      vehicleNoController: truckNumberController,
                      onVerificationResult: (isVerified, vehicleData) {
                        setState(() {
                          isVehicleVerified = isVerified;

                          // If data came from API, autofill fields
                          if (vehicleData != null) {
                            final makeModel =
                                vehicleData['vehicle_make_model'] ??
                                vehicleData['modelNumber'];
                            if (makeModel != null) {
                              truckMakeModelController.text =
                                  makeModel.toString();
                            }
                            final ownerName =
                                vehicleData['ownerName'] ??
                                vehicleData['user_name'];
                            if (ownerName != null) {
                              owenerNameController.text = ownerName.toString();
                            }

                            final insurancePolicyNo =
                                vehicleData['insurance_policy_number'] ??
                                vehicleData['insurancePolicyNumber'];
                            if (insurancePolicyNo != null) {
                              insurancePolicyNumber.text =
                                  insurancePolicyNo.toString();
                            }
                            final capacity =
                                vehicleData['vehicle_gross_weight'] ??
                                vehicleData['tonnage'];
                            if (capacity != null) {
                              final numberOnly = RegExp(
                                r'\d+',
                              ).stringMatch(capacity.toString());
                              selectedWeightDropDownValue = capacity;

                              isVehicleActive =
                                  vehicleData['status'] == 1 ? true : false;
                              final truckTypeList =
                                  context
                                      .read<VpCreateAccountCubit>()
                                      .state
                                      .truckTypeUIState
                                      ?.data ??
                                  [];

                              final TruckTypeModel? matchedTruckType =
                                  truckTypeList.firstWhereOrNull(
                                    (t) => t.id == vehicleData['truckTypeId'],
                                  );

                              if (matchedTruckType != null) {
                                selectedTruckType = matchedTruckType;
                              } else {
                                selectedTruckType = null;
                                print(
                                  'No matching truck type found for id: ${vehicleData['truckTypeId']}',
                                );
                              }

                              final insurancyexpiryRaw =
                                  vehicleData['insurance_expiry_date'] ??
                                  vehicleData['insuranceValidityDate'];
                              insuranceValidityDate = DateHelper.parseDate(
                                insurancyexpiryRaw,
                              );
                              final pucExpiryRaw =
                                  vehicleData['rc_pucc_expiry_date'] ??
                                  vehicleData['pucExpiryDate'];
                              pucExpiryDate = DateHelper.parseDate(
                                pucExpiryRaw,
                              );
                              final fcExpiryRaw = vehicleData['fcExpiryDate'];
                              fcExpiryDate = DateHelper.parseDate(fcExpiryRaw);
                              final registrationRaw =
                                  vehicleData['rc_registration_date'] ??
                                  vehicleData['registrationDate'];
                              registrationDate = DateHelper.parseDate(
                                registrationRaw,
                              );
                            }
                          }
                        });
                      },
                    ),
                    16.height,
                    AppTextField(
                      validator: (value) => Validator.fieldRequired(value),
                      controller: owenerNameController,
                      labelText: "Owner Name",
                      hintText: "Owner Name",
                      mandatoryStar: true,
                    ),
                    16.height,

                    /// Regsitartion Date
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          final formattedDate = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);

                          setState(() {
                            registrationDate = formattedDate;
                          });
                        }
                      },
                      child: buildReadOnlyField(
                        "Registartion Date",
                        (registrationDate?.isEmpty ?? true)
                            ? 'Registartion Date'
                            : registrationDate!,
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),

                    16.height,

                    16.height,
                    AppTextField(
                      validator: (value) => Validator.fieldRequired(value),
                      controller: truckMakeModelController,
                      labelText: context.appText.truckMakeAndModel,
                      hintText: context.appText.truckMakeAndModel,
                      mandatoryStar: true,
                    ),
                    16.height,
                    Text(context.appText.truckType, style: AppTextStyle.body3),
                    5.height,
                    // TrucK Type
                    BlocBuilder<VpCreateAccountCubit, VpCreateAccountState>(
                      builder: (context, state) {
                        final truckTypeUIState = state.truckTypeUIState;

                        if (truckTypeUIState == null ||
                            truckTypeUIState.status == Status.LOADING) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (truckTypeUIState.status == Status.ERROR) {
                          return const Text("Error loading truck types");
                        }

                        final uiState = state.truckTypeUIState?.data;
                        final truckTypes = uiState ?? [];
                        final truckTypeLabels =
                            truckTypes
                                .map((e) => '${e.type} - ${e.subType}')
                                .toList();
                        final truckTypeLabelMap = Map.fromEntries(
                          truckTypes.map(
                            (e) => MapEntry('${e.type} - ${e.subType}', e),
                          ),
                        );

                        return SearchableDropdown(
                          hintText: context.appText.truckType,
                          items: truckTypeLabels,
                          selectedItem:
                              selectedTruckType == null
                                  ? null
                                  : '${selectedTruckType!.type} - ${selectedTruckType!.subType}',
                          onChanged: (value) {
                            selectedTruckType = truckTypeLabelMap[value];
                            setState(() {});
                          },
                        );
                      },
                    ),
                    16.height,
                    Text(context.appText.capacity, style: AppTextStyle.body3),
                    5.height,
                    BlocBuilder<LPHomeCubit, LPHomeState>(
                      builder: (context, state) {
                        final uiState = state.loadWeightUIState;
                        final weights = uiState?.data ?? [];
                        final weightLabels =
                            weights.map((e) => '${e.value} Ton').toList();
                        final weightLabelIdMap = Map.fromEntries(
                          weights.map((e) => MapEntry('${e.value} Ton', e.id)),
                        );

                        return SearchableDropdown(
                          hintText: context.appText.capacity,
                          items: weightLabels,
                          selectedItem: selectedWeightDropDownValue,
                          onChanged: (value) {
                            selectedWeightDropDownValue = value;
                            setState(() {});
                          },
                        );
                      },
                    ),
                    16.height,
                    //Insurance policy number
                    AppTextField(
                      validator: (value) => Validator.fieldRequired(value),
                      controller: insurancePolicyNumber,
                      labelText: "Insurance Policy Number",
                      hintText: "Insurance Policy Number",
                      mandatoryStar: true,
                    ),
                    16.height,

                    /// Insurance Validity Date
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          final formattedDate = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);

                          setState(() {
                            insuranceValidityDate = formattedDate;
                          });
                        }
                      },
                      child: buildReadOnlyField(
                        "Insurance Validity Date",
                        (insuranceValidityDate?.isEmpty ?? true)
                            ? 'Insurance Validity Date'
                            : insuranceValidityDate!,
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),
                    16.height,

                    /// FC Expiry Date
                    FormField<String>(
                      initialValue: fcExpiryDate,
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'FC Expiry Date is required'
                                  : null,
                      builder: (state) {
                        return InkWell(
                          onTap: () async {
                            final DateTime initialDate =
                                fcExpiryDate != null
                                    ? DateFormat(
                                      'dd/MM/yyyy',
                                    ).parse(fcExpiryDate!)
                                    : DateTime.now();

                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              final formattedDate = DateFormat(
                                'dd/MM/yyyy',
                              ).format(pickedDate);
                              setState(() {
                                fcExpiryDate = formattedDate;
                              });
                              state.didChange(
                                formattedDate,
                              ); // Update FormField state
                            }
                          },
                          child: buildReadOnlyField(
                            "FC Expiry Date",
                            fcExpiryDate ?? 'FC Expiry Date',
                            fillColor: Colors.white,
                            mandatoryStar: true,
                          ),
                        );
                      },
                    ),

                    16.height,

                    /// PUC Expiry Date
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          final formattedDate = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);

                          setState(() {
                            pucExpiryDate = formattedDate;
                          });
                        }
                      },
                      child: buildReadOnlyField(
                        "PUC Expiry Date",
                        (pucExpiryDate?.isEmpty ?? true)
                            ? 'PUC Expiry Date'
                            : pucExpiryDate!,
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),

                    16.height,

                    /// Active Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.appText.active),
                        Switch(
                          value: isVehicleActive,
                          onChanged: (val) {
                            setState(() => isVehicleActive = val);
                            if (vehcile != null) {
                              profileCubit.deleteVehicle(
                                vehicleId: vehcile.vehicleId,
                                request: DeleteVehicleRequest(
                                  status: val ? 1 : 2,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
            onClickYesButton: () async {
              final String? validation = Validator.fieldRequired(
                truckNumberController.text.trim(),
                fieldName: 'Vehicle Reg No',
              );
              if (validation != null) {
                ToastMessages.alert(message: validation);
                return;
              }
              if (!isVehicleVerified) {
                ToastMessages.alert(
                  message: "Please verify the Vehcile Reg No before proceeding",
                );
                return;
              }
              if (owenerNameController.text == null ||
                  owenerNameController!.text.isEmpty) {
                ToastMessages.alert(message: "Owner Name is required");
                return;
              }
              if (fcExpiryDate == null || fcExpiryDate!.isEmpty) {
                ToastMessages.alert(message: "FC Expiry Date is required");
                return;
              }
              if (registrationDate == null || registrationDate!.isEmpty) {
                ToastMessages.alert(message: "Registration Date is required");
                return;
              }
              if (pucExpiryDate == null || pucExpiryDate!.isEmpty) {
                ToastMessages.alert(message: "PUC Expiry Date is required");
                return;
              }
              if (insuranceValidityDate == null ||
                  insuranceValidityDate!.isEmpty) {
                ToastMessages.alert(
                  message: "Insurance Validity Date is required",
                );
                return;
              }
              if (insurancePolicyNumber.text == null ||
                  insurancePolicyNumber!.text.isEmpty) {
                ToastMessages.alert(
                  message: "Insurance Policy Number is required",
                );
                return;
              }
              if (formKey.currentState!.validate()) {
                final request = VehicleRequest(
                  customerId: profileCubit.userId ?? "",
                  truckNo: truckNumberController.text.trim(),
                  tonnage: selectedWeightDropDownValue,
                  truckTypeId: selectedTruckType?.id ?? 1,
                  modelNumber: truckMakeModelController.text.trim(),
                  ownerName: owenerNameController.text,
                  fcExpiryDate: convertToYMD(fcExpiryDate.toString()) ?? '',
                  insurancePolicyNumber: insurancePolicyNumber.text,
                  pucExpiryDate: convertToYMD(pucExpiryDate.toString()) ?? '',
                  registrationDate:
                      convertToYMD(registrationDate.toString()) ?? '',
                  insuranceValidityDate:
                      convertToYMD(insuranceValidityDate.toString()) ?? '',
                );

                if (isEdit) {
                  await profileCubit.updateVehicle(
                    vehicleId: vehcile.vehicleId,
                    request: VehicleRequest(
                      customerId: profileCubit.userId ?? "",
                      truckNo: truckNumberController.text.trim(),
                      tonnage: selectedWeightDropDownValue,
                      truckTypeId: selectedTruckType?.id ?? 1,
                      fcExpiryDate: convertToYMD(fcExpiryDate.toString()) ?? '',
                      insuranceValidityDate:
                          convertToYMD(insuranceValidityDate.toString()) ?? '',
                      pucExpiryDate:
                          convertToYMD(pucExpiryDate.toString()) ?? '',
                      registrationDate:
                          convertToYMD(registrationDate.toString()) ?? '',
                      insurancePolicyNumber: insurancePolicyNumber.text,
                      ownerName: owenerNameController.text,
                      modelNumber: truckMakeModelController.text,
                    ),
                  );
                } else {
                  await profileCubit.createVehicle(request: request);
                }

                final state = profileCubit.state.createVehicleState;
                if (state?.status == Status.SUCCESS) {
                  if (context.mounted) Navigator.pop(context);
                  profileCubit.fetchVehicle(isLoading: false);
                  ToastMessages.success(
                    message:
                        isEdit
                            ? context.appText.vehicleUpdatedSuccessfully
                            : context.appText.vehicleAddedSuccessfully,
                  );
                } else {
                  ToastMessages.error(
                    message: getErrorMsg(
                      errorType: state?.errorType ?? GenericError(),
                    ),
                  );
                }
              }
            },
            onClickNoButton: () async {
              mastersCubit.resetVehicleVerification();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  /// Delete Popup
  void showDeletePopUp({
    required BuildContext context,
    required String confirmMessage,
    required String successMessage,
    required Future<dynamic> Function() onDelete,
  }) {
    AppDialog.show(
      context,
      dismissible: true,
      child: CommonDialogView(
        hideCloseButton: true,
        showYesNoButtonButtons: true,
        noButtonText: context.appText.cancel,
        yesButtonText: context.appText.delete,
        yesButtonTextStyle: AppButtonStyle.deleteTextButton,
        child: Column(
          children: [
            Lottie.asset(
              AppJSON.alertRed,
              repeat: true,
              frameRate: FrameRate(200),
            ),
            Center(child: Text(confirmMessage, textAlign: TextAlign.center)),
          ],
        ),
        onClickYesButton: () async {
          final result = await onDelete();

          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop();
              ToastMessages.success(message: successMessage);
            }
          } else if (result is Error) {
            ToastMessages.error(message: getErrorMsg(errorType: result.type));
          }
        },
      ),
    );
  }
}

/// Verify RC No
Widget buildVehicleVerificationFieldWidget({
  required TextEditingController vehicleNoController,
  required void Function(bool, Map<String, dynamic>?) onVerificationResult,
}) {
  return BlocBuilder<MastersCubit, MastersState>(
    buildWhen:
        (previous, current) =>
            previous.vehicleVerification != current.vehicleVerification,
    builder: (context, state) {
      final verificationState = state.vehicleVerification;

      final isVerified = verificationState.status == Status.SUCCESS;

      return AppTextField(
            onChanged: (value) {
      final verificationState = context.read<MastersCubit>().state.vehicleVerification;
      if (verificationState.status == Status.SUCCESS) {
        // Reset verification if user edits
        context.read<MastersCubit>().resetVehicleVerification();
        onVerificationResult(false, null);
      }
    },

        controller: vehicleNoController,
        mandatoryStar: true,
        maxLength: 15,
        labelText: "Vehicle Reg No",

        textCapitalization: TextCapitalization.characters,
        validator:
            (value) => Validator.validateVehicleNumber(
              value,
              fieldName: "Vehicle reg no",
            ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(vehicleAlphaNumSpaceRegex),
          UpperCaseTextFormatter(),
          LengthLimitingTextInputFormatter(10),
        ],

   
        decoration: commonInputDecoration(
          suffixIcon:
              verificationState.status == Status.LOADING
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : isVerified
                  ? const Icon(Icons.verified, color: Colors.green)
                  : InkWell(
                    onTap: () async {
                      final vehicleNumber =
                          vehicleNoController.text.trim().toUpperCase();

                      final validationMessage = Validator.validateVehicleNumber(
                        vehicleNumber,
                        fieldName: "Vehicle reg no",
                      );

                      if (validationMessage != null) {
                        ToastMessages.alert(message: validationMessage);
                        return;
                      }

                      final result = await context
                          .read<MastersCubit>()
                          .fetchAndVerifyVehicle(vehicleNumber);

                      if (result is Success<Map<String, dynamic>>) {
                        ToastMessages.success(
                          message: "Vehicle verified & data autofilled.",
                        );
                        onVerificationResult(
                          true,
                          result.value,
                        ); // Pass data back
                      } else {
                        ToastMessages.alert(
                          message: "Vehicle verification failed",
                        );
                        onVerificationResult(false, null);
                      }
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
  );
}

class AddVehicleDialog {
  static void show({required BuildContext context}) {
    context.read<MastersCubit>().resetVehicleVerification();
    bool isVehicleVerified = false;
    final formKey = GlobalKey<FormState>();
    final kavachCheckoutVehicleBloc = locator<KavachCheckoutVehicleBloc>();
    final truckNumberController = TextEditingController();
    final truckMakeModelController = TextEditingController();
    final owenerNameController = TextEditingController();
    final insurancePolicyNumber = TextEditingController();
     final vpCreationCubit = locator<VpCreateAccountCubit>();
     final lphomeCubit = locator<LPHomeCubit>();
     
     vpCreationCubit.fetchTruckType();
     lphomeCubit.fetchLoadWeight();
    String? registrationDate;
    String? insuranceValidityDate;
    String? fcExpiryDate;
    String? pucExpiryDate;
    String? selectedWeightDropDownValue;
    TruckTypeModel? selectedTruckType;
    bool isVehicleActive = true;
    MasterDialogueWidget.show(
      dismissible: true,
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
          
          return MasterCommonDialogView(
            hideCloseButton: true,
            showYesNoButtonButtons: true,
            yesButtonText: context.appText.save,
            noButtonText: context.appText.cancel,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.appText.addNewVehicle, style: AppTextStyle.h4),
                    20.height,
                    buildVehicleVerificationFieldWidget(
                      vehicleNoController: truckNumberController,
                      onVerificationResult: (isVerified, vehicleData) {
                        setState(() {
                          isVehicleVerified = isVerified;

                          // If data came from API, autofill fields
                          if (vehicleData != null) {
                            final makeModel =
                                vehicleData['vehicle_make_model'] ??
                                vehicleData['modelNumber'];
                            if (makeModel != null) {
                              truckMakeModelController.text =
                                  makeModel.toString();
                            }
                            final ownerName =
                                vehicleData['ownerName'] ??
                                vehicleData['user_name'];
                            if (ownerName != null) {
                              owenerNameController.text = ownerName.toString();
                            }

                            final insurancePolicyNo =
                                vehicleData['insurance_policy_number'] ??
                                vehicleData['insurancePolicyNumber'];
                            if (insurancePolicyNo != null) {
                              insurancePolicyNumber.text =
                                  insurancePolicyNo.toString();
                            }
                            final capacity =
                                vehicleData['vehicle_gross_weight'] ??
                                vehicleData['tonnage'];
                            if (capacity != null) {
                              final numberOnly = RegExp(
                                r'\d+',
                              ).stringMatch(capacity.toString());
                              selectedWeightDropDownValue = capacity;

                              final truckTypeList =
                                  context
                                      .read<VpCreateAccountCubit>()
                                      .state
                                      .truckTypeUIState
                                      ?.data ??
                                  [];

                              final TruckTypeModel? matchedTruckType =
                                  truckTypeList.firstWhereOrNull(
                                    (t) => t.id == vehicleData['truckTypeId'],
                                  );

                              if (matchedTruckType != null) {
                                selectedTruckType = matchedTruckType;
                              } else {
                                selectedTruckType = null;
                                print(
                                  'No matching truck type found for id: ${vehicleData['truckTypeId']}',
                                );
                              }

                              final insurancyexpiryRaw =
                                  vehicleData['insurance_expiry_date'] ??
                                  vehicleData['insuranceValidityDate'];
                              insuranceValidityDate = DateHelper.parseDate(
                                insurancyexpiryRaw,
                              );
                              final pucExpiryRaw =
                                  vehicleData['rc_pucc_expiry_date'] ??
                                  vehicleData['pucExpiryDate'];
                              pucExpiryDate = DateHelper.parseDate(
                                pucExpiryRaw,
                              );
                              final fcExpiryRaw = vehicleData['fcExpiryDate'];
                              fcExpiryDate = DateHelper.parseDate(fcExpiryRaw);
                              final registrationRaw =
                                  vehicleData['rc_registration_date'] ??
                                  vehicleData['registrationDate'];
                              registrationDate = DateHelper.parseDate(
                                registrationRaw,
                              );
                            }
                          }
                        });
                      },
                    ),
                    16.height,
                    AppTextField(
                      validator: (value) => Validator.fieldRequired(value),
                      controller: owenerNameController,
                      labelText: "Owner Name",
                      hintText: "Owner Name",
                      mandatoryStar: true,
                    ),
                    16.height,

                    /// Regsitartion Date
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          final formattedDate = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);

                          setState(() {
                            registrationDate = formattedDate;
                          });
                        }
                      },
                      child: buildReadOnlyField(
                        "Registartion Date",
                        (registrationDate?.isEmpty ?? true)
                            ? 'Registartion Date'
                            : registrationDate!,
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),

                    16.height,

                    16.height,
                    AppTextField(
                      validator: (value) => Validator.fieldRequired(value),
                      controller: truckMakeModelController,
                      labelText: context.appText.truckMakeAndModel,
                      hintText: context.appText.truckMakeAndModel,
                      mandatoryStar: true,
                    ),
                    16.height,
                    Text(context.appText.truckType, style: AppTextStyle.body3),
                    5.height,
                    // TrucK Type
                    BlocBuilder<VpCreateAccountCubit, VpCreateAccountState>(
                      builder: (context, state) {
                        final truckTypeUIState = state.truckTypeUIState;

                        if (truckTypeUIState == null ||
                            truckTypeUIState.status == Status.LOADING) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (truckTypeUIState.status == Status.ERROR) {
                          return const Text("Error loading truck types");
                        }

                        final uiState = state.truckTypeUIState?.data;
                        final truckTypes = uiState ?? [];
                        final truckTypeLabels =
                            truckTypes
                                .map((e) => '${e.type} - ${e.subType}')
                                .toList();
                        final truckTypeLabelMap = Map.fromEntries(
                          truckTypes.map(
                            (e) => MapEntry('${e.type} - ${e.subType}', e),
                          ),
                        );

                        return SearchableDropdown(
                          hintText: context.appText.truckType,
                          items: truckTypeLabels,
                          selectedItem:
                              selectedTruckType == null
                                  ? null
                                  : '${selectedTruckType!.type} - ${selectedTruckType!.subType}',
                          onChanged: (value) {
                            selectedTruckType = truckTypeLabelMap[value];
                            setState(() {});
                          },
                        );
                      },
                    ),
                    16.height,
                    Text(context.appText.capacity, style: AppTextStyle.body3),
                    5.height,
                    BlocBuilder<LPHomeCubit, LPHomeState>(
                      builder: (context, state) {
                        final uiState = state.loadWeightUIState;
                        final weights = uiState?.data ?? [];
                        final weightLabels =
                            weights.map((e) => '${e.value} Ton').toList();
                        final weightLabelIdMap = Map.fromEntries(
                          weights.map((e) => MapEntry('${e.value} Ton', e.id)),
                        );

                        return SearchableDropdown(
                          hintText: context.appText.capacity,
                          items: weightLabels,
                          selectedItem: selectedWeightDropDownValue,
                          onChanged: (value) {
                            selectedWeightDropDownValue = value;
                            setState(() {});
                          },
                        );
                      },
                    ),
                    16.height,
                    //Insurance policy number
                    AppTextField(
                      validator: (value) => Validator.fieldRequired(value),
                      controller: insurancePolicyNumber,
                      labelText: "Insurance Policy Number",
                      hintText: "Insurance Policy Number",
                      mandatoryStar: true,
                    ),
                    16.height,

                    /// Insurance Validity Date
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          final formattedDate = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);

                          setState(() {
                            insuranceValidityDate = formattedDate;
                          });
                        }
                      },
                      child: buildReadOnlyField(
                        "Insurance Validity Date",
                        (insuranceValidityDate?.isEmpty ?? true)
                            ? 'Insurance Validity Date'
                            : insuranceValidityDate!,
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),
                    16.height,

                    /// FC Expiry Date
                    FormField<String>(
                      initialValue: fcExpiryDate,
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'FC Expiry Date is required'
                                  : null,
                      builder: (state) {
                        return InkWell(
                          onTap: () async {
                            final DateTime initialDate =
                                fcExpiryDate != null
                                    ? DateFormat(
                                      'dd/MM/yyyy',
                                    ).parse(fcExpiryDate!)
                                    : DateTime.now();

                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: initialDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              final formattedDate = DateFormat(
                                'dd/MM/yyyy',
                              ).format(pickedDate);
                              setState(() {
                                fcExpiryDate = formattedDate;
                              });
                              state.didChange(
                                formattedDate,
                              ); // Update FormField state
                            }
                          },
                          child: buildReadOnlyField(
                            "FC Expiry Date",
                            fcExpiryDate ?? 'FC Expiry Date',
                            fillColor: Colors.white,
                            mandatoryStar: true,
                          ),
                        );
                      },
                    ),

                    16.height,

                    /// PUC Expiry Date
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          final formattedDate = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);

                          setState(() {
                            pucExpiryDate = formattedDate;
                          });
                        }
                      },
                      child: buildReadOnlyField(
                        "PUC Expiry Date",
                        (pucExpiryDate?.isEmpty ?? true)
                            ? 'PUC Expiry Date'
                            : pucExpiryDate!,
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),

                    16.height,

                    /// Active Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(context.appText.active),
                        Switch(
                          value: isVehicleActive,
                          onChanged: (val) {
                            setState(() => isVehicleActive = val);
                          },
                        ),
                      ],
                    ),
                    20.height,
                  ],
                ),
              ),
            ),
            onClickYesButton: () async {
               final String? validation = Validator.fieldRequired(
                truckNumberController.text.trim(),
                fieldName: 'Vehicle Reg No',
              );
              if (validation != null) {
                ToastMessages.alert(message: validation);
                return;
              }
              if (!isVehicleVerified) {
                ToastMessages.alert(
                  message: "Please verify the Vehcile Reg No before proceeding",
                );
                return;
              }
              if (owenerNameController.text == null ||
                  owenerNameController!.text.isEmpty) {
                ToastMessages.alert(message: "Owner Name is required");
                return;
              }
              if (fcExpiryDate == null || fcExpiryDate!.isEmpty) {
                ToastMessages.alert(message: "FC Expiry Date is required");
                return;
              }
              if (registrationDate == null || registrationDate!.isEmpty) {
                ToastMessages.alert(message: "Registration Date is required");
                return;
              }
              if (pucExpiryDate == null || pucExpiryDate!.isEmpty) {
                ToastMessages.alert(message: "PUC Expiry Date is required");
                return;
              }
              if (insuranceValidityDate == null ||
                  insuranceValidityDate!.isEmpty) {
                ToastMessages.alert(
                  message: "Insurance Validity Date is required",
                );
                return;
              }
              if (insurancePolicyNumber.text == null ||
                  insurancePolicyNumber!.text.isEmpty) {
                ToastMessages.alert(
                  message: "Insurance Policy Number is required",
                );
                return;
              }
              if (formKey.currentState!.validate()) {
                final request = VehicleRequest(
                  customerId: context.read<ProfileCubit>().userId ?? "",
                  truckNo: truckNumberController.text.trim(),
                  tonnage: selectedWeightDropDownValue,
                  truckTypeId: selectedTruckType?.id ?? 1,
                  modelNumber: truckMakeModelController.text.trim(),
                  ownerName: owenerNameController.text,
                  fcExpiryDate: convertToYMD(fcExpiryDate.toString()) ?? '',
                  insurancePolicyNumber: insurancePolicyNumber.text,
                  pucExpiryDate: convertToYMD(pucExpiryDate.toString()) ?? '',
                  registrationDate:
                      convertToYMD(registrationDate.toString()) ?? '',
                  insuranceValidityDate:
                      convertToYMD(insuranceValidityDate.toString()) ?? '',
                );
                await context.read<ProfileCubit>().createVehicle(
                  request: request,
                );
                final state =
                    context.read<ProfileCubit>().state.createVehicleState;
                if (state?.status == Status.SUCCESS) {
                  if (context.mounted) Navigator.pop(context);
                  context.read<ProfileCubit>().fetchVehicle(isLoading: false);
                  kavachCheckoutVehicleBloc.add(FetchKavachVehicles());
                  ToastMessages.success(
                    message: context.appText.vehicleAddedSuccessfully,
                  );
                } else {
                  ToastMessages.error(
                    message: getErrorMsg(
                      errorType: state?.errorType ?? GenericError(),
                    ),
                  );
                }
              }
            },
            onClickNoButton: () {
              context.read<MastersCubit>().resetVehicleVerification();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
