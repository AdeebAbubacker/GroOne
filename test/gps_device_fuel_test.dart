import 'package:flutter_test/flutter_test.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_device_fuel_model.dart';

void main() {
  group('GPS Device Fuel Model Tests', () {
    test('should parse device fuel JSON correctly', () {
      // Sample JSON data based on the provided response
      final jsonData = {
        "data": [
          {
            "amount": "55",
            "device_id": 43,
            "fuel_filled": "2.5",
            "fuel_type": "Petrol",
            "id": 7640,
            "image_name": "",
            "mileage": "55",
            "payment_type": "Cash",
            "price_per_litre": "22",
            "timestamp": "2024-02-27T09:59:31",
            "total_distance": "49386.9",
            "total_engine_seconds": null,
            "transaction_id": null,
            "update_time": "2024-02-27T09:59:36",
            "user_id": 163,
          },
          {
            "amount": "1000",
            "device_id": 2274,
            "fuel_filled": "10.0",
            "fuel_type": "Petrol",
            "id": 10919,
            "image_name":
                "https://firebasestorage.googleapis.com/v0/b/gro-fleet-c146a.appspot.com/o/uploads%2FFUEL_2274_1748243755683.jpg?alt=media&token=6599e533-44b4-445f-8ce1-955c9e691546",
            "mileage": "10",
            "payment_type": "Cash",
            "price_per_litre": "100",
            "timestamp": "2025-05-26T07:15:55",
            "total_distance": "62722.9",
            "total_engine_seconds": null,
            "transaction_id": null,
            "update_time": "2025-05-26T07:16:03",
            "user_id": 163,
          },
        ],
        "success": true,
        "total": 2,
      };

      // Parse the JSON
      final deviceFuel = GpsDeviceFuelModel.fromJson(jsonData);

      // Verify the model was created correctly
      expect(deviceFuel.data, isNotNull);
      expect(deviceFuel.data!.length, equals(2));
      expect(deviceFuel.success, equals(true));
      expect(deviceFuel.total, equals(2));

      final fuelData1 = deviceFuel.data!.first;
      expect(fuelData1.id, equals(7640));
      expect(fuelData1.deviceId, equals(43));
      expect(fuelData1.amount, equals("55"));
      expect(fuelData1.fuelFilled, equals("2.5"));
      expect(fuelData1.fuelType, equals("Petrol"));
      expect(fuelData1.mileage, equals("55"));
      expect(fuelData1.paymentType, equals("Cash"));
      expect(fuelData1.pricePerLitre, equals("22"));
      expect(fuelData1.totalDistance, equals("49386.9"));
      expect(fuelData1.userId, equals(163));
      expect(fuelData1.imageName, equals(""));
      expect(fuelData1.totalEngineSeconds, isNull);
      expect(fuelData1.transactionId, isNull);

      // Test timestamp parsing
      expect(fuelData1.timestamp, isNotNull);
      expect(fuelData1.timestamp!.year, equals(2024));
      expect(fuelData1.timestamp!.month, equals(2));
      expect(fuelData1.timestamp!.day, equals(27));

      // Test update time parsing
      expect(fuelData1.updateTime, isNotNull);
      expect(fuelData1.updateTime!.year, equals(2024));
      expect(fuelData1.updateTime!.month, equals(2));
      expect(fuelData1.updateTime!.day, equals(27));

      final fuelData2 = deviceFuel.data![1];
      expect(fuelData2.id, equals(10919));
      expect(fuelData2.deviceId, equals(2274));
      expect(fuelData2.amount, equals("1000"));
      expect(fuelData2.fuelFilled, equals("10.0"));
      expect(fuelData2.fuelType, equals("Petrol"));
      expect(fuelData2.mileage, equals("10"));
      expect(fuelData2.paymentType, equals("Cash"));
      expect(fuelData2.pricePerLitre, equals("100"));
      expect(fuelData2.totalDistance, equals("62722.9"));
      expect(fuelData2.userId, equals(163));
      expect(fuelData2.imageName, contains("firebasestorage.googleapis.com"));
    });

    test('should handle null values correctly', () {
      final jsonData = {
        "data": [
          {
            "amount": null,
            "device_id": null,
            "fuel_filled": null,
            "fuel_type": null,
            "id": null,
            "image_name": null,
            "mileage": null,
            "payment_type": null,
            "price_per_litre": null,
            "timestamp": null,
            "total_distance": null,
            "total_engine_seconds": null,
            "transaction_id": null,
            "update_time": null,
            "user_id": null,
          },
        ],
        "success": null,
        "total": null,
      };

      // Parse the JSON
      final deviceFuel = GpsDeviceFuelModel.fromJson(jsonData);

      // Verify the model handles null values correctly
      expect(deviceFuel.data, isNotNull);
      expect(deviceFuel.data!.length, equals(1));
      expect(deviceFuel.success, isNull);
      expect(deviceFuel.total, isNull);

      final fuelData = deviceFuel.data!.first;
      expect(fuelData.id, isNull);
      expect(fuelData.deviceId, isNull);
      expect(fuelData.amount, isNull);
      expect(fuelData.fuelFilled, isNull);
      expect(fuelData.fuelType, isNull);
      expect(fuelData.mileage, isNull);
      expect(fuelData.paymentType, isNull);
      expect(fuelData.pricePerLitre, isNull);
      expect(fuelData.totalDistance, isNull);
      expect(fuelData.userId, isNull);
      expect(fuelData.imageName, isNull);
      expect(fuelData.totalEngineSeconds, isNull);
      expect(fuelData.transactionId, isNull);
      expect(fuelData.timestamp, isNull);
      expect(fuelData.updateTime, isNull);
    });

    test('should convert to JSON correctly', () {
      final deviceFuel = GpsDeviceFuelModel(
        data: [
          GpsDeviceFuelData(
            id: 7640,
            deviceId: 43,
            amount: "55",
            fuelFilled: "2.5",
            fuelType: "Petrol",
            mileage: "55",
            paymentType: "Cash",
            pricePerLitre: "22",
            timestamp: DateTime(2024, 2, 27, 9, 59, 31),
            totalDistance: "49386.9",
            userId: 163,
            imageName: "",
            updateTime: DateTime(2024, 2, 27, 9, 59, 36),
          ),
        ],
        success: true,
        total: 1,
      );

      final json = deviceFuel.toJson();

      expect(json["data"], isNotNull);
      expect(json["data"].length, equals(1));
      expect(json["success"], equals(true));
      expect(json["total"], equals(1));

      final fuelJson = json["data"][0];
      expect(fuelJson["id"], equals(7640));
      expect(fuelJson["device_id"], equals(43));
      expect(fuelJson["amount"], equals("55"));
      expect(fuelJson["fuel_filled"], equals("2.5"));
      expect(fuelJson["fuel_type"], equals("Petrol"));
      expect(fuelJson["mileage"], equals("55"));
      expect(fuelJson["payment_type"], equals("Cash"));
      expect(fuelJson["price_per_litre"], equals("22"));
      expect(fuelJson["total_distance"], equals("49386.9"));
      expect(fuelJson["user_id"], equals(163));
      expect(fuelJson["image_name"], equals(""));
    });
  });
}
