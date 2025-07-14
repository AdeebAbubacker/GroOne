import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class AppBottomSheetBody extends StatefulWidget {
  final String? title;
  final bool? isCloseButton;
  final bool hideDivider;
  final Widget body;

  const AppBottomSheetBody( {super.key, this.title, this.isCloseButton = true,this.hideDivider = true, required this.body});


  @override
  State<AppBottomSheetBody> createState() => _AppBottomSheetBodyState();
}

class _AppBottomSheetBodyState extends State<AppBottomSheetBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            15.height,
            // AppBar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(widget.title != null)
                Text(widget.title ?? "", style: AppTextStyle.appBar)
                else
                  0.width,

                if(widget.isCloseButton != null && widget.isCloseButton!)
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.clear_rounded))
              ],
            ).paddingSymmetric(horizontal: commonSafeAreaPadding),

           widget.hideDivider? commonDivider(height: 15, dividerColor: AppColors.lightDividerColor):const SizedBox(),
            20.height,

           // body
            widget.body.paddingSymmetric(horizontal: commonSafeAreaPadding),
            50.height,
          ],
        ),
        )
      ),
    );
  }
}
