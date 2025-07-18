import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/vp_creation_form_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_onboarding_appbar.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/extra_utils.dart';
import '../bloc/role_bloc.dart';

class ChooseRoleScreen extends StatelessWidget {
  final String userId;
  final String mobileNumber;

  const ChooseRoleScreen({super.key,required this.userId,required this.mobileNumber, });

  @override
  Widget build(BuildContext context) {
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
                chooseRoleTile(
                  isSelected: state.index == 0 ? true : false,
                  text1: "Load Provider",
                  text2: context.appText.lpText,
                  onTap: () {
                    context.read<RoleBloc>().add(const ChangeIndex(index: 0));
                  },
                  imageString: AppImage.png.lp,
                ),
                chooseRoleTile(
                  isSelected: state.index == 1 ? true : false,
                  text1: "Truck Provider",
                  text2: context.appText.vpText,
                  onTap: () {
                    context.read<RoleBloc>().add(const ChangeIndex(index: 1));
                  },
                  imageString: AppImage.png.vp,
                ),
                chooseRoleTile(
                  isSelected: state.index == 2 ? true : false,
                  text1: "Both Load & Truck Provider",
                  text2: context.appText.vpLp,
                  onTap: () {
                    context.read<RoleBloc>().add(const ChangeIndex(index: 2));
                  },
                  imageString: AppImage.png.lpVp,
                ),
                chooseRoleTile(
                  isSelected: state.index == 3 ? true : false,
                  text1: "Require Fleet Products",
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
                    // CustomLog.debug(this, "Role Id : ${state.index + 1}");
                    // context.push(AppRouteName.login, extra: "${state.index + 1}");

                    final roleId = state.index + 1;

                  switch (roleId) {
                    case 1: // Load Provider
                    context.push(
                          AppRouteName.lpCreateAccount,
                          extra: {
                            "userId": userId,
                            "mobileNumber": mobileNumber,
                            "roleId": roleId.toString(),
                          },
                    );
                      break;
                    case 2:
                    Navigator.push(context, commonRoute(VpCreationFormScreen(id: userId ?? '', mobileNumber:mobileNumber, roleId: roleId), isForward: true));
                    break;
                    case 3: // Both
                      Navigator.push(context, commonRoute(VpCreationFormScreen(id: userId ?? '', mobileNumber:mobileNumber, roleId: roleId), isForward: true));
                      break;
                    case 4: // Fleet Products
                      Navigator.push(context, commonRoute(VpCreationFormScreen(id: userId ?? '', mobileNumber:mobileNumber, roleId: roleId), isForward: true));
                      break;

                }
                  },
                ),
                 50.height,

                Text("Powered by Hinduja Group", style: AppTextStyle.bodyPrimaryColor).center()



                // Text("Powered by Hinduja Group", style: AppTextStyle.bodyPrimaryColor).center(),
               // Center(child: Image.asset(AppImage.png.hinduja)),
              ],
            ),
          ).withScroll();
        },
      ),
    );
  }

  Widget chooseRoleTile({
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
            color: Colors.white,
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
              subtitle:
                  text2.isNotEmpty
                      ? Text(text2, style: AppTextStyle.body3GreyColor)
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
              color: Colors.white,
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
