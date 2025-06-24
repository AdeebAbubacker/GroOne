import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'app_colors.dart';

class RadioButton extends StatelessWidget {
  const RadioButton({super.key, required this.radioBool, required this.onChanged});
  final bool radioBool;
  final GestureTapCallback onChanged;
  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onChanged,
      child: Row(
        children: [
          Container(
            height: 14,
            width: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color:
                radioBool ? AppColors.primaryColor : AppColors.disableColor,
                width: radioBool ? 4 : 2,
              ),
            ),
          ),
          10.width,

        ],
      ),
    );
  }
}
