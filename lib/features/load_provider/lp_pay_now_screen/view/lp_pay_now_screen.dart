import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../utils/app_text_style.dart';
import '../../../../utils/extra_utils.dart';

class LpPayNowScreen extends StatefulWidget {
  const LpPayNowScreen({super.key,});


  @override
  State<LpPayNowScreen> createState() => _LpPayNowScreenState();
}

class _LpPayNowScreenState extends State<LpPayNowScreen> {
  int selectedPercentage = 80;
  final int baseAmount = 15000;
  bool forBalancePayment=true;

  @override
  Widget build(BuildContext context) {
    int calculatedAmount = (baseAmount * selectedPercentage ~/ 100);
    return Scaffold(bottomNavigationBar:    Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      child: AppButton(
        title: forBalancePayment?"Continue":"Back To Tracking",
        onPressed: () {
          showSuccessDialog(
            onTap: () {
              context.pop();
              if(forBalancePayment==true){
                forBalancePayment=false;
                setState(() {

                });
              }else{
                context.pop();

              }
            },

            context,
            text:  "${ forBalancePayment?"Advance":"Balance"} Payment done\nsuccessfull",
            subheading: "",
          );
        },
      ),
    ),
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        backgroundColor: AppColors.backgroundColor,
        title: "Make Payment",
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            children: [
         Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 2.5,
                    ),
                  ],
                ),
          
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.appText.advancePayment,
                          style: AppTextStyle.darkDividerColor16w400,
                        ),
                        statusButtonWidget(
                          margin: EdgeInsets.zero,
                          statusBackgroundColor: forBalancePayment? AppColors.appRedColor:AppColors.boxGreen,
                          statusTextColor: forBalancePayment? AppColors.textRed:AppColors.textGreen,
                          statusText: forBalancePayment? "Pending":"Completed",
                        ),
                      ],
                    ),
                    forBalancePayment?    20.height:const SizedBox(),
                    forBalancePayment?  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          [75, 80, 85, 90].map((percent) {
                            final isSelected = percent == selectedPercentage;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPercentage = percent;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? const Color(0xFF0057FF)
                                          : Colors.transparent,
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$percent%',
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? AppColors.white
                                            : AppColors.greyTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ):const SizedBox(),
                    20.height,
                    Text(
                      '₹$calculatedAmount',
                      style: AppTextStyle.textBlackColor26w700,
                    ),
                  ],
                ),
              ),
         forBalancePayment? const SizedBox():   balancePaymentWidget(),
              forBalancePayment? cardDetailsWidget():const SizedBox() ,

              forBalancePayment? bakWidget(): const SizedBox(),
              

            ],
          ),
        ),
      ),
    );
  }

  balancePaymentWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 2.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Balance Payment",
                style: AppTextStyle.darkDividerColor16w400,
              ),
              statusButtonWidget(
                margin: EdgeInsets.zero,
                statusBackgroundColor: AppColors.appRedColor,
                statusTextColor: AppColors.textRed,
                statusText: "Pending",
              ),
            ],
          ),

          Text(
            '₹3200',
            style: AppTextStyle.textBlackColor26w700,
          ),
        ],
      ),
    );
  }

  bankDetailsWidget({required String text1, required String text2}) {
    return Row(
      spacing: 40,
      children: [
        Expanded(
          child: Text(text1, style: AppTextStyle.textGreyDetailColor14w400),
        ),
        Expanded(
          child: Text(text2, style: AppTextStyle.textGreyDetailColor14w400),
        ),
      ],
    );
  }

  bakWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            children: [
              Image.asset(AppImage.png.bankImage, height: 20, width: 20),
              headingText(
                text: "Bank Details",
                appStyle: AppTextStyle.textBlackColor15w700,
              ),
            ],
          ),
          bankDetailsWidget(text1: "Account Name", text2: "Gro One"),
          bankDetailsWidget(text1: "Account number", text2: "1234567890"),
          bankDetailsWidget(text1: "IFSC Code", text2: "HDFC000098"),
        ],
      ),
    );
  }

  cardDetailsWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      child: Column(
        spacing: 10,
        children: [
          payMethodWidget(
            imageString: AppImage.png.cards,
            heading: "Cards",
            onTap: () {},
            selected: true,
            subheading: "Visa, mastercard, rupay & more",
          ),
          dividerWidget(),
          payMethodWidget(
            imageString: AppImage.png.upi,
            heading: "UPI",
            onTap: () {},
            selected: false,
            subheading: "Google pay, paytm, phonepe & more",
          ),
          dividerWidget(),
          payMethodWidget(
            imageString: AppImage.png.netBanking,
            heading: "Net Banking",
            onTap: () {},
            selected: false,
            subheading: "pay using 50+ supported banks",
          ),
        ],
      ),
    );
  }

  payMethodWidget({
    required String heading,
    required String subheading,
    required String imageString,
    bool selected = false,
    required GestureTapCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        spacing: 10,
        children: [
          Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color:
                    selected
                        ? AppColors.primaryDarkColor
                        : AppColors.disableColor,
                width: selected ? 5 : 2,
              ),
            ),
          ),
          Image.asset(height: 48, width: 48, imageString),

          Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(heading, style: AppTextStyle.textBlackDetailColor16w500),
              Text(subheading, style: AppTextStyle.textGreyDetailColor10w400),
            ],
          ),
        ],
      ),
    );
  }
}
