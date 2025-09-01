import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class KavachModelsFilterBottomSheetScreen extends StatefulWidget {
  const KavachModelsFilterBottomSheetScreen({super.key});

  @override
  State<KavachModelsFilterBottomSheetScreen> createState() => _KavachModelsFilterBottomSheetScreenState();
}

class _KavachModelsFilterBottomSheetScreenState extends State<KavachModelsFilterBottomSheetScreen> {
  final formKey = GlobalKey<FormState>();

  String? shortByDropDownValue;
  String? modelsDropDownValue;

  final List<String> vehicleTypes = [
    'Car',
    'Bike',
    'Scooter',
    'Auto Rickshaw',
    'Van',
    'Truck',
    'Bus',
    'Tractor',
    'SUV',
    'Pickup',
    'Electric Scooter',
    'Electric Car'
  ];


  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() {
    //  Call your init methods
  });

  void disposeFunction() => frameCallback(() {
  });



  @override
  Widget build(BuildContext context) {
    return AppBottomSheetBody(
      title: context.appText.filter,
      body: _buildBody(context: context),
    );
  }

  Widget _buildBody({required BuildContext context}){
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Short By
          AppDropdown(
            labelText: context.appText.sortBy,
            dropdownValue: shortByDropDownValue,
            decoration: commonInputDecoration(),
            dropDownList: vehicleTypes.map((e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: AppTextStyle.body),
            )).toList(),
            onChanged: (onChangeValue) {
              shortByDropDownValue = onChangeValue;
            },
          ),
          20.height,

          // Models
          AppDropdown(
            labelText: context.appText.models,
            dropdownValue: modelsDropDownValue,
            decoration: commonInputDecoration(),
            dropDownList: vehicleTypes.map((e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: AppTextStyle.body),
            )).toList(),
            onChanged: (onChangeValue) {
              modelsDropDownValue = onChangeValue;
            },
          ),
          50.height,

          Row(
            children: [

              // Cancel
              AppButton(
                onPressed: ()=> context.pop(),
                title: context.appText.cancel,
                style: AppButtonStyle.outline,
              ).expand(),

              20.width,

              // Apply
              AppButton(
                onPressed: (){},
                title: context.appText.apply,
                style: AppButtonStyle.primary,
              ).expand()
            ],
          ),

        ],
      ),
    );
  }


}
