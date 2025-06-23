import 'memo_otp_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class LpLoadValidateMemo extends StatelessWidget {
  const LpLoadValidateMemo({super.key});

  final List<String> notes = const [
    "Non-receipt of PODs should be intimated within 30 days from the delivered date.",
    "Delayed intimation related to POD non-submission will not be accepted.",
    "Transit insurance will be customer scope. Shortage/Damage debits up to ₹15,000/- or Load balance amount whichever is lower.",
    "Payment terms:- We need a 90% advance within 24 hours from the loading and 10% balance 15 days from the date of submission of the hard POD and invoices.",
    "Loss of POD: In case of physical copy of POD is lost means we can submit an indemnity bond or we can accept ₹3000/- debit only as indemnity charges.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text('MEMO Generated'),
        titleTextStyle: AppTextStyle.h4,
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10.h,
            children: [
              buildMainDetailWidget(),
              buildBankDetailsWidget(),
              buildTruckSupplierWidget(),
              buildNotesWidget(),
              10.height,
              AppButton(
                title: "E-Sign Memo",
                onPressed: () {
                  AppDialog.show(context, child: MemoOtpDialogWidget());
                },
              ),
              40.height,
            ],
          ),
        ),
      ),
    );
  }

  /// Main Details
  Widget buildMainDetailWidget() {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20.h,
        children: [
          buildHeadingText('Main Details'),
          buildDMemoDetailWidget(label: "Load ID", value: "GD12456"),
          buildDMemoDetailWidget(label: "Transporter", value: "Gogovan india pvt ltd"),
          buildDMemoDetailWidget(label: "Vehicle Number", value: "MH87 HV 7807"),
          buildDMemoDetailWidget(label: "MEMO#", value: "09876543212345678"),
          buildDMemoDetailWidget(label: "Lane", value: "Chennai - Namakkal"),
          buildDMemoDetailWidget(label: "Total Freight", value: "Rs 30000.00"),
          buildDMemoDetailWidget(label: "Handling Charges", value: "(-) Rs 1000.00"),
          buildDMemoDetailWidget(label: "Net Freight", value: "Rs 29000.00"),
          buildDMemoDetailWidget(label: "Advance (80%)", value: "Rs 27000.00"),
          buildDMemoDetailWidget(label: "Balance (20%)", value: "Rs 3000.00"),
        ],
      ),
    );
  }

  /// Bank Details
  Widget buildBankDetailsWidget() {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20.h,
        children: [
          buildHeadingText("Bank Details"),
          buildDMemoDetailWidget(label: "Beneficiary Name", value: "Gro Digital Platform"),
          buildDMemoDetailWidget(label: "Bank Name*", value: "Axis Bank"),
          buildDMemoDetailWidget(label: "Account Number*", value: "7658036540837458"),
          buildDMemoDetailWidget(label: "IFSC Code*", value: "UT7346580nfj"),
          buildDMemoDetailWidget(label: "Branch Name*", value: "T.Nagar"),
        ],
      ),
    );
  }

  /// Truck Supplier Details
  Widget buildTruckSupplierWidget() {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20.h,
        children: [
          buildHeadingText("Truck Supplier"),
          buildDMemoDetailWidget(label: "Partner Name", value: "Manish Kumar"),
          buildDMemoDetailWidget(label: "PAN Number", value: "DPXP938650"),
          buildDMemoDetailWidget(label: "Vehicle Number", value: "MH87HV7808"),
        ],
      ),
    );
  }

  ///Disclaimer
  Widget buildNotesWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.h,
        children: [
          buildHeadingText('Disclaimer'),
          Column(
            spacing: 5.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(notes.length, (index) {
              return Text(
                '${index + 1}. ${notes[index]}',
                style: AppTextStyle.body4.copyWith(color: AppColors.black),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildHeadingText(String text) {
    return Text(
      text,
      style: AppTextStyle.h5.copyWith(color: AppColors.textBlackColor, fontWeight: FontWeight.w700),
    );
  }

  Widget buildDMemoDetailWidget({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.body3),
        Text(value, style: AppTextStyle.body2),
      ],
    );
  }
}
