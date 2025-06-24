import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

import '../../../utils/app_image.dart';

class MyDocumentScreen extends StatelessWidget {
  const MyDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text("My Documents", style: AppTextStyle.textBlackColor18w500),
        toolbarHeight: 50,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          spacing: 15,
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
      itemCount: 3, shrinkWrap: true,physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
      return Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric( vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.white,
          ),
          child:ListTile(
            leading:  SvgPicture.asset(AppImage.svg.myDocumentsIcon2, height: 40, width: 40),
            title:   Text(
              "GSTIN",
              style: AppTextStyle.h5,
            ),
            subtitle: Text("Uploaded on 22 Apr 2025, 3:45 PM",style: AppTextStyle.textGreyDetailColor12w400,),
          ));
    },);
  }
}
