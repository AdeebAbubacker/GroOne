import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

class SearchableDropdown extends StatelessWidget {
  final String? selectedItem;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;
  final bool showSearchBox;
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
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      selectedItem: selectedItem,
      items: (String filter, _) async {
        return items
            .where((v) => v.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      },
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox,
        // constraints: const BoxConstraints(maxHeight: 250),
        emptyBuilder:  emptyBuilder ?? (context, searchEntry) => const Center(
          child: Text("No results found"),
        ),
        loadingBuilder: (context, searchEntry) =>
            const Center(child: CircularProgressIndicator()),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: commonInputDecoration(
          hintText: hintText,
        ),
      ),
      onChanged: onChanged,
      dropdownBuilder: dropdownBuilder,
    );
  }
}
