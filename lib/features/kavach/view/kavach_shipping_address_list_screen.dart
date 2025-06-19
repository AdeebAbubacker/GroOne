import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class KavachShippingAddressListScreen extends StatelessWidget {
  const KavachShippingAddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.shippingAddress,
      body: SizedBox(
          height: 500.h,
          child: _buildBody(context: context)),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return Column(
      children: [
        AppButton(
          onPressed: () async {
            await commonBottomSheetWithBGBlur(
              context: context,
              screen: KavachAddAddressBottomSheet(
                addrType: 1, // Shipping address type
                title: context.appText.shippingAddress,
              ),
            );
            // After the bottom sheet is dismissed, refetch the shipping addresses
            context.read<KavachCheckoutShippingAddressBloc>().add(FetchKavachShippingAddresses());
          },
          title: context.appText.addNewAddress,
          style: AppButtonStyle.outline,
        ),
        BlocBuilder<KavachCheckoutShippingAddressBloc, KavachCheckoutShippingAddressState>(
          builder: (context, state) {
            if (state is KavachCheckoutShippingAddressLoading) {
              return const CircularProgressIndicator();
            }

            if (state is KavachCheckoutShippingAddressSelected) {
              final addresses = state.addresses;

              return Column(
                children: [
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
                      final selectedAddress = context.read<KavachCheckoutShippingAddressBloc>().state;
                      if (selectedAddress is KavachCheckoutShippingAddressSelected) {
                        Navigator.pop(context, selectedAddress.selectedAddress); // Optional: return selected address
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

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
class AddressListItem extends StatelessWidget {
  final KavachAddressModel address;

  const AddressListItem({super.key, required this.address});

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
                  Text(address.customerName, style: AppTextStyle.textDarkGreyColor14w500),
                  Text('+91 ${address.mobileNumber}', style: AppTextStyle.textDarkGreyColor14w500),
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

