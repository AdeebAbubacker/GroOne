import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class UploadFileAndImageBottomSheet extends StatefulWidget {
  final bool isMultipleSelectionFile;
  const UploadFileAndImageBottomSheet({super.key,  this.isMultipleSelectionFile = true});

  @override
  State<UploadFileAndImageBottomSheet> createState() => _UploadFileAndImageBottomSheetState();
}

class _UploadFileAndImageBottomSheetState extends State<UploadFileAndImageBottomSheet> {

  final List<String> icons = [
    AppIcons.svg.camera,
    AppIcons.svg.gallery,
    AppIcons.svg.folder, // Add this in your AppIcons.svg
  ];

  final List<String> labels = [
    AppString.label.fromCamera,
    AppString.label.fromGallery,
    AppString.label.fromFile,
  ];

  @override
  Widget build(BuildContext context) {
    if (!widget.isMultipleSelectionFile) {
      icons.removeLast();
      labels.removeLast();
    }
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppString.label.selectImageFrom, style: AppTextStyle.appBar),
              IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.clear_rounded))
            ],
          ),
          20.height,
          Column(
            children: [
              for (var i = 0; i < icons.length; i++) ...[
                InkWell(
                  onTap: () async {
                    if (i == 0) {
                      final result = await ImagePickerFrom.fromCamera();
                      if(!context.mounted) return;
                      if (result != null) Navigator.of(context).pop(result);
                    } else if (i == 1) {
                      final result = await ImagePickerFrom.fromGallery();
                      if(!context.mounted) return;
                      if (result != null) Navigator.of(context).pop(result);
                    } else {
                      final files = await pickMultipleFiles();
                      if(!context.mounted) return;
                      if (files != null && files.isNotEmpty) {
                        Navigator.of(context).pop(files);
                      }
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        10.width,
                        SvgPicture.asset(icons[i], colorFilter : AppColors.svg(AppColors.iconColor)),
                        20.width,
                        Text(labels[i].toString(), style: AppTextStyle.body)
                      ],
                    ),
                  ),
                ),
                if (i != icons.length - 1)
                  const Divider(color: AppColors.dividerColor, indent: 55, thickness: 0.5),
              ],
            ],
          ),
          50.height,
        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding),
    );
  }
}
