import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/service/analytics/analytics_event_name.dart';
import 'package:gro_one_app/service/analytics/analytics_service.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VpHelper {
  static final AnalyticsService analyticsHelper = locator<AnalyticsService>();

  static String getLoadStatusButtonTitle(int loadStatus) {
    BuildContext context = navigatorKey.currentState!.context;
    switch (loadStatus) {
      case 3:
        return context.appText.assignDriver;
      default:
        return context.appText.acceptLoad;
    }
  }

  /// Refresh Indicator
  static Widget withRefreshIndicator(
    Future<void> Function() onRefresh, {
    Widget? child,
  }) {
    return RefreshIndicator(onRefresh: onRefresh, child: child ?? SizedBox());
  }

  /// Refresh Indicator
  static Widget withSliverRefresh(
    Future<void> Function() onRefresh, {
    Widget? child,
  }) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: [SliverFillRemaining(child: child ?? SizedBox())],
      ),
    );
  }

  static Color getColor(String colorString) {
    if (colorString.startsWith('#')) {
      final hex = colorString.replaceFirst('#', '');
      final fullHex = hex.length == 6 ? 'FF$hex' : hex;
      return Color(int.parse(fullHex, radix: 16));
    } else if (colorString.startsWith('rgb')) {
      final regex = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+),?\s*([.\d]*)\)');
      final match = regex.firstMatch(colorString);
      if (match != null) {
        final r = int.parse(match.group(1)!);
        final g = int.parse(match.group(2)!);
        final b = int.parse(match.group(3)!);
        final a =
            match.group(4)?.isNotEmpty == true
                ? (double.parse(match.group(4)!) * 255).round()
                : 255;
        return Color.fromARGB(a, r, g, b);
      }
    }

    // Fallback color (e.g. transparent or default)
    return Colors.transparent;
  }


  // Upload Event for document upload
 static void logDocumentUploadedEvent(String fileType){
    if (fileType==DocumentFileType.lorryReceipt.name) {
      analyticsHelper.logEvent(AnalyticEventName.LORRY_RECEIPT_UPLOADED);
    } else if (fileType==DocumentFileType.ewayBill.name) {
      analyticsHelper.logEvent(AnalyticEventName.E_WAY_BILLED_UPLOADED);
    } else if (fileType==DocumentFileType.materialInvoice.name) {
      analyticsHelper.logEvent(AnalyticEventName.MATERIAL_INVOICE_UPLOADED);
    } else if(fileType==DocumentFileType.uploadOtherDocument.name){
      analyticsHelper.logEvent(AnalyticEventName.OTHERS_DOCUMENT_UPLOADED);
    } else if(fileType==DocumentFileType.proofOfDelivery.name){
      analyticsHelper.logEvent(AnalyticEventName.POD_DOCUMENT_UPLOADED);
    }
  }


}

enum LoadStatus {
  matching,
  accepted,
  assigned,
  loading,
  inTransit,
  unloading,
  podDispatched,
  completed,
}

String getSwipeButtonTitle(
  LoadStatus status,
  PodDispatch? podDispatched, {
  bool? isMemoGenerated,
  required bool isPodSkip,
}) {
  BuildContext context = navigatorKey.currentState!.context;
  switch (status) {
    case LoadStatus.loading:
      return context.appText.swipeToCompleteLoading;
    case LoadStatus.inTransit:
      return context.appText.swipeToStartUnLoading;
    case LoadStatus.unloading:
      return context.appText.swipeToCompleteUnLoading;
    case LoadStatus.podDispatched:
      return podDispatched == null && isPodSkip == false
          ? context.appText.podDispatchedDetails
          : context.appText.swipeToCompleteTrip;
    default:
      return (isMemoGenerated ?? false)
          ? context.appText.swipeToStart
          : context.appText.waitingForLpToConfirmed;
  }
}

