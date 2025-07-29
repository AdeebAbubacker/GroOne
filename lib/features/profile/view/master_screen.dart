import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_state.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/driver_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/features/profile/model/driver_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/model/vehicle_verification_success.dart';
import 'package:gro_one_app/features/profile/view/widgets/master_dialogue_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/driver_list_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_recent_load_response.dart';
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
import 'package:gro_one_app/utils/global_variables.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';
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
  final vehicleSearchController = TextEditingController();
  final addressSearchController = TextEditingController();
  final driverSearchController = TextEditingController();
  Timer? vehicleSearchDebounce;
  Timer? addressSearchDebounce;
  Timer? driverSearchDebounce;

  String? selectedTruckType;
  String? selectedTruckLength;
  String? truckLengthDropdownValue;
  bool showValidationErrors = false;
  List<Map<String, dynamic>> vehicleDocList = [];

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
    vpCreationCubit.fetchTruckType();
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
              Navigator.of(context).pop(); 
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
            Text(context.appText.areYouSureToDeleteThisVehicle).center(),
          ],
        ),
        onClickYesButton: () async {
          final result = await profileCubit.deleteVehicle(vehicleId: vehicleId,request: DeleteVehicleRequest(status: 3));

          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop(); 
              ToastMessages.success(
                message: context.appText.vehicleDeletedSuccessfully,
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
            Text(context.appText.areYouSureToDeleteThisDriver).center(),
          ],
        ),
        onClickYesButton: () async {
          final result = await profileCubit.deleteDriver(driverId: addressId);

          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop();
              ToastMessages.success(
                message: context.appText.driverDeletedSuccessfully,
              );
            }
          } else if (result is Error) {
            ToastMessages.error(message: getErrorMsg(errorType: result.type));
          }
        },
      ),
    );
  }
  
   /// Upload RC book
   Future<Result<bool>> _uploadRCBookCall(
    BuildContext context,
    List<Map<String, dynamic>> multiFilesList,
  ) async {
    final cubit = context.read<ProfileCubit>();
    await cubit.uploadVehicleDoc(File(multiFilesList.first['path']));
    final status = cubit.state.vehicleDocUpload!.status;

    if (status == Status.SUCCESS) {
      final url = cubit.state.vehicleDocUpload!.data?.data?.url ?? '';
      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    } else if (status == Status.ERROR) {
      final errorType = cubit.state.vehicleDocUpload!.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  /// Upload License Copy
   Future<Result<bool>> _uploadLicenseCopy(
    BuildContext context,
    List<Map<String, dynamic>> multiFilesList,
  ) async {
    final cubit = context.read<ProfileCubit>();
    await cubit.uploadLicenseDoc(File(multiFilesList.first['path']));
    final status = cubit.state.vehicleDocUpload!.status;

    if (status == Status.SUCCESS) {
      final url = cubit.state.vehicleDocUpload!.data?.data?.url ?? '';
      if (url.isNotEmpty) {
        multiFilesList.first['path'] = url;
        ToastMessages.success(message: 'File uploaded successfully');
        return Success(true);
      }
    } else if (status == Status.ERROR) {
      final errorType = cubit.state.vehicleDocUpload!.errorType;
      ToastMessages.error(
        message: getErrorMsg(errorType: errorType ?? GenericError()),
      );
    }
    return Error(GenericError());
  }

  @override
  Widget build(BuildContext context) {
    int? role = profileCubit.userRole;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CommonAppBar(
        scrolledUnderElevation: 0,
        backgroundColor:  Colors.transparent,
        title: Text(
          context.appText.masters,
          style: AppTextStyle.textBlackColor18w500,
        ),
      ),
      body: Column(
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
                        buildAddressTab(),
                        buildVehicleTab(),
                        buildDriverTab(),
                      ],
                    ),
                  ),
                ],
              )
              
    );
  }

  Widget buildAddressTab() {
    return Column(
      children: [
        20.height,
      // Search Bar 
      AppSearchBar(
        searchController: addressSearchController,
        onChanged: (query) {
          addressSearchDebounce?.cancel();
          addressSearchDebounce = Timer(const Duration(milliseconds: 300), () {
            profileCubit.fetchAddress(search: query);
          });
        },
      ).paddingSymmetric(horizontal: 20),
        Expanded(
          child: BlocBuilder<ProfileCubit, ProfileState>(
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
                    ),             
                  ],
                );
              }
          
              return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              );
            },
          ),
        ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: AppButton(
          title: context.appText.addNewAddress,
          onPressed: () => showAddAddressPopup(context),
        ),
      ),
      ],
    );
  }
 
  Widget buildVehicleTab() {
    return Column(
      children: [
        20.height,
        // Search Bar 
        AppSearchBar(
          searchController: vehicleSearchController,
          onChanged: (query) {
            vehicleSearchDebounce?.cancel();
            vehicleSearchDebounce = Timer(const Duration(milliseconds: 300), () {
              profileCubit.fetchVehicle(search: query);
            });
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
                return genericErrorWidget(error: uiState.errorType);
              }

              final vehicleList = uiState.data?.data ?? [];
                          final List<VehicleDetailsData> filteredVehicleList =
                  vehicleList.where((v) => v.status == 1).toList();

              if (filteredVehicleList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppImage.svg.noSearchFound, height: 120),
                      20.height,
                      Text(context.appText.noVehiclesFound, style: AppTextStyle.h5),
                      10.height,
                      Text(context.appText.startByAddingANewVehicle, style: AppTextStyle.body3),
                    ],
                  ),
                );
              }



              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: filteredVehicleList.length,
                itemBuilder: (context, index) {
                  final vehicleDetailsData = filteredVehicleList[index];
                  return masterVehicleInfoWidget(
                    name: vehicleDetailsData.truckNo,
                    phone: vehicleDetailsData.companyName ?? '',
                    driverStatus: vehicleDetailsData.status,
                    onEdit: () => showAddVehiclePopup(context, vehcile: vehicleDetailsData),
                    onDelete: () => deletePopUpForVehicle(context, vehicleDetailsData.vehicleId),
                    context: context,
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: AppButton(
            title: context.appText.addNewVehicle,
            onPressed: () => showAddVehiclePopup(context),
          ),
        ),
      ],
    );
  }

  String formatMobileNumber(String number) {
    if (!number.startsWith("+91") && number.length == 10) {
      return "+91$number";
    }
    return number;
  }

   Widget buildDriverTab() {
    return Column(
      children: [
        20.height,
        // Search Bar 
        AppSearchBar(
          searchController: driverSearchController,
          onChanged: (query) {
            driverSearchDebounce?.cancel();
            driverSearchDebounce = Timer(const Duration(milliseconds: 300), () {
              profileCubit.fetchDriver(search: query);
            });
          },
        ).paddingSymmetric(horizontal: 20),
        Expanded(
          child: BlocBuilder<ProfileCubit, ProfileState>(
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
                          Text(context.appText.noDriversfound, style: AppTextStyle.h5),
                          10.height,
                          Text(
                            context.appText.startByAddingANewDriver,
                            style: AppTextStyle.body3,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
          
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      itemCount: driverList.length,
                      itemBuilder: (context, index) {
                      DriverDetailsData driver = driverList[index];                    
                        return masterDriverInfoWidget(
                          name: driver.name,
                          phone: driver.mobile,
                          driverStatus: driver.driverStatus,
                          onEdit: () {
                            showAddDriverPopup(context,driver: driver);
                          },
                      
                          onDelete: () => deletePopUpForDriver(context, driver.driverId),
                        context: context);
                        },
                        );
                      },
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: AppButton(
                  title: context.appText.addNewDriver,
                  onPressed: () => showAddDriverPopup(context),
                ),
              ),
            ],
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
    required int driverStatus,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required BuildContext context,
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
                child: SvgPicture.asset( AppIcons.svg.truckSteering)
              ),
              10.width,

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
                        6.width,
                      SvgPicture.asset( AppIcons.svg.tick)
                      ],
                    ),
                    4.height,
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
                  color:  driverStatus == 1 ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  driverStatus == 1 ?context.appText.active : context.appText.inactive,
                  style:  AppTextStyle.body.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color:driverStatus==1? Color(0XFF0E6027): Color(0XFFE31B25),
                        ),
                ),
              ),
            ],
          ),
          16.height,
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButton(
                buttonHeight: commonButtonHeight2,
                style: AppButtonStyle.logout,
                isLoading: false,
                onPressed: onDelete,
                title: context.appText.delete,
                textStyle: TextStyle(color: Colors.red),
              ).expand(),
              16.width,

              // Yes Button
              AppButton(
                buttonHeight: commonButtonHeight2,
                style: AppButtonStyle.outline,
                isLoading: false,
                onPressed: onEdit,
                title: context.appText.edit,
              ).expand(),

            ],
          ),
        ],
      ),
    );
  }

  Widget masterVehicleInfoWidget({
    required String name,
    required String phone,
    required int driverStatus,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required BuildContext context,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Icon
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade50,
                child: SvgPicture.asset( AppIcons.svg.truck,color: AppColors.primaryColor)
              ),
              10.width,

              // Name, Verified and Phone Number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    4.height,
                    Row(
                      children: [
                        Text(
                          name,
                          style: AppTextStyle.body.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.textBlackDetailColor,
                        ),
                        ),
                        6.width,
                        SvgPicture.asset( AppIcons.svg.tick)
                      ],
                    ),
                    4.height,
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
                child: Text(
                  context.appText.active,
                  style: AppTextStyle.body.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color:driverStatus==1? Color(0XFF0E6027): Color(0XFFE31B25),
                        ),
                ),
              ),
            ],
          ),
          16.height,

          // Action Buttons
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButton(
                buttonHeight: commonButtonHeight2,
                style: AppButtonStyle.logout,
                isLoading: false,
                onPressed: onDelete,
                title: context.appText.delete,
                textStyle: TextStyle(color: Colors.red),
              ).expand(),
              16.width,

              // Yes Button
              AppButton(
                buttonHeight: commonButtonHeight2,
                style: AppButtonStyle.outline,
                isLoading: false,
                onPressed: onEdit,
                title: context.appText.edit,
              ).expand(),

            ],
          ),
        ],
      ),
    );
  }
  
  Widget buildVehicleVerificationFieldWidget({required TextEditingController vehicleNoController,required void Function(bool) onVerificationResult,}) {
  return BlocConsumer<ProfileCubit, ProfileState>(
    bloc: profileCubit,
    listenWhen: (previous, current) =>
        previous.vehicleVerificationState != current.vehicleVerificationState,
    listener: (context, state) {
              final s = state.vehicleVerificationState;      
              final status = s?.status;
          
              if (status == Status.SUCCESS) {
                 ToastMessages.success(message: context.appText.vehicleRegNoVerified);
                  onVerificationResult(true);
              } else if (status == Status.ERROR) {
                 ToastMessages.error(message: context.appText.vehicleRegNoAlreadyExcist);
                  onVerificationResult(false);
              }
            },
          builder: (context, state) {
            return AppTextField(
              validator: (value) => Validator.fieldRequired(value),
              controller: vehicleNoController,
              labelText: "Vehicle reg no",
              mandatoryStar: true,
              keyboardType: TextInputType.text,
              decoration: commonInputDecoration(
                hintText: "Enter vehicle reg no",
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      (state.vehicleVerificationState?.status == Status.LOADING)
                          ? "Verifying..."
                          : "Verify",
                      style: AppTextStyle.body3.copyWith(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
          suffixOnTap: () {
            final String? validation = Validator.fieldRequired(vehicleNoController.text);
            if (validation == null) {
              profileCubit.fetchVehicleExcistence(
                vehicleId: vehicleNoController.text.trim(),
              );
            } else {
              ToastMessages.alert(message: validation);
            }
          },
        ),
      );
    },
  );
}
 
  Widget buildLicenseVerificationFieldWidget({required TextEditingController licenseNoController,required void Function(bool) onVerificationResult,}) {
  return BlocConsumer<ProfileCubit, ProfileState>(
    bloc: profileCubit,
    listenWhen: (previous, current) =>
        previous.licenseVerficationState != current.licenseVerficationState,
    listener: (context, state) {
              final s = state.licenseVerficationState;          
              final status = s?.status;
          
              if (status == Status.SUCCESS) {
                ToastMessages.success(message:  context.appText.licenseNoVerified);
                onVerificationResult(true);
                 
              } else if (status == Status.ERROR) {
             final error = state.licenseVerficationState?.errorType;
             ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
              onVerificationResult(false);

              }
            },
    builder: (context, state) {
      return AppTextField(
        validator: (value) => Validator.fieldRequired(value),
        controller: licenseNoController,
        labelText: "License No",
        mandatoryStar: true,
        keyboardType: TextInputType.text,
        decoration: commonInputDecoration(
          hintText: "Enter License No",
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                    (state.licenseVerficationState?.status == Status.LOADING)
                          ? "Verifying..."
                          : "Verify",
                      style: AppTextStyle.body3.copyWith(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                      ),
                    ),
            ],
          ),
          suffixOnTap: () {
            final String? validation = Validator.fieldRequired(licenseNoController.text);
            if (validation == null) {
              profileCubit.fetchLicenseExcistence(
                licenseNo: licenseNoController.text.trim(),
              );
            } else {
              ToastMessages.alert(message: validation);
            }
          },
        ),
      );
    },
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
     bool isVehicleVerified = vehcile != null;
    final formKey = GlobalKey<FormState>();
    final isEdit = vehcile != null;
    bool isVehicleActive = vehcile != null ? (vehcile.status == 1) : true;
    final truckNumberController = TextEditingController(text: vehcile?.truckNo ?? '');
    final truckMakeModelController = TextEditingController(text: vehcile?.modelNumber ?? '');
    final rcNumberController = TextEditingController();
    final capacityController = TextEditingController(text: vehcile?.tonnage ?? '');
    TruckTypeModel? selectedTruckType;
   

    MasterDialogueWidget.show(
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
          List<Map<String, dynamic>> localVehicleDocList = List.from(vehicleDocList);
      final vehicleDocUpload = context.watch<ProfileCubit>().state.vehicleDocUpload;
      final isUploading = vehicleDocUpload?.status == Status.LOADING;
          return MasterCommonDialogView(
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
                      isEdit ? context.appText.editVehicle :context.appText.addNewVehicle ,
                      style: AppTextStyle.h4,
                    ),
                    20.height,
                    buildVehicleVerificationFieldWidget(vehicleNoController:  truckNumberController,onVerificationResult: (value) {
                      setState(() {
                        isVehicleVerified = value;
                      });
                    },),
                    16.height,
                    AppTextField(
                    readOnly: isVehicleVerified ? false : true,
                    validator: (value) => Validator.fieldRequired(value),
                    controller: truckMakeModelController,
                    labelText: context.appText.truckMakeAndModel,
                    hintText:  context.appText.truckMakeAndModel,
                    mandatoryStar: true,
                  ),
                    16.height,
                    AppTextField(
                    readOnly: isVehicleVerified ? false : true,
                    validator: (value) => Validator.fieldRequired(value),
                    controller: rcNumberController,
                    labelText:  context.appText.rcBook,
                    hintText:   context.appText.rcBook,
                    mandatoryStar: true,
                  ),
                    16.height,
                    // Upload RC Book
                      UploadAttachmentFiles(
                      multiFilesList: localVehicleDocList,
                      isSingleFile: true,
                      isLoading: isUploading,
                      thenUploadFileToSever: () async {
                        final result = await _uploadRCBookCall(context, localVehicleDocList);
                        if (result is Success) {
                          setState(() {
                            // Update the persistent vehicleDocList field in State class as well if needed
                            vehicleDocList.clear();
                            vehicleDocList.addAll(localVehicleDocList);
                          });
                        }
                      },
                    ),
                     16.height,
                    // TrucK Type
                   BlocBuilder<VpCreateAccountCubit, VpCreateAccountState>(
                builder: (context, state) {
                  final truckTypeUIState = state.truckTypeUIState;

                  if (truckTypeUIState == null || truckTypeUIState.status == Status.LOADING) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (truckTypeUIState.status == Status.ERROR) {
                    return const Text("Error loading truck types");
                  }

                  final truckTypeList = truckTypeUIState.data ?? [];

                            return AppDropdown(
                          enabled: isVehicleVerified,
                          labelText: context.appText.truckType,
                          dropdownValue: selectedTruckType == null
                              ? null
                              : "${selectedTruckType!.type} - ${selectedTruckType!.subType}",
                          dropDownList: truckTypeList.map((truckType) {
                            final label = "${truckType.type} - ${truckType.subType}";
                            return DropdownMenuItem<String>(
                              value: label,
                              child: Text(label),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedTruckType = truckTypeList.firstWhere(
                                (e) => "${e.type} - ${e.subType}" == val,
                              );
                            });
                          },
                          validator: (val) => val == null ? "Select Truck Type" : null,
                        );
                    },
                  ),
                  16.height,
                  AppTextField(
                    readOnly: isVehicleVerified ? false : true,
                    validator: (value)=> Validator.fieldRequired(value),
                    controller: capacityController,
                    labelText: context.appText.capacity,
                    hintText: "2",
                  ),
                   16.height,   
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
                    /// Active Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.appText.active),
                    Switch(
                      value: isVehicleActive,
                      onChanged: isVehicleVerified
                      ? (val) => setState(() => isVehicleActive = val)
                      : null,
                    ),
                  ],
                ),
                    20.height,
                  ],
                ),
              ),
            ),
            onClickYesButton: () async {
              if (formKey.currentState!.validate()) {
                final rcDocLink = vehicleDocList.isNotEmpty ? vehicleDocList.first['path'] : '';
                final request = VehicleRequest(
                  customerId: profileCubit.userId ?? "", 
                    truckNo: truckNumberController.text.trim(),
                    rcNumber: rcNumberController.text.trim(),
                    rcDocLink: rcDocLink,
                    tonnage: capacityController.text.trim(),
                    truckTypeId: selectedTruckType?.id ?? 1,
                    truckMakeAndModel: truckMakeModelController.text.trim(),
                    acceptableCommodities: selectedCommodities.map(int.parse).toList(),
                    truckLength: 1,
                    vehicleStatus:  isVehicleActive ? 1 : 2
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
          );
        }
      ),
    );
  }
 
  Map<String, dynamic>? createFileFromLink(String url) {
  if (url.trim().isEmpty) return null;

  final uri = Uri.parse(url);
  if (uri.pathSegments.isEmpty) return null;

  final fileName = uri.pathSegments.last;
  final extension = fileName.split('.').last;

  return {
    "fileName": fileName,
    "path": url,
    "extension": extension,
  };
}


  void showAddDriverPopup(BuildContext context, {DriverDetailsData? driver}) {
   bool isLicenseVerified = driver != null;

    final formKey = GlobalKey<FormState>();
    final isEdit = driver != null;
   String? selectedDate = driver?.licenseExpiryDate != null
    ? DateFormat('dd/MM/yyyy').format(driver!.licenseExpiryDate!)
    : null;

    String? selectedDoB = driver?.dateOfBirth != null
        ? DateFormat('dd/MM/yyyy').format(driver!.dateOfBirth!)
        : null;
    final nameController = TextEditingController(text: driver?.name ?? "");
    final licenseNumberController = TextEditingController(text: driver?.licenseNumber ?? "");
    final mobileController = TextEditingController(text: driver?.mobile?.replaceFirst('+91', '') ?? "",);
    final emailController = TextEditingController(text: driver?.email ?? "");
    final localVehicleDocList = <Map<String, dynamic>>[];

    if (driver?.licenseDocLink != null && driver!.licenseDocLink!.isNotEmpty) {
      final doc = createFileFromLink(driver.licenseDocLink!);
      if (doc != null) {
        localVehicleDocList.add(doc);
      }
    }
    bool isInitialized = false;
    bool isActive = driver != null ? (driver.driverStatus == 1) : true;
    MasterDialogueWidget.show(
      context,
      child: StatefulBuilder(
       builder: (BuildContext context, void Function(void Function()) setState) {   
      final vehicleDocUpload = context.watch<ProfileCubit>().state.vehicleDocUpload;
      final isUploading = vehicleDocUpload?.status == Status.LOADING;
    

      if (!isInitialized && driver?.licenseDocLink?.isNotEmpty == true) {
                final doc = createFileFromLink(driver!.licenseDocLink!);
                if (doc != null) {
                  localVehicleDocList
                    ..clear()
                    ..add(doc);
                  vehicleDocList
                    ..clear()
                    ..add(doc);
                }
                isInitialized = true;
              }

          return MasterCommonDialogView(
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
                    isEdit ? context.appText.editDriver : context.appText.addNewDriver,
                    style: AppTextStyle.h4,
                  ),
                  20.height,
                  buildLicenseVerificationFieldWidget(licenseNoController: licenseNumberController,onVerificationResult: (value) {
                  setState(() {
                    isLicenseVerified = value;
                  });
                },),
                  16.height,
                  AppTextField(
                    readOnly: isLicenseVerified ? false : true,
                    validator: (value) => Validator.fieldRequired(value),
                    controller: nameController,
                    labelText:  context.appText.driverName,
                    hintText:   context.appText.driverName,
                    mandatoryStar: true,
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                  ),
                 
                  16.height,
          
                  ///License Expiry date
                  InkWell(                   
                    onTap: isLicenseVerified ? () async {
                       final DateTime today = DateTime.now();
                      final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: today, 
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  setState(() {
                    selectedDate = formattedDate;
                  });
                }
                    } : null,
                    child: buildReadOnlyField(
          
                      context.appText.licenseExpiryDate,
                      selectedDate ?? 'Select date',
                      fillColor: Colors.white,
                      mandatoryStar: true,
                    ),
                  ),
                  16.height,
          
                  ///Date of Birth
                  InkWell(
                    onTap: isLicenseVerified? () async {
                      final DateTime today = DateTime.now();
                      final DateTime eighteenYearsAgo = DateTime(today.year - 18, today.month, today.day);

                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: eighteenYearsAgo,
                        firstDate: DateTime(1900),     
                        lastDate: eighteenYearsAgo,   
                      );

                      if (pickedDate != null) {
                        final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                        setState(() {
                          selectedDoB = formattedDate;
                        });
                      }
                    }
                    :null, 
                    child: buildReadOnlyField(
                      context.appText.dateOdBirth,
                      selectedDoB ?? 'DOB',
                      fillColor: Colors.white,
                      mandatoryStar: true,
                    ),
                  ),

                  
                  16.height,
                  UploadAttachmentFiles(
                  multiFilesList: localVehicleDocList,
                  isSingleFile: true,
                  isLoading: isUploading,
                  thenUploadFileToSever: () async {
                    final result = await _uploadLicenseCopy(context, localVehicleDocList);
                    if (result is Success) {
                      setState(() {                    
                        vehicleDocList.clear();
                        vehicleDocList.addAll(localVehicleDocList);
                      });
                    }
                  },
                ),
                 16.height,
                  AppTextField(
                  readOnly:isLicenseVerified? false : true,
                  controller: mobileController,
                  labelText: context.appText.mobileNumber,
                  hintText: context.appText.mobileNumber,
                  mandatoryStar: true,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => Validator.positiveNumber(
                    value,
                    fieldName: context.appText.mobileNumber,
                  ),
                ),
                  16.height,
                  AppTextField(
                  readOnly:isLicenseVerified? false : true,
                  labelText: '${context.appText.emailId}(optional)',
                                hintText: 'example@email.com',
                               controller: emailController,                            
                                validator: (value) {                     
                                },
                                decoration: commonInputDecoration(
                                  hintText: 'example@email.com',                         
                                ),
                              ),
                  
                  20.height,
                   /// Active Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.appText.active),
                    Switch(
                      value: isActive,
                      onChanged: isLicenseVerified
                      ? (val) => setState(() => isActive = val)
                      : null,
                    ),
                  ],
                ),
                ],
              ),
            ),
            onClickYesButton: () async {
              if (formKey.currentState!.validate()) {
                final licenseExpiryIso = selectedDate != null
                  ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                      .format(DateFormat('dd/MM/yyyy').parse(selectedDate!))
                  : null;

              final dateOfBirthIso = selectedDoB != null
                  ? DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                      .format(DateFormat('dd/MM/yyyy').parse(selectedDoB!))
                  : null;
                final rcDocLink = localVehicleDocList.isNotEmpty ? localVehicleDocList.first['path'] : '';

                final request = DriverRequest(
                customerId: profileCubit.userId ?? "",
                name: nameController.text,
                mobile: formatMobileNumber(mobileController.text.trim()),
                email: emailController.text,
                licenseNumber: licenseNumberController.text,
                licenseDocLink: rcDocLink,
                licenseExpiryDate: licenseExpiryIso ?? '',
               dateOfBirth: dateOfBirthIso ?? '',
                driverStatus: isActive ? 1 : 2
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
                            ? context.appText.driverUpdatedSuccessfully
                            : context.appText.driverAddedSuccess,
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
          );
        }
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
