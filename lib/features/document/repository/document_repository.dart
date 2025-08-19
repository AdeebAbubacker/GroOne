import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/features/document/model/document_type_response.dart';
import 'package:gro_one_app/features/document/services/document_service.dart';
import 'package:gro_one_app/utils/custom_log.dart';

class DocumentRepository {
 final DocumentService _documentService;

 const DocumentRepository(this._documentService);


 Future<Result<DocumentTypeResponseModel>> getDocumentType() async {
   try {
     return await _documentService.getDocumentType();
   } catch (e) {
     CustomLog.error(this, "Failed to get upload loadData ", e);
     return Error(ErrorWithMessage(message: e.toString()));
   }
 }
}