Future<void> downloadAndOpenFile(String url, {String? originalFileName}) async {


  try {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getTemporaryDirectory();
    String fileName;
    if (originalFileName != null && originalFileName.isNotEmpty) {
      fileName = originalFileName; 
    } else {
      final uri = Uri.parse(url);
      final lastSegment = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "downloaded_file.pdf";




      fileName = lastSegment.contains(".") ? lastSegment : "$lastSegment.pdf";
    }

    final filePath = path.join(directory!.path, fileName);

    final dio = Dio();
    await dio.download(url, filePath);


    if(filePath.split(".").last=="pdf"){
      final result = await OpenFilex.open(filePath, type: "application/pdf",);
    }else{
      final result = await OpenFilex.open(filePath);
    }



  } catch (e) {
    debugPrint("Error downloading/opening file: $e");
  }
}



LoadStatus getLoadStatus(int? status) {
  return switch (status) {
    3 => LoadStatus.accepted,
    4 => LoadStatus.assigned,
    5 => LoadStatus.loading,
    6 => LoadStatus.inTransit,
    7 => LoadStatus.unloading,
    8 => LoadStatus.podDispatched,
    9 => LoadStatus.completed,
    null || int() => LoadStatus.matching,
  };
}

LoadStatus? getVPLoadStatusFromString(String? loadType) {

  switch (loadType) {
    case 'Matching':
      return LoadStatus.matching;
    case 'Confirmed':
      return LoadStatus.accepted;
    case 'Assigned':
      return LoadStatus.assigned;
    case 'Loading':
      return LoadStatus.loading;
    case 'In Transit':
      return LoadStatus.inTransit;
    case 'Unloading':
      return LoadStatus.unloading;

    case 'POD Dispatch':
      return LoadStatus.podDispatched;
    case 'Completed':
      return LoadStatus.completed;
    default:
      return null;
  }
}

enum DocumentFileType {
  lorryReceipt('lorry_receipt', documentType: "Lorry Receipt"),
  ewayBill('eway_bill', documentType: "Eway Bill"),
  materialInvoice('material_invoice', documentType: "Material Invoice"),
  proofOfDelivery('proof_of_delivery', documentType: "Upload POD"),
  uploadOtherDocument('upload_other_document', documentType: "Upload Other Documents"),
  damageAndShortage('damages_and_shortages', documentType: "Damages and Shortages",),
  aadharDocument('aadhaar_card', documentType: 'Aadhaar Card'),
  panDocument('pan_card', documentType: 'PAN Card'),
  tanDocument('tan_document', documentType: 'Tan Document'),
  gstinDocument('gst_document', documentType: 'GST Document'),
  tdsDocument('tds', documentType: 'TDS'),
  chequeDocument('cancelled_cheque', documentType: 'Cancelled Cheque'),
  licenseDocument('driving_licence', documentType: 'Driving Licence'),
  supportTicket('ticket_document', documentType: 'Ticket Document');

  final String value;
  final String? documentType;

  const DocumentFileType(this.value, {this.documentType});
}

String getButtonText(LoadStatus status, {bool? priceIntoRange}) {
  BuildContext context = navigatorKey.currentState!.context;

  if (priceIntoRange ?? false) {
    return context.appText.adminContact;
  }

  switch (status) {
    case LoadStatus.completed:
      return context.appText.viewTripStatement;
    case LoadStatus.accepted:
      return context.appText.assignDriver;
    case LoadStatus.podDispatched:
      return context.appText.podDispatchedDetails;
    default:
      return context.appText.acceptLoad;
  }
}

bool checkPriceIntoRange(String? vpRate, String? vpMaxRate) {
  final vpLoadPrice =
      (vpMaxRate == null || vpMaxRate.isEmpty || vpMaxRate == "0")
          ? PriceHelper.formatINR(vpRate)
          : '${PriceHelper.formatINR(vpRate)} - ${PriceHelper.formatINR(vpMaxRate)}';

  return vpLoadPrice.contains("-");
}

String formatVehicleNumber(String number) {
  final parts = number.trim().split(RegExp(r"\s+"));

  if (parts.length == 4) {
    return parts.join(" ");
  }
  final cleaned = number.replaceAll(RegExp(r"\s+"), "");
  if (cleaned.length >= 10) {
    return "${cleaned.substring(0, 2)} "
        "${cleaned.substring(2, 4)} "
        "${cleaned.substring(4, 6)} "
        "${cleaned.substring(6)}";
  }

  return number; // fallback
}

double calculateGstAmount(double amountWithoutGst, double amountWithGst) {
  return amountWithGst - amountWithoutGst;
}










