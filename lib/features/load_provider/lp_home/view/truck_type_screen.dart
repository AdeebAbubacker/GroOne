import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_commodity_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';

class TruckTypesScreen extends StatefulWidget {
  final List<TruckTypeData> dataList;
  final Function(TruckTypeData) onSelect;
  const TruckTypesScreen({super.key, required this.dataList, required this.onSelect});

  @override
  State<TruckTypesScreen> createState() => _TruckTypesScreenState();
}

class _TruckTypesScreenState extends State<TruckTypesScreen> {


  int? selectedIndex;
  String selectedType = 'Open'; // default selected
  int? selectedSubTypeIndex;

  String? checkValidation;


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


  List<String> getUniqueTypes(List<TruckTypeData> dataList) {
    return dataList.map((e) => e.type).toSet().toList();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();

    super.dispose();
  }


  void initFunction() => frameCallback(() async {

  });

  void disposeFunction() => frameCallback(() {

  });



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Select Truck Types", isCrossLeadingIcon: true),
      body: _buildBodyWidget(context),
      bottomNavigationBar: _buildSelectButton(context),
    );
  }

  Widget _buildBodyWidget(BuildContext context){
    final types = getUniqueTypes(widget.dataList);
    final subTypes = widget.dataList.where((e) => e.type == selectedType).toList();
    return SafeArea(
      minimum: EdgeInsets.all(commonSafeAreaPadding),
      child:  Column(
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
                    height: 50,
                    decoration: commonContainerDecoration(
                      color: AppColors.lightPrimaryColor2,
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
              final data = subTypes[index];
              final isSelected = (index == selectedSubTypeIndex);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    checkValidation = index.toString();
                    selectedSubTypeIndex = index;
                    widget.onSelect(data);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: commonContainerDecoration(
                    color: AppColors.lightPrimaryColor2,
                    borderColor: isSelected ? AppColors.primaryColor : AppColors.lightDividerColor,
                    borderRadius: BorderRadius.circular(10),
                    borderWidth: isSelected ?  1.5 : 1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.svg.truck,
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
    );
  }

  Widget _buildSelectButton(BuildContext context){
    return AppButton(
      title: context.appText.select,
      onPressed: (){
        if(selectedSubTypeIndex == null){
          ToastMessages.alert(message: "Please Select Truck Length");
          return;
        }
        Navigator.of(context).pop();
        },
    ).bottomNavigationPadding();
  }

}
