import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_event.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_state.dart';
import '../model/kavach_address_model.dart';
import 'kavach_add_address_bottom_sheet.dart';
import '../../gps_feature/cubit/gps_order_cubit_folder/gps_billing_address_cubit.dart';
import '../../gps_feature/cubit/gps_order_cubit_folder/gps_shipping_address_cubit.dart';

enum AddressListFeature { kavach, gps }

class KavachBillingAddressListScreen extends StatelessWidget {
  final KavachAddressModel? selectedShippingAddress;
  final AddressListFeature feature;
  final GpsBillingAddressCubit? gpsBillingAddressCubit; // For GPS feature
  final GpsShippingAddressCubit?
  gpsShippingAddressCubit; // For GPS feature - to refresh both lists
  int? changeShippingIndex;

  KavachBillingAddressListScreen({
    super.key,
    this.selectedShippingAddress,
    this.feature = AddressListFeature.kavach,
    this.gpsBillingAddressCubit,
    this.gpsShippingAddressCubit,
    this.changeShippingIndex,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: _buildBody(context: context),
    );

    // Wrap with BlocProvider if this is for GPS feature
    if (feature == AddressListFeature.gps && gpsBillingAddressCubit != null) {
      body = BlocProvider.value(value: gpsBillingAddressCubit!, child: body);
    }

    return AppBottomSheetBody(
      title: context.appText.billingAddress,
      hideDivider: false,
      body: body,
    );
  }

  Widget addVehicleButton(BuildContext context) {
    return AppButton(
      onPressed: () async {
        if (feature == AddressListFeature.kavach) {
          await commonBottomSheetWithBGBlur(
            context: context,
            screen: KavachAddAddressBottomSheet(
              addrType: 2, // Billing address type
              title: context.appText.billingAddress,
              feature: AddressFeature.kavach,
            ),
          );
          if (!context.mounted) return;
          context.read<KavachCheckoutBillingAddressBloc>().add(
            FetchKavachBillingAddresses(),
          );
        } else if (feature == AddressListFeature.gps &&
            gpsBillingAddressCubit != null) {
          await commonBottomSheetWithBGBlur(
            context: context,
            screen: KavachAddAddressBottomSheet(
              addrType: 2, // Billing address type
              title: context.appText.billingAddress,
              feature: AddressFeature.gps,
              onAddressAdded: () {
                // Refresh both billing and shipping address lists
                gpsBillingAddressCubit!.fetchGpsBillingAddresses();
                if (gpsShippingAddressCubit != null) {
                  gpsShippingAddressCubit!.fetchGpsShippingAddresses(
                    changeShippingIndex:
                        changeShippingIndex != null ? changeShippingIndex! : 0,
                  );
                }
              },
            ),
          );
        }
      },
      title: context.appText.addNewAddress,
      style: AppButtonStyle.outline,
    );
  }

  Widget _buildBody({required BuildContext context}) {
    if (feature == AddressListFeature.kavach) {
      return _buildKavachBody(context);
    } else if (feature == AddressListFeature.gps &&
        gpsBillingAddressCubit != null) {
      return _buildGpsBody(context);
    }
    return Center(child: Text(context.appText.invalidFeatureConfiguration));
  }

  Widget _buildKavachBody(BuildContext context) {
    return BlocBuilder<
      KavachCheckoutBillingAddressBloc,
      KavachCheckoutBillingAddressState
    >(
      builder: (context, state) {
        if (state is KavachCheckoutBillingAddressLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is KavachCheckoutBillingAddressError) {
          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 48),
                      10.height,
                      Text(
                        context.appText.failedToLoadAddresses,
                        style: AppTextStyle.h5,
                      ),
                      10.height,
                      AppButton(
                        onPressed: () {
                          context.read<KavachCheckoutBillingAddressBloc>().add(
                            FetchKavachBillingAddresses(),
                          );
                        },
                        title: context.appText.retry,
                        style: AppButtonStyle.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        if (state is KavachCheckoutBillingAddressSelected) {
          // Filter out the selected shipping address from billing address list
          final filteredAddresses =
              selectedShippingAddress != null
                  ? state.addresses
                      .where(
                        (address) =>
                            address.uniqueId !=
                            selectedShippingAddress!.uniqueId,
                      )
                      .toList()
                  : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child:
                    filteredAddresses.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                color: Colors.grey,
                                size: 48,
                              ),
                              10.height,
                              Text(
                                context.appText.noAvailableBillingAddresses,
                                style: AppTextStyle.h5,
                              ),
                              5.height,
                              Text(
                                selectedShippingAddress != null
                                    ? context
                                        .appText
                                        .allAddressesAlreadySelectedForShipping
                                    : context
                                        .appText
                                        .addYourFirstBillingAddress,
                                style: AppTextStyle.bodyGreyColor,
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shrinkWrap: true,
                          itemCount: filteredAddresses.length,
                          separatorBuilder: (context, index) => 10.height,
                          itemBuilder: (context, index) {
                            final address = filteredAddresses[index];
                            return KavachAddressListItem(address: address);
                          },
                        ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  final selectedAddress =
                      context.read<KavachCheckoutBillingAddressBloc>().state;
                  if (selectedAddress is KavachCheckoutBillingAddressSelected) {
                    Navigator.pop(context, selectedAddress.selectedAddress);
                  } else {
                    // Handle if nothing is selected (optional)
                  }
                },
                title: context.appText.deliverHere,
                style: AppButtonStyle.primary,
              ),
              20.height,
            ],
          );
        }

