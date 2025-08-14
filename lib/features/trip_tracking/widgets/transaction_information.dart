import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_icons.dart';

class TransactionInformation extends StatefulWidget {
  final List<VpLog>? vpLogs;
  final String? advancedPer;
  const TransactionInformation({super.key,this.vpLogs,this.advancedPer});

  @override
  State<TransactionInformation> createState() => _TransactionInformationState();
}

class _TransactionInformationState extends State<TransactionInformation> {
  VpLog? advancedAction;
  VpLog? balanceAction;

  @override
  void initState() {
    getTransactionLogsDetails();
    super.initState();
  }

  getTransactionLogsDetails(){
    try{
      advancedAction=  widget.vpLogs!.firstWhere((element) => element.action=="advanced",);
    }catch(e){}

    try{
      balanceAction= widget.vpLogs!.firstWhere((element) => element.action=="balance",);
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      child: SingleChildScrollView(
        child: Column(
          spacing: 15,
          children: [
            if(advancedAction!=null)
            _buildInfoWidget(context,advancedAction,"${context.appText.advancedReceived} (${widget.advancedPer}%)"),
            if(balanceAction!=null)
            _buildInfoWidget(context,balanceAction,context.appText.balanceReceived),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoWidget(BuildContext context,VpLog? vpLogs,String? received){
   return Container(
        decoration:commonContainerDecoration
          (
          color: Color(0xffE9F3FA).withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          spacing: 5,
          children: [
            _buildInfoRow(received, vpLogs?.amount??""),
            _buildInfoRow(context.appText.transactionID, vpLogs?.transactionId??"", ),
            _buildInfoRow(context.appText.paymentMode, vpLogs?.paymentMethod.toString()),
            _buildInfoRow(context.appText.receivedOn,  DateTimeHelper.formatCustomDateIST(vpLogs?.createdAt),),
            _buildInfoRow(context.appText.paymentStatus, "",showStatus: true),
          ],
        ).paddingAll(12)
    );
  }

  Widget _buildInfoRow(String? title, String? value, {bool isLink = false,bool? showStatus,bool? status}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title??"",
            style: AppTextStyle.h3w500.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w200
            )),
        Spacer(),
        if(showStatus??false)
          Container(
            height: 24,
            decoration: commonContainerDecoration(
              color: (status??false) ? Colors.green.shade100 :  Color(0xffFFD7D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
                (status??false) ? context.appText.completed : context.appText.pending,
                style: AppTextStyle.h3w500.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w100,
                    color: (status??false) ?  AppColors.textGreen:AppColors.textRed
                )).paddingSymmetric(horizontal: 5,vertical: 3),
          )
        else

        FittedBox(
          child: Text(
            value??"",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 12,
              decoration: isLink ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 5);
  }
}

