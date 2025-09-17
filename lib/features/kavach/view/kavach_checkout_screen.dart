import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/kavach/view/kavach_billing_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_shipping_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_summary_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/referral_autocomplete_textfield.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/features/profile/view/widgets/add_new_support_ticket.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
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
import '../../load_provider/lp_home/cubit/lp_home_cubit.dart';
import '../../profile/view/support_screen.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_event.dart';
import '../bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_state.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_event.dart';
import '../bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_state.dart';
import '../helper/kavach_helper.dart';
import '../model/kavach_product_model.dart';
import '../model/kavach_address_model.dart';
import '../repository/kavach_repository.dart';
import 'widgets/product_counter.dart';
import 'widgets/vehicle_selection_field.dart';

class KavachCheckoutScreen extends StatefulWidget {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  final Map<String, List<String>>? previousVehicleSelection;
  final String? previousReferralCode;
  final String? previousShippingPersonInCharge;
  final String? previousShippingPersonContactNo;
  final bool? previousShippingSameAsBilling;
  final KavachAddressModel? selectedBillingAddress;
  final KavachAddressModel? selectedShippingAddress;
  final List<KavachAddressModel>? billingAddresses;
  final List<KavachAddressModel>? shippingAddresses;

  const KavachCheckoutScreen({
    super.key,
    required this.products,
    required this.quantities,
    this.previousVehicleSelection,
    this.previousReferralCode,
    this.previousShippingPersonInCharge,
    this.previousShippingPersonContactNo,
    this.previousShippingSameAsBilling,
    this.selectedBillingAddress,
    this.selectedShippingAddress,
    this.billingAddresses,
    this.shippingAddresses,
  });

  @override
  State<KavachCheckoutScreen> createState() => _KavachCheckoutScreenState();
}

class _KavachCheckoutScreenState extends State<KavachCheckoutScreen> {
  Map<String, List<TextEditingController>> vehicleControllersPerProduct = {};
  Map<String, List<bool>> vehicleVerificationStatusPerProduct =
      {}; // Track verification status
  final kavachCheckoutShippingAddressBloc =
      locator<KavachCheckoutShippingAddressBloc>();
  final kavachCheckoutBillingAddressBloc =
      locator<KavachCheckoutBillingAddressBloc>();
  final kavachOrderBloc = locator<KavachOrderBloc>();
  final profileCubit = locator<ProfileCubit>();
  final userInfoRepo = locator<UserInformationRepository>();

  late Map<String, int> _quantities;
  late List<KavachProduct> _products;
  bool shippingSameAsBilling = false;
  late Map<String, int> _availableStocks;
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController shippingPersonInChargeController =
      TextEditingController();
  TextEditingController shippingPersonContactNoController =
      TextEditingController();
  final formKeyCheckout = GlobalKey<FormState>();

  // Store selected addresses for restoration
  KavachAddressModel? selectedBillingAddress;
  KavachAddressModel? selectedShippingAddress;
  List<KavachAddressModel>? billingAddresses;
  List<KavachAddressModel>? shippingAddresses;

  // Store previous shipping address for restoration when checkbox is toggled
  KavachAddressModel? _previousShippingAddress;

  final lpHomeCubit = locator<LPHomeCubit>();

