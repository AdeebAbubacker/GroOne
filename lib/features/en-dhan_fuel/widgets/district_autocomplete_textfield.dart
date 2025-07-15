import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

class DistrictAutoCompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String)? onSelected;
  final void Function(int)? onDistrictSelected;
  final int? stateId;
  final String? Function(String?)? validator;

  const DistrictAutoCompleteTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.onSelected,
    this.onDistrictSelected,
    this.stateId,
    this.validator,
  });

  @override
  State<DistrictAutoCompleteTextField> createState() =>
      _DistrictAutoCompleteTextFieldState();
}

class _DistrictAutoCompleteTextFieldState
    extends State<DistrictAutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> allDistricts = [];
  List<Map<String, dynamic>> filteredDistricts = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    if (widget.stateId != null) {
      _loadDistricts();
    }
  }

  @override
  void didUpdateWidget(DistrictAutoCompleteTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stateId != oldWidget.stateId && widget.stateId != null) {
      _loadDistricts();
    }
  }

  Future<void> _loadDistricts() async {
    if (isLoading || widget.stateId == null) return;
    
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final cubit = locator<EnDhanCubit>();
      await cubit.fetchDistricts(widget.stateId!);
      
      setState(() {
        allDistricts = List.from(cubit.state.districts);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load districts';
        isLoading = false;
      });
    }
  }

  void _onChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredDistricts = allDistricts
          .where((district) => 
              (district['district_name'] ?? '').toString().toLowerCase().contains(query))
          .toList();

      if (filteredDistricts.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      filteredDistricts = [];
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
                maxHeight: (filteredDistricts.length * 56.0).clamp(0, 200),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredDistricts.length,
                itemBuilder: (context, index) {
                  final district = filteredDistricts[index];
                  final districtName = district['district_name'] ?? '';
                  final districtId = district['id'];
                  
                  return ListTile(
                    title: Text(
                      districtName,
                      style: AppTextStyle.body,
                    ),
                    onTap: () {
                      widget.controller.text = districtName;
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: districtName.length),
                      );
                      widget.onSelected?.call(districtName);
                      if (districtId != null) {
                        widget.onDistrictSelected?.call(districtId);
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
            readOnly: widget.stateId == null,
            validator: widget.validator,
            decoration: commonInputDecoration(
              hintText: widget.stateId == null ? 'Select state first' : widget.labelText,
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
              onPressed: _loadDistricts,
              child: Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
} 