import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

class StateAutoCompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String)? onSelected;
  final void Function(int)? onStateSelected;
  final String? Function(String?)? validator;

  const StateAutoCompleteTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.onSelected,
    this.onStateSelected,
    this.validator,
  });

  @override
  State<StateAutoCompleteTextField> createState() =>
      _StateAutoCompleteTextFieldState();
}

class _StateAutoCompleteTextFieldState
    extends State<StateAutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> allStates = [];
  List<Map<String, dynamic>> filteredStates = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _loadStates();
  }

  Future<void> _loadStates() async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final cubit = locator<EnDhanCubit>();
      await cubit.fetchStates();
      
      setState(() {
        allStates = List.from(cubit.state.states);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load states';
        isLoading = false;
      });
    }
  }

  void _onChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredStates = allStates
          .where((state) => 
              (state['name'] ?? '').toString().toLowerCase().contains(query))
          .toList();

      if (filteredStates.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      filteredStates = [];
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
                maxHeight: (filteredStates.length * 56.0).clamp(0, 200),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredStates.length,
                itemBuilder: (context, index) {
                  final state = filteredStates[index];
                  final stateName = state['name'] ?? '';
                  final stateId = state['id'];
                  
                  return ListTile(
                    title: Text(
                      stateName,
                      style: AppTextStyle.body,
                    ),
                    onTap: () {
                      widget.controller.text = stateName;
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: stateName.length),
                      );
                      widget.onSelected?.call(stateName);
                      if (stateId != null) {
                        widget.onStateSelected?.call(stateId);
                      }
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: widget.controller,
            labelText: widget.labelText,
            validator: widget.validator,
            decoration: commonInputDecoration(
              hintText: widget.labelText,
              suffixIcon: isLoading 
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : hasError
                      ? Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 20,
                        )
                      : Icon(
                          CupertinoIcons.chevron_down,
                          color: Colors.grey,
                          size: 20,
                        ),
            ),
          ),
          if (hasError) ...[
            SizedBox(height: 4),
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4),
            TextButton(
              onPressed: _loadStates,
              child: Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
} 