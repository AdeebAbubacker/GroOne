import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';

class VpTripstatementScreen extends StatefulWidget {
  const VpTripstatementScreen({super.key});

  @override
  State<VpTripstatementScreen> createState() => _VpTripstatementScreenState();
}

class _VpTripstatementScreenState extends State<VpTripstatementScreen> {
  final lpLoadLocator = locator<LpLoadCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: context.appText.tripStatement),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              buildMainDetailWidget(),
              buildBankDetailsWidget(),
              buildTruckSupplierWidget(),
              10.height,
              AppButton(
                title: context.appText.downloadInvoice,
                onPressed: () {
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
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText(context.appText.mainDetails),
          buildDTripStatementWidget(
            label: context.appText.loadID,
            value: 'GD12456',
          ),
          buildDTripStatementWidget(
            label: context.appText.transporter,
            value: 'Gogovan',
          ),
          buildDTripStatementWidget(
            label: context.appText.vehicleNumber,
            value: 'MH87 HV 7807',
          ),
          buildDTripStatementWidget(
            label: "${context.appText.memo}#",
            value: '5465215',
          ),
          buildDTripStatementWidget(
            label: context.appText.lane,
            value: 'Chennai - Namakkal',
          ),
          buildDTripStatementWidget(
            label: context.appText.totalFreight,
            value: 'Rs 30,000.00',
          ),
          buildDTripStatementWidget(
            label: context.appText.handlingCharges,
            value: '(-) Rs 1000.00',
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.netFreight,
            value: 'Rs 29,000.00',
          ),
          buildDTripStatementWidget(
            label: "${context.appText.advance} (80%)",
            value: 'Rs 23,200.00',
          ),
          buildDTripStatementWidget(
            label: context.appText.damageCharges,
            value: '(-) Rs 1000.00',
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.shortages,
            value: '(-) Rs 1000.00',
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.penalty,
            value: '(-) Rs 1000.00',
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.loadingCharges,
            value: 'Rs 23,200.00',
          ),
          buildDTripStatementWidget(
            label: context.appText.unloadingCharges,
            value: 'Rs 23,200.00',
          ),
          buildDTripStatementWidget(
            label: context.appText.detentions,
            value: 'Rs 23,200.00',
          ),
          buildDTripStatementWidget(
            label: context.appText.balanceToBePaid,
            value: 'Rs 5,800.00',
          ),
        ],
      ),
    );
  }

  /// Bank Details
  Widget buildBankDetailsWidget() {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText(context.appText.bankDetails),
          buildDTripStatementWidget(
            label: context.appText.beneficiaryName,
            value: 'Gro Digital',
          ),
          buildDTripStatementWidget(
            label: context.appText.bankName,
            value: 'Axis Bank',
          ),
          buildDTripStatementWidget(
            label: "${context.appText.accountNumber}*",
            value: '7587967568',
          ),
          buildDTripStatementWidget(
            label: "${context.appText.ifscCode}*",
            value: 'BARB0KALAMA',
          ),
          buildDTripStatementWidget(
            label: "${context.appText.branchName}*",
            value: 'Nungambakam',
          ),
        ],
      ),
    );
  }

  /// Truck Supplier Details
  Widget buildTruckSupplierWidget() {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText(context.appText.truckSupplier),
          buildDTripStatementWidget(
            label: context.appText.partnerName,
            value: 'Manish Kumar',
          ),
          buildDTripStatementWidget(
            label: context.appText.panNumber,
            value: 'DPXP938650',
          ),
          buildDTripStatementWidget(
            label: context.appText.vehicleNumber,
            value: 'MH87HV7808',
          ),
        ],
      ),
    );
  }

  /// Heading Section
  Widget buildHeadingText(String text) {
    return Text(
      text,
      style: AppTextStyle.h5.copyWith(
        color: AppColors.textBlackColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  /// Trip Statement Detail Widget
  Widget buildDTripStatementWidget({
    required String label,
    required String value,
    bool isNegative = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.body3),
        Text(
          value,
          style: AppTextStyle.body2.copyWith(
            color: isNegative ? AppColors.iconRed : AppTextStyle.body2.color,
          ),
        ),
      ],
    );
  }
}

void showUnloadingHeldPopup(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  AppDialog.show(
    context,
    child: CommonDialogView(
      crossAxisAlignment: CrossAxisAlignment.center,
      hideCloseButton: true,
      showYesNoButtonButtons: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            AppJSON.alert,
            width: screenWidth * 0.5,
            height: screenWidth * 0.5,
            repeat: true,
            frameRate: FrameRate.max,
          ).paddingBottom(5),
          Text(
            context.appText.unloadingHeld,
            // "Unloading Held",
            style: AppTextStyle.body2PrimaryColor.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textRed,
            ),
          ).paddingBottom(5),

          Text(
            context.appText.unloadingHeldNotice,
            style: AppTextStyle.radialProgressText.copyWith(
              fontSize: 13,
              color: AppColors.mediumGreyColor,
            ),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 10),
        ],
      ),
    ),
  );
}
