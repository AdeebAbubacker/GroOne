import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/upload_file_and_image_bottom_sheet.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/extra_utils.dart';

class LpProfileScreen extends StatefulWidget {
  const LpProfileScreen({super.key});

  @override
  State<LpProfileScreen> createState() => _LpProfileScreenState();
}

class _LpProfileScreenState extends State<LpProfileScreen> {
  final double profileSize = 130;
  dynamic pickImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          context.appText.profile,
          style: AppTextStyle.textBlackColor18w500,
        ),
        toolbarHeight: 50.h,
      ),

      body: SingleChildScrollView(
        child: Column(
          spacing: 15.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            15.width,
            buildUploadProfilePictureWidget(context: context),
            Text("Sachin Mehta", style: AppTextStyle.blackColor15w500),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primaryColor,
              ),
              child: Text(
                "${context.appText.blueMembershipId} : qwesd123",
                style: AppTextStyle.whiteColor14w400,
              ),
            ),
            profileOptionWidget()
          ],
        ),
      ),
    );
  }
profileOptionWidget(){
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          profileWidget(
            imageString: AppImage.svg.user,
            text: context.appText.myAccount,
            onTap: () {
              context.push(AppRouteName.lpMyAccount);
            },
          ),
          dividerWidget(),
          profileWidget(
            imageString: AppImage.svg.master,
            text: "Master",
            onTap: () {
              context.push(AppRouteName.lpMyAccount);
            },
          ),
          dividerWidget(),
          profileWidget(
            imageString: AppImage.svg.myDocuments,
            text: "My Documents",
            onTap: () {
              context.push(AppRouteName.lpMyAccount);
            },
          ),
          dividerWidget(),
          profileWidget(
            imageString: AppImage.svg.transaction,
            text: context.appText.transactions,
            onTap: () {
              context.push(AppRouteName.lpTransaction);
            },
          ),
          dividerWidget(),
          profileWidget(
            imageString: AppImage.svg.settings,
            text: context.appText.settings,
            onTap: () {
              context.push(AppRouteName.lpSetting);
            },
          ),
          dividerWidget(),
          profileWidget(
            imageString: AppImage.svg.support,
            text: context.appText.support,
            onTap: () {
              context.push(AppRouteName.lpSupport);
            },
          ),
          dividerWidget(),
          profileWidget(
            imageString: AppImage.svg.logOut,
            text: context.appText.logOut,
            onTap: () {},
            showArrow: false,
          ),
        ],
      ),
    );
}
  dividerWidget() {
    return Divider(
      color: AppColors.dividerColor,
      thickness: 0.5,
      indent: 20,
      endIndent: 20,
    );
  }

  Widget buildUploadProfilePictureWidget({
    String? profileImage,
    required BuildContext context,
  }) {
    return SizedBox(
      height: profileSize,
      width: profileSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (pickImage != null)
            ClipOval(
              child: Image.file(
                pickImage!,
                fit: BoxFit.cover,
                width: profileSize,
                height: profileSize,
              ),
            )
          else
            ClipOval(
              child: commonCacheNetworkImage(
                path: profileImage ?? "",
                height: profileSize,
                width: profileSize,
                errorImage: AppImage.png.userProfileError,
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                commonBottomSheet(
                  context: context,
                  barrierDismissible: true,
                  screen: const UploadFileAndImageBottomSheet(),
                ).then((value) {
                  if (value != null && value["path"] != null) {
                    File file = File(value["path"]);
                    pickImage = file;
                    setState(() {});
                    // if (file.existsSync()) {
                    //   //viewModel.setPickImageUIState(file);
                    //   debugPrint("File exists: $file");
                    // } else {
                    //   debugPrint("File does not exist: ${file.path}");
                    // //  viewModel.setPickImageUIState(null);
                    // }
                  } else {
                    // viewModel.setPickImageUIState(null);
                  }
                });
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  AppIcons.svg.camera,
                  colorFilter: AppColors.svg(Colors.white),
                ).paddingAll(7),
              ).paddingBottom(15),
            ),
          ),
        ],
      ),
    );
  }
}
