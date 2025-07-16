import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:slide_to_act/slide_to_act.dart';

class VpMyLoadHelper {
  VpMyLoadHelper._();

  // Showing Status View
  static Widget loadStatusWidget(String status) {
    debugPrint("Status : $status");
    Widget ui({required Color backgroundColor, required Color textColor}) {
      return Container(
        decoration: commonContainerDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          status.capitalize,
          style: AppTextStyle.body.copyWith(color: textColor),
        ).paddingSymmetric(horizontal: 10, vertical: 3),
      );
    }

    switch (status) {
      case "accepted":
        return ui(textColor: Color(0xff9C27B0), backgroundColor: Color(0xffe1bfe6));
      case "assigned":
        return ui(textColor: Color(0xff018800), backgroundColor: Color(0xffe6f3e5));
      case "loading":
        return ui(textColor: Color(0xffFF9800), backgroundColor: Color(0xffffeacc));
      case "unloading":
        return ui(textColor: Color(0xff009688), backgroundColor: Color(0xffcceae7));
      case "inTransit":
        return ui(textColor: Color(0xffFF5722), backgroundColor: Color(0xffffddd3));
      case "POD Dispatch":
        return ui(textColor: Colors.white, backgroundColor: Color(0xff42A5F5));
      case "completed":
        return ui(textColor: Colors.white, backgroundColor: Color(0xff018800));
      default:
        return Container();
    }
  }

  // Showing Status Button
  static Widget loadStatusButtonWidget({required String status, bool isLoading = false, required void Function() onPressed}) {
    debugPrint("Status : $status");
    switch (status) {
      case "accepted":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Assign Driver",
        );
      case "assigned":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "Start Trip",
        );
      case "loading":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: status.capitalize,
        );
      case "unloading":
        return SlideAction(
          borderRadius: commonButtonRadius,
          elevation: 0,
          height: commonButtonHeight2,
          innerColor: Colors.transparent,
          outerColor:  AppColors.primaryColor.withOpacity(0.2),
          sliderButtonIcon: Visibility(
              child: SizedBox(
                width: 70,
                height: commonButtonHeight2,
                child: ClipPath(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                          left: 16,
                         child: ClipPath(
                           clipper: _ChevronClipper(),
                           child: Container(
                             width: 50,
                             height: commonButtonHeight2,
                             color: Color(0xFFB3C7FF),
                           ),
                         ),
                      ),
                      Positioned(
                          left: 8,
                         child: ClipPath(
                           clipper: _ChevronClipper(),
                           child: Container(
                             width: 50,
                             height: commonButtonHeight2,
                             color: AppColors.primaryColor.withOpacity(0.50),
                           ),
                         ),
                      ),
                      ClipPath(
                        clipper: _ChevronClipper(),
                        child: Container(
                          width: 50,
                          height: commonButtonHeight2,
                          color: AppColors.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
          sliderRotate: false,
          sliderButtonYOffset: -20,
          text: "Swipe to complete unloading",
          textStyle: AppTextStyle.button.copyWith(color: AppColors.primaryColor),
          onSubmit: (){
            onPressed.call();
          },

        );
      case "inTransit":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: status.capitalize,
        );
      case "POD Dispatch":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "POD Dispatch Detail",
        );
      case "completed":
        return AppButton(
          buttonHeight: commonButtonHeight2,
          onPressed: isLoading ? () {} : onPressed,
          isLoading: isLoading,
          title: "View Detail",
        );
      default:
        return Container();
    }
  }


  Widget _buildChevron(Color color) {
    return ClipPath(
      clipper: _ChevronClipper(),
      child: Container(
        width: 50,
        height: 50,
        color: color,
      ),
    );
  }


}


class _ChevronClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
