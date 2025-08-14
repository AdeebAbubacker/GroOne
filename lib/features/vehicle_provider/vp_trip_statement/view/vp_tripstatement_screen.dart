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
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(title: context.appText.tripStatement),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
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
  Widget buildMainDetailWidget({required BuildContext context,TripStatementResponse? tripStatement}) {
    TripStatementData? statementData= tripStatement?.data;
    final detentionsAmount = PriceHelper.formatINR(
      statementData?.detentions.toString(),
    );

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
          buildDTripStatementWidget(
            label: context.appText.totalTransportationCost,
            value: PriceHelper.formatINR(  tripStatement?.data?.totalTransportationCost??""),


          ),

          buildDTripStatementWidget(
            label: "${context.appText.advance} (${statementData?.advancePercentage??""}%)",
            value: PriceHelper.formatINR(  statementData?.advanceAmount??""),
          ),

          buildDTripStatementWidget(
            label: context.appText.damageCharges,
            value: '(-) ${PriceHelper.formatINR( statementData?.damages??"")}',
            isNegative: true
          ),

          buildDTripStatementWidget(
            label: context.appText.shortages,
            value:"(-) ${PriceHelper.formatINR( statementData?.shortages??"")}",
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.penalty,
            value: '(-) ${PriceHelper.formatINR(statementData?.penalties??"")}',
            isNegative: true,
          ),

          buildDTripStatementWidget(
            label: "${context.appText.platformFee } + ${statementData?.platformFeeGstPercentage}% ${context.appText.gst}",
            value: '(-) ${PriceHelper.formatINR(statementData?.platformFeeWithGst??"")}',
            isNegative: true,
          ),

          buildDTripStatementWidget(
            label: context.appText.loadingCharges,
            value: PriceHelper.formatINR(statementData?.loading??""),
          ),

          buildDTripStatementWidget(
            label: context.appText.unloadingCharges,
            value: PriceHelper.formatINR( statementData?.unloading??"")
          ),

          buildDTripStatementWidget(
            label: context.appText.detentions,
            value: detentionsAmount,
          ),
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
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          buildHeadingText(context.appText.loadProvider),
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
            value:  DateTimeHelper.formatCustomDateIST(
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
               color: isNegative ? AppColors.iconRed : AppTextStyle.body2.color,
            ),
          ),
        )
      ],
    );
  }
}
