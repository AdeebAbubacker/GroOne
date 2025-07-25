import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class ViewFileWidget extends StatelessWidget {
  final List<String> image;
  const ViewFileWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.file, isCrossLeadingIcon: true),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding, vertical: 20),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: image.length,
        itemBuilder: (context, index) {
          return  commonCacheNetworkImage(
            height: 200,
            width: double.infinity,
            path: image[index],
            errorImage: Icons.image_not_supported,
          );
        },
        separatorBuilder: (context, index) => 15.height,
      ).withScroll(),
    );
  }
}
