import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/constant_variables.dart';
import '../../kavach/model/kavach_product_model.dart';
import '../../kavach/view/widgets/product_counter.dart';

class GpsModelWidget extends StatelessWidget {
  final KavachProduct product;
  final int quantity;
  final int availableStock;
  final Function(int)? onQuantityChanged;
  const GpsModelWidget({
    super.key,
    required this.product,
    required this.quantity,
    required this.availableStock,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: commonContainerDecoration(
        shadow: false,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: product.fileKey,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return Image.asset(AppImage.png.gpsNewProduct, width: 100);
            },
          ),

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
                      Text(
                        "$indianCurrencySymbol ${product.price.toStringAsFixed(2)}",
                        style: AppTextStyle.h4PrimaryColor,
                      ),
                      Text(
                        context.appText.excludingGST,
                        style: AppTextStyle.body4GreyColor,
                      ),
                    ],
                  ).expand(),
                  // Conditional rendering based on availableStock
                  if (availableStock == 0)
                    Text(context.appText.outOfStock,
                      style: AppTextStyle.h5,
                    )
                  else
                    ProductCounter(
                      count: quantity,
                      onIncrement: () {
                        if (onQuantityChanged != null) {
                          onQuantityChanged!(quantity + 1);
                        }
                      },
                      onDecrement: () {
                        if (onQuantityChanged != null) {
                          onQuantityChanged!(quantity - 1);
                        }
                      },
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