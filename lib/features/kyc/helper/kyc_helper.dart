import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';
import 'package:gro_one_app/features/kyc/model/kyc_document_meta_model.dart';
import 'package:image/image.dart' as imgLib;
import 'package:path_provider/path_provider.dart';


class KycHelper {

 static KycStage kycStage(int? isKyc) {
    switch (isKyc) {
      case 3:  return KycStage.done;
      case 2:  return KycStage.inProgress;
      case 0:  return KycStage.none;
      default: return KycStage.unknown;
    }
 }

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
 static int? getDocumentTypeId(KycDocType type) {
   switch (type) {
     case KycDocType.pan:
       return 2;       // "PAN Card"
     case KycDocType.tan:
       return 223;     // "Tan Document"
     case KycDocType.gstin:
       return 109;     // "GST Document"
     case KycDocType.tds:
       return 112;     // "TDS"
     case KycDocType.cheque:
       return 106;     // "Cancelled Cheque"
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
   }
 }

 static Future<String> saveBase64PdfToFile(String base64Pdf) async {

   Uint8List pdfBytes = base64.decode(base64Pdf);


   final dir = await getTemporaryDirectory();
   final filePath = '${dir.path}/converted_file.pdf';

   // Step 3: Write PDF file
   final file = File(filePath);
   await file.writeAsBytes(pdfBytes);

   return filePath;
 }










}