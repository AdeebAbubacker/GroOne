import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/storage/secured_shared_preferences.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/master/widget/master_address_tab.dart';
import 'package:gro_one_app/features/master/widget/master_driver_tab.dart';
import 'package:gro_one_app/features/master/widget/master_vehicle_tab.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/cubit/masters/masters_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/view/widgets/master_dialogue_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../data/ui_state/status.dart';

class MasterScreen extends StatefulWidget {
  final int? initialIndex;
  const MasterScreen({super.key, this.initialIndex});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen>
    with SingleTickerProviderStateMixin {
  final profileCubit = locator<ProfileCubit>();
  final mastersCubit = locator<MastersCubit>();
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final gpsVehicleCubit = locator<GpsVehicleCubit>();
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
  void initState() {
    super.initState();
    context.read<MastersCubit>().resetVehicleVerification();
    _tabController = TabController(
      initialIndex: widget.initialIndex ?? 0,

      length: 3,
      vsync: this,
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    kycCubit.fetchStateList();
    initFunction();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    await kycCubit.fetchUserRole();

    _checkAuthenticationAndLoadData();
  });

  /// Check authentication status before loading data
  Future<void> _checkAuthenticationAndLoadData() async {
    try {
      // Check if user has valid token and user data
      final apiService = locator<ApiService>();
      final hasToken = await apiService.hasValidToken();

      // Also check if we have user data stored
      final securePrefs = locator<SecuredSharedPreferences>();
      final userId = await securePrefs.get(AppString.sessionKey.userId);
      final userRole = await securePrefs.getInt(AppString.sessionKey.userRole);

      CustomLog.debug(
        this,
        "🔐 Auth check - Token: $hasToken, UserId: $userId, UserRole: $userRole",
      );

      if (!hasToken || userId == null || userId.isEmpty) {
        // Clear any partial authentication data
        if (userId != null && userId.isNotEmpty) {
          CustomLog.debug(this, "🔐 Clearing partial authentication data");
          await securePrefs.deleteKey(AppString.sessionKey.userId);
          await securePrefs.deleteKey(AppString.sessionKey.userRole);
          await securePrefs.deleteKey(AppString.sessionKey.companyTypeId);
        }

        // Check if we're already on the choose language screen to prevent loop
        if (mounted) {
          final currentRoute = GoRouterState.of(context).uri.path;
          if (currentRoute != AppRouteName.chooseLanguage) {
            CustomLog.debug(
              this,
              "🔐 No valid authentication found, redirecting to login",
            );
            ToastMessages.error(
              message: 'Authentication required. Please login again.',
            );
            Navigator.of(context).pushReplacementNamed('/choose-language');
          } else {
            CustomLog.debug(
              this,
              "🔐 Already on choose language screen, skipping redirect",
            );
          }
        }
        return;
      }

      // If token exists, proceed with data loading
      CustomLog.debug(
        this,
        "🔐 Valid authentication found, loading initial data",
      );
      _loadInitialData();
    } catch (e) {
      CustomLog.error(this, "Error checking authentication", e);
      if (mounted) {
        final currentRoute = GoRouterState.of(context).uri.path;
        if (currentRoute != AppRouteName.chooseLanguage) {
          ToastMessages.error(
            message: 'Authentication check failed. Please login again.',
          );
          Navigator.of(context).pushReplacementNamed('/choose-language');
        }
      }
    }
  }

  /// Load initial data after authentication check
  void _loadInitialData() {
    profileCubit.fetchAddress();
    profileCubit.fetchVehicle();
    profileCubit.fetchDriver();
    profileCubit.fetchUserRole();
    gpsVehicleCubit.fetchTruckTypes();
    gpsVehicleCubit.fetchCommodities();
    vpCreationCubit.fetchTruckType();
    profileCubit.fetchBloodGroup();
    profileCubit.fetchLicenseCategory();
    lpHomeCubit.fetchLoadWeight();
  }

  void disposeFunction() => frameCallback(() {
    _tabController.dispose();
    vehicleSearchDebounce?.cancel();
    addressSearchDebounce?.cancel();
    driverSearchDebounce?.cancel();
    vehicleSearchController.dispose();
    addressSearchController.dispose();
    driverSearchController.dispose();
  });

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

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : AppColors.greyContainerBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: AppTextStyle.h6.copyWith(
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CommonAppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            context.appText.masters,
            style: AppTextStyle.textBlackColor18w500,
          ),
        ),
        body: Column(
          children: [
           15.height,
          TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.transparent, // selected tab bg
            borderRadius: BorderRadius.circular(30),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerHeight: 0,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white,
          labelStyle: AppTextStyle.h6.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTextStyle.h6,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: [
            _buildTab(context.appText.address, _tabController.index == 0),
            _buildTab(context.appText.vehicles, _tabController.index == 1),
            _buildTab(context.appText.drivers, _tabController.index == 2),
          ],
        ),
        Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  buildAddressTab(),
                  buildVehicleTab(),
                  buildDriverTab(),
                ],
              ),
            ),
          ],
        ),
      ),
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

                          // ✅ If data came from API, autofill fields
                          if (vehicleData != null) {
                            final makeModel =
                                vehicleData['vehicle_make_model'] ??
                                vehicleData['modelNumber'];
                            if (makeModel != null) {
                              truckMakeModelController.text =
                                  makeModel.toString();
                            }
                            final ownerName = vehicleData['ownerName'] ?? '';
                            if (ownerName != null) {
                              owenerNameController.text = ownerName.toString();
                            }

                            final insurancePolicyNo =
                                vehicleData['insurance_policy_number'] ?? '';
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
                              final matchedTruckType = truckTypeList.firstWhere(
                                (t) => t.id == vehicleData['truckTypeId'],
                              );
                              if (matchedTruckType != null) {
                                selectedTruckType = matchedTruckType;
                              }
                            }
                          }
                        });

                        /// Date Fields auto pop
                        setState(() {
                          if (vehicleData != null) {
                            insuranceValidityDate =
                                formatApiDateForVehicleVahan(
                                  vehicleData['insurance_expiry_date'],
                                ) ??
                                null;
                            pucExpiryDate =
                                formatApiDateForVehicleVahan(
                                  vehicleData['rc_pucc_expiry_date'],
                                ) ??
                                null;
                            fcExpiryDate =
                                formatApiDateForVehicleVahan(
                                  vehicleData['rc_expiry_date'],
                                ) ??
                                null;
                            registrationDate =
                                formatApiDateForVehicleVahan(
                                  vehicleData['rc_registration_date'],
                                ) ??
                                null;
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
                          initialDate: DateTime.now(), // default current date
                          firstDate: DateTime(1900), // prevent past dates
                          lastDate: DateTime(2100), // far in the future
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
                            fcExpiryDate = formattedDate;
                          });
                        }
                      },
                      child: buildReadOnlyField(
                        "FC Expiry Date",
                        (fcExpiryDate?.isEmpty ?? true)
                            ? 'FC Expiry Date'
                            : fcExpiryDate!,
                        fillColor: Colors.white,
                        mandatoryStar: true,
                      ),
                    ),
                    16.height,

                    /// PUC Expiry Date
                    InkWell(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), // default current date
                          firstDate: DateTime.now(), // prevent past dates
                          lastDate: DateTime(2100), // far in the future
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
                        textStyle: (pucExpiryDate == 'PUC Expiry Date') 
                      ? AppTextStyle.textGreyDetailColor12w400 
                      : AppTextStyle.textFiled,
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
                                vehicleId: vehcile!.vehicleId,
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
              if (formKey.currentState!.validate()) {
                final rcDocLink =
                    vehicleDocList.isNotEmpty
                        ? vehicleDocList.first['path']
                        : '';
                final request = VehicleRequest(
                  customerId: profileCubit.userId ?? "",
                  truckNo: truckNumberController.text.trim(),
                  tonnage: selectedWeightDropDownValue,
                  truckTypeId: selectedTruckType?.id ?? 1,
                  modelNumber: truckMakeModelController.text.trim(),
                  ownerName: owenerNameController.text,
                  fcExpiryDate: fcExpiryDate,
                  insurancePolicyNumber: insurancePolicyNumber.text,
                  pucExpiryDate: pucExpiryDate,
                  registrationDate: registrationDate,
                  insuranceValidityDate: insuranceValidityDate,
                );

                if (isEdit) {
                  await profileCubit.updateVehicle(
                    vehicleId: vehcile.vehicleId,
                    request: VehicleRequest(
                      customerId: profileCubit.userId ?? "",
                      truckNo: truckNumberController.text.trim(),
                      tonnage: selectedWeightDropDownValue,
                      truckTypeId: selectedTruckType?.id ?? 1,
                      fcExpiryDate: fcExpiryDate,
                      insuranceValidityDate: insuranceValidityDate,
                      pucExpiryDate: pucExpiryDate,
                      registrationDate: registrationDate,
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

  Map<String, dynamic>? createFileFromLink(String url) {
    if (url.trim().isEmpty) return null;

    final uri = Uri.parse(url);
    if (uri.pathSegments.isEmpty) return null;

    final fileName = uri.pathSegments.last;
    final extension = fileName.split('.').last;

    return {"fileName": fileName, "path": url, "extension": extension};
  }
}

/// Read Only Textfield
Widget buildReadOnlyField(
  String label,
  String value, {
  Color? fillColor,
  TextStyle? textStyle,
  bool mandatoryStar = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(label, style: AppTextStyle.textFiled),
          if (mandatoryStar)
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
        ],
      ),
      6.height,
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: commonContainerDecoration(
          color: fillColor ?? AppColors.lightGreyBackgroundColor,
          borderRadius: BorderRadius.circular(commonTexFieldRadius),
          borderColor: AppColors.borderColor,
        ),
        child: Row(
          children: [
            Text(value, style:textStyle),
            Spacer(),
            SvgPicture.asset(AppIcons.svg.calendar),
          ],
        ),
      ),
    ],
  );
}

