import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/kavach/helper/product_counter.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../bloc/kavach_list_bloc/kavach_list_bloc.dart';
import '../../bloc/kavach_list_bloc/kavach_list_event.dart';
import '../../model/kavach_product.dart';

// class KavachModelsListBody extends StatelessWidget {
//   const KavachModelsListBody({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: commonContainerDecoration(borderColor: AppColors.borderColor),
//       child: Row(
//         children: [
//           // Kavach Image
//           Image.asset(AppImage.png.kavachProduct, width: 80),
//           10.width,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Model Name
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text("eN-Dhan Kavach", style: AppTextStyle.h5),
//                   5.width,
//                   SvgPicture.asset(AppIcons.svg.infOutline, width: 15, colorFilter: AppColors.svg(AppColors.greyIconColor),)
//                 ],
//               ),
//               Text("CS01K0001", style: AppTextStyle.bodyGreyColor),
//
//               5.height,
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("$indianCurrencySymbol 1,499", style: AppTextStyle.h4PrimaryColor),
//                       Text(context.appText.excludingGST, style: AppTextStyle.body4GreyColor),
//                     ],
//                   ).expand(),
//
//                   // Counter
//                   ProductCounter(
//                     count: 1,
//                     onIncrement: () {
//
//                     },
//                     onDecrement: () {
//
//                     },
//                   ),
//                 ],
//               ),
//
//             ],
//           ).expand(),
//
//
//         ],
//       ).paddingSymmetric(horizontal: 10),
//     );
//   }
// }

// class KavachModelsListBody extends StatelessWidget {
//   final KavachProduct product;
//
//   const KavachModelsListBody({super.key, required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: commonContainerDecoration(borderColor: AppColors.borderColor),
//       child: Row(
//         children: [
//           // Placeholder for image
//           Image.asset(AppImage.png.kavachProduct, width: 80),
//           10.width,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(product.name, style: AppTextStyle.h5),
//                   5.width,
//                   SvgPicture.asset(AppIcons.svg.infOutline, width: 15, colorFilter: AppColors.svg(AppColors.greyIconColor)),
//                 ],
//               ),
//               Text(product.part, style: AppTextStyle.bodyGreyColor),
//               5.height,
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("$indianCurrencySymbol ${product.price.toStringAsFixed(0)}", style: AppTextStyle.h4PrimaryColor),
//                       Text(context.appText.excludingGST, style: AppTextStyle.body4GreyColor),
//                     ],
//                   ).expand(),
//
//                   ProductCounter(
//                     count: 1,
//                     onIncrement: () {},
//                     onDecrement: () {},
//                   ),
//                 ],
//               ),
//             ],
//           ).expand(),
//         ],
//       ).paddingSymmetric(horizontal: 10),
//     );
//   }
// }

class KavachModelsListBody extends StatelessWidget {
  final KavachProduct product;
  final int quantity;

  const KavachModelsListBody({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<KavachBloc>();

    return Container(
      padding: EdgeInsets.all(10),
      decoration: commonContainerDecoration(borderColor: AppColors.borderColor),
      child: Row(
        children: [
          Image.asset(AppImage.png.kavachProduct, width: 80),
          10.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(product.name, style: AppTextStyle.h5),
                  5.width,
                  SvgPicture.asset(AppIcons.svg.infOutline, width: 15),
                ],
              ),
              Text(product.part, style: AppTextStyle.bodyGreyColor),
              5.height,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$indianCurrencySymbol ${product.price.toStringAsFixed(0)}", style: AppTextStyle.h4PrimaryColor),
                      Text(context.appText.excludingGST, style: AppTextStyle.body4GreyColor),
                    ],
                  ).expand(),

                  ProductCounter(
                    count: quantity,
                    onIncrement: () => bloc.add(IncrementQuantity(product.id)),
                    onDecrement: () => bloc.add(DecrementQuantity(product.id)),
                  ),
                ],
              ),
            ],
          ).expand(),
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }
}
