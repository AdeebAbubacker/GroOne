import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/helper/kavach_helper.dart';
import 'package:gro_one_app/features/kavach/model/kavach_order_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/common_functions.dart';
import '../../profile/view/support_screen.dart';
import '../../profile/view/widgets/add_new_support_ticket.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_state.dart';
import 'kavach_choose_your_preference_screen.dart';

class KavachOrderDetailsScreen extends StatelessWidget {
  final KavachOrderListOrderItem order;

  const KavachOrderDetailsScreen({super.key, required this.order});

  int getTotalQuantity() {
    return order.lineItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: context.appText.orderDetail,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                commonRoute(KavachChooseYourPreferenceScreen()),
              );
            },
            icon: Icon(Icons.add, color: Colors.white),
            style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
          ),
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
        centreTile: false,
      ),
      // bottomNavigationBar: _downloadButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              12.height,
              _productDetails(context),
              12.height,
              _orderTimeline(context),
              12.height,
              _addressSection(order.billingAddress, context),
              _addressSection(order.shippingAddress, context),
              12.height,
              _paymentSummary(context),
              12.height,
              _groExecutiveWidget(context),
              12.height,
              _downloadButton(),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _productDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(commonBottomSheetRadius),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.appText.orderId}: ${order.orderUniqueId}',
                      style: AppTextStyle.primaryColor14w700,
                    ),
                    4.height,
                    Text(
                      order.orderDate.toString(),
                      style: AppTextStyle.bodyGreyColor,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: KavachHelper.getKavachOrderStatusColor(
                    order.statusHistory.last.statusLabel,
                  ).withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.statusHistory.last.statusLabel,
                  style: TextStyle(
                    color: KavachHelper.getKavachOrderStatusColor(
                      order.statusHistory.last.statusLabel,
                    ),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          25.height,
          Text(
            order.lineItems.length == 1
                ? context.appText.productDetail
                : context.appText.productDetails,
            style: AppTextStyle.h5,
          ),
          8.height,
          ...order.lineItems.map((p) => _productItem(p, context)),
          const Divider(color: AppColors.shadowColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.appText.totalAmountPaid,
                style: AppTextStyle.h5GreyColor,
              ),
              Text(
                "₹${KavachHelper.formatCurrency(order.totalPrice)}",
                style: AppTextStyle.h5,
              ),
            ],
          ),
          10.height,
        ],
      ),
    );
  }

  Widget _productItem(KavachOrderListItem p, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              p.product?.fileKey != null
                  ? CachedNetworkImage(
                    imageUrl: p.product!.fileKey,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  )
                  : Image.asset(AppImage.png.kavachProduct, width: 70),
              8.width,
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
                  Text(
                    '₹${KavachHelper.formatCurrency(p.totalPrice)}',
                    style: AppTextStyle.h5,
                  ),
                  Text(
                    '${context.appText.qty} - ${p.quantity}',
                    style: AppTextStyle.textGreyColor12w400,
                  ),
                ],
              ),
            ],
          ),
          // Vehicle information section
          if (p.vehicles.isNotEmpty) ...[
            8.height,
            Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                4.width,
                Expanded(
                  child: Text(
                    _formatVehicleNumbers(p.vehicles),
                    style: AppTextStyle.textBlackColor12w400,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatVehicleNumbers(List<KavachOrderListVehicle> vehicles) {
    if (vehicles.isEmpty) return '';

    if (vehicles.length <= 2) {
      return vehicles.map((v) => v.vehicleNumber).join(', ');
    } else {
      final firstTwo = vehicles.take(2).map((v) => v.vehicleNumber).join(', ');
      return '$firstTwo, +${vehicles.length - 2} more';
    }
  }

  Widget _orderTimeline(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(commonSafeAreaPadding),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.status, style: AppTextStyle.h4),
          20.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    context: context,
                  ),
              itemCount: order.statusHistory.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stage({
    required String title,
    required String date,
    required String subtitle,
    required bool isLast,
    required BuildContext context,
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
                        visible:
                            title.toLowerCase() ==
                            context.appText.installationScheduled.toLowerCase(),
                        child: Icon(Icons.headset_mic_rounded, size: 16),
                      ),
                    ],
                  ),
                  Text(subtitle, style: AppTextStyle.textGreyColor14w300),
                  5.height,
                  Text(
                    date.toString(),
                    style: AppTextStyle.textGreyColor14w300,
                  ),
                  Visibility(
                    visible:
                        title.toLowerCase() ==
                        context.appText.installationScheduled.toLowerCase(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        5.height,
                        Text(
                          context.appText.installationPersonContactDetails,
                          style: AppTextStyle.h6,
                        ),
                        Text(
                          installationPersonName ?? '',
                          style: AppTextStyle.h5,
                        ),
                        Text(
                          installationPersonMobile ?? '',
                          style: AppTextStyle.primaryColor14w700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressSection(KavachOrderListAddress address, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: commonSafeAreaPadding,
      ),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.addressType.toLowerCase() == "shipping"
                ? context.appText.shippingAddress
                : context.appText.billingAddress,
            style: AppTextStyle.h4,
          ),
          10.height,
          Text(address.addressLine1, style: AppTextStyle.textGreyColor14w300),
          Text(address.addressLine2, style: AppTextStyle.textGreyColor14w300),
          Text(address.city, style: AppTextStyle.textGreyColor14w300),
          Text(address.state, style: AppTextStyle.textGreyColor14w300),
          Text(
            '${address.country} - ${address.postalCode}',
            style: AppTextStyle.textGreyColor14w300,
          ),
          address.gstId.isNotEmpty
              ? Text(address.gstId, style: AppTextStyle.textGreyColor14w300)
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _paymentSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.appText.paymentSummary, style: AppTextStyle.h4),
              10.height,
              PriceRow(
                "${context.appText.price} (${getTotalQuantity()} ${getTotalQuantity() == 1 ? 'item' : context.appText.items})",
                '₹${KavachHelper.formatCurrency(order.price.toStringAsFixed(2))}',
              ),
              PriceRow(
                context.appText.gstKavach,
                '₹${KavachHelper.formatCurrency(order.totalGst.toStringAsFixed(2))}',
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
              PriceRow(
                context.appText.totalAmountPaid,
                '₹${KavachHelper.formatCurrency(order.totalPrice.toStringAsFixed(2))}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _groExecutiveWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(commonSafeAreaPadding),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.appText.groExecutive, style: AppTextStyle.h5),
          Text(order.orderReferencedBy, style: AppTextStyle.bodyGreyColor),
        ],
      ),
    );
  }

  Widget _downloadButton() {
    return BlocConsumer<KavachOrderListBloc, KavachOrderListState>(
      listener: (context, state) {
        if (state is InvoiceDownloaded) {
          // Open the invoice in browser or PDF viewer
          launchUrl(Uri.parse(state.url), mode: LaunchMode.externalApplication);
        } else if (state is KavachOrderListError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return AppButton(
          onPressed: () {
            context.read<KavachOrderListBloc>().add(
              DownloadInvoiceEvent(order.id),
            );
          },
          title:
              state is InvoiceDownloading
                  ? context.appText.downloading
                  : context.appText.downloadInvoice,
        ).bottomNavigationPadding();
      },
    );
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
