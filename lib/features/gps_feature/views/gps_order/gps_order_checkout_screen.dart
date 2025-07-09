import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kavach/view/kavach_added_vehicles_bottom_sheet.dart';
import 'package:gro_one_app/features/kavach/view/kavach_billing_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_shipping_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/referral_autocomplete_textfield.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../data/model/result.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_check_box.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_field.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/constant_variables.dart';
import '../../../../utils/validator.dart';
import '../../../../utils/app_bottom_sheet_body.dart';
import '../../../../utils/app_search_bar.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../features/gps_feature/cubit/gps_order_cubit_folder/gps_billing_address_cubit.dart';
import '../../../../features/gps_feature/cubit/gps_order_cubit_folder/gps_shipping_address_cubit.dart';
import '../../models/gps_document_models.dart';
import '../../gps_order_repo/gps_order_api_repository.dart';
import 'gps_order_summary_screen.dart';
import '../../../../features/kavach/view/widgets/product_counter.dart';



// Address Model
class Address {
  final String addressName;
  final String fullAddress;
  final String? gstin;

  Address({
    required this.addressName,
    required this.fullAddress,
    this.gstin,
  });
}

// Vehicle Model
class Vehicle {
  final String vehicleNumber;
  final String? truckMakeAndModel;
  final String? truckType;
  final String? truckSubType;
  final int vehicleStatus; // 1 for active, 0 for inactive

  Vehicle({
    required this.vehicleNumber,
    this.truckMakeAndModel,
    this.truckType,
    this.truckSubType,
    this.vehicleStatus = 1,
  });
}

// Product Counter Widget
class ProductCounter extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductCounter({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: Icon(Icons.remove, color: AppColors.primaryColor),
        ),
        Text(
          count.toString(),
          style: AppTextStyle.h5,
        ),
        IconButton(
          onPressed: onIncrement,
          icon: Icon(Icons.add, color: AppColors.primaryColor),
        ),
      ],
    );
  }
}

// Referral Auto Complete Text Field
class ReferralAutoCompleteTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<String> suggestions;
  final String labelText;
  final Function(String) onSelected;

  const ReferralAutoCompleteTextField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.labelText,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return AppTextField(
          controller: controller,
          currentFocus: focusNode,
          labelText: labelText,
          decoration: commonInputDecoration(hintText: labelText),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return suggestions;
        }
        return suggestions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
    );
  }
}

// GPS Address List Screen
class GpsAddressListScreen extends StatefulWidget {
  final List<Address> addresses;
  final String title;
  final Address? selectedAddress;
  final Function(Address) onAddressSelected;

