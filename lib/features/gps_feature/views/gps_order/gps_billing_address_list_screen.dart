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
  
  const GpsBillingAddressListScreen({
    super.key,
    required this.billingAddressCubit,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.billingAddress,
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
            title: context.appText.billingAddress,
          ),
        );
        // After adding address, wait a bit and then refetch the billing addresses
        await Future.delayed(Duration(milliseconds: 500));
        billingAddressCubit.fetchGpsBillingAddresses();
      },
      title: context.appText.addNewAddress,
      style: AppButtonStyle.outline,
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return BlocBuilder<GpsBillingAddressCubit, GpsBillingAddressState>(
      bloc: billingAddressCubit,
      builder: (context, state) {
        if (state is GpsBillingAddressLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GpsBillingAddressLoaded || state is GpsBillingAddressSelected) {
          final addresses = state is GpsBillingAddressLoaded 
              ? (state as GpsBillingAddressLoaded).addresses
              : (state as GpsBillingAddressSelected).addresses;

          // Check if addresses list is null or empty
          if (addresses.isEmpty) {
            return Column(
              children: [
                addVehicleButton(context)
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
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) => 10.height,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressListItem(
                      address: address,
                      billingAddressCubit: billingAddressCubit,
                    );
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
                    // Handle if nothing is selected
                  }
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
            addVehicleButton(context)
          ],
        );
      },
    );
  }
}

class AddressListItem extends StatelessWidget {
  final KavachAddressModel address;
  final GpsBillingAddressCubit billingAddressCubit;

  const AddressListItem({
    super.key, 
    required this.address,
    required this.billingAddressCubit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedAddress = billingAddressCubit.state is GpsBillingAddressSelected 
        ? (billingAddressCubit.state as GpsBillingAddressSelected).selectedAddress 
        : null;

    return GestureDetector(
      onTap: () {
        billingAddressCubit.selectGpsBillingAddress(address);
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
                billingAddressCubit.selectGpsBillingAddress(address);
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