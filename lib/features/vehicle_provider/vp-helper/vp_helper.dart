
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
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



String getSwipeButtonTitle(LoadStatus status){
  BuildContext context=navigatorKey.currentState!.context;
  switch(status){
    case LoadStatus.loading:
      return context.appText.swipeToCompleteLoading;
      case LoadStatus.inTransit:
      return context.appText.swipeToStartUnLoading;
      case LoadStatus.unloading:
      return context.appText.swipeToCompleteUnLoading;
    case LoadStatus.podDispatched:
      return context.appText.podDispatchedDetails;
    default:
      return context.appText.swipeToStart;
  }
}

Future<void> downloadAndOpenFile(String url,{String? originalFileName}) async {
  try {
    final fileName = path.basename(url);
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, originalFileName);

    final dio = Dio();
    await dio.download(url, filePath);

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

  lorryReceipt('lorry_receipt'),
  ewayBill('eway_bill'),
  materialInvoice('material_invoice'),
  proofOfDelivery('proof_of_delivery'),
  uploadOtherDocument('upload_other_document'),
  damageAndShortage('damages_and_shortages');


  final String value;

  const DocumentFileType(this.value);
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





