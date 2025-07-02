import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class ReferralAutoCompleteTextField extends StatefulWidget {
  final List<String> suggestions;
  final TextEditingController controller;
  final String labelText;
  final void Function(String)? onSelected;

  const ReferralAutoCompleteTextField({
    super.key,
    required this.suggestions,
    required this.controller,
    required this.labelText,
    this.onSelected,
  });

  @override
  State<ReferralAutoCompleteTextField> createState() =>
      _ReferralAutoCompleteTextFieldState();
}

class _ReferralAutoCompleteTextFieldState
    extends State<ReferralAutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<String> filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredSuggestions = widget.suggestions
          .where((item) => item.toLowerCase().contains(query))
          .toList();

      if (filteredSuggestions.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      filteredSuggestions = [];
      _removeOverlay();
    }
    setState(() {});
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4),
          child: Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: (filteredSuggestions.length * 56.0).clamp(0, 200),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = filteredSuggestions[index];
                  return ListTile(
                    title: Text(suggestion,style: AppTextStyle.body,),
                    onTap: () {
                      widget.controller.text = suggestion;
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: suggestion.length),
                      );
                      widget.onSelected?.call(suggestion);
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AppTextField(
        controller: widget.controller,
        labelText: widget.labelText,
      ),
    );
  }
}

