import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class LPCommodityDropdown extends StatefulWidget {
  final GestureTapCallback onTab;
  final String? selectedText;
  final String hintText;
  final String preFixIcon;
  final Function(int) onSelect;
  final bool viewDropDown;
  final List<LoadCommodityList> dataList;
  const LPCommodityDropdown({super.key, required this.onTab, required this.hintText, this.selectedText, required this.viewDropDown, required this.dataList, required this.onSelect, required this.preFixIcon});

  @override
  State<LPCommodityDropdown> createState() => _LPCommodityDropdownState();
}

class _LPCommodityDropdownState extends State<LPCommodityDropdown> {

  int selectedIndex = 0;

  List<String> commodityIconsList = [
    AppIcons.svg.agriculture,
    AppIcons.svg.parcel,
    AppIcons.svg.barrel,
    AppIcons.svg.log,
    AppIcons.svg.bottles
  ];

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
                      var data = widget.dataList[index].copyWith(iconUrl: commodityIconsList[index]);
                      return InkWell(
                        onTap: () {
                          widget.onSelect(index);
                          selectedIndex = index;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: commonContainerDecoration(
                            borderColor: selectedIndex == index ? AppColors.primaryColor : AppColors.lightDividerColor,
                            borderWidth: selectedIndex == index  ? 1.5 : 1
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              // Icon
                              SvgPicture.asset(data.iconUrl, width: 25 ,colorFilter: AppColors.svg(selectedIndex == index ? AppColors.primaryColor : AppColors.greyIconColor)),
                              5.height,

                              // Label
                              Text(
                                data.name,
                                style:  selectedIndex == index ? AppTextStyle.body3PrimaryColor : AppTextStyle.body3GreyColor,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
