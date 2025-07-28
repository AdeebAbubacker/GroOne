import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_text_style.dart';
import '../cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import '../helper/gps_session_manager.dart';
import '../models/gps_geofence_model.dart';

class GpsShowHideGeofenceScreen extends StatefulWidget {
  const GpsShowHideGeofenceScreen({super.key});

  @override
  State<GpsShowHideGeofenceScreen> createState() =>
      _GpsShowHideGeofenceScreenState();
}

class _GpsShowHideGeofenceScreenState extends State<GpsShowHideGeofenceScreen> {
  final gpsGeofenceCubit = locator<GpsGeofenceCubit>();
  final Map<String, bool> toggledState = {}; // {geofenceId: true/false}
  bool selectAll = true;

  @override
  void initState() {
    super.initState();
    gpsGeofenceCubit.loadGeofences();
    _loadSavedToggles();
  }

  Future<void> _loadSavedToggles() async {
    final savedToggles = await GpsSessionManager.getGeofenceToggleMap();
    setState(() {
      toggledState.addAll(savedToggles);
    });
  }


  String _getFormattedValue(GpsGeofenceModel item) {
    switch (item.shapeType) {
      case 'circle':
        return '${(item.radius ?? 0).toStringAsFixed(1)} m';
      case 'polygon':
      case 'polyline':
        return item.coveredArea ?? '';
      default:
        return '';
    }
  }

  void _toggleAll(List<GpsGeofenceModel> geofences, bool value) async {
    for (final g in geofences) {
      toggledState[g.id] = value;
    }
    setState(() {
      selectAll = value;
    });
    await GpsSessionManager.setGeofenceToggleMap(toggledState);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: context.appText.showHideGeofence,
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {},
            icon: Image.asset(AppIcons.png.moreVertical),
            iconColor: AppColors.primaryColor,
          ),
        ],
      ),
      body: BlocBuilder<GpsGeofenceCubit, GpsGeofenceState>(
        builder: (context, state) {
          if (state is GpsGeofenceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GpsGeofenceLoaded) {
            final geofences = state.geofences;

            // Determine global toggle status
            final allOn = geofences.every(
                  (g) => toggledState[g.id] ?? false,
            );
            if (allOn != selectAll) selectAll = allOn;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select All', style: AppTextStyle.h5),
                    Switch(
                      value: selectAll,
                      activeTrackColor: AppColors.activeGreenColor,
                      activeColor: Colors.white,
                      onChanged: (value) {
                        _toggleAll(geofences, value);
                      },
                    ),
                  ],
                ).paddingOnly(left: 15, right: 30),
                ...geofences.map((geofence) {
                  final isOn = toggledState[geofence.id] ?? false;
                  return Card(
                    color: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        '${geofence.name} (${_getFormattedValue(geofence)})',
                        style: AppTextStyle.h6,
                      ),
                      trailing: Switch(
                        value: isOn,
                        activeTrackColor: AppColors.activeGreenColor,
                        activeColor: Colors.white,
                          onChanged: (val) async {
                            setState(() {
                              toggledState[geofence.id] = val;
                            });
                            await GpsSessionManager.setGeofenceToggleMap(toggledState);
                          }
                      ),
                    ),
                  );
                }),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
