import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_event.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_event.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_state.dart';
import '../model/kavach_address_model.dart';
import 'kavach_add_address_bottom_sheet.dart';
// Import GPS dependencies for GPS feature support
import '../../gps_feature/cubit/gps_order_cubit_folder/gps_shipping_address_cubit.dart';
import '../../gps_feature/cubit/gps_order_cubit_folder/gps_billing_address_cubit.dart';

enum AddressListFeature { kavach, gps }

class KavachShippingAddressListScreen extends StatelessWidget {
  final KavachAddressModel? selectedBillingAddress;
  final AddressListFeature feature;
  final GpsShippingAddressCubit? gpsShippingAddressCubit; // For GPS feature
  final GpsBillingAddressCubit? gpsBillingAddressCubit; // For GPS feature - to refresh both lists
  
  const KavachShippingAddressListScreen({
    super.key,
    this.selectedBillingAddress,
    this.feature = AddressListFeature.kavach,
    this.gpsShippingAddressCubit,
    this.gpsBillingAddressCubit,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: _buildBody(context: context),
    );

    // Wrap with BlocProvider if this is for GPS feature
    if (feature == AddressListFeature.gps && gpsShippingAddressCubit != null) {
      body = BlocProvider.value(
        value: gpsShippingAddressCubit!,
        child: body,
      );
    }

    return AppBottomSheetBody(
      title: context.appText.shippingAddress,
      body: body,
    );
  }

