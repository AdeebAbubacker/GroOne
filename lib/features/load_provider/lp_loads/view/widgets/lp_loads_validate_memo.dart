import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

import 'memo_otp_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class LpLoadValidateMemo extends StatefulWidget {
  const LpLoadValidateMemo({super.key, required this.loadId});

  final String loadId;

  @override
  State<LpLoadValidateMemo> createState() => _LpLoadValidateMemoState();
}

class _LpLoadValidateMemoState extends State<LpLoadValidateMemo> {

  final lpLoadLocator = locator<LpLoadCubit>();

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(() {
    lpLoadLocator.getLpLoadsMemoDetails(loadId: int.parse(widget.loadId));
  });


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

      body: BlocBuilder<LpLoadCubit, LpLoadState>(
          builder: (context, state) {
            final uiState = state.lpLoadMemoDetails;


            if (uiState == null || uiState.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            if (uiState.status == Status.ERROR) {
              return const Center(
                child: Text("Failed to load memo details.", style: TextStyle(fontSize: 16)),
              );
            }

            if (uiState.status == Status.SUCCESS && (uiState.data == null || uiState.data!.loadId.isEmpty)) {
              return const Center(
                child: Text("No Memo Found.", style: TextStyle(fontSize: 16)),
              );
            }

            final  memoDetails = uiState.data;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  buildMainDetailWidget(memoDetails!),
                  buildBankDetailsWidget(memoDetails),
                  buildTruckSupplierWidget(memoDetails),
                  buildNotesWidget(),
                  10.height,
                  AppButton(
                    title: "E-Sign Memo",
                    onPressed: () async {
                      await lpLoadLocator.sendOtp(loadId: memoDetails.id.toString());
                      final otpState = lpLoadLocator.state.lpLoadMemoSendOtp;
                      if (otpState?.status == Status.SUCCESS) {
                        final message = otpState?.data?.data?.message ?? "OTP sent";
                        if (context.mounted) {
                          ToastMessages.success(message: message);
                        }
                        setState(() {});
                      } else if (otpState?.status == Status.ERROR) {
                        final errorType = otpState?.errorType;
                        ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()),
                        );
                      }
                    if (context.mounted) {
                      AppDialog.show(context, child: MemoOtpDialogWidget(
                          parentContext: context, loadId: memoDetails.id.toString()));
                    }
                    },
                  ),
                  40.height,
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  /// Main Details
  Widget buildMainDetailWidget(LoadMemoData memoDetails) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText('Main Details'),
          buildDMemoDetailWidget(label: "Load ID", value: memoDetails.loadId),
          buildDMemoDetailWidget(label: "Transporter", value: memoDetails.transporter),
          buildDMemoDetailWidget(label: "Vehicle Number", value: memoDetails.trip?.vehicle?.vehicleNumber ?? ''),
          buildDMemoDetailWidget(label: "MEMO#", value: memoDetails.memoNumber),
          buildDMemoDetailWidget(label: "Lane", value: memoDetails.lane),
          buildDMemoDetailWidget(label: "Total Freight", value: PriceHelper.formatINR(memoDetails.totalFreight, symbol: 'Rs ')),
          buildDMemoDetailWidget(label: "Handling Charges", value:' (-)   ${PriceHelper.formatINR(memoDetails.handlingCharges, symbol: 'Rs ')}'),
          buildDMemoDetailWidget(label: "Net Freight", value: PriceHelper.formatINR(memoDetails.netFreight, symbol: 'Rs ')),
          buildDMemoDetailWidget(label: "Advance (${memoDetails.advancePercentage.split('.').first}%)", value: PriceHelper.formatINR(memoDetails.advanceAmount, symbol: 'Rs ')),
          buildDMemoDetailWidget(label: "Balance (${memoDetails.balancePercentage.split('.').first}%)", value: PriceHelper.formatINR(memoDetails.balanceAmount, symbol: 'Rs ')),],
      ),
    );
  }

  /// Bank Details
  Widget buildBankDetailsWidget(LoadMemoData memoDetails) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText("Bank Details"),
          buildDMemoDetailWidget(label: "Beneficiary Name", value: memoDetails.bankDetails?.beneficiaryName ?? ''),
          buildDMemoDetailWidget(label: "Bank Name*", value: memoDetails.bankDetails?.bankName ?? ''),
          buildDMemoDetailWidget(label: "Account Number*", value: memoDetails.bankDetails?.accountNumber ?? ''),
          buildDMemoDetailWidget(label: "IFSC Code*", value: memoDetails.bankDetails?.ifscCode ?? ''),
          buildDMemoDetailWidget(label: "Branch Name*", value: memoDetails.bankDetails?.branchName ?? ''),
        ],
      ),
    );
  }

  /// Truck Supplier Details
  Widget buildTruckSupplierWidget(LoadMemoData memoDetails) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText("Truck Supplier"),
          buildDMemoDetailWidget(label: "Partner Name", value: memoDetails.truckSupplier?.partnerName ?? ''),
          buildDMemoDetailWidget(label: "PAN Number", value: memoDetails.truckSupplier?.panNumber ?? ''),
          buildDMemoDetailWidget(label: "Vehicle Number", value: memoDetails.trip?.vehicle?.vehicleNumber ?? ''),
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
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          buildHeadingText('Disclaimer'),
          Column(
            spacing: 5,
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
