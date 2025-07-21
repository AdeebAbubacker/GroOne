import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_shipping_address_cubit.dart';
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

class GpsShippingAddressListScreen extends StatelessWidget {
  final GpsShippingAddressCubit shippingAddressCubit;
  final KavachAddressModel? selectedBillingAddress;
  
  const GpsShippingAddressListScreen({
    super.key,
    required this.shippingAddressCubit,
    this.selectedBillingAddress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.shippingAddress,
      body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
         child: _buildBody(context: context)),
    );
  }

  Widget addVehicleButton(BuildContext context){
    return AppButton(
      onPressed: () async {
        await commonBottomSheetWithBGBlur(
          context: context,
          screen: GpsAddAddressBottomSheet(
            title: context.appText.shippingAddress,
          ),
        );
        // After adding address, wait a bit and then refetch the shipping addresses
        await Future.delayed(Duration(milliseconds: 500));
        shippingAddressCubit.fetchGpsShippingAddresses();
      },
      title: context.appText.addNewAddress,
      style: AppButtonStyle.outline,
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return BlocBuilder<GpsShippingAddressCubit, GpsShippingAddressState>(
      bloc: shippingAddressCubit,
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
                        'Failed to load addresses',
                        style: AppTextStyle.h5,
                      ),
                      10.height,
                      AppButton(
                        onPressed: () {
                          shippingAddressCubit.fetchGpsShippingAddresses();
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

        if (state is GpsShippingAddressLoaded || state is GpsShippingAddressSelected) {
          final addresses = state is GpsShippingAddressLoaded 
              ? (state as GpsShippingAddressLoaded).addresses
              : (state as GpsShippingAddressSelected).addresses;

          // Filter out the selected billing address from shipping address list
          final filteredAddresses = selectedBillingAddress != null 
              ? addresses.where((address) => address.uniqueId != selectedBillingAddress!.uniqueId).toList()
              : addresses;

          // Check if addresses list is null or empty
          if (filteredAddresses.isEmpty) {
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
                          'No available shipping addresses',
                          style: AppTextStyle.h5,
                        ),
                        5.height,
                        Text(
                          selectedBillingAddress != null 
                              ? 'All addresses are already selected for billing'
                              : 'Add your first shipping address',
                          style: AppTextStyle.bodyGreyColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              addVehicleButton(context),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shrinkWrap: true,
                  itemCount: filteredAddresses.length,
                  separatorBuilder: (context, index) => 10.height,
                  itemBuilder: (context, index) {
                    final address = filteredAddresses[index];
                    return AddressListItem(
                      address: address,
                      shippingAddressCubit: shippingAddressCubit,
                    );
                  },
                ),
              ),
              10.height,
              AppButton(
                onPressed: () {
                  final selectedAddress = shippingAddressCubit.state;
                  if (selectedAddress is GpsShippingAddressSelected) {
                    Navigator.pop(context, selectedAddress.selectedAddress);
                  } else {
                    // Show message that user must select an address first
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select an address first'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                title: context.appText.deliverHere,
                style: AppButtonStyle.primary,
              ),
              
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
                      'Add your first shipping address',
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
  final GpsShippingAddressCubit shippingAddressCubit;

  const AddressListItem({
    super.key, 
    required this.address,
    required this.shippingAddressCubit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAddress = shippingAddressCubit.state is GpsShippingAddressSelected 
        ? (shippingAddressCubit.state as GpsShippingAddressSelected).selectedAddress 
        : null;

    return GestureDetector(
      onTap: () {
        shippingAddressCubit.selectGpsShippingAddress(address);
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
                shippingAddressCubit.selectGpsShippingAddress(address);
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