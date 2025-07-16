import 'dart:convert';
import 'dart:developer';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_order_cubit.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_request/gps_order_api_request.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import '../../../../utils/app_dialog.dart' show AppDialog;
import '../../../../utils/common_dialog_view/success_dialog_view.dart';
import '../../../kavach/model/kavach_address_model.dart';
import '../../../kavach/view/kavach_support_screen.dart';
import '../../models/gps_document_models.dart';

class GpsOrderSummaryScreen extends StatefulWidget {
  final List<GpsProduct> products;
  final Map<String, int> quantities;
  final Map<String, int> availableStocks;
  final KavachAddressModel shippingAddress;
  final KavachAddressModel billingAddress;
  final List<String> selectedVehicleNumbers;
  final String shippingPersonInCharge;
  final String shippingPersonContactNo;
  final String orderReferencedBy;
  final Map<String, List<String>> selectedVehiclePerProduct;

  const GpsOrderSummaryScreen({
    super.key,
    required this.products,
    required this.quantities,
    required this.shippingAddress,
    required this.billingAddress,
    required this.selectedVehicleNumbers,
    required this.availableStocks,
    required this.shippingPersonInCharge,
    required this.shippingPersonContactNo,
    required this.orderReferencedBy,
    required this.selectedVehiclePerProduct,
  });

  @override
  State<GpsOrderSummaryScreen> createState() => _GpsOrderSummaryScreenState();
}

class _GpsOrderSummaryScreenState extends State<GpsOrderSummaryScreen> {
  late final GpsOrderCubit gpsOrderCubit;
  GpsOrderSummaryResponse? orderSummary;
  bool isLoadingSummary = true;

  @override
  void initState() {
    super.initState();
    try {
      gpsOrderCubit = locator<GpsOrderCubit>();
    } catch (e) {
      print('Error getting GPS order cubit: $e');
      final repository = locator<GpsOrderApiRepository>();
      final userRepository = locator<UserInformationRepository>();
      gpsOrderCubit = GpsOrderCubit(repository, userRepository);
    }

    // Fetch order summary
    _fetchOrderSummary();
  }

  Future<void> _fetchOrderSummary() async {
    try {
      // Create products list for API request with individual state and gstId
      final products =
          widget.products.map((product) {
            // Get state from billing address
            final state =
                widget.billingAddress.state.isNotEmpty
                    ? widget.billingAddress.state
                    : _parseAddress(widget.billingAddress.addr1)['state'] ?? '';

            // Get GST ID from billing address
            final gstId = widget.billingAddress.gstin ?? '';

            return GpsOrderSummaryRequestItem(
              productId: int.parse(product.id),
              quantity: widget.quantities[product.id] ?? 0,
              discount:
                  0.0, // Default discount, can be updated based on business logic
              state: state,
              gstId: gstId,
            );
          }).toList();

      final request = GpsOrderSummaryRequest(products: products);

      print('Fetching GPS order summary with request: ${request.toJson()}');
      print('Request products count: ${products.length}');
      for (int i = 0; i < products.length; i++) {
        print('Product $i: ${products[i].toJson()}');
      }
      await gpsOrderCubit.getOrderSummary(request);
    } catch (e) {
      print('Error fetching order summary: $e');
      setState(() {
        isLoadingSummary = false;
      });
      ToastMessages.error(
        message: 'Failed to load order summary. Please try again.',
      );
    }
  }

