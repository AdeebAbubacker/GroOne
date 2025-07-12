// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/swipe_button_widget.dart';
// import 'package:gro_one_app/features/trip_tracking/widgets/load_timeline_widget.dart';
// import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
// import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
// import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
// import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
// import 'package:gro_one_app/utils/app_button.dart';
// import 'package:gro_one_app/utils/app_button_style.dart';
// import 'package:gro_one_app/utils/app_colors.dart';
// import 'package:gro_one_app/utils/app_icons.dart';
// import 'package:gro_one_app/utils/app_image.dart';
// import 'package:gro_one_app/utils/app_multiline_textfield.dart';
// import 'package:gro_one_app/utils/app_text_field.dart';
// import 'package:gro_one_app/utils/app_text_style.dart';
// import 'package:gro_one_app/utils/common_widgets.dart';
// import 'package:gro_one_app/utils/constant_variables.dart';
// import 'package:gro_one_app/utils/extensions/int_extensions.dart';
// import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
// import 'package:gro_one_app/utils/upload_attachment_files.dart';
// import 'package:gro_one_app/utils/validator.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';

// class DriverLoadBottomWidget extends StatelessWidget {

//   const DriverLoadBottomWidget({
//     super.key,
//   });


//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//          bottom: 0,
//             left: 0,
//             right: 0,
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.55,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 30,
//               offset: const Offset(0, -2),
//             ),
//           ],
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               40.height,
//               _buildRequestWidget(),
//               20.height,
//               _buildProgressEtaWidget(
//                 context: context,
//                 progressPercentage: 6,
//                 remainingDistance: "250 KMs",
//                 totalDistance: "456KMs",
//                 eta: "31-09-2024, 09:30 PM",
//               ).paddingSymmetric(horizontal: 15),
//               20.height,
//               _buildAdvancePaymentCard(context: context, paymentState: 2),
//               20.height,
//               _buildDivider(),
//               20.height,
//               _buildConsigneeDetail(
//                 context: context,
//                 name: 'dd',
//                 email: 'd',
//                 phoneNo: '6587443',
//                 isUpdatable: true,
//                 isTextField: true,
//               ),
//               20.height,
//               _buildDivider(),
//               20.height,
//               Text(
//                 context.appText.tripdocument,
//                 style: AppTextStyle.h4,
//               ).paddingSymmetric(horizontal: 15),
//               20.height,
//               Column(
//                 children: [
//                   // Upload Lorrry Receipt
//                   UploadAttachmentFiles(
//                     multiFilesList: [],
//                     isSingleFile: true,
//                     isLoading: false,
//                     hideDeleteButton: false,
//                     hintText: context.appText.uploadLorryReceipt,
//                     isSpaceBetwenUpload: true,
//                   ),
                
//                   20.height,
                
//                   // Upload E-way bill
//                   UploadAttachmentFiles(
//                     multiFilesList: [],
//                     isSingleFile: true,
//                     isLoading: false,
//                     hideDeleteButton: false,
//                     hintText: context.appText.uploadEwayBill,
//                     isSpaceBetwenUpload: true,
//                   ),
                
//                   20.height,
                
//                   // Upload Material Invoice
//                   UploadAttachmentFiles(
//                     multiFilesList: [],
//                     isSingleFile: true,
//                     isLoading: false,
//                     hideDeleteButton: false,
//                     hintText: context.appText.uploadMaterialInvoice,
//                     isSpaceBetwenUpload: true,
//                   ),
                
//                   20.height,
                
