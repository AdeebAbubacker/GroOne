import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_user_config_model.dart';

void main() {
  group('GPS User Config Model Tests', () {
    test('should parse user config JSON correctly', () {
      // Sample JSON data based on the provided response
      final jsonData = {
        "data": [
          {
            "activation_codes": 0,
            "activation_date": null,
            "after_login_page": 0,
            "alarm_settings": {"alarm": "off", "name": "Door", "type": "door"},
            "app_name": null,
            "auto_pan_map_geofence_loop": 0,
            "auto_pan_map_geofence_time": 10,
            "auto_rpt_email": 0,
            "auto_rpt_email_list": null,
            "calls_count": 1,
            "cng_notif": null,
            "custom_filter_update": null,
            "custom_zoom": 15,
            "default_map": "HERE_STREET",
            "device_details": {
              "androidVersion": "15",
              "app_version": "2.7",
              "deviceType": "ANDROID",
              "manufacturer": "vivo",
              "model": "I2223",
              "sdk": 35,
            },
            "device_token": "",
            "device_type": "ANDROID",
            "email_config": null,
            "fitness_notif": null,
            "five_year_permit_notif": null,
            "hbt_notif": null,
            "id": 41065,
            "ignition_off_time": null,
            "image_markers": 0,
            "insurance_notif": null,
            "is_third_party": 0,
            "is_waste_mgmt_visible": 0,
            "isload_unload_visible": 0,
            "last_login": null,
            "last_ten_mins": 1,
            "last_update_sms_mail_config": null,
            "list_view_settings": {
              "columns": [
                "door",
                "ac",
                "status",
                "select",
                "name",
                "speed",
                "fuel",
                "temperature",
                "bookmark",
                "lastUpdate",
                "view",
                "lastignition",
              ],
              "timeFormat": "normal",
            },
            "maintenance_notif_enable": 0,
            "maintenance_notif_receivers": null,
            "maintenance_reminders": null,
            "marker_animate": 1,
            "marker_cluster": 0,
            "marker_infobox": 0,
            "marker_label": 0,
            "marker_label_with_speed": 1,
            "marker_route_direction": 0,
            "national_permit_notif": null,
            "poi_label": 0,
            "pollution_notif": null,
            "privacy_policy_dev_id": null,
            "privacy_policy_dev_name": null,
            "privacy_policy_dev_tstamp": null,
            "register_date": "2021-10-13T06:42:57",
            "send_mail_from_email": null,
            "service_notif": null,
            "show_geofence_report": 0,
            "show_geofences": 0,
            "sms_config": null,
            "stock_mgmt": 0,
            "stop_time": "1",
            "third_party_value": null,
            "token_tax_notif": null,
            "total_dist_alerts": 0,
            "total_dist_distance_interval": null,
            "total_dist_email_list": null,
            "user_id": 163,
            "user_profile_pic":
                "https://firebasestorage.googleapis.com/v0/b/hlf-track.appspot.com/o/uploads%2FPROFILE_163.jpg.jpg?alt=media&token=dbca7f45-48cc-4046-aa9e-c6ab5b43a262",
            "user_type": "user",
            "variation": 0.0,
          },
        ],
      };

      // Parse the JSON
      final userConfig = GpsUserConfigModel.fromJson(jsonData);

      // Verify the model was created correctly
      expect(userConfig.data, isNotNull);
      expect(userConfig.data!.length, equals(1));

      final configData = userConfig.data!.first;
      expect(configData.userId, equals(163));
      expect(configData.userType, equals("user"));
      expect(configData.defaultMap, equals("HERE_STREET"));
      expect(configData.customZoom, equals(15));
      expect(configData.markerAnimate, equals(1));
      expect(configData.markerCluster, equals(0));

      // Test alarm settings
      expect(configData.alarmSettings, isNotNull);
      expect(configData.alarmSettings!.alarm, equals("off"));
      expect(configData.alarmSettings!.name, equals("Door"));
      expect(configData.alarmSettings!.type, equals("door"));

      // Test device details
      expect(configData.deviceDetails, isNotNull);
      expect(configData.deviceDetails!.androidVersion, equals("15"));
      expect(configData.deviceDetails!.appVersion, equals("2.7"));
      expect(configData.deviceDetails!.deviceType, equals("ANDROID"));
      expect(configData.deviceDetails!.manufacturer, equals("vivo"));
      expect(configData.deviceDetails!.model, equals("I2223"));
      expect(configData.deviceDetails!.sdk, equals(35));

      // Test list view settings
      expect(configData.listViewSettings, isNotNull);
      expect(configData.listViewSettings!.columns, isNotNull);
      expect(configData.listViewSettings!.columns!.length, equals(12));
      expect(configData.listViewSettings!.timeFormat, equals("normal"));

      // Test register date parsing
      expect(configData.registerDate, isNotNull);
      expect(configData.registerDate!.year, equals(2021));
      expect(configData.registerDate!.month, equals(10));
      expect(configData.registerDate!.day, equals(13));
    });

    test('should handle null values correctly', () {
      final jsonData = {
        "data": [
          {
            "activation_codes": null,
            "activation_date": null,
            "after_login_page": null,
            "alarm_settings": null,
            "app_name": null,
            "auto_pan_map_geofence_loop": null,
            "auto_pan_map_geofence_time": null,
            "auto_rpt_email": null,
            "auto_rpt_email_list": null,
            "calls_count": null,
            "cng_notif": null,
            "custom_filter_update": null,
            "custom_zoom": null,
            "default_map": null,
            "device_details": null,
            "device_token": null,
            "device_type": null,
            "email_config": null,
            "fitness_notif": null,
            "five_year_permit_notif": null,
            "hbt_notif": null,
            "id": null,
            "ignition_off_time": null,
            "image_markers": null,
            "insurance_notif": null,
            "is_third_party": null,
            "is_waste_mgmt_visible": null,
            "isload_unload_visible": null,
            "last_login": null,
            "last_ten_mins": null,
            "last_update_sms_mail_config": null,
            "list_view_settings": null,
            "maintenance_notif_enable": null,
            "maintenance_notif_receivers": null,
            "maintenance_reminders": null,
            "marker_animate": null,
            "marker_cluster": null,
            "marker_infobox": null,
            "marker_label": null,
            "marker_label_with_speed": null,
            "marker_route_direction": null,
            "national_permit_notif": null,
            "poi_label": null,
            "pollution_notif": null,
            "privacy_policy_dev_id": null,
            "privacy_policy_dev_name": null,
            "privacy_policy_dev_tstamp": null,
            "register_date": null,
            "send_mail_from_email": null,
            "service_notif": null,
            "show_geofence_report": null,
            "show_geofences": null,
            "sms_config": null,
            "stock_mgmt": null,
            "stop_time": null,
            "third_party_value": null,
            "token_tax_notif": null,
            "total_dist_alerts": null,
            "total_dist_distance_interval": null,
            "total_dist_email_list": null,
            "user_id": null,
            "user_profile_pic": null,
            "user_type": null,
            "variation": null,
          },
        ],
      };

      // Parse the JSON
      final userConfig = GpsUserConfigModel.fromJson(jsonData);

      // Verify the model handles null values correctly
      expect(userConfig.data, isNotNull);
      expect(userConfig.data!.length, equals(1));

      final configData = userConfig.data!.first;
      expect(configData.userId, isNull);
      expect(configData.userType, isNull);
      expect(configData.defaultMap, isNull);
      expect(configData.alarmSettings, isNull);
      expect(configData.deviceDetails, isNull);
      expect(configData.listViewSettings, isNull);
      expect(configData.registerDate, isNull);
    });

    test('should convert to JSON correctly', () {
      final userConfig = GpsUserConfigModel(
        data: [
          GpsUserConfigData(
            userId: 163,
            userType: "user",
            defaultMap: "HERE_STREET",
            customZoom: 15,
            markerAnimate: 1,
            markerCluster: 0,
            alarmSettings: GpsAlarmSettings(
              alarm: "off",
              name: "Door",
              type: "door",
            ),
            deviceDetails: GpsDeviceDetails(
              androidVersion: "15",
              appVersion: "2.7",
              deviceType: "ANDROID",
              manufacturer: "vivo",
              model: "I2223",
              sdk: 35,
            ),
            listViewSettings: GpsListViewSettings(
              columns: ["door", "ac", "status"],
              timeFormat: "normal",
            ),
            registerDate: DateTime(2021, 10, 13, 6, 42, 57),
          ),
        ],
      );

      final json = userConfig.toJson();

      expect(json["data"], isNotNull);
      expect(json["data"].length, equals(1));

      final configJson = json["data"][0];
      expect(configJson["user_id"], equals(163));
      expect(configJson["user_type"], equals("user"));
      expect(configJson["default_map"], equals("HERE_STREET"));
      expect(configJson["custom_zoom"], equals(15));
      expect(configJson["marker_animate"], equals(1));
      expect(configJson["marker_cluster"], equals(0));
    });
  });
}
