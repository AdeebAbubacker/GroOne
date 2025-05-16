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
  const UploadFileAndImageBottomSheet({super.key});

  @override
  State<UploadFileAndImageBottomSheet> createState() =>
      _UploadFileAndImageBottomSheetState();
}

class _UploadFileAndImageBottomSheetState extends State<UploadFileAndImageBottomSheet> {

  var exitIcons = [AppIcons.svg.camera, AppIcons.svg.gallery];
  var exitNames = [AppString.label.fromCamera, AppString.label.fromGallery];

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.clear_rounded))
            ],
          ),
          20.height,
          Column(
            children: [
              for (var i = 0; i < exitIcons.length; i++) ...[
                InkWell(
                  onTap: () async {
                    if (i == 0) {
                      // final status = await Permission.camera.request();
                      //  print(status);
                      //  if (status.isGranted) {
                      await ImagePickerFrom.fromCamera().then((value) => Navigator.of(context).pop(value));
                      //  }else{
                      // openAppSettings();
                      // }
                    } else {
                      // final status = await Permission.storage.request();
                      // if (status.isGranted) {
                      // } else {
                      //   openAppSettings();
                      // }
                      ImagePickerFrom.fromGallery().then((value) => Navigator.of(context).pop(value));

                    }
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        10.width,
                        SvgPicture.asset(exitIcons[i], colorFilter : AppColors.svg(AppColors.greyIconColor)),
                        20.width,
                        Text(exitNames[i].toString(), style: AppTextStyle.body2)
                      ],
                    ),
                  ),
                ),
                if (i != exitIcons.length - 1)
                  const Divider(
                      color: AppColors.dividerColor,
                      indent: 55,
                      thickness: 0.5,
                  ),
              ],
            ],
          ),
          50.height,
        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding),
    );
  }
}
