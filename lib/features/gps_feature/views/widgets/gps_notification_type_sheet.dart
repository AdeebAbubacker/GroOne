import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../cubit/gps_notification_type_sheet_cubit/gps_notification_type_sheet_cubit.dart';
import '../../cubit/gps_notification_type_sheet_cubit/gps_notification_type_sheet_state.dart';


class GpsNotificationTypesSheet extends StatefulWidget {
  const GpsNotificationTypesSheet({super.key});

  @override
  State<GpsNotificationTypesSheet> createState() => _GpsNotificationTypesSheetState();
}

class _GpsNotificationTypesSheetState extends State<GpsNotificationTypesSheet> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GpsNotificationTypesSheetCubit>().fetchNotificationToggles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GpsNotificationTypesSheetCubit, GpsNotificationTypesSheetState>(
      builder: (context, state) {
        Map<String, bool> toggles = {};
        bool isLoading = false;
        String? error;

        if (state is GpsNotificationTypesLoading) {
          isLoading = true;
        } else if (state is GpsNotificationTypesLoaded) {
          toggles = state.toggles;
        } else if (state is GpsNotificationTypesError) {
          error = state.message;
        }

        return buildSheet(context, toggles, isLoading, error);
      },
    );
  }

  Widget buildSheet(
      BuildContext context,
      Map<String, bool> notifications,
      bool isLoading,
      String? error,
      ) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Text(context.appText.notificationTypesTitle, style: AppTextStyle.h4).paddingLeft(15),
              8.height,
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                    ? Center(child: Text(context.appText.notificationToggleError))
                    : ListView(
                  controller: scrollController,
                  children: notifications.entries.map((entry) {
                    return SwitchListTile(
                      title: Text(entry.key, style: AppTextStyle.h5),
                      value: entry.value,
                      onChanged: (val) {
                        context
                            .read<GpsNotificationTypesSheetCubit>()
                            .updateToggle(entry.key, val);
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
