import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/master/view/master_screen.dart';
import 'package:gro_one_app/features/master/widget/master_addrress_widget.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:lottie/lottie.dart';

class buildAddressTab extends StatefulWidget {
  const buildAddressTab({super.key});

  @override
  State<buildAddressTab> createState() => _buildAddressTabState();
}

class _buildAddressTabState extends State<buildAddressTab> {
  List<String> selectedCommodities = [];
  final profileCubit = locator<ProfileCubit>();
  final vehicleSearchController = TextEditingController();
  final addressSearchController = TextEditingController();
  final driverSearchController = TextEditingController();
  String? selectedTruckType;
  String? selectedTruckLength;
  String? truckLengthDropdownValue;
  bool showValidationErrors = false;
  List<Map<String, dynamic>> vehicleDocList = [];
  String? insuranceValidityDate;
  String? fcExpiryDate;
  String? pucExpiryDate;
  String? registrationDate;
  Timer? addressSearchDebounce;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.height,
        // Search Bar
        AppSearchBar(
          searchController: addressSearchController,
          onChanged: (query) {
            addressSearchDebounce?.cancel();
            addressSearchDebounce = Timer(
              const Duration(milliseconds: 300),
              () {
                profileCubit.fetchAddress(isLoading: false,search: query);
              },
            );
          },
          onClear: () {
            setState(() {
              addressSearchController.text = '';
              addressSearchController.clear();
            });
            profileCubit.fetchAddress(search: '');
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
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<ProfileCubit>().fetchAddress(isLoading: true);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            genericErrorWidget(error: uiState.errorType),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              final addressList = uiState.data?.addresses ?? [];

              final isSearching = addressSearchController.text.isNotEmpty;

              if (addressList.isEmpty) {
                return RefreshIndicator(
                   onRefresh: () async {
                  context.read<ProfileCubit>().fetchAddress(isLoading: true);
                }, 
                  child: isSearching ? Text(context.appText.noSearchResults).center() :
                  ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
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
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  // Reset page count if you are paginating
                  context.read<ProfileCubit>().fetchAddress(isLoading: true);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  itemBuilder: (context, index) {
                    var address = addressList[index];
                    String fullAddress =
                        '${address.addr}, ${address.city}, ${address.state}, ${address.pincode}';
                    return masterInfoWidget(
                      context: context,
                      title: address.addrName.capitalizeFirst,
                      address: fullAddress,
                      isPrimary: address.isDefault,
                      onEdit:
                          () => showAddAddressPopup(context, address: address),
                      onDelete:
                          () => showDeletePopUp(
                            context: context,
                            confirmMessage:
                                context.appText.areYouSureToDeleteThisAddress,
                            successMessage:
                                context.appText.addressDeletedSuccessfully,
                            onDelete:
                                () => profileCubit.deleteAddress(
                                  addressId: address.preferedAddressId,
                                ),
                          ),
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
                                context
                                    .appText
                                    .primaryAddressUpdatedSuccessfully,
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
                ),
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
        20.height,
      ],
    );
  }

  /// Add Address Popup
  void showAddAddressPopup(BuildContext context, {CustomerAddress? address}) {
    final formKey = GlobalKey<FormState>();
    final isEdit = address != null;

    final addressNameController = TextEditingController(
      text: address?.addrName ?? '',
    );
    final addressController = TextEditingController(text: address?.addr ?? '');
    final pinCodeController = TextEditingController(
      text: address?.pincode ?? '',
    );
    String? selectedState = address?.state;
    String? selectedCity = address?.city;

    AppDialog.show(
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
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
                    StateDropdown(
                      selected: selectedState,
                      onStateChanged: (value) {
                        setState(() {
                          selectedState = value;
                          selectedCity = null;
                          print("selected state is ${selectedCity}");
                        });
                      },
                    ),
                    16.height,
                    CityDropdown(
                      selected: selectedCity,
                      isStateSelected:
                          selectedState != null && selectedState!.isNotEmpty,
                      onCityChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
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
                final existingAddresses =
                    profileCubit.state.addressState?.data?.addresses ?? [];
                final request = AddressRequest(
                  addrName: addressNameController.text.trim(),
                  addr: addressController.text.trim(),
                  city: selectedCity ?? "",
                  state: selectedState ?? "",
                  pincode: pinCodeController.text.trim(),
                  isDefault:
                      isEdit ? address.isDefault : existingAddresses.isEmpty,
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
      inputFormatters: [
        FilteringTextInputFormatter.allow(pattern),
        LengthLimitingTextInputFormatter(100),
      ],
    );
  }
}
