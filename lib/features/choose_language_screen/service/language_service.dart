import '../../../data/model/result.dart';
import '../../../data/network/api_service.dart';
import '../model/language_model.dart';

class LanguageService {
  final ApiService _apiService;
  LanguageService(this._apiService);

  Future<Result<List<LanguageModel>>> fetchLanguages() async {
    try {
      final response = await _apiService.get(
        'https://gro-devapi.letsgro.co/customer/api/v1/language',
        forceRefresh: true,
      );

      if (response is Success) {
        final data = response.value['data'] as List;
        final languages = data.map((e) => LanguageModel.fromJson(e)).toList();
        return Success(languages);
      } else if (response is Error) {
        return Error(response.type);
      } else {
        return Error(GenericError());
      }
    } catch (e) {
      return Error(DeserializationError());
    }
  }
}
