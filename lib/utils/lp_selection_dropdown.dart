import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import 'app_colors.dart';
import 'app_image.dart';
import 'app_text_style.dart';

class LPSelectionDropdown extends StatefulWidget {
  final GestureTapCallback onTab;
  final String? selectedText;
  final String hintText;
  final String preFixIcon;
  final Function(int) onSelect;
  final bool viewDropDown;
  final List dataList;
  const LPSelectionDropdown({super.key, required this.onTab, required this.hintText, this.selectedText, required this.viewDropDown, required this.dataList, required this.onSelect, required this.preFixIcon});

  @override
  State<LPSelectionDropdown> createState() => _LPSelectionDropdownState();
}

class _LPSelectionDropdownState extends State<LPSelectionDropdown> {
  @override
  Widget build(BuildContext context) {
    debugPrint("selected Text ${widget.selectedText}");
    return Column(
      children: [

        InkWell(
          onTap: widget.onTab,
          child: Container(
            height: 55,
            padding: EdgeInsets.all(10),
            decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
            child: Row(
              children: [
                SvgPicture.asset(widget.preFixIcon),
                10.width,
                Text(widget.selectedText ?? widget.hintText, style: AppTextStyle.body).expand(),

                Icon(Icons.keyboard_arrow_down, color: AppColors.greyIconColor, size: 20),
              ],
            ),
          ),
        ),

        10.height,

        // Menu Option
        Builder(
            builder: (context) {
              if(widget.viewDropDown){
                return Container(
                  padding: EdgeInsets.all(15),
                  decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2,  borderColor: AppColors.borderColor),
                  child: GridView.builder(
                    itemCount: widget.dataList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 items per row
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3, // Adjust for item width/height
                    ),
                    itemBuilder: (context, index) {
                      var image = widget.dataList[index];
                      return InkWell(
                        onTap: () => widget.onSelect(index),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: commonContainerDecoration(
                            borderColor: widget.selectedText == image['label'] ? AppColors.primaryColor : AppColors.lightDividerColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // Icon
                              Icon(
                                image['icon'],
                                color: widget.selectedText == image['label'] ? AppColors.primaryDarkColor : AppColors.lightGreyIconColor,
                                size: 25,
                              ),
                              5.height,

                              // Label
                              Flexible(
                                child: Text(
                                  image['label'],
                                  style: widget.selectedText == image['label'] ? AppTextStyle.body : AppTextStyle.bodyGreyColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return 0.height;
              }
            }
            )

      ],
    );
  }
}
