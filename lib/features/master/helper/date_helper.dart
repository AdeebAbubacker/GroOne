import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gro_one_app/features/document/cubit/document_type_cubit.dart';
import 'package:gro_one_app/features/kyc/enum/kyc_document_type.dart';
import 'package:gro_one_app/features/kyc/model/kyc_document_meta_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:image/image.dart' as imgLib;
import 'package:path_provider/path_provider.dart';


class DateHelper {
  static String? parseDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;

    DateTime? parsedDate;

    // Remove dots and trim spaces
    rawDate = rawDate.replaceAll('.', '').trim();
    String normalizedDate = rawDate.replaceAllMapped(
        RegExp(r'^(\d{1,2})-(\w{3})-(\d{2,4})$'), (match) {
      return '${match[1]} ${match[2]} ${match[3]}';
    });
    normalizedDate = normalizedDate.replaceAllMapped(
      RegExp(r'\b[a-zA-Z]{3}\b'),
      (match) =>
          '${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}',
    );

    // List of possible formats
    List<String> formats = [
      'dd-MM-yyyy',
      'dd/MM/yyyy',
      'dd MMM yyyy', 
      'dd-MMM-yy',
      'yyyy-MM-dd',
      'yyyy-MM-ddTHH:mm:ss.SSSZ',
      'yyyy-MM-ddTHH:mm:ssZ',
      'yyyy-MM-ddTHH:mm:ss',
    ];

    for (var format in formats) {
      try {
        parsedDate = DateFormat(format, 'en_US').parseStrict(normalizedDate);
        break;
      } catch (_) {}
    }
    parsedDate ??= DateTime.tryParse(normalizedDate);

    if (parsedDate != null) {
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    }

    return null; 
  }
}





class MasterDriverDropDownHelper {
  static T? mapByIdOrName<T>(
    List<T> list,
    dynamic idOrName, {
    required int? Function(T) getId,
    required String? Function(T) getName,
  }) {
    if (list.isEmpty || idOrName == null) return null;

    return list.firstWhereOrNull(
      (item) =>
          (idOrName is int && getId(item) == idOrName) ||
          (idOrName is String && getName(item) == idOrName),
    );
  }

  static Map<String, dynamic>? mapBloodGroup(
    List<BloodGroupResponseModel> list,
    dynamic idOrName,
  ) {
    final matched = mapByIdOrName<BloodGroupResponseModel>(
      list,
      idOrName,
      getId: (t) => t.id,
      getName: (t) => t.groupName,
    );

    if (matched != null) {
      return {
        'id': matched.id,
        'name': matched.groupName,
      };
    }
    return null;
  }

  static Map<String, dynamic>? mapLicenseCategory(
    List<LicenseCategoryResponseModel> list,
    dynamic idOrName,
  ) {
    final matched = mapByIdOrName<LicenseCategoryResponseModel>(
      list,
      idOrName,
      getId: (t) => t.id,
      getName: (t) => t.categoryName,
    );

    if (matched != null) {
      return {
        'id': matched.id,
        'name': matched.categoryName,
      };
    }
    return null;
  }
}





String convertToYMD(String dateStr) {
  dateStr = dateStr.trim();

  final formats = [
    'dd/MM/yyyy',
    'dd-MM-yyyy',
    'MM/dd/yyyy',
    'MM-dd-yyyy',
    'yyyy/MM/dd',
    'yyyy-MM-dd',
    'dd MMM yyyy',
    'MMM dd, yyyy',
  ];

  for (var format in formats) {
    try {
      final parsedDate = DateFormat(format).parseStrict(dateStr);
      // Format as year-month-day with hyphens
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (_) {}
  }

  // Fallback to ISO parse
  try {
    final parsedDate = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  } catch (_) {}

  return 'Invalid date';
}





class DriverLicenseHelper {


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
 static Future<int?>  getDocumentTypeId(DriverDocType type,DocumentTypeCubit documentTypeCubit) async {
   switch (type) {
     case DriverDocType.licenseDoc:
       return await documentTypeCubit.getDocumentTypeId(DocumentFileType.licenseDocument.documentType??"");
   }
 }


 // Get Meta
 static KycDocumentMeta getMeta(DriverDocType type) {
   switch (type) {
     case DriverDocType.licenseDoc:
       return const KycDocumentMeta(
         title: "Driving License",
         description: "Driving License",
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










}

enum DriverDocType {licenseDoc,}

// KYC flags that matter to UI
enum KycStage { none, inProgress, done, unknown }