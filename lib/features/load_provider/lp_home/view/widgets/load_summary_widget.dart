import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LoadSummaryWidget extends StatelessWidget {
  final String title;
  final String heading1;
  final String heading2;
  final String subheading1;
  final String subheading2;
  final bool showHeading2;
  const LoadSummaryWidget({super.key, required this.title, required this.heading1, required this.heading2, required this.subheading1, required this.subheading2,  this.showHeading2 = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.h5),
        15.height,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading1, style: AppTextStyle.bodyPrimaryColor),
                  5.height,
                  Text(subheading1, style: AppTextStyle.body3),
                ],
              ),
            ),
            10.width,
            showHeading2
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(heading2, style: AppTextStyle.bodyPrimaryColor),
                    5.height,
                    Text(subheading2, style: AppTextStyle.body3),
                  ],
                ).expand() : SizedBox.shrink().expand(),
          ],
        ),
        5.height,
        commonDivider(),
      ],
    );
  }
}
