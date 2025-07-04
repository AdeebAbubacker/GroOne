import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/fast_tag/fast_tag_screen.dart';
// import 'package:gro_one_app/features/gps/view/gps_order_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_orders_list_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../utils/app_route.dart';
import '../en-dhan_fuel/view/endhan_new_user_and_card_screen.dart';

class OurValueAddedServicesWidget extends StatefulWidget {
  const OurValueAddedServicesWidget({super.key});

  @override
  State<OurValueAddedServicesWidget> createState() =>
      _OurValueAddedServicesWidgetState();
}

class _OurValueAddedServicesWidgetState
    extends State<OurValueAddedServicesWidget> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _scrollProgress =
            maxScroll == 0 ? 0 : (currentScroll / maxScroll).clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonContainerDecoration(
        borderRadius: BorderRadius.circular(0),
        shadow: true,
      ),
      child: Column(
        children: [
          20.height,

          // Heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("Value Added Services", style: AppTextStyle.body1),
              ),
              // Icon(Icons.arrow_forward_outlined),
            ],
          ).paddingSymmetric(horizontal: commonSafeAreaPadding),
          20.height,

          Column(
            children: [
              SizedBox(
                height: 101,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    15.width,

                    _buildServicesWidget(
                      title: context.appText.gps,
                      imageString: AppImage.png.gps,
                      onClick: () {
                        context.push(AppRouteName.gps);
                      },
                    ),
                    15.width,

                    _buildServicesWidget(
                      title: "Fuel Card",
                      imageString: AppImage.png.enDhan,
                      onClick: () {
                        //context.push(AppRouteName.enDhanCard);
                        Navigator.push(
                          context,
                          commonRoute(EndhanNewUserAndCardScreen()),
                        );
                      },
                    ),
                    15.width,

                    _buildServicesWidget(
                      title: "Fast tag",
                      imageString: AppImage.png.buyFastTag,
                      onClick: () {
                        //context.push(AppRouteName.buyFastag);
                        Navigator.push(context, commonRoute(FastTagScreen()));
                      },
                    ),
                    15.width,

                    _buildServicesWidget(
                      title: "Tank Lock",
                      imageString: AppImage.png.kavach,
                      onClick: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => KavachOrdersListScreen(),
                            settings: RouteSettings(
                              name: 'KavachOrderListScreen',
                            ),
                          ),
                        );
                      },
                    ),
                    15.width,

                    //
                    // _buildServicesWidget(
                    //   title: context.appText.instantLoan,
                    //   imageString: AppImage.png.insuranceLoan,
                    //   onClick: () {
                    //     context.push(AppRouteName.instantLoan);
                    //   },
                    // ),
                    // 15.width,
                    //
                    // _buildServicesWidget(
                    //   title: context.appText.insurance,
                    //   imageString: AppImage.png.insurance,
                    //   onClick: () {
                    //     context.push(AppRouteName.insurance);
                    //   },
                    // ),
                    15.width,
                  ],
                ),
              ),

              20.height,
              Container(
                width: 100,
                height: 4,
                decoration: commonContainerDecoration(
                  color: AppColors.borderColor,
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: _scrollProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          // Replace with your theme color
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          20.height,
        ],
      ),
    );
  }

  Widget _buildServicesWidget({
    required String title,
    required String imageString,
    required GestureTapCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: 100,
        height: 90,
        decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageString, width: 30),
            10.height,

            Text(title, textAlign: TextAlign.center, style: AppTextStyle.h6),
          ],
        ),
      ),
    );
  }
}
