import 'dart:convert';
import 'dart:developer';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/extra_utils.dart';
import '../bloc/kavach_order_bloc/kavach_order_event.dart';
import '../bloc/kavach_order_bloc/kavach_order_state.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import '../helper/kavach_helper.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_product_model.dart';
import 'kavach_support_screen.dart';

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
  });

  @override
  State<KavachSummaryScreen> createState() => _KavachSummaryScreenState();
}

class _KavachSummaryScreenState extends State<KavachSummaryScreen> {
  final kavachOrderBloc = locator<KavachOrderBloc>();

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<KavachOrderBloc, KavachOrderState>(
      bloc: kavachOrderBloc,
      listener: (context, state) {
        if (state is KavachOrderSubmitting) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          if (Navigator.canPop(context)) Navigator.of(context).pop();
        }

        if (state is KavachOrderSuccess) {
          showSuccessDialog(
            context,
            text: 'Order placed successfully',
            subheading: ''
          );
          Future.delayed(Duration(seconds: 3),() {
            Navigator.of(context).popUntil((route) {
              if (route.settings.name == 'KavachOrderListScreen') {
                if (route.navigator != null && route.navigator!.context.mounted) {
                  BlocProvider.of<KavachOrderListBloc>(route.navigator!.context).add(FetchKavachOrderList(forceRefresh: true,isRefresh: true));
                }
                return true; // Pop until this route
              }
              return false;
            });
          },);

          // Pop until KavachBenefitsScreen
        } else if (state is KavachOrderFailure) {
          ToastMessages.error(message: "Failed to place order: ${state.message}");
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(title: context.appText.summary,
          actions: [
          AppIconButton(
          onPressed: () {
            Navigator.push(context, commonRoute(KavachSupportScreen()));
          },
          icon: AppIcons.svg.filledSupport,
          iconColor: AppColors.primaryButtonColor,
        ),
          5.width,
        ],),
        bottomNavigationBar: _buildProceedToPayButton(context),
        body: _buildBodyWidget(context),
      ),
    );
  }


  Widget _buildBodyWidget(BuildContext context){
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
                    context.appText.vehicleDetails,
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
                  Text(context.appText.shippingAddress, style: AppTextStyle.h5,),
                  10.height,
                  _buildAddressCard(widget.shippingAddress),
                  15.height,
                  Text(context.appText.billingAddress, style: AppTextStyle.h5,),
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

  Widget _productWidget(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.paymentDetails, style: AppTextStyle.h4),
          10.height,
          ...widget.products.map((product) {
            final qty = widget.quantities[product.id] ?? 0;
            final totalPrice = product.price * qty;
            final gstAmount = totalPrice * (product.gstPerc / 100);
            final totalWithGst = totalPrice + gstAmount;

            final isTamilNadu = widget.billingAddress.state.trim().toLowerCase() == "tamil nadu";
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
                          Text(product.part, style: AppTextStyle.textDarkGreyColor14w500),
                        ],
                      ),
                    ),
                    Text("₹${KavachHelper.formatCurrency(totalPrice.toStringAsFixed(2))}", style: AppTextStyle.blackColor15w500),
                  ],
                ),
                5.height,
                _buildDetailRow("HSN Code",  product.hsnSacCode??'-'),
                _buildDetailRow("Qty", qty.toString().padLeft(2, '0')),
                _buildDetailRow("Rate /Unit ₹", "₹${KavachHelper.formatCurrency(product.price.toStringAsFixed(2))}"),
                _buildDetailRow("IGST", "₹${KavachHelper.formatCurrency(igst.toStringAsFixed(2))}"),
                _buildDetailRow("CGST", "₹${KavachHelper.formatCurrency(cgst.toStringAsFixed(2))}"),
                _buildDetailRow("SGST", "₹${KavachHelper.formatCurrency(sgst.toStringAsFixed(2))}"),
                _buildDetailRow("Total GST", "₹${KavachHelper.formatCurrency(gstAmount.toStringAsFixed(2))}"),
                5.height,
                DottedLine(
                  direction: Axis.horizontal,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 6.0,
                  dashColor: AppColors.greyIconColor,
                ),
                5.height,
                _buildDetailRow("Total Amount", "₹${KavachHelper.formatCurrency(totalWithGst.toStringAsFixed(0))}"),
                15.height,
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProceedToPayButton(BuildContext context){
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
              Text(context.appText.total, style: AppTextStyle.blackColor14w400,),
              Text('₹${KavachHelper.formatCurrency(totalAmount.toStringAsFixed(2))}', style: AppTextStyle.primaryColor16w900),
            ],
          ),
          15.width,
          AppButton(
            onPressed: () async {
              final request = KavachOrderRequest(
                orderSource: "MOBILE",
                isOrderPaid: false,
                orderTypeId: 1,
                customerId: await kavachOrderBloc.getUserId()??'',
                totalPrice: totalAmount,
                categoryId: 1,
                shippingPersonIncharge: widget.shippingPersonInCharge,
                shippingPersonContactNo: widget.shippingPersonContactNo,
                customerInfo: {
                  "CompanyName": "ABC Logistics Pvt Ltd",
                  "contactNumber": "9876543210",
                  "BlueMembershipID": "BLUE123456"
                },
                createdEmpUserId: 1234,
                orderReferencedBy: widget.orderReferencedBy,
                billingAddress: {
                  "addressLine1": widget.billingAddress.addressName,
                  "addressLine2": widget.billingAddress.addr1,
                  "city": widget.billingAddress.city,
                  "state": widget.billingAddress.state,
                  "postalCode": widget.billingAddress.pincode,
                  "country": widget.billingAddress.country,
                  "gstId": widget.billingAddress.gstin??"",
                },
                shippingAddress: {
                  "addressLine1": widget.shippingAddress.addressName,
                  "addressLine2": widget.shippingAddress.addr1,
                  "city": widget.shippingAddress.city,
                  "state": widget.shippingAddress.state,
                  "postalCode": widget.shippingAddress.pincode,
                  "country": widget.shippingAddress.country,
                  "gstId": widget.shippingAddress.gstin??""
                },
                // orders: widget.products.map((product) {
                //   final quantity = widget.quantities[product.id]!;
                //   final stock = widget.availableStocks[product.id] ?? 0;
                //
                //   return KavachOrderItem(
                //     productServiceId: int.parse(product.id),
                //     noOfProducts: quantity,
                //     unitPrice: product.price,
                //     totalPrice: product.price * quantity * (1 + (product.gstPerc / 100)),
                //     stockAvailable: stock,
                //     vehicleNumbers: widget.selectedVehicleNumbers.map((v) => KavachOrderVehicle(vehicleNumber: v)).toList(),
                //   );
                // }).toList(),
                orders: widget.products.map((product) {
                  final quantity = widget.quantities[product.id]!;
                  final stock = widget.availableStocks[product.id] ?? 0;
                  final vehicleNumbers = widget.selectedVehiclePerProduct[product.id] ?? [];

                  return KavachOrderItem(
                    productServiceId: int.parse(product.id),
                    noOfProducts: quantity,
                    unitPrice: product.price,
                    totalPrice: product.price * quantity * (1 + (product.gstPerc / 100)),
                    stockAvailable: stock,
                    vehicleNumbers: vehicleNumbers.map((v) => KavachOrderVehicle(vehicleNumber: v)).toList(),
                  );
                }).toList(),
                teamId: 1,

              );

              if (kDebugMode) {
                log(jsonEncode(request));
              }
              kavachOrderBloc.add(KavachSubmitOrder(request));
            },
            title: context.appText.placeOrder,
            style: AppButtonStyle.primary,
          ).expand()
        ],
      ).paddingOnly(bottom: 30,right: 20,left: 20,top: 15),
    );
  }

  Widget _buildAddressCard(KavachAddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address.addressName,style: AppTextStyle.textDarkGreyColor14w500,),
        Text(address.addr1,style: AppTextStyle.textDarkGreyColor14w500,),
        Text("${address.city}, ${address.state}",style: AppTextStyle.textDarkGreyColor14w500,),
        Text("${address.country}- ${address.pincode}",style: AppTextStyle.textDarkGreyColor14w500,),
        Visibility(
            visible: address.gstin!=null && address.gstin!.isNotEmpty,
            child: Text("${context.appText.gstKavach} - ${address.gstin}",style: AppTextStyle.textDarkGreyColor14w500,)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: AppTextStyle.textDarkGreyColor14w500)),
        Text(value, style: AppTextStyle.blackColor15w500),
      ],
    ).paddingSymmetric(vertical: 5);
  }
}


