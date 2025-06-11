import '../../../data/model/result.dart';
import '../model/language_model.dart';
import '../service/language_service.dart';

class LanguageRepository {
  final LanguageService _service;

  LanguageRepository(this._service);

  Future<Result<List<LanguageModel>>> getLanguages() {
    return _service.fetchLanguages();
  }
}