//                   // Upload Other documents
//                   UploadAttachmentFiles(
//                     multiFilesList: [],
//                     isSingleFile: true,
//                     isLoading: false,
//                     hideDeleteButton: false,
//                     hintText: context.appText.uploadOtherDocs,
//                     isSpaceBetwenUpload: true,
//                   ),
//                 ],
//               ).paddingSymmetric(horizontal: 15),
//               20.height,
//               _buildDivider(),
//               _buildLoadProviderAdvancePaymentCardViewOnly(
//                 tripPrice: '₹ 3500',
//                 advancePayment: '₹ 79000',
//                 agreedAdvance: '₹ 8000',
//                 agreedPrice: '₹ 5000',
//                 balancePayment: '₹ 10000',
//                 context: context,
//                 paymentStatus: 3,
//               ),
//               20.height,
//               _buildFeedbackRemarksWidget(
//                 context: context,
//                 controller: TextEditingController(),
//               ),
//               20.height,
//               _buildHeading(text: 'a'),
//               20.height,
                
//             //  _buildBottomButtonWidget(loadDetails, state, context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Build Request Widget

// Widget _buildRequestWidget() {
//   return SizedBox(
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset(AppImage.png.dummyTruckLoad, width: 57, height: 42),
//         10.width,
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xffFFC100),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: const Text(
//                     "RJ14GA1234",
//                   ).paddingSymmetric(vertical: 2, horizontal: 5),
//                 ),
//                 5.width,
//                 Text("Open", style: AppTextStyle.body3),
//                 5.width,
//                 Text("(19ft)", style: AppTextStyle.body3),
//               ],
//             ),

//             8.height,

//             Row(
//               children: [
//                 Text("Driver:", style: AppTextStyle.body3),
//                 const Text(
//                   " Ishwar Parihar",
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF343434),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: () => print("Calling 9876543210"),
//           child: Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: AppColors.blueColor,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.phone,
//               color: AppColors.defaultIconTint,
//               size: 24,
//             ),
//           ),
//         ),
//       ],
//     ),
//   ).paddingSymmetric(horizontal: 15);
// }

// // Source Destination Widget
// Widget _buildSourceDestinationWidget(
//   BuildContext context,
//   bool isAccepted,
//   LoadDetails? loadDetails,
// ) {
//   return AnimatedContainer(
//     height: isAccepted ? 190 : 200,

//     padding: EdgeInsets.symmetric(vertical: 13),
//     decoration: commonContainerDecoration(
//       color: AppColors.backGroundBlue,
//       borderColor: AppColors.disableColor,
//       borderRadius: BorderRadius.circular(8),
//     ),

//     duration: Duration(milliseconds: 300),
//     child: Column(
//       children: [
//         if (isAccepted)
//           Container(
//             height: 30,

//             padding: EdgeInsets.symmetric(horizontal: 10),

//             decoration: commonContainerDecoration(
//               color: Color(0xffE5EBFF),
//               borderRadius: BorderRadius.circular(6),
//             ),

//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "LP: Nestle India Pvt ltd",
//                 style: AppTextStyle.h3.copyWith(
//                   fontWeight: FontWeight.w100,
//                   fontSize: 13,

//                   color: AppColors.primaryColor,
//                 ),
//               ),
//             ),
//           ).paddingSymmetric(horizontal: 13),
//         10.height,

//         Row(
//           children: [
//             Column(
//               spacing: 3,
//               children: [
//                 SvgPicture.asset(
//                   AppIcons.svg.myLocation,
//                   height: 18,
//                   width: 18,
//                 ),
//                 ...List.generate(
//                   8,
//                   (index) => Container(
//                     height: 3,
//                     width: 1,
//                     color: AppColors.dividerColor,
//                   ),
//                 ),
//                 SvgPicture.asset(
//                   AppIcons.svg.markerLocation,
//                   height: 18,
//                   width: 18,
//                 ),
//               ],
//             ).expand(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   spacing: 5,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       context.appText.source,
//                       style: AppTextStyle.h3w500.copyWith(
//                         color: AppColors.textBlackColor,
//                         fontSize: 14,

//                         fontWeight: FontWeight.w200,
//                       ),
//                     ),
//                     Text(
//                       "${loadDetails?.pickUpLocation}",
//                       maxLines: 3,
//                     ).expand(),
//                   ],
//                 ).expand(),
//                 commonDivider(),
//                 Column(
//                   spacing: 5,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       context.appText.destination,
//                       style: AppTextStyle.h3w500.copyWith(
//                         color: AppColors.textBlackColor,
//                         fontSize: 14,

