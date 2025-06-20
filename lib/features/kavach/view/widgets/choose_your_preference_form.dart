import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../utils/app_image.dart';
import '../../model/masters_model.dart';

/// A reusable form widget for choosing preferences used in both
/// KavachChooseYourPreferenceScreen and KavachModelsScreen
class ChooseYourPreferenceForm extends StatefulWidget {
  final Function(Map<String, String?>) onPreferenceChanged;
  final Function() onApply;
  final Function() onCancel;
  final Function()? onSupport;
  final bool showTitle;
  final Map<String, VehicleFilter> vehicleFilters;
  final Map<String, String?>? initialValues;

  const ChooseYourPreferenceForm({
    Key? key,
    required this.onPreferenceChanged,
    required this.onApply,
    required this.onCancel,
    this.onSupport,
    this.showTitle = true,
    required this.vehicleFilters,
    this.initialValues,
  }) : super(key: key);

  @override
  State<ChooseYourPreferenceForm> createState() => _ChooseYourPreferenceFormState();
}

class _ChooseYourPreferenceFormState extends State<ChooseYourPreferenceForm> {
  String? selectedMake;
  String? selectedModel;
  String? selectedEngine;
  String? selectedTankType;
  String? selectedDeviceType;

  @override
  void initState() {
    super.initState();
    // Use initial values if provided, otherwise start with null values
    if (widget.initialValues != null) {
      selectedMake = widget.initialValues!['make'];
      selectedModel = widget.initialValues!['model'];
      selectedEngine = widget.initialValues!['engine'];
      selectedTankType = widget.initialValues!['tankType'];
      selectedDeviceType = widget.initialValues!['deviceType'];
    }
    _updatePreferences();
  }

  void _updatePreferences() {
    widget.onPreferenceChanged({
      'make': selectedMake,
      'model': selectedModel,
      'engine': selectedEngine,
      'tankType': selectedTankType,
      'deviceType': selectedDeviceType,
    });
  }

  bool get _isFormValid {
    return selectedMake != null && selectedModel != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(  
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: commonContainerDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        shadow: true,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

              Center(
                child: Text(
                  context.appText.chooseYourPreference,
                  style: AppTextStyle.h4,
                ),
              ),
              15.height,
        
            _buildMakeDropdown(context),
            10.height,

            _buildModelDropdown(context),
            10.height,

            _buildEngineDropdown(context),
            10.height,

            _buildTankTypeDropdown(context),
            10.height,

            _buildDeviceTypeDropdown(context),
            20.height,

            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMakeDropdown(BuildContext context) {
    final makes = widget.vehicleFilters.keys.toList();
    
    return AppDropdown(
      labelText: context.appText.make,
      mandatoryStar: true,
      dropdownValue: selectedMake,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...makes.map((make) => DropdownMenuItem(
          value: make,
          child: Text(make),
        )).toList(),
      ],
      onChanged: (val) {
        setState(() {
          selectedMake = val;
          // Reset dependent fields
          selectedModel = null;
          selectedEngine = null;
          selectedTankType = null;
          selectedDeviceType = null;
          _updatePreferences();
        });
      },
    );
  }

  Widget _buildModelDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final models = vehicleFilter?.models ?? [];

    return AppDropdown(
      labelText: context.appText.model,
      mandatoryStar: true,
      dropdownValue: selectedModel,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...models.map((model) => DropdownMenuItem(
          value: model,
          child: Text(model),
        )).toList(),
      ],
      onChanged: (val) {
        setState(() {
          selectedModel = val;
          _updatePreferences();
        });
      },
    );
  }

  Widget _buildEngineDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final engines = vehicleFilter?.engineType ?? [];

    return AppDropdown(
      labelText: context.appText.engine,
      dropdownValue: selectedEngine,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...engines.map((engine) => DropdownMenuItem(
          value: engine,
          child: Text(engine),
        )).toList(),
      ],
      onChanged: (val) {
        setState(() {
          selectedEngine = val;
          _updatePreferences();
        });
      },
    );
  }

  Widget _buildTankTypeDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final tankTypes = vehicleFilter?.tankType ?? [];

    return AppDropdown(
      labelText: context.appText.tankType,
      dropdownValue: selectedTankType,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...tankTypes.map((type) => DropdownMenuItem(
          value: type,
          child: Text(type),
        )).toList(),
      ],
      onChanged: (val) {
        setState(() {
          selectedTankType = val;
          _updatePreferences();
        });
      },
    );
  }

  Widget _buildDeviceTypeDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final deviceTypes = vehicleFilter?.deviceType ?? [];

    return AppDropdown(
      labelText: context.appText.deviceType,
      dropdownValue: selectedDeviceType,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...deviceTypes.map((type) => DropdownMenuItem(
          value: type,
          child: Text(type),
        )).toList(),
      ],
      onChanged: (val) {
        setState(() {
          selectedDeviceType = val;
          _updatePreferences();
        });
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // Check if BS6 is selected in engine type - handle different variations
    final isBS6Selected = selectedEngine != null && 
        (selectedEngine!.toUpperCase().contains('BS6') || 
         selectedEngine!.toUpperCase().contains('BS-6') ||
         selectedEngine!.toUpperCase().contains('BS 6'));
    
    // Debug print to see what engine is selected
    print('Selected engine: "$selectedEngine", isBS6Selected: $isBS6Selected');
    
    return Row(
      children: [
        AppButton(
          title: context.appText.cancel,
          style: AppButtonStyle.outline,
          onPressed: widget.onCancel,
        ).expand(),
        20.width,
        AppButton(
          title: isBS6Selected ? 'Support' : context.appText.apply,
          style: AppButtonStyle.primary,
          onPressed: () {
            if (isBS6Selected) {
              widget.onSupport?.call();
            } else if (!_isFormValid) {
              // Show validation popup
              AppDialog.show(
              context,
              child: CommonDialogView(
              heading: 'Validation Error',
              message: 'Please select Make and Model',
              onSingleButtonText: "OK",
              onTapSingleButton: (){
                Navigator.of(context).pop();
                },
              ),
            );
            } else {
              widget.onApply();
            }
          },
        ).expand(),
      ],
    );
  }
} 