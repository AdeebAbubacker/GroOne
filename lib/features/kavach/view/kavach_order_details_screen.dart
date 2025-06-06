import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/model/kavach_order_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_image.dart';
import '../../../utils/common_functions.dart';

class KavachOrderDetailsScreen extends StatelessWidget {
  final KavachOrderListOrderItem order;

  const KavachOrderDetailsScreen({super.key, required this.order});

  int getTotalQuantity() {
    return order.lineItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: CommonAppBar(title: "Order Details"),
      // bottomNavigationBar: _downloadButton(),
      body: SafeArea(
        child: SingleChildScrollView(
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
              _addressSection(order.shippingAddress),
              12.height,
              _addressSection(order.billingAddress),
              12.height,
              _paymentSummary(),
              40.height,
            ],
          ),
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
                Text(
                  'Order ID: ${order.orderUniqueId}',
                  style: AppTextStyle.primaryColor14w700,
                ),
                4.height,
                Text(
                  formatDateTimeKavach(order.orderDate.toString()),
                  style: AppTextStyle.bodyGreyColor,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getKavachOrderStatusColor(
                order.statusHistory.last.statusLabel,
              ).withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              order.statusHistory.last.statusLabel,
              style: TextStyle(
                color: getKavachOrderStatusColor(
                  order.statusHistory.last.statusLabel,
                ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.productDetails, style: AppTextStyle.h5),
          8.height,
          ...order.lineItems.map((p) => _productItem(p)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Amount Paid", style: AppTextStyle.h5GreyColor),
              Text("₹${order.totalPrice}", style: AppTextStyle.h5),
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
                Text(p.product?.name ?? '', style: AppTextStyle.h5),
                Text(
                  p.product?.part ?? '',
                  style: AppTextStyle.textGreyColor12w400,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${p.totalPrice}', style: AppTextStyle.h5),
              Text(
                'Qty - ${p.quantity}',
                style: AppTextStyle.textGreyColor12w400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(order.statusHistory.last.statusLabel, style: AppTextStyle.h5),
        10.height,
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder:
                (context, index) => _stage(
                  title: order.statusHistory[index].statusLabel,
                  date: order.statusHistory[index].createdAt,
                  subtitle: order.statusHistory[index].remarks,
                  isLast: (order.statusHistory.length - 1) == index,
                  installationPersonMobile:
                      order.installationContactPersonNumber,
                  installationPersonName: order.installationContactPerson,
                ),
            itemCount: order.statusHistory.length,
          ),
        ),
      ],
    );
  }

  Widget _stage({
    required String title,
    required DateTime date,
    required String subtitle,
    required bool isLast,
    String? installationPersonName,
    String? installationPersonMobile,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                Icons.radio_button_checked,
                color: AppColors.primaryColor,
                size: 20,
              ),
              Visibility(
                visible: isLast == false,
                child: Expanded(
                  child: Container(width: 2, color: Colors.grey.shade300),
                ),
              ),
            ],
          ),
          8.width,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: AppTextStyle.blackColor15w500),
                      5.width,
                      Visibility(
                          visible: title.toLowerCase() == "installation scheduled",
                          child: Icon(Icons.headset_mic_rounded, size: 16))
                    ],
                  ),
                  Text(subtitle, style: AppTextStyle.textGreyColor14w300),
                  5.height,
                  Text(
                    formatDateTimeKavach(date.toString()),
                    style: AppTextStyle.textGreyColor14w300,
                  ),
                  Visibility(
                    visible: title.toLowerCase() == "installation scheduled",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        5.height,
                        Text(
                          "Installation Person Contact Details",
                          style: AppTextStyle.h6,
                        ),
                        Text(installationPersonName ?? '', style: AppTextStyle.h5),
                        Text(
                          installationPersonMobile ?? '',
                          style: AppTextStyle.primaryColor14w700,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressSection(KavachOrderListAddress address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${address.addressType.capitalize} Address', style: AppTextStyle.h5),
        10.height,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.addressLine1,
                style: AppTextStyle.textGreyColor14w300,
              ),
              Text(
                address.addressLine2,
                style: AppTextStyle.textGreyColor14w300,
              ),
              Text(
                address.city,
                style: AppTextStyle.textGreyColor14w300,
              ),
              Text(
                address.state,
                style: AppTextStyle.textGreyColor14w300,
              ),
              Text(
                '${address.country} - ${address.postalCode}',
                style: AppTextStyle.textGreyColor14w300,
              ),
              address.gstId.isNotEmpty?Text(
                address.gstId,
                style: AppTextStyle.textGreyColor14w300,
              ):SizedBox.shrink(),
            ],
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children:  [
              PriceRow("Price (${getTotalQuantity()} items)", '₹${order.price}'),
              PriceRow("GST", '₹${order.totalGst}'),
              Divider(),
              PriceRow("Total Amount Paid", '₹${order.totalPrice}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _downloadButton() {
    return AppButton(
      onPressed: () {},
      title: 'Download Invoice',
    ).bottomNavigationPadding();
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
