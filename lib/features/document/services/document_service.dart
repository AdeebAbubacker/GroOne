import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/network/api_service.dart';
import 'package:gro_one_app/data/network/api_urls.dart';
import 'package:gro_one_app/features/document/model/document_type_response.dart';

class DocumentService {
  final ApiService _apiService;


  const DocumentService(this._apiService);


  Future<Result<DocumentTypeResponseModel>> getDocumentType() async {
    try {
      final url = ApiUrls.getDocumentType;
      final result = await _apiService.get(url);
      if (result is Success) {
        final documentTypeResponse = DocumentTypeResponseModel.fromJson(result.value);
        return Success(documentTypeResponse);
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