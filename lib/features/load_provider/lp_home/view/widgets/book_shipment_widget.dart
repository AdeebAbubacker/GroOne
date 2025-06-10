import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class BookShipmentWidget extends StatelessWidget {
  final String heading;
  final String subHeading;
  final GestureTapCallback onClick;

  const BookShipmentWidget({
    super.key,
    required this.heading,
    required this.subHeading,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(heading, style: AppTextStyle.textGreyColor12w400),
              Text(subHeading, style: AppTextStyle.body, overflow: TextOverflow.ellipsis, maxLines: 1),
            ],
          ).expand(),
          Image.asset(AppImage.png.locationIcon, height: 18, width: 18),
        ],
      ),
    );
  }
}
