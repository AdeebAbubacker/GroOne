
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

String getButtonText(LoadStatus status){
  BuildContext context=navigatorKey.currentState!.context;
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





