import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';

class KavachMakePaymentScreen extends StatefulWidget {
  const KavachMakePaymentScreen({super.key});

  @override
  State<KavachMakePaymentScreen> createState() => _KavachMakePaymentScreenState();
}

class _KavachMakePaymentScreenState extends State<KavachMakePaymentScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Make Payment'),
      bottomNavigationBar: buildProceeToPayButton(),
      body: buildBodyWidget(context),
    );
  }

  Widget buildBodyWidget(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            10.height,
            Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                decoration: commonContainerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Amounts to Pay',style: AppTextStyle.textDarkGreyColor14w500,),
                    10.height,
                    Text('₹10,420',style: AppTextStyle.h4,),
                  ],
                )
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              child: Column(
                children: [
             paymentWidget(title: 'Cards', subtitle: 'Visa, Mastercard, Rupay & More', img: AppIcons.png.kavachPaymentCard),
             Divider(),
             paymentWidget(title: 'UPI', subtitle: 'Google pay, Paytm, Phonepe & More', img: AppIcons.png.kavachPaymentUpi),
             Divider(),
             paymentWidget(title: 'Net Banking', subtitle: 'Pay Using 50+ Supported Banks', img: AppIcons.png.kavachPaymentNetBanking),
                ],
              ),
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance_outlined),
                      10.width,
                      Text('Bank Details',style: AppTextStyle.h5,),
                    ],
                  ),
                  10.height,
                  Row(
                    children: [
                      Expanded(child: Text('Account Name', style: AppTextStyle.textDarkGreyColor14w500)),
                      Expanded(child: Text('Gro One', style: AppTextStyle.textDarkGreyColor14w500)),
                    ],
                  ),
                  10.height,
                  Row(
                    children: [
                      Expanded(child: Text('Account Number', style: AppTextStyle.textDarkGreyColor14w500)),
                      Expanded(child: Text('1234567890', style: AppTextStyle.textDarkGreyColor14w500)),
                    ],
                  ),
                  10.height,
                  Row(
                    children: [
                      Expanded(child: Text('IFSC Code', style: AppTextStyle.textDarkGreyColor14w500)),
                      Expanded(child: Text('HDFC000098', style: AppTextStyle.textDarkGreyColor14w500)),
                    ],
                  ),
                ],
              ),
            ),
            30.height,
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }

  Widget buildProceeToPayButton(){
    return AppButton(
      onPressed: (){

      },
      title: 'Pay ₹10,420',
      style: AppButtonStyle.primary,
    ).paddingAll(30);
  }

  Widget paymentWidget({required String title,required String subtitle,required String img,}){
    return  Row(
      children: [
        Radio(value: false, groupValue: null, onChanged: (value) {

        },),
        Card(
          color: AppColors.lightBlueIconBackgroundColor,
          child: Image.asset(img, height: 30.h, width: 30.w).paddingAll(10),),
        10.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: AppTextStyle.h4,),
            5.height,
            Text(subtitle,style: AppTextStyle.textDarkGreyColor12w400,),
          ],
        )
      ],
    );
  }
}
