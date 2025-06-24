import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:slide_to_act/slide_to_act.dart';

class CustomSwipeButton extends StatelessWidget {
  final int price;
  final String loadId;
  final Future<dynamic>? Function()?  onSubmit;

  const CustomSwipeButton({super.key, required this.price, required this.loadId, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      borderRadius: 16,
      elevation: 0,
      height: 55,
      innerColor: Colors.transparent,
      outerColor: const Color(0xffE5EBFF),
      sliderButtonIcon: _buildChevronIcon(),
      sliderRotate: false,
      sliderButtonYOffset: -20,
      text: 'Swipe to Agree',
      textStyle: AppTextStyle.body2.copyWith(color: AppColors.primaryColor),
      onSubmit: onSubmit,
    ).paddingAll(10);
  }

  Widget _buildChevronIcon() {
    return SizedBox(
      width: 70,
      height: 50,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(left: 16, child: _buildChevron(const Color(0xFFB3C7FF))),
          Positioned(left: 8, child: _buildChevron(AppColors.primaryColor.withOpacity(0.50))),
          _buildChevron(AppColors.primaryColor),
        ],
      ),
    );
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