/// State Dropdown
class StateDropdown extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onStateChanged;

  const StateDropdown({
    Key? key,
    required this.selected,
    required this.onStateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateUI = context.watch<KycCubit>().state.stateUIState;
    final stateList = stateUI?.data?.map((e) => e.name ?? '').toList() ?? [];

    return SearchableDropdown(
      labelText: context.appText.state,
      mandatoryStar: true,
      selectedItem: selected,
      items: stateList,
      hintText: context.appText.selectState,
      onChanged: (String? newValue) {
        if (newValue != null) {
          // 1️⃣ Update parent state
          onStateChanged(newValue);

          // 2️⃣ Trigger city list fetch immediately (like in KYC)
          context.read<KycCubit>().fetchCityList(newValue);
        }
      },
      dropdownBuilder: (context, selectedItem) {
        if (selectedItem == null || selectedItem.isEmpty) {
          return const SizedBox.shrink();
        }
        return Row(children: [Text(selectedItem)]);
      },
      emptyBuilder:
          (context, _) => const Center(child: Text("No states found")),
    );
  }
}

/// City Dropdwon
class CityDropdown extends StatelessWidget {
  final String? selected;
  final bool isStateSelected;
  final ValueChanged<String?> onCityChanged;

  const CityDropdown({
    super.key,
    required this.selected,
    required this.isStateSelected,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cityUI = context.watch<KycCubit>().state.cityUIState;
    final cityList = cityUI?.data?.map((e) => e.city ?? '').toList() ?? [];

    return AbsorbPointer(
      absorbing: !isStateSelected,
      child: SearchableDropdown(
        labelText: context.appText.city,
        mandatoryStar: true,
        selectedItem: selected,
        items: cityList,
        hintText: context.appText.selectCity,
        onChanged: (String? newValue) {
          if (newValue != null) {
            onCityChanged(newValue);
          }
        },
        dropdownBuilder: (context, selectedItem) {
          if (selectedItem == null || selectedItem.isEmpty) {
            return const SizedBox.shrink();
          }
          return Row(children: [Text(selectedItem)]);
        },
        emptyBuilder:
            (context, _) => const Center(child: Text("No cities found")),
      ),
    );
  }
}

String? formatApiDateForVehicleVahan(String? apiDate) {
  if (apiDate == null || apiDate.isEmpty) return null;
  try {
    final parsed = DateFormat('dd-MMM-yyyy').parse(apiDate);
    return DateFormat('dd/MM/yyyy').format(parsed);
  } catch (_) {
    return apiDate;
  }
}
