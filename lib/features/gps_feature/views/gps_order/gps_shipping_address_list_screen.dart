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

class GpsShippingAddressListScreen extends StatefulWidget {
  final GpsShippingAddressCubit shippingAddressCubit;
  final KavachAddressModel? selectedBillingAddress;
  
  const GpsShippingAddressListScreen({
    super.key,
    required this.shippingAddressCubit,
    this.selectedBillingAddress,
  });

  @override
  State<GpsShippingAddressListScreen> createState() => _GpsShippingAddressListScreenState();
}

class _GpsShippingAddressListScreenState extends State<GpsShippingAddressListScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh shipping addresses when the screen opens, but preserve selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAddressesPreservingSelection();
    });
  }

  /// Refresh addresses while preserving the currently selected address
  void _refreshAddressesPreservingSelection() {
    final currentState = widget.shippingAddressCubit.state;
    KavachAddressModel? selectedAddress;
    
    // Store the currently selected address
    if (currentState is GpsShippingAddressSelected) {
      selectedAddress = currentState.selectedAddress;
    }
    
    // Refresh addresses
    widget.shippingAddressCubit.fetchGpsShippingAddresses().then((_) {
      // After refresh, restore the selection if there was one
      if (selectedAddress != null && mounted) {
        // Add a small delay to ensure the fetch is complete
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            widget.shippingAddressCubit.selectGpsShippingAddress(selectedAddress!);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.shippingAddressCubit,
      child: AppBottomSheetBody(
        title: context.appText.shippingAddress,
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
            title: context.appText.shippingAddress,
          ),
        );
        // After adding address, refetch the shipping addresses immediately
        widget.shippingAddressCubit.fetchGpsShippingAddresses();
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
                          widget.shippingAddressCubit.fetchGpsShippingAddresses();
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

        if (state is GpsShippingAddressSelected) {
          // Filter out the selected billing address from shipping address list
          final filteredAddresses = widget.selectedBillingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != widget.selectedBillingAddress!.uniqueId).toList()
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
                              'No available shipping addresses',
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              widget.selectedBillingAddress != null 
                                  ? 'All addresses are already selected for billing'
                                  : 'Add your first shipping address',
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
                  final selectedAddress = widget.shippingAddressCubit.state;
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
          final filteredAddresses = widget.selectedBillingAddress != null 
              ? state.addresses.where((address) => address.uniqueId != widget.selectedBillingAddress!.uniqueId).toList()
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
                              'No available shipping addresses',
                              style: AppTextStyle.h5,
                            ),
                            5.height,
                            Text(
                              widget.selectedBillingAddress != null 
                                  ? 'All addresses are already selected for billing'
                                  : 'Add your first shipping address',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 