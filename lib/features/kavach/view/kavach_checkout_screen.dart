import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/kavach/view/kavach_added_vehicles_bottom_sheet.dart';
import 'package:gro_one_app/features/kavach/view/kavach_billing_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_shipping_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_summary_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/referral_autocomplete_textfield.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../data/model/result.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_check_box.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_field.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import '../../../utils/validator.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_event.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_state.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_event.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_state.dart';
import '../model/kavach_product_model.dart';
import '../repository/kavach_repository.dart';
import 'kavach_support_screen.dart';
import 'widgets/product_counter.dart';

class KavachCheckoutScreen extends StatefulWidget {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  final Map<String, List<String>>? previousVehicleSelection;

  const KavachCheckoutScreen({
    super.key,
    required this.products,
    required this.quantities,
    this.previousVehicleSelection
  });

  @override
  State<KavachCheckoutScreen> createState() => _KavachCheckoutScreenState();
}

class _KavachCheckoutScreenState extends State<KavachCheckoutScreen> {
  Map<String, List<TextEditingController>> vehicleControllersPerProduct = {};
  final kavachCheckoutShippingAddressBloc =
      locator<KavachCheckoutShippingAddressBloc>();
  final kavachCheckoutBillingAddressBloc =
      locator<KavachCheckoutBillingAddressBloc>();

  late Map<String, int> _quantities;
  late List<KavachProduct> _products;
  bool shippingSameAsBilling = false;
  late Map<String, int> _availableStocks;
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController shippingPersonInChargeController = TextEditingController();
  TextEditingController shippingPersonContactNoController = TextEditingController();
  final formKeyCheckout = GlobalKey<FormState>();






  void loadVehicleSelection() {
    for (var product in _products) {
      final productId = product.id;
      final qty = _quantities[productId] ?? 0;
      final existingControllers = vehicleControllersPerProduct[productId] ?? [];

      final newControllers = List<TextEditingController>.generate(qty, (index) {
        if (index < existingControllers.length) {
          return existingControllers[index]; // reuse existing
        } else {
          return TextEditingController(); // create new one
        }
      });

      vehicleControllersPerProduct[productId] = newControllers;
    }
  }

  void syncVehicleControllersWithProducts() {
    vehicleControllersPerProduct.removeWhere(
          (productId, _) => !_products.any((p) => p.id == productId),
    );
  }


  bool isVehicleAlreadySelected(String vehicleNumber) {
    for (var product in _products) {
      final controllers = vehicleControllersPerProduct[product.id] ?? [];
      for (var controller in controllers) {
        if (controller.text.trim() == vehicleNumber) {
          return true;
        }
      }
    }
    return false;
  }




