import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_agree_response.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/lp_loads_validate_memo.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';


class AdvancePaymentDialog extends StatelessWidget {
   AdvancePaymentDialog({super.key, required this.loadId, this.creditLimit = '', required this.lpLoadAgreeData});

  final String loadId;
  final String creditLimit;
  final LpLoadAgreeResponse lpLoadAgreeData;
  final lpLoadLocator = locator<LpLoadCubit>();


  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LpLoadCubit>();
    final selectedAdvance = cubit.state.selectedAdvance;
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.appText.advancePayment,
          style: AppTextStyle.body2.copyWith(color: AppColors.darkDividerColor),
        ),
        15.height,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: lpLoadAgreeData.advance.map((advanceItem) {
            final isSelected = advanceItem.percentageId == cubit.state.selectedPercentageId;
            return GestureDetector(
              onTap: () => cubit.selectAdvance(advanceItem),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05, vertical: 5),
                  decoration: commonContainerDecoration(
                    color: isSelected ? AppColors.primaryColor : Colors.white,
                    borderColor:  AppColors.primaryColor,
                  ),
                  child: Text('${advanceItem.percentage.split('.').first}%', style:  AppTextStyle.body2.copyWith(color: isSelected ? AppColors.white : AppColors.primaryColor))),
            );
          }).toList(),
        ),
        15.height,
        Text(PriceHelper.formatINR(selectedAdvance?.amount ?? ''), style: AppTextStyle.h2),
        40.height,

        AppButton(
          onPressed: ()async{
            final selectedAdvanceId = cubit.state.selectedAdvance?.percentageId;

            await lpLoadLocator.verifyAdvance(loadId: loadId, percentageId: selectedAdvanceId.toString());

            final uiState = lpLoadLocator.state.lpLoadVerifyAdvance;

            if (uiState?.status == Status.LOADING) {}
            else if (uiState?.status == Status.SUCCESS) {
              if(context.mounted) {
                context.pop();
                Navigator.push(context, commonRoute(LpLoadValidateMemo(loadId: loadId)));
              }
            }
            else if (uiState?.status == Status.ERROR) {
              final errorType = uiState?.errorType;
              ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
              return;
            }

          },
          title: context.appText.confirmAdvance,
        ),
        20.height,
      ],
    );
  }
}