//                         fontWeight: FontWeight.w200,
//                       ),
//                     ),
//                     Text("${loadDetails?.dropLocation}"),
//                   ],
//                 ).expand(),
//               ],
//             ).expand(flex: 7),
//           ],
//         ).expand(),
//       ],
//     ),
//   ).paddingSymmetric(horizontal: 15);
// }

// // Load Entity Widget
// Widget _buildLoadEntityWidget(LoadDetails? loadDetails) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     spacing: 15,

//     children: [
//       Row(
//         spacing: 3,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(AppIcons.svg.package, height: 24, width: 24),
//           Text(
//             loadDetails?.commodity?.name ?? "",
//             style: AppTextStyle.bodyGreyColorW500.copyWith(
//               color: AppColors.veryLightGreyColor,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),

//       Row(
//         spacing: 3,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             AppIcons.svg.kgWeight,
//             height: 24,
//             width: 24,
//             colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
//           ),

//           Text(
//             "${loadDetails?.consignmentWeight} Ton",
//             style: AppTextStyle.bodyGreyColorW500.copyWith(
//               color: AppColors.veryLightGreyColor,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),

//       Row(
//         spacing: 3,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             AppIcons.svg.locationDistance,
//             height: 24,
//             width: 24,
//           ),

//           Text(
//             "534 KM",
//             style: AppTextStyle.bodyGreyColorW500.copyWith(
//               color: AppColors.veryLightGreyColor,
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     ],
//   ).paddingSymmetric(horizontal: 15);
// }

// // Bottom Button
// Widget _buildBottomButtonWidget(
//   LoadDetails? loadDetails,
//   LoadDetailsState state,
//   BuildContext context,
// ) {
//   return Container(
//     decoration: commonContainerDecoration(
//       color: Colors.white,
//       blurRadius: 30,
//       shadow: true,
//     ),
//     child: Row(
//       spacing: 10,
//       children: [
//         ...[
//           if (state.loadStatus == LoadStatus.matching)
//             AppButton(
//               title: context.appText.support,
//               style: AppButtonStyle.outline.copyWith(
//                 shape: WidgetStatePropertyAll(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               onPressed: () {},
//               textStyle: TextStyle(fontSize: 14),
//             ).expand(),

//           SizedBox(
//             height: 60,
//             width: MediaQuery.of(context).size.width * 0.90,
//             child: CustomSwipeButton(
//               padding: 0,
//               price: 0,
//               loadId: "",
//               text: "d",
//               onSubmit: () {
//                 return null;
//               },
//             ),
//           ),
//         ],
//       ],
//     ).paddingSymmetric(horizontal: 15, vertical: 12),
//   );
// }



// // Divider
// Widget _buildDivider() {
//   return Divider(color: AppColors.bottomSheetDividerColor, thickness: 3);
// }


// // Heading
// Widget _buildHeading({required String text}) {
//   return Text(text, style: AppTextStyle.h4).paddingSymmetric(horizontal: 15);
// }


// //Payment View only
// Widget _buildLoadProviderAdvancePaymentCardViewOnly({
//   required BuildContext context,
//   String? tripPrice,
//   String? agreedPrice,
//   required String agreedAdvance,
//   String? advancePayment,
//   String? balancePayment,
//   required int paymentStatus,
//   VoidCallback? onViewTap,
// }) {
//   return Container(
//     margin: const EdgeInsets.all(16),
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFFF7F9FC),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (paymentStatus == 1 && tripPrice != null)
//           _buildPriceRow(
//             context.appText.tripPrice,
//             tripPrice,
//             context,
//             highlight: true,
//           ),
//         if (paymentStatus == 2 || paymentStatus == 3)
//           _buildPriceRow(
//             context.appText.agreedPrice,
//             agreedPrice ?? '',
//             context,
//             highlight: true,
//           ),
//         8.height,
//         _buildPriceRow(
//           context.appText.agreedAdvance,
//           agreedAdvance,
//           context,
//           highlight: true,
//         ),
//         12.height,