  @override
  void initState() {
    super.initState();
    _quantities = Map<String, int>.from(widget.quantities);
    _products = List<KavachProduct>.from(widget.products);
    _availableStocks = {};

    for (var product in _products) {
      locator<KavachRepository>()
          .fetchAvailableStock(productId: product.id)
          .then((result) {
            if (result is Success<int>) {
              setState(() {
                _availableStocks[product.id] = result.value;
              });
            }
          });
    }

    for (var product in _products) {
      final qty = _quantities[product.id] ?? 0;
      final previousControllers = widget.previousVehicleSelection?[product.id] ?? [];
      final controllers = List<TextEditingController>.generate(qty, (index) {
        if (index < previousControllers.length) {
          return TextEditingController(text: previousControllers[index]);
        } else {
          return TextEditingController();
        }
      });
      vehicleControllersPerProduct[product.id] = controllers;
    }

    // loadVehicleSelection();
    kavachCheckoutShippingAddressBloc.add(FetchKavachShippingAddresses());
    kavachCheckoutBillingAddressBloc.add(FetchKavachBillingAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        centreTile: false,
        title: context.appText.checkout,
        leading : IconButton(
            onPressed: () {
              // Navigator.of(context).pop(_quantities);
              Navigator.of(context).pop({
                'quantities': _quantities,
                'vehicles': vehicleControllersPerProduct.map(
                      (key, value) => MapEntry(
                    key,
                    value.map((controller) => controller.text.trim()).toList(),
                  ),
                ),
              });
            },
            icon: SvgPicture.asset(AppIcons.svg.goBack, colorFilter: AppColors.svg(Colors.black),),
          ),

        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(context, commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          5.width,
        ],
      ),
      bottomNavigationBar: buildPlaceOrderButtonWidget(),
      body: buildBodyWidget(context),
    );
  }

  Widget buildBodyWidget(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: AppColors.backgroundColor,
          child: Column(
            children: [
              10.height,
              Container(
                padding: EdgeInsets.all(commonSafeAreaPadding),
                decoration: commonContainerDecoration(
                  borderRadius: BorderRadius.zero,
                ),
                child: ReferralAutoCompleteTextField(
                  controller: referralCodeController,
                  labelText: 'Referral Code (Optional)',
                  onSelected: (value) {
                    // Referral code selected
                  },
                ),
              ),
              10.height,
              // Product details
              Container(
                padding: EdgeInsets.all(commonSafeAreaPadding),
                decoration: commonContainerDecoration(
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.appText.productDetails,
                      style: AppTextStyle.h5,
                    ),
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
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(_quantities);
                        syncVehicleControllersWithProducts();
                        loadVehicleSelection();
                      },
                      label: Text(
                        'Add More Kavach',
                        style: AppTextStyle.primaryColor16w400,
                      ),
                      icon: Icon(Icons.add, color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ),
              15.height,
              //address
              Container(
                padding: EdgeInsets.all(commonSafeAreaPadding),
                alignment: Alignment.centerLeft,
                decoration: commonContainerDecoration(
                  borderRadius: BorderRadius.zero,
                ),
                child: Form(
                  key: formKeyCheckout,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Billing Address
                      BlocBuilder<KavachCheckoutBillingAddressBloc, KavachCheckoutBillingAddressState>(
                        builder: (context, state) {
                          if (state is KavachCheckoutBillingAddressLoading) {
                            return AppTextField(
                              readOnly: true,
                              autofocus: false,
                              labelText: context.appText.billingAddress,
                              mandatoryStar: true,
                              decoration: kavachInputDecoration(
                                suffixIcon: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          }
                          if (state is KavachCheckoutBillingAddressSelected) {
                            final address = state.selectedAddress;
                            return addressWidget(
                              address: address,
                              onChangeTap: () {
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: const KavachBillingAddressListScreen(),
                                );
                              },
                              title: context.appText.billingAddress,
                            );
                          }
                          if (state is KavachCheckoutBillingAddressEmpty) {
                            return AppTextField(
                              readOnly: true,
                              autofocus: false,
                              labelText: context.appText.billingAddress,
                              mandatoryStar: true,
                              decoration: kavachInputDecoration(
                                suffixIcon: Icon(
                                  Icons.chevron_right,
                                  color: AppColors.chevronGreyColor,
                                ),
                              ),
                              onTextFieldTap: () {
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: const KavachBillingAddressListScreen(),
                                );
                              },
                            );
                          }
                          if (state is KavachCheckoutBillingAddressAvailable) {
                            return AppTextField(
                              readOnly: true,
                              autofocus: false,
                              labelText: context.appText.billingAddress,
                              mandatoryStar: true,
                              decoration: kavachInputDecoration(
                                suffixIcon: Icon(
                                  Icons.chevron_right,
                                  color: AppColors.chevronGreyColor,
                                ),
                              ),
                              onTextFieldTap: () {
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: const KavachBillingAddressListScreen(),
                                );
                              },
                            );
                          }
                          if (state is KavachCheckoutBillingAddressError) {
                            return AppTextField(
                              readOnly: true,
                              autofocus: false,
                              labelText: context.appText.billingAddress,
                              mandatoryStar: true,
                              decoration: kavachInputDecoration(
                                suffixIcon: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                              onTextFieldTap: () {
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: const KavachBillingAddressListScreen(),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      15.height,
                      //Shipping Address
                      BlocBuilder<KavachCheckoutShippingAddressBloc, KavachCheckoutShippingAddressState>(
                        builder: (context, state) {
                          if (state is KavachCheckoutShippingAddressLoading) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.appText.shippingAddress,
                                      style: AppTextStyle.textFiled,
                                    ).paddingLeft(3),
                                    Text(
                                      " *",
                                      style: AppTextStyle.textFiled.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                5.height,
                                Visibility(
                                  visible: shippingSameAsBilling == false,
                                  child: AppTextField(
                                    readOnly: true,
                                    autofocus: false,
                                    decoration: kavachInputDecoration(
                                      suffixIcon: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                checkBoxSameAsShipping(),
                              ],
                            );
                          }
                          if (state is KavachCheckoutShippingAddressSelected) {
                            final address = state.selectedAddress;
                            return Column(
                              children: [
                                Visibility(
                                  visible: shippingSameAsBilling,
                                  child: Row(
                                    children: [
                                      Text(
                                        context.appText.shippingAddress,
                                        style: AppTextStyle.textFiled,
                                      ).paddingLeft(3),
                                      Text(
                                        " *",
                                        style: AppTextStyle.textFiled.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                5.height,
                                Visibility(
                                  visible: shippingSameAsBilling == false,
                                  child: addressWidget(
                                    address: address,
                                    onChangeTap: () {
                                      commonBottomSheetWithBGBlur(
                                        context: context,
                                        screen:
                                        const KavachShippingAddressListScreen(),
                                      );
                                    },
                                    title: context.appText.shippingAddress,
                                  ),
                                ),
                                5.height,
                                checkBoxSameAsShipping(),
                              ],
                            );
                          }

                          if (state is KavachCheckoutShippingAddressEmpty) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.appText.shippingAddress,
                                      style: AppTextStyle.textFiled,
                                    ).paddingLeft(3),
                                    Text(
                                      " *",
                                      style: AppTextStyle.textFiled.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                5.height,
                                Visibility(
                                  visible: shippingSameAsBilling == false,
                                  child: AppTextField(
                                    readOnly: true,
                                    autofocus: false,
                                    decoration: kavachInputDecoration(
                                      suffixIcon: Icon(
                                        Icons.chevron_right,
                                        color: AppColors.chevronGreyColor,
                                      ),
                                    ),
                                    onTextFieldTap: () {
                                      commonBottomSheetWithBGBlur(
                                        context: context,
                                        screen:
                                        const KavachShippingAddressListScreen(),
                                      );
                                    },
                                    // validator: (value) => Validator.fieldRequired(value,fieldName: context.appText.addressName),
                                  ),
                                ),
                                checkBoxSameAsShipping(),
                              ],
                            );
                          }
                          if (state is KavachCheckoutShippingAddressAvailable) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.appText.shippingAddress,
                                      style: AppTextStyle.textFiled,
                                    ).paddingLeft(3),
                                    Text(
                                      " *",
                                      style: AppTextStyle.textFiled.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                5.height,
                                Visibility(
                                  visible: shippingSameAsBilling == false,
                                  child: AppTextField(
                                    readOnly: true,
                                    autofocus: false,
                                    decoration: kavachInputDecoration(
                                      suffixIcon: Icon(
                                        Icons.chevron_right,
                                        color: AppColors.chevronGreyColor,
                                      ),
                                    ),
                                    onTextFieldTap: () {
                                      commonBottomSheetWithBGBlur(
                                        context: context,
                                        screen:
                                        const KavachShippingAddressListScreen(),
                                      );
                                    },
                                  ),
                                ),
                                checkBoxSameAsShipping(),
                              ],
                            );
                          }
                          if (state is KavachCheckoutShippingAddressError) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      context.appText.shippingAddress,
                                      style: AppTextStyle.textFiled,
                                    ).paddingLeft(3),
                                    Text(
                                      " *",
                                      style: AppTextStyle.textFiled.copyWith(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                5.height,
                                Visibility(
                                  visible: shippingSameAsBilling == false,
                                  child: AppTextField(
                                    readOnly: true,
                                    autofocus: false,
                                    decoration: kavachInputDecoration(
                                      suffixIcon: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTextFieldTap: () {
                                      commonBottomSheetWithBGBlur(
                                        context: context,
                                        screen:
                                        const KavachShippingAddressListScreen(),
                                      );
                                    },
                                  ),
                                ),
                                checkBoxSameAsShipping(),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      10.height,
                      AppTextField(
                        controller: shippingPersonInChargeController,
                        decoration: kavachInputDecoration(hintText: context.appText.personInCharge,isMandatoryMark: true),
                        validator: (value) => Validator.fieldRequired(value,fieldName: context.appText.personInCharge),
                      ),
                      10.height,
                      AppTextField(
                        controller: shippingPersonContactNoController,
                        decoration: kavachInputDecoration(hintText: context.appText.contactNo,isMandatoryMark: true),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) => Validator.phone(value),
                      ),
                    ],
                  ),
                ),
              ),
              40.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget productWidget(KavachProduct product, int quantity) {
    num totalPrice = product.price * quantity;
    final vehicleControllers = vehicleControllersPerProduct[product.id] ?? [];
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
                  onIncrement: () {
                    final stock = _availableStocks[product.id] ?? 0;
                    final currentQty = _quantities[product.id] ?? 0;

                    if (currentQty < stock) {
                      loadVehicleSelection();
                      setState(() {
                        _quantities[product.id] = currentQty + 1;
                        loadVehicleSelection();
                      });
                    } else {
                      ToastMessages.alert(message: context.appText.unableToAddMoreItems);
                    }
                  },

                  onDecrement: () {
                    if (quantity > 1) {
                      setState(() {
                        _quantities[product.id] = quantity - 1;
                        loadVehicleSelection();
                      });
                    } else {
                      // Quantity will become 0 – remove the product
                      setState(() {
                        _quantities.remove(product.id);
                        _products.removeWhere((p) => p.id == product.id);
                        syncVehicleControllersWithProducts();
                        loadVehicleSelection();
                      });
                    }
                  },
                ),
              ],
            ),
            5.height,
            Row(
              children: [
                Text(product.part, style: AppTextStyle.bodyGreyColor).expand(),
                Text(
                  "$indianCurrencySymbol ${totalPrice.toStringAsFixed(2)}",
                  style: AppTextStyle.h4PrimaryColor,
                ),
              ],
            ),
            12.height,
            Column(
              children: List.generate(vehicleControllers.length, (index) {
                return AppTextField(
                  controller: vehicleControllers[index],
                  onTextFieldTap: () async {
                    final selectedVehicle =
                        await commonBottomSheet<String?>(
                          context: context,
                          screen: const KavachAddedVehiclesScreen(),
                          barrierDismissible: true
                        );
                    // if (selectedVehicle != null) {
                    //   setState(() {
                    //     vehicleControllers[index].text = selectedVehicle;
                    //   });
                    // }
                    if (selectedVehicle != null) {
                      final isAlreadySelected = isVehicleAlreadySelected(selectedVehicle);
                      if (isAlreadySelected &&
                          vehicleControllers[index].text.trim() != selectedVehicle) {
                        ToastMessages.alert(
                          message: 'Vehicle already selected',
                        );
                        return;
                      } else {
                        setState(() {
                          vehicleControllers[index].text = selectedVehicle;
                        });
                      }
                    }
                  },
                  readOnly: true,
                  decoration: kavachInputDecoration(
                    hintText: context.appText.selectVehicleRegNum,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              AppColors.lightBlueIconBackgroundColor2,
                          child: SvgPicture.asset(
                            AppIcons.svg.truck,
                            colorFilter: AppColors.svg(AppColors.primaryColor),
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: AppColors.chevronGreyColor,
                        ).paddingSymmetric(horizontal: 5),
                      ],
                    ),
                  ),
                ).paddingBottom(10);
              }),
            ),
          ],
        ).expand(),
      ],
    ).paddingSymmetric(horizontal: 10);
  }

  Widget buildPlaceOrderButtonWidget() {
    return AppButton(
      title: context.appText.placeOrder,
      onPressed: () {
        final shippingState =
            context.read<KavachCheckoutShippingAddressBloc>().state;
        final billingState =
            context.read<KavachCheckoutBillingAddressBloc>().state;
        final selectedVehicles = <String>[];

        vehicleControllersPerProduct.forEach((productId, controllers) {
          for (var controller in controllers) {
            if (controller.text.trim().isNotEmpty) {
              selectedVehicles.add(controller.text.trim());
            }
          }
        });

        if (!formKeyCheckout.currentState!.validate()) return;

        // Validate products in cart
        if (_products.isEmpty || _quantities.isEmpty) {
          ToastMessages.alert(
            message: context.appText.pleaseAddProducts,
          );
          return; // Stop further execution
        }

        // Validate shipping address
        if (shippingState is KavachCheckoutShippingAddressEmpty) {
          ToastMessages.alert(message: context.appText.pleaseAddShippingAddress);
          return;
        }
        if (shippingState is KavachCheckoutShippingAddressLoading) {
          ToastMessages.alert(
            message: context.appText.shippingLoading,
          );
          return;
        }
        if (shippingState is KavachCheckoutShippingAddressError) {
          ToastMessages.alert(
            message: context.appText.shippingLoadFailed,
          );
          return;
        }

        // Validate billing address
        if (billingState is KavachCheckoutBillingAddressEmpty) {
          ToastMessages.alert(message: context.appText.pleaseAddBillingAddress);
          return;
        }
        if (billingState is KavachCheckoutBillingAddressLoading) {
          ToastMessages.alert(
            message: context.appText.billingLoading,
          );
          return;
        }
        if (billingState is KavachCheckoutBillingAddressError) {
          ToastMessages.alert(
            message: context.appText.billingLoadFailed,
          );
          return;
        }

        final allVehiclesFilled = vehicleControllersPerProduct.values.every(
          (controllers) => controllers.every((c) => c.text.trim().isNotEmpty),
        );
        if (!allVehiclesFilled) {
          ToastMessages.alert(
            message: context.appText.pleaseSelectAllVehicles,
          );
          return;
        }

        // If all validations pass, proceed to summary screen
        if (shippingState is KavachCheckoutShippingAddressSelected &&
            billingState is KavachCheckoutBillingAddressSelected) {
          Navigator.of(context).push(
            commonRoute(
              KavachSummaryScreen(
                products: _products,
                quantities: _quantities,
                availableStocks: _availableStocks,
                shippingAddress: shippingState.selectedAddress,
                billingAddress: billingState.selectedAddress,
                selectedVehicleNumbers: selectedVehicles,
                shippingPersonContactNo: shippingPersonContactNoController.text.trim(),
                shippingPersonInCharge: shippingPersonInChargeController.text.trim(),
                orderReferencedBy: referralCodeController.text.trim(),
                selectedVehiclePerProduct: vehicleControllersPerProduct.map(
                      (key, value) => MapEntry(
                    key,
                    value.map((controller) => controller.text.trim()).toList(),
                  ),
                ),
              ),
            ),
          );
        } else {
          ToastMessages.alert(message: context.appText.completeAllFields);
        }
      },
    ).bottomNavigationPadding();
  }

  Widget checkBoxSameAsShipping() {
    return AppCheckBox(
      onChanged: (checked) {
        setState(() {
          shippingSameAsBilling = checked ?? false;
        });

        final shippingBloc = context.read<KavachCheckoutShippingAddressBloc>();
        final billingState =
            context.read<KavachCheckoutBillingAddressBloc>().state;

        if (shippingSameAsBilling) {
          if (billingState is KavachCheckoutBillingAddressSelected) {
            shippingBloc.add(
              SelectKavachShippingAddress(billingState.selectedAddress),
            );
          } else {
            ToastMessages.alert(
              message: context.appText.pleaseSelectBillingFirst,
            );
          }
        } else {
          shippingBloc.add(ClearKavachShippingAddress());
          shippingBloc.add(FetchKavachShippingAddresses());
        }
      },
      value: shippingSameAsBilling,
      title: context.appText.sameAsBillingAddress,
    );
  }

  InputDecoration kavachInputDecoration({Widget? suffixIcon, String? hintText,bool? isMandatoryMark}){
    return InputDecoration(
      hint: Row(
        children: [
          Text(hintText??'', style: AppTextStyle.textFieldHint),
          if(isMandatoryMark??false)Text(" *", style:AppTextStyle.textFiled.copyWith(color: Colors.red)),
        ],
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      suffixIcon: suffixIcon,
      counterText: ''
    );
  }

  Widget addressWidget({
    required address,
    required Function() onChangeTap,
    required String title,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyle.textFiled),
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
          ],
        ),
        5.height,
        Container(
          padding: EdgeInsets.all(10),
          decoration: commonContainerDecoration(
            color: AppColors.greyContainerBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      address.addressName,
                      style: AppTextStyle.blackColor14w400,
                    ),
                  ),
                  InkWell(
                    onTap: onChangeTap,
                    child: Text(
                      context.appText.change,
                      style: AppTextStyle.primaryColor14w700,
                    ),
                  ),
                ],
              ),
              Text(address.fullAddress, style: AppTextStyle.blackColor14w400),
              Visibility(
                visible: address.gstin != null && address.gstin!.isNotEmpty,
                child: Text(
                  "${context.appText.gstKavach} - ${address.gstin}",
                  style: AppTextStyle.blackColor14w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
