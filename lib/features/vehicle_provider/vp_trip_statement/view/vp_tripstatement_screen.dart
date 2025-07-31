import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/cubit/vp_trip_statement_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_trip_statement/model/trip_statement_response.dart';
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
  return Column(
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
  ).withScroll().expand();
  }

  /// Main Details
  Widget buildMainDetailWidget({required BuildContext context,TripStatementResponse? tripStatement}) {

    final numberOfDays = tripStatement?.loadSettlement?.noOfDays ?? 1;
    final amount = tripStatement?.loadSettlement?.amountPerDay ?? 1;
    final detentionsAmount = PriceHelper.formatINR(
      (amount * numberOfDays).toString(),
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
            value: tripStatement?.memoDetails?.loadId??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.transporter,
            value: tripStatement?.memoDetails?.transporter??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.vehicleNumber,
            value: tripStatement?.memoDetails?.vehicleNumber??"",
          ),
          buildDTripStatementWidget(
            label: "${context.appText.memo}#",
            value: tripStatement?.memoDetails?.memoNumber??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.lane,
            value: tripStatement?.memoDetails?.lane??"",
          ),
          buildDTripStatementWidget(
            label: "Total transportation cost",
            value: "Rs 30,000.00",
          ),

          buildDTripStatementWidget(
            label: "${context.appText.advance} (${tripStatement?.memoDetails?.advancePercentage??""}%)",
            value: tripStatement?.memoDetails?.advanceAmount??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.damageCharges,
            value: '(-) ${tripStatement?.loadSettlement?.debitDamages}',
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.shortages,
            value: '(-) ${tripStatement?.loadSettlement?.debitShortages}',
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.penalty,
            value: '(-) 0',
            isNegative: true,
          ),
          buildDTripStatementWidget(
            label: context.appText.loadingCharges,
            value: tripStatement?.loadSettlement?.loadingCharge.toString() ??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.unloadingCharges,
            value: tripStatement?.loadSettlement?.unloadingCharge.toString() ??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.detentions,
            value: detentionsAmount,
          ),
          buildDTripStatementWidget(
            label: "Advance Received",
            value: 'Rs 5,800.00',
          ),
          buildDTripStatementWidget(
            label: "Balance to be Received",
            value: 'Rs 5,800.00',
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
            value: tripStatement?.memoDetails?.truckSupplier?.partnerName??"",
          ),
          buildDTripStatementWidget(
            label: context.appText.destination,
            value: 'DPXP938650',
          ),
          buildDTripStatementWidget(
            label: context.appText.unloadingDate,
            value: 'DPXP938650',
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
