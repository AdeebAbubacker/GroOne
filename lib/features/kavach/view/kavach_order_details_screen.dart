import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/model/kavach_order_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_image.dart';
import '../../../utils/common_functions.dart';

class KavachOrderDetailsScreen extends StatelessWidget {
  final KavachOrderListOrderItem order;

  const KavachOrderDetailsScreen({super.key, required this.order,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: CommonAppBar(
        title: "Order Details",
      ),
      bottomNavigationBar: _downloadButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderHeader(),
            12.height,
            _productDetails(context),
            12.height,
            _orderTimeline(),
            12.height,
            _addressSection(context.appText.shippingAddress),
            12.height,
            _addressSection(context.appText.billingAddress),
            12.height,
            _paymentSummary(),
            20.height,
          ],
        ),
      ),
    );
  }

  Widget _orderHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: ${order.orderUniqueId}', style: AppTextStyle.primaryColor14w700),
                4.height,
                Text(formatDateTimeKavach(order.orderDate.toString()), style: AppTextStyle.bodyGreyColor),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getKavachOrderStatusColor(order.statusHistory.last.statusLabel).withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              order.statusHistory.first.statusLabel,
              style: TextStyle(
                color: getKavachOrderStatusColor(order.statusHistory.last.statusLabel),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.productDetails, style: AppTextStyle.h5),
          8.height,
          ...order.lineItems.map((p) => _productItem(p)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              Text("Total Amount Paid", style: AppTextStyle.h5GreyColor),
              Text("₹${order.orderAmount}", style: AppTextStyle.h5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productItem(KavachOrderListItem p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Image.asset(AppImage.png.kavachProduct, width: 80),
          8.height,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.itemType, style: AppTextStyle.h5),
                Text(p.id, style: AppTextStyle.textGreyColor12w400),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${p.totalPrice}', style: AppTextStyle.h5),
              Text('Qty - ${p.quantity}', style: AppTextStyle.textGreyColor12w400),
            ],
          )
        ],
      ),
    );
  }

  Widget _orderTimeline() {
    final stages = [
      _stage("Order Placed", "Your order has been placed", true),
      _stage("Order Processing", "Your order has been processed", true),
      _stage("Dispatched", "Your order has been dispatched from the hub", true),
      _stage("Out for Delivery", "Your order is out for delivery", false),
      _stage("Delivered", "Your order has been delivered successfully", false),
      _stage("Installation Scheduled",
          "Your device will be Installed in 2 days after the delivery", false,
          icon: Icons.headset_mic),
      _stage("Installed", "Your device has been successfully installed.", false),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dispatched", style: AppTextStyle.h5),
        10.height,
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(children: stages),
        )
      ],
    );
  }

  Widget _stage(String title, String subtitle, bool isDone, {IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isDone ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isDone ? Colors.blue : Colors.grey,
              size: 20,
            ),
            Container(width: 2, height: 50, color: Colors.grey.shade300),
          ],
        ),
        8.width,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTextStyle.blackColor15w500),
                    if (icon != null) ...[
                      5.width,
                      Icon(icon, size: 16),
                    ],
                  ],
                ),
                Text(subtitle, style: AppTextStyle.textGreyColor14w300),
                5.height,
                Text("25 May 2025, 7.30 PM", style: AppTextStyle.textGreyColor14w300),
                if (title == "Installation Scheduled") ...[
                  5.height,
                  Text("Installation Person Contact Details", style: AppTextStyle.h6),
                  Text("Dinesh Kumar", style: AppTextStyle.h5),
                  Text("+91 9876543210", style: AppTextStyle.primaryColor14w700),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _addressSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.h5),
        10.height,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Text(
            "John Doe\n+91 98466 48963\n18, 4th Street, MG Road,\nNungambakkam,\nChennai - 600 034.",
            style: AppTextStyle.textGreyColor14w300,
          ),
        ),
      ],
    );
  }

  Widget _paymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment Summary", style: AppTextStyle.h5),
        10.height,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: const [
              PriceRow("Price (6 items)", "₹9,730.00"),
              PriceRow("GST", "₹650.00"),
              Divider(),
              PriceRow("Total Amount Paid", "₹10,480"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _downloadButton() {
    return AppButton(onPressed: (){},title: 'Download Invoice').bottomNavigationPadding();
  }
}

class Product {
  final String name;
  final String code;
  final int price;
  final int quantity;

  Product(this.name, this.code, this.price, this.quantity);
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const PriceRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.h5GreyColor),
          Text(value, style: AppTextStyle.h5),
        ],
      ),
    );
  }
}

// Shipping address
// Billing address
// Product name
// Product img
// Status clarification
// Download Invoice PDF link
// Separate payment summary - GST, price not there.


