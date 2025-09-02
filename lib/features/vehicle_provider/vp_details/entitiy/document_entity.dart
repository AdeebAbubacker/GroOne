import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
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
  List<LoadDocument>? loadDocument;
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
    List<LoadDocument>? loadDocument,
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



class DocumentDataModel {
  static List<DocumentEntity> documentTypeList=[];
  static DocumentEntity? damageDocumentEntity;
  static DocumentEntity? supportDocumentEntity;


  static void setDocumentEntityList(){
    documentTypeList=[
      DocumentEntity(
        documentTypeId: null,
        fileType: DocumentFileType.lorryReceipt.name,
        title:navigatorKey.currentState?.context.appText.uploadLorryReceipt,
        visible: true,
        isLoading: false,
        documentType:DocumentFileType.lorryReceipt.documentType,
      )..loadDocumentTypeId(DocumentFileType.lorryReceipt.documentType),
      DocumentEntity(
        documentTypeId: null,
        fileType: DocumentFileType.ewayBill.name,
        title: navigatorKey.currentState?.context.appText.uploadEwayBill,
        visible: true,
        documentType: DocumentFileType.ewayBill.documentType,
      )..loadDocumentTypeId(DocumentFileType.ewayBill.documentType),
      DocumentEntity(
        documentTypeId: null,
        fileType: DocumentFileType.materialInvoice.name,
        title:navigatorKey.currentState?.context.appText.uploadMaterialInvoice,
        visible: true,
        documentType: DocumentFileType.materialInvoice.documentType,
      )..loadDocumentTypeId(DocumentFileType.materialInvoice.documentType),
      DocumentEntity(
        documentTypeId: null,
        fileType: DocumentFileType.proofOfDelivery.name,
        title:navigatorKey.currentState?.context.appText.uploadPOD,
        visible: false,
        documentType: DocumentFileType.proofOfDelivery.documentType,
      )..loadDocumentTypeId( DocumentFileType.proofOfDelivery.documentType),

      DocumentEntity(
        documentTypeId: null,
        fileType: DocumentFileType.uploadOtherDocument.value,
        title:navigatorKey.currentState?.context.appText.othersDocument,
        visible: true,
        documentType: DocumentFileType.uploadOtherDocument.documentType,
      )..loadDocumentTypeId(DocumentFileType.uploadOtherDocument.documentType),
    ];
  }

  static void setDamageDocumentEntity(){
    damageDocumentEntity=  DocumentEntity(
      documentTypeId:null,
      fileType: DocumentFileType.damageAndShortage.name,
      title:navigatorKey.currentState?.context.appText.damageAndShortage,
      visible: true,
      documentType: DocumentFileType.damageAndShortage.documentType
    )..loadDocumentTypeId( DocumentFileType.damageAndShortage.documentType);
  }

  static void setSupportDocumentEntity(){
    supportDocumentEntity=  DocumentEntity(
      documentTypeId:null,
      fileType: DocumentFileType.supportTicket.name,
      title:navigatorKey.currentState?.context.appText.supportTicket,
      visible: true,
      documentType: DocumentFileType.supportTicket.documentType
    )..loadDocumentTypeId( DocumentFileType.supportTicket.documentType);
  }

}

Future<int> getDocumentTypeId(String name) async {
  final cubit=locator<DocumentTypeCubit>();
  int documentTypeID= await cubit.getDocumentTypeId(name);
  return documentTypeID;
}

extension on DocumentEntity {
  void loadDocumentTypeId(String? name) async {
    documentTypeId = await getDocumentTypeId(name ?? '');
  }


}







