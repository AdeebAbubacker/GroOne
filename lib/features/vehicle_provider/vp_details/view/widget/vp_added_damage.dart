import 'package:flutter/material.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/view_file_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class VpAddedDamageWidget extends StatelessWidget {
  final List<DamageReport>? damageReport;
  final List<String>? imageList;
  const VpAddedDamageWidget({super.key, this.damageReport, this.imageList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        damageReport?.length ?? 0,
        (index) {
          DamageReport? damageReportModel = damageReport?[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: addedDamageView(
              context: context,
              onEdit: () {},
              description: damageReportModel?.description ?? "",
              imageIDs: damageReportModel?.image ?? [],
              imageUrl: imageList?[index] ?? "",
              itemName: damageReportModel?.itemName ?? "",
              onDelete: () {},
              quantity: damageReportModel?.quantity.toString() ?? "",
            ),
          );
        },
      ),
    );
  }

  Widget addedDamageView({
    required BuildContext context,
    required List<String> imageIDs,
    required String itemName,
    required String quantity,
    required String imageUrl,
    required String description,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.extraLightBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // Left-side Image with only left corners rounded
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
              maxWidth: 110,
            ),
              child: commonCacheNetworkImage(
                path: imageUrl,
                errorImage: Icons.image_not_supported,
                radius: 0,
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
                  // Item name with ellipsis if too long
                  Text(
                    itemName,
                    style: AppTextStyle.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  5.height,

                  // Quantity
                  Text(
                    "${context.appText.quantity}: $quantity",
                    style: AppTextStyle.body4GreyColor,
                  ),

                  // Description with expandable "Read More"
                  ExpandableText(
                    text: description,
                    maxLines: 2,
                    style: AppTextStyle.body4GreyColor,
                  ),

                  5.height,

                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(createRoute(ViewFileWidget(image: imageIDs)));
                    },
                    child: Text(
                      context.appText.viewFiles,
                      style: AppTextStyle.body3PrimaryColor,
                    ),
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

/// ExpandableText Widget 
class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ExpandableText({
    Key? key,
    required this.text,
    this.maxLines = 2,
    this.style,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: text, style: widget.style);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
          ellipsis: '...',
        );
        tp.layout(maxWidth: constraints.maxWidth);

        final bool isOverflowing = tp.didExceedMaxLines;
        final linkText = isExpanded ? ' Read Less' : ' Read More';

        if (!isOverflowing) {
          return Text(text, style: widget.style);
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: widget.style,
                maxLines: isExpanded ? null : widget.maxLines,
                overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  linkText,
                  style: widget.style?.copyWith(color: Colors.blue) ??
                      const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