//         if (paymentStatus == 2 || paymentStatus == 3)
//           _buildStatusRow(
//             title: '${context.appText.advancePayment} (80%)',
//             amount: advancePayment ?? "",
//             statusText: context.appText.received,
//             statusColor: AppColors.lightGreenBox, // (125, 255, 159)
//           ),

//         if (paymentStatus == 3)
//           Padding(
//             padding: const EdgeInsets.only(top: 12),
//             child: _buildStatusRow(
//               title: context.appText.balancePayment,
//               amount: balancePayment ?? "",
//               statusText: context.appText.received,
//               statusColor: AppColors.lightGreenBox, // (125, 255, 159)
//             ),
//           ),

//         12.height,
//         Align(
//           alignment: Alignment.center,
//           child: GestureDetector(
//             onTap: onViewTap,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   context.appText.view,
//                   style: AppTextStyle.body.copyWith(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 const Icon(
//                   Icons.chevron_right,
//                   size: 25,
//                   color: AppColors.black,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Status Details
// Widget _buildStatusRow({
//   required String title,
//   required String amount,
//   required String statusText,
//   required Color statusColor,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         title,
//         style: AppTextStyle.body.copyWith(
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//           color: AppColors.darkDividerColor,
//         ),
//       ),
//       6.height,
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             amount,
//             style: AppTextStyle.body.copyWith(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: AppColors.textBlackColor,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: statusColor,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               statusText,
//               style: AppTextStyle.textBlackColor12w400.copyWith(
//                 color: AppColors.textGreen,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }





// // Advance Payment Card
// Widget _buildAdvancePaymentCard({
//   required BuildContext context,
//   required int paymentState,
// }) {
//   return Container(
//     padding: const EdgeInsets.all(10),
//     decoration: BoxDecoration(
//       color: const Color(0xFFEAF5FF),
//     borderRadius: BorderRadius.circular(commonPadding),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Agreed Price
//         _buildPriceRow(context.appText.agreedPrice, "₹ 79,000", context),
//         const SizedBox(height: 8),

//         // Payable Advance Row with Status
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   context.appText.payableAdvance,
//                   style: AppTextStyle.body2.copyWith(
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.textBlackColor,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 if (paymentState == 2)
//                   Row(
//                     children: [
//                       const Icon(Icons.error, size: 16, color: AppColors.iconRed),
//                       const SizedBox(width: 4),
//                      Text(
//                      context.appText.pending,
//                      style: AppTextStyle.body.copyWith(
//                      fontSize: 10,
//                      color: AppColors.iconRed,
//                         ),
//                        ),
//                     ],
//                   )
//                 else if (paymentState == 3)
//                  Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 2,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.boxGreen,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text( 
//                       context.appText.paid,
//                       style: AppTextStyle.body.copyWith(
//                       fontSize: 12,
//                       color: AppColors.greenColor, 
//                      fontWeight: FontWeight.w500,
// )

//                     ),
//                   ),
//               ],
//             ),
//             Flexible(
//               child: Text(
//                 "₹ 70,000",
//                 style: AppTextStyle.body1GreyColor.copyWith(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textGreyDetailColor,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 8),

//         // Payable Balance (only if paymentState is 2 or 3)
//         if (paymentState == 3)
//           _buildPriceRow(
//             context.appText.payableBalance,
//             "₹ 9,000",
//             context,
//             highlight: true,
//           ),

//         const SizedBox(height: 12),

