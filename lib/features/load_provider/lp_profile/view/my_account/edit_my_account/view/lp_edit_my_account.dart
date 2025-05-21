import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';

import '../../../../../../../utils/app_application_bar.dart';
import '../../../../../../../utils/app_button.dart';
import '../../../../../../../utils/app_text_style.dart';
import '../../../../../../../utils/extra_utils.dart';

class LpEditMyAccount extends StatelessWidget {
  const LpEditMyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
    appBar:   CommonAppBar(
        backgroundColor: Colors.transparent,
        title: Text(context.appText.myAccount,style:AppTextStyle.textBlackColor18w500,),
        toolbarHeight: 50.h,

      ),
      body: Padding(
        padding:   EdgeInsets.symmetric(horizontal: 18.0.w,vertical: 18.h),
        child: Column(

         crossAxisAlignment: CrossAxisAlignment.start, spacing: 10.h,
          children: [
            headingText(text: context.appText.personalDetails),
        15.height,
        AppTextField(decoration: commonInputDecoration(fillColor: Colors.white),
          labelText: context.appText.name,
        ),
            AppTextField(decoration: commonInputDecoration(fillColor: Colors.white),
          labelText: context.appText.mobileNumber,
        ), 10.height,
            headingText(text: context.appText.companyDetails),
            15.height,
            AppTextField(decoration: commonInputDecoration(fillColor: Colors.white),
              labelText: context.appText.mobileNumber,
            ),
            AppTextField(decoration: commonInputDecoration(fillColor: Colors.white),
              labelText: context.appText.gst,
            ),
            Expanded(child: SizedBox.shrink()),
            AppButton(
              title:context.appText.updateChanges,

              onPressed:() {
                context.pop();
              } ,),
          ],
        ),
      ),
    );
  }
}
