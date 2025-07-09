import 'package:flutter/material.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_models_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/constant_variables.dart';
import '../../../../utils/common_functions.dart';
import 'gps_upload_document_screen.dart';
import 'gps_transaction_screen.dart';

class GpsOrderBenefitsAndOrderListScreen extends StatelessWidget {
  final bool showBenefits;
  GpsOrderBenefitsAndOrderListScreen({super.key, required this.showBenefits});
  final GlobalKey menuKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    const double menuWidth = 200.0;
    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        title: Text(context.appText.gps, style: AppTextStyle.appBar),
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {},
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
          // Add More Icon
          AppIconButton(
            key: menuKey, // Attach key
            onPressed: () async {
              final RenderBox button = menuKey.currentContext!.findRenderObject() as RenderBox;
              final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

              final selected = await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  position.dx - 100, // To the left of the icon
                  position.dy,       // Align top with the icon
                  position.dx,       // Right edge = icon start
                  overlay.size.height - position.dy,
                ),
                items: [
                  PopupMenuItem(
                    value: 'transaction',
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Transaction'),
                      ],
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
              );

              if (selected == 'transaction') {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => GpsTransactionScreen(),
                ));
              }
            },
            icon: Icons.more_vert,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
        ],
      ),
      body: showBenefits ? gpsBenifitsWidget(context) : gpsOrderListWidget(context),
    );
  }

  // --- Benefits Section (unchanged) ---
  Widget gpsBenifitsWidget(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildGpsProductImageWidget(context),
                20.height,
                buildGpsBenefitsDetailsWidget(context),
                buildGroBannerImageWidget(),
              ],
            ),
          ),
        ),
        // Fixed bottom button
        AppButton(
          title: context.appText.buyNewGps,
          onPressed: () {
            //Navigator.push(context,commonRoute(GpsUploadDocumentScreen()));
              Navigator.push(context,commonRoute(GpsModelsScreen()));
            
          },
        ).paddingOnly(bottom: 30, left: 15, right: 15, top: 10),
      ],
    );
  }

  Widget buildGpsProductImageWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.18,
      color: AppColors.lightPrimaryColor,
      child: Image.asset(
        AppImage.png.gpsBenefitTruck,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildGpsBenefitsDetailsWidget(BuildContext context) {
    Widget innerUIWidget({
      required String icon,
      required String title,
      required String subTitle,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            decoration: commonContainerDecoration(
              color: AppColors.lightPrimaryColor,
              borderRadius: BorderRadius.circular(100),
              borderColor: AppColors.primaryColor,
            ),
            child: Image.asset(icon, width: 25).paddingAll(15),
          ),
          15.width,

          // Heading or SubHeading
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.h5),
              5.height,
              Text(subTitle, style: AppTextStyle.body3),
            ],
          ).expand(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.gpsBenefitGps, style: AppTextStyle.body1),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.cardPayment,
          title: context.appText.benefitsOfGpsCardHeading1,
          subTitle: context.appText.benefitsOfGpsCardSubHeading1,
        ),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.tracking,
          title: context.appText.benefitsOfGpsCardHeading2,
          subTitle: context.appText.benefitsOfGpsCardSubHeading2
        ),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.reconcilation,
          title: context.appText.benefitsOfGpsCardHeading3,
          subTitle: context.appText.benefitsOfGpsCardSubHeading3,
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }

  Widget buildGroBannerImageWidget() {
    return Image.asset(AppImage.png.groBanner,width: double.infinity,fit: BoxFit.cover);
  }

  // --- Order List Section (static/mock data) ---
  Widget gpsOrderListWidget(BuildContext context) {
    // Mock static order data
    final orders = [
      {
        'orderId': '45465846SFG3',
        'status': 'Order Placed',
        'date': '2025-05-21T19:30:00',
        'product': 'GPS Telkon CSK77332, +2',
        'amount': 7500.0,
      },
      {
        'orderId': '45465846SFG3',
        'status': 'Dispatched',
        'date': '2025-05-21T19:30:00',
        'product': 'GPS Telkon CSK77332, +2',
        'amount': 9500.0,
      },
      {
        'orderId': '45465846SFG3',
        'status': 'Delivered',
        'date': '2025-05-21T19:30:00',
        'product': 'GPS Telkon CSK77332, +2',
        'amount': 6200.0,
      },
      {
        'orderId': '45465846SFG3',
        'status': 'Failed',
        'date': '2025-05-21T19:30:00',
        'product': 'GPS Telkon CSK77332, +2',
        'amount': 6500.0,
      },
      {
        'orderId': '45465846SFG3',
        'status': 'Installed',
        'date': '2025-05-21T19:30:00',
        'product': 'en-Dhan Tank Lock, +5',
        'amount': 10500.0,
      },
    ];

    final tabLabels = [
      'All',
      'Order Placed',
      'Dispatched',
      'Delivered',
      'Installed',
    ];
    // For static demo, just filter by status
    int selectedTab = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        List<Map<String, dynamic>> filteredOrders = selectedTab == 0
            ? orders
            : orders.where((o) => o['status'] == tabLabels[selectedTab]).toList();
        return Column(
          children: [
            // Tab Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(tabLabels.length, (index) {
                  final isSelected = selectedTab == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: commonContainerDecoration(
                          color: isSelected ? AppColors.primaryColor : const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          tabLabels[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: filteredOrders.isEmpty
                  ? Center(child: Text('No orders found', style: AppTextStyle.h5))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      itemCount: filteredOrders.length,
                      separatorBuilder: (_, __) => 8.height,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        final statusColor = getKavachOrderStatusColor(order['status'] as String);
                        return Container(
                          decoration: commonContainerDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            shadow: true,
                            borderColor: AppColors.borderColor,
                      
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                 Text(
                                      'Order ID: ${order['orderId']}',
                                      style: AppTextStyle.h4PrimaryColor.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
                                    ).expand(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: commonContainerDecoration(
                                      color: statusColor.withOpacity(0.09),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      order['status'] as String,
                                      style: TextStyle(
                                        color: statusColor,
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
                                  Text(
                                      order['product'] as String,
                                      style: AppTextStyle.textGreyColor14w300,
                                    ).expand(),
                                  Text(
                                    '₹${(order['amount'] as num).toStringAsFixed(0)}',
                                    style: AppTextStyle.h4,
                                  ),
                                ],
                              ),
                              8.height,
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {}, // TODO: Add details navigation
                                    child: Text('View Details', style: AppTextStyle.primaryColor16w400),
                                  ),
                                  15.width,
                                  Text(
                                      'Purchased on ${formatDateTimeKavach(order['date'] as String)}',
                                      style: AppTextStyle.textGreyColor14w300,
                                      maxLines: 1,
                                    ).expand()
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

