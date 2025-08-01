import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';

class EnhancedDropdownField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? value;
  final List<Map<String, dynamic>> options;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool isLoading;
  final bool showDropdown;

  const EnhancedDropdownField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.isLoading = false,
    this.showDropdown = true,
  });

  @override
  State<EnhancedDropdownField> createState() => _EnhancedDropdownFieldState();
}

class _EnhancedDropdownFieldState extends State<EnhancedDropdownField> {
  String? selectedValue;
  String? selectedDisplayText;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
    _updateDisplayText();
  }

  @override
  void didUpdateWidget(EnhancedDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value || widget.options != oldWidget.options) {
      selectedValue = widget.value;
      // Use post frame callback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateDisplayText();
        }
      });
    }
  }

  void _updateDisplayText() {
    if (selectedValue != null && selectedValue!.isNotEmpty) {
      // Always show the selected value as-is first
      selectedDisplayText = selectedValue;
      
      // Then try to find a matching option if available
      if (widget.options.isNotEmpty) {
        // Try to find the option by ID first
        final option = widget.options.firstWhere(
          (opt) => opt['id'].toString() == selectedValue,
          orElse: () => <String, dynamic>{},
        );
        
        if (option.isNotEmpty) {
          // Found by ID, use the name from the option
          selectedDisplayText = option['name'] ?? selectedValue;
        } else {
          // Not found by ID, try to find by name (for cases where we have the name but not the exact ID)
          final nameOption = widget.options.firstWhere(
            (opt) => opt['name']?.toString().toLowerCase() == selectedValue!.toLowerCase(),
            orElse: () => <String, dynamic>{},
          );
          
          if (nameOption.isNotEmpty) {
            // Found by name, use the name from the option
            selectedDisplayText = nameOption['name'] ?? selectedValue;
          } else {
            // Not found by ID or name, keep the selected value as is
            // This handles cases where pincode API returns a district name not in master list
          }
        }
      } else {
        // If no options available, keep the selected value as is
        // This also handles cases where pincode API returns a district name not in master list
      }
    } else {
      selectedDisplayText = null;
    }
    _controller.text = selectedDisplayText ?? '';
  }

  void _showDropdown() {
    if (widget.options.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select ${widget.labelText}'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final optionId = option['id'].toString();
                final optionName = option['name'] ?? optionId;
                final isSelected = selectedValue == optionId;
                
                return ListTile(
                  title: Text(optionName),
                  trailing: isSelected ? Icon(Icons.check, color: AppColors.primaryColor) : null,
                  onTap: () {
                    setState(() {
                      selectedValue = optionId;
                      _updateDisplayText();
                    });
                    widget.onChanged(optionId);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text field on the left
        Expanded(
          child: AppTextField(
            labelText: widget.labelText,
            hintText: widget.hintText,
            controller: _controller,
            readOnly: true,
            validator: widget.validator,
            decoration: commonInputDecoration(
              hintText: widget.hintText,
              fillColor: selectedDisplayText != null ? AppColors.disabledFieldBackgroundColor : null,
              focusColor: selectedDisplayText != null ? AppColors.disabledFieldBackgroundColor : null,
            ),
          ),
        ),
        
        // Dropdown button on the right (only show if showDropdown is true)
        if (widget.showDropdown)
          Container(
            margin: const EdgeInsets.only(left: 8, top: 22),
            child: InkWell(
              onTap: widget.isLoading ? null : _showDropdown,
              child: Container(
                height: 48, // Match the height of AppTextField
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderColor, width: 1),
                  borderRadius: BorderRadius.circular(commonTexFieldRadius),
                  color: Colors.white,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.isLoading)
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                          ),
                        )
                      else
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: AppColors.chevronGreyColor,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
} 