//         // Action Button
//         if (paymentState == 1)
//           AppButton(
//             isLoading: false,
//             title: context.appText.payAdvance,
//             onPressed: () {},
//           )
//         else if (paymentState == 2)
//           AppButton(
//             isLoading: false,
//             title: context.appText.payAdvance,
//             onPressed: () {},
//             richTextWidget: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SvgPicture.asset(
//                   AppIcons.svg.alertWarning,
//                   height: 18,
//                   width: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   context.appText.payAdvance,
//                   style: AppTextStyle.buttonWhiteTextColor,
//                 ),
//               ],
//             ),
//           )
//         else if (paymentState == 3)
//           AppButton(
//             isLoading: false,
//             title: context.appText.payAdvance,
//             onPressed: () {},
//             richTextWidget: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   context.appText.payBalance,
//                   style: AppTextStyle.buttonWhiteTextColor,
//                 ),
//               ],
//             ),
//           ),
//       ],
//     ),
//   );
// }


// // Prcie Row
// Widget _buildPriceRow(
//   String label,
//   String amount,
//   BuildContext context, {
//   bool highlight = false,
// }) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         label,
//         style: AppTextStyle.body2.copyWith(
//           fontWeight: FontWeight.w400,
//           color: AppColors.textBlackColor,
//         ),
//       ),
//       Flexible(
//         child: Text(
//           amount,
//           style: AppTextStyle.body1GreyColor.copyWith(
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color:
//                 highlight
//                     ? AppColors.primaryColor
//                     : AppColors.textGreyDetailColor,
//           ),
//         ),
//       ),
//     ],
//   );
// }


// // Consignee Details
// Widget _buildConsigneeDetail({
//   required BuildContext context,
//    String? name,
//    String? phoneNo,
//    String? email,
//   bool isTextField = false,
//   bool isUpdatable = false,
//   TextEditingController? nameController,
//   TextEditingController? phoneController,
//   TextEditingController? emailController,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           Text(context.appText.consigneeDetails, style: AppTextStyle.h4),
//           Spacer(),
//           if (isUpdatable)
//            AppButton(
//            title: context.appText.update,
//            style: AppButtonStyle.outlineShrink,
//            textStyle: AppTextStyle.buttonPrimaryColorTextColor,
//            onPressed: () {},
//           ),
//         ],
//       ),
//       if (isTextField)
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             20.height,
//             // Name
//             AppTextField(
//               validator: (value) => Validator.fieldRequired(value),
//               controller: nameController,
//               labelText: context.appText.name,
//               mandatoryStar: true,
//             ),
//             20.height,
//             // Contact Number
//             AppTextField(
//               validator: (value) => Validator.fieldRequired(value),
//               controller: phoneController,
//               labelText: context.appText.contactNumber,
//               mandatoryStar: true,
//             ),
//             20.height,
//             AppTextField(
//               validator: (value) => Validator.fieldRequired(value),
//               controller: emailController,
//               labelText: context.appText.emailId,
//               mandatoryStar: false,
//             ),
//           ],
//         )
//       else
//         Column(
//           children: [
//             20.height,
//             // Contact Name
//             _buildDetailWidget(text1: context.appText.name, text2: name ?? ""),

//             20.height,

//             // Contact Number
//             _buildDetailWidget(text1: context.appText.contactNo, text2: phoneNo ?? ""),
//             20.height,

//             // Email Id
//             _buildDetailWidget(text1: context.appText.emailId, text2: email ?? ""),
//           ],
//         ),
//     ],
//   );
// }

// // Detail Widget
// Widget _buildDetailWidget({required String text1, required String text2}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         text1,
//         style: AppTextStyle.body2.copyWith(color: AppColors.textBlackColor),
//       ),
//       Text(
//         text2,
//         style: AppTextStyle.body2.copyWith(
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF003CFF),
//         ),
//       ),
//     ],
//   );
// }


// // Doc Preview
// Widget _buildUploadedDocPreviewItem({
//   required String fileTitle,
//   required String dateTime,
//   required bool isFileAvailable,
//   required bool isDownloadable,
//   required String fileUrl,
//   required BuildContext context,
// }) {
//   Future<void> downloadAndOpenFile(String url) async {
//     try {
//       final fileName = path.basename(url);
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = path.join(directory.path, fileName);

