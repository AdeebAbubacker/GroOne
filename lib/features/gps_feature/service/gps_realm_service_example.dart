import '../model/gps_combined_vehicle_model.dart';
import '../model/gps_login_model.dart';
import '../model/gps_user_details_model.dart';
import 'gps_realm_service.dart';

/// Example usage of the enhanced GPS Realm Service
/// This file demonstrates how to use all the store and get functions
class GpsRealmServiceExample {
  final GpsRealmService _realmService = GpsRealmService();

  /// Example: Complete GPS data management workflow
  Future<void> demonstrateCompleteWorkflow() async {
    try {
      print("🚀 Starting GPS Realm Service Demo");

      // 1. Save login response
      await _saveLoginData();

      // 2. Save user details
      await _saveUserDetails();

      // 3. Save vehicle data
      await _saveVehicleData();

      // 4. Demonstrate data retrieval
      await _demonstrateDataRetrieval();

      // 5. Demonstrate data updates
      await _demonstrateDataUpdates();

      // 6. Show data summary
      await _showDataSummary();

      print("✅ GPS Realm Service Demo completed successfully");
    } catch (e) {
      print("❌ Error in GPS Realm Service Demo: $e");
    } finally {
      // Always close the realm service
      _realmService.close();
    }
  }

  /// Example: Save login data
  Future<void> _saveLoginData() async {
    print("\n📝 Saving login data...");

    final loginResponse = GpsLoginResponseModel(
      token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      refreshToken: "refresh_token_12345",
    );

    await _realmService.saveLoginResponse(loginResponse);
    print("✅ Login data saved successfully");
  }

  /// Example: Save user details
  Future<void> _saveUserDetails() async {
    print("\n👤 Saving user details...");

    final userDetails = GpsUserDetailsModel(
      id: 163,
      name: "John Doe",
      email: "john.doe@example.com",
      disabled: 0,
      attributes: GpsUserAttributes(email: "john.doe@example.com"),
    );

    await _realmService.saveUserDetails(userDetails);
    print("✅ User details saved successfully");
  }

  /// Example: Save vehicle data
  Future<void> _saveVehicleData() async {
    print("\n🚗 Saving vehicle data...");

    final vehicles = [
      GpsCombinedVehicleData(
        deviceId: 1001,
        vehicleNumber: "MH12AB1234",
        status: "IGNITION_ON",
        statusDuration: "2h ago",
        location: "Mumbai, Maharashtra",
        networkSignal: 85,
        hasGPS: true,
        odoReading: "45,230 km",
        todayDistance: "120 km",
        lastSpeed: "65 km/h",
        lastUpdate: DateTime.now().subtract(const Duration(hours: 2)),
        isExpiringSoon: false,
      ),
      GpsCombinedVehicleData(
        deviceId: 1002,
        vehicleNumber: "DL01CD5678",
        status: "IGNITION_OFF",
        statusDuration: "1d ago",
        location: "Delhi, Delhi",
        networkSignal: 72,
        hasGPS: true,
        odoReading: "32,150 km",
        todayDistance: "0 km",
        lastSpeed: "0 km/h",
        lastUpdate: DateTime.now().subtract(const Duration(days: 1)),
        isExpiringSoon: true,
      ),
    ];

    await _realmService.saveVehicleData(vehicles);
    print("✅ Vehicle data saved successfully (${vehicles.length} vehicles)");
  }

