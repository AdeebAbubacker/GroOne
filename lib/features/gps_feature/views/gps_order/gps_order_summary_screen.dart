import 'package:flutter/material.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_order_benefits_and_order_list_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
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
import 'package:dotted_line/dotted_line.dart';

class GpsOrderSummaryScreen extends StatelessWidget {
  GpsOrderSummaryScreen({super.key});

  // Static data
  final String productName = 'GPS Roadcast';
  final String productPart = 'BSVI | CS01K0001';
  final String hsnCode = 'HSN1234';
  final int quantity = 2;
  final double unitPrice = 3620.0;
  final double gstPerc = 18.0;
  final List<String> vehicleNumbers = ['MH12AB1234', 'MH12CD5678'];
  final String shippingPersonInCharge = 'Arvin Sagar';
  final String shippingPersonContactNo = '9876543210';
  final String referral = 'GDP67543 - Arvin Sagar';
  final String billingAddress = 'Office Address\n123 Business Park, Sector 15, Mumbai, Maharashtra - 400001\nIndia - 400001\nGST: 27ABCDE1234F1Z5';
  final String shippingAddress = 'Delivery Address 1\n789 Residential Colony, Pune, Maharashtra - 411001\nIndia - 411001';

  double get totalPrice => unitPrice * quantity;
  double get totalGst => totalPrice * (gstPerc / 100);
  double get totalAmount => totalPrice + totalGst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.summary,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(
                context,
                commonRoute(
                  Scaffold(
                    appBar: AppBar(title: Text('Support')),
                    body: Center(child: Text('Support Screen')),
                  ),
                ),
              );
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          5.width,
        ],
      ),
      bottomNavigationBar: _buildProceedToPayButton(context),
      body: _buildBodyWidget(context),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _productWidget(context),
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
                  Text(vehicleNumbers.join(", "), style: AppTextStyle.textDarkGreyColor14w500),
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
                  _buildAddressCard(shippingAddress),
                  15.height,
                  Text(context.appText.billingAddress, style: AppTextStyle.h5),
                  10.height,
                  _buildAddressCard(billingAddress),
                ],
              ),
            ),
            30.height,
          ],
        ).paddingAll(commonSafeAreaPadding),
      ),
    );
  }

  Widget _productWidget(BuildContext context) {
    final double gstAmount = totalGst;
    final double totalWithGst = totalAmount;
    final double cgst = gstAmount / 2;
    final double sgst = gstAmount / 2;
    final double igst = 0.0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: commonContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.paymentDetails, style: AppTextStyle.h4),
          10.height,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: AppTextStyle.h5),
                    Text(productPart, style: AppTextStyle.textDarkGreyColor14w500),
                  ],
                ),
              ),
              Text("₹${totalPrice.toStringAsFixed(2)}", style: AppTextStyle.blackColor15w500),
            ],
          ),
          5.height,
          _buildDetailRow("HSN Code", hsnCode),
          _buildDetailRow("Qty", quantity.toString().padLeft(2, '0')),
          _buildDetailRow("Rate /Unit ₹", "₹${unitPrice.toStringAsFixed(2)}"),
          _buildDetailRow("IGST", "₹${igst.toStringAsFixed(2)}"),
          _buildDetailRow("CGST", "₹${cgst.toStringAsFixed(2)}"),
          _buildDetailRow("SGST", "₹${sgst.toStringAsFixed(2)}"),
          _buildDetailRow("Total GST", "₹${gstAmount.toStringAsFixed(2)}"),
          5.height,
          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.0,
            dashLength: 6.0,
            dashColor: AppColors.greyIconColor,
          ),
          5.height,
          _buildDetailRow("Total Amount", "₹${totalWithGst.toStringAsFixed(0)}"),
          15.height,
        ],
      ),
    );
  }

  Widget _buildProceedToPayButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, -2),
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
              Text('₹${totalAmount.toStringAsFixed(2)}', style: AppTextStyle.primaryColor16w900),
            ],
          ),
          15.width,
          AppButton(
            onPressed: () {
            Navigator.push(context, commonRoute(GpsOrderBenefitsAndOrderListScreen(showBenefits: false)));
            },
            title: context.appText.proceedToPay,
            style: AppButtonStyle.primary,
          ).expand(),
        ],
      ).paddingOnly(bottom: 30, right: 20, left: 20, top: 15),
    );
  }

  Widget _buildAddressCard(String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: address.split('\n').map((line) => Text(line, style: AppTextStyle.textDarkGreyColor14w500)).toList(),
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