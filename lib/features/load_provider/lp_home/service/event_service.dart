import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_event_api_request.dart';

class EventService {
  final ApiService _apiService;
  EventService(this._apiService);

  /// Create Event Service
  Future<Result<String?>> createEvent(CreateEventApiRequest request) async {
    try {
      final xApiKey = ApiUrls.xApiKey;
      final udid = ApiUrls.fetchUDID;
      
      final result = await _apiService.post(
        ApiUrls.createEvent,
        body: request.toJson(),
        customHeaders: {
          "accept": "application/json",
          "X-API-Key": xApiKey,
          "X-Application-UDID": udid,
          "Content-Type": "application/json",
        },
      );
      
      if (result is Success) {
        // Extract event_id from response
        String? eventId;
        try {
          final responseData = result.value;
          if (responseData['event_id'] != null) {
            eventId = responseData['event_id']?.toString();
          } else if (responseData['data'] != null && responseData['data']['event_id'] != null) {
            eventId = responseData['data']['event_id']?.toString();
          } else if (responseData['id'] != null) {
            eventId = responseData['id']?.toString();
          } else if (responseData['eventId'] != null) {
            eventId = responseData['eventId']?.toString();
          } else if (responseData['_id'] != null) {
            eventId = responseData['_id']?.toString();
          }
        } catch (e) {
          // If parsing fails, still return success but with null event_id
          eventId = null;
        }
        return Success(eventId);
      } else if (result is Error) {
        return Error(result.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }
}
