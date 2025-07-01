import 'package:flutter/material.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class LpMyAccount extends StatelessWidget {
  final ProfileDetailsData profileData;
  const LpMyAccount({super.key, required this.profileData});

  String checkUserDetails(dynamic value){
    if(value != null && value.toString().isNotEmpty){
      return value.toString();
    }else{
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.myAccount),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(commonSafeAreaPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              headingText(text: context.appText.personalDetails),

              if (profileData.customer != null) ...[

                buildDetailWidget(
                  text1: context.appText.name,
                  text2: checkUserDetails(profileData.customer!.customerName),
                ),

                buildDetailWidget(
                  text1: context.appText.mobileNumber,
                  text2: checkUserDetails(profileData.customer!.mobileNumber),
                ),

                buildDetailWidget(
                  text1: context.appText.email,
                  text2: checkUserDetails(profileData.customer!.emailId)
                ),
                dividerWidget(),

                headingText(text: context.appText.accountDetails),

                buildDetailWidget(
                  text1: context.appText.blueMembershipId,
                  text2: checkUserDetails(profileData.customer!.blueId)
                ),

                buildDetailWidget(
                  text1: context.appText.accountType,
                  text2: checkUserDetails(profileData.customer!.accountType),
                ),

                buildDetailWidget(
                  text1: context.appText.registrationData,
                  text2: profileData.customer!.createdAt != null ? DateTimeHelper.getFormattedDate(profileData.customer!.createdAt!) : "--",
                ),

                buildDetailWidget(
                  text1: context.appText.kycStatus,
                  text2: profileData.customer!.isKyc == 3 ? "Verified" : "Un-Verified",
                ),

                dividerWidget(),
              ],


              // Bank Details
              if (profileData.details != null) ...[
                headingText(text: 'Bank Details'),

                buildDetailWidget(
                  text1: 'Account no.',
                  text2: checkUserDetails(profileData.details!.bankAccount),
                ),
                buildDetailWidget(
                  text1: 'Bank Name',
                  text2: checkUserDetails(profileData.details!.bankName),
                ),
                buildDetailWidget(
                  text1: 'Branch Name',
                  text2: checkUserDetails(profileData.details!.branchName),
                ),
                buildDetailWidget(
                  text1: 'IFSC code',
                  text2: checkUserDetails(profileData.details!.ifscCode),
                ),
                dividerWidget(),

                // Company Detail
                headingText(text: context.appText.companyDetails),
                buildDetailWidget(
                  text1: context.appText.companyName,
                  text2: checkUserDetails(profileData.details!.companyName),
                ),

                if (profileData.details!.companyTypeId != 2)
                  buildDetailWidget(
                    text1: context.appText.gst,
                    text2: checkUserDetails(profileData.details!.gstin),
                  ),
              ],

              20.height,
            ],
          ),
        ),
      ),
    );
  }

 Widget buildDetailWidget({required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: AppTextStyle.textGreyDetailColor14w400),
        Text(text2, style: AppTextStyle.textGreyDetailColor14w400),
      ],
    );
  }


}
