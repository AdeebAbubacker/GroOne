import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';


class LpValidateMemo extends StatelessWidget {
  const LpValidateMemo({super.key});

  final List<String> notes = const [
    "Non-receipt of PODs should be intimated within 30 days from the delivered date.",
    "Delayed intimation related to POD non-submission will not be accepted.",
    "Transit insurance will be customer scope. Shortage/Damage debits up to ₹15,000/- or trip balance amount whichever is lower.",
    "Payment terms: We need a 90% advance within 24 hours from the loading and 10% balance 15 days from the date of submission of the hard POD and invoices.",
    "Loss of POD: In case of physical copy of POD is lost means we can submit an indemnity bond or we can accept ₹3000/- debit only as indemnity charges.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        backgroundColor: AppColors.backgroundColor,
        toolbarHeight: 50,
        title: context.appText.memo,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,

            children: [
              mainDetailWidget(),
              bankDetailsWidget(),
              truckSupplierWidget(),
              notesWidget(),
              20.height,
              AppButton(
                title: "E-Sign Memo",
                onPressed: () {
                  showVerificationNumberDialogue(context1: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  notesWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          headingText(
            text: "Note:-",
            appStyle: AppTextStyle.textBlackDetailColor16w500.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(notes.length, (index) {
              return Text(
                '${index + 1}. ${notes[index]}',
                style: AppTextStyle.blackColor14w400.copyWith(fontSize: 11),
              );
            }),
          ),
        ],
      ),
    );
  }

  Future showVerificationNumberDialogue({required BuildContext context1}) {
    return showDialog(
      context: context1,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return showCustomDialogue(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("", style: AppTextStyle.darkDividerColor16w400),
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.dividerColor,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  10.height,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Verify OTP',
                          style: AppTextStyle.primaryColor16w900.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' for confirming your load\nWe have sent an OTP to your registered\nmobile number. ',
                          style: AppTextStyle.textBlackColor16w400.copyWith(
                            height: 1.9,
                          ),
                        ),
                        TextSpan(
                          text: context.appText.needHelp,
                          style: AppTextStyle.primaryColor14w400UnderLine,
                          recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              // Handle terms & conditions tap
                              debugPrint('Terms & Conditions tapped');
                            },
                        ),
                      ],
                    ),
                  ),
                  10.height,
                  Center(
                    child: OtpTextField(
                      numberOfFields: 4,
                      showFieldAsBox: true,
                      fieldWidth: 60,
                      borderColor: AppColors.borderDisableColor,
                      onCodeChanged: (String code) {},

                      onSubmit: (String verificationCode) {
                        // controller.otp.value.text = verificationCode;
                        // controller.update();
                      }, // end
                    ),
                  ),
                ],
              ),
              child2: InkWell(
                onTap: () {},
                child: SizedBox(
                  height: 50,
                  width: 310,

                  child: Center(
                    child: Text(
                      "Resend",
                      style: AppTextStyle.textBlackColor14w400,
                    ),
                  ),
                ),
              ),
              onClickButton: () async {
                context1.pop();
                showSuccessDialog(
                  onTap: () {
                    context1.pop();
                    context1.pop();

                  },
                  context1,
                  text: "Memo E-Signed\nsuccessfully",
                  subheading:
                  "Now you can explore the rates\nand post loads",
                );

                //  context.push(AppRouteName.lpValidateMemo);
              },

              buttonText: "Verify Otp",
            );
          },
        );
      },
    );
  }

  mainDetailWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          headingText(
            text: "Main Details",
            appStyle: AppTextStyle.textBlackDetailColor16w500.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          detailMemoWidget(
            text1: "Transporter",
            text2: "Gogovan india pvt ltd",
          ),
          detailMemoWidget(text1: "Vehicle Number", text2: "MH87HV7807"),
          detailMemoWidget(text1: "LR NO:", text2: "25sch00013_1094"),
          detailMemoWidget(text1: "Route", text2: "MH87HV7807"),
          detailMemoWidget(text1: "Total Freight", text2: "Rs 30000.00"),
          detailMemoWidget(text1: "Advance", text2: "Rs 27000.00"),
          detailMemoWidget(text1: "Balance", text2: "Rs 3000.00"),
        ],
      ),
    );
  }

  truckSupplierWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          headingText(
            text: "Truck Supplier",
            appStyle: AppTextStyle.textBlackDetailColor16w500.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          detailMemoWidget(
            text1: "Partner Name",
            text2: "Gogovan india pvt ltd",
          ),
          detailMemoWidget(text1: "PAN Number", text2: "MH87HV7807"),
          detailMemoWidget(text1: "Vehicle Number", text2: "25sch00013_1094"),
        ],
      ),
    );
  }

  bankDetailsWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          headingText(
            text: "Bank Details",
            appStyle: AppTextStyle.textBlackDetailColor16w500.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          detailMemoWidget(
            text1: "Beneficiary Name",
            text2: "Gogovan india pvt ltd",
          ),
          detailMemoWidget(text1: "Bank Name", text2: "MH87HV7807"),
          detailMemoWidget(text1: "Account Number", text2: "25sch00013_1094"),
          detailMemoWidget(text1: "IFSC Code", text2: "MH87HV7807"),
          detailMemoWidget(text1: "Branch Name", text2: "Rs 30000.00"),
        ],
      ),
    );
  }

  detailMemoWidget({required String text1, required String text2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text1, style: AppTextStyle.textBlackColor14w400),
        Text(text2, style: AppTextStyle.textBlackColor16w500),
      ],
    );
  }
}
