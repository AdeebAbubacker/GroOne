import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

import '../../../../../../utils/app_application_bar.dart';
import '../../../../../../utils/app_text_style.dart';

class LpSupport extends StatefulWidget {
  const LpSupport({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  State<LpSupport> createState() => _LpSupportState();
}

class _LpSupportState extends State<LpSupport> {
  List tabList = ["All", "In Transit", "Completed", "Pending"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar:   CommonAppBar(
      actions: [Icon(Icons.support_agent_rounded), 10.width],
      isLeading: widget.showBackButton ? true : false,
      backgroundColor: Colors.transparent,
      title: Text(context.appText.support,style:AppTextStyle.textBlackColor18w500,),
      toolbarHeight: 50.h,

    ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 18.h),

        child: Column(
          spacing: 20.h,
          children: [
            AppTextField(
              decoration: commonInputDecoration(
                fillColor: AppColors.white,
                prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
                hintText: "Search",
              ),
            ),

            SizedBox(
              height: 30.h,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: tabList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: tabWidget(
                      text: tabList[index],
                      onTap: () {
                        selectedIndex = index;
                        setState(() {});
                      },
                      selected: selectedIndex == index ? true : false,
                    ),
                  );
                },
              ),
            ),


            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
              decoration: BoxDecoration(
                color: AppColors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What’s the resolution time for disputes?",style:AppTextStyle.textBlackDetailColor15w500 ,),
                  dividerWidget(),
                  Text("Most issues are resolved within 24–48 hours. You’ll be notified via app and email on progress.",style:AppTextStyle.textGreyDetailColor12w400.copyWith(fontWeight: FontWeight.w500) ,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
