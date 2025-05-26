import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import 'app_colors.dart';
import 'app_image.dart';
import 'app_text_style.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({super.key,required this.onTab,required this.hintText, this.selectedText,required this.viewDroDown,required this.dataList,required this.onSelect});
  final GestureTapCallback onTab;
  final String? selectedText;
  final String hintText;
  final Function(int) onSelect;
  final bool viewDroDown;
  final List dataList;
  @override
  Widget build(BuildContext context) {
    debugPrint("selected Text $selectedText");
    return Column(
      children: [
        InkWell(onTap: onTab,
          child: Container(height: 44.h,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderDisableColor, width: 0.6.w),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.backGroundBlue,
            ),
            child: Row(
              children: [
                Image.asset(
                  AppImage.png.loadImage,
                  color: AppColors.primaryDarkColor,
                  height: 22.h,
                  width: 22.w,
                ),
                10.width,
                Text(selectedText??hintText,style: AppTextStyle.textBlackColor14w400,),
                Expanded(child: SizedBox.shrink()),
                Icon(Icons.keyboard_arrow_down, color: AppColors.textBlackColor,size: 20,),

              ],
            ),
          ),
        ),
        5.height,
        viewDroDown?Container( padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderDisableColor, width: 0.6.w),
              borderRadius: BorderRadius.circular(8),

            ),
            child: GridView.builder(
              itemCount: dataList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items per row
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio:1.3, // Adjust for item width/height
              ),
              itemBuilder: (context, index) {
                var image = dataList[index];
                return InkWell(
                  onTap: () => onSelect(index),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color:  selectedText==image['label']?AppColors.primaryColor:AppColors.primaryDarkColor,width: selectedText==image['label']?2: 0.8),
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.backgroundColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(image['icon'], color: selectedText==image['label']?AppColors.primaryDarkColor: AppColors.primaryDarkColor,size: 30,),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            image['label'],
                            style: selectedText==image['label']?AppTextStyle.primaryColor14w700:AppTextStyle.textBlackColor14w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )

        ):const SizedBox(),
      ],
    );
  }
}
