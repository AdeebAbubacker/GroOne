import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/helper/kavach_helper.dart';
import 'package:gro_one_app/features/kavach/view/kavach_order_details_screen.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_functions.dart';
import '../../model/kavach_order_list_model.dart';

class KavachOrderCardWidget extends StatelessWidget {
  final KavachOrderListOrderItem order;

  const KavachOrderCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 10),
      decoration: commonContainerDecoration(borderColor: AppColors.borderColor),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID and Status
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order ID: ${order.orderUniqueId}',
                    style: AppTextStyle.h5PrimaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: KavachHelper.getKavachOrderStatusColor(order.statusHistory.last.statusLabel).withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.statusHistory.first.statusLabel,
                    style: TextStyle(
                      color: KavachHelper.getKavachOrderStatusColor(order.statusHistory.last.statusLabel),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            6.height,
            Row(
              children: [
                Expanded(child: Text(order.lineItems.length>1?'${order.lineItems.first.product?.name} +${order.lineItems.length-1}':'${order.lineItems.first.product?.name}', style: AppTextStyle.textGreyColor14w300)),
                // Text('₹${order.orderAmount}', style: AppTextStyle.h4),
                Text('₹${double.parse(order.orderAmount).round()}', style: AppTextStyle.h4),
              ],
            ),
            Divider(color: AppColors.borderColor,),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(commonRoute(KavachOrderDetailsScreen(order: order,)));
                    },
                    child: Text("View Detail", style: AppTextStyle.primaryColor14w700)),
                15.width,
                Expanded(child: Text("Purchased on ${formatDateTimeKavach(order.orderDate.toString())}", style: AppTextStyle.textGreyColor14w300,maxLines: 1,)),
              ],
            )
          ],
        ),
      ),
    );
  }

}