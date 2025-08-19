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
import 'package:gro_one_app/features/kavach/api_request/kavach_payment_api_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
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
import '../../../kavach/helper/kavach_helper.dart';
import '../../../kavach/model/kavach_address_model.dart';
import '../../../kavach/view/kavach_support_screen.dart';
import '../../../payments/view/payments_screen.dart';
import '../../models/gps_document_models.dart';
import '../gps_home_screen.dart';

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
  final profileCubit = locator<ProfileCubit>();
  final userInfoRepo = locator<UserInformationRepository>();
  GpsOrderSummaryResponse? orderSummary;
  bool isLoadingSummary = true;

  @override
  void initState() {
    super.initState();
    try {
      gpsOrderCubit = locator<GpsOrderCubit>();
    } catch (e) {
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
              discount: 0.0,
              // Default discount, can be updated based on business logic
              state: state,
              gstId: gstId,
            );
          }).toList();

      final request = GpsOrderSummaryRequest(products: products);
      for (int i = 0; i < products.length; i++) {
        if (kDebugMode) {
          print('Product $i: ${products[i].toJson()}');
        }
      }
      await gpsOrderCubit.getOrderSummary(request);
    } catch (e) {
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
          blueId = customer.blueId?.toString() ?? "";
          email = customer.emailId;
          blueId = customer.blueId?.toString() ?? "";
        }
      }

      // Fallback to hardcoded values if still not available
      return {
        "companyName":
            companyName?.isNotEmpty == true
                ? companyName!
                : "ABC Logistics Pvt Ltd",
        "contactNumber":
            contactNumber?.isNotEmpty == true ? contactNumber! : "9876543210",
        "blueMembershipId": blueId?.isNotEmpty == true ? blueId! : "BLUE123456",
        "email": email ?? "venkat03it@gmail.com",
        "mobileNumber": mobileNumber ?? "9876543210",
      };
    } catch (e) {
      // Return hardcoded values as fallback
      return {
        "companyName": "ABC Logistics Pvt Ltd",
        "contactNumber": "9876543210",
        "blueMembershipId": "BLUE123456",
        "email": "venkat03it@gmail.com",
        "mobileNumber": "9876543210",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GpsOrderCubit, GpsOrderState>(
      bloc: gpsOrderCubit,
      listener: (context, state) async {
        if (state is GpsPaymentSuccess) {
          // Initiate payment → open payment screen
          final result = await Navigator.of(context).push(
            commonRoute(
              PaymentsScreen(
                url: state.paymentResponse.data?.data?.tinyUrl ?? "",
                loadId: "gps_order",
              ),
            ),
          );

          if (result == true) {
            // final cubit = context.read<GpsOrderCubit>();
            final requestId = gpsOrderCubit.paymentRequestId;
            if (requestId != null) {
              gpsOrderCubit.checkPaymentStatus(requestId);
            }
          }
        }

        if (state is GpsPaymentStatusSuccess) {
          // Payment really succeeded → Create order
          _createGpsOrder();
        }

        if (state is GpsPaymentStatusFailure) {
          // Payment failed → show toast
          ToastMessages.error(message: context.appText.paymentFailed);
        }

        if (state is GpsOrderSuccess) {
          await Future.delayed(Duration(seconds: 1));
          _showSuccessDialogAndNavigate(
            context,
            context.appText.orderPlacedSuccessfully,
          );
        }

        if (state is GpsOrderError) {
          ToastMessages.error(
            message: "Order creation failed: ${state.message}",
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
            message: context.appText.failedToLoadOrderSummary,
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
                  Text(
                    widget.selectedVehicleNumbers.length == 1
                        ? "Vehicle Detail"
                        : context.appText.vehicleDetails,
                    style: AppTextStyle.h5,
                  ),
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
                  Text(context.appText.billingAddress, style: AppTextStyle.h5),
                  10.height,
                  _buildAddressCard(widget.billingAddress),
                  15.height,
                  Text(context.appText.shippingAddress, style: AppTextStyle.h5),
                  10.height,
                  _buildAddressCard(widget.shippingAddress),
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
            Text(
              widget.products.length == 1
                  ? "Product Detail"
                  : context.appText.paymentDetails,
              style: AppTextStyle.h4,
            ),
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
            Text(
              widget.products.length == 1
                  ? "Product Detail"
                  : context.appText.paymentDetails,
              style: AppTextStyle.h4,
            ),
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
          Text(
            widget.products.length == 1
                ? "Product Detail"
                : context.appText.paymentDetails,
            style: AppTextStyle.h4,
          ),
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
                      "₹${KavachHelper.formatCurrency((summaryItem.unitPrice * summaryItem.quantity))}",
                      style: AppTextStyle.blackColor15w500,
                    ),
                  ],
                ),
                5.height,
                _buildDetailRow(context.appText.hsnCode, summaryItem.hsnCode),
                _buildDetailRow(
                  context.appText.qty,
                  summaryItem.quantity.toString().padLeft(2, '0'),
                ),
                _buildDetailRow(
                  context.appText.ratePerUnit,
                  "₹${KavachHelper.formatCurrency(summaryItem.unitPrice.toStringAsFixed(2))}",
                ),
                if (summaryItem.discount > 0)
                  _buildDetailRow(
                    "Discount",
                    "₹${KavachHelper.formatCurrency(summaryItem.discount.toStringAsFixed(2))}",
                  ),
                _buildDetailRow(
                  context.appText.igst,
                  "₹${KavachHelper.formatCurrency(summaryItem.igst.toStringAsFixed(2))}",
                ),
                _buildDetailRow(
                  context.appText.cgst,
                  "₹${KavachHelper.formatCurrency(summaryItem.cgst.toStringAsFixed(2))}",
                ),
                _buildDetailRow(
                  context.appText.sgst,
                  "₹${KavachHelper.formatCurrency(summaryItem.sgst.toStringAsFixed(2))}",
                ),
                _buildDetailRow(
                  context.appText.totalGst,
                  "₹${KavachHelper.formatCurrency(summaryItem.totalGst.toStringAsFixed(2))}",
                ),
                5.height,
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 6.0,
                  dashColor: AppColors.greyIconColor,
                ),
                5.height,
                _buildDetailRow(
                  context.appText.totalAmount,
                  "₹${KavachHelper.formatCurrency(summaryItem.totalAmount)}",
                ),
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

    return BlocBuilder<GpsOrderCubit, GpsOrderState>(
      bloc: gpsOrderCubit,
  builder: (context, state) {
    final isLoading = state is GpsOrderLoading || state is GpsPaymentInitiating;
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
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: AppTextStyle.primaryColor16w900,
              ),
            ],
          ),
          15.width,
          AppButton(
            isLoading: isLoading,
            onPressed: () async {
              // Get customer information
              final customerInfo = await getCustomerInfo();
              final userRepository = locator<UserInformationRepository>();
              final customerId = await userRepository.getUserID();

              // Create payment request using the order ID from checkout
              if (customerId != null && customerId.isNotEmpty) {
                final paymentRequest = KavachInitiatePaymentRequest(
                  orderId: "ORDER_${DateTime.now().millisecondsSinceEpoch}",
                  // This should be the actual order ID from the order creation
                  amount: totalAmount,
                  customerName:
                      customerInfo["companyName"] ?? "ABC Logistics Pvt Ltd",
                  customerEmail: "customer@example.com",
                  // This should be fetched from user profile
                  customerMobile: customerInfo["contactNumber"] ?? "9876543210",
                  customerCity: widget.billingAddress.city,
                  customerId: customerId,
                  merchantReferenceNo: 'fleet',
                );

                gpsOrderCubit.initiatePayment(paymentRequest);
              }
            },
            title: context.appText.placeOrder,
            style: AppButtonStyle.primary,
          ).expand(),
        ],
      ).paddingOnly(bottom: 30, right: 20, left: 20, top: 15),
    );
  },
);
  }

  // Helper function to parse address and extract city, state, postal code
  Map<String, String> _parseAddress(String addressString) {
    // Default values
    String city = '';
    String state = '';
    String postalCode = '';

    try {
      // Split by commas and clean up
      List<String> parts =
          addressString.split(',').map((part) => part.trim()).toList();

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
      if (kDebugMode) {
        print('Error parsing address: $e');
      }
    }

    return {'city': city, 'state': state, 'postalCode': postalCode};
  }

  Future<void> _createGpsOrder() async {
    try {
      final customerId = await gpsOrderCubit.getUserId() ?? '';

      // Get real customer information
      final customerInfoMap = await getCustomerInfo();

      // Create customer info
      final customerInfo = GpsCustomerInfo(
        companyName: customerInfoMap["companyName"] ?? "ABC Logistics Pvt Ltd",
        contactNumber: customerInfoMap["contactNumber"] ?? "9876543210",
        blueMembershipId: customerInfoMap["blueMembershipId"] ?? "BLUE123456",
        email: customerInfoMap['email'] ?? "venkat03it@gmail.com",
        mobileNumber: customerInfoMap['mobileNumber'] ?? '9876543210',
      );

      // Determine if referral code is provided and extract employee details
      String? createdEmpId;
      int createdEmpUserId = 1234; // Default value

      if (widget.orderReferencedBy.isNotEmpty) {
        // If referral code is provided, use it as createdEmpId
        createdEmpId = widget.orderReferencedBy;
        // For now, using a default user ID. In a real implementation,
        // you would fetch the employee details from the referral code
        createdEmpUserId =
            52864; // This should be fetched based on referral code
      }

      // Create billing address
      final billingAddressParts = _parseAddress(widget.billingAddress.addr1);
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

      int? customerSeriesId = await userInfoRepo.getCustomerSeriesId();

      // Create the order request
      final request = GpsOrderRequest(
        paymentRequestId: gpsOrderCubit.paymentRequestId,
        orderSource: "MOBILE",
        customerSeriesId: customerSeriesId ?? 200,
        isOrderPaid: true,
        // Always true as per documentation
        customerId: customerId,
        createdEmpUserId: createdEmpUserId,
        createdEmpId: createdEmpId,
        // Will be null if no referral code
        orderReferencedBy:
            widget.orderReferencedBy.isNotEmpty
                ? widget.orderReferencedBy
                : "DIRECT",
        totalPrice: orderSummary?.data.grandTotal ?? _fallbackTotalAmount,
        // Use the API's grandTotal or fallback
        categoryId: 1,
        orderTypeId: 1,
        // Added orderTypeId - typically 1 for product orders
        teamId: 1,
        // Added teamId as requested
        shippingPersonIncharge: widget.shippingPersonInCharge,
        shippingPersonContactNo: widget.shippingPersonContactNo,
        customerInfo: customerInfo,
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        orders: orders,
      );

      // Create the order
      await gpsOrderCubit.createOrder(request);
    } catch (e) {
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

  /// Show success dialog and handle navigation with proper context management
  void _showSuccessDialogAndNavigate(BuildContext context, String message) {
    // Store the current context before showing dialog
    final currentContext = context;

    AppDialog.show(
      currentContext,
      child: SuccessDialogView(
        message: message,
        onContinue: () {
          // Close the dialog first
          Navigator.of(currentContext).pop();

          // Use a post-frame callback to ensure dialog is fully closed
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Add a small delay to ensure dialog is fully closed
            await Future.delayed(Duration(milliseconds: 100));

            if (currentContext.mounted) {
              try {
                // Try multiple navigation approaches
                GoRouter.of(currentContext).go(AppRouteName.gps);
              } catch (e) {
                try {
                  currentContext.go(AppRouteName.gps);
                } catch (fallbackError) {
                  try {
                    Navigator.of(currentContext).pushNamedAndRemoveUntil(
                      AppRouteName.gps,
                      (route) => false,
                    );
                  } catch (navigatorError) {
                    try {
                      Navigator.of(currentContext).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => GpsHomeScreen(),
                        ),
                        (route) => false,
                      );
                    } catch (pushError) {
                      // Last resort: Try to navigate to a different route
                      try {
                        currentContext.go(AppRouteName.lpBottomNavigationBar);
                      } catch (lastResortError) {
                        ToastMessages.error(
                          message: 'Navigation failed. Please try again.',
                        );
                      }
                    }
                  }
                }
              }
            }
          });
        },
      ),
    );
  }

  Widget _buildAddressCard(KavachAddressModel address) {
    // Clean the addr1 to remove trailing comma
    String cleanAddr1 = address.addr1.trim();
    if (cleanAddr1.endsWith(',')) {
      cleanAddr1 = cleanAddr1.substring(0, cleanAddr1.length - 1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.addressName, style: AppTextStyle.textDarkGreyColor14w500),
        Text(cleanAddr1, style: AppTextStyle.textDarkGreyColor14w500),
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
