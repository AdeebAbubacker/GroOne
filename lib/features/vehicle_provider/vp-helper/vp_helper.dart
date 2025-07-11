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
      return "Swipe to complete unloading";
      case LoadStatus.unloading:
      return "Swipe to complete Trip";
    default:
      return "Swipe to Start Trip";
  }
}