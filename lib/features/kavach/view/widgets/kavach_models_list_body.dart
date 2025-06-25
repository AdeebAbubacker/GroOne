import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/view/widgets/product_counter.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:intl/intl.dart';

import '../../bloc/kavach_list_bloc/kavach_products_list_bloc.dart';
import '../../bloc/kavach_list_bloc/kavach_products_list_event.dart';
import '../../model/kavach_product_model.dart';

class KavachModelsListBody extends StatelessWidget {
  final KavachProduct product;
  final int quantity;
  final int availableStock; // Add availableStock to the constructor

  const KavachModelsListBody({
    super.key,
    required this.product,
    required this.quantity,
    required this.availableStock, // Require it in the constructor
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<KavachProductsListBloc>();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: commonContainerDecoration(
        borderColor: AppColors.borderColor,
        shadow: false,
        borderRadius: BorderRadius.circular(8),
        ),
      child: Row(
        children: [
          Image.asset(AppImage.png.kavachNewProduct1, width: 100),

          10.width,
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: AppTextStyle.h5),
              5.height,
              Text(product.part, style: AppTextStyle.bodyGreyColor),
              5.height,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$indianCurrencySymbol ${product.price.toStringAsFixed(2)}", style: AppTextStyle.h4PrimaryColor),
                      Text(context.appText.excludingGST, style: AppTextStyle.body4GreyColor),
                    ],
                  ).expand(),
                  // Conditional rendering based on availableStock
                  if (availableStock == 0)
                    Text(
                      'out of stock', // Assuming you have 'outOfStock' in your appText
                      style: AppTextStyle.h5, // Example style for out of stock text
                    )
                  else
                    ProductCounter(
                      count: quantity,
                      onIncrement: () => bloc.add(TryIncrementQuantity(productId: product.id)),
                      onDecrement: () => bloc.add(DecrementQuantity(product.id)),
                    ),
                ],
              ),
            ],
          ).expand(),
        ],
      ),
    );
  }
}
// class KavachModelsListBody extends StatelessWidget {
//   final KavachProduct product;
//   final int quantity;
//
//   const KavachModelsListBody({
//     super.key,
//     required this.product,
//     required this.quantity,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.read<KavachProductsListBloc>();
//
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: commonContainerDecoration(borderColor: AppColors.borderColor),
//       child: Row(
//         children: [
//           Image.asset(AppImage.png.kavachProduct, width: 80),
//           10.width,
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(product.name, style: AppTextStyle.h5),
//                   5.width,
//                   SvgPicture.asset(AppIcons.svg.infOutline, width: 15),
//                 ],
//               ),
//               Text(product.part, style: AppTextStyle.bodyGreyColor),
//               5.height,
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("$indianCurrencySymbol ${product.price.toStringAsFixed(2)}", style: AppTextStyle.h4PrimaryColor),
//                       Text(context.appText.excludingGST, style: AppTextStyle.body4GreyColor),
//                     ],
//                   ).expand(),
//
//                   ProductCounter(
//                     count: quantity,
//                     onIncrement: () => bloc.add(TryIncrementQuantity(productId: product.id)),
//                     onDecrement: () => bloc.add(DecrementQuantity(product.id)),
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
