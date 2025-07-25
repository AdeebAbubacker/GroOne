import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_show_hide_geofence_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/widgets/gps_notification_type_sheet.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../cubit/gps_notification_type_sheet_cubit/gps_notification_type_sheet_cubit.dart';
import '../cubit/gps_settings_cubit/gps_settings_cubit.dart';
import '../cubit/gps_settings_cubit/gps_settings_state.dart';
import '../cubit/vehicle_list_cubit.dart';
import '../helper/gps_helper.dart';
import '../helper/gps_session_manager.dart';
import '../service/notification_settings_service.dart';
import 'gps_notification_screen.dart';

class GpsSettingsScreen extends StatefulWidget {
  const GpsSettingsScreen({super.key});

  @override
  State<GpsSettingsScreen> createState() => _GpsSettingsScreenState();
}

class _GpsSettingsScreenState extends State<GpsSettingsScreen> {
  bool _showMarkerLabel = GpsSessionManager.isShowMarkerLabelEnabled();
  bool _showMarkerCluster = GpsSessionManager.isShowMarkerClusterEnabled();
  final uri = GpsSessionManager.getNotificationToneUri();
  String? _notificationToneUri;

  @override
  void initState() {
    super.initState();
    _notificationToneUri = GpsSessionManager.getNotificationToneUri();
  }

  void showGpsNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: locator<GpsNotificationTypesSheetCubit>(),
          child: const GpsNotificationTypesSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final toneTitle =
        _notificationToneUri != null
            ? GpsHelper.extractRingtoneTitle(_notificationToneUri!)
            : context.appText.notificationToneDefault;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: context.appText.appSettings,
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              final vehicleListCubit = locator<VehicleListCubit>();
              // Only load data if not already loaded
              if (!vehicleListCubit.hasLoadedData) {
                vehicleListCubit.loadVehicleData();
              } else {
                debugPrint(
                  "📍 GpsGeofenceScreen - Vehicle data already loaded, skipping loadVehicleData call",
                );
              }

              Navigator.push(
                context,
                commonRoute(
                  BlocProvider.value(
                    value: vehicleListCubit,
                    child: GpsNotificationScreen(),
                  ),
                ),
              );
            },
            icon: SvgPicture.asset(AppIcons.svg.notification, height: 20),
            iconColor: AppColors.primaryColor,
          ),
          AppIconButton(
            onPressed: () {},
            icon: Image.asset(AppIcons.png.moreVertical),
            iconColor: AppColors.primaryColor,
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                BlocBuilder<GpsSettingsCubit, GpsSettingsState>(
                  builder: (context, state) {
                    final isEnabled =
                        state is GpsSettingsSuccess
                            ? state.isEnabled
                            : GpsSessionManager.isNotificationEnabled();

                    return SwitchListTile(
                      title: Text(
                        context.appText.notification,
                        style: AppTextStyle.h5,
                      ),
                      value: isEnabled,
                      onChanged: (val) {
                        context.read<GpsSettingsCubit>().toggleNotification(
                          val,
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    context.appText.typesOfNotifications,
                    style: AppTextStyle.h5,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showGpsNotificationSheet(context);
                  },
                ),
                Visibility(
                  visible: Platform.isAndroid,
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.appText.notificationTone,
                            style: AppTextStyle.h5,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            toneTitle ??
                                context.appText.notificationToneDefault,
                            style: AppTextStyle.h5GreyColor,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        5.width,
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () async {
                      if (Platform.isAndroid) {
                        final hasPermission =
                            await GpsHelper.checkNotificationPermission();
                        if (!hasPermission) {
                          ToastMessages.alert(
                            message:
                                context.appText.notificationTonePermissionAlert,
                          );
                          return;
                        }
                        final uri = await RingtonePicker.pickRingtone();
                        if (uri != null) {
                          await GpsSessionManager.setNotificationToneUri(uri);
                          setState(() => _notificationToneUri = uri);
                          ToastMessages.success(
                            message: context.appText.notificationToneUpdated,
                          );
                        }
                      }
                    },
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.appText.onlineVehicleColor,
                          style: AppTextStyle.h5,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(color: Colors.green),
                      ),
                      10.width,
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.appText.testNotification,
                          style: AppTextStyle.h5,
                        ),
                      ),
                      Text(
                        context.appText.send,
                        style: AppTextStyle.h5PrimaryColor,
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    context.appText.showHideGeofence,
                    style: AppTextStyle.h5,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      commonRoute(GpsShowHideGeofenceScreen()),
                    );
                  },
                ),
                SwitchListTile(
                  title: Text(
                    context.appText.showMarkerLabel,
                    style: AppTextStyle.h5,
                  ),
                  value: _showMarkerLabel,
                  onChanged: (val) async {
                    setState(() => _showMarkerLabel = val);
                    await GpsSessionManager.setShowMarkerLabel(val);
                  },
                ),
                SwitchListTile(
                  title: Text(
                    context.appText.showMarkerCluster,
                    style: AppTextStyle.h5,
                  ),
                  value: _showMarkerCluster,
                  onChanged: (val) async {
                    setState(() => _showMarkerCluster = val);
                    await GpsSessionManager.setShowMarkerCluster(val);
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: commonContainerDecoration(),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.appText.vehicleListSort,
                          style: AppTextStyle.h5,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Default",
                          style: AppTextStyle.h5GreyColor,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      5.width,
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.appText.vehicleIconSize,
                          style: AppTextStyle.h5,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Default",
                          style: AppTextStyle.h5GreyColor,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      5.width,
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