  Widget addVehicleButton(BuildContext context){
    return AppButton(
      onPressed: () async {
        if (feature == AddressListFeature.kavach) {
        await commonBottomSheetWithBGBlur(
          context: context,
          screen: KavachAddAddressBottomSheet(
            addrType: 1, // Shipping address type
            title: context.appText.shippingAddress,
              feature: AddressFeature.kavach,
          ),
        );
        // After the bottom sheet is dismissed, refetch the shipping addresses
        context.read<KavachCheckoutShippingAddressBloc>().add(FetchKavachShippingAddresses());
        } else if (feature == AddressListFeature.gps && gpsShippingAddressCubit != null) {
          await commonBottomSheetWithBGBlur(
            context: context,
            screen: KavachAddAddressBottomSheet(
              addrType: 1, // Shipping address type
              title: context.appText.shippingAddress,
              feature: AddressFeature.gps,
              onAddressAdded: () {
                // Refresh both billing and shipping address lists
                gpsShippingAddressCubit!.fetchGpsShippingAddresses();
                if (gpsBillingAddressCubit != null) {
                  gpsBillingAddressCubit!.fetchGpsBillingAddresses();
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
    } else if (feature == AddressListFeature.gps && gpsShippingAddressCubit != null) {
      return _buildGpsBody(context);
    }
    return  Center(child: Text(context.appText.invalidFeatureConfiguration));
  }

  Widget _buildKavachBody(BuildContext context) {
    return BlocBuilder<KavachCheckoutShippingAddressBloc, KavachCheckoutShippingAddressState>(
      builder: (context, state) {
        if (state is KavachCheckoutShippingAddressLoading) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (state is KavachCheckoutShippingAddressError) {
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
                          context.read<KavachCheckoutShippingAddressBloc>().add(FetchKavachShippingAddresses());
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

        if (state is KavachCheckoutShippingAddressSelected) {
          // Filter out the selected billing address from shipping address list
          final filteredAddresses = selectedBillingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != selectedBillingAddress!.uniqueId).toList()
              : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child: filteredAddresses.isEmpty 
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, color: Colors.grey, size: 48),
                            10.height,
                            Text(
                              context.appText.noAvailableShippingAddresses,
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              selectedBillingAddress != null
                                  ? context.appText.allAddressesAlreadySelectedForBilling
                                  : context.appText.addYourFirstShippingAddress,
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
                  final selectedAddress = context.read<KavachCheckoutShippingAddressBloc>().state;
                  if (selectedAddress is KavachCheckoutShippingAddressSelected) {
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

        if (state is KavachCheckoutShippingAddressAvailable) {
          // Filter out the selected billing address from shipping address list
          final filteredAddresses = selectedBillingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != selectedBillingAddress!.uniqueId).toList()
              : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child: filteredAddresses.isEmpty 
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, color: Colors.grey, size: 48),
                            10.height,
                            Text(
                              context.appText.noAvailableShippingAddresses,
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              selectedBillingAddress != null
                                  ? context.appText.allAddressesAlreadySelectedForBilling
                                  : context.appText.addYourFirstShippingAddress,
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
                      context.appText.addYourFirstShippingAddress,
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
    return BlocBuilder<GpsShippingAddressCubit, GpsShippingAddressState>(
      builder: (context, state) {
        if (state is GpsShippingAddressLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GpsShippingAddressError) {
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
                          gpsShippingAddressCubit!.fetchGpsShippingAddresses();
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

        if (state is GpsShippingAddressSelected) {
          // Filter out the selected billing address from shipping address list
          final filteredAddresses = selectedBillingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != selectedBillingAddress!.uniqueId).toList()
              : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child: filteredAddresses.isEmpty 
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, color: Colors.grey, size: 48),
                            10.height,
                            Text(
                              context.appText.noAvailableShippingAddresses,
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              selectedBillingAddress != null
                                  ? context.appText.allAddressesAlreadySelectedForBilling
                                  : context.appText.addYourFirstShippingAddress,
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
                            cubit: gpsShippingAddressCubit!,
                          );
                        },
                      ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  final selectedAddress = gpsShippingAddressCubit!.state;
                  if (selectedAddress is GpsShippingAddressSelected) {
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

        if (state is GpsShippingAddressAvailable) {
          // Filter out the selected billing address from shipping address list
          final filteredAddresses = selectedBillingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != selectedBillingAddress!.uniqueId).toList()
              : state.addresses;

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child: filteredAddresses.isEmpty 
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, color: Colors.grey, size: 48),
                            10.height,
                            Text(
                              context.appText.noAvailableShippingAddresses,
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              selectedBillingAddress != null 
                                  ? context.appText.allAddressesAlreadySelectedForBilling
                                  : context.appText.addYourFirstShippingAddress,
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
                            cubit: gpsShippingAddressCubit!,
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
                      context.appText.addYourFirstShippingAddress,
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
    final selectedAddress = context.select((KavachCheckoutShippingAddressBloc bloc) {
      final state = bloc.state;
      if (state is KavachCheckoutShippingAddressSelected) return state.selectedAddress;
      return null;
    });

    return GestureDetector(
      onTap: () {
        context.read<KavachCheckoutShippingAddressBloc>().add(SelectKavachShippingAddress(address));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: commonContainerDecoration(color: AppColors.greyContainerBackgroundColor),
        child: Row(
          children: [
            Radio<KavachAddressModel>(
              value: address,
              groupValue: selectedAddress,
              onChanged: (_) {
                context.read<KavachCheckoutShippingAddressBloc>().add(SelectKavachShippingAddress(address));
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.addressName, style: AppTextStyle.textDarkGreyColor14w500),
                  Text(address.fullAddress, style: AppTextStyle.textDarkGreyColor14w500),
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
  final GpsShippingAddressCubit cubit;

  const GpsAddressListItem({
    super.key, 
    required this.address,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAddress = context.select((GpsShippingAddressCubit cubit) {
      final state = cubit.state;
      if (state is GpsShippingAddressSelected) return state.selectedAddress;
      return null;
    });

    // Compare addresses by their unique identifier instead of object reference
    final isSelected = selectedAddress != null && 
                      selectedAddress.id == address.id &&
                      selectedAddress.addressName == address.addressName &&
                      selectedAddress.addr1 == address.addr1 &&
                      selectedAddress.city == address.city &&
                      selectedAddress.pincode == address.pincode;

    return GestureDetector(
      onTap: () {
        cubit.selectGpsShippingAddress(address);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: commonContainerDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : AppColors.greyContainerBackgroundColor,
        ),
        child: Row(
          children: [
            Radio<KavachAddressModel>(
              value: address,
              groupValue: isSelected ? address : null,
              onChanged: (_) {
                cubit.selectGpsShippingAddress(address);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.addressName, style: AppTextStyle.textDarkGreyColor14w500),
                  Text(address.fullAddress, style: AppTextStyle.textDarkGreyColor14w500),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

