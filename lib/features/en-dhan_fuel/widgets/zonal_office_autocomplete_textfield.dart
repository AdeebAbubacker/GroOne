import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

class ZonalOfficeAutoCompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String)? onSelected;
  final void Function(int)? onZonalOfficeSelected;
  final String? Function(String?)? validator;

  const ZonalOfficeAutoCompleteTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.onSelected,
    this.onZonalOfficeSelected,
    this.validator,
  });

  @override
  State<ZonalOfficeAutoCompleteTextField> createState() =>
      _ZonalOfficeAutoCompleteTextFieldState();
}

class _ZonalOfficeAutoCompleteTextFieldState
    extends State<ZonalOfficeAutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> allZonalOffices = [];
  List<Map<String, dynamic>> filteredZonalOffices = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _loadZonalOffices();
  }

  Future<void> _loadZonalOffices() async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final cubit = locator<EnDhanCubit>();
      await cubit.fetchZonalOffices();
      
      setState(() {
        allZonalOffices = List.from(cubit.state.zonalOffices);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load zonal offices';
        isLoading = false;
      });
    }
  }

  void _onChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredZonalOffices = allZonalOffices
          .where((office) => 
              (office['zone_name'] ?? '').toString().toLowerCase().contains(query))
          .toList();

      if (filteredZonalOffices.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      filteredZonalOffices = [];
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
                maxHeight: (filteredZonalOffices.length * 56.0).clamp(0, 200),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredZonalOffices.length,
                itemBuilder: (context, index) {
                  final office = filteredZonalOffices[index];
                  final zoneName = office['zone_name'] ?? '';
                  final zoneId = office['id'];
                  
                  return ListTile(
                    title: Text(
                      zoneName,
                      style: AppTextStyle.body,
                    ),
                    onTap: () {
                      widget.controller.text = zoneName;
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: zoneName.length),
                      );
                      widget.onSelected?.call(zoneName);
                      if (zoneId != null) {
                        widget.onZonalOfficeSelected?.call(zoneId);
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
              onPressed: _loadZonalOffices,
              child: Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
} 