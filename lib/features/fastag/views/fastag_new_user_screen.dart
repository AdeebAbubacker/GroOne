import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import '../../kavach/view/kavach_support_screen.dart' show KavachSupportScreen;
import 'buy_new_fastag_screen.dart';

class FastagNewUserScreen extends StatelessWidget {
  const FastagNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar:  AppButton(
        title: context.appText.buyFastag,
        onPressed: () {
          Navigator.pushReplacement(context,commonRoute(BuyNewFastagScreen()));
        },
      ).bottomNavigationPadding(),
      appBar: CommonAppBar(
        title: Text(context.appText.fastag),
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(context, commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildFastagProductImageWidget(context),
              20.height,
              buildFastagBenefitsDetailsWidget(context),
              buildGroBannerImageWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGroBannerImageWidget(){
    return Image.asset(AppImage.png.groBanner);
  }

  Widget buildFastagProductImageWidget(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.16,
      child: Image.asset(
        AppImage.png.fastagBenefitsBanner,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildFastagBenefitsDetailsWidget(BuildContext context) {
    Widget benefitItem({
      required String title,
      required String subTitle,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyle.h5),
          5.height,
          Text(subTitle, style: AppTextStyle.body3),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.fastagBenefitsTitle, style: AppTextStyle.body1),
        20.height,

        benefitItem(
          title: context.appText.fastagBenefitTrustedTitle,
          subTitle: context.appText.fastagBenefitTrustedDesc,
        ),
        20.height,

        benefitItem(
          title: context.appText.fastagBenefitInstantTitle,
          subTitle: context.appText.fastagBenefitInstantDesc,
        ),
        20.height,

        benefitItem(
          title: context.appText.fastagBenefitSupportTitle,
          subTitle: context.appText.fastagBenefitSupportDesc,
        ),
        20.height,

        benefitItem(
          title: context.appText.fastagBenefitSecureTitle,
          subTitle: context.appText.fastagBenefitSecureDesc,
        ),
        20.height,

        benefitItem(
          title: context.appText.fastagBenefitHistoryTitle,
          subTitle: context.appText.fastagBenefitHistoryDesc,
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }
}