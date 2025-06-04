import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/view/kavach_add_shipping_address_bottom_sheet.dart';
import 'package:gro_one_app/features/kavach/view/kavach_billing_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_shipping_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_summary_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_check_box.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_event.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_state.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_event.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_state.dart';
import '../bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_bloc.dart';
import '../bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_event.dart';
import '../bloc/kavach_checkout_vehicle_bloc/kavach_checkout_vehicle_state.dart';
import '../model/kavach_product_model.dart';
import '../repository/kavach_repository.dart';
import 'widgets/product_counter.dart';

class KavachCheckoutScreen extends StatefulWidget {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  const KavachCheckoutScreen({super.key, required this.products, required this.quantities});

  @override
  State<KavachCheckoutScreen> createState() => _KavachCheckoutScreenState();
}

class _KavachCheckoutScreenState extends State<KavachCheckoutScreen> {
  final MultiSelectController<String> vehicleDetailsController = MultiSelectController<String>();
  final kavachCheckoutVehicleBloc = locator<KavachCheckoutVehicleBloc>();
  final kavachCheckoutShippingAddressBloc = locator<KavachCheckoutShippingAddressBloc>();
  final kavachCheckoutBillingAddressBloc = locator<KavachCheckoutBillingAddressBloc>();

  late Map<String, int> _quantities;
  late List<KavachProduct> _products;
  bool billingSameAsShipping =false;
  TextEditingController gstNoController = TextEditingController();
  late Map<String, int> _availableStocks;

  // @override
  // void initState() {
  //   super.initState();
  //   _quantities = Map<String, int>.from(widget.quantities);
  //   _products = List<KavachProduct>.from(widget.products);
  //   kavachCheckoutVehicleBloc.add(FetchKavachVehicles());
  //   kavachCheckoutShippingAddressBloc.add(FetchKavachAddresses());
  //   kavachCheckoutBillingAddressBloc.add(FetchKavachBillingAddresses());
  // }

