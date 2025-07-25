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