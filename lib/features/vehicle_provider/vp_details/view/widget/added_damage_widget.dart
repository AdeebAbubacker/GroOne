import 'package:flutter/material.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/vp_damages_and_shortages_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/view_file_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import '../../../../../utils/app_icons.dart';

class AddedDamageWidget extends StatelessWidget {
  final List<DamageReport>? damageReport;
  const AddedDamageWidget({super.key,this.damageReport});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: List.generate(

        damageReport?.length??0, (index) {
        DamageReport? damageReportModel=damageReport?[index];
      return addedDamageView(
        context: context,
        onEdit: () {
          },
        description: damageReportModel?.description??"",
        imageUrl:  damageReportModel?.image??[],
        itemName: damageReportModel?.itemName??"",
        onDelete: () {},
        quantity: damageReportModel?.quantity.toString()??"",

      );
      },),
    );
  }

  Widget addedDamageView({
    required BuildContext context,
    required List<String> imageUrl,
    required String itemName,
    required String quantity,
    required String description,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.extraLightBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 110,
      child: Row(
        children: [
          // Left-side Image with only left corners rounded
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: SizedBox(
              width: 110,
              height: double.infinity,
              child: commonCacheNetworkImage(
                  path: imageUrl.isNotEmpty ?  imageUrl.first:"",
                  errorImage: Icons.image_not_supported,
                  radius: 0
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(itemName, style: AppTextStyle.body2),
                  5.height,
                  Text("${context.appText.quantity}: $quantity", style: AppTextStyle.body4GreyColor),
                  Text(description, style: AppTextStyle.body4GreyColor),
                  5.height,
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(createRoute(ViewFileWidget(image: imageUrl)));
                    },
                    child: Text(context.appText.viewFiles, style: AppTextStyle.body3PrimaryColor),
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }
}
