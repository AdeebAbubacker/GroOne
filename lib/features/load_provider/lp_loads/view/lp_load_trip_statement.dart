import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/api_request/create_orderid_request.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/helper/lp_payment_helper.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/model/trip_statement_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import '../model/lp_load_get_by_id_response.dart';

class LpLoadSummaryScreen extends StatefulWidget {
  const LpLoadSummaryScreen({super.key, required this.loadId, required this.loadItem});

  final String loadId;
  final LoadData loadItem;

  @override
  State<LpLoadSummaryScreen> createState() => _LpLoadSummaryScreenState();
}

class _LpLoadSummaryScreenState extends State<LpLoadSummaryScreen> {
  final lpLoadCubit = locator<LpLoadCubit>();
  final vpLoadCubit = locator<LoadDetailsCubit>();

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(() {
    lpLoadCubit.getLpLoadsTripDetails(loadId: widget.loadId);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(context.appText.tripStatement, style: AppTextStyle.h4),
        centerTitle: true,
      ),

      body: BlocBuilder<LpLoadCubit, LpLoadState>(
        builder: (context, state) {
          final uiState = state.lpLoadTripDetails;

          if (uiState == null || uiState.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (uiState.status == Status.ERROR) {
            return genericErrorWidget(error: uiState.errorType,onRefresh: () async {  initFunction(); });
          }

          final TripDetails? tripDetails = uiState.data?.data;

          if (tripDetails == null) {
            return Text(context.appText.tripStatementIsEmpty).center();
          }

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  buildMainDetailWidget(tripDetails),
                  buildBankDetailsWidget(tripDetails),
                  buildTruckSupplierWidget(tripDetails),

                  20.height,
                  if (tripDetails.balanceToBePaid != '0.00')
                    LpPaymentHelper.buildPaymentActionButton(
                      context: context,
                      label: context.appText.payBalance,
                      showWarningIcon: false,
                      onPressed: () {
                        LpPaymentHelper.showPaymentMethodDialog(
                          context: context,
                          isLoading: lpLoadCubit.state.lpCreateOrder?.status == Status.LOADING,
                          onNeftTap: () {
                            LpPaymentHelper.showBankDetailsDialog(context, widget.loadItem.bankDetails);
                          },
                          onOnlineTap: () {
                            LpPaymentHelper.navigateToPaymentScreen(
                              context: context,
                              loadId: widget.loadItem.loadId,
                              lpLoadCubit: lpLoadCubit,
                              request: CreateOrderIdRequest(
                                memoid: widget.loadItem.loadMemoDetails?.id ?? '',
                                lpId: widget.loadItem.customer?.customerSeriesNo.toString() ?? '',
                                lpName: widget.loadItem.customer?.customerName ?? '',
                                lpEmailId: widget.loadItem.customer?.emailId ?? '',
                                lpMobile: widget.loadItem.customer?.mobileNumber ?? '',
                                vpId: widget.loadItem.vpCustomer?.customerSeriesNo.toString() ?? '',
                                loadSeriesId: widget.loadItem.loadSeriesId,
                                netFreight: widget.loadItem.loadMemoDetails?.netFreight ?? '',
                                advance: widget.loadItem.loadMemoDetails?.advance ?? '',
                                advancePercentage: widget.loadItem.loadMemoDetails?.advancePercentage ?? '',
                                balance: widget.loadItem.loadMemoDetails?.balance ?? '',
                                balancePercentage: widget.loadItem.loadMemoDetails?.balancePercentage ?? '',
                                vpAdvance: widget.loadItem.loadMemoDetails?.vpAdvance ?? '',
                                vpAdvancePercentage: widget.loadItem.loadMemoDetails?.vpAdvancePercentage ?? '',
                                vpBalance: widget.loadItem.loadMemoDetails?.vpBalance ?? '',
                                vpBalancePercentage: widget.loadItem.loadMemoDetails?.vpBalancePercentage ?? '',
                                amount: tripDetails.balanceToBePaid,
                                type: 'online',
                                action: 'balance',
                                vpAmount: widget.loadItem.loadMemoDetails?.vpAmount ?? ''
                              ),
                              onSuccess: () {
                                initFunction();
                              },
                            );
                          },
                        );
                      },
                    ),
                  if((tripDetails.invoiceUrl??"").isNotEmpty)
                  ...[
                    AppButton(
                      title: context.appText.downloadInvoice,
                      onPressed: () {
                        vpLoadCubit.downloadDocument(tripDetails.invoiceUrl??"",-1);
                      },
                    ),
                    10.height,
                  ],
                  40.height,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Main Details
  Widget buildMainDetailWidget(TripDetails details) {
    return Container(
      decoration: commonContainerDecoration(),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText(context.appText.trip),
          8.height,
          buildDetailRow(label: context.appText.loadId, value: details.loadId),
          buildDetailRow(label: context.appText.transporter, value: details.transporter.capitalize),
          buildDetailRow(label: context.appText.vehicleNumber, value: details.vehicleNumber),
          buildDetailRow(label: context.appText.memo, value: details.memoNumber),
          buildDetailRow(label: context.appText.lane, value: details.lane),
          20.height,
          buildDetailRow(
            label: context.appText.totalFreightCost,
            value: PriceHelper.formatINR(details.totalFreight),
          ),

          if(details.loading != '0.00' || details.unloading != '0.00' || details.detentions != '0.00')
            ...[
              20.height,
              buildHeadingText(context.appText.credits.toUpperCase()),
            ],
          8.height,

          if(details.loading != '0.00')
          buildDetailRow(
            label: context.appText.loadingCharges,
            value: '(+) ${PriceHelper.formatINR(details.loading)}',
            isPositive: true
          ),
          if(details.unloading != '0.00')
          buildDetailRow(
            label: context.appText.unloadingCharges,
            value: '(+) ${PriceHelper.formatINR(details.unloading)}',
            isPositive: true
          ),
          if(details.detentions != '0.00')
            buildDetailRow(
            label: context.appText.detentions.capitalizeFirst,
            value: '(+) ${PriceHelper.formatINR(details.detentions)}',
            isPositive: true
          ),


          if(details.handlingCharges != '0.00' || details.damages != '0.00' || details.shortages != '0.00' || details.penalties != '0.00')
            ...[
              20.height,
              buildHeadingText(context.appText.debits.toUpperCase()),
            ],
          8.height,
          if(details.handlingCharges != '0.00')
          buildDetailRow(
            label: context.appText.handlingCharges,
            value: '(-) ${PriceHelper.formatINR(details.handlingCharges)}',
            isNegative: true
          ),
          if(details.damages != '0.00')
          buildDetailRow(
            label: context.appText.damage,
            value: '(-) ${PriceHelper.formatINR(details.damages)}',
            isNegative: true
          ),
          if(details.shortages != '0.00')
          buildDetailRow(
            label: context.appText.shortages,
            value: '(-) ${PriceHelper.formatINR(details.shortages)}',
            isNegative: true
          ),
          if(details.penalties != '0.00')
          buildDetailRow(
            label: context.appText.penalties,
            value: '(-) ${PriceHelper.formatINR(details.penalties)}',
            isNegative: true
          ),
          20.height,

          buildHeadingText(context.appText.total.toUpperCase()),
          8.height,
          buildDetailRow(
            label: context.appText.netFreight,
            value: PriceHelper.formatINR(details.netFreight),
          ),
          buildDetailRow(
            label: context.appText.advance,
            value: PriceHelper.formatINR(details.advancePaid),
          ),
          buildDetailRow(
            label: context.appText.balanceToBePaid,
            value: PriceHelper.formatINR(details.balanceToBePaid),
            style: AppTextStyle.h3.copyWith(color: AppColors.primaryColor, fontSize: 20),
          ),
        ],
      ),
    );
  }

  /// Bank Details
  Widget buildBankDetailsWidget(TripDetails details) {
    final bank = details.bankDetails;
    return Container(
      decoration: commonContainerDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText(context.appText.bankDetails, isHeading: true),
          10.height,
          buildDetailRow(label: context.appText.beneficiaryName, value: bank?.beneficiaryName ?? ''),
          buildDetailRow(label: context.appText.bankName, value: bank?.bankName ?? ''),
          buildDetailRow(label: context.appText.accountNumber, value: bank?.accountNumber ?? ''),
          buildDetailRow(label: context.appText.ifscCode, value: bank?.ifscCode ?? ''),
          buildDetailRow(label: context.appText.branchName, value: bank?.branchName ?? ''),
        ],
      ),
    );
  }

  /// Truck Supplier Details
  Widget buildTruckSupplierWidget(TripDetails details) {
    final truck = details.truckSupplier;
    return Container(
      decoration: commonContainerDecoration(),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeadingText(context.appText.truckSupplier, isHeading: true),
          10.height,
          buildDetailRow(label: context.appText.partnerName, value: truck?.partnerName.capitalize ?? ''),
          buildDetailRow(label: context.appText.panNumber, value: truck?.panNumber ?? ''),
          buildDetailRow(label: context.appText.vehicleNumber, value: truck?.vehicleNumber ?? ''),
        ],
      ),
    );
  }

  Widget buildHeadingText(String text, {bool isHeading = false}) {
    return Text(
      text,
      style: AppTextStyle.h5.copyWith(
          color: isHeading ? AppColors.textBlackColor :  Color(0xff6a7282), fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildDetailRow({
    required String label,
    required String value,
    TextStyle? style,
    bool isNegative = false,
    bool? isPositive=false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.body3.copyWith(fontSize: 14)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              textAlign: TextAlign.right,
              style: AppTextStyle.body2.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color:(isPositive??false)?  AppColors.greenColor:
                isNegative ? AppColors.iconRed : AppTextStyle.body2.color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
