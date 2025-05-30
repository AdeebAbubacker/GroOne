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
  final bool viewDropDown;
  final List<TruckTypeData> dataList;
  final Function(TruckTypeData) onSelect;
  const LPTruckTypeDropdown({super.key, required this.onTab, required this.hintText, this.selectedText, required this.viewDropDown, required this.dataList, required this.preFixIcon, required this.onSelect});

  @override
  State<LPTruckTypeDropdown> createState() => _LPTruckTypeDropdownState();
}

class _LPTruckTypeDropdownState extends State<LPTruckTypeDropdown> {

  int selectedIndex = 0;
  String selectedType = 'Open'; // default selected
  int selectedSubTypeIndex = -1;

  List<String> getUniqueTypes(List<TruckTypeData> dataList) {
    return dataList.map((e) => e.type).toSet().toList();
  }

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

    final types = getUniqueTypes(widget.dataList);
    final subTypes = widget.dataList.where((e) => e.type == selectedType).toList();

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

        if(widget.viewDropDown)
        Container(
          padding: EdgeInsets.all(15),
          decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2,  borderColor: AppColors.borderColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Truck Tabs Type Row
              Text(context.appText.selectTruckType, style: AppTextStyle.body),
              10.height,
              Row(
                children: List.generate(types.length, (index) {
                  final type = types[index];
                  final icons = selectTruckTypeList[index];
                  final isSelected = selectedType == type;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = type;
                          selectedSubTypeIndex = -1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: commonContainerDecoration(
                          color: Colors.white,
                          borderColor: isSelected ? AppColors.primaryColor : AppColors.lightDividerColor,
                          borderRadius: BorderRadius.circular(10),
                          borderWidth: isSelected ?  1.5 : 1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(icons, colorFilter: AppColors.svg(isSelected ? AppColors.primaryColor : AppColors.greyIconColor), width: 25),
                            5.width,
                            Text(type, style: isSelected ? AppTextStyle.body3PrimaryColor : AppTextStyle.body3GreyColor),
                          ],
                        ),
                      ),
                    ),
                  );
                }).expand((w) => [w, 10.width]).toList()..removeLast(),
              ),

              20.height,

              // SubType Grid
              Text("Truck Length", style: AppTextStyle.body),
              10.height,
              GridView.builder(
                itemCount: subTypes.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final data = subTypes[index].copyWith(iconUrl: selectTruckLengthList[index]);
                  final isSelected = index == selectedSubTypeIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSubTypeIndex = index;
                        widget.onSelect(data);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: commonContainerDecoration(
                        color: Colors.white,
                        borderColor: isSelected ? AppColors.primaryColor : AppColors.lightDividerColor,
                        borderRadius: BorderRadius.circular(10),
                        borderWidth: isSelected ?  1.5 : 1,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            data.iconUrl,
                            colorFilter: AppColors.svg(isSelected ? AppColors.primaryColor : AppColors.greyIconColor),
                          ),
                          5.height,
                          Text(
                            data.subType,
                            style: isSelected ? AppTextStyle.body3PrimaryColor : AppTextStyle.body3GreyColor,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}