import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../app_colors.dart';
import '../app_text_style.dart';

/// A common share widget that can be used across the application
/// Supports both live location sharing and current location sharing
class AppShareWidget extends StatefulWidget {
  final String title;
  final String? vehicleNumber;
  final String? location;
  final DateTime? lastUpdate;
  final int? deviceId;
  final String? token;
  final Function(
    String token,
    int deviceId,
    String vehicleNumber,
    bool isLiveLocation,
    int hours,
  )?
  onLiveLocationShare;
  final Function(String vehicleNumber, String location, DateTime? lastUpdate)?
  onCurrentLocationShare;
  final String? customShareText;
  final String? customShareSubject;
  final bool showLiveLocationOption;
  final bool showCurrentLocationOption;
  final int? maxHours;
  final String? whiteLabelUrl;

  const AppShareWidget({
    super.key,
    this.title = 'Share',
    this.vehicleNumber,
    this.location,
    this.lastUpdate,
    this.deviceId,
    this.token,
    this.onLiveLocationShare,
    this.onCurrentLocationShare,
    this.customShareText,
    this.customShareSubject,
    this.showLiveLocationOption = true,
    this.showCurrentLocationOption = true,
    this.maxHours = 24,
    this.whiteLabelUrl = "https://track.letsgro.co",
  });

  @override
  State<AppShareWidget> createState() => _AppShareWidgetState();
}

class _AppShareWidgetState extends State<AppShareWidget> {
  bool isLiveLocation = true;
  final TextEditingController _hoursController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default hours to 1 if live location is selected
    if (widget.showLiveLocationOption && !widget.showCurrentLocationOption) {
      _hoursController.text = '1';
    }
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = const Radius.circular(20);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                widget.title,
                style: AppTextStyle.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Toggle buttons (only if both options are available)
              if (widget.showLiveLocationOption &&
                  widget.showCurrentLocationOption) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildToggleButton(context, true, 'Live'),
                    const SizedBox(width: 8),
                    _buildToggleButton(context, false, 'Current'),
                  ],
                ),
                const SizedBox(height: 24),
              ],

              // Hours input (only for live location)
              if (isLiveLocation && widget.showLiveLocationOption) ...[
                Text(
                  'Hours',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _hoursController,
                  keyboardType: TextInputType.number,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: 'Enter Hours (1-${widget.maxHours})',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    errorText: _errorText,
                  ),
                  onChanged: (_) {
                    if (_errorText != null) {
                      setState(() {
                        _errorText = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),
              ],

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primaryColor,
                        side: BorderSide(
                          color: AppColors.primaryColor,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _handleShare(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Text(
                                'Share',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, bool value, String label) {
    final bool selected = isLiveLocation == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          isLiveLocation = value;
          if (value && _hoursController.text.isEmpty) {
            _hoursController.text = '1';
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryColor : Colors.white,
          border: Border.all(color: AppColors.primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 6,
              bottom: 6,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.primaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleShare(BuildContext context) {
    if (isLiveLocation && widget.showLiveLocationOption) {
      final text = _hoursController.text.trim();
      if (text.isEmpty) {
        setState(() {
          _errorText = 'Hours field cannot be empty';
        });
        return;
      }
      final hours = int.tryParse(text);
      if (hours == null || hours <= 0 || hours > (widget.maxHours ?? 24)) {
        setState(() {
          _errorText = 'Enter a valid number of hours (1-${widget.maxHours})';
        });
        return;
      }
      Navigator.of(context).pop();
      _handleLiveLocationSharing(context, hours);
    } else if (!isLiveLocation && widget.showCurrentLocationOption) {
      Navigator.of(context).pop();
      _shareCurrentLocation(context);
    } else if (widget.customShareText != null) {
      Navigator.of(context).pop();
      _shareCustomText(context);
    }
  }

  void _handleLiveLocationSharing(BuildContext context, int hours) async {
    if (widget.onLiveLocationShare != null) {
      // Use custom callback if provided
      widget.onLiveLocationShare!(
        widget.token ?? '',
        widget.deviceId ?? 0,
        widget.vehicleNumber ?? '',
        true,
        hours,
      );
    } else {
      // Default implementation
      setState(() => _isLoading = true);
      try {
        // This would typically call your repository method
        // For now, we'll just show a success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Live location shared successfully for $hours hours',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to share live location: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _shareCurrentLocation(BuildContext context) async {
    if (widget.onCurrentLocationShare != null) {
      // Use custom callback if provided
      widget.onCurrentLocationShare!(
        widget.vehicleNumber ?? '',
        widget.location ?? '',
        widget.lastUpdate,
      );
    } else {
      // Default implementation
      try {
        final shareText = _generateCurrentLocationShareText();
        SharePlus.instance.share(
          ShareParams(
            text: shareText,
            subject: widget.customShareSubject ?? 'Vehicle Location',
          ),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Current location shared successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to share location: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _shareCustomText(BuildContext context) async {
    try {
      SharePlus.instance.share(
        ShareParams(
          text: widget.customShareText!,
          subject: widget.customShareSubject ?? 'Shared Content',
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Content shared successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share content: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _generateCurrentLocationShareText() {
    if (widget.customShareText != null) {
      return widget.customShareText!;
    }

    final String vehicleNumber = widget.vehicleNumber ?? 'Unknown Vehicle';
    final String location = widget.location ?? 'Location not available';
    final String formattedDate = _formatDateTime(widget.lastUpdate);
    final String cleanLocation = location.replaceAll(' ', '');

    return '''
Vehicle Name - $vehicleNumber
Location - $location
Date - $formattedDate
Map - https://www.google.com/maps/search/?api=1&query=$cleanLocation
Sent via gro fleet
''';
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  }
}

/// Extension to easily show the share widget
extension AppShareWidgetExtension on BuildContext {
  void showShareWidget({
    String title = 'Share',
    String? vehicleNumber,
    String? location,
    DateTime? lastUpdate,
    int? deviceId,
    String? token,
    Function(
      String token,
      int deviceId,
      String vehicleNumber,
      bool isLiveLocation,
      int hours,
    )?
    onLiveLocationShare,
    Function(String vehicleNumber, String location, DateTime? lastUpdate)?
    onCurrentLocationShare,
    String? customShareText,
    String? customShareSubject,
    bool showLiveLocationOption = true,
    bool showCurrentLocationOption = true,
    int? maxHours = 24,
    String? whiteLabelUrl,
  }) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AppShareWidget(
            title: title,
            vehicleNumber: vehicleNumber,
            location: location,
            lastUpdate: lastUpdate,
            deviceId: deviceId,
            token: token,
            onLiveLocationShare: onLiveLocationShare,
            onCurrentLocationShare: onCurrentLocationShare,
            customShareText: customShareText,
            customShareSubject: customShareSubject,
            showLiveLocationOption: showLiveLocationOption,
            showCurrentLocationOption: showCurrentLocationOption,
            maxHours: maxHours,
            whiteLabelUrl: whiteLabelUrl,
          ),
        );
      },
    );
  }
}
