import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class LoadSummaryScreen extends StatelessWidget {
  const LoadSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(
        backgroundColor: AppColors.white,
        title: Text(
          "Post Load Summary",
          style: AppTextStyle.textBlackColor18w500,
        ),
        toolbarHeight: 50.h,
        actions: [
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryColor,
                  size: 15,
                ),
                5.width,
                Text(
                  context.appText.edit,
                  style: AppTextStyle.primaryColor12w400.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                10.width,
              ],
            ),
          ).paddingOnly(right: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 18.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.h,
            children: [detailWidget(), notesWidget(),
              AppButton(
              title: "Continue",
              onPressed: () {


              },
            ),
              // Need Support Next
              InkWell(
                onTap: (){
                  showCustomerCareBottomSheet(context);
                },
                child: Center(
                  child: Text("Need Our Customer Support Help?",style: AppTextStyle.primaryColor14w400UnderLine),
                ),
              ),],
          ),
        ),
      ),
    );
  }

  notesWidget() {
    return Column(
      spacing: 10.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notes / Instruction",
          style: AppTextStyle.textBlackDetailColor14w400,
        ),
        AppTextField(
          hintText: "Write Notes...",
          labelTextStyle: AppTextStyle.textBlackColor16w400,
          maxLines: 3,
        ),

      ],
    );
  }

  detailWidget() {
    return Column(
      spacing: 13.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        loadSummaryWidget(
          title: "Address Details",
          heading1: "Sender Address",
          heading2: "Sender Address",

          subheading1: "Warehouse 4, Sector 12, Chennai – 411026",
          subheading2: "Warehouse 4, Sector 12, Chennai – 411026",
        ),
        loadSummaryWidget(
          title: "Vehicle Details",
          heading1: "Sender Address",
          heading2: "Sender Address",

          subheading1: "Warehouse 4, Sector 12, Chennai – 411026",
          subheading2: "Warehouse 4, Sector 12, Chennai – 411026",
        ),
        loadSummaryWidget(
          title: "Package Details",
          heading1: "Sender Address",
          heading2: "Sender Address",

          subheading1: "Warehouse 4, Sector 12, Chennai – 411026",
          subheading2: "Warehouse 4, Sector 12, Chennai – 411026",
        ),
        loadSummaryWidget(
          title: "Price Details",
          heading1: "Sender Address",
          heading2: "",
          showHeading2: false,
          subheading1: "₹75,000 - ₹80, 000",
          subheading2: "",
        ),
      ],
    );
  }

  Widget loadSummaryWidget({
    required String title,
    required String heading1,
    required String heading2,
    bool showHeading2 = true,
    required String subheading1,
    required String subheading2,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.textBlackDetailColor16w500),
        15.height,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading1, style: AppTextStyle.primaryColor12w400),
                  5.height,
                  Text(
                    subheading1,
                    style: AppTextStyle.textGreyDetailColor12w400,
                  ),
                ],
              ),
            ),
            10.width,
            showHeading2
                ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sender Address",
                        style: AppTextStyle.primaryColor12w400,
                      ),
                      5.height,
                      Text(
                        "Warehouse 4, Sector 12, Chennai – 411026",
                        style: AppTextStyle.textGreyDetailColor12w400,
                      ),
                    ],
                  ),
                )
                : Expanded(child: SizedBox.shrink()),
          ],
        ),
        5.height,
        commonDivider(
          thickness: 1,
          dividerColor: AppColors.textGreyDetailColor,
        ),
      ],
    );
  }
}
