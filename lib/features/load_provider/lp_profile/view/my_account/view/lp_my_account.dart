import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/view/my_account/edit_my_account/view/lp_edit_my_account.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../../../../utils/app_application_bar.dart';
import '../../../../../../utils/app_text_style.dart';
import '../../../../../../utils/extra_utils.dart';
import '../../../../lp_home/model/profile_detail_response_model.dart';

class LpMyAccount extends StatefulWidget {
  const LpMyAccount({super.key, required this.profileData});

  final AllProfileDetails profileData;

  @override
  State<LpMyAccount> createState() => _LpMyAccountState();
}

class _LpMyAccountState extends State<LpMyAccount> {


  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();
    super.dispose();
  }

  void initFunction() => addPostFrameCallback(() async {

  });

  void disposeFunction() => addPostFrameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          context.appText.myAccount,
          style: AppTextStyle.textBlackColor18w500,
        ),
        toolbarHeight: 50.h,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                commonRoute(
                  LpEditMyAccount(profileData:widget.profileData),
                  isForward: true,
                ),
              );
            },
            child: Text(
              context.appText.edit,
              style: AppTextStyle.primaryColor18w500UnderLine,
            ),
          ).paddingOnly(right: 10),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 18.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20.h,
          children: [
            headingText(text: context.appText.personalDetails),

            10.width,
            detailWidget(
              text1: context.appText.name,
              text2: widget.profileData.customer!.customerName,
            ),
            detailWidget(
              text1: context.appText.mobileNumber,
              text2: widget.profileData.customer!.mobileNumber,
            ),
            dividerWidget(),

            headingText(text: context.appText.accountDetails),
            10.width,

            detailWidget(
              text1: context.appText.blueMembershipId,
              text2: widget.profileData.customer!.blueId ?? "--",
            ),
            detailWidget(text1: context.appText.accountType, text2: "--"),
            detailWidget(
              text1: context.appText.registrationData,
              text2:
                  widget.profileData.customer!.createdAt != null
                      ? DateTimeHelper.getFormattedDate(
                        widget.profileData.customer!.createdAt!,
                      ).toString()
                      : "--",
            ),
            detailWidget(
              text1: context.appText.kycStatus,
              text2:
                  widget.profileData.customer!.isKyc
                      ? "Verified"
                      : "Un-Verified",
            ),
            dividerWidget(),

            headingText(text: context.appText.companyDetails),
            10.width,

            detailWidget(
              text1: context.appText.companyName,
              text2: widget.profileData.details!.companyName,
            ),
            detailWidget(
              text1: context.appText.gst,
              text2: widget.profileData.details!.gstin ?? "--",
            ),
          ],
        ),
      ),
    );
  }

  detailWidget({required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: AppTextStyle.textGreyDetailColor14w400),
        Text(text2, style: AppTextStyle.textGreyDetailColor14w400),
      ],
    );
  }
}
