import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import 'endhan_kyc_screen.dart';


class NewUserEndhanScreen extends StatelessWidget {
  const NewUserEndhanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.fuelCard,
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {},
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          10.width,
        ],),
      body: SafeArea(child: enDhanBenifitsWidget(context)),
    );
  }

  Widget enDhanBenifitsWidget(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildenDhanProductImageWidget(context),
          6.height,
          buildenDhanBenefitsDetailsWidget(context),
          buildGroBannerImageWidget(),
      
          AppButton(
              title: "Buy New Fuel Card",
              onPressed: (){
                Navigator.push(context,commonRoute(EndhanKycScreen()));
              }
          ).paddingOnly(left: 10.0, right: 10.0, bottom: 8.0)
        ],
      ),
    );
  }

  Widget buildenDhanProductImageWidget(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.2,
      color: AppColors.lightPrimaryColor,
     child: Image.asset(AppImage.png.endhanCard, width: 150),
    );
  }

  Widget buildenDhanBenefitsDetailsWidget(BuildContext context){
    Widget innerUIWidget({required String icon,required String title, required String subTitle}){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            decoration: commonContainerDecoration(
                color: AppColors.lightPrimaryColor,
                borderRadius: BorderRadius.circular(100),
                borderColor: AppColors.primaryColor
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
              Text(subTitle, style: AppTextStyle.body3)
            ],
          ).expand()
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.benefitsOfFuelCard, style: AppTextStyle.body1),
        20.height,
        innerUIWidget(icon: AppIcons.png.cardPayment, title: context.appText.benefitsOfFuelCardHeading1, subTitle: context.appText.benefitsOfFuelCardSubHeading1),
        20.height,
        innerUIWidget(icon: AppIcons.png.tracking, title: context.appText.benefitsOfFuelCardHeading2, subTitle: context.appText.benefitsOfFuelCardSubHeading2),
        20.height,
        innerUIWidget(icon: AppIcons.png.reconcilation, title: context.appText.benefitsOfFuelCardHeading3, subTitle: context.appText.benefitsOfFuelCardSubHeading3),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }
  Widget buildGroBannerImageWidget(){
    return Image.asset(AppImage.png.groBanner);
  }
}
