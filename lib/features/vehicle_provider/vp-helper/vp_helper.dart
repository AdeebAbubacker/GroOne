
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/download_handler.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
class VpHelper{


 static String getLoadStatusButtonTitle(int loadStatus){
   BuildContext context=navigatorKey.currentState!.context;
    switch(loadStatus){
      case 3:
        return context.appText.assignDriver;
      default:
        return context.appText.acceptLoad;
    }
 }

 /// Refresh Indicator
 static Widget withRefreshIndicator(Future<void> Function() onRefresh,{Widget? child}) {
   return RefreshIndicator(
     onRefresh: onRefresh,
     child: child??SizedBox(),
   );
 }

 /// Refresh Indicator
 static Widget withSliverRefresh(Future<void> Function() onRefresh,{Widget? child}) {
   return RefreshIndicator(
     onRefresh: onRefresh,
     child: CustomScrollView(
       slivers: [
         SliverFillRemaining(
           child:   child??SizedBox(),
         )
       ],
     ),
   );
 }

  static Color getColor(String colorString) {
   if (colorString.startsWith('#')) {
     final hex = colorString.replaceFirst('#', '');
     final fullHex = hex.length == 6 ? 'FF$hex' : hex;
     return Color(int.parse(fullHex, radix: 16));
   } else if (colorString.startsWith('rgba')) {
     final regex = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+),?\s*([.\d]*)\)');
     final match = regex.firstMatch(colorString);
     if (match != null) {
       final r = int.parse(match.group(1)!);
       final g = int.parse(match.group(2)!);
       final b = int.parse(match.group(3)!);
       final a = match.group(4)?.isNotEmpty == true
           ? (double.parse(match.group(4)!) * 255).round()
           : 255;
       return Color.fromARGB(a, r, g, b);
     }
   }

   // Fallback color (e.g. transparent or default)
   return Colors.transparent;
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
  completed
}



String getSwipeButtonTitle(LoadStatus status,PodDispatch? podDispatched,{bool? isMemoGenerated}){

  BuildContext context=navigatorKey.currentState!.context;
  switch(status){
    case LoadStatus.loading:
      return context.appText.swipeToCompleteLoading;
      case LoadStatus.inTransit:
      return context.appText.swipeToStartUnLoading;
      case LoadStatus.unloading:
      return context.appText.swipeToCompleteUnLoading;
    case LoadStatus.podDispatched:
      return  podDispatched==null ?  context.appText.podDispatchedDetails:context.appText.swipeToCompleteTrip;
    default:
      return (isMemoGenerated??false) ?  context.appText.swipeToStart:context.appText.waitingForLpToConfirmed;
  }
}

Future<void> downloadAndOpenFile(String url,{String? originalFileName}) async {
  try {
    final fileName = path.basename(url);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, originalFileName);
    final dio = Dio();
    await dio.download(url,filePath);

    print("filePath gettign :: ${filePath} and original file name ${originalFileName}");
    await OpenFilex.open(filePath);
  } catch (e) {
    debugPrint("Error downloading/opening file: $e");
  }
}

LoadStatus getLoadStatus(int? status){
  return switch(status){
    3 => LoadStatus.accepted,
    4 => LoadStatus.assigned,
    5 => LoadStatus.loading,
    6 => LoadStatus.inTransit,
    7 => LoadStatus.unloading,
    8 => LoadStatus.podDispatched,
    9 => LoadStatus.completed,
    null || int() => LoadStatus.matching
  };
}


enum DocumentFileType {

  lorryReceipt('lorry_receipt',documentType: "Lorry Receipt"),
  ewayBill('eway_bill',documentType: "Eway Bill"),
  materialInvoice('material_invoice',documentType: "Material Invoice"),
  proofOfDelivery('proof_of_delivery',documentType: "Proof of Delivery"),
  uploadOtherDocument('other_documents',documentType: "Other Documents",),
  damageAndShortage('damages_and_shortages',documentType: "Damages and Shortages"),
  aadharDocument('aadhaar_card',documentType: 'Aadhaar Card'),
  panDocument('aadhaar_card',documentType: 'PAN Card'),
  tanDocument('tan_document',documentType: 'Tan Document'),
  gstinDocument('gst_document',documentType: 'GST Document'),
  tdsDocument('tds',documentType: 'TDS'),
  chequeDocument('cancelled_cheque',documentType: 'Cancelled Cheque');




  final String value;
  final String? documentType;

  const DocumentFileType(this.value,{this.documentType});
}

String getButtonText(LoadStatus status,{bool? priceIntoRange}){
  BuildContext context=navigatorKey.currentState!.context;

  if(priceIntoRange??false){
    return context.appText.adminContact;
  }


  switch(status){
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

 bool checkPriceIntoRange( String? vpRate, String? vpMaxRate){
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