  void loadVehicleSelection() {
    for (var product in _products) {
      final productId = product.id;
      final qty = _quantities[productId] ?? 0;
      final existingControllers = vehicleControllersPerProduct[productId] ?? [];
      final existingVerificationStatus =
          vehicleVerificationStatusPerProduct[productId] ?? [];

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

  void syncVehicleControllersWithProducts() {
    vehicleControllersPerProduct.removeWhere(
      (productId, _) => !_products.any((p) => p.id == productId),
    );
    vehicleVerificationStatusPerProduct.removeWhere(
      (productId, _) => !_products.any((p) => p.id == productId),
    );
  }

  void restoreSelectedAddresses() {
    // Restore billing address if previously selected
    if (selectedBillingAddress != null && billingAddresses != null) {
      kavachCheckoutBillingAddressBloc.add(
        RestoreKavachBillingAddress(selectedBillingAddress!, billingAddresses!),
      );
    }

    // Restore shipping address if previously selected
    if (selectedShippingAddress != null && shippingAddresses != null) {
      kavachCheckoutShippingAddressBloc.add(
        RestoreKavachShippingAddress(
          selectedShippingAddress!,
          shippingAddresses!,
        ),
      );
    }
  }

  // Get customer information from profile or session
  Future<Map<String, String>> getCustomerInfo() async {
    try {
      // First try to get from session storage
      String? companyName = await userInfoRepo.getUsername();
      String? contactNumber = await userInfoRepo.getUserMobileNumber();
      String? blueId = await userInfoRepo.getBlueID();
      String? email = await userInfoRepo.getUserEmail();
      String? mobileNumber = await userInfoRepo.getUserMobileNumber();

      // If session data is not available, fetch from profile
      if (companyName == null || companyName.isEmpty) {
        await profileCubit.fetchProfileDetail();
        final profileState = profileCubit.state;

        if (profileState.profileDetailUIState?.data?.customer != null) {
          final customer = profileState.profileDetailUIState!.data!.customer!;
          companyName =
              customer.companyName.isNotEmpty
                  ? customer.companyName
                  : customer.customerName;
          contactNumber = customer.mobileNumber;
          mobileNumber = customer.mobileNumber;
          email = customer.emailId;
          blueId = customer.blueId?.toString() ?? "";
        }
      }

      // Fallback to hardcoded values if still not available
      return {
        "CompanyName":
            companyName?.isNotEmpty == true
                ? companyName!
                : "ABC Logistics Pvt Ltd",
        "contactNumber":
            contactNumber?.isNotEmpty == true ? contactNumber! : "9876543210",
        "BlueMembershipID": blueId?.isNotEmpty == true ? blueId! : "BLUE123456",
        "email": email ?? "venkat03it@gmail.com",
        "mobileNumber": mobileNumber ?? "9876543210",
      };
    } catch (e) {
      // Return hardcoded values as fallback
      return {
        "CompanyName": "ABC Logistics Pvt Ltd",
        "contactNumber": "9876543210",
        "BlueMembershipID": "BLUE123456",
        "email": "venkat03it@gmail.com",
        "mobileNumber": "9876543210",
      };
    }
  }

  // Get selected vehicles from all products
  List<String> _getSelectedVehicles() {
    final selectedVehicles = <String>[];
    vehicleControllersPerProduct.forEach((productId, controllers) {
      for (var controller in controllers) {
        if (controller.text.trim().isNotEmpty) {
          selectedVehicles.add(controller.text.trim());
        }
      }
    });
    return selectedVehicles;
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

    // Restore previous form data
    if (widget.previousReferralCode != null) {
      referralCodeController.text = widget.previousReferralCode!;
    }
    if (widget.previousShippingPersonInCharge != null) {
      shippingPersonInChargeController.text =
          widget.previousShippingPersonInCharge!;
    }
    if (widget.previousShippingPersonContactNo != null) {
      shippingPersonContactNoController.text =
          widget.previousShippingPersonContactNo!;
    }
    if (widget.previousShippingSameAsBilling != null) {
      shippingSameAsBilling = widget.previousShippingSameAsBilling!;
    }

    // Restore selected addresses if passed
    if (widget.selectedBillingAddress != null) {
      selectedBillingAddress = widget.selectedBillingAddress;
    }
    if (widget.selectedShippingAddress != null) {
      selectedShippingAddress = widget.selectedShippingAddress;
    }
    if (widget.billingAddresses != null) {
      billingAddresses = widget.billingAddresses;
    }
    if (widget.shippingAddresses != null) {
      shippingAddresses = widget.shippingAddresses;
    }

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
      final previousControllers =
          widget.previousVehicleSelection?[product.id] ?? [];
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
        if (index < previousControllers.length &&
            previousControllers[index].isNotEmpty) {
          return true; // Previously selected vehicles are verified
        } else {
          return false;
        }
      });
      vehicleVerificationStatusPerProduct[product.id] = verificationStatus;
    }

