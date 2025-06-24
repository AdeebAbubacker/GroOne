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
import 'kavach_add_shipping_address_bottom_sheet.dart';

class KavachBillingAddressListScreen extends StatelessWidget {
  const KavachBillingAddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.billingAddress,
      body: SizedBox(
          height: 500,
          child: _buildBody(context: context)),
    );
  }

  Widget _buildBody({required BuildContext context}) {
    return BlocBuilder<KavachCheckoutBillingAddressBloc, KavachCheckoutBillingAddressState>(
      builder: (context, state) {
        if (state is KavachCheckoutBillingAddressLoading) {
          return const CircularProgressIndicator();
        }

        if (state is KavachCheckoutBillingAddressSelected) {
          final addresses = state.addresses;

          return Column(
            children: [
              AppButton(
                onPressed: () async {
                  await commonBottomSheetWithBGBlur(
                  context: context,
                  screen: KavachAddAddressBottomSheet(
                    addrType: 2, // Shipping address type
                    title: context.appText.billingAddress,
                  ),
                  );
                  context.read<KavachCheckoutBillingAddressBloc>().add(FetchKavachBillingAddresses());
                },
                title: context.appText.addNewAddress,
                style: AppButtonStyle.outline,
              ),
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
                  final selectedAddress = context.read<KavachCheckoutBillingAddressBloc>().state;
                  if (selectedAddress is KavachCheckoutBillingAddressSelected) {
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
    );
  }
}
class AddressListItem extends StatelessWidget {
  final KavachAddressModel address;

  const AddressListItem({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final selectedAddress = context.select((KavachCheckoutBillingAddressBloc bloc) {
      final state = bloc.state;
      if (state is KavachCheckoutBillingAddressSelected) return state.selectedAddress;
      return null;
    });

    return GestureDetector(
      onTap: () {
        context.read<KavachCheckoutBillingAddressBloc>().add(SelectKavachBillingAddress(address));
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
                context.read<KavachCheckoutBillingAddressBloc>().add(SelectKavachBillingAddress(address));
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