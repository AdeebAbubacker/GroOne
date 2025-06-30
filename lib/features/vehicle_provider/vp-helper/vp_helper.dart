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
   switch(loadStatus){
     case LoadStatus.assigned:
       return "Assigned";
     default:
       return "confirmed";
   }
 }
}



enum LoadStatus {
  accepted,
  matching,
  assigned
}