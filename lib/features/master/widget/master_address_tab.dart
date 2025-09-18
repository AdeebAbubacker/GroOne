import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/kyc/model/city_model.dart';
import 'package:gro_one_app/features/kyc/model/state_model.dart';
import 'package:gro_one_app/features/master/widget/master_addrress_widget.dart';
import 'package:gro_one_app/features/profile/api_request/address_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/address_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/model/searchable_dropdown_menu_item.dart';
import 'package:gro_one_app/utils/app_dropdown_paginated/searchable_dropdown.dart';
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
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:lottie/lottie.dart';

class BuildAddressTab extends StatefulWidget {
  const BuildAddressTab({super.key});

  @override
  State<BuildAddressTab> createState() => _BuildAddressTabState();
}

class _BuildAddressTabState extends State<BuildAddressTab> {
  List<String> selectedCommodities = [];
  final profileCubit = locator<ProfileCubit>();
  final kycCubit = locator<KycCubit>();
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
  final _addressScrollController = ScrollController();
  String? selectedStateData;

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  void initFunction() => frameCallback(() async {
    await profileCubit.fetchAddress();
  });

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
                profileCubit.fetchAddress(isLoading: false, search: query);
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
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            genericErrorWidget(error: uiState.errorType),
                          ],
                        ).center(),
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
                  child:
                      isSearching
                          ? Text(context.appText.noSearchResults).center()
                          : ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              context
                                                  .appText
                                                  .startByAddingANewAddress,
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
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      profileCubit.fetchAddress(
                        isLoading: false,
                        isInit: false,
                      );
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _addressScrollController,
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
                            () =>
                                showAddAddressPopup(context, address: address),
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
                            ); 
                            profileCubit.fetchAddress(
                              isLoading: true,
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
      ],
    );
  }

  /// Add Address Popup
  void showAddAddressPopup(BuildContext context, {CustomerAddress? address}) async{
    final formKey = GlobalKey<FormState>();
    final isEdit = address != null;
    if (isEdit) {
    await kycCubit.fetchStateList(search: address.state);
    await kycCubit.fetchCityList(address.state,search: address.city);
    }

    final addressNameController = TextEditingController(
      text: address?.addrName ?? '',
    );
    final addressController = TextEditingController(text: address?.addr ?? '');
    final pinCodeController = TextEditingController(
      text: address?.pincode ?? '',
    );
    String? selectedState = address?.state;
    String? selectedCity = address?.city;
    String? selectedStateId = address?.stateId.toString();
    String? selectedCityId = address?.cityId.toString();
    AppDialog.show(
      context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return MasterCommonDialogView(
            isAddress: true,
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
                    FormField<String>(
                    initialValue: selectedStateId,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return context.appText.stateisRequired;
                      }
                      return null;
                    },
                      builder: (field) {
                        if ((field.value == null || field.value!.isEmpty) &&
                        (selectedStateId != null && selectedStateId!.isNotEmpty)) {
                         field.didChange(selectedStateId);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StateDropdown(
                              selectedStateId: selectedStateId,
                              onStateChanged: (value) {
                                setState(() {
                                  selectedStateId = value?.id.toString();
                                  selectedState = value?.name.toString();
                                  selectedStateData = value?.name.toString();
                                  selectedCity = null;
                                });
                                 field.didChange(value?.id.toString());
                              },
                            ),
                            if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 8),
                              child: Text(
                                field.errorText!,
                                style: AppTextStyle.textFieldHintRedColor,
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                    16.height,
                    FormField<String>(
                    initialValue: selectedCityId,  
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return context.appText.cityisRequired;
                      }
                      return null;
                    },
                      builder: (field) {
                        if ((field.value == null || field.value!.isEmpty) &&
                        (selectedCityId != null && selectedCityId!.isNotEmpty)) {
                        field.didChange(selectedCityId);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CityDropdown(
                              selectedState: selectedState,
                              selectedCityId: selectedCityId,
                              isStateSelected:
                                  selectedState != null && selectedState!.isNotEmpty,
                              onCityChanged: (value) {
                                setState(() {
                                  selectedCityId = value?.id.toString(); 
                                  selectedCity = value?.city.toString();
                                });
                                field.didChange(value?.id.toString());
                              },
                            ),
                            if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 8),
                              child: Text(
                                field.errorText!,
                                style: AppTextStyle.textFieldHintRedColor,
                              ),
                            ),
                          ],
                        );
                      }
                    ),
                    16.height,
                    AppTextField(
                      mandatoryStar: true,
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
                  profileCubit.fetchAddress(isLoading: true);
                  if (!context.mounted) return;
                  Navigator.pop(context);
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
            profileCubit.fetchAddress(isLoading: true);
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
      mandatoryStar: true,
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

/// State Dropdown
class StateDropdown extends StatelessWidget {
  final String? selectedStateId;
  final ValueChanged<StateModelList?> onStateChanged;

  const StateDropdown({
    super.key,
    required this.selectedStateId,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final stateCubit = context.read<KycCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.appText.state, style: AppTextStyle.textFiled),
            const SizedBox(width: 2),
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: SearchableDropdown<StateModelList>.paginated(
            hintText: Text(
              context.appText.selectState,
              style: AppTextStyle.textFieldHint,
            ),
            isDialogExpanded: false,
            requestItemCount: 10,

            // Initial selected value
            initialValue:
                selectedStateId != null
                    ? SearchableDropdownMenuItem<StateModelList>(
                      value: stateCubit.state.stateUIState?.data
                          ?.firstWhereOrNull(
                            (e) => e.id.toString() == selectedStateId,
                          ),
                      label:
                          stateCubit.state.stateUIState?.data
                              ?.firstWhereOrNull(
                                (e) => e.id.toString() == selectedStateId,
                              )
                              ?.name ??
                          '',
                      child: Text(
                        stateCubit.state.stateUIState?.data
                                ?.firstWhereOrNull(
                                  (e) => e.id.toString() == selectedStateId,
                                )
                                ?.name ??
                            '',
                      ),
                    )
                    : null,

            // Pagination request
            paginatedRequest: (int page, String? searchKey) async {
              await stateCubit.fetchStateList(
                search: searchKey,
                loadMore: page > 1,
              );
              final stateList = stateCubit.state.stateUIState?.data ?? [];
              return stateList.map((state) {
                return SearchableDropdownMenuItem<StateModelList>(
                  value: state,
                  label: state.name,
                  child: Text(state.name),
                );
              }).toList();
            },

            onChanged: (StateModelList? newState) {
              // Pass the ID to parent callback
              onStateChanged(newState);
              if (newState != null) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  context.read<KycCubit>().fetchCityList(newState.name);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

/// City Dropdown
class CityDropdown extends StatefulWidget {
  final String? selectedCityId;
  final String? selectedState;
  final bool isStateSelected;
  final ValueChanged<CityModelList?> onCityChanged;

  const CityDropdown({
    super.key,
    required this.selectedCityId,
    required this.selectedState,
    required this.isStateSelected,
    required this.onCityChanged,
  });
  
  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  @override
  void initState() {
    super.initState();

    // Preload city list if state + cityId are already given
    if (widget.selectedState != null && widget.selectedCityId != null) {
      Future.microtask(() {
        context.read<KycCubit>().fetchCityList(
              widget.selectedState!,
            );
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final kycCubit = context.read<KycCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.appText.city, style: AppTextStyle.textFiled),
            const SizedBox(width: 2),
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AbsorbPointer(
          absorbing: !widget.isStateSelected,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: SearchableDropdown<CityModelList>.paginated(
              hintText: Text(
                context.appText.selectCity,
                style: AppTextStyle.textFieldHint,
              ),
              isDialogExpanded: false,
              requestItemCount: 10,

              // Initial selected value
              initialValue:
                  widget.selectedCityId != null
                      ? SearchableDropdownMenuItem<CityModelList>(
                        value: kycCubit.state.cityUIState?.data
                            ?.firstWhereOrNull(
                              (e) => e.id.toString() == widget.selectedCityId,
                            ),
                        label:
                            kycCubit.state.cityUIState?.data
                                ?.firstWhereOrNull(
                                  (e) =>
                                      e.id.toString() == widget.selectedCityId,
                                )
                                ?.city ??
                            '',
                        child: Text(
                          kycCubit.state.cityUIState?.data
                                  ?.firstWhereOrNull(
                                    (e) =>
                                        e.id.toString() ==
                                        widget.selectedCityId,
                                  )
                                  ?.city ??
                              '',
                        ),
                      )
                      : null,

              // Pagination request
              paginatedRequest: (int page, String? searchKey) async {
                if (widget.selectedState != null) {
                  await kycCubit.fetchCityList(
                    widget.selectedState!,
                    search: searchKey,
                    loadMore: page > 1,
                  );
                }

                final cityList = kycCubit.state.cityUIState?.data ?? [];
                return cityList.map((city) {
                  return SearchableDropdownMenuItem<CityModelList>(
                    value: city,
                    label: city.city,
                    child: Text(city.city),
                  );
                }).toList();
              },

              onChanged: (CityModelList? newCity) {
                widget.onCityChanged(newCity);
              },
            ),
          ),
        ),
      ],
    );
  }
}
