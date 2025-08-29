import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_payment_api_request.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_event.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_state.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_billing_address_bloc/kavach_checkout_billing_address_event.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_checkout_shipping_address_bloc/kavach_checkout_shipping_address_event.dart';
import 'package:gro_one_app/features/kavach/helper/kavach_helper.dart';
import 'package:gro_one_app/features/kavach/model/kavach_address_model.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import 'package:gro_one_app/features/payments/view/payments_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../dependency_injection/locator.dart';
import '../../../service/analytics/analytics_event_name.dart';
import '../../../service/analytics/analytics_service.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_dialog_view/success_dialog_view.dart';
import '../../../utils/common_widgets.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import '../../login/repository/user_information_repository.dart';
import '../../profile/view/support_screen.dart';

class KavachSummaryScreen extends StatefulWidget {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  final Map<String, int> availableStocks;
  final KavachAddressModel shippingAddress;
  final KavachAddressModel billingAddress;
  final List<String> selectedVehicleNumbers;
  final String shippingPersonInCharge;
  final String shippingPersonContactNo;
  final String orderReferencedBy;
  final Map<String, List<String>> selectedVehiclePerProduct;
  final String? orderId; // Add orderId parameter
  final KavachOrderRequest kavachOrderRequest;

  const KavachSummaryScreen({
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
    this.orderId, // Make it optional
    required this.kavachOrderRequest,
  });

  @override
  State<KavachSummaryScreen> createState() => _KavachSummaryScreenState();
}

class _KavachSummaryScreenState extends State<KavachSummaryScreen> {
  final kavachOrderBloc = locator<KavachOrderBloc>();
  final profileCubit = locator<ProfileCubit>();
  final userInfoRepo = locator<UserInformationRepository>();
  final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  double get totalPrice {
    double total = 0.0;
    for (var product in widget.products) {
      int qty = widget.quantities[product.id] ?? 0;
      total += product.price * qty;
    }
    return total;
  }

  double get totalGst {
    double gst = 0.0;
    for (var product in widget.products) {
      int qty = widget.quantities[product.id] ?? 0;
      double itemTotal = product.price * qty;
      gst += itemTotal * (product.gstPerc / 100);
    }
    return gst;
  }

  double get totalAmount {
    return totalPrice + totalGst;
  }