  @override
  void initState() {
    super.initState();
    _quantities = Map<String, int>.from(widget.quantities);
    _products = List<KavachProduct>.from(widget.products);
    _availableStocks = {}; // empty initially

    for (var product in _products) {
      // Fetch stock for each product
      locator<KavachRepository>().fetchAvailableStock(
        productId: product.id,
      ).then((result) {
        if (result is Success<int>) {
          setState(() {
            _availableStocks[product.id] = result.value;
          });
        }
      });
    }

    kavachCheckoutVehicleBloc.add(FetchKavachVehicles());
    kavachCheckoutShippingAddressBloc.add(FetchKavachAddresses());
    kavachCheckoutBillingAddressBloc.add(FetchKavachBillingAddresses());
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.checkout,onLeadingTap: () {
        Navigator.of(context).pop(_quantities);
      },),
      bottomNavigationBar: buildPlaceOrderButtonWidget(),
      body: buildBodyWidget(context),
    );
  }

  Widget productWidget(KavachProduct product, int quantity) {
    num totalPrice = product.price*quantity;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(product.name, style: AppTextStyle.h5).expand(),
                ProductCounter(
                  count: quantity,
                  // onIncrement: () {
                  //   setState(() {
                  //     _quantities[product.id] = quantity + 1;
                  //   });
                  // },
                  onIncrement: () {
                    final stock = _availableStocks[product.id] ?? 0;
                    final currentQty = _quantities[product.id] ?? 0;

                    if (currentQty < stock) {
                      setState(() {
                        _quantities[product.id] = currentQty + 1;
                      });
                    } else {
                      ToastMessages.alert(message: 'Product out of stock');
                    }
                  },

                  onDecrement: () {
                    if (quantity > 1) {
                      setState(() {
                        _quantities[product.id] = quantity - 1;
                      });
                    } else {
                      // Quantity will become 0 – remove the product
                      setState(() {
                        _quantities.remove(product.id);
                        _products.removeWhere((p) => p.id == product.id);
                      });

                    }
                  },

                ),
              ],
            ),
            Row(
              children: [
                Text(product.part, style: AppTextStyle.bodyGreyColor).expand(),
                Text("$indianCurrencySymbol ${totalPrice.toStringAsFixed(2)}", style: AppTextStyle.h4PrimaryColor),
              ],
            ),
          ],
        ).expand(),
      ],
    ).paddingSymmetric(horizontal: 10);
  }

  Widget buildBodyWidget(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                decoration: commonContainerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.appText.productDetails,style: AppTextStyle.h5,),
                    10.height,
                    ListView.separated(
                      itemCount: _products.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(height: 20),
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final quantity = _quantities[product.id] ?? 0;
                        return productWidget(product, quantity);
                      },
                    ),
                    TextButton.icon(onPressed: () {
                      Navigator.of(context).pop(_quantities);
                    }, label: Text(context.appText.addMoreItems,style: AppTextStyle.primaryColor16w400,),
                      icon: Icon(Icons.add,color: AppColors.primaryColor,),
                    ),
                  ],
                )
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<KavachCheckoutVehicleBloc, KavachCheckoutVehicleState>(
                    builder: (context, state) {
                      if (state is KavachCheckoutVehicleLoading) {
                        return const SizedBox.shrink();
                      } else if (state is KavachCheckoutVehicleLoaded) {
                        final items = state.vehicles.map((vehicle) {
                          return DropdownItem<String>(
                            label: vehicle.vehicleNumber,
                            value: vehicle.vehicleNumber,
                          );
                        }).toList();
                        return AppMultiSelectionDropdown<String>(
                          labelText: context.appText.addVehicleDetails,
                          hintText: context.appText.select,
                          controller: vehicleDetailsController,
                          items: items,
                          onSelectionChange: (selected) {
                            print('Selected vehicles: $selected');
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? "${context.appText.truckType} ${context.appText.pinCode}"
                              : null,
                        );
                      } else if (state is KavachCheckoutVehicleError) {
                        return Text('Error: ${state.error}');
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  15.height,
                  Text('${context.appText.gstKavach} (${context.appText.optional})',style: AppTextStyle.body3,),
                  AppTextField(
                    controller: gstNoController,
                    hintText: 'Eg: GS68468GS654',
                  ),
                  10.height
                ],
              ),
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              decoration: commonContainerDecoration(),
              child: BlocBuilder<KavachCheckoutShippingAddressBloc, KavachCheckoutShippingAddressState>(
                builder: (context, state) {
                  if (state is KavachCheckoutAddressSelected) {
                    final address = state.selectedAddress;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(context.appText.shippingAddress, style: AppTextStyle.body3)),
                            TextButton.icon(
                              onPressed: () {
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: const KavachShippingAddressListScreen(),
                                );
                              },
                              icon: const Icon(Icons.mode_edit_outline_outlined, color: AppColors.primaryColor),
                              label: Text('Change', style: AppTextStyle.primaryColor16w400),
                            ),
                          ],
                        ),
                        Text(address.customerName),
                        Text('+91 ${address.mobileNumber}'),
                        Text(address.fullAddress),
                      ],
                    );
                  }

                  if (state is KavachCheckoutAddressEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.appText.shippingAddress, style: AppTextStyle.body3),
                        10.height,
                        TextButton.icon(
                          onPressed: () {
                            commonBottomSheetWithBGBlur(
                              context: context,
                              screen: KavachAddShippingAddressBottomSheet(),
                            );
                          },
                          icon: Icon(Icons.add, color: AppColors.primaryColor),
                          label: Text(context.appText.addNewAddress, style: AppTextStyle.primaryColor16w400),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              decoration: commonContainerDecoration(),
              child: BlocBuilder<KavachCheckoutBillingAddressBloc, KavachCheckoutBillingAddressState>(
                builder: (context, state) {
                  if (state is KavachCheckoutBillingAddressSelected) {
                    final address = state.selectedAddress;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(context.appText.billingAddress, style: AppTextStyle.body3)),
                            TextButton.icon(
                              onPressed: () {
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: const KavachBillingAddressListScreen(), // You create this similar to shipping
                                );
                              },
                              icon: const Icon(Icons.mode_edit_outline_outlined, color: AppColors.primaryColor),
                              label: Text('Change', style: AppTextStyle.primaryColor16w400),
                            ),
                          ],
                        ),
                        AppCheckBox(
                          onChanged: (checked) {
                            setState(() {
                              billingSameAsShipping = checked ?? false;
                            });
                            final billingBloc = context.read<KavachCheckoutBillingAddressBloc>();
                            if (billingSameAsShipping) {
                              final shippingState = context.read<KavachCheckoutShippingAddressBloc>().state;
                              if (shippingState is KavachCheckoutAddressSelected) {
                                billingBloc.add(SelectKavachBillingAddress(shippingState.selectedAddress));
                              }
                            } else {
                              billingBloc.add(ClearKavachBillingAddress()); // ← Add this line
                            }
                          },
                          value: billingSameAsShipping,
                          title: context.appText.sameAsShippingAddress,
                        ),
                        Text(address.customerName),
                        Text('+91 ${address.mobileNumber}'),
                        Text(address.fullAddress),
                      ],
                    );
                  }
                  if (state is KavachCheckoutBillingAddressEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.appText.billingAddress, style: AppTextStyle.body3),
                        AppCheckBox(
                          onChanged: (checked) {
                            setState(() {
                              billingSameAsShipping = checked ?? false;
                            });
                            final billingBloc = context.read<KavachCheckoutBillingAddressBloc>();
                            if (billingSameAsShipping) {
                              final shippingState = context.read<KavachCheckoutShippingAddressBloc>().state;
                              if (shippingState is KavachCheckoutAddressSelected) {
                                billingBloc.add(SelectKavachBillingAddress(shippingState.selectedAddress));
                              }
                            } else {
                              billingBloc.add(ClearKavachBillingAddress()); // ← Add this line
                            }
                          },
                          value: billingSameAsShipping,
                          title: context.appText.sameAsShippingAddress,
                        ),
                        10.height,
                        TextButton.icon(
                          onPressed: () {
                            commonBottomSheetWithBGBlur(
                              context: context,
                              screen: KavachAddShippingAddressBottomSheet(), // You create this too
                            );
                          },
                          icon: Icon(Icons.add, color: AppColors.primaryColor),
                          label: Text(context.appText.addNewAddress, style: AppTextStyle.primaryColor16w400),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            40.height
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }

  Widget buildPlaceOrderButtonWidget(){
    return AppButton(
      title: context.appText.placeOrder,
      onPressed: () {
        final shippingState = context.read<KavachCheckoutShippingAddressBloc>().state;
        final billingState = context.read<KavachCheckoutBillingAddressBloc>().state;

        if (shippingState is KavachCheckoutAddressSelected && billingState is KavachCheckoutBillingAddressSelected && vehicleDetailsController.selectedItems.map((item) => item.value).toList().isNotEmpty) {
          Navigator.of(context).push(commonRoute(KavachSummaryScreen(
            products: _products,
            quantities: _quantities,
            availableStocks: _availableStocks,
            shippingAddress: shippingState.selectedAddress,
            billingAddress: billingState.selectedAddress,
            selectedVehicleNumbers: vehicleDetailsController.selectedItems.map((item) => item.value).toList(),
            gstNo: gstNoController.text.trim(),
          )));
        } else {
          // Show error/snackbar
        }
      },

    ).bottomNavigationPadding();
  }
}