  // Fallback calculation methods in case API fails
  double get _fallbackTotalAmount {
    double total = 0.0;
    for (var product in widget.products) {
      int qty = widget.quantities[product.id] ?? 0;
      double price = double.tryParse(product.price) ?? 0.0;
      double itemTotal = price * qty;
      double itemGst = itemTotal * (18.0 / 100);
      total += itemTotal + itemGst;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GpsOrderCubit, GpsOrderState>(
      bloc: gpsOrderCubit,
      listener: (context, state) {
        // Handle order creation states
        if (state is GpsOrderLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is GpsOrderSuccess) {
          // Close loading dialog if it's open
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }

          // Show success dialog
          AppDialog.show(
            context,
            child: SuccessDialogView(
              message: 'Order placed successfully',
              onContinue: () async {
                try {
                  Navigator.of(context).pop();
                  await Future.delayed(Duration(milliseconds: 300));
                  if (context.mounted) {
                    // Debug current route
                    print(
                      '🔄 GPS Order Success: Current route: ${GoRouterState.of(context).uri}',
                    );
                    print(
                      '🔄 GPS Order Success: Target route: ${AppRouteName.gpsOrderBenefits}',
                    );
                    // Try using direct navigation instead of GoRouter
                    context.go(AppRouteName.gpsOrderBenefits);
                    print('🔄 GPS Order Success: Direct navigation used');
                  } else {
                    print(
                      '❌ GPS Order Success: Context is not mounted after delay',
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Use GoRouter to navigate and clear stack
                    context.go(AppRouteName.gpsOrderBenefits);
                    print('🔄 GPS Order Success: Fallback navigation used');
                  }
                }
              },
            ),
          );
          // showSuccessDialog(
          //   context,
          //   text: 'Order placed successfully',
          //   subheading: '',
          //   onTap: () {
          //     // Navigate directly without closing dialog first
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (context) => GpsOrderBenefitsAndOrderListScreen()),
          //   (route) => false,
          // );
          //   },
          // );
        } else if (state is GpsOrderError) {
          // Close loading dialog if it's open
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
          ToastMessages.error(
            message: "Failed to place order: ${state.message}",
          );
        }

        // Handle order summary states
        if (state is GpsOrderSummaryLoaded) {
          setState(() {
            orderSummary = state.summary;
            isLoadingSummary = false;
          });
        } else if (state is GpsOrderSummaryError) {
          setState(() {
            isLoadingSummary = false;
          });
          ToastMessages.error(
            message: "Failed to load order summary: ${state.message}",
          );
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: context.appText.summary,
          isLeading: true,
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
        bottomNavigationBar: _buildProceedToPayButton(context),
        body: _buildBodyWidget(context),
      ),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Product Widget
            _productWidget(),
            5.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.vehicleDetails, style: AppTextStyle.h5),
                  SizedBox(height: 5),
                  Text(
                    widget.selectedVehicleNumbers.join(", "),
                    style: AppTextStyle.textDarkGreyColor14w500,
                  ),
                ],
              ),
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.shippingAddress, style: AppTextStyle.h5),
                  10.height,
                  _buildAddressCard(widget.shippingAddress),
                  15.height,
                  Text(context.appText.billingAddress, style: AppTextStyle.h5),
                  10.height,
                  _buildAddressCard(widget.billingAddress),
                ],
              ),
            ),
            30.height,
          ],
        ).paddingAll(commonSafeAreaPadding),
      ),
    );
  }

  Widget _productWidget() {
    if (isLoadingSummary) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: commonContainerDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.appText.paymentDetails, style: AppTextStyle.h4),
            10.height,
            Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    if (orderSummary == null) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: commonContainerDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.appText.paymentDetails, style: AppTextStyle.h4),
            10.height,
            Text(
              'Failed to load order summary',
              style: AppTextStyle.textDarkGreyColor14w500,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.paymentDetails, style: AppTextStyle.h4),
          10.height,
          ...orderSummary!.data.summary.map((summaryItem) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(summaryItem.productName, style: AppTextStyle.h5),
                          Text(
                            summaryItem.partName,
                            style: AppTextStyle.textDarkGreyColor14w500,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "₹${(summaryItem.unitPrice * summaryItem.quantity)}",
                      style: AppTextStyle.blackColor15w500,
                    ),
                  ],
                ),
                5.height,
                _buildDetailRow("HSN Code", summaryItem.hsnCode),
                _buildDetailRow(
                  "Qty",
                  summaryItem.quantity.toString().padLeft(2, '0'),
                ),
                _buildDetailRow("Rate /Unit ₹", "₹${summaryItem.unitPrice}"),
                if (summaryItem.discount > 0)
                  _buildDetailRow("Discount", "₹${summaryItem.discount}"),
                _buildDetailRow("IGST", "₹${summaryItem.igst}"),
                _buildDetailRow("CGST", "₹${summaryItem.cgst}"),
                _buildDetailRow("SGST", "₹${summaryItem.sgst}"),
                _buildDetailRow("Total GST", "₹${summaryItem.totalGst}"),
                5.height,
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 6.0,
                  dashColor: AppColors.greyIconColor,
                ),
                5.height,
                _buildDetailRow("Total Amount", "₹${summaryItem.totalAmount}"),
                15.height,
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildProceedToPayButton(BuildContext context) {
    final totalAmount = orderSummary?.data.grandTotal ?? _fallbackTotalAmount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2), // shadow towards top
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.appText.total, style: AppTextStyle.blackColor14w400),
              Text('₹$totalAmount', style: AppTextStyle.primaryColor16w900),
            ],
          ),
          15.width,
          AppButton(
            onPressed: () async {
              await _createGpsOrder();
            },
            title: context.appText.placeOrder,
            style: AppButtonStyle.primary,
          ).expand(),
        ],
      ).paddingOnly(bottom: 30, right: 20, left: 20, top: 15),
    );
  }

  // Helper function to parse address and extract city, state, postal code
  Map<String, String> _parseAddress(String addressString) {
    // Default values
    String city = '';
    String state = '';
    String postalCode = '';

    print('Parsing address: $addressString');

    try {
      // Split by commas and clean up
      List<String> parts =
          addressString.split(',').map((part) => part.trim()).toList();
      print('Address parts: $parts');

      if (parts.length >= 3) {
        // Try to extract postal code from the last part (format: "Country - PostalCode")
        String lastPart = parts.last;
        if (lastPart.contains('-')) {
          List<String> countryPostal =
              lastPart.split('-').map((part) => part.trim()).toList();
          if (countryPostal.length >= 2) {
            postalCode = countryPostal.last;
          }
        }

        // Extract city and state from middle parts
        if (parts.length >= 4) {
          // For format: "home, karnal, haryana, India - 123008"
          // or "123 Main St, Apt 4B, Chennai, Tamil Nadu, India - 600001"
          if (parts.length >= 5) {
            // More complex address with street details
            city = parts[parts.length - 3]; // Third from last
            state = parts[parts.length - 2]; // Second from last
          } else {
            // Simpler format
            city = parts[1]; // Second part
            state = parts[2]; // Third part
          }
        } else if (parts.length >= 3) {
          // If only 3 parts, assume the middle one is state
          state = parts[1];
        }
      }
    } catch (e) {
      print('Error parsing address: $e');
    }

    print(
      'Parsed address - City: $city, State: $state, PostalCode: $postalCode',
    );

    return {'city': city, 'state': state, 'postalCode': postalCode};
  }

  Future<void> _createGpsOrder() async {
    try {
      final customerId = await gpsOrderCubit.getUserId() ?? '';

      // Create customer info
      final customerInfo = GpsCustomerInfo(
        companyName: "ABC Logistics Pvt Ltd",
        contactNumber: "9876543210",
        blueMembershipId: "BLUE123456",
      );

      // Create billing address
      final billingAddressParts = _parseAddress(widget.billingAddress.addr1);
      print(
        'Billing address - Original: city=${widget.billingAddress.city}, state=${widget.billingAddress.state}, pincode=${widget.billingAddress.pincode}',
      );
      print(
        'Billing address - Parsed: city=${billingAddressParts['city']}, state=${billingAddressParts['state']}, postalCode=${billingAddressParts['postalCode']}',
      );
      final billingAddress = GpsOrderAddress(
        addressLine1: widget.billingAddress.addressName,
        addressLine2: widget.billingAddress.addr1,
        city:
            widget.billingAddress.city.isNotEmpty
                ? widget.billingAddress.city
                : billingAddressParts['city']!,
        state:
            widget.billingAddress.state.isNotEmpty
                ? widget.billingAddress.state
                : billingAddressParts['state']!,
        postalCode:
            widget.billingAddress.pincode.isNotEmpty
                ? widget.billingAddress.pincode
                : billingAddressParts['postalCode']!,
        country: widget.billingAddress.country,
        gstId: widget.billingAddress.gstin ?? "",
      );

      // Create shipping address
      final shippingAddressParts = _parseAddress(widget.shippingAddress.addr1);
      print(
        'Shipping address - Original: city=${widget.shippingAddress.city}, state=${widget.shippingAddress.state}, pincode=${widget.shippingAddress.pincode}',
      );
      print(
        'Shipping address - Parsed: city=${shippingAddressParts['city']}, state=${shippingAddressParts['state']}, postalCode=${shippingAddressParts['postalCode']}',
      );
      final shippingAddress = GpsOrderAddress(
        addressLine1: widget.shippingAddress.addressName,
        addressLine2: widget.shippingAddress.addr1,
        city:
            widget.shippingAddress.city.isNotEmpty
                ? widget.shippingAddress.city
                : shippingAddressParts['city']!,
        state:
            widget.shippingAddress.state.isNotEmpty
                ? widget.shippingAddress.state
                : shippingAddressParts['state']!,
        postalCode:
            widget.shippingAddress.pincode.isNotEmpty
                ? widget.shippingAddress.pincode
                : shippingAddressParts['postalCode']!,
        country: widget.shippingAddress.country,
        gstId: widget.shippingAddress.gstin ?? "",
      );

      // Create order items
      final orders =
          widget.products.map((product) {
            final quantity = widget.quantities[product.id]!;
            final stock = widget.availableStocks[product.id] ?? 0;
            final vehicleNumbers =
                widget.selectedVehiclePerProduct[product.id] ?? [];
            final price = double.tryParse(product.price) ?? 0.0;
            final itemTotal = price * quantity;
            final itemGst = itemTotal * (18.0 / 100);
            final totalWithGst = itemTotal + itemGst;

            return GpsOrderItem(
              productServiceId: int.parse(product.id),
              noOfProducts: quantity,
              unitPrice: price,
              totalPrice: totalWithGst,
              stockAvailable: stock,
              vehicleNumbers:
                  vehicleNumbers
                      .map((v) => GpsOrderVehicle(vehicleNumber: v))
                      .toList(),
            );
          }).toList();

      // Create the order request
      final request = GpsOrderRequest(
        orderSource: "MOBILE",
        isOrderPaid: false,
        customerId: customerId,
        createdEmpUserId: 1234,
        orderReferencedBy: widget.orderReferencedBy,
        totalPrice:
            orderSummary?.data.grandTotal ??
            _fallbackTotalAmount, // Use the API's grandTotal or fallback
        categoryId: 1,
        shippingPersonIncharge: widget.shippingPersonInCharge,
        shippingPersonContactNo: widget.shippingPersonContactNo,
        customerInfo: customerInfo,
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        orders: orders,
      );

      print('GPS Order Request: ${request.toJson()}');

      if (kDebugMode) {
        log(jsonEncode(request));
      }

      // Create the order
      await gpsOrderCubit.createOrder(request);
    } catch (e) {
      print('Error creating GPS order: $e');
      ToastMessages.alert(message: 'Failed to create order: $e');
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: AppTextStyle.textDarkGreyColor14w500),
        ),
        Text(value, style: AppTextStyle.blackColor15w500),
      ],
    ).paddingSymmetric(vertical: 5);
  }

  Widget _buildAddressCard(KavachAddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.addressName, style: AppTextStyle.textDarkGreyColor14w500),
        Text(address.addr1, style: AppTextStyle.textDarkGreyColor14w500),
        Text(
          "${address.city}, ${address.state}",
          style: AppTextStyle.textDarkGreyColor14w500,
        ),
        Text(
          "${address.country}- ${address.pincode}",
          style: AppTextStyle.textDarkGreyColor14w500,
        ),
        Visibility(
          visible: address.gstin != null && address.gstin!.isNotEmpty,
          child: Text(
            "${context.appText.gstKavach} - ${address.gstin}",
            style: AppTextStyle.textDarkGreyColor14w500,
          ),
        ),
      ],
    );
  }
}
