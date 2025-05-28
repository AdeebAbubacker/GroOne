import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/view/kavach_make_payment_screen.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';

class KavachSummaryScreen extends StatefulWidget {
  const KavachSummaryScreen({super.key});

  @override
  State<KavachSummaryScreen> createState() => _KavachSummaryScreenState();
}

class _KavachSummaryScreenState extends State<KavachSummaryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Summary'),
      bottomNavigationBar: buildProceeToPayButton(),
      body: buildBodyWidget(context),
    );
  }

  Widget buildBodyWidget(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                decoration: commonContainerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Details',style: AppTextStyle.h5,),
                    10.height,
                    Row(
                      children: [
                        Expanded(child: Text('Price (6 items)',style: AppTextStyle.textDarkGreyColor14w500,)),
                        Text('₹9,730.00',style: AppTextStyle.blackColor15w500,),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('GST',style: AppTextStyle.textDarkGreyColor14w500,)),
                        Text('₹9,730.00',style: AppTextStyle.blackColor15w500,),
                      ],
                    ),
                    Divider(color: AppColors.greyIconColor,),
                    Row(
                      children: [
                        Expanded(child: Text('Total Amount',style: AppTextStyle.textDarkGreyColor14w500,)),
                        Text('₹10,420',style: AppTextStyle.blackColor15w500,),
                      ],
                    ),
                  ],
                )
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shipping Address',style: AppTextStyle.h5,),
                  10.height,
                  Text('John Doe', style: AppTextStyle.textDarkGreyColor14w500),
                  Text('+91 9988993399',style: AppTextStyle.textDarkGreyColor14w500,),
                  Text('18, 4th Street, MG Road, Nungambakkam, Chennai - 600 034.',style: AppTextStyle.textDarkGreyColor14w500,),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Billing Address',style: AppTextStyle.h5,),
                  10.height,
                  Text('John Doe', style: AppTextStyle.textDarkGreyColor14w500),
                  Text('+91 9988993399',style: AppTextStyle.textDarkGreyColor14w500,),
                  Text('18, 4th Street, MG Road, Nungambakkam, Chennai - 600 034.',style: AppTextStyle.textDarkGreyColor14w500,),
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
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('₹10,420',style: AppTextStyle.primaryColor16w900,),
            Text('Total',style: AppTextStyle.blackColor14w400,),
          ],
        ),
        15.width,
        AppButton(
          onPressed: (){
            Navigator.of(context).push(commonRoute(KavachMakePaymentScreen()));
          },
          title: 'Proceed To Pay',
          style: AppButtonStyle.primary,
        ).expand()
      ],
    ).paddingAll(30);
  }

}
