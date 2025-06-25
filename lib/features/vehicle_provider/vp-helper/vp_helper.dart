class VpHelper{


 static String getLoadStatusButtonTitle(int loadStatus){
    switch(loadStatus){
      case 3:
        return "Assign Driver";
      default:
        return "Accept Load";
    }


  }



}

enum LoadStatus {
  accepted,
  matching,
  assigned
}