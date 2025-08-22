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
import '../../../../utils/app_searchabledropdown.dart';
import '../../model/kavach_masters_model.dart';
import '../../model/kavach_choose_preference_model.dart';

class ChooseYourPreferenceForm extends StatefulWidget {
  final Function(KavachChoosePreferenceModel) onPreferenceChanged;
  final Function() onApply;
  final Function() onCancel;
  final Function()? onSupport;
  final bool showTitle;
  final Map<String, KavachVehicleFilter> vehicleFilters;
  final KavachChoosePreferenceModel? initialValues;

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
    final preferences = KavachChoosePreferenceModel(
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

  /// Determines if a field should be enabled based on previous selections
  bool _isFieldEnabled(String fieldName) {
    switch (fieldName) {
      case 'make':
        return true; // Make is always enabled
      case 'model':
        return selectedMake != null; // Model enabled when make is selected
      case 'engine':
        return selectedMake != null && selectedModel != null; // Engine enabled when make and model are selected
      case 'tankType':
        return selectedMake != null && selectedModel != null && selectedEngine != null; // Tank type enabled when make, model, and engine are selected
      case 'deviceType':
        return selectedMake != null && selectedModel != null && selectedEngine != null && selectedTankType != null; // Device type enabled when make, model, engine, and tank type are selected
      default:
        return false;
    }
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
                  context.appText.chooseYourPreference,
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

    return SearchableDropdown(
      labelText: context.appText.make,
      mandatoryStar: true,
      selectedItem: selectedMake,
      items: makes,
      hintText: context.appText.select,
      onChanged: (val) {
        setState(() {
          selectedMake = val;
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

    return SearchableDropdown(
      labelText: context.appText.model,
      mandatoryStar: true,
      selectedItem: selectedModel,
      items: models,
      hintText: context.appText.select,
      onChanged: (val) {
        setState(() {
          selectedModel = val;
          selectedEngine = null;
          selectedTankType = null;
          selectedDeviceType = null;
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

    return SearchableDropdown(
      labelText: context.appText.engine,
      selectedItem: selectedEngine,
      items: engines,
      hintText: context.appText.select,
      onChanged: (val) {
        setState(() {
          selectedEngine = val;
          selectedTankType = null;
          selectedDeviceType = null;
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

    return SearchableDropdown(
      labelText: context.appText.tankType,
      selectedItem: selectedTankType,
      items: tankTypes,
      hintText: context.appText.select,
      onChanged: (val) {
        setState(() {
          selectedTankType = val;
          selectedDeviceType = null;
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

    return SearchableDropdown(
      labelText: context.appText.deviceType,
      selectedItem: selectedDeviceType,
      items: deviceTypes,
      hintText:context.appText.select,
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
    
    return Row(
      children: [
        AppButton(
          title: context.appText.cancel,
          style: AppButtonStyle.outline,
          onPressed: widget.onCancel,
        ).expand(),
        20.width,
        AppButton(
          title: isBS4Selected ? context.appText.support : context.appText.apply,
          style: AppButtonStyle.primary,
          onPressed: () {
            if (isBS4Selected) {
              widget.onSupport?.call();
            } else if (!_isFormValid) {
              // Show validation popup
              AppDialog.show(
                context,
                child: CommonDialogView(
                  heading: context.appText.validationError,
                  message: context.appText.pleaseSelectMakeAndModel,
                  onSingleButtonText: context.appText.ok,
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