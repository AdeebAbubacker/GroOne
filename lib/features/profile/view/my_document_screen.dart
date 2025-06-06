import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

class MyDocumentScreen extends StatelessWidget {
  const MyDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text("My Documents", style: AppTextStyle.textBlackColor18w500),
        toolbarHeight: 50.h,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          spacing: 15.h,
          children: [
            AppTextField(
              decoration: commonInputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: "Search...",
                fillColor: AppColors.white,
              ),
            ),
           Expanded(child: documentInfoWidget())

          ],
        ),
      ),
    );
  }
  documentInfoWidget(){
    return  ListView.builder(
      itemCount: 14,shrinkWrap: true,physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
      return Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric( vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.white,
          ),
          child:ListTile(
            leading: Icon(Icons.picture_as_pdf,color: AppColors.textRed,size: 50,),
            title:   Text(
              "GSTIN",
              style: AppTextStyle.textBlackDetailColor15w500,
            ),
            subtitle: Text("Uploaded on 22 Apr 2025, 3:45 PM"),
          ));
    },);
  }
}