        if (state is KavachCheckoutBillingAddressAvailable) {
          // Filter out the selected shipping address from billing address list
          final filteredAddresses =
              selectedShippingAddress != null
                  ? state.addresses
                      .where(
                        (address) =>
                            address.uniqueId !=
                            selectedShippingAddress!.uniqueId,
                      )
                      .toList()
                  : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child:
                    filteredAddresses.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                color: Colors.grey,
                                size: 48,
                              ),
                              10.height,
                              Text(
                                context.appText.noAvailableBillingAddresses,
                                style: AppTextStyle.h5,
                              ),
                              5.height,
                              Text(
                                selectedShippingAddress != null
                                    ? context
                                        .appText
                                        .allAddressesAlreadySelectedForShipping
                                    : context
                                        .appText
                                        .addYourFirstBillingAddress,
                                style: AppTextStyle.bodyGreyColor,
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shrinkWrap: true,
                          itemCount: filteredAddresses.length,
                          separatorBuilder: (context, index) => 10.height,
                          itemBuilder: (context, index) {
                            final address = filteredAddresses[index];
                            return KavachAddressListItem(address: address);
                          },
                        ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  // Show message that user must select an address first
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.appText.pleaseSelectAddressFirst),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                title: context.appText.deliverHere,
                style: AppButtonStyle.primary,
              ),
              20.height,
            ],
          );
        }

        // Empty state or any other state
        return Column(
          children: [
            addVehicleButton(context),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, color: Colors.grey, size: 48),
                    10.height,
                    Text(
                      context.appText.noAddressFound,
                      style: AppTextStyle.h5,
                    ),
                    5.height,
                    Text(
                      context.appText.addYourFirstBillingAddress,
                      style: AppTextStyle.bodyGreyColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGpsBody(BuildContext context) {
    return BlocBuilder<GpsBillingAddressCubit, GpsBillingAddressState>(
      builder: (context, state) {
        if (state is GpsBillingAddressLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GpsBillingAddressError) {
          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 48),
                      10.height,
                      Text(
                        context.appText.failedToLoadAddresses,
                        style: AppTextStyle.h5,
                      ),
                      10.height,
                      AppButton(
                        onPressed: () {
                          gpsBillingAddressCubit!.fetchGpsBillingAddresses();
                        },
                        title: context.appText.retry,
                        style: AppButtonStyle.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        if (state is GpsBillingAddressSelected) {
          // Filter out the selected shipping address from billing address list
          final filteredAddresses =
              selectedShippingAddress != null
                  ? state.addresses
                      .where(
                        (address) =>
                            address.uniqueId !=
                            selectedShippingAddress!.uniqueId,
                      )
                      .toList()
                  : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child:
                    filteredAddresses.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                color: Colors.grey,
                                size: 48,
                              ),
                              10.height,
                              Text(
                                context.appText.noAvailableBillingAddresses,
                                style: AppTextStyle.h5,
                              ),
                              5.height,
                              Text(
                                selectedShippingAddress != null
                                    ? context
                                        .appText
                                        .allAddressesAlreadySelectedForShipping
                                    : context
                                        .appText
                                        .addYourFirstBillingAddress,
                                style: AppTextStyle.bodyGreyColor,
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shrinkWrap: true,
                          itemCount: filteredAddresses.length,
                          separatorBuilder: (context, index) => 10.height,
                          itemBuilder: (context, index) {
                            final address = filteredAddresses[index];
                            return GpsAddressListItem(
                              address: address,
                              cubit: gpsBillingAddressCubit!,
                            );
                          },
                        ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  final selectedAddress = gpsBillingAddressCubit!.state;
                  if (selectedAddress is GpsBillingAddressSelected) {
                    Navigator.pop(context, selectedAddress.selectedAddress);
                  } else {
                    // Handle if nothing is selected (optional)
                  }
                },
                title: context.appText.deliverHere,
                style: AppButtonStyle.primary,
              ),
              20.height,
            ],
          );
        }

        if (state is GpsBillingAddressAvailable) {
          // Filter out the selected shipping address from billing address list
          final filteredAddresses =
              selectedShippingAddress != null
                  ? state.addresses
                      .where(
                        (address) =>
                            address.uniqueId !=
                            selectedShippingAddress!.uniqueId,
                      )
                      .toList()
                  : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child:
                    filteredAddresses.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                color: Colors.grey,
                                size: 48,
                              ),
                              10.height,
                              Text(
                                context.appText.noAvailableBillingAddresses,
                                style: AppTextStyle.h5,
                              ),
                              5.height,
                              Text(
                                selectedShippingAddress != null
                                    ? context
                                        .appText
                                        .allAddressesAlreadySelectedForShipping
                                    : context
                                        .appText
                                        .addYourFirstBillingAddress,
                                style: AppTextStyle.bodyGreyColor,
                              ),
                            ],
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shrinkWrap: true,
                          itemCount: filteredAddresses.length,
                          separatorBuilder: (context, index) => 10.height,
                          itemBuilder: (context, index) {
                            final address = filteredAddresses[index];
                            return GpsAddressListItem(
                              address: address,
                              cubit: gpsBillingAddressCubit!,
                            );
                          },
                        ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  // Show message that user must select an address first
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.appText.pleaseSelectAddressFirst),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                title: context.appText.deliverHere,
                style: AppButtonStyle.primary,
              ),
              20.height,
            ],
          );
        }

        // Empty state - show add address button
        return Column(
          children: [
            addVehicleButton(context),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, color: Colors.grey, size: 48),
                    10.height,
                    Text(
                      context.appText.noAddressFound,
                      style: AppTextStyle.h5,
                    ),
                    5.height,
                    Text(
                      context.appText.addYourFirstBillingAddress,
                      style: AppTextStyle.bodyGreyColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class KavachAddressListItem extends StatelessWidget {
  final KavachAddressModel address;

  const KavachAddressListItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final selectedAddress = context.select((
      KavachCheckoutBillingAddressBloc bloc,
    ) {
      final state = bloc.state;
      if (state is KavachCheckoutBillingAddressSelected)
        return state.selectedAddress;
      return null;
    });

    return GestureDetector(
      onTap: () {
        context.read<KavachCheckoutBillingAddressBloc>().add(
          SelectKavachBillingAddress(address),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: commonContainerDecoration(
          color: AppColors.greyContainerBackgroundColor,
        ),
        child: Row(
          children: [
            Radio<KavachAddressModel>(
              value: address,
              groupValue: selectedAddress,
              onChanged: (_) {
                context.read<KavachCheckoutBillingAddressBloc>().add(
                  SelectKavachBillingAddress(address),
                );
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.addressName,
                    style: AppTextStyle.textDarkGreyColor14w500,
                  ),
                  Text(
                    address.fullAddress,
                    style: AppTextStyle.textDarkGreyColor14w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GpsAddressListItem extends StatelessWidget {
  final KavachAddressModel address;
  final GpsBillingAddressCubit cubit;

  const GpsAddressListItem({
    super.key,
    required this.address,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAddress = context.select((GpsBillingAddressCubit cubit) {
      final state = cubit.state;
      if (state is GpsBillingAddressSelected) return state.selectedAddress;
      return null;
    });

    // Compare addresses by their unique identifier instead of object reference
    final isSelected =
        selectedAddress != null &&
        selectedAddress.id == address.id &&
        selectedAddress.addressName == address.addressName &&
        selectedAddress.addr1 == address.addr1 &&
        selectedAddress.city == address.city &&
        selectedAddress.pincode == address.pincode;

    return GestureDetector(
      onTap: () {
        cubit.selectGpsBillingAddress(address);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: commonContainerDecoration(
          color:
              isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.1)
                  : AppColors.greyContainerBackgroundColor,
        ),
        child: Row(
          children: [
            Radio<KavachAddressModel>(
              value: address,
              groupValue: isSelected ? address : null,
              onChanged: (_) {
                cubit.selectGpsBillingAddress(address);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.addressName,
                    style: AppTextStyle.textDarkGreyColor14w500,
                  ),
                  Text(
                    address.fullAddress,
                    style: AppTextStyle.textDarkGreyColor14w500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
