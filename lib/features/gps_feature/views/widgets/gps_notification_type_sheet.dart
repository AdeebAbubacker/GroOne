

import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class GpsNotificationTypesSheet extends StatefulWidget {
  const GpsNotificationTypesSheet({super.key});

  @override
  State<GpsNotificationTypesSheet> createState() => _GpsNotificationTypesSheetState();
}

class _GpsNotificationTypesSheetState extends State<GpsNotificationTypesSheet> {
  final Map<String, bool> notifications = {
    "Ignition On": true,
    "Ignition Off": true,
    "Geo-fence Enter": true,
    "Geo-fence Exit": true,
    "Device Over-speed": true,
    "Low Battery": true,
    "Power-Cut": false,
    "Power Restored": false,
    "Vibration": true,
    "SOS": true,
    "AC/Door On": true,
    "AC/Door Off": true,
    "Tow": true,
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Text(
                "Types of Notification",
                style: AppTextStyle.h4,
              ).paddingLeft(15),
              8.height,
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: notifications.entries.map((entry) {
                    return SwitchListTile(
                      title: Text(entry.key,style: AppTextStyle.h5,),
                      value: entry.value,
                      onChanged: (val) {
                        setState(() {
                          notifications[entry.key] = val;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