    // loadVehicleSelection();

    // Check if we have previously selected addresses to restore
    if (selectedBillingAddress != null && billingAddresses != null) {
      // Restore billing address immediately
      kavachCheckoutBillingAddressBloc.add(
        RestoreKavachBillingAddress(selectedBillingAddress!, billingAddresses!),
      );
    } else {
      // Only fetch if we don't have addresses to restore
      kavachCheckoutBillingAddressBloc.add(FetchKavachBillingAddresses());
    }

    if (selectedShippingAddress != null && shippingAddresses != null) {
      // Restore shipping address immediately
      kavachCheckoutShippingAddressBloc.add(
        RestoreKavachShippingAddress(
          selectedShippingAddress!,
          shippingAddresses!,
        ),
      );
    } else {
      // Only fetch if we don't have addresses to restore
      kavachCheckoutShippingAddressBloc.add(FetchKavachShippingAddresses());
    }

    // Listen to address states to store selected addresses
    kavachCheckoutBillingAddressBloc.stream.listen((state) {
      if (state is KavachCheckoutBillingAddressSelected) {
        selectedBillingAddress = state.selectedAddress;
        billingAddresses = state.addresses;
      }
    });

    kavachCheckoutShippingAddressBloc.stream.listen((state) {
      if (state is KavachCheckoutShippingAddressSelected) {
        selectedShippingAddress = state.selectedAddress;
        shippingAddresses = state.addresses;

        // Update stored previous address when user manually selects a shipping address
        if (!shippingSameAsBilling) {
          _previousShippingAddress = state.selectedAddress;
        }
      }
    });
    updatedAppEvent(stage:'viewedCheckoutScreen');

  }

  Future<void> updatedAppEvent({required String stage,String? entityId, Map<String, dynamic>? context}) async {
    try {
      lpHomeCubit.updatedAppEvent(
          stage: stage,
          entityId: entityId,
          context: context);
    } catch (e) {
      // Log error but don't show to user as it's not critical
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        centreTile: false,
        title: context.appText.checkout,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop({
              'quantities': _quantities,
              'vehicles': vehicleControllersPerProduct.map(
                (key, value) => MapEntry(
                  key,
                  value.map((controller) => controller.text.trim()).toList(),
                ),
              ),
              'referralCode': referralCodeController.text.trim(),
              'shippingPersonInCharge':
                  shippingPersonInChargeController.text.trim(),
              'shippingPersonContactNo':
                  shippingPersonContactNoController.text.trim(),
              'shippingSameAsBilling': shippingSameAsBilling,
              'selectedBillingAddress': selectedBillingAddress,
              'selectedShippingAddress': selectedShippingAddress,
              'billingAddresses': billingAddresses,
              'shippingAddresses': shippingAddresses,
            });
          },
          icon: SvgPicture.asset(
            AppIcons.svg.goBack,
            colorFilter: AppColors.svg(Colors.black),
          ),
        ),

        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.of(context).push(
                commonRoute(
                  LpSupport(
                    showBackButton: true,
                    ticketTag: TicketTags.TANK_LOCK,
                  ),
                  isForward: true,
                ),
              );
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

  // Helper function to get current selected addresses from blocs
  KavachAddressModel? _getCurrentShippingAddress(BuildContext context) {
    final shippingState =
        context.read<KavachCheckoutShippingAddressBloc>().state;
    if (shippingState is KavachCheckoutShippingAddressSelected) {
      return shippingState.selectedAddress;
    }
    return null;
  }

  KavachAddressModel? _getCurrentBillingAddress(BuildContext context) {
    final billingState = context.read<KavachCheckoutBillingAddressBloc>().state;
    if (billingState is KavachCheckoutBillingAddressSelected) {
      return billingState.selectedAddress;
    }
    return null;
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
                  labelText: context.appText.referralCodeOptional,
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
                        Navigator.of(context).pop({
                          'quantities': _quantities,
                          'vehicles': vehicleControllersPerProduct.map(
                            (key, value) => MapEntry(
                              key,
                              value
                                  .map((controller) => controller.text.trim())
                                  .toList(),
                            ),
                          ),
                          'referralCode': referralCodeController.text.trim(),
                          'shippingPersonInCharge':
                              shippingPersonInChargeController.text.trim(),
                          'shippingPersonContactNo':
                              shippingPersonContactNoController.text.trim(),
                          'shippingSameAsBilling': shippingSameAsBilling,
                          'selectedBillingAddress': selectedBillingAddress,
                          'selectedShippingAddress': selectedShippingAddress,
                          'billingAddresses': billingAddresses,
                          'shippingAddresses': shippingAddresses,
                          'clearSearch': true, // Add flag to clear search
                        });
                        syncVehicleControllersWithProducts();
                        loadVehicleSelection();
                      },
                      label: Text(
                        context.appText.addMoreKavach,
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
                      BlocBuilder<
                        KavachCheckoutBillingAddressBloc,
                        KavachCheckoutBillingAddressState
                      >(
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
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
                                  screen: KavachBillingAddressListScreen(
                                    selectedShippingAddress:
                                        _getCurrentShippingAddress(context),
                                  ),
                                );
                              },
                              title: context.appText.billingAddress,
                            );
                          }
                          // if (state is KavachCheckoutBillingAddressEmpty ||
                          //     state is KavachCheckoutBillingAddressLoading ||
                          //     state is KavachCheckoutBillingAddressError) {
                          if (state is! KavachCheckoutBillingAddressSelected) {
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
                                  screen: KavachBillingAddressListScreen(
                                    selectedShippingAddress:
                                        _getCurrentShippingAddress(context),
                                  ),
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
                                  screen: KavachBillingAddressListScreen(
                                    selectedShippingAddress:
                                        _getCurrentShippingAddress(context),
                                  ),
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
                                  screen: KavachBillingAddressListScreen(
                                    selectedShippingAddress:
                                        _getCurrentShippingAddress(context),
                                  ),
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      15.height,
                      //Shipping Address
                      BlocBuilder<
                        KavachCheckoutShippingAddressBloc,
                        KavachCheckoutShippingAddressState
                      >(
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
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
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
                                        screen: KavachShippingAddressListScreen(
                                          selectedBillingAddress:
                                              _getCurrentBillingAddress(
                                                context,
                                              ),
                                        ),
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

                          // if (state is KavachCheckoutShippingAddressEmpty ||
                          //     state is KavachCheckoutShippingAddressLoading ||
                          //     state is KavachCheckoutShippingAddressError) {
                          if (state is! KavachCheckoutShippingAddressSelected) {
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
                                        screen: KavachShippingAddressListScreen(
                                          selectedBillingAddress:
                                              selectedBillingAddress,
                                        ),
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
                                        screen: KavachShippingAddressListScreen(
                                          selectedBillingAddress:
                                              _getCurrentBillingAddress(
                                                context,
                                              ),
                                        ),
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
                                        screen: KavachShippingAddressListScreen(
                                          selectedBillingAddress:
                                              _getCurrentBillingAddress(
                                                context,
                                              ),
                                        ),
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
                        enableInteractiveSelection: true,
                        controller: shippingPersonInChargeController,
                        decoration: kavachInputDecoration(
                          hintText: context.appText.personInCharge,
                          isMandatoryMark: true,
                        ),
                        maxLength: 50,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
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
                        enableInteractiveSelection: true,
                        controller: shippingPersonContactNoController,
                        decoration: kavachInputDecoration(
                          hintText: context.appText.contactNo,
                          isMandatoryMark: true,
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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

  // Helper method to format vehicle number for display
  String formatVehicleNumberForDisplay(String vehicleNumber) {
    if (vehicleNumber.isEmpty) return '';

    // Remove any existing spaces and convert to uppercase
    String cleanNumber =
        vehicleNumber.replaceAll(RegExp(r'\s'), '').toUpperCase();

    // Format: MH12AB1234 -> MH 12 AB 1234
    if (cleanNumber.length >= 10) {
      return '${cleanNumber.substring(0, 2)} ${cleanNumber.substring(2, 4)} ${cleanNumber.substring(4, 6)} ${cleanNumber.substring(6)}';
    }

    // If not standard format, return as is
    return vehicleNumber.toUpperCase();
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
                      ToastMessages.alert(
                        message: context.appText.unableToAddMoreItems,
                      );
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
                  "$indianCurrencySymbol ${KavachHelper.formatCurrency(totalPrice.round())}",
                  style: AppTextStyle.h4PrimaryColor,
                ),
              ],
            ),
            12.height,
            Column(
              children: List.generate(vehicleControllers.length, (index) {
                final verificationStatus =
                    vehicleVerificationStatusPerProduct[product.id]?[index] ??
                    false;
                return VehicleSelectionField(
                  controller: vehicleControllers[index],
                  hintText: context.appText.selectVehicleRegNum,
                  index: index,
                  isVerified: verificationStatus,
                  isVehicleAlreadySelected: isVehicleAlreadySelected(
                    vehicleControllers[index].text.trim(),
                  ),
                  onVehicleSelected: (selectedIndex, selectedVehicle) {
                    // Check for duplicates across all products, excluding the current field
                    bool isAlreadySelected = false;
                    vehicleControllersPerProduct.forEach((
                      productId,
                      controllers,
                    ) {
                      for (int i = 0; i < controllers.length; i++) {
                        // Skip the current field being updated
                        if (productId == product.id && i == selectedIndex)
                          continue;

                        if (controllers[i].text.trim() ==
                            selectedVehicle.trim()) {
                          isAlreadySelected = true;
                          return;
                        }
                      }
                    });

                    if (isAlreadySelected) {
                      ToastMessages.alert(
                        message: context.appText.vehicleAlreadySelected,
                      );
                      return;
                    }

                    // Set the vehicle in the controller only if no duplicates
                    vehicleControllers[selectedIndex].text = selectedVehicle;
                    // Mark as verified when selected from list
                    vehicleVerificationStatusPerProduct[product
                            .id]![selectedIndex] =
                        true;
                    setState(() {}); // Trigger rebuild to show green tick
                  },
                  onVehicleVerified: (verifiedVehicle) {
                    // Update verification status when manually verified
                    if (verifiedVehicle.isNotEmpty) {
                      vehicleVerificationStatusPerProduct[product.id]![index] =
                          true;
                    } else {
                      // Reset verification status when text is cleared or changed
                      vehicleVerificationStatusPerProduct[product.id]![index] =
                          false;
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
      onPressed: () async {
        final shippingState =
            context.read<KavachCheckoutShippingAddressBloc>().state;
        final billingState =
            context.read<KavachCheckoutBillingAddressBloc>().state;

        if (!formKeyCheckout.currentState!.validate()) return;

        // Validate products in cart
        if (_products.isEmpty || _quantities.isEmpty) {
          ToastMessages.alert(message: context.appText.pleaseAddProducts);
          return; // Stop further execution
        }

        // Validate shipping address
        if (shippingState is KavachCheckoutShippingAddressEmpty) {
          ToastMessages.alert(
            message: context.appText.pleaseAddShippingAddress,
          );
          return;
        }
        if (shippingState is KavachCheckoutShippingAddressLoading) {
          ToastMessages.alert(message: context.appText.shippingLoading);
          return;
        }
        if (shippingState is KavachCheckoutShippingAddressError) {
          ToastMessages.alert(message: context.appText.shippingLoadFailed);
          return;
        }

        // Validate billing address
        if (billingState is KavachCheckoutBillingAddressEmpty) {
          ToastMessages.alert(message: context.appText.pleaseAddBillingAddress);
          return;
        }
        if (billingState is KavachCheckoutBillingAddressLoading) {
          ToastMessages.alert(message: context.appText.billingLoading);
          return;
        }
        if (billingState is KavachCheckoutBillingAddressError) {
          ToastMessages.alert(message: context.appText.billingLoadFailed);
          return;
        }

        final allVehiclesFilled = vehicleControllersPerProduct.values.every(
          (controllers) => controllers.every((c) => c.text.trim().isNotEmpty),
        );
        if (!allVehiclesFilled) {
          ToastMessages.alert(message: context.appText.pleaseSelectAllVehicles);
          return;
        }

        // ✅ Ensure all vehicles are verified
        final allVehiclesVerified = vehicleVerificationStatusPerProduct.values
            .every((statuses) => statuses.every((isVerified) => isVerified));
        if (!allVehiclesVerified) {
          ToastMessages.alert(
            message:
                "Please verify all vehicle numbers before placing the order.",
          );
          return;
        }

        // Validate that all vehicle numbers are unique across all products
        final allVehicleNumbers = <String>[];
        final duplicateVehicles = <String>[];

        vehicleControllersPerProduct.forEach((productId, controllers) {
          for (var controller in controllers) {
            final vehicleNumber = controller.text.trim();
            if (vehicleNumber.isNotEmpty) {
              if (allVehicleNumbers.contains(vehicleNumber)) {
                duplicateVehicles.add(vehicleNumber);
              } else {
                allVehicleNumbers.add(vehicleNumber);
              }
            }
          }
        });

        if (duplicateVehicles.isNotEmpty) {
          final uniqueDuplicates = duplicateVehicles.toSet().toList();
          ToastMessages.alert(
            message:
                'Duplicate vehicle numbers found: ${uniqueDuplicates.join(', ')}. Please use unique vehicle numbers for each product.',
          );
          return;
        }

        // If all validations pass, create order
        if (shippingState is KavachCheckoutShippingAddressSelected &&
            billingState is KavachCheckoutBillingAddressSelected) {
          // Calculate total amount
          double totalAmount = 0.0;
          for (var product in _products) {
            int qty = _quantities[product.id] ?? 0;
            double itemTotal = product.price * qty;
            totalAmount += itemTotal + (itemTotal * (product.gstPerc / 100));
          }

          // Get customer information
          final customerInfo = await getCustomerInfo();

          // Determine if referral code is provided and extract employee details
          String? createdEmpId;
          int createdEmpUserId = 1234; // Default value for direct orders

          if (referralCodeController.text.trim().isNotEmpty) {
            createdEmpId = referralCodeController.text.trim();
            // For referral orders, use the employee ID as per documentation
            // In a real implementation, this should be fetched from an API based on the referral code
            createdEmpUserId = 52864; // Employee ID for referral code GDP00584
          }

          int? customerSeries = await userInfoRepo.getCustomerSeriesId();

          final request = KavachOrderRequest(
            orderSource: "MOBILE",
            customerSeriesId: customerSeries ?? 200,
            isOrderPaid: true,
            // Set to false since payment will be handled separately
            customerId: await kavachOrderBloc.getUserId() ?? '',
            createdEmpUserId: createdEmpUserId,
            createdEmpId: createdEmpId,
            orderReferencedBy:
                referralCodeController.text.trim().isNotEmpty
                    ? referralCodeController.text.trim()
                    : "DIRECT",
            totalPrice: totalAmount,
            categoryId: 1,
            orderTypeId: 1,
            teamId: 1,
            shippingPersonIncharge:
                shippingPersonInChargeController.text.trim(),
            shippingPersonContactNo:
                shippingPersonContactNoController.text.trim(),
            customerInfo: customerInfo,
            billingAddress: {
              "addressLine1": billingState.selectedAddress.addressName,
              "addressLine2": billingState.selectedAddress.addr1,
              "city": billingState.selectedAddress.city,
              "state": billingState.selectedAddress.state,
              "postalCode": billingState.selectedAddress.pincode,
              "country": 'India',
              "gstId": billingState.selectedAddress.gstin ?? "",
            },
            shippingAddress: {
              "addressLine1": shippingState.selectedAddress.addressName,
              "addressLine2": shippingState.selectedAddress.addr1,
              "city": shippingState.selectedAddress.city,
              "state": shippingState.selectedAddress.state,
              "postalCode": shippingState.selectedAddress.pincode,
              "country": 'India',
              "gstId": shippingState.selectedAddress.gstin ?? "",
            },
            orders:
                _products.map((product) {
                  final quantity = _quantities[product.id]!;
                  final stock = _availableStocks[product.id] ?? 0;
                  final vehicleControllers =
                      vehicleControllersPerProduct[product.id] ?? [];

                  return KavachOrderItem(
                    productServiceId: int.parse(product.id),
                    noOfProducts: quantity,
                    unitPrice: product.price,
                    totalPrice:
                        product.price *
                        quantity *
                        (1 + (product.gstPerc / 100)),
                    stockAvailable: stock,
                    vehicleNumbers:
                        vehicleControllers
                            .map(
                              (controller) => KavachOrderVehicle(
                                vehicleNumber: controller.text.trim(),
                              ),
                            )
                            .toList(),
                  );
                }).toList(),
          );

          // kavachOrderBloc.add(KavachSubmitOrder(request));
          if (!mounted) return;
          Navigator.of(context).push(
            commonRoute(
              KavachSummaryScreen(
                products: _products,
                quantities: _quantities,
                availableStocks: _availableStocks,
                shippingAddress: _getCurrentShippingAddress(context)!,
                billingAddress: _getCurrentBillingAddress(context)!,
                selectedVehicleNumbers: _getSelectedVehicles(),
                shippingPersonContactNo:
                    shippingPersonContactNoController.text.trim(),
                shippingPersonInCharge:
                    shippingPersonInChargeController.text.trim(),
                orderReferencedBy: referralCodeController.text.trim(),
                selectedVehiclePerProduct: vehicleControllersPerProduct.map(
                  (key, value) => MapEntry(
                    key,
                    value.map((controller) => controller.text.trim()).toList(),
                  ),
                ),
                kavachOrderRequest:
                    request, // Pass full request object instead of orderId
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
        final shippingBloc = context.read<KavachCheckoutShippingAddressBloc>();
        final billingState =
            context.read<KavachCheckoutBillingAddressBloc>().state;
        final shippingState = shippingBloc.state;

        if (checked == true) {
          // User is checking the box - store current shipping address and copy billing
          if (shippingState is KavachCheckoutShippingAddressSelected) {
            _previousShippingAddress = shippingState.selectedAddress;
          }

          if (billingState is KavachCheckoutBillingAddressSelected) {
            shippingBloc.add(
              SelectKavachShippingAddress(billingState.selectedAddress),
            );
          } else {
            ToastMessages.alert(
              message: context.appText.pleaseSelectBillingFirst,
            );
            return; // Don't update state if billing not selected
          }
        } else {
          // User is unchecking the box - restore previous shipping address if available
          if (_previousShippingAddress != null) {
            shippingBloc.add(
              SelectKavachShippingAddress(_previousShippingAddress!),
            );
          } else {
            // If no previous address, just clear the selection
            shippingBloc.add(ClearKavachShippingAddress());
            shippingBloc.add(FetchKavachShippingAddresses());
          }
        }

        setState(() {
          shippingSameAsBilling = checked ?? false;
        });
      },
      value: shippingSameAsBilling,
      title: context.appText.sameAsBillingAddress,
    );
  }

  InputDecoration kavachInputDecoration({
    Widget? suffixIcon,
    String? hintText,
    bool? isMandatoryMark,
  }) {
    return InputDecoration(
      hint: Row(
        children: [
          Text(hintText ?? '', style: AppTextStyle.textFieldHint),
          if (isMandatoryMark ?? false)
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
        ],
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1),
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
              Text(address.addr1, style: AppTextStyle.blackColor14w400),
              Text(
                "${address.city}, ${address.state}",
                style: AppTextStyle.blackColor14w400,
              ),
              Text(
                "${address.country}- ${address.pincode}",
                style: AppTextStyle.blackColor14w400,
              ),
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
