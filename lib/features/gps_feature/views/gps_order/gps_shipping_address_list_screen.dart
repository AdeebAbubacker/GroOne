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
  const GpsShippingAddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.shippingAddress,
      body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: _buildBody(context: context)),
    );
  }

  Widget addAddressButton(BuildContext context){
    return AppButton(
      onPressed: () async {
        await commonBottomSheetWithBGBlur(
          context: context,
          screen: GpsAddAddressBottomSheet(
            addrType: "1", // Shipping address type
            title: context.appText.shippingAddress,
          ),
        );
        // After adding address, refetch the shipping addresses
        context.read<GpsShippingAddressCubit>().fetchGpsShippingAddresses();
      },
      title: context.appText.addNewAddress,
      style: AppButtonStyle.outline,
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return BlocBuilder<GpsShippingAddressCubit, GpsShippingAddressState>(
      builder: (context, state) {
        if (state is GpsShippingAddressLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GpsShippingAddressLoaded) {
          final addresses = state.addresses;

          return Column(
            children: [
              addAddressButton(context),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shrinkWrap: true,
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) => 10.height,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressListItem(address: address);
                  },
                ),
              ),
              20.height,
              AppButton(
                onPressed: () {
                  final selectedAddress = context.read<GpsShippingAddressCubit>().state;
                  if (selectedAddress is GpsShippingAddressSelected) {
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
            addAddressButton(context)
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
    final selectedAddress = context.select((GpsShippingAddressCubit cubit) {
      final state = cubit.state;
      if (state is GpsShippingAddressSelected) return state.selectedAddress;
      return null;
    });

    return GestureDetector(
      onTap: () {
        context.read<GpsShippingAddressCubit>().selectGpsShippingAddress(address);
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
                context.read<GpsShippingAddressCubit>().selectGpsShippingAddress(address);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(address.addressName, style: AppTextStyle.textDarkGreyColor14w500),
                  Text(address.fullAddress, style: AppTextStyle.textDarkGreyColor14w500),
                  if (address.gstin != null && address.gstin!.isNotEmpty)
                    Text("GST: ${address.gstin}", style: AppTextStyle.textDarkGreyColor14w500),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 