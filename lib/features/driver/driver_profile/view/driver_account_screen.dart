import 'package:flutter/material.dart';
import 'package:gro_one_app/features/driver/driver_profile/model/driver_profile_details_model.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';

class DriverAccountScreen extends StatelessWidget {
  final DriverProfileDetailsModel driverProfileDetailsModel;
  const DriverAccountScreen({super.key,required this.driverProfileDetailsModel});

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
              0.height,

            
                headingText(text: context.appText.personalDetails),
                buildDetailWidget(
                  text1: context.appText.name,
                  text2: checkUserDetails(driverProfileDetailsModel.data?.name),
                ),

                buildDetailWidget(
                  text1: context.appText.mobileNumber,
                  text2: checkUserDetails(driverProfileDetailsModel.data?.mobile),
                ),

                buildDetailWidget(
                    text1: context.appText.email,
                    text2: checkUserDetails(driverProfileDetailsModel.data?.email)
                ),
                dividerWidget(),


              



              // Company Detail
              headingText(text: context.appText.companyDetails),
           
              buildDetailWidget(
                text1: context.appText.companyName,
                text2: checkUserDetails(driverProfileDetailsModel.data?.companyDetails?.companyName ?? ''),
              ),
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
