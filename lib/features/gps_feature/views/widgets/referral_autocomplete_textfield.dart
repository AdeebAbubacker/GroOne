import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kavach/model/kavach_user_model.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class ReferralAutoCompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String)? onSelected;

  const ReferralAutoCompleteTextField({
    super.key,
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
  List<KavachUserModel> allUsers = [];
  List<KavachUserModel> filteredUsers = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  final GpsOrderApiRepository _repository = locator<GpsOrderApiRepository>();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final result = await _repository.fetchUsers();
      if (result is Success<List<KavachUserModel>>) {
        setState(() {
          allUsers = result.value;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          errorMessage = result is Error<List<KavachUserModel>> ? result.type.getText(context) : 'Failed to load users';
          isLoading = false;
        });
      }
    } catch (e) {
      CustomLog.error(this, "Failed to load users", e);
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load users';
        isLoading = false;
      });
    }
  }

  void _onChanged() {
    final query = widget.controller.text.toLowerCase();
    if (query.isNotEmpty) {
      filteredUsers = allUsers
          .where((user) => 
              user.userName.toLowerCase().contains(query) ||
              user.empCode.toLowerCase().contains(query) ||
              '${user.empCode} ${user.userName}'.toLowerCase().contains(query))
          .toList();

      if (filteredUsers.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      filteredUsers = [];
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
                maxHeight: (filteredUsers.length * 56.0).clamp(0, 200),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    title: Text(
                      '${user.empCode} ${user.userName}',
                      style: AppTextStyle.body,
                    ),
                    onTap: () {
                      final displayText = '${user.empCode} ${user.userName}';
                      widget.controller.text = displayText;
                      widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: displayText.length),
                      );
                      widget.onSelected?.call(displayText);
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
                      : null,
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
              onPressed: _loadUsers,
              child: Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
} 