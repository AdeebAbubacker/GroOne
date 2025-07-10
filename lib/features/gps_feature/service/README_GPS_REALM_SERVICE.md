# GPS Realm Service Documentation

## Overview

The `GpsRealmService` is a comprehensive local storage solution for GPS-related data using Realm database. It provides efficient storage, retrieval, and management of vehicle data, user authentication, and user details.

## Features

### 🔐 Authentication Management
- Store and retrieve login tokens
- Manage refresh tokens
- Check user login status
- Update authentication data

### 🚗 Vehicle Data Management
- Store multiple vehicle information
- Retrieve vehicles by device ID
- Update individual vehicle data
- Get vehicle statistics and counts

### 👤 User Details Management
- Store user profile information
- Retrieve user details
- Update user information
- Manage user attributes

### 📊 Data Operations
- Comprehensive data summary
- Selective data clearing
- Bulk operations
- Error handling

## File Structure

```
lib/features/gps_feature/service/
├── gps_realm_service.dart              # Main realm service
├── gps_realm_service_example.dart      # Usage examples
└── README_GPS_REALM_SERVICE.md        # This documentation

lib/features/gps_feature/model/
├── gps_combined_vehicle_realm_model.dart
├── gps_login_realm_model.dart
├── gps_user_details_realm_model.dart
└── [other model files]
```

## Usage Examples

### Basic Initialization

```dart
final realmService = GpsRealmService();

// Always close when done
realmService.close();
```

### Authentication Operations

```dart
// Save login response
final loginResponse = GpsLoginResponseModel(
  token: "your_jwt_token",
  refreshToken: "refresh_token",
);
await realmService.saveLoginResponse(loginResponse);

// Check if user is logged in
final isLoggedIn = await realmService.isUserLoggedIn();

// Get stored login data
final storedLogin = await realmService.getLoginResponse();

// Update login data
await realmService.updateLoginResponse(updatedLoginResponse);

// Clear login data
await realmService.clearLoginData();
```

### Vehicle Data Operations

```dart
// Save multiple vehicles
final vehicles = [
  GpsCombinedVehicleData(
    deviceId: 1001,
    vehicleNumber: "MH12AB1234",
    status: "IGNITION_ON",
    // ... other properties
  ),
  // ... more vehicles
];
await realmService.saveVehicleData(vehicles);

// Get all vehicles
final allVehicles = await realmService.getAllVehicleData();

// Get specific vehicle
final vehicle = await realmService.getVehicleDataById(1001);

// Update specific vehicle
await realmService.updateVehicleData(updatedVehicle);

// Check data availability
final hasData = await realmService.hasVehicleData();
final count = await realmService.getVehicleCount();

// Clear vehicle data
await realmService.clearVehicleData();
```

### User Details Operations

```dart
// Save user details
final userDetails = GpsUserDetailsModel(
  id: 163,
  name: "John Doe",
  email: "john@example.com",
  // ... other properties
);
await realmService.saveUserDetails(userDetails);

// Get user details
final storedUser = await realmService.getUserDetails();

// Update user details
await realmService.updateUserDetails(updatedUserDetails);

// Clear user details
await realmService.clearUserDetails();
```

### General Operations

```dart
// Get data summary
final summary = await realmService.getDataSummary();
print("Vehicle count: ${summary['vehicleCount']}");
print("Has login data: ${summary['hasLoginData']}");
print("Has user details: ${summary['hasUserDetails']}");

// Clear all data
await realmService.clearAllData();
```

## API Reference

### Vehicle Data Methods

| Method | Description | Parameters | Returns |
|--------|-------------|------------|---------|
| `saveVehicleData()` | Save multiple vehicles | `List<GpsCombinedVehicleData>` | `Future<void>` |
| `getAllVehicleData()` | Get all vehicles | None | `Future<List<GpsCombinedVehicleData>>` |
| `getVehicleDataById()` | Get vehicle by device ID | `int deviceId` | `Future<GpsCombinedVehicleData?>` |
| `updateVehicleData()` | Update specific vehicle | `GpsCombinedVehicleData` | `Future<void>` |
| `hasVehicleData()` | Check if vehicles exist | None | `Future<bool>` |
| `getVehicleCount()` | Get vehicle count | None | `Future<int>` |
| `clearVehicleData()` | Clear all vehicle data | None | `Future<void>` |

### Authentication Methods

