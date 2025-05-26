import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/choose_language_screen/view/choose_language_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/vp_creation_form_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/extra_utils.dart';
import '../bloc/role_bloc.dart';

class ChooseRoleScreen extends StatelessWidget {
  const ChooseRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,

        actions: [
          translateWiget(onTap: (){

            Navigator.push(context, commonRoute(ChooseLanguageScreen(isCloseButton: true,)));

          }),    20.width,
          customerSupportWidget(onTap: (){

            showCustomerCareBottomSheet(context);

          }),
          20.width,
          Image.asset(AppImage.png.appIcon, width: 74.25.w, height: 33.h),
          30.width,
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<RoleBloc, RoleState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0.h, horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                spacing: 10.h,
                children: [
                  30.height,

                  Text(
                    context.appText.chooseRoleText,
                    style: AppTextStyle.textBlackColors20w400,
                  ),
                  chooseRoleTile(
                    isSelected: state.index == 0 ? true : false,
                    text1: context.appText.lpTextHeading,
                    text2: context.appText.lpText,
                    onTap: () {
                      context.read<RoleBloc>().add(const ChangeIndex(index: 0));
                    },
                    imageString: AppImage.png.lp,
                  ),
                  chooseRoleTile(
                    isSelected: state.index == 1 ? true : false,
                    text1: context.appText.vpTextHeading,
                    text2: context.appText.vpText,
                    onTap: () {
                      context.read<RoleBloc>().add(const ChangeIndex(index: 1));
                    },
                    imageString: AppImage.png.vp,
                  ),
                  chooseRoleTile(
                    isSelected: state.index == 2 ? true : false,
                    text1: context.appText.vpLpHeading,
                    text2: context.appText.vpLp,
                    onTap: () {
                      context.read<RoleBloc>().add(const ChangeIndex(index: 2));
                    },
                    imageString: AppImage.png.lpVp,
                  ),
                  chooseRoleTile(
                    isSelected: state.index == 3 ? true : false,
                    text1: context.appText.fleetHeading,
                    text2: context.appText.fleet,
                    onTap: () {
                      context.read<RoleBloc>().add(const ChangeIndex(index: 3));
                    },
                    imageString: AppImage.png.fleet,
                  ),
                  5.height,
                  AppButton(
                    title: context.appText.next,

                    onPressed: () {


                        context.push( AppRouteName.login,
                        extra:"${state.index + 1}");

                    },
                  ),

                  25.height,

                  Center(child: Image.asset(AppImage.png.hinduja)),
                ],
              ),
            );
          },
        ),
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
          margin: EdgeInsets.only(top: 28.h),
          // height: 70.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 0.8,
              color:
                  isSelected ? AppColors.primaryColor : AppColors.disableColor,
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
                    width: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 24.h,
                width: 24.w,
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
                      ? Text(text2, style: AppTextStyle.textGreyColor14w300)
                      : null,
              title: Row(
                children: [
                  60.width,
                  Expanded(
                    child: Text(
                      text1,
                      style: AppTextStyle.textBlackColor18w500,
                    ),
                  ),
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
                color:
                    isSelected
                        ? AppColors.primaryColor
                        : AppColors.disableColor,
              ),
            ),
            height: 55.h,
            width: 55.w,
            child: Image.asset(imageString),
          ),
        ),
      ],
    );
  }
}
