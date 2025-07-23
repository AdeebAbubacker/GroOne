import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/global_variables.dart';

import '../../vp-helper/vp_helper.dart';


class DocumentEntity {
  String? title;
  String? fileType;
  int? documentTypeId;
  bool? visible;
  String? documentType;
  LoadDocument? loadDocument;
  bool? isLoading;
  bool? deleteLoading;


  DocumentEntity({
    this.title,
    this.fileType,
    this.documentTypeId,
    this.visible,
    this.documentType,
    this.loadDocument,
    this.isLoading,
    this.deleteLoading,
  });

  DocumentEntity copyWith({
    String? title,
    String? fileType,
    int? documentTypeId,
    bool? visible,
    String? documentType,
    LoadDocument? loadDocument,
    bool? isLoading,
    bool? deleteLoading,
    bool clearLoadData=false,
  }) {
    return DocumentEntity(
      deleteLoading: deleteLoading ?? this.deleteLoading,
      title: title ?? this.title,
      fileType: fileType ?? this.fileType,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      visible: visible ?? this.visible,
      documentType: documentType ?? this.documentType,
      loadDocument: clearLoadData? null: loadDocument ?? this.loadDocument,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

List<DocumentEntity> documentTypeList=[
  DocumentEntity(
    documentTypeId: 5,
    fileType: DocumentFileType.lorryReceipt.name,
    title:navigatorKey.currentState?.context.appText.uploadLorryReceipt,
    visible: true,
    isLoading: false,
    documentType: navigatorKey.currentState?.context.appText.lorryReceipt,
  ),
  DocumentEntity(
    documentTypeId: 6,
    fileType: DocumentFileType.ewayBill.name,
    title: navigatorKey.currentState?.context.appText.uploadEwayBill,
      visible: true,
    documentType: navigatorKey.currentState?.context.appText.ewayBill,
  ),
  DocumentEntity(
    documentTypeId: 7,
    fileType: DocumentFileType.materialInvoice.name,
    title:navigatorKey.currentState?.context.appText.uploadMaterialInvoice,
    visible: true,
    documentType: navigatorKey.currentState?.context.appText.materialInvoice,
  ),
  DocumentEntity(
    documentTypeId: 8,
    fileType: DocumentFileType.proofOfDocument.name,
    title:navigatorKey.currentState?.context.appText.uploadPOD,
    visible: false,
    documentType: navigatorKey.currentState?.context.appText.pod,

  ),

  DocumentEntity(

    documentTypeId: 309,
    fileType: DocumentFileType.uploadOtherDocument.name,
    title:navigatorKey.currentState?.context.appText.uploadOtherDocuments,
    visible: true,
    documentType: navigatorKey.currentState?.context.appText.uploadOtherDocuments,
  ),

];