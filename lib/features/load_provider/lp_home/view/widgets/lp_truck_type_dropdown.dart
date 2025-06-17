import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LPTruckTypeDropdown extends StatefulWidget {
  final GestureTapCallback onTab;
  final String? selectedText;
  final String hintText;
  final String preFixIcon;
  final List<TruckTypeData> dataList;
  final Function(TruckTypeData) onSelect;
  const LPTruckTypeDropdown({super.key, required this.onTab, required this.hintText, this.selectedText,required this.dataList, required this.preFixIcon, required this.onSelect});

  @override
  State<LPTruckTypeDropdown> createState() => _LPTruckTypeDropdownState();
}

class _LPTruckTypeDropdownState extends State<LPTruckTypeDropdown> {

  int selectedIndex = 0;
  String selectedType = 'Open'; // default selected
  int selectedSubTypeIndex = -1;



  List<String> selectTruckTypeList = [
    AppIcons.svg.openTruck,
    AppIcons.svg.truck,
    AppIcons.svg.trailer,
  ];

  List<String> selectTruckLengthList = [
    AppIcons.svg.truck20Feet,
    AppIcons.svg.truck22Feet,
    AppIcons.svg.truck24Feet,
  ];


  @override
  Widget build(BuildContext context) {

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
                Text(widget.selectedText ?? widget.hintText, style: AppTextStyle.body, maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                Icon(Icons.keyboard_arrow_down, color: AppColors.greyIconColor, size: 20),
              ],
            ),
          ),
        ),



      ],
    );
  }
}