


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/validator.dart';

class AppCountSelector extends StatelessWidget {
  final String label;
  final bool isMandatory;
  final TextEditingController controller;
  final int minValue;
  final int maxValue;
  final Function(String? val)? onChanged;

  const AppCountSelector({
    super.key,
    required this.label,
    required this.controller,
    this.isMandatory = false,
    this.minValue = 0,
    this.maxValue = 9999,
    this.onChanged,
  });

  void _increment() {
    print("tap increment");
    final current = int.tryParse(controller.text) ?? 0;
    if (current < maxValue) {
      controller.text = (current + 1).toString();
      if(onChanged!=null){
        onChanged!(controller.text);
      }
    }
  }

  void _decrement() {
    final current = int.tryParse(controller.text) ?? 0;
    if (current > minValue) {
      controller.text = (current - 1).toString();
      if(onChanged!=null){
        onChanged!(controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            if (isMandatory)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _decrement,
              ),
              SizedBox(
                width: 40,
                child: AppTextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (p0) {
                    print("working");
                    if(onChanged!=null){
                      print("changed number");
                      onChanged!(p0);
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],

                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) => Validator.fieldRequired(value),
                  // style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _increment,
              ),
            ],
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 10);
  }
}