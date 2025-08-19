import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart' hide LoadSettlement;
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/cubit/vp_trip_statement_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/model/trip_statement_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class VpTripStatementScreen extends StatefulWidget {
  final LoadDetailModelData? loadDetailModelData;
  final String? loadId;
  const VpTripStatementScreen({super.key,this.loadDetailModelData,this.loadId});

  @override
  State<VpTripStatementScreen> createState() => _VpTripStatementScreenState();
}

class _VpTripStatementScreenState extends State<VpTripStatementScreen> {

  final loadDetailsCubit = locator<LoadDetailsCubit>();
  final tripStatementCubit = locator<VpTripStatementCubit>();



  @override
  void initState() {
    _fetchTripStatement();
    super.initState();
  }

  Future _fetchTripStatement() async {
    await tripStatementCubit.fetchTripStatement(widget.loadId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(title: context.appText.tripStatement),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: Column(
          children: [
            BlocBuilder<VpTripStatementCubit,VpTripStatementState>(
              builder:(context, state)  {
                final status=state.tripStatementUIState?.status;

                if (status == Status.LOADING) {
                  return CircularProgressIndicator().center();
                }

                if (status == Status.ERROR) {
                  return VpHelper.withSliverRefresh(
                          () => _fetchTripStatement(),
                      child: genericErrorWidget(
                        error: state.tripStatementUIState?.errorType,
                      ));
                }
                if (status == Status.SUCCESS) {
                  final tripStatement = state.tripStatementUIState?.data;
                  if (tripStatement == null) {
                    return VpHelper.withSliverRefresh(
                            () => _fetchTripStatement(),
                        child: genericErrorWidget(error: NotFoundError()));
                  }
                  return buildTripStatementView(tripStatement);
                }

                return genericErrorWidget(error: GenericError());
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTripStatementView(TripStatementResponse? tripStatement){
    return Expanded(
    child: RefreshIndicator(
      onRefresh: () async {
        await _fetchTripStatement();
      },
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            buildMainDetailWidget(context: context,tripStatement: tripStatement),
            buildLoadProviderWidget(context: context,tripStatement: tripStatement),
            10.height,
            if((tripStatement?.data?.tripStatementUrl??"").isNotEmpty)
            ...[
              AppButton(
                title: context.appText.downloadTripStatement,
                onPressed: () {
                  loadDetailsCubit.downloadDocument(tripStatement?.data?.tripStatementUrl??"",-1);
                },
              ),
              10.height,
            ]

          ],
        ),
      ),
    ),
  );
  }

  /// Main Details
  Widget buildMainDetailWidget({required BuildContext context,TripStatementResponse? tripStatement}) {
    TripStatementData? statementData= tripStatement?.data;
    final detentionsAmount = PriceHelper.formatINR(
      statementData?.detentions.toString(),
    );

    final gstAmount=calculateGstAmount(double.tryParse(statementData?.platformFee??"")??0,double.tryParse(statementData?.platformFeeWithGst??"")??0);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText("TRIP"),
          8.height,
          buildDTripStatementWidget(
            label: context.appText.loadID,
            value: statementData?.loadId??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.shipper,
            value: statementData?.shipper??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.vehicleNumber,
            value: formatVehicleNumber(statementData?.vehicleNumber??""),
          ),
          buildDTripStatementWidget(
            label: "${context.appText.memo}#",
            value: statementData?.memoNumber??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.lane,
            value: statementData?.lane??"",
          ),
          20.height,
          buildDTripStatementWidget(
            label: context.appText.totalTransportationCost,
            value: PriceHelper.formatINR(  tripStatement?.data?.totalTransportationCost??""),
          ),
          10.height,

          buildHeadingText("CREDITS"),
          8.height,

          buildDTripStatementWidget(
            label: context.appText.loadingCharges,
            value: "(+)${PriceHelper.formatINR(statementData?.loading??"")}",
            isPositive: true
          ),

          buildDTripStatementWidget(
              label: context.appText.unloadingCharges,
              value: "(+) ${PriceHelper.formatINR( statementData?.unloading??"")}",
              isPositive: true
          ),

          buildDTripStatementWidget(
            label: context.appText.detentions,
            value: "(+) $detentionsAmount", isPositive: true
          ),


          20.height,

          buildHeadingText("DEBITS"),
          8.height,

          platformFeeView(
              baseAmount:PriceHelper.formatINR(statementData?.platformFee??""),
              gstAmount: PriceHelper.formatINR(gstAmount),
              gstPercentage: statementData?.platformFeeGstPercentage.toString(),
              totalAmount: PriceHelper.formatINR(statementData?.platformFeeWithGst??""),
              totalLabeledValue: '(-) ${PriceHelper.formatINR(statementData?.platformFeeWithGst??"")}'
          ),

          buildDTripStatementWidget(
            label: context.appText.damage,
            value: '(-) ${PriceHelper.formatINR( statementData?.damages??"")}',
            isNegative: true
          ),
          buildDTripStatementWidget(
            label: context.appText.shortages,
            value:"(-) ${PriceHelper.formatINR( statementData?.shortages??"")}",
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.penalties,
            value: '(-) ${PriceHelper.formatINR(statementData?.penalties??"")}',
            isNegative: true,
          ),
          20.height,

          buildHeadingText("TOTAL"),
          8.height,

          buildDTripStatementWidget(
            label:  context.appText.advancedReceived,
            value: PriceHelper.formatINR(tripStatement?.data?.advanceReceived??""),
          ),
          buildDTripStatementWidget(
            label: context.appText.balanceToBeReceived,
            value:PriceHelper.formatINR(statementData?.balanceToBeReceived??""),
          ),
        ],
      ),
    );
  }

