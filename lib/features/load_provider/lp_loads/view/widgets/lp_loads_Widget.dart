import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/advance_payment_dialog.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/features/load_provider/lp_home/helper/lp_home_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/helper/LpLoadsHelper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:lottie/lottie.dart';

class LPLoadListBodyWidget extends StatelessWidget{
  const LPLoadListBodyWidget({super.key, required this.loadItem});

  final LpLoadItem loadItem;

  void agreeLoadPopup(context) {
    AppDialog.show(context, child: CommonDialogView(
      hideCloseButton: true,
      showYesNoButtonButtons: true,
      noButtonText: "Cancel",
      yesButtonText: "I Agree Load",
      child: Column(
        children: [
          Lottie.asset(AppJSON.shipment, repeat: true, frameRate: FrameRate(200)),
          Text("Are you sure you agree to this Load?"),
        ],
      ),
      onClickYesButton: () {
        Navigator.pop(context);
        AppDialog.show(context, child: AdvancePaymentDialog(price:loadItem.rate == "" ? 0 : int.parse(loadItem.rate),  loadId: loadItem.loadId), dismissible: true);
      },
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: commonContainerDecoration(
          borderColor: AppColors.primaryColor,
          borderWidth: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLoadIdDetailsWidget(),
            commonDivider(),
            buildPickupAndDropAddressWidget(),
            20.height,
            buildRateWidget(),
            10.height,
            if(loadItem.loadStatus == 5)
            buildAgreeButtonWidget(context)
          ],
        )
    );
  }

  /// Load ID Details
  Widget buildLoadIdDetailsWidget() {
    return Row(
      children: [
        Container(
          decoration: commonContainerDecoration(
            color: Color(0xffDFE6FF),
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset(AppIcons.svg.orderBox).paddingAll(10),
        ),
        15.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Text(
                  'GD ${loadItem.loadId}',
                  style: AppTextStyle.h5,
                  maxLines: 2,
                ),
              ],
            ),
            8.height,
            Text(
             loadItem.dueDate != null ? DateTimeHelper.formatCustomDate(loadItem.dueDate!) : "--",
              style: AppTextStyle.body4.copyWith(
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ).expand(),
        Column(
          children: [
            Container(
              decoration: commonContainerDecoration(
                color: LpLoadsHelper.getLoadStatusColor(loadItem.loadStatus.toInt())
              ),
              width: 100.w,
              child: Text(
                LpLoadsHelper.getLoadTypeDisplayText(loadItem.loadStatus.toInt()),
                style: AppTextStyle.body3.copyWith(color: LpLoadsHelper.getLoadStatusTextColor(loadItem.loadStatus.toInt())),
              ).center().paddingAll(4),
            ),
            5.height,
            if(loadItem.loadStatus == 2)
            Text(LpHomeHelper.getMatchingTime(loadItem.createdAt.toString()), style: AppTextStyle.body4.copyWith(color: AppColors.greenColor),  maxLines: 1).paddingRight(5)
          ],
        ),
      ],
    );
  }

  /// PickUp and Drop Address
  Widget buildPickupAndDropAddressWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.gps_fixed, color: AppColors.greenColor, size: 20),
        5.width,
        Text(
          loadItem.pickUpAddr,
          style: AppTextStyle.body4.copyWith(fontSize: 12),
        ),
        DottedLine(
          direction: Axis.horizontal,
          lineLength: double.infinity,
          lineThickness: 1.0,
          dashLength: 4.0,
          dashColor: Colors.grey,
          dashGapLength: 3.0,
        ).paddingOnly(right: 8, left: 12).expand(),
        Icon(Icons.location_on_outlined, color: AppColors.activeRedColor, size: 20),
        Text(
          loadItem.dropAddr,
          style: AppTextStyle.body4.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  /// Rate
  Widget buildRateWidget() {
    return Container(
      decoration: commonContainerDecoration(
        color: AppColors.primaryLightColor,
        borderRadius: BorderRadius.circular(commonButtonRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Agreed Price", style: AppTextStyle.body2),
          Text(
            "₹ ${loadItem.rate}",
            style: AppTextStyle.h4.copyWith(color: AppColors.primaryColor),
          ),
        ],
      ).paddingAll(8),

    );
  }

  /// Agree Button
  Widget buildAgreeButtonWidget(BuildContext context) {
    return Row(
      children: [
        AppButton(
          buttonHeight: 40,
          onPressed: () => agreeLoadPopup(context),
          title: context.appText.iAgree,
        ).expand(),
        10.width,
        IconButton(
          onPressed: () {
            commonSupportDialog(context);
          },
          icon: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            child: SvgPicture.asset(
              AppIcons.svg.support,
              width: 25,
              colorFilter: AppColors.svg(AppColors.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