// BlocBuilder<KavachCheckoutBloc, KavachCheckoutState>(
//   builder: (context, state) {
//     if (state is AddressLoading) {
//       return CircularProgressIndicator();
//     } else if (state is AddressLoaded) {
//       final address = state.addresses.first;
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(address.customerName, style: AppTextStyle.textDarkGreyColor14w500),
//           Text('+91 ${address.mobileNumber}', style: AppTextStyle.textDarkGreyColor14w500),
//           Text(address.fullAddress, style: AppTextStyle.textDarkGreyColor14w500),
//           TextButton.icon(
//             onPressed: () {
//               commonBottomSheetWithBGBlur(context: context, screen: KavachShippingAddressListScreen());
//             },
//             icon: Icon(Icons.mode_edit_outline_outlined, color: AppColors.primaryColor),
//             label: Text('Change', style: AppTextStyle.primaryColor16w400),
//           ),
//         ],
//       );
//     } else if (state is AddressEmpty) {
//       return TextButton.icon(
//         onPressed: () {
//           commonBottomSheetWithBGBlur(context: context, screen: KavachAddShippingAddressBottomSheet());
//         },
//         icon: Icon(Icons.add, color: AppColors.primaryColor),
//         label: Text('Add Address', style: AppTextStyle.primaryColor16w400),
//       );
//     } else if (state is AddressError) {
//       return Text('Error loading address');
//     }
//
//     return SizedBox.shrink();
//   },
// ),