| Method | Description | Parameters | Returns |
|--------|-------------|------------|---------|
| `saveLoginResponse()` | Save login data | `GpsLoginResponseModel` | `Future<void>` |
| `getLoginResponse()` | Get stored login data | None | `Future<GpsLoginResponseModel?>` |
| `updateLoginResponse()` | Update login data | `GpsLoginResponseModel` | `Future<void>` |
| `isUserLoggedIn()` | Check login status | None | `Future<bool>` |
| `clearLoginData()` | Clear login data | None | `Future<void>` |

### User Details Methods

| Method | Description | Parameters | Returns |
|--------|-------------|------------|---------|
| `saveUserDetails()` | Save user details | `GpsUserDetailsModel` | `Future<void>` |
| `getUserDetails()` | Get stored user details | None | `Future<GpsUserDetailsModel?>` |
| `updateUserDetails()` | Update user details | `GpsUserDetailsModel` | `Future<void>` |
| `clearUserDetails()` | Clear user details | None | `Future<void>` |

### General Methods

| Method | Description | Parameters | Returns |
|--------|-------------|------------|---------|
| `getDataSummary()` | Get data summary | None | `Future<Map<String, dynamic>>` |
| `clearAllData()` | Clear all data | None | `Future<void>` |
| `close()` | Close realm instance | None | `void` |

## Error Handling

The service includes comprehensive error handling:

- **Initialization errors**: Thrown when Realm fails to initialize
- **Storage errors**: Thrown when data cannot be saved
- **Retrieval errors**: Thrown when data cannot be read
- **Query errors**: Thrown when database queries fail

All methods include try-catch blocks and provide meaningful error messages.

## Best Practices

### 1. Resource Management
```dart
final realmService = GpsRealmService();
try {
  // Use the service
  await realmService.saveVehicleData(vehicles);
} finally {
  // Always close the service
  realmService.close();
}
```

### 2. Error Handling
```dart
try {
  await realmService.saveVehicleData(vehicles);
} catch (e) {
  print("Failed to save vehicle data: $e");
  // Handle error appropriately
}
```

### 3. Data Validation
```dart
// Check if data exists before operations
if (await realmService.hasVehicleData()) {
  final vehicles = await realmService.getAllVehicleData();
  // Process vehicles
}
```

### 4. Batch Operations
```dart
// For multiple operations, use a single realm instance
final realmService = GpsRealmService();
try {
  await realmService.saveLoginResponse(loginData);
  await realmService.saveUserDetails(userDetails);
  await realmService.saveVehicleData(vehicles);
} finally {
  realmService.close();
}
```

## Data Models

### GpsCombinedVehicleData
- `deviceId`: Unique device identifier
- `vehicleNumber`: Vehicle registration number
- `status`: Current vehicle status (IGNITION_ON, IGNITION_OFF, IDLE, etc.)
- `location`: Current location
- `networkSignal`: Signal strength
- `hasGPS`: GPS availability
- `lastUpdate`: Last update timestamp
- And more...

### GpsLoginResponseModel
- `token`: JWT authentication token
- `refreshToken`: Token for refreshing authentication

### GpsUserDetailsModel
- `id`: User ID
- `name`: User name
- `email`: User email
- `disabled`: Account status
- `attributes`: Additional user attributes

## Performance Considerations

1. **Lazy Initialization**: Realm is initialized only when needed
2. **Efficient Queries**: Uses indexed queries for fast retrieval
3. **Memory Management**: Proper cleanup with `close()` method
4. **Batch Operations**: Supports bulk data operations

## Migration Notes

When updating the service:
1. Run `dart run build_runner build` to regenerate Realm models
2. Test data migration with existing data
3. Update any dependent services using the realm service

## Troubleshooting

### Common Issues

1. **Realm initialization fails**
   - Check file permissions
   - Ensure proper directory access

2. **Data not persisting**
   - Verify `close()` is called properly
   - Check for exceptions in write operations

3. **Query errors**
   - Ensure proper data types in queries
   - Check for null values in required fields

### Debug Information

The service includes debug logging:
- 💾 Success operations
- ❌ Error operations
- 🗑️ Clear operations
- 🔒 Close operations

Enable debug mode to see detailed logs.

## Example Implementation

See `gps_realm_service_example.dart` for complete usage examples including:
- Complete workflow demonstration
- Error handling examples
- Data clearing operations
- Performance testing scenarios 