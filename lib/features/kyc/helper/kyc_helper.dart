import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';
import 'package:gro_one_app/features/kyc/model/kyc_document_meta_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:path_provider/path_provider.dart';

class KycHelper {
  // Get Mine Type
  static String getMimeTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
        return 'image/jpg';
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      default:
        return ""; // or throw an exception if needed
    }
  }

  // Get Document Type Id
  static Future<int?> getDocumentTypeId(
    KycDocType type,
    DocumentTypeCubit documentTypeCubit,
  ) async {
    switch (type) {
      case KycDocType.pan:
        return await documentTypeCubit.getDocumentTypeId(
          DocumentFileType.panDocument.documentType ?? "",
        ); // "PAN Card"
      case KycDocType.tan:
        return await documentTypeCubit.getDocumentTypeId(
          DocumentFileType.tanDocument.documentType ?? "",
        ); // "Tan Document"
      case KycDocType.gstin:
        return await documentTypeCubit.getDocumentTypeId(
          DocumentFileType.gstinDocument.documentType ?? "",
        ); // "GST Document"
      case KycDocType.tds:
        return await documentTypeCubit.getDocumentTypeId(
          DocumentFileType.tdsDocument.documentType ?? "",
        ); // "TDS"
      case KycDocType.cheque:
        return await documentTypeCubit.getDocumentTypeId(
          DocumentFileType.chequeDocument.documentType ?? "",
        );
      case KycDocType.aadharCard:
        return await documentTypeCubit.getDocumentTypeId(
          DocumentFileType.aadharDocument.documentType ?? "",
        ); // "Cancelled Cheque"
    }
  }

  // Get Meta
  static KycDocumentMeta getMeta(KycDocType type) {
    switch (type) {
      case KycDocType.pan:
        return const KycDocumentMeta(
          title: "PAN Card",
          description: "Permanent Account Number document",
        );
      case KycDocType.tan:
        return const KycDocumentMeta(
          title: "TAN Document",
          description: "Tax Deduction and Collection Account Number document",
        );
      case KycDocType.gstin:
        return const KycDocumentMeta(
          title: "GST Document",
          description: "Goods and Services Tax document",
        );
      case KycDocType.tds:
        return const KycDocumentMeta(
          title: "TDS",
          description: "Tax Deducted at Source certificate",
        );
      case KycDocType.cheque:
        return const KycDocumentMeta(
          title: "Cancelled Cheque",
          description: "Bank account verification via cancelled cheque",
        );
      case KycDocType.aadharCard:
        return const KycDocumentMeta(
          title: "Aadhaar Card",
          description: "Aadhaar Card",
        );
    }
  }

  static Future<String> saveBase64PdfToFile(String base64Pdf) async {
    Uint8List pdfBytes = base64.decode(base64Pdf);
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/converted_file.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    return filePath;
  }

  // Get Document File Type Id
  static Future<String?> getDocumentFileType(
    KycDocType type,
    DocumentTypeCubit documentTypeCubit,
  ) async {
    switch (type) {
      case KycDocType.pan:
        return await documentTypeCubit.getDocumentFileType(
          DocumentFileType.panDocument.value ?? "",
        ); // "PAN Card"
      case KycDocType.tan:
        return await documentTypeCubit.getDocumentFileType(
          DocumentFileType.tanDocument.value ?? "",
        ); // "Tan Document"
      case KycDocType.gstin:
        return await documentTypeCubit.getDocumentFileType(
          DocumentFileType.gstinDocument.value ?? "",
        ); // "GST Document"
      case KycDocType.tds:
        return await documentTypeCubit.getDocumentFileType(
          DocumentFileType.tdsDocument.value ?? "",
        ); // "TDS"
      case KycDocType.cheque:
        return await documentTypeCubit.getDocumentFileType(
          DocumentFileType.chequeDocument.value ?? "",
        );
      case KycDocType.aadharCard:
        return await documentTypeCubit.getDocumentFileType(
          DocumentFileType.aadharDocument.value ?? "",
        ); // "Cancelled Cheque"
    }
  }
}
