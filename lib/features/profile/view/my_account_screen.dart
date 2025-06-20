import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/profile/view/edit_my_account.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class LpMyAccount extends StatefulWidget {
  final ProfileDetailsData profileData;

  const LpMyAccount({super.key, required this.profileData});

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

  void initFunction() => frameCallback(() async {});

  void disposeFunction() => frameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title:  context.appText.myAccount),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(commonSafeAreaPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20.h,
          children: [
            headingText(text: context.appText.personalDetails),
            detailWidget(
              text1: context.appText.name,
              text2: widget.profileData.customer!.customerName,
            ),
            detailWidget(
              text1: context.appText.mobileNumber,
              text2: widget.profileData.customer!.mobileNumber,
            ),
            detailWidget(
              text1: context.appText.email,
              text2: widget.profileData.customer?.emailId ?? '--',
            ),
            dividerWidget(),
            headingText(text: context.appText.accountDetails),
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
                  widget.profileData.customer!.isKyc == 3
                      ? "Verified"
                      : "Un-Verified",
            ),
            dividerWidget(),
            headingText(text: 'Bank Details'),
            detailWidget(
              text1: 'Account no.',
              text2: widget.profileData.details!.bankAccount??'--',
            ),
            detailWidget(
              text1: 'Bank Name',
              text2: widget.profileData.details!.bankName??'--',
            ),
            detailWidget(
              text1: 'Branch Name',
              text2: widget.profileData.details!.branchName??'--',
            ),
            detailWidget(
              text1: 'IFSC code',
              text2: widget.profileData.details!.ifscCode??'--',
            ),
            dividerWidget(),
            headingText(text: context.appText.companyDetails),
            detailWidget(
              text1: context.appText.companyName,
              text2: widget.profileData.details!.companyName,
            ),
            detailWidget(
              text1: context.appText.gst,
              text2: widget.profileData.details!.gstin ?? "--",
            ),
            20.height,
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
