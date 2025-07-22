import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import '../../../kavach/helper/kavach_helper.dart';
import '../../../kavach/view/kavach_support_screen.dart';

import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
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
import '../../../../features/gps_feature/cubit/gps_order_cubit_folder/gps_billing_address_cubit.dart';
import '../../../../features/gps_feature/cubit/gps_order_cubit_folder/gps_shipping_address_cubit.dart';
import '../../../../features/login/repository/user_information_repository.dart';
import '../../models/gps_document_models.dart';
import '../../gps_order_repo/gps_order_api_repository.dart';
import 'gps_billing_address_list_screen.dart';
import 'gps_shipping_address_list_screen.dart';
import 'gps_order_summary_screen.dart';
import '../../../../features/kavach/view/widgets/product_counter.dart';
import '../widgets/referral_autocomplete_textfield.dart';
import '../../../../features/kavach/view/widgets/vehicle_selection_field.dart';
import '../../../kavach/model/kavach_address_model.dart';

class GpsOrderCheckoutScreen extends StatefulWidget {
  final List<GpsProduct> products;
  final Map<String, int> quantities;
  final Map<String, List<String>>? previousVehicleSelection;
  final String? previousReferralCode;
  final bool? previousShippingSameAsBilling;
  final String? previousShippingPersonInCharge;
  final String? previousShippingPersonContactNo;

  const GpsOrderCheckoutScreen({
    super.key,
    required this.products,
    required this.quantities,
    this.previousVehicleSelection,
    this.previousReferralCode,
    this.previousShippingSameAsBilling,
    this.previousShippingPersonInCharge,
    this.previousShippingPersonContactNo,
  });

  @override
  State<GpsOrderCheckoutScreen> createState() => _GpsOrderCheckoutScreenState();
}

class _GpsOrderCheckoutScreenState extends State<GpsOrderCheckoutScreen> with WidgetsBindingObserver {
  Map<String, List<TextEditingController>> vehicleControllersPerProduct = {};
  Map<String, List<bool>> vehicleVerificationStatusPerProduct = {}; // Track verification status
  late final GpsShippingAddressCubit gpsShippingAddressCubit;
  late final GpsBillingAddressCubit gpsBillingAddressCubit;

  late Map<String, int> _quantities;
  late List<GpsProduct> _products;
  bool shippingSameAsBilling = false;
  late Map<String, int> _availableStocks;
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController shippingPersonInChargeController = TextEditingController();
  TextEditingController shippingPersonContactNoController = TextEditingController();
  final formKeyCheckout = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _quantities = Map<String, int>.from(widget.quantities);
    _products = List<GpsProduct>.from(widget.products);
    _availableStocks = {};

    for (var product in _products) {
      // For now, set default stock. Later we can fetch from API
      _availableStocks[product.id] = 10;
    }

    // Restore previous form data if available
    if (widget.previousReferralCode != null && widget.previousReferralCode!.isNotEmpty) {
      referralCodeController.text = widget.previousReferralCode!;
    }

    if (widget.previousShippingSameAsBilling != null) {
      shippingSameAsBilling = widget.previousShippingSameAsBilling!;
    }

    if (widget.previousShippingPersonInCharge != null && widget.previousShippingPersonInCharge!.isNotEmpty) {
      shippingPersonInChargeController.text = widget.previousShippingPersonInCharge!;
    }

    if (widget.previousShippingPersonContactNo != null && widget.previousShippingPersonContactNo!.isNotEmpty) {
      shippingPersonContactNoController.text = widget.previousShippingPersonContactNo!;
    }

    // Initialize cubits
    try {
      gpsShippingAddressCubit = locator<GpsShippingAddressCubit>();
      gpsBillingAddressCubit = locator<GpsBillingAddressCubit>();
    } catch (e) {
      // Fallback: create new instances directly
      final repository = locator<GpsOrderApiRepository>();
      final userRepository = locator<UserInformationRepository>();
      gpsShippingAddressCubit = GpsShippingAddressCubit(repository, userRepository);
      gpsBillingAddressCubit = GpsBillingAddressCubit(repository, userRepository);
    }

