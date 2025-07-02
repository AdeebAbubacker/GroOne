import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class KavachMultiSelectionDropdown extends StatefulWidget {
  final String labelText;
  final String hintText;
  final List<String> items;
  final List<String> initialSelectedItems;
  final bool mandatoryStar;
  final void Function(List<String>) onSelectionChanged;
  final String? Function(List<String>?)? validator;

  const KavachMultiSelectionDropdown({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.items,
    this.initialSelectedItems = const [],
    this.mandatoryStar = false,
    required this.onSelectionChanged,
    this.validator,
  });

  @override
  State<KavachMultiSelectionDropdown> createState() => _KavachMultiSelectionDropdownState();
}

class _KavachMultiSelectionDropdownState extends State<KavachMultiSelectionDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _actionKey = GlobalKey();

  late List<String> selectedItems;

  @override
  void initState() {
    selectedItems = [...widget.initialSelectedItems];
    super.initState();
  }

  void toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      closeDropdown();
    }
  }

  void closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _actionKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        width: size.width,
        top: offset.dy + size.height + 5,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: widget.items.map((item) {
                final isSelected = selectedItems.contains(item);
                return ListTile(
                  leading: isSelected
                      ? const Icon(Icons.check_box, color: Colors.blue)
                      : const Icon(Icons.check_box_outline_blank),
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedItems.remove(item);
                      } else {
                        selectedItems.add(item);
                      }
                    });
                    widget.onSelectionChanged(selectedItems);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.labelText, style: const TextStyle(fontWeight: FontWeight.w500)),
            if (widget.mandatoryStar) const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          key: _actionKey,
          onTap: toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: selectedItems.isEmpty
                      ? Text(widget.hintText, style: TextStyle(color: Colors.grey.shade600))
                      : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedItems
                        .map(
                          (e) => Chip(
                        label: Text(e),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            selectedItems.remove(e);
                          });
                          widget.onSelectionChanged(selectedItems);
                        },
                      ),
                    )
                        .toList(),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    closeDropdown();
    super.dispose();
  }
}



