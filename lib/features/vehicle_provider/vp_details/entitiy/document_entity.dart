import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';


class DocumentEntity {
  String? title;
  String? fileType;
  int? documentTypeId;
  bool? visible;
  String? documentType;
  LoadDocument? loadDocument;
  bool? isLoading;

  DocumentEntity({
    this.title,
    this.fileType,
    this.documentTypeId,
    this.visible,
    this.documentType,
    this.loadDocument,
    this.isLoading,
  });

  DocumentEntity copyWith({
    String? title,
    String? fileType,
    int? documentTypeId,
    bool? visible,
    String? documentType,
    LoadDocument? loadDocument,
    bool? isLoading,
  }) {
    return DocumentEntity(
      title: title ?? this.title,
      fileType: fileType ?? this.fileType,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      visible: visible ?? this.visible,
      documentType: documentType ?? this.documentType,
      loadDocument: loadDocument ?? this.loadDocument,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

List<DocumentEntity> documentTypeList=[
  DocumentEntity(
    documentTypeId: 5,
    fileType: "lorry_receipt",
    title: "Upload Lorry Receipt",
    visible: true,
    isLoading: false,
    documentType: "Lorry Receipt",

  ),
  DocumentEntity(
    documentTypeId: 6,
    fileType: "eway_bill",
    title: "Upload E-Way bill",
      visible: true,
    documentType: "Eway Bill",
  ),
  DocumentEntity(
    documentTypeId: 7,
    fileType: "material_invoice",
    title: "Upload Material Invoice",
    visible: true,
    documentType: "Material Invoice",

  ),

  DocumentEntity(
    documentTypeId: 8,
    fileType: "Proof_of_document",
    title: "Upload POD",
    visible: true,
    documentType: "Proof of Document",
  ),

];