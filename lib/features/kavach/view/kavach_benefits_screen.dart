// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gro_one_app/features/kavach/view/kavach_models_screen.dart';
// import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
// import 'package:gro_one_app/utils/app_application_bar.dart';
// import 'package:gro_one_app/utils/app_button_style.dart';
// import 'package:gro_one_app/utils/app_colors.dart';
// import 'package:gro_one_app/utils/app_icon_button.dart';
// import 'package:gro_one_app/utils/app_icons.dart';
// import 'package:gro_one_app/utils/app_image.dart';
// import 'package:gro_one_app/utils/app_route.dart';
// import 'package:gro_one_app/utils/app_text_style.dart';
// import 'package:gro_one_app/utils/common_widgets.dart';
// import 'package:gro_one_app/utils/constant_variables.dart';
// import 'package:gro_one_app/utils/extensions/int_extensions.dart';
// import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
//
// class KavachBenefitsScreen extends StatelessWidget {
//   const KavachBenefitsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBarWidget(context),
//       body: buildBodyWidget(context),
//     );
//   }
//
//   // Appbar
//   PreferredSizeWidget buildAppBarWidget(BuildContext context){
//     return CommonAppBar(
//         title: context.appText.kavach,
//       actions: [
//         AppIconButton(
//             onPressed: ()=> Navigator.of(context).push(commonRoute(KavachModelsScreen())),
//             icon: Icon(Icons.add, color: Colors.white),
//             style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
//         ),
//
//         // Support Button
//         AppIconButton(onPressed: (){}, icon: AppIcons.svg.support,  style: AppButtonStyle.circularIconButtonStyle),
//         10.width,
//       ],
//     );
//   }
//
//   // Body
//   Widget buildBodyWidget(BuildContext context){
//     return SafeArea(
//       bottom: false,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           buildKavachProductImageWidget(),
//           buildKavachBenefitsDetailsWidget(context),
//           buildGroBannerImageWidget()
//         ],
//       ),
//     );
//   }
//
//   Widget buildKavachProductImageWidget(){
//     return Container(
//       width: double.infinity,
//         height: 200,
//         color: AppColors.lightPrimaryColor,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Image.asset(AppImage.png.truck, width: 150),
//             Image.asset(AppImage.png.kavachProduct, width: 70).paddingOnly(top: 80, right: 140),
//           ],
//         ),
//     );
//   }
//
//
//   Widget buildKavachBenefitsDetailsWidget(BuildContext context){
//
//     Widget innerUIWidget({required String icon,required String title, required String subTitle}){
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Icon
//           Container(
//             decoration: commonContainerDecoration(
//               color: AppColors.lightPrimaryColor,
//                 borderRadius: BorderRadius.circular(100),
//                 borderColor: AppColors.primaryColor
//             ),
//               child: Image.asset(icon, width: 25).paddingAll(15),
//           ),
//           15.width,
//
//           // Heading or SubHeading
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: AppTextStyle.h5),
//               5.height,
//               Text(subTitle, style: AppTextStyle.body3)
//             ],
//           ).expand()
//         ],
//       );
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(context.appText.benefitsOfKavach, style: AppTextStyle.body1),
//         20.height,
//         innerUIWidget(icon: AppIcons.png.lockAndKey, title: context.appText.benefitsOfKavachHeading1, subTitle: context.appText.benefitsOfKavachSubHeading1),
//         20.height,
//         innerUIWidget(icon: AppIcons.png.insightGraph, title: context.appText.benefitsOfKavachHeading1, subTitle: context.appText.benefitsOfKavachSubHeading1),
//       ],
//     ).paddingSymmetric(horizontal: commonSafeAreaPadding);
//   }
//
//   Widget buildGroBannerImageWidget(){
//     return Image.asset(AppImage.png.groBanner);
//   }
//
// }
