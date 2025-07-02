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
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../utils/app_image.dart';
import '../../model/masters_model.dart';
import '../../model/choose_preference_model.dart';

class ChooseYourPreferenceForm extends StatefulWidget {
  final Function(ChoosePreferenceModel) onPreferenceChanged;
  final Function() onApply;
  final Function() onCancel;
  final Function()? onSupport;
  final bool showTitle;
  final Map<String, VehicleFilter> vehicleFilters;
  final ChoosePreferenceModel? initialValues;

  const ChooseYourPreferenceForm({
    super.key,
    required this.onPreferenceChanged,
    required this.onApply,
    required this.onCancel,
    this.onSupport,
    this.showTitle = true,
    required this.vehicleFilters,
    this.initialValues,
  });

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
      selectedMake = widget.initialValues!.make;
      selectedModel = widget.initialValues!.model;
      selectedEngine = widget.initialValues!.engine;
      selectedTankType = widget.initialValues!.tankType;
      selectedDeviceType = widget.initialValues!.deviceType;
    }
    _updatePreferences();
  }

  /// Updates the preferences and notifies the parent widget
  void _updatePreferences() {
    final preferences = ChoosePreferenceModel(
      make: selectedMake,
      model: selectedModel,
      engine: selectedEngine,
      tankType: selectedTankType,
      deviceType: selectedDeviceType,
    );
    widget.onPreferenceChanged(preferences);
  }

  /// Checks if the form has valid selections (make and model are required)
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
            // Title section - only shown when showTitle is true
            if (widget.showTitle) ...[
              Center(
                child: Text(
                  "Choose your Preference",
                  style: AppTextStyle.h4,
                ),
              ),
              15.height,
            ],
        
            // Vehicle make dropdown
            _buildMakeDropdown(context),
            10.height,

            // Vehicle model dropdown
            _buildModelDropdown(context),
            10.height,

            // Engine type dropdown
            _buildEngineDropdown(context),
            10.height,

            // Tank type dropdown
            _buildTankTypeDropdown(context),
            10.height,

            // Device type dropdown
            _buildDeviceTypeDropdown(context),
            20.height,

            // Action buttons (Cancel/Apply or Support)
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// Builds the vehicle make dropdown widget
  Widget _buildMakeDropdown(BuildContext context) {
    final makes = widget.vehicleFilters.keys.toList();
    
    return AppDropdown(
      labelText: "Make",
      mandatoryStar: true,
      dropdownValue: selectedMake,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...makes.map((make) => DropdownMenuItem(
          value: make,
          child: Text(make.capitalize),
        )),
      ],
      onChanged: (val) {
        setState(() {
          selectedMake = val;
          // Reset dependent fields when make changes
          selectedModel = null;
          selectedEngine = null;
          selectedTankType = null;
          selectedDeviceType = null;
          _updatePreferences();
        });
      },
    );
  }

  /// Builds the vehicle model dropdown widget
  Widget _buildModelDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final models = vehicleFilter?.models ?? [];

    return AppDropdown(
      labelText: "Model",
      mandatoryStar: true,
      dropdownValue: selectedModel,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...models.map((model) => DropdownMenuItem(
          value: model,
          child: Text(model.capitalize),
        )),
      ],
      onChanged: (val) {
        setState(() {
          selectedModel = val;
          _updatePreferences();
        });
      },
    );
  }

  /// Builds the engine type dropdown widget
  Widget _buildEngineDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final engines = vehicleFilter?.engineType ?? [];

    return AppDropdown(
      labelText: "Engine",
      dropdownValue: selectedEngine,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...engines.map((engine) => DropdownMenuItem(
          value: engine,
          child: Text(engine.capitalize),
        )),
      ],
      onChanged: (val) {
        setState(() {
          selectedEngine = val;
          _updatePreferences();
        });
      },
    );
  }

  /// Builds the tank type dropdown widget
  Widget _buildTankTypeDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final tankTypes = vehicleFilter?.tankType ?? [];

    return AppDropdown(
      labelText: "Tank Type",
      dropdownValue: selectedTankType,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...tankTypes.map((type) => DropdownMenuItem(
          value: type,
          child: Text(type.capitalize),
        )),
      ],
      onChanged: (val) {
        setState(() {
          selectedTankType = val;
          _updatePreferences();
        });
      },
    );
  }

  /// Builds the device type dropdown widget
  Widget _buildDeviceTypeDropdown(BuildContext context) {
    final vehicleFilter = selectedMake != null 
        ? widget.vehicleFilters[selectedMake]
        : null;
    final deviceTypes = vehicleFilter?.deviceType ?? [];

    return AppDropdown(
      labelText: "Device Type",
      dropdownValue: selectedDeviceType,
      dropDownList: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Select'),
        ),
        ...deviceTypes.map((type) => DropdownMenuItem(
          value: type,
          child: Text(type.capitalize),
        )),
      ],
      onChanged: (val) {
        setState(() {
          selectedDeviceType = val;
          _updatePreferences();
        });
      },
    );
  }

  /// Builds the action buttons section
  Widget _buildActionButtons(BuildContext context) {
    // Check if BS4 is selected in engine type - handle different variations
    final isBS4Selected = selectedEngine != null &&
        (selectedEngine!.toUpperCase().contains('BS4') ||
         selectedEngine!.toUpperCase().contains('BS-4') ||
         selectedEngine!.toUpperCase().contains('BS 4'));
    
    // Debug print to see what engine is selected
    print('Selected engine: "$selectedEngine", isBS4Selected: $isBS4Selected');
    
    return Row(
      children: [
        AppButton(
          title: context.appText.cancel,
          style: AppButtonStyle.outline,
          onPressed: widget.onCancel,
        ).expand(),
        20.width,
        AppButton(
          title: isBS4Selected ? 'Support' : context.appText.apply,
          style: AppButtonStyle.primary,
          onPressed: () {
            if (isBS4Selected) {
              widget.onSupport?.call();
            } else if (!_isFormValid) {
              // Show validation popup
              AppDialog.show(
                context,
                child: CommonDialogView(
                  heading: 'Validation Error',
                  message: 'Please select Make and Model',
                  onSingleButtonText: "OK",
                  onTapSingleButton: () {
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