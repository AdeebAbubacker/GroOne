import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class SearchableDropdown extends StatelessWidget {
  final String? selectedItem;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final bool showSearchBox;
  final String? labelText;
  final bool mandatoryStar;
  final TextStyle? labelTextStyle;
  final DropdownSearchBuilder<String>? dropdownBuilder;
  final Widget Function(BuildContext, String)? emptyBuilder;
  

  const SearchableDropdown({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.showSearchBox = true,
    this.dropdownBuilder,
    this.emptyBuilder,
     this.labelText,
    this.mandatoryStar = false,
    this.labelTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              Text(
                " $labelText",
                style: labelTextStyle ?? AppTextStyle.textFiled,
              ),
              if (mandatoryStar)
                Text(
                  " *",
                  style: (labelTextStyle ?? AppTextStyle.textFiled)
                      .copyWith(color: Colors.red),
                ),
            ],
          ),
        if (labelText != null) 6.height,
        DropdownSearch<String>(
          selectedItem: selectedItem,

          items: (String filter, _) async {
            return items
                .where((v) => v.toLowerCase().contains(filter.toLowerCase()))
                .toList();
          },
          popupProps: PopupProps.menu(
            showSearchBox: showSearchBox,
            emptyBuilder: emptyBuilder ??
           (context, searchEntry) => const SizedBox(
              height: 120,
              child: Center(child: Text("No results found")),
            ),
            loadingBuilder: (context, searchEntry) =>
                const Center(child: CircularProgressIndicator()),
            constraints: BoxConstraints(
              maxHeight: items.isEmpty
                  ? 140 
                  : items.length <= 2
                      ? (items.length * 48 + 80).toDouble()
                      : 250,
            ),
             menuProps: MenuProps(
             backgroundColor: AppColors.white, 
            ), 
            searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: "${context.appText.search}...",
              hintStyle: AppTextStyle.bodyGreyColor.copyWith(color: AppColors.greyTextColor, fontWeight: FontWeight.w500, fontSize: 16),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),

          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: commonInputDecoration(
              hintText: hintText,
            ),
          ),
          onChanged: onChanged,
          dropdownBuilder: dropdownBuilder,
        ),
      ],
    );
  }
}
