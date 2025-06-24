import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class BenefitsOfMembershipScreen extends StatelessWidget {
  const BenefitsOfMembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "Benefits of Membership",
          style: AppTextStyle.textBlackColor18w500,
        ),
        toolbarHeight: 50,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        child:ListView.builder(

          itemCount: 13,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
          return membershipInfoWidget();
        },)
      ),
    );
  }

  membershipInfoWidget(){
    return  Container(
      margin: EdgeInsets.only(bottom: 5),
      child: ListTile(
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.primaryColor, width: 2),
          color: AppColors.lightPrimaryColor,
        ),
        child: Icon(Icons.star),
      ),
      title: Text(
        "Lower Commission Rates",
        style: AppTextStyle.black13w700,
      ),
      subtitle: Text(
        "Lower Commission Rates Enjoy up to 20% reduced commission on every completed trip.",
      ),
      subtitleTextStyle: TextStyle(
        color: Color(0xFF575757),
        fontWeight: FontWeight.w400,
        fontSize: 13,
      ),
      ),
    );
  }
}
