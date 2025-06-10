import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class OurValueAddedServicesWidget extends StatefulWidget {
  const OurValueAddedServicesWidget({super.key});

  @override
  State<OurValueAddedServicesWidget> createState() => _OurValueAddedServicesWidgetState();
}

class _OurValueAddedServicesWidgetState extends State<OurValueAddedServicesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          20.height,


          // Heading
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(context.appText.ourValueAddedServices, style: AppTextStyle.body1),
              ),
              Icon(Icons.arrow_forward_outlined),
            ],
          ).paddingSymmetric(horizontal: commonSafeAreaPadding),
          20.height,
      
          Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    0.width,

                    _buildServicesWidget(
                      title: context.appText.buyFastTag,
                      imageString: AppImage.png.buyFastTag,
                      onClick: () {
                        context.push(AppRouteName.buyFastag);
                      },
                    ),

                    _buildServicesWidget(
                      title: context.appText.enDan,
                      imageString: AppImage.png.enDhan,
                      onClick: () {
                        context.push(AppRouteName.enDhanCard);
                      },
                    ),

                    _buildServicesWidget(
                      title: context.appText.gps,
                      imageString: AppImage.png.gps,
                      onClick: () {
                        context.push(AppRouteName.gps);
                      },
                    ),

                    _buildServicesWidget(
                      title: context.appText.instantLoan,
                      imageString: AppImage.png.insuranceLoan,
                      onClick: () {
                        context.push(AppRouteName.instantLoan);
                      },
                    ),

                    _buildServicesWidget(
                      title: context.appText.insurance,
                      imageString: AppImage.png.insurance,
                      onClick: () {
                        context.push(AppRouteName.insurance);
                      },
                    ),

                    _buildServicesWidget(
                      title: context.appText.kavach,
                      imageString: AppImage.png.kavach,
                      onClick: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => KavachOrdersListScreen(), settings: RouteSettings(name: 'KavachOrderListScreen')),
                        );
                      },
                    ),
                    10.width,

                  ],
                ),
              ).expand(),
            ],
          ),
          20.height,
        ],
      ),
    );
  }

  Widget _buildServicesWidget({required String title, required String imageString, required GestureTapCallback onClick}) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: 110,
        height: 100,
        decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageString, width: 30),
            10.height,
            
            Text(title,textAlign: TextAlign.center, style: AppTextStyle.body3),
          ],
        ),
      ),
    );
  }

}