  const GpsAddressListScreen({
    super.key,
    required this.addresses,
    required this.title,
    this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  State<GpsAddressListScreen> createState() => _GpsAddressListScreenState();
}

class _GpsAddressListScreenState extends State<GpsAddressListScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: widget.title,
      hideDivider: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shrinkWrap: true,
                itemCount: widget.addresses.length,
                separatorBuilder: (context, index) => 10.height,
                itemBuilder: (context, index) {
                  final address = widget.addresses[index];
                  return AddressListItem(
                    address: address,
                    isSelected: widget.selectedAddress?.addressName == address.addressName,
                    onTap: () {
                      widget.onAddressSelected(address);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            20.height,
            AppButton(
              onPressed: () {
                if (widget.selectedAddress != null) {
                  Navigator.pop(context, widget.selectedAddress);
                } else {
                  ToastMessages.alert(message: 'Please select an address');
                }
              },
              title: context.appText.deliverHere,
              style: AppButtonStyle.primary,
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}

// Address List Item
class AddressListItem extends StatelessWidget {
  final Address address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressListItem({
    super.key,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: commonContainerDecoration(color: AppColors.greyContainerBackgroundColor),
        child: Row(
          children: [
            Radio<Address>(
              value: address,
              groupValue: isSelected ? address : null,
              onChanged: (_) => onTap(),
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

// GPS Vehicle Selection Screen
class GpsVehicleSelectionScreen extends StatefulWidget {
  final List<Vehicle> vehicles;
  final Function(Vehicle) onVehicleSelected;

  const GpsVehicleSelectionScreen({
    super.key,
    required this.vehicles,
    required this.onVehicleSelected,
  });

  @override
  State<GpsVehicleSelectionScreen> createState() => _GpsVehicleSelectionScreenState();
}

class _GpsVehicleSelectionScreenState extends State<GpsVehicleSelectionScreen> {
  final searchController = TextEditingController();
  List<Vehicle> filteredVehicles = [];

  @override
  void initState() {
    super.initState();
    filteredVehicles = widget.vehicles;
  }

  void _filterVehicles(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredVehicles = widget.vehicles;
      } else {
        filteredVehicles = widget.vehicles.where((vehicle) {
          return vehicle.vehicleNumber.toLowerCase().contains(searchText.toLowerCase()) ||
                 (vehicle.truckMakeAndModel?.toLowerCase().contains(searchText.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  Widget vehicleCard(Vehicle vehicle) {
    return InkWell(
      onTap: () {
        if (vehicle.vehicleStatus == 1) {
          widget.onVehicleSelected(vehicle);
          Navigator.pop(context, vehicle.vehicleNumber);
        } else {
          ToastMessages.alert(message: 'Vehicle is currently inactive');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightBlueIconBackgroundColor2,
              child: SvgPicture.asset(
                AppIcons.svg.truck,
                colorFilter: AppColors.svg(AppColors.primaryColor),
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vehicle.vehicleNumber,
                        style: AppTextStyle.h4.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      6.width,
                      if (vehicle.vehicleStatus == 1)
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 18,
                        ),
                    ],
                  ),
                  if (vehicle.truckMakeAndModel != null)
                    Text(
                      vehicle.truckMakeAndModel!,
                      style: AppTextStyle.bodyBlackColorW500,
                    ),
                  if (vehicle.truckType != null)
                    Text(
                      '${vehicle.truckType} - ${vehicle.truckSubType ?? ''}',
                      style: AppTextStyle.textGreyColor12w400,
                    ),
                ],
              ),
            ),
            if (vehicle.vehicleStatus == 1)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F8ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  context.appText.active,
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            10.height,
            Text(
              context.appText.selectVehicleRegNum,
              style: AppTextStyle.appBar.copyWith(
                color: AppColors.primaryTextColor,
              ),
            ),
            10.height,
            AppSearchBar(
              searchController: searchController,
              onChanged: _filterVehicles,
            ),
            Expanded(
              child: filteredVehicles.isEmpty
                  ? Center(
                      child: Text(context.appText.noVehiclesFound),
                    )
                  : ListView.separated(
                      itemCount: filteredVehicles.length,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      separatorBuilder: (_, __) => 12.height,
                      itemBuilder: (_, index) {
                        final vehicle = filteredVehicles[index];
                        return vehicleCard(vehicle);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class GpsOrderCheckoutScreen extends StatefulWidget {
  final List<GpsProduct> products;
  final Map<String, int> quantities;

  const GpsOrderCheckoutScreen({
    super.key,
    required this.products,
    required this.quantities,
  });

  @override
  State<GpsOrderCheckoutScreen> createState() => _GpsOrderCheckoutScreenState();
}

class _GpsOrderCheckoutScreenState extends State<GpsOrderCheckoutScreen> {
  Map<String, List<TextEditingController>> vehicleControllersPerProduct = {};
  final gpsShippingAddressCubit =
      locator<GpsShippingAddressCubit>();
  final gpsBillingAddressCubit =
      locator<GpsBillingAddressCubit>();

  late Map<String, int> _quantities;
  late List<GpsProduct> _products;
  bool shippingSameAsBilling = false;
  late Map<String, int> _availableStocks;
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController shippingPersonInChargeController = TextEditingController();
  TextEditingController shippingPersonContactNoController = TextEditingController();
  final formKeyCheckout = GlobalKey<FormState>();

  List<String> referralSuggestions = [
    'John Doe GDP67543',
    'David GDP67544',
    'Michael GDP67545',
    'Sarah GDP67546',
  ];

  @override
  void initState() {
    super.initState();
    _quantities = Map<String, int>.from(widget.quantities);
    _products = List<GpsProduct>.from(widget.products);
    _availableStocks = {};

    for (var product in _products) {
      // For now, set default stock. Later we can fetch from API
      _availableStocks[product.id] = 10;
    }
    loadVehicleSelection();
    gpsShippingAddressCubit.fetchGpsShippingAddresses();
    gpsBillingAddressCubit.fetchGpsBillingAddresses();
  }

  @override
  void dispose() {
    referralCodeController.dispose();
    shippingPersonInChargeController.dispose();
    shippingPersonContactNoController.dispose();
    for (var controllers in vehicleControllersPerProduct.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void syncVehicleControllersWithProducts() {
    vehicleControllersPerProduct.removeWhere(
          (productId, _) => !_products.any((p) => p.id == productId),
    );
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        centreTile: false,
        title: context.appText.checkout,
        leading : IconButton(
            onPressed: () {
              Navigator.of(context).pop(_quantities);
            },
            icon: SvgPicture.asset(AppIcons.svg.goBack, colorFilter: AppColors.svg(Colors.black),),
          ),

        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(context, commonRoute(Scaffold(
                appBar: AppBar(title: Text('Support')),
                body: Center(child: Text('Support Screen')),
              )));
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
                  suggestions: referralSuggestions,
                  labelText: 'Referral Code (Optional)',
                  onSelected: (value) {
                    print('Selected: $value');
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
                        'Add More GPS Devices',
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
                      BlocBuilder<GpsBillingAddressCubit, GpsBillingAddressState>(
                        bloc: gpsBillingAddressCubit,
                        builder: (context, state) {
                          if (state is GpsBillingAddressSelected) {
                            final address = state.selectedAddress;
                            return addressWidget(
                              address: address,
                              onChangeTap: () {
                                // TODO: Create GPS billing address list screen
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: const KavachBillingAddressListScreen(),
                                );
                              },
                              title: context.appText.billingAddress,
                            );
                          }
                          if (state is GpsBillingAddressEmpty) {
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
                                // TODO: Create GPS billing address list screen
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
                      BlocBuilder<GpsShippingAddressCubit, GpsShippingAddressState>(
                        bloc: gpsShippingAddressCubit,
                        builder: (context, state) {
                          if (state is GpsShippingAddressSelected) {
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
                                      // TODO: Create GPS shipping address list screen
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

                          if (state is GpsShippingAddressEmpty) {
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
                                      // TODO: Create GPS shipping address list screen
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

  Widget productWidget(GpsProduct product, int quantity) {
    num totalPrice = (double.tryParse(product.price) ?? 0.0) * quantity;
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
                Text(product.part ?? '', style: AppTextStyle.bodyGreyColor).expand(),
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
        final shippingState = gpsShippingAddressCubit.state;
        final billingState = gpsBillingAddressCubit.state;
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
        if (shippingState is GpsShippingAddressEmpty) {
          ToastMessages.alert(message: context.appText.pleaseAddShippingAddress);
          return;
        }
        if (shippingState is GpsShippingAddressLoading) {
          ToastMessages.alert(
            message: context.appText.shippingLoading,
          );
          return;
        }
        if (shippingState is GpsShippingAddressError) {
          ToastMessages.alert(
            message: context.appText.shippingLoadFailed,
          );
          return;
        }

        // Validate billing address
        if (billingState is GpsBillingAddressEmpty) {
          ToastMessages.alert(message: context.appText.pleaseAddBillingAddress);
          return;
        }
        if (billingState is GpsBillingAddressLoading) {
          ToastMessages.alert(
            message: context.appText.billingLoading,
          );
          return;
        }
        if (billingState is GpsBillingAddressError) {
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
        if (shippingState is GpsShippingAddressSelected &&
            billingState is GpsBillingAddressSelected) {
          Navigator.of(context).push(
            commonRoute(
              GpsOrderSummaryScreen(),
            ),
          );
        } else {
          ToastMessages.alert(message: context.appText.completeAllFields);
        }
      },
    ).bottomNavigationPadding();
  }

  double _calculateTotal() {
    double total = 0;
    for (var product in _products) {
      final quantity = _quantities[product.id] ?? 0;
      total += (double.tryParse(product.price) ?? 0.0) * quantity;
    }
    return total;
  }

  Widget checkBoxSameAsShipping() {
    return AppCheckBox(
      onChanged: (checked) {
        setState(() {
          shippingSameAsBilling = checked ?? false;
        });

        final billingState = gpsBillingAddressCubit.state;

        if (shippingSameAsBilling) {
          if (billingState is GpsBillingAddressSelected) {
            gpsShippingAddressCubit.selectGpsShippingAddress(billingState.selectedAddress);
          } else {
            ToastMessages.alert(
              message: context.appText.pleaseSelectBillingFirst,
            );
          }
        } else {
          gpsShippingAddressCubit.clearGpsShippingAddress();
          gpsShippingAddressCubit.fetchGpsShippingAddresses();
        }
      },
      value: shippingSameAsBilling,
      title: context.appText.sameAsBillingAddress,
    );
  }

  InputDecoration kavachInputDecoration({Widget? suffixIcon, String? hintText, bool? isMandatoryMark}) {
    return InputDecoration(
      hint: Row(
        children: [
          Text(hintText ?? '', style: AppTextStyle.textFieldHint),
          if (isMandatoryMark ?? false)
            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
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
      counterText: '',
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