import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class CommodityTypesScreen extends StatefulWidget {
  final List<LoadCommodityListModel> dataList;
  final Function(int) onSelect;
  final int? selectedIndex;
  const CommodityTypesScreen({
    super.key,
    required this.dataList,
    required this.onSelect,
    this.selectedIndex,
  });

  @override
  State<CommodityTypesScreen> createState() => _CommodityTypesScreenState();
}

class _CommodityTypesScreenState extends State<CommodityTypesScreen> {
  int? selectedIndex;

  List<String> commodityIconsList = [
    AppIcons.svg.agriculture,
    AppIcons.svg.parcel,
    AppIcons.svg.barrel,
    AppIcons.svg.log,
    AppIcons.svg.bottles,
  ];

  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    selectDefaultCommodity();
    super.initState();
  }

  selectDefaultCommodity() {
    if ((selectedIndex == null || selectedIndex == -1) && widget.dataList.isNotEmpty) {
      selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Select Commodity Types",
        isCrossLeadingIcon: true,
      ),
      body: _buildBodyWidget(context),
      bottomNavigationBar: _buildSelectButton(context),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.all(commonSafeAreaPadding),
      child: Builder(
        builder: (context) {
          return GridView.builder(
            itemCount: widget.dataList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 20, bottom: 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 items per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3, // Adjust for item width/height
            ),
            itemBuilder: (context, index) {
              var data = widget.dataList[index].copyWith(
                iconUrl: commodityIconsList[index],
              );
              return InkWell(
                onTap: () {
                  widget.onSelect(index);
                  selectedIndex = index;
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: commonContainerDecoration(
                    color: AppColors.lightPrimaryColor2,
                    borderColor:
                        selectedIndex == index
                            ? AppColors.primaryColor
                            : AppColors.lightDividerColor,
                    borderWidth: selectedIndex == index ? 1.5 : 1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      SvgPicture.asset(
                        data.iconUrl,
                        width: 25,
                        colorFilter: AppColors.svg(
                          selectedIndex == index
                              ? AppColors.primaryColor
                              : AppColors.greyIconColor,
                        ),
                      ),
                      5.height,

                      // Label
                      Text(
                        data.name,
                        style:
                            selectedIndex == index
                                ? AppTextStyle.body3PrimaryColor
                                : AppTextStyle.body3GreyColor,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectButton(BuildContext context) {
    return AppButton(
      title: context.appText.select,
      onPressed: () {
        widget.onSelect(selectedIndex ?? 0);
        Navigator.of(context).pop();
      },
    ).bottomNavigationPadding();
  }
}