  /// Example: Demonstrate data retrieval
  Future<void> _demonstrateDataRetrieval() async {
    print("\n📖 Demonstrating data retrieval...");

    // Check if user is logged in
    final isLoggedIn = await _realmService.isUserLoggedIn();
    print("🔐 User logged in: $isLoggedIn");

    // Get login response
    final loginResponse = await _realmService.getLoginResponse();
    if (loginResponse != null) {
      print("🔑 Token: ${loginResponse.token?.substring(0, 20)}...");
    }

    // Get user details
    final userDetails = await _realmService.getUserDetails();
    if (userDetails != null) {
      print("👤 User: ${userDetails.name} (${userDetails.email})");
    }

    // Get all vehicle data
    final vehicles = await _realmService.getAllVehicleData();
    print("🚗 Total vehicles: ${vehicles.length}");

    // Get specific vehicle by ID
    final specificVehicle = await _realmService.getVehicleDataById(1001);
    if (specificVehicle != null) {
      print(
        "🎯 Specific vehicle: ${specificVehicle.vehicleNumber} - ${specificVehicle.status}",
      );
    }

    // Check data availability
    final hasVehicleData = await _realmService.hasVehicleData();
    final vehicleCount = await _realmService.getVehicleCount();
    print("📊 Has vehicle data: $hasVehicleData, Count: $vehicleCount");
  }

  /// Example: Demonstrate data updates
  Future<void> _demonstrateDataUpdates() async {
    print("\n🔄 Demonstrating data updates...");

    // Update login response
    final updatedLoginResponse = GpsLoginResponseModel(
      token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...updated",
      refreshToken: "refresh_token_updated_12345",
    );
    await _realmService.updateLoginResponse(updatedLoginResponse);
    print("✅ Login response updated");

    // Update user details
    final updatedUserDetails = GpsUserDetailsModel(
      id: 163,
      name: "John Doe (Updated)",
      email: "john.doe.updated@example.com",
      disabled: 0,
      attributes: GpsUserAttributes(email: "john.doe.updated@example.com"),
    );
    await _realmService.updateUserDetails(updatedUserDetails);
    print("✅ User details updated");

    // Update specific vehicle
    final updatedVehicle = GpsCombinedVehicleData(
      deviceId: 1001,
      vehicleNumber: "MH12AB1234",
      status: "IDLE",
      statusDuration: "5m ago",
      location: "Mumbai, Maharashtra (Updated)",
      networkSignal: 90,
      hasGPS: true,
      odoReading: "45,250 km",
      todayDistance: "130 km",
      lastSpeed: "0 km/h",
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
      isExpiringSoon: false,
    );
    await _realmService.updateVehicleData(updatedVehicle);
    print("✅ Vehicle data updated");
  }

  /// Example: Show data summary
  Future<void> _showDataSummary() async {
    print("\n📊 Data Summary:");

    final summary = await _realmService.getDataSummary();
    print("📈 Vehicle count: ${summary['vehicleCount']}");
    print("🔐 Has login data: ${summary['hasLoginData']}");
    print("👤 Has user details: ${summary['hasUserDetails']}");
    print("🕒 Last updated: ${summary['lastUpdated']}");
  }

  /// Example: Clear specific data types
  Future<void> demonstrateDataClearing() async {
    print("\n🗑️ Demonstrating data clearing...");

    // Clear only vehicle data
    await _realmService.clearVehicleData();
    print("✅ Vehicle data cleared");

    // Clear only login data
    await _realmService.clearLoginData();
    print("✅ Login data cleared");

    // Clear only user details
    await _realmService.clearUserDetails();
    print("✅ User details cleared");

    // Clear all data
    await _realmService.clearAllData();
    print("✅ All data cleared");
  }

  /// Example: Error handling
  Future<void> demonstrateErrorHandling() async {
    print("\n⚠️ Demonstrating error handling...");

    try {
      // Try to get data from uninitialized service
      final newService = GpsRealmService();
      await newService.getAllVehicleData();
    } catch (e) {
      print("❌ Expected error caught: $e");
    }

    try {
      // Try to get vehicle with invalid ID
      final vehicle = await _realmService.getVehicleDataById(99999);
      if (vehicle == null) {
        print("ℹ️ Vehicle not found (expected behavior)");
      }
    } catch (e) {
      print("❌ Unexpected error: $e");
    }
  }
}

/// Usage example in a widget or service
class GpsRealmUsageExample {
  static Future<void> initializeAndUseRealm() async {
    final example = GpsRealmServiceExample();

    // Run the complete workflow
    await example.demonstrateCompleteWorkflow();

    // Or run specific operations
    // await example.demonstrateDataClearing();
    // await example.demonstrateErrorHandling();
  }
}
