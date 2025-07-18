import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class AppFilePickerField extends StatefulWidget {
  final String? labelText;
  final bool mandatoryStar;
  final TextStyle? labelTextStyle;

  const AppFilePickerField({
    super.key,
    this.labelText,
    this.mandatoryStar = false,
    this.labelTextStyle,
  });

  @override
  State<AppFilePickerField> createState() => _AppFilePickerFieldState();
}

class _AppFilePickerFieldState extends State<AppFilePickerField> {
  String _fileName = '';

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Row(
            children: [
              Text(
                widget.labelText!,
                style: widget.labelTextStyle ?? AppTextStyle.textFiled,
              ),
              if (widget.mandatoryStar)
                Text(
                  " *",
                  style: (widget.labelTextStyle ?? AppTextStyle.textFiled)
                      .copyWith(color: Colors.red),
                ),
            ],
          ),
        if (widget.labelText != null) 6.height,
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0XFFE4E4E4),
                    border: Border.all(color: AppColors.borderColor),
                    borderRadius: BorderRadius.circular(commonTexFieldRadius),
                  ),
                  child: Text(
                    context.appText.chooseFiles,
                    style: AppTextStyle.textFiled.copyWith(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _fileName.isNotEmpty
                        ? _fileName
                        : context.appText.noFileChoosen,
                    style: AppTextStyle.textFiled.copyWith(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
