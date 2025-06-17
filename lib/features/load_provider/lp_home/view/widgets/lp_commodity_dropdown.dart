import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LPCommodityDropdown extends StatelessWidget {
  final GestureTapCallback onTab;
  final String? selectedText;
  final String hintText;
  final String preFixIcon;
  final Function(int) onSelect;
  final List<LoadCommodityList> dataList;
  const LPCommodityDropdown({super.key, required this.onTab, required this.hintText, this.selectedText, required this.dataList, required this.onSelect, required this.preFixIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        height: 55,
        padding: EdgeInsets.all(10),
        decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
        child: Row(
          children: [
            SvgPicture.asset(preFixIcon),
            10.width,
            Text(selectedText ?? hintText, style: AppTextStyle.body, maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
            Icon(Icons.keyboard_arrow_down, color: AppColors.greyIconColor, size: 20),
          ],
        ),
      ),
    );
  }
}
