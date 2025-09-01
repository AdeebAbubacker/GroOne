import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../bloc/role_bloc.dart';

class ChooseRoleScreen extends StatelessWidget {
  final String userId;
  final String mobileNumber;
  const ChooseRoleScreen({super.key,required this.userId,required this.mobileNumber, });

  @override
  Widget build(BuildContext context) {

    final analytics = locator<AnalyticsService>();

    return Scaffold(
      appBar: CommonOnboardingAppbar(),
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(commonSafeAreaPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                20.height,
                Text(
                  context.appText.chooseRoleText,
                  style: AppTextStyle.textBlackColors20w400,
                ),
                buildRoleSelectionTileWidget(
                  isSelected: state.index == 0 ? true : false,
                  text1: context.appText.loadProvider,
                  text2: context.appText.lpText,
                  onTap: () {
                    context.read<RoleBloc>().add(const ChangeIndex(index: 0));
                  },
                  imageString: AppImage.png.lp,
                ),
                buildRoleSelectionTileWidget(
                  isSelected: state.index == 1 ? true : false,
                  text1: context.appText.truckProvider,
                  text2: context.appText.vpText,
                  onTap: () {
                    context.read<RoleBloc>().add(const ChangeIndex(index: 1));
                  },
                  imageString: AppImage.png.vp,
                ),
                buildRoleSelectionTileWidget(
                  isSelected: state.index == 2 ? true : false,
                  text1: context.appText.vpLpHeading,
                  text2: context.appText.vpLp,
                  onTap: () {
                    context.read<RoleBloc>().add(const ChangeIndex(index: 2));
                  },
                  imageString: AppImage.png.lpVp,
                ),
                buildRoleSelectionTileWidget(
                  isSelected: state.index == 3 ? true : false,
                  text1:  context.appText.fleetHeading,
                  text2: context.appText.fleet,
                  onTap: () {
                    context.read<RoleBloc>().add(const ChangeIndex(index: 3));
                  },
                  imageString: AppImage.png.fleet,
                ),
                30.height,

                AppButton(
                  title: context.appText.next,
                  onPressed: () {

                    final roleId = state.index + 1;
                    final extra = {
                      "userId": userId,
                      "mobileNumber": mobileNumber,
                      "roleId": roleId.toString(),
                    };

                    switch (roleId) {
                      case 1: // Load Provider
                       context.push(AppRouteName.lpCreateAccount, extra: extra);
                       break;
                      case 2:
                        context.push(AppRouteName.vpCreateAccount, extra: extra);
                        break;
                      case 3: // Both
                        context.push(AppRouteName.vpCreateAccount, extra: extra);
                        break;
                      case 4: // Fleet Products
                        context.push(AppRouteName.lpCreateAccount, extra: extra);
                          break;
                    }
                    analytics.logScreenView("RoleSelectionScreen");
                    analytics.logEvent(AnalyticEventName.ONBOARD_ROLE_SELECTED, extra);
                  },
                ),
                 50.height,

                Text(context.appText.poweredByHindujagroup, style: AppTextStyle.bodyPrimaryColor).center()

              ],
            ),
          ).withScroll();
        },
      ),
    );
  }


  Widget buildRoleSelectionTileWidget({
    required String text1,
    required bool isSelected,
    required String text2,
    required GestureTapCallback onTap,
    required String imageString,
  }) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 28),
          // height: 70.h,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1.5,
              color: isSelected ? AppColors.primaryColor : AppColors.disableColor,
            ),
          ),
          child: Center(
            child: ListTile(
              onTap: onTap,
              trailing: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.primaryColor
                            : AppColors.disableColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 24,
                width: 24,
                padding: EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primaryColor
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
             subtitle: text2.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.height,
                    Text(text2, style: AppTextStyle.body3GreyColor),
                  ],
                )
              : null,
              title: Row(
                children: [
                  60.width,
                  Expanded(child: Text(text1, style: AppTextStyle.h5)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 15,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 1.5,
                color: isSelected ? AppColors.primaryColor : AppColors.disableColor,
              ),
            ),
            height: 55,
            width: 55,
            child: Image.asset(imageString),
          ),
        ),
     
      ],
    );
  }
}