  // Get customer information from profile or session
  Future<Map<String, String>> getCustomerInfo() async {
    try {
      // First try to get from session storage
      String? companyName = await userInfoRepo.getUsername();
      String? contactNumber = await userInfoRepo.getUserMobileNumber();
      String? blueId = await userInfoRepo.getBlueID();

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
      };
    } catch (e) {
      // Return hardcoded values as fallback
      return {
        "CompanyName": "ABC Logistics Pvt Ltd",
        "contactNumber": "9876543210",
        "BlueMembershipID": "BLUE123456",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KavachOrderBloc, KavachOrderState>(
      bloc: kavachOrderBloc,
      listener: (context, state) async {
        if (state is KavachPaymentSuccess) {
          final result = await Navigator.of(context).push(
            commonRoute(
              PaymentsScreen(
                url: state.paymentResponse.data?.data?.tinyUrl ?? "",
                loadId: "kavach_order",
              ),
            ),
          );
          await Future.delayed(Duration(seconds: 1));
          if (result == true) {
            final paymentRequestId = kavachOrderBloc.paymentRequestId;
            if (paymentRequestId != null) {
              kavachOrderBloc.add(CheckFleetPaymentStatus(paymentRequestId));
            }
          }
        }
        if (state is KavachPaymentStatusSuccess) {
          KavachOrderRequest request = widget.kavachOrderRequest;
          request.paymentRequestId = kavachOrderBloc.paymentRequestId;
          analyticsHelper.logEvent(AnalyticEventName.FLEET_ORDER_CREATION, request.toJson(),);
          kavachOrderBloc.add(KavachSubmitOrder(request));
        }
        if (state is KavachPaymentStatusFailure) {
          ToastMessages.error(message: context.appText.paymentFailed);
        }
        if (state is KavachOrderSuccess) {
          await Future.delayed(Duration(milliseconds: 500));
          ///new
          AppDialog.show(
            context,
            child: SuccessDialogView(
              message: context.appText.orderPlacedSuccessfully,
              onContinue: () {
                if (context.mounted) {
                  // Clear address blocs before navigating back
                  try {
                    // Clear billing address bloc
                    final billingBloc = locator<KavachCheckoutBillingAddressBloc>();
                    billingBloc.add(ClearKavachBillingAddress());

                    // Clear shipping address bloc
                    final shippingBloc =
                    locator<KavachCheckoutShippingAddressBloc>();
                    shippingBloc.add(ClearKavachShippingAddress());
                  } catch (e) {
                    // Handle any errors if blocs are not available
                  }

                  Navigator.of(context).popUntil((route) {
                    if (route.settings.name == 'KavachOrderListScreen') {
                      if (route.navigator != null &&
                          route.navigator!.context.mounted) {
                        BlocProvider.of<KavachOrderListBloc>(
                          route.navigator!.context,
                        ).add(
                          FetchKavachOrderList(forceRefresh: true, isRefresh: true),
                        );
                      }
                      return true; // Pop until this route
                    }
                    return false;
                  });
                }
              },
            ),
          );
        }
        if (state is KavachOrderFailure) {
          ToastMessages.error(message: state.message);
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: context.appText.summary,
          actions: [
            AppIconButton(
              onPressed: () {
                Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true), isForward: true));
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
                        ? context.appText.vehicleDetail
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

            //15.height,
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
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.appText.paymentDetails,
            style: AppTextStyle.h4,
          ),
          10.height,
          ...widget.products.map((product) {
            final qty = widget.quantities[product.id] ?? 0;
            final totalPrice = product.price * qty;
            final gstAmount = totalPrice * (product.gstPerc / 100);
            final totalWithGst = totalPrice + gstAmount;

            final isTamilNadu =
                widget.billingAddress.state.trim().toLowerCase() ==
                "tamil nadu";
            final cgst = isTamilNadu ? gstAmount / 2 : 0.0;
            final sgst = isTamilNadu ? gstAmount / 2 : 0.0;
            final igst = isTamilNadu ? 0.0 : gstAmount;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: AppTextStyle.h5),
                          Text(
                            product.part,
                            style: AppTextStyle.textDarkGreyColor14w500,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "₹${KavachHelper.formatCurrency(totalPrice.toStringAsFixed(2))}",
                      style: AppTextStyle.blackColor15w500,
                    ),
                  ],
                ),
                5.height,
                _buildDetailRow(context.appText.hsnCode, product.hsnSacCode ?? '-'),
                _buildDetailRow(context.appText.qty, qty.toString().padLeft(2, '0')),
                _buildDetailRow(
                  context.appText.ratePerUnit,
                  "₹${KavachHelper.formatCurrency(product.price.toStringAsFixed(2))}",
                ),
                _buildDetailRow(
                  context.appText.igst,
                  "₹${KavachHelper.formatCurrency(igst.toStringAsFixed(2))}",
                ),
                _buildDetailRow(
                  context.appText.cgst,
                  "₹${KavachHelper.formatCurrency(cgst.toStringAsFixed(2))}",
                ),
                _buildDetailRow(
                  context.appText.sgst,
                  "₹${KavachHelper.formatCurrency(sgst.toStringAsFixed(2))}",
                ),
                _buildDetailRow(
                  context.appText.totalGst,
                  "₹${KavachHelper.formatCurrency(gstAmount.toStringAsFixed(2))}",
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
                  "₹${totalWithGst.toStringAsFixed(2)}",
                ),
                15.height,
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProceedToPayButton(BuildContext context) {
    return BlocBuilder<KavachOrderBloc, KavachOrderState>(
      bloc: kavachOrderBloc,
  builder: (context, state) {
    final isLoading = state is KavachOrderSubmitting ||
        state is KavachPaymentInitiating ||
        state is KavachPaymentStatusChecking;
    return Container(
      padding: EdgeInsets.only(top: 10),
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
              final customerInfo = await getCustomerInfo();
              final customerId =
                  await locator<UserInformationRepository>().getUserID();

              if (customerId != null && customerId.isNotEmpty) {
                final paymentRequest = KavachInitiatePaymentRequest(
                  orderId:
                      widget.orderId ??
                      "ORDER_${DateTime.now().millisecondsSinceEpoch}",
                  amount: totalAmount,
                  customerName:
                      customerInfo["CompanyName"] ?? "ABC Logistics Pvt Ltd",
                  customerEmail:
                      widget.kavachOrderRequest.customerInfo['email'],
                  customerMobile: customerInfo["contactNumber"] ?? "9876543210",
                  customerCity: widget.billingAddress.city,
                  customerId: customerId,
                  merchantReferenceNo: 'fleet',
                );

                kavachOrderBloc.add(KavachInitiatePayment(paymentRequest));
              }
            },
            title: context.appText.placeOrder,
            style: AppButtonStyle.primary,
          ).expand(),
        ],
      ).bottomNavigationPadding(),
    );
  },
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
}