  /// Bank Details


  /// Truck Supplier Details
  Widget buildLoadProviderWidget({required BuildContext context,TripStatementResponse? tripStatement}) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          buildHeadingText(context.appText.loadProvider.toUpperCase()),
          8.height,
          buildDTripStatementWidget(
            label: context.appText.name,
            value: tripStatement?.data?.loadProvider?.name??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.destination,
            value: tripStatement?.data?.loadProvider?.destination??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.unloadingDate,
            value:  DateTimeHelper.formatCustomDateTimeIST(
              tripStatement?.data?.loadProvider?.unloadingDate,
            ),
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
        color: Color(0xff6a7282),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Trip Statement Detail Widget
  Widget buildDTripStatementWidget({
    required String label,
    required String value,
    bool isNegative = false,
    bool? isPositive=false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        color:Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
            maxLines: 1,
            style: AppTextStyle.body3.copyWith(
            fontSize: 14,
            color: AppColors.textBlackDetailColor,

          ),),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
               value,
              maxLines: 1,
              textAlign: TextAlign.right,
               style: AppTextStyle.body2.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                 color:(isPositive??false)?  Colors.green:

                 isNegative ? AppColors.iconRed : AppTextStyle.body2.color,
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget platformFeeView({
    String? baseAmount,
    String? gstAmount,
    String? totalAmount,
    String? gstPercentage,
    String? totalLabeledValue,

  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        color:Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 5,
                children: [
                  Text(context.appText.platformFee,
                    maxLines: 1,
                    style: AppTextStyle.body3.copyWith(
                      fontSize: 14,
                      color: AppColors.textBlackDetailColor,
                    ),),
                  Container(
                    height: 20,
                   padding: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.grey
                      ),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child:  FittedBox(
                      child: Text("${context.appText.gst} ${gstPercentage}%",
                        maxLines: 1,
                        style: AppTextStyle.body3.copyWith(
                          fontSize: 14,
                          color: AppColors.textBlackDetailColor.withOpacity(0.6),
                        ),),
                    ),
                  )
                ],
              ),
              Text(
                "${context.appText.base} $baseAmount + ${context.appText.gst} $gstAmount = $totalAmount",
                maxLines: 1,
                textAlign: TextAlign.right,
                style: AppTextStyle.body2.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w200,
                    color: AppColors.grayColor
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              totalLabeledValue??"",
              maxLines: 1,
              textAlign: TextAlign.right,
              style: AppTextStyle.body2.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.iconRed
              ),
            ),
          )
        ],
      ),
    );
  }
}
