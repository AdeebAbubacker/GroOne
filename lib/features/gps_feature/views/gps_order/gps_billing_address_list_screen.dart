import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_billing_address_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../../utils/app_bottom_sheet_body.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../kavach/model/kavach_address_model.dart';
import 'gps_add_address_bottom_sheet.dart';

class GpsBillingAddressListScreen extends StatelessWidget {
  final GpsBillingAddressCubit billingAddressCubit;
  final KavachAddressModel? selectedShippingAddress;
  
  const GpsBillingAddressListScreen({
    super.key,
    required this.billingAddressCubit,
    this.selectedShippingAddress,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: billingAddressCubit,
      child: AppBottomSheetBody(
        title: context.appText.billingAddress,
        hideDivider: false,
        body: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
           child: _buildBody(context: context)),
      ),
    );
  }

  Widget addVehicleButton(BuildContext context){
    return AppButton(
      onPressed: () async {
        await commonBottomSheetWithBGBlur(
          context: context,
          screen: GpsAddAddressBottomSheet(
            title: context.appText.billingAddress,
          ),
        );
        // After adding address, refetch the billing addresses immediately
        billingAddressCubit.fetchGpsBillingAddresses();
      },
      title: context.appText.addNewAddress,
      style: AppButtonStyle.outline,
    );
  }

  Widget _buildBody({required BuildContext context}) {
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
                        'Failed to load addresses',
                        style: AppTextStyle.h5,
                      ),
                      10.height,
                      AppButton(
                        onPressed: () {
                          billingAddressCubit.fetchGpsBillingAddresses();
                        },
                        title: 'Retry',
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
          final filteredAddresses = selectedShippingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != selectedShippingAddress!.uniqueId).toList()
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
                              'No available billing addresses',
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              selectedShippingAddress != null 
                                  ? 'All addresses are already selected for shipping'
                                  : 'Add your first billing address',
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
                          return AddressListItem(address: address);
                        },
                      ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  final selectedAddress = billingAddressCubit.state;
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
          final filteredAddresses = selectedShippingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != selectedShippingAddress!.uniqueId).toList()
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
                              'No available billing addresses',
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              selectedShippingAddress != null 
                                  ? 'All addresses are already selected for shipping'
                                  : 'Add your first billing address',
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
                          return AddressListItem(address: address);
                        },
                      ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  // Show message that user must select an address first
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select an address first'),
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
                      'No addresses found',
                      style: AppTextStyle.h5,
                    ),
                    5.height,
                    Text(
                      'Add your first billing address',
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

class AddressListItem extends StatelessWidget {
  final KavachAddressModel address;

  const AddressListItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final selectedAddress = context.select((GpsBillingAddressCubit cubit) {
      final state = cubit.state;
      if (state is GpsBillingAddressSelected) return state.selectedAddress;
      return null;
    });

    return GestureDetector(
      onTap: () {
        context.read<GpsBillingAddressCubit>().selectGpsBillingAddress(address);
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
                context.read<GpsBillingAddressCubit>().selectGpsBillingAddress(address);
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