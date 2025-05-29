import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/view/kavach_order_details_screen.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_style.dart';

class KavachOrderItem {
  final String id;
  final String description;
  final String status;
  final int price;

  KavachOrderItem(this.id, this.description, this.status, this.price);
}

class KavachOrderCardWidget extends StatelessWidget {
  final KavachOrderItem order;

  const KavachOrderCardWidget({super.key, required this.order});

  Color _statusColor(String status) {
    switch (status) {
      case 'Order Placed':
        return AppColors.primaryColor;
      case 'Dispatched':
        return Colors.orange;
      case 'Delivered':
        return AppColors.greenColor;
      case 'Failed':
        return AppColors.activeRedColor;
      case 'Installed':
        return Colors.teal;
      default:
        return AppColors.greyContainerBackgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: AppColors.greyIconBackgroundColor)),
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
                    'Order ID: ${order.id}',
                    style: AppTextStyle.primaryColor16w900,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            6.height,
            Text(order.description, style: AppTextStyle.bodyGreyColor),
            4.height,
            Text('₹${order.price}', style: AppTextStyle.h4),
            6.height,
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(commonRoute(KavachOrderDetailsScreen()));
                    },
                    child: Text("View Details", style: AppTextStyle.primaryColor14w700)),
                15.width,
                Expanded(child: Text("Purchased on 21 May 2025, 7:30PM", style: AppTextStyle.bodyGreyColor)),
              ],
            )
          ],
        ),
      ),
    );
  }
}