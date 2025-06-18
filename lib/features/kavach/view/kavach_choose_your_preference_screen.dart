import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/view/kavach_models_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class KavachChooseYourPreferenceScreen extends StatefulWidget {
  const KavachChooseYourPreferenceScreen({super.key});

  @override
  State<KavachChooseYourPreferenceScreen> createState() => _KavachChooseYourPreferenceScreenState();
}

class _KavachChooseYourPreferenceScreenState extends State<KavachChooseYourPreferenceScreen> {
  // Sample dropdown values
  String? selectedMake = 'TATA';
  String? selectedModel;
  String? selectedEngine;
  String? selectedTankType;
  String? selectedDeviceType;

  final List<DropdownMenuItem<String>> makeList = [
    DropdownMenuItem(value: 'TATA', child: Text('TATA')),
    DropdownMenuItem(value: 'ASHOK LEYLAND', child: Text('ASHOK LEYLAND')),
    DropdownMenuItem(value: 'EICHER', child: Text('EICHER')),
  ];
  final List<DropdownMenuItem<String>> modelList = [
    DropdownMenuItem(value: 'Select', child: Text('Select')),
    DropdownMenuItem(value: 'Model X', child: Text('Model X')),
    DropdownMenuItem(value: 'Model Y', child: Text('Model Y')),
  ];
  final List<DropdownMenuItem<String>> engineList = [
    DropdownMenuItem(value: 'Select', child: Text('Select')),
    DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
    DropdownMenuItem(value: 'Petrol', child: Text('Petrol')),
  ];
  final List<DropdownMenuItem<String>> tankTypeList = [
    DropdownMenuItem(value: 'cross Linked polymer/Plastic', child: Text('cross Linked polymer/Plastic')),
    DropdownMenuItem(value: 'Steel', child: Text('Steel')),
  ];
  final List<DropdownMenuItem<String>> deviceTypeList = [
    DropdownMenuItem(value: 'Neck/Drain Plug/ Full Kit', child: Text('Neck/Drain Plug/ Full Kit')),
    DropdownMenuItem(value: 'Neck Only', child: Text('Neck Only')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.tankLock,
                actions: [
                AppIconButton(
                  onPressed: () {},
                  icon: AppIcons.svg.support,
                  iconColor: AppColors.primaryColor,
                ),
                10.width,
              ],),
    
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Image
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.lightPrimaryColor,
                image: DecorationImage(
                  image: AssetImage(AppImage.png.newTruck),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            15.height,
            // Form Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: commonContainerDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                shadow: true,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Choose your preference', style: AppTextStyle.h4)),
                  15.height,
                  AppDropdown(
                    labelText: 'Make',
                    mandatoryStar: true,
                    dropdownValue: selectedMake,
                    dropDownList: makeList,
                    onChanged: (val) => setState(() => selectedMake = val),
                  ),
                   10.height,
                  AppDropdown(
                    labelText: 'Model',
                    mandatoryStar: true,
                    dropdownValue: selectedModel,
                    dropDownList: modelList,
                    onChanged: (val) => setState(() => selectedModel = val),
                  ),
                  10.height,
                  AppDropdown(
                    labelText: 'Engine',
                    dropdownValue: selectedEngine,
                    dropDownList: engineList,
                    onChanged: (val) => setState(() => selectedEngine = val),
                  ),
                  10.height,
                  AppDropdown(
                    labelText: 'Tank Type',
                    dropdownValue: selectedTankType,
                    dropDownList: tankTypeList,
                    onChanged: (val) => setState(() => selectedTankType = val),
                  ),
                 10.height,
                  AppDropdown(
                    labelText: 'Device Type',
                    dropdownValue: selectedDeviceType,
                    dropDownList: deviceTypeList,
                    onChanged: (val) => setState(() => selectedDeviceType = val),
                  ),
                 10.height,
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          title: 'Cancel',
                          style: AppButtonStyle.outline,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      20.width,
                      Expanded(
                        child: AppButton(
                          title: 'Apply',
                          style: AppButtonStyle.primary,
                          onPressed: () {
                            Navigator.of(context).push(commonRoute(KavachModelsScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            20.height,
          ],
        ),
      ),
    );
  }
}
