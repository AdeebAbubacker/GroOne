
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
class VpHelper{


 static String getLoadStatusButtonTitle(int loadStatus){
    switch(loadStatus){
      case 3:
        return "Assign Driver";
      default:
        return "Accept Load";
    }


  }

 static String getLoadStatus(LoadStatus loadStatus){
   print("loadStatus is on label ${loadStatus}");
   return switch(loadStatus){
     LoadStatus.matching => "",
     LoadStatus.accepted => "Confirmed",
     // TODO: Handle this case.
     LoadStatus.assigned => "Assigned",
     // TODO: Handle this case.
     LoadStatus.loading => "Loading",
     // TODO: Handle this case.
     LoadStatus.unloading => "Unloading",
     // TODO: Handle this case.
     LoadStatus.inTransit => "In Transit",
     // TODO: Handle this case.
     LoadStatus.completed => "Completed",
   };

 }
}



enum LoadStatus {
  matching,
  accepted,
  assigned,
  loading,
  unloading,
  inTransit,
  completed


}

String getBottomButtonTitle(LoadStatus status){
  switch(status){
    case LoadStatus.loading:
      return "Swipe to complete Loading";
      case LoadStatus.inTransit:
      return "Swipe To start unloading";
      case LoadStatus.unloading:
      return "Swipe to complete Unloading";
    default:
      return "Swipe to Start Trip";
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

