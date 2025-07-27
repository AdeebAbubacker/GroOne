import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_state.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/driver_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../../data/ui_state/status.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen>
    with SingleTickerProviderStateMixin {
  final profileCubit = locator<ProfileCubit>();
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final gpsVehicleCubit = locator<GpsVehicleCubit>();
  final MultiSelectController<String> acceptableCommoditiesController = MultiSelectController<String>();
  List<String> selectedCommodities = [];
  late TabController _tabController;
  final searchController = TextEditingController();
  String? selectedTruckType;
  String? selectedTruckLength;
  String? truckLengthDropdownValue;
   bool showValidationErrors = false;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() {
    _tabController = TabController(length: 3, vsync: this);
    profileCubit.fetchAddress();
    profileCubit.fetchVehicle();
    profileCubit.fetchDriver();
    profileCubit.fetchUserRole();
    gpsVehicleCubit.fetchTruckTypes();
    gpsVehicleCubit.fetchCommodities();
  }

  void disposeFunction() => frameCallback(() {
    _tabController.dispose();
  });

  void deletePopUp(BuildContext context, String addressId) {
    return AppDialog.show(
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
            Text(context.appText.areYouSureToDeleteThisAddress).center(),
          ],
        ),
        onClickYesButton: () async {
          final result = await profileCubit.deleteAddress(addressId: addressId);

          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop(); // close dialog
              ToastMessages.success(
                message: context.appText.addressDeletedSuccessfully,
              );
            }
          } else if (result is Error) {
            ToastMessages.error(message: getErrorMsg(errorType: result.type));
          }
        },
      ),
    );
  }

  void deletePopUpForVehicle(BuildContext context, String vehicleId) {
    return AppDialog.show(
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
            Text(context.appText.areYouSureToDeleteThisAddress).center(),
          ],
        ),
        onClickYesButton: () async {
          final result = await profileCubit.deleteVehicle(vehicleId: vehicleId);

          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop(); // close dialog
              ToastMessages.success(
                message: context.appText.addressDeletedSuccessfully,
              );
            }
          } else if (result is Error) {
            ToastMessages.error(message: getErrorMsg(errorType: result.type));
          }
        },
      ),
    );
  }

  void deletePopUpForDriver(BuildContext context, String addressId) {
    return AppDialog.show(
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
            Text(context.appText.areYouSureToDeleteThisAddress).center(),
          ],
        ),
        onClickYesButton: () async {
          final result = await profileCubit.deleteDriver(driverId: addressId);

          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop(); // close dialog
              ToastMessages.success(
                message: context.appText.addressDeletedSuccessfully,
              );
            }
          } else if (result is Error) {
            ToastMessages.error(message: getErrorMsg(errorType: result.type));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int? role = profileCubit.userRole;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CommonAppBar(
        scrolledUnderElevation: 0,
        backgroundColor: role == 1 ? AppColors.white : Colors.transparent,
        title: Text(
          context.appText.masters,
          style: AppTextStyle.textBlackColor18w500,
        ),
      ),

      body:
          role == 2
              ? Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerHeight: 0,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      labelStyle: AppTextStyle.h6.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: AppTextStyle.h6,
                      tabs: [
                        SizedBox(
                          height: 30,
                          child: Tab(text: context.appText.address),
                        ),
                        SizedBox(
                          height: 30,
                          child: Tab(text: context.appText.vehicles),
                        ),
                        SizedBox(
                          height: 30,
                          child: Tab(text: context.appText.drivers),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildAddressTab(role ?? 0),
                        buildVehicleTab(role ?? 0),
                        buildDriverTab(role ?? 0),
                      ],
                    ),
                  ),
                ],
              )
              : buildAddressTab(role ?? 0),
    );
  }

  Widget buildAddressTab(int role) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final uiState = state.addressState;

        if (uiState == null || uiState.status == Status.LOADING) {
          return CircularProgressIndicator().center();
        }

        if (uiState.status == Status.ERROR) {
          return genericErrorWidget(error: uiState.errorType);
        }

        final addressList = uiState.data?.addresses ?? [];

        if (addressList.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppImage.svg.noSearchFound, height: 120),
                    20.height,
                    Text(
                      context.appText.noAddressFound,
                      style: AppTextStyle.h5,
                    ),
                    10.height,
                    Text(
                      context.appText.startByAddingANewAddress,
                      style: AppTextStyle.body3,
                    ),
                  ],
                ),
              ).expand(),
              AppButton(
                title: context.appText.addNewAddress,
                onPressed: () async => showAddAddressPopup(context),
              ).paddingSymmetric(horizontal: 20, vertical: 10),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              20.height,
              if (role == 2) ...[
                AppSearchBar(searchController: searchController),
                20.height,
              ],
              ListView.builder(
                itemBuilder: (context, index) {
                  var address = addressList[index];
                  String fullAddress =
                      '${address.addr}, ${address.city}, ${address.state}, ${address.pincode}';
                  return masterInfoWidget(
                    title: address.addrName.capitalizeFirst,
                    address: fullAddress,
                    isPrimary: address.isDefault,
                    onEdit:
                        () => showAddAddressPopup(context, address: address),
                    onDelete:
                        () => deletePopUp(context, address.preferedAddressId),
                    onSetPrimary: () async {
                      await profileCubit.setPrimaryAddress(
                        addressId: address.preferedAddressId,
                      );

                      // Check if it succeeded
                      final primaryState =
                          profileCubit.state.primaryAddressState;
                      if (primaryState != null &&
                          primaryState.status == Status.SUCCESS) {
                        ToastMessages.success(
                          message:
                              context.appText.primaryAddressUpdatedSuccessfully,
                        ); // optional toast
                        profileCubit.fetchAddress(
                          isLoading: false,
                        ); // silent refresh
                      } else {
                        final error = primaryState?.errorType;
                        ToastMessages.error(
                          message: getErrorMsg(
                            errorType: error ?? GenericError(),
                          ),
                        ); // optional toast
                      }
                    },
                  );
                },
                itemCount: addressList.length,
              ).expand(),
              AppButton(
                title: context.appText.addNewAddress,
                onPressed: () async => showAddAddressPopup(context),
              ).paddingSymmetric(vertical: 10),
            ],
          ),
        );
      },
    );
  }

  Widget buildVehicleTab(int role) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final uiState = state.vehicleState;

        if (uiState == null || uiState.status == Status.LOADING) {
          return const Center(child: CircularProgressIndicator());
        }

        if (uiState.status == Status.ERROR) {
          return genericErrorWidget(error: uiState.errorType);
        }

        final vehicleList = uiState.data?.data ?? [];

        if (vehicleList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppImage.svg.noSearchFound, height: 120),
                20.height,
                Text(context.appText.noVehiclesFound, style: AppTextStyle.h5),
                10.height,
                Text(
                  context.appText.startByAddingANewAddress,
                  style: AppTextStyle.body3,
                ),
                20.height,
                AppButton(
                  title: context.appText.addNewVehicle,
                  onPressed: () async {
                    showAddVehiclePopup(context);
                  },
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              20.height,
              if (role == 2) AppSearchBar(searchController: searchController),
              20.height,
              ListView.builder(
                shrinkWrap: true,
                itemCount: vehicleList.length,
                itemBuilder: (context, index) {
                 VehicleDetailsData vehicleDetailsData = vehicleList[index];
                  print("Vehicle id ${vehicleDetailsData.vehicleId}");
                  return masterVehicleInfoWidget(
                     name: vehicleDetailsData.modelNumber,
                  phone:  vehicleDetailsData.ownerName,
                  onEdit: () {
                     showAddVehiclePopup(context,vehcile: vehicleDetailsData);
                  },
                    onDelete:
                        () => deletePopUpForVehicle(context, vehicleDetailsData.vehicleId),
                  
                  );
                },
              ).expand(),
              AppButton(
                title: context.appText.addNewVehicle,
                onPressed: () async => showAddVehiclePopup(context),
              ).paddingSymmetric(vertical: 10),
            ],
          ),
        );
      },
    );
  }
 String formatMobileNumber(String number) {
  if (!number.startsWith("+91") && number.length == 10) {
    return "+91$number";
  }
  return number;
}
   Widget buildDriverTab(int role) {
  return BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context, state) {
      final uiState = state.driverState;

      if (uiState == null || uiState.status == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      }

      if (uiState.status == Status.ERROR) {
        return genericErrorWidget(error: uiState.errorType);
      }

      final driverList = uiState.data?.data ?? [];

      if (driverList.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppImage.svg.noSearchFound, height: 120),
                  20.height,
                  Text(context.appText.noVehiclesFound, style: AppTextStyle.h5),
                  10.height,
                  Text(
                    context.appText.startByAddingANewAddress,
                    style: AppTextStyle.body3,
                  ),
                ],
              ),
            ).expand(),
            AppButton(
              title: "Add New Driver",
              onPressed: () async {
                showAddDriverPopup(context);
              },
            ).paddingSymmetric(horizontal: 20, vertical: 10),
          ],
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            20.height,
            if (role == 2) ...[
              AppSearchBar(searchController: searchController),
              20.height,
            ],
            ListView.builder(
              itemCount: driverList.length,
              itemBuilder: (context, index) {
               DriverDetailsData driver = driverList[index];
                return masterDriverInfoWidget(
                  name: driver.name,
                  phone: driver.mobile,
                  onEdit: () {
                    showAddDriverPopup(context,driver: driver);
                  },
                  onDelete: () => deletePopUpForDriver(context, driver.driverId),
                );
              },
            ).expand(),
            AppButton(
              title: "Add New Driver",
              onPressed: () {
                showAddDriverPopup(context);
              },
            ).paddingSymmetric(vertical: 10),
          ],
        ),
      );
    },
  );
}

  Widget masterInfoWidget({
    required String title,
    required String address,
    required bool isPrimary,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onSetPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: AppTextStyle.h5).expand(),
              IconButton(
                onPressed: onEdit,
                icon: SvgPicture.asset(
                  AppIcons.svg.edit,
                  color: AppColors.primaryColor,
                ),
                splashRadius: 20,
              ),
              IconButton(
                onPressed: onDelete,
                icon: SvgPicture.asset(
                  AppIcons.svg.delete,
                  color: AppColors.iconRed,
                ),
                splashRadius: 20,
              ),
            ],
          ),
          4.height,
          Text(
            address,
            style: AppTextStyle.body3.copyWith(
              color: AppColors.lightGreyTextColor,
            ),
          ),
          15.height,

          InkWell(
            onTap: () => onSetPrimary(),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: commonContainerDecoration(
                    borderColor: AppColors.primaryColor,
                    borderWidth: 2,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child:
                      isPrimary
                          ? Center(child: Icon(Icons.check, size: 15))
                          : const SizedBox(),
                ),
                10.width,
                Text(
                  isPrimary
                      ? context.appText.primaryAddress
                      : context.appText.setAsPrimaryAddress,
                  style: AppTextStyle.body3PrimaryColor.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          10.height,
        ],
      ),
    );
  }
  
  Widget masterDriverInfoWidget({
  required String name,
  required String phone,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Profile Icon
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              child: Icon(Icons.drive_eta, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 10),

            // Name, Verified and Phone Number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Active Tag
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Active",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Delete"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Edit"),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

 Widget masterVehicleInfoWidget({
  required String name,
  required String phone,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Profile Icon
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              child: Icon(Icons.drive_eta, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 10),

            // Name, Verified and Phone Number
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Active Tag
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Active",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Delete"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Edit"),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  void showAddAddressPopup(BuildContext context, {CustomerAddress? address}) {
    final formKey = GlobalKey<FormState>();
    final isEdit = address != null;

    final addressNameController = TextEditingController(
      text: address?.addrName ?? '',
    );
    final addressController = TextEditingController(text: address?.addr ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    final stateController = TextEditingController(text: address?.state ?? '');
    final pinCodeController = TextEditingController(
      text: address?.pincode ?? '',
    );

    AppDialog.show(
      context,
      child: MasterCommonDialogView(
        hideCloseButton: true,
        showYesNoButtonButtons: true,
        yesButtonText: isEdit ? context.appText.update : context.appText.save,
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
                      ? context.appText.editAddress
                      : context.appText.addNewAddress,
                  style: AppTextStyle.h4,
                ),
                20.height,
                _buildTextField(
                  context,
                  addressNameController,
                  context.appText.addressName,
                  alphanumericWithSpaceRegex,
                ),
                16.height,
                _buildTextField(
                  context,
                  addressController,
                  context.appText.address,
                  alphanumericWithSpaceRegex,
                ),
                16.height,
                _buildTextField(
                  context,
                  stateController,
                  context.appText.state,
                  alphabetWithSpaceRegex,
                ),
                16.height,
                _buildTextField(
                  context,
                  cityController,
                  context.appText.city,
                  alphabetWithSpaceRegex,
                ),
                16.height,
                AppTextField(
                  validator: Validator.pincode,
                  controller: pinCodeController,
                  labelText: context.appText.pincode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: iosNumberKeyboard,
                ),
                20.height,
              ],
            ),
          ),
        ),
        onClickYesButton: () async {
          if (formKey.currentState!.validate()) {
            final request = AddressRequest(
              addrName: addressNameController.text.trim(),
              addr: addressController.text.trim(),
              city: cityController.text.trim(),
              state: stateController.text.trim(),
              pincode: pinCodeController.text.trim(),
              isDefault: address?.isDefault ?? false,
            );

            if (isEdit) {
              await profileCubit.updateAddress(
                addressId: address.preferedAddressId,
                request: request,
              );
            } else {
              await profileCubit.createAddress(request: request);
            }

            final state = profileCubit.state.createAddressState;
            if (state?.status == Status.SUCCESS) {
              if (context.mounted) Navigator.pop(context);
              profileCubit.fetchAddress(isLoading: false);
              ToastMessages.success(
                message:
                    isEdit
                        ? context.appText.addressUpdatedSuccessfully
                        : context.appText.addressAddedSuccess,
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
      ),
    );
  }

  void showAddVehiclePopup(BuildContext context, {VehicleDetailsData? vehcile}) {
   
    final formKey = GlobalKey<FormState>();
    final isEdit = vehcile != null;

    final truckNumberController = TextEditingController(text: vehcile?.truckNo ?? '');
    final truckMakeModelController = TextEditingController();
    final rcNumberController = TextEditingController();
    final capacityController = TextEditingController(text: vehcile?.tonnage ?? '');

    AppDialog.show(
      context,
      child: MasterCommonDialogView(
        hideCloseButton: true,
        showYesNoButtonButtons: true,
        yesButtonText: isEdit ? context.appText.update : context.appText.save,
        noButtonText: context.appText.cancel,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? context.appText.editAddress : "Add New Vehicle",
                  style: AppTextStyle.h4,
                ),
                20.height,
                _buildTextField(
                  context,
                  truckNumberController,
                  "Truck Number",
                  alphanumericWithSpaceRegex,
                ),
                16.height,
                _buildTextField(
                  context,
                  truckMakeModelController,
                  "Truck Make and model",
                  alphanumericWithSpaceRegex,
                ),
                16.height,
                _buildTextField(
                  context,
                  rcNumberController,
                  "RC Book Number",
                  alphabetWithSpaceRegex,
                ),
                16.height,
                
                // TrucK Type
             BlocBuilder<GpsVehicleCubit, GpsVehicleState>(
              builder: (context, state) {
                final truckTypesUI = state.truckTypes;
                final truckLengthsUI = state.truckLengths;

                if (truckTypesUI == null || truckTypesUI.status == Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (truckTypesUI.status == Status.ERROR) {
                  return Text("Error loading truck types");
                }
                final truckTypes = truckTypesUI.data ?? [];

                return Column(
                  children: [
                    AppDropdown(
                      labelText: "Truck Type",
                      dropdownValue: selectedTruckType,
                      dropDownList: truckTypes.map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          )).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedTruckType = val;
                          truckLengthDropdownValue = null; // reset truck length on type change
                        });
                        context.read<GpsVehicleCubit>().fetchTruckLengths(val!);
                      },
                      validator: (val) => val == null ? "Select Truck Type" : null,
                    ),
                 const SizedBox(height: 16),
                AppDropdown(
                  labelText: "Truck Length",
                  dropdownValue: truckLengthDropdownValue,
                  dropDownList: (truckLengthsUI != null &&
                          truckLengthsUI.status == Status.SUCCESS &&
                          truckLengthsUI.data != null)
                      ? truckLengthsUI.data!.map((e) => DropdownMenuItem(
                            value: e.subType,
                            child: Text(e.subType),
                          )).toList()
                      : [],
                  hintText: "Select Truck Length",
                  mandatoryStar: true,
                
                  onChanged: (val) {
                    if (truckLengthsUI != null && truckLengthsUI.status == Status.SUCCESS) {
                      setState(() {
                        truckLengthDropdownValue = val;
                      });
                    }
                  },
                  validator: (val) =>
                      val == null || val.isEmpty ? "Select Truck Length" : null,
                ),
                if (truckLengthsUI != null && truckLengthsUI.status == Status.LOADING)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (truckLengthsUI != null && truckLengthsUI.status == Status.ERROR)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("Error loading truck lengths"),
                  ),
              ],
            );
          },
        ),
        Builder(
                  builder: (context) {
                    final state = gpsVehicleCubit.state;
                    
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
                        labelText: context.appText.acceptableCommodities,
                        hintText: context.appText.select,
                        mandatoryStar: true,
                        controller: acceptableCommoditiesController,
                        items: items,
                        onSelectionChange: (selected) {
                           selectedCommodities = selected;
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? context.appText.pleaseSelectCommodity
                            : null,
                        showValidationError: showValidationErrors,
                      );
                    } else if (state.commodities.status == Status.ERROR) {
                      return Text('Error: ${state.commodities.errorType}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
               
        16.height,
                _buildTextField(
                  context,
                  capacityController,
                  "Capacity",
                  alphabetWithSpaceRegex,
                ),
                16.height,
               
                20.height,
              ],
            ),
          ),
        ),
        onClickYesButton: () async {
          if (formKey.currentState!.validate()) {
            final request = VehicleRequest(
              customerId: profileCubit.userId ?? "", // fallback if null
                truckNo: truckNumberController.text.trim(),
                rcNumber: rcNumberController.text.trim(),
                rcDocLink: "https://example.com/rc-book.pdf",
                tonnage: capacityController.text.trim(),
                truckTypeId: int.tryParse(selectedTruckType ?? '') ?? 0,
                truckMakeAndModel: truckMakeModelController.text.trim(),
                acceptableCommodities: selectedCommodities.map(int.parse).toList(),
                truckLength: int.tryParse(selectedTruckLength ?? '') ?? 0,
                vehicleStatus: 1,
            );

            if (isEdit) {
             await profileCubit.updateVehicle(vehicleId: vehcile.vehicleId, request: request);
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
                        ? context.appText.addressUpdatedSuccessfully
                        : context.appText.addressAddedSuccess,
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
      ),
    );
  }

  void showAddDriverPopup(BuildContext context, {DriverDetailsData? driver}) {
    final formKey = GlobalKey<FormState>();
    final isEdit = driver != null;

    final nameController = TextEditingController(text: driver?.name ?? "");
    final licenseNumberController = TextEditingController();
    final mobileController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController(
      text: driver?.companyDetails?.companyName ?? '',
    );
    final cityController = TextEditingController(
      text: driver?.companyDetails?.companyName ?? '',
    );
    final stateController = TextEditingController(
      text: driver?.companyDetails?.companyName ?? '',
    );
    final pinCodeController = TextEditingController(
      text: driver?.companyDetails?.companyName?? '',
    );

    AppDialog.show(
      context,
      child: MasterCommonDialogView(
        hideCloseButton: true,
        showYesNoButtonButtons: true,
        yesButtonText: isEdit ? context.appText.update : context.appText.save,
        noButtonText: context.appText.cancel,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? context.appText.editAddress : "Add New Driver",
                style: AppTextStyle.h4,
              ),
              20.height,
              _buildTextField(
                context,
                nameController,
                "Driver Name",
                alphanumericWithSpaceRegex,
              ),
              16.height,
              _buildTextField(
                context,
                licenseNumberController,
                "License Number",
                alphanumericWithSpaceRegex,
              ),
              16.height,

              ///Possible Delivery date
              InkWell(
                onTap: () async {
                  final String? date = await commonDatePicker(
                    context,
                    firstDate: DateTime.now(),
                    initialDate:
                        DateTimeHelper.convertToDateTimeWithCurrentTime(
                          DateTime.now().toString(),
                        ),
                  );
                  if (!context.mounted) return;
                  final String? time = await commonTimePicker(context);

                  if (date != null && time != null) {}
                },
                child: buildReadOnlyField(
                  context.appText.possibleDeliveryDate,
                  "Licensne",
                  fillColor: Colors.white,
                  mandatoryStar: true,
                ),
              ),
              16.height,

              ///Possible Delivery date
              InkWell(
                onTap: () async {
                  final String? date = await commonDatePicker(
                    context,
                    firstDate: DateTime.now(),
                    initialDate:
                        DateTimeHelper.convertToDateTimeWithCurrentTime(
                          DateTime.now().toString(),
                        ),
                  );
                  if (!context.mounted) return;
                  final String? time = await commonTimePicker(context);

                  if (date != null && time != null) {}
                },
                child: buildReadOnlyField(
                  context.appText.possibleDeliveryDate,
                  "Licensne",
                  fillColor: Colors.white,
                  mandatoryStar: true,
                ),
              ),
              16.height,
              AppTextField(
                validator: Validator.phone,
                controller: mobileController,
                labelText: "Mobile Number",
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                keyboardType: iosNumberKeyboard,
              ),
              16.height,
              AppTextField(
                            labelText: '"Email ID (optional)',
                            hintText: 'example@email.com',
                           controller: emailController,
                            readOnly: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.appText.emailAddressRequired;
                              }
                              // Email validation
                              final emailRegex = emailValidationRegex;
                              if (!emailRegex.hasMatch(value.trim())) {
                                return context.appText.validEmailAddress;
                              }
                              return null;
                            },
                            decoration: commonInputDecoration(
                              hintText: 'example@email.com',
                              fillColor: AppColors.disabledFieldBackgroundColor,
                              focusColor: AppColors.disabledFieldBackgroundColor,
                            ),
                          ),
              
              20.height,
            ],
          ),
        ),
        onClickYesButton: () async {
          if (formKey.currentState!.validate()) {
            final request = DriverRequest(
            customerId: profileCubit.userId ?? "",
            name: nameController.text,
            mobile: formatMobileNumber(mobileController.text.trim()),
            email: emailController.text,
            licenseNumber: licenseNumberController.text,
            licenseDocLink: "https://cdn.example.com/licenses/123.pdf",
            licenseExpiryDate:"2025-12-31T18:30:00.000Z",
            dateOfBirth:"1990-01-01T00:00:00.000Z",
          );
            if (isEdit) {
               await profileCubit.updateDriver(driverId: driver.driverId, request: request);
            } else {
              await profileCubit.createDriver(request: request);
            }

            final state = profileCubit.state.createDriverState;
            if (state?.status == Status.SUCCESS) {
              if (context.mounted) Navigator.pop(context);
              profileCubit.fetchDriver(isLoading: false);
              ToastMessages.success(
                message:
                    isEdit
                        ? context.appText.addressUpdatedSuccessfully
                        : context.appText.addressAddedSuccess,
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
      ),
    );

  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String label,
    RegExp pattern,
  ) {
    return AppTextField(
      validator: (value) => Validator.fieldRequired(value, fieldName: label),
      controller: controller,
      labelText: label,
      inputFormatters: [FilteringTextInputFormatter.allow(pattern)],
    );
  }
}

Widget buildReadOnlyField(
  String label,
  String value, {
  Color? fillColor,
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
          borderColor: AppColors.borderDisableColor,
        ),
        child: Text(value, style: AppTextStyle.textFiled),
      ),
    ],
  );
}