//       final dio = Dio();
//       await dio.download(url, filePath);

//       await OpenFilex.open(filePath);
//     } catch (e) {
//       debugPrint("Error downloading/opening file: $e");
//     }
//   }

//   return Container(
//     height: 55,
//     width: double.infinity,
//     margin:  EdgeInsets.symmetric(vertical: 5),
//     padding:  EdgeInsets.symmetric(horizontal: 12),
//     decoration: BoxDecoration(
//       color: AppColors.docViewCardBgColor,
//       borderRadius: BorderRadius.circular(commonTexFieldRadius),
//     ),
//     child: Row(
//       children: [
//         SvgPicture.asset(
//           AppIcons.svg.documentView,
//           width: 22,
//           height: 22,
//           colorFilter: AppColors.svg(
//             isFileAvailable ? AppColors.primaryColor : AppColors.iconRed,
//           ),
//         ),
//         10.width,
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               isFileAvailable ? fileTitle : context.appText.fileNotFound,
//               style: AppTextStyle.body.copyWith(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color:
//                     isFileAvailable
//                         ? AppColors.textBlackColor
//                         : AppColors.iconRed,
//               ),
//             ),
//             4.height,
//             Text(
//               dateTime,
//               style: AppTextStyle.body.copyWith(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 10,
//                 color: AppColors.textGreyColor,
//               ),
//             ),
//           ],
//         ).expand(),

//         if (isFileAvailable && isDownloadable)
//           IconButton(
//             icon: Icon(
//               Icons.download_rounded,
//               size: 20,
//               color: AppColors.primaryColor,
//             ),
//             onPressed: () => downloadAndOpenFile(fileUrl),
//           ),
//       ],
//     ),
//   );
// }


// // Travel Progress Details
// Widget _buildProgressEtaWidget({
//   required BuildContext context,
//   required double progressPercentage,
//   required String remainingDistance,
//   required String totalDistance,
//   required String eta,
// }) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Radial Progress
//       Stack(
//         alignment: Alignment.center,
//         children: [
//           SizedBox(
//             width: 40,
//             height: 40,
//             child: CircularProgressIndicator(
//               value: progressPercentage / 100,
//               strokeWidth: 4,
//               backgroundColor: Colors.grey.shade200,
//               valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
//             ),
//           ),
//           Text(
//             "${progressPercentage.toInt()}%",
//             style: AppTextStyle.radialProgressText,
//           ),
//         ],
//       ),

//       const SizedBox(width: 12),

//       // Main content with distance/ETA
//       Expanded(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Remaining Distance
//             Flexible(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     context.appText.remainingDistance,
//                     style: AppTextStyle.body3SoftGrey,
//                   ),
//                   const SizedBox(height: 4),
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: remainingDistance,
//                           style: AppTextStyle.body2.copyWith(
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' / $totalDistance',
//                           style: AppTextStyle.textDarkGreyColor14w400.copyWith(
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Vertical Divider
//             Container(
//               width: 1,
//               height: 35,
//               color: Colors.grey.shade300,
//               margin: const EdgeInsets.symmetric(horizontal: 12),
//             ),

//             // ETA
//             Flexible(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     context.appText.estArrivalTime,
//                     style: AppTextStyle.body3SoftGrey,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(eta, style: AppTextStyle.body3),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }


// // Feedback and Remarks Widget
// Widget _buildFeedbackRemarksWidget({
//   required BuildContext context,
//   required TextEditingController controller,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       /// Header Row
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "${context.appText.feedback} / ${context.appText.remarks}",
//             style: AppTextStyle.h4,
//           ),
//            AppButton(
//            title: context.appText.update,
//            style: AppButtonStyle.outlineShrink,
//            textStyle: AppTextStyle.buttonPrimaryColorTextColor,
//            onPressed: () {},
//           ),
//         ],
//       ),

//       10.height,

//       /// Multiline TextField
//       AppMultilineTextField(controller: controller,hintText: context.appText.enterRemarks,),
//     ],
//   );
// }
