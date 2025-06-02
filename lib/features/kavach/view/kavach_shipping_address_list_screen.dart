import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_bottom_sheet_body.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../bloc/kavach_checkout_bloc/kavach_checkout_bloc.dart';
import '../bloc/kavach_checkout_bloc/kavach_checkout_event.dart';
import '../bloc/kavach_checkout_bloc/kavach_checkout_state.dart';
import '../model/kavach_address_model.dart';
import 'kavach_add_shipping_address_bottom_sheet.dart';
import 'kavach_checkout_screen.dart';

class KavachShippingAddressListScreen extends StatelessWidget {
  const KavachShippingAddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.shippingAddress,
      body: _buildBody(context: context),
    );
  }
  Widget _buildBody({required BuildContext context}) {
    return BlocBuilder<KavachCheckoutBloc, KavachCheckoutState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return const CircularProgressIndicator();
        }
        if (state is AddressLoaded || state is AddressSelected) {
          final addresses = state is AddressLoaded
              ? state.addresses
              : (state as AddressSelected).addresses;

          return SingleChildScrollView(
            child: Column(
              children: [
                AppButton(
                  onPressed: () {
                    commonBottomSheetWithBGBlur(context: context, screen: KavachAddShippingAddressBottomSheet());
                  },
                  title: context.appText.addNewAddress,
                  style: AppButtonStyle.outline,
                ),
                ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: addresses.length,
                  separatorBuilder: (context, index) => 10.height,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressListItem(address: address);
                  },
                ),
                20.height,
                AppButton(
                  onPressed: () {
                    Navigator.pop(context); // Close sheet
                  },
                  title: context.appText.deliverHere,
                  style: AppButtonStyle.primary,
                ),
                20.height,
              ],
            ),
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
    final selectedAddress = context.select((KavachCheckoutBloc bloc) {
      final state = bloc.state;
      if (state is AddressSelected) return state.selectedAddress;
      return null;
    });

    return GestureDetector(
      onTap: () {
        context.read<KavachCheckoutBloc>().add(SelectAddress(address));
        Navigator.pop(context); // Close bottom sheet
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
                context.read<KavachCheckoutBloc>().add(SelectAddress(address));
                Navigator.pop(context); // Close bottom sheet
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

