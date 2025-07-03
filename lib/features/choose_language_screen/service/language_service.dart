import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/choose_language_screen/model/language_model.dart';

class LanguageService {
  final ApiService _apiService;
  LanguageService(this._apiService);

  Future<Result<List<LanguageModel>>> fetchLanguages() async {
    try {
      final url = ApiUrls.language;
      final response = await _apiService.get(url, forceRefresh: true);
      if (response is Success) {
        print("language ${response.value.toString()}");
        final data = response.value as List;
        final languages = data.map((e) => LanguageModel.fromJson(e)).toList();
        return Success(languages);
      } else if (response is Error) {
        print("language ${response.type.toString()}");
        return Error(response.type);
      } else {
        print("language GenericError");
        return Error(GenericError());
      }
    } catch (e) {
       print("language ${e.toString()}");
      return Error(DeserializationError());
    }
  }
}
