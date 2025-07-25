import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
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
    lpLoadLocator.getLpLoadsMemoDetails(loadId: widget.loadId);
  });


  @override
  Widget build(BuildContext context) {
    final notes = [
      context.appText.disclaimerNote1,
      context.appText.disclaimerNote2,
      context.appText.disclaimerNote3,
      context.appText.disclaimerNote4,
      context.appText.disclaimerNote5,
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(context.appText.memoGenerated),
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
              return Center(
                child: Text(context.appText.failedToLoadMemo, style: TextStyle(fontSize: 16)),
              );
            }

            if (uiState.status == Status.SUCCESS && (uiState.data == null || uiState.data!.loadId.isEmpty)) {
              return Center(
                child: Text(context.appText.noMemoFound, style: TextStyle(fontSize: 16)),
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
                  buildNotesWidget(notes),
                  10.height,
                  AppButton(
                    title: context.appText.eSignMemo,
                    isLoading: lpLoadLocator.state.lpLoadMemoSendOtp?.status == Status.LOADING,
                    onPressed: () async {
                      await lpLoadLocator.sendOtp(loadId: widget.loadId);
                      final otpState = lpLoadLocator.state.lpLoadMemoSendOtp;
                      if (otpState?.status == Status.SUCCESS) {
                        final message = otpState?.data?.message ?? "";
                        if (context.mounted) {
                          ToastMessages.success(message: message);
                          AppDialog.show(context, child: MemoOtpDialogWidget(
                              parentContext: context, loadId: widget.loadId));
                        }
                        setState(() {});
                      } else if (otpState?.status == Status.ERROR) {
                        final errorType = otpState?.errorType;
                        ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()),
                        );
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
  Widget buildMainDetailWidget(LpLoadMemoResponse memoDetails) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText(context.appText.mainDetails),
          buildDMemoDetailWidget(label: context.appText.loadId, value: memoDetails.loadId),
          buildDMemoDetailWidget(label: context.appText.transporter, value: memoDetails.transporter),
          buildDMemoDetailWidget(label: context.appText.vehicleNumber, value: memoDetails.vehicleNumber ?? ''),
          buildDMemoDetailWidget(label: context.appText.memo, value: memoDetails.memoNumber),
          buildDMemoDetailWidget(label: context.appText.lane, value: memoDetails.lane),
          buildDMemoDetailWidget(label: context.appText.totalFreight, value: PriceHelper.formatINR(memoDetails.totalFreight, symbol: 'Rs ')),
          buildDMemoDetailWidget(label: context.appText.handlingCharges, value:' (-)   ${PriceHelper.formatINR(memoDetails.handlingCharges, symbol: 'Rs ')}'),
          buildDMemoDetailWidget(label: context.appText.netFreight, value: PriceHelper.formatINR(memoDetails.netFreight, symbol: 'Rs ')),
          buildDMemoDetailWidget(label: "${context.appText.advance} (${memoDetails.advancePercentage.split('.').first}%)", value: PriceHelper.formatINR(memoDetails.advanceAmount, symbol: 'Rs ')),
          buildDMemoDetailWidget(label: "${context.appText.balance} (${memoDetails.balancePercentage.split('.').first}%)", value: PriceHelper.formatINR(memoDetails.balanceAmount, symbol: 'Rs ')),
        ],
      ),
    );
  }

  /// Bank Details
  Widget buildBankDetailsWidget(LpLoadMemoResponse memoDetails) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText(context.appText.bankDetails),
          buildDMemoDetailWidget(label: context.appText.beneficiaryName, value: memoDetails.bankDetails?.beneficiaryName ?? ''),
          buildDMemoDetailWidget(label: context.appText.bankName, value: memoDetails.bankDetails?.bankName ?? ''),
          buildDMemoDetailWidget(label: context.appText.accountNumber, value: memoDetails.bankDetails?.accountNumber ?? ''),
          buildDMemoDetailWidget(label: context.appText.ifscCode, value: memoDetails.bankDetails?.ifscCode ?? ''),
          buildDMemoDetailWidget(label: context.appText.branchName, value: memoDetails.bankDetails?.branchName ?? ''),
        ],
      ),
    );
  }

  /// Truck Supplier Details
  Widget buildTruckSupplierWidget(LpLoadMemoResponse memoDetails) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText(context.appText.truckSupplier),
          buildDMemoDetailWidget(label: context.appText.partnerName, value: memoDetails.truckSupplier?.partnerName.toString().capitalizeFirst ?? ''),
          buildDMemoDetailWidget(label: context.appText.vehicleNumber, value: memoDetails.truckSupplier?.vehicleNumber ?? ''),
        ],
      ),
    );
  }

  ///Disclaimer
  Widget buildNotesWidget(notes) {
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
          buildHeadingText(context.appText.disclaimer),
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