    // Initialize vehicle controllers with previous selection if available
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
      
      // Initialize verification status - vehicles from previous selection are considered verified
      final verificationStatus = List<bool>.generate(qty, (index) {
        if (index < previousControllers.length && previousControllers[index].isNotEmpty) {
          return true; // Previously selected vehicles are verified
        } else {
          return false;
        }
      });
      vehicleVerificationStatusPerProduct[product.id] = verificationStatus;
    }

    // Initialize address cubits with state preservation

    // Only fetch billing addresses if not already available or selected
    if (gpsBillingAddressCubit.state is! GpsBillingAddressAvailable &&
        gpsBillingAddressCubit.state is! GpsBillingAddressSelected &&
        gpsBillingAddressCubit.state is! GpsBillingAddressLoading) {
      gpsBillingAddressCubit.fetchGpsBillingAddresses();
    }

    // Only fetch shipping addresses if not already available or selected
    if (gpsShippingAddressCubit.state is! GpsShippingAddressAvailable &&
        gpsShippingAddressCubit.state is! GpsShippingAddressSelected &&
        gpsShippingAddressCubit.state is! GpsShippingAddressLoading) {
      gpsShippingAddressCubit.fetchGpsShippingAddresses();
    }

    // Add a small delay to ensure cubits are properly initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRestoreAddressStates();
      _clearAddressSelectionsIfFreshOrder();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh addresses when screen becomes visible again
    _refreshAddressesIfNeeded();
  }

  /// Handle navigation back from address screens
  void _handleAddressScreenReturn() {
    // Refresh addresses immediately when returning from address screens
    if (mounted) {
      gpsBillingAddressCubit.fetchGpsBillingAddresses();
      gpsShippingAddressCubit.fetchGpsShippingAddresses();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App became visible again, refresh addresses if needed
      _refreshAddressesIfNeeded();
    }
  }

  /// Check and restore address states if needed
  void _checkAndRestoreAddressStates() {
    // If states are initial or empty, try to fetch addresses
    if (gpsBillingAddressCubit.state is GpsBillingAddressInitial ||
        gpsBillingAddressCubit.state is GpsBillingAddressEmpty) {
      gpsBillingAddressCubit.fetchGpsBillingAddresses();
    }

    if (gpsShippingAddressCubit.state is GpsShippingAddressInitial ||
        gpsShippingAddressCubit.state is GpsShippingAddressEmpty) {
      gpsShippingAddressCubit.fetchGpsShippingAddresses();
    }
  }

  /// Refresh addresses if they are in error state or empty
  void _refreshAddressesIfNeeded() {
    // Refresh billing addresses if in error state or empty
    if (gpsBillingAddressCubit.state is GpsBillingAddressError ||
        gpsBillingAddressCubit.state is GpsBillingAddressEmpty) {
      gpsBillingAddressCubit.fetchGpsBillingAddresses();
    }

    // Refresh shipping addresses if in error state or empty
    if (gpsShippingAddressCubit.state is GpsShippingAddressError ||
        gpsShippingAddressCubit.state is GpsShippingAddressEmpty) {
      gpsShippingAddressCubit.fetchGpsShippingAddresses();
    }
  }

  /// Clear address selections if this is a fresh order (no previous data)
  void _clearAddressSelectionsIfFreshOrder() {
    // Check if this is a fresh order by looking at previous data
    final hasPreviousData = widget.previousReferralCode != null && 
                           widget.previousReferralCode!.isNotEmpty ||
                           widget.previousVehicleSelection != null ||
                           widget.previousShippingPersonInCharge != null ||
                           widget.previousShippingPersonContactNo != null;

    // If no previous data, clear address selections
    if (!hasPreviousData) {
      print('🔄 GPS Checkout: Fresh order detected, clearing address selections');
      
      // Clear billing address selection but preserve loaded addresses
      if (gpsBillingAddressCubit.state is GpsBillingAddressSelected) {
        gpsBillingAddressCubit.clearGpsBillingAddressSelection();
      }
      
      // Clear shipping address selection but preserve loaded addresses
      if (gpsShippingAddressCubit.state is GpsShippingAddressSelected) {
        gpsShippingAddressCubit.clearGpsShippingAddressSelection();
      }
      
      // Reset shipping same as billing checkbox
      setState(() {
        shippingSameAsBilling = false;
      });
      
      print('🔄 GPS Checkout: Address selections cleared for fresh order');
    } else {
      print('🔄 GPS Checkout: Previous data detected, preserving address selections');
    }
  }

  // Helper function to get current selected addresses from cubits
  KavachAddressModel? _getCurrentShippingAddress() {
    final shippingState = gpsShippingAddressCubit.state;
    if (shippingState is GpsShippingAddressSelected) {
      return shippingState.selectedAddress;
    }
    return null;
  }

  KavachAddressModel? _getCurrentBillingAddress() {
    final billingState = gpsBillingAddressCubit.state;
    if (billingState is GpsBillingAddressSelected) {
      return billingState.selectedAddress;
    }
    return null;
  }

  void syncVehicleControllersWithProducts() {
    vehicleControllersPerProduct.removeWhere(
          (productId, _) => !_products.any((p) => p.id == productId),
    );
    vehicleVerificationStatusPerProduct.removeWhere(
      (productId, _) => !_products.any((p) => p.id == productId),
    );
  }

  void loadVehicleSelection() {
    for (var product in _products) {
      final productId = product.id;
      final qty = _quantities[productId] ?? 0;
      final existingControllers = vehicleControllersPerProduct[productId] ?? [];
      final existingVerificationStatus = vehicleVerificationStatusPerProduct[productId] ?? [];

      final newControllers = List<TextEditingController>.generate(qty, (index) {
        if (index < existingControllers.length) {
          return existingControllers[index]; // reuse existing
        } else {
          return TextEditingController(); // create new one
        }
      });

      final newVerificationStatus = List<bool>.generate(qty, (index) {
        if (index < existingVerificationStatus.length) {
          return existingVerificationStatus[index]; // reuse existing
        } else {
          return false; // new ones start as not verified
        }
      });

      vehicleControllersPerProduct[productId] = newControllers;
      vehicleVerificationStatusPerProduct[productId] = newVerificationStatus;
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
        leading: IconButton(
          onPressed: () {
            final result = {
              'quantities': _quantities,
              'vehicles': vehicleControllersPerProduct.map(
                    (key, value) => MapEntry(
                  key,
                  value.map((controller) => controller.text.trim()).toList(),
                ),
              ),
              'referralCode': referralCodeController.text.trim(),
              'shippingSameAsBilling': shippingSameAsBilling,
              'shippingPersonInCharge': shippingPersonInChargeController.text.trim(),
              'shippingPersonContactNo': shippingPersonContactNoController.text.trim(),
            };
            Navigator.of(context).pop(result);
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
            crossAxisAlignment: CrossAxisAlignment.start,
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

                  ],
                ),
              ),
              10.height,

              Container(
                  width: double.infinity,
                  decoration: commonContainerDecoration(
                      color: AppColors.white
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        final result = {
                          'quantities': _quantities,
                          'vehicles': vehicleControllersPerProduct.map(
                                (key, value) => MapEntry(
                              key,
                              value.map((controller) => controller.text.trim()).toList(),
                            ),
                          ),
                          'referralCode': referralCodeController.text.trim(),
                          'shippingSameAsBilling': shippingSameAsBilling,
                          'shippingPersonInCharge': shippingPersonInChargeController.text.trim(),
                          'shippingPersonContactNo': shippingPersonContactNoController.text.trim(),
                        };
                        Navigator.of(context).pop(result);
                      },
                      label: Text(
                        context.appText.addMoreGpsDevices,
                        style: AppTextStyle.primaryColor16w400,
                      ),
                      icon: Icon(Icons.add, color: AppColors.primaryColor),
                    ),
                  )
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
                      BlocProvider.value(
                        value: gpsBillingAddressCubit,
                        child: BlocBuilder<GpsBillingAddressCubit, GpsBillingAddressState>(
                          builder: (context, state) {
                            if (state is GpsBillingAddressSelected) {
                              final address = state.selectedAddress;
                              return addressWidget(
                                address: address,
                                onChangeTap: () {
                                  commonBottomSheetWithBGBlur(
                                    context: context,
                                    screen: GpsBillingAddressListScreen(
                                      billingAddressCubit: gpsBillingAddressCubit,
                                      selectedShippingAddress: _getCurrentShippingAddress(),
                                    ),
                                  ).then((_) {
                                    // Refresh addresses after returning from billing address screen
                                    _handleAddressScreenReturn();
                                  });
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
                                  commonBottomSheetWithBGBlur(
                                    context: context,
                                    screen: GpsBillingAddressListScreen(
                                      billingAddressCubit: gpsBillingAddressCubit,
                                      selectedShippingAddress: _getCurrentShippingAddress(),
                                    ),
                                  ).then((result) {
                                    // Handle the returned address
                                    if (result != null && result is KavachAddressModel) {
                                      // The address was selected and returned
                                      gpsBillingAddressCubit.selectGpsBillingAddress(result);
                                    }
                                    // Don't refresh addresses if no address was selected (user just closed the sheet)
                                  });
                                },
                              );
                            }
                            if (state is GpsBillingAddressAvailable) {
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
                                    screen: GpsBillingAddressListScreen(
                                      billingAddressCubit: gpsBillingAddressCubit,
                                      selectedShippingAddress: _getCurrentShippingAddress(),
                                    ),
                                  ).then((result) {
                                    // Handle the returned address
                                    if (result != null && result is KavachAddressModel) {
                                      // The address was selected and returned
                                      gpsBillingAddressCubit.selectGpsBillingAddress(result);
                                    }
                                    // Don't refresh addresses if no address was selected (user just closed the sheet)
                                  });
                                },
                              );
                            }
                            if (state is GpsBillingAddressLoading) {
                              return Column(
                                children: [
                                  Text(context.appText.billingAddress, style: AppTextStyle.textFiled),
                                  Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                                  5.height,
                                  AppTextField(
                                    readOnly: true,
                                    autofocus: false,
                                    //labelText: 'Loading addresses...',
                                    decoration: kavachInputDecoration(
                                      suffixIcon: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (state is GpsBillingAddressError) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(context.appText.billingAddress, style: AppTextStyle.textFiled),
                                      Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                                    ],
                                  ),

                                  5.height,
                                  AppTextField(
                                    readOnly: true,
                                    autofocus: false,
                                    //labelText: 'Error loading addresses',
                                    decoration: kavachInputDecoration(
                                      suffixIcon: Icon(
                                        Icons.chevron_right,
                                        color: AppColors.chevronGreyColor,
                                      ),
                                    ),
                                    onTextFieldTap: () {
                                      commonBottomSheetWithBGBlur(
                                        context: context,
                                        screen: GpsBillingAddressListScreen(
                                          billingAddressCubit: gpsBillingAddressCubit,
                                          selectedShippingAddress: _getCurrentShippingAddress(),
                                        ),
                                      ).then((result) {
                                        // Handle the returned address
                                        if (result != null && result is KavachAddressModel) {
                                          // The address was selected and returned
                                          gpsBillingAddressCubit.selectGpsBillingAddress(result);
                                        }
                                        // Don't refresh addresses if no address was selected (user just closed the sheet)
                                      });
                                    },
                                  ),
                                ],
                              );
                            }
                            // Fallback for any other state
                            return Column(
                              children: [
                                // Text(context.appText.billingAddress, style: AppTextStyle.textFiled),
                                // Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
                                5.height,
                                AppTextField(
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
                                      screen: GpsBillingAddressListScreen(
                                        billingAddressCubit: gpsBillingAddressCubit,
                                        selectedShippingAddress: _getCurrentShippingAddress(),
                                      ),
                                    ).then((result) {
                                      // Handle the returned address
                                      if (result != null && result is KavachAddressModel) {
                                        // The address was selected and returned
                                        gpsBillingAddressCubit.selectGpsBillingAddress(result);
                                      }
                                      // Don't refresh addresses if no address was selected (user just closed the sheet)
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      15.height,
                      //Shipping Address
                      BlocProvider.value(
                        value: gpsShippingAddressCubit,
                        child: BlocBuilder<GpsShippingAddressCubit, GpsShippingAddressState>(
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
                                      commonBottomSheetWithBGBlur(
                                        context: context,
                                        screen: GpsShippingAddressListScreen(
                                          shippingAddressCubit: gpsShippingAddressCubit,
                                          selectedBillingAddress: _getCurrentBillingAddress(),
                                        ),
                                      ).then((result) {
                                        // Handle the returned address
                                        if (result != null && result is KavachAddressModel) {
                                          // The address was selected and returned
                                          gpsShippingAddressCubit.selectGpsShippingAddress(result);
                                        }
                                        // Don't refresh addresses if no address was selected (user just closed the sheet)
                                      });
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
                                        commonBottomSheetWithBGBlur(
                                          context: context,
                                          screen: GpsShippingAddressListScreen(
                                            shippingAddressCubit: gpsShippingAddressCubit,
                                            selectedBillingAddress: _getCurrentBillingAddress(),
                                          ),
                                        ).then((result) {
                                          // Handle the returned address
                                          if (result != null && result is KavachAddressModel) {
                                            // The address was selected and returned
                                            gpsShippingAddressCubit.selectGpsShippingAddress(result);
                                          }
                                          // Don't refresh addresses if no address was selected (user just closed the sheet)
                                        });
                                      },
                                    ),
                                  ),
                                  checkBoxSameAsShipping(),
                                ],
                              );
                            }
                            if (state is GpsShippingAddressAvailable) {
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
                                          screen: GpsShippingAddressListScreen(
                                            shippingAddressCubit: gpsShippingAddressCubit,
                                            selectedBillingAddress: _getCurrentBillingAddress(),
                                          ),
                                        ).then((result) {
                                          // Handle the returned address
                                          if (result != null && result is KavachAddressModel) {
                                            // The address was selected and returned
                                            gpsShippingAddressCubit.selectGpsShippingAddress(result);
                                          }
                                          // Don't refresh addresses if no address was selected (user just closed the sheet)
                                        });
                                      },
                                    ),
                                  ),
                                  checkBoxSameAsShipping(),
                                ],
                              );
                            }

                            if (state is GpsShippingAddressLoading) {
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
                                      //labelText: 'Loading addresses...',
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

                            if (state is GpsShippingAddressError) {
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
                                      //labelText: 'Error loading addresses',
                                      decoration: kavachInputDecoration(
                                        suffixIcon: Icon(
                                          Icons.chevron_right,
                                          color: AppColors.chevronGreyColor,
                                        ),
                                      ),
                                      onTextFieldTap: () {
                                        commonBottomSheetWithBGBlur(
                                          context: context,
                                          screen: GpsShippingAddressListScreen(
                                            shippingAddressCubit: gpsShippingAddressCubit,
                                            selectedBillingAddress: _getCurrentBillingAddress(),
                                          ),
                                        ).then((result) {
                                          // Handle the returned address
                                          if (result != null && result is KavachAddressModel) {
                                            // The address was selected and returned
                                            gpsShippingAddressCubit.selectGpsShippingAddress(result);
                                          }
                                          // Don't refresh addresses if no address was selected (user just closed the sheet)
                                        });
                                      },
                                    ),
                                  ),
                                  checkBoxSameAsShipping(),
                                ],
                              );
                            }

                            // Fallback for any other state
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
                                    //labelText: context.appText.shippingAddress,
                                    decoration: kavachInputDecoration(
                                      suffixIcon: Icon(
                                        Icons.chevron_right,
                                        color: AppColors.chevronGreyColor,
                                      ),
                                    ),
                                    onTextFieldTap: () {
                                      commonBottomSheetWithBGBlur(
                                        context: context,
                                        screen: GpsShippingAddressListScreen(
                                          shippingAddressCubit: gpsShippingAddressCubit,
                                          selectedBillingAddress: _getCurrentBillingAddress(),
                                        ),
                                      ).then((result) {
                                        // Handle the returned address
                                        if (result != null && result is KavachAddressModel) {
                                          // The address was selected and returned
                                          gpsShippingAddressCubit.selectGpsShippingAddress(result);
                                        }
                                        // Don't refresh addresses if no address was selected (user just closed the sheet)
                                      });
                                    },
                                  ),
                                ),
                                checkBoxSameAsShipping(),
                              ],
                            );
                          },
                        ),
                      ),
                      10.height,
                      AppTextField(
                        controller: shippingPersonInChargeController,
                        decoration: kavachInputDecoration(hintText: context.appText.personInCharge,isMandatoryMark: true),
                        maxLength: 50,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                        ],
                        validator: (value) {
                          // First check if field is required
                          final requiredValidation = Validator.fieldRequired(
                            value,
                            fieldName: context.appText.personInCharge,
                          );
                          if (requiredValidation != null) {
                            return requiredValidation;
                          }
                          
                          // Check if contains only alphabets and spaces
                          if (value != null && value.isNotEmpty) {
                            final alphabetsOnly = RegExp(r'^[a-zA-Z\s]+$');
                            if (!alphabetsOnly.hasMatch(value)) {
                              return '${context.appText.personInCharge} should contain only alphabets';
                            }
                          }
                          
                          return null;
                        },
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
                      ToastMessages.alert(message: context.appText.cannotAddMoreItemsStockLimitReached);
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
                  "$indianCurrencySymbol ${KavachHelper.formatCurrency(totalPrice.toStringAsFixed(2))}",
                  style: AppTextStyle.h4PrimaryColor,
                ),
              ],
            ),
            12.height,
            Column(
              children: List.generate(vehicleControllers.length, (index) {
                final verificationStatus = vehicleVerificationStatusPerProduct[product.id]?[index] ?? false;
                return VehicleSelectionField(
                  controller: vehicleControllers[index],
                  hintText: context.appText.selectVehicleRegNum,
                  index: index,
                  isVerified: verificationStatus,
                  isVehicleAlreadySelected: isVehicleAlreadySelected(vehicleControllers[index].text.trim()),
                  onVehicleSelected: (selectedIndex, selectedVehicle) {
                    // Check for duplicates across all products, excluding the current field
                    bool isAlreadySelected = false;
                    vehicleControllersPerProduct.forEach((productId, controllers) {
                      for (int i = 0; i < controllers.length; i++) {
                        // Skip the current field being updated
                        if (productId == product.id && i == selectedIndex) continue;
                        
                        if (controllers[i].text.trim() == selectedVehicle.trim()) {
                          isAlreadySelected = true;
                          return;
                        }
                      }
                    });
                    
                    if (isAlreadySelected) {
                      ToastMessages.alert(message: context.appText.vehicleAlreadySelected);
                      return;
                    }
                    
                    // Set the vehicle in the controller only if no duplicates
                    vehicleControllers[selectedIndex].text = selectedVehicle;
                    // Mark as verified when selected from list
                    vehicleVerificationStatusPerProduct[product.id]![selectedIndex] = true;
                    setState(() {}); // Trigger rebuild to show green tick
                  },
                  onVehicleVerified: (verifiedVehicle) {
                    // Update verification status when manually verified
                    if (verifiedVehicle.isNotEmpty) {
                      vehicleVerificationStatusPerProduct[product.id]![index] = true;
                    } else {
                      // Reset verification status when text is cleared or changed
                      vehicleVerificationStatusPerProduct[product.id]![index] = false;
                    }
                    setState(() {}); // Trigger rebuild to update UI
                  },
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
              GpsOrderSummaryScreen(
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
          gpsShippingAddressCubit.clearGpsShippingAddressSelection();
          // No need to fetch again if addresses are already loaded
        }
      },
      value: shippingSameAsBilling,
      title: context.appText.sameAsBillingAddress,
    );
  }

  InputDecoration kavachInputDecoration({Widget? suffixIcon, String? hintText, bool? isMandatoryMark, Widget? preffixIcon}) {
    return InputDecoration(
      prefixIcon: preffixIcon,
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