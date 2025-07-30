// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gro_one_app/data/model/result.dart';
// import 'package:gro_one_app/data/ui_state/status.dart';
// import 'package:gro_one_app/dependency_injection/locator.dart';
// import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
// import 'package:gro_one_app/features/load_provider/lp_loads/model/lp_load_memo_response.dart';
// import 'package:gro_one_app/features/load_provider/lp_loads/model/trip_statement_response.dart';
// import 'package:gro_one_app/helpers/price_helper.dart';
// import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
// import 'package:gro_one_app/utils/common_functions.dart';
// import 'package:gro_one_app/utils/extensions/state_extension.dart';
// import 'package:gro_one_app/utils/extensions/string_extensions.dart';
// import 'package:gro_one_app/utils/toast_messages.dart';
//
// import 'package:flutter/material.dart';
// import 'package:gro_one_app/utils/app_button.dart';
// import 'package:gro_one_app/utils/app_colors.dart';
// import 'package:gro_one_app/utils/app_dialog.dart';
// import 'package:gro_one_app/utils/app_text_style.dart';
// import 'package:gro_one_app/utils/common_widgets.dart';
// import 'package:gro_one_app/utils/extensions/int_extensions.dart';
//
// class LpLoadSummaryScreen extends StatefulWidget {
//   const LpLoadSummaryScreen({super.key});
//
//   @override
//   State<LpLoadSummaryScreen> createState() => _LpLoadSummaryScreenState();
// }
//
// class _LpLoadSummaryScreenState extends State<LpLoadSummaryScreen> {
//
//   final lpLoadLocator = locator<LpLoadCubit>();
//
//   @override
//   void initState() {
//     super.initState();
//     initFunction();
//   }
//
//   void initFunction() => frameCallback(() {
//     lpLoadLocator.getLpLoadsTripDetails();
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: Text(context.appText.tripStatement),
//         titleTextStyle: AppTextStyle.h4,
//         centerTitle: true,
//       ),
//
//       body: BlocBuilder<LpLoadCubit, LpLoadState>(
//           builder: (context, state) {
//
//             final uiState = state.lpLoadTripDetails;
//
//
//             if (uiState == null || uiState.status == Status.LOADING) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             // if (uiState.status == Status.ERROR) {
//             //   return genericErrorWidget(error: uiState.errorType);
//             // }
//
//             final data1 = uiState.data;
//
//             final data = TripStatementResponse.fromJson({
//               "memoDetails": {
//                 "loadId": "GD072500130",
//                 "transporter": "Neela transports ",
//                 "vehicleNumber": "N/A",
//                 "memoNumber": "17532480422752886",
//                 "lane": "Delhi - Bengaluru",
//                 "totalFreight": "Rs 65000.00",
//                 "handlingCharges": "Rs 1000.00",
//                 "netFreight": "Rs 64000.00",
//                 "advanceAmount": "Rs 51200.00",
//                 "advancePercentage": "80.00",
//                 "balancePercentage": "20.00",
//                 "balanceAmount": "Rs 12800.00",
//                 "bankDetails": {
//                   "beneficiaryName": "Gro Digital Platform",
//                   "bankName": "Axis Bank",
//                   "accountNumber": "7658036540837458",
//                   "ifscCode": "UT7346580NFJ",
//                   "branchName": "T.Nagar"
//                 },
//                 "truckSupplier": {
//                   "partnerName": "dhinesh VP",
//                   "vehicleNumber": "N/A",
//                   "panNumber": "2345454"
//                 }
//               },
//               "loadSettlement": {
//                 "settlementId": "42d24f80-6cce-4a3b-aba3-f02ca50f155c",
//                 "vehicleId": "0e25ce12-37e7-4380-8e29-bc31d5a7a291",
//                 "loadId": "6f30bdc8-31b2-4213-b0a3-7fe300fef134",
//                 "noOfDays": 1,
//                 "amountPerDay": 3,
//                 "loadingCharge": 3,
//                 "unloadingCharge": 2,
//                 "debitDamages": 4,
//                 "debitShortages": 3,
//                 "debitPenalities": 4,
//                 "createdAt": "2025-07-29T07:23:16.027Z",
//                 "updatedAt": "2025-07-29T07:23:28.523Z",
//                 "deletedAt": null
//               }
//             });
//
//             return Padding(
//               padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
//               child: SingleChildScrollView(
//                 child: Column(
//                   spacing: 10,
//                   children: [
//                    buildMainDetailWidget(data),
//                     buildBankDetailsWidget(data),
//                     buildTruckSupplierWidget(data),
//
//                       20.height,
//                       AppButton(
//                         title: context.appText.payBalance,
//                         onPressed: () {
//                           // Your pay balance logic
//                         },
//                       ),
//                     40.height,
//                 ]
//
//
//                 ),
//               ),
//             );
//           }
//       ),
//     );
//   }
//
//   /// Main Details
//   Widget buildMainDetailWidget(TripStatementResponse memoDetails) {
//     var detention = (memoDetails.loadSettlement?.amountPerDay ?? 0) * (memoDetails.loadSettlement?.noOfDays ?? 0);
//     return Container(
//       decoration: commonContainerDecoration(),
//       padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 20,
//         children: [
//           buildHeadingText(context.appText.mainDetails),
//           buildDMemoDetailWidget(label: context.appText.loadId, value: memoDetails.memoDetails?.loadId ?? ''),
//           buildDMemoDetailWidget(label: context.appText.transporter, value: memoDetails.memoDetails?.transporter ?? ''),
//           buildDMemoDetailWidget(label: context.appText.vehicleNumber, value: memoDetails.memoDetails?.vehicleNumber ?? ''),
//           buildDMemoDetailWidget(label: context.appText.memo, value: memoDetails.memoDetails?.memoNumber ?? ''),
//           buildDMemoDetailWidget(label: context.appText.lane, value: memoDetails.memoDetails?.lane ?? ''),
//           buildDMemoDetailWidget(label: context.appText.totalFreight, value: PriceHelper.formatINR(memoDetails.memoDetails?.totalFreight, symbol: 'Rs ')),
//           // buildDMemoDetailWidget(label: context.appText.handlingCharges, value:' (-)   ${PriceHelper.formatINR(memoDetails.handlingCharges, symbol: 'Rs ')}'),
//           buildDMemoDetailWidget(label: context.appText.netFreight, value: PriceHelper.formatINR(memoDetails.memoDetails?.netFreight, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: "${context.appText.advance} (${memoDetails.memoDetails?.advancePercentage.split('.').first}%)", value: PriceHelper.formatINR(memoDetails.memoDetails?.advanceAmount, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: 'Loading Charges', value: PriceHelper.formatINR(memoDetails.loadSettlement?.loadingCharge, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: 'Unloading Charges', value: PriceHelper.formatINR(memoDetails.loadSettlement?.unloadingCharge, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: 'Detentions', value: PriceHelper.formatINR(detention, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: context.appText.handlingCharges, value: PriceHelper.formatINR(memoDetails.memoDetails?.handlingCharges, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: 'Damage charges', value: PriceHelper.formatINR(memoDetails.loadSettlement?.debitDamages, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: 'Shortages', value: PriceHelper.formatINR(memoDetails.loadSettlement?.debitShortages, symbol: 'Rs ')),
//           buildDMemoDetailWidget(label: 'Penalty', value: PriceHelper.formatINR(memoDetails.loadSettlement?.debitPenalities, symbol: 'Rs ')),
//           Divider(),
//           buildDMemoDetailWidget(label: 'Balance to be paid', value: PriceHelper.formatINR(memoDetails.memoDetails?.balanceAmount, symbol: 'Rs ')),
//
//         ],
//       ),
//     );
//   }
//
//   /// Bank Details
//   Widget buildBankDetailsWidget(dynamic data) {
//     final bank = data.memoDetails.bankDetails;
//     return Container(
//       decoration: commonContainerDecoration(),
//       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 20,
//         children: [
//           buildHeadingText(context.appText.bankDetails),
//           buildDMemoDetailWidget(label: context.appText.beneficiaryName, value: bank?.beneficiaryName ?? ''),
//           buildDMemoDetailWidget(label: context.appText.bankName, value: bank?.bankName ?? ''),
//           buildDMemoDetailWidget(label: context.appText.accountNumber, value: bank?.accountNumber ?? ''),
//           buildDMemoDetailWidget(label: context.appText.ifscCode, value: bank?.ifscCode ?? ''),
//           buildDMemoDetailWidget(label: context.appText.branchName, value: bank?.branchName ?? ''),
//         ],
//       ),
//     );
//   }
//
//
//   /// Truck Supplier Details
//   Widget buildTruckSupplierWidget(dynamic data) {
//     final truck = data.memoDetails.truckSupplier;
//     return Container(
//       decoration: commonContainerDecoration(),
//       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 20,
//         children: [
//           buildHeadingText(context.appText.truckSupplier),
//           buildDMemoDetailWidget(label: context.appText.partnerName, value: truck?.partnerName.toString().capitalizeFirst ?? ''),
//           buildDMemoDetailWidget(label: context.appText.vehicleNumber, value: truck?.vehicleNumber ?? ''),
//         ],
//       ),
//     );
//   }
//
//
//   Widget buildHeadingText(String text) {
//     return Text(
//       text,
//       style: AppTextStyle.h5.copyWith(color: AppColors.textBlackColor, fontWeight: FontWeight.w700),
//     );
//   }
//
//   Widget buildDMemoDetailWidget({required String label, required String value}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(label, style: AppTextStyle.body3),
//         Text(value, style: AppTextStyle.body2),
//       ],
//     );
//   }
// }
