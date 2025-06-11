@override
class AppIcons {
  AppIcons._();
  static PngIcons png = PngIcons();
  static SvgIcons svg = SvgIcons();
  static GifIcons gif = GifIcons();
}

/// PNG Icons
class PngIcons {
  // Base Icon
  static const String _pngBasePath = "assets/icons/png/";
  final String brokenImage = "${_pngBasePath}imageBreak.png";
  final String appIcon = "${_pngBasePath}appIcon.png";

  // App Icons
  final String insightGraph = "${_pngBasePath}insight_graph.png";
  final String lockAndKey = "${_pngBasePath}lock_and_key.png";

  //kavach payment icons
  final String kavachPaymentCard = "${_pngBasePath}payment_card.png";
  final String kavachPaymentUpi = "${_pngBasePath}payment_upi.png";
  final String kavachPaymentNetBanking = "${_pngBasePath}payment_netbanking.png";

}

/// GIF Icons
class GifIcons {
  static const String _gifBasePath = "assets/icons/gif/";
  final String appIcon = "${_gifBasePath}lntAnimateLogo.gif";
}

/// SVG Icons
class SvgIcons {
  // Base Icon
  static const String _svgBasePath = "assets/icons/svg/";
  final String search = "${_svgBasePath}search.svg";
  final String goBack = "${_svgBasePath}goBack.svg";
  final String galleryAdd = "${_svgBasePath}galleryAdd.svg";
  final String camera = "${_svgBasePath}camera.svg";
  final String gallery = "${_svgBasePath}gallery.svg";
  final String clearOutline = "${_svgBasePath}clearOutline.svg";
  final String documentUpload = "${_svgBasePath}documentUpload.svg";

  // App Icons
  final String support = "${_svgBasePath}support.svg";
  final String orderBox = "${_svgBasePath}order_box.svg";
  final String deliveryTruckSpeed = "${_svgBasePath}delivery_truck_speed.svg";
  final String package = "${_svgBasePath}package.svg";
  final String filter = "${_svgBasePath}filterOutline.svg";
  final String edit = "${_svgBasePath}edit_outline.svg";
  final String delete = "${_svgBasePath}trash.svg";
  final String infOutline = "${_svgBasePath}infoCircleOutline.svg";
  final String commodity = "${_svgBasePath}commodity.svg";
  final String dateAndTime = "${_svgBasePath}date_and_time.svg";
  final String kgWeight = "${_svgBasePath}kg_weight.svg";
  final String weight = "${_svgBasePath}weight_icon.svg";
  final String truck = "${_svgBasePath}truck.svg";
  final String markerLocation = "${_svgBasePath}marker_location.svg";
  final String myLocation = "${_svgBasePath}my_location.svg";
  final String calendar = "${_svgBasePath}calendar_outline.svg";
  final String call = "${_svgBasePath}call.svg";
  final String tick = "${_svgBasePath}tick.svg";
  final String agriculture = "${_svgBasePath}agriculture.svg";
  final String barrel = "${_svgBasePath}barrel.svg";
  final String bottles = "${_svgBasePath}bottles.svg";
  final String log = "${_svgBasePath}log.svg";
  final String parcel = "${_svgBasePath}parcel.svg";
  final String moreMenu = "${_svgBasePath}more_menu.svg";
  final String openTruck = "${_svgBasePath}open_truck.svg";
  final String trailer = "${_svgBasePath}trailer.svg";
  final String truck20Feet = "${_svgBasePath}truck_20_feet.svg";
  final String truck22Feet = "${_svgBasePath}truck_22_feet.svg";
  final String truck24Feet = "${_svgBasePath}truck_24_feet.svg";
  final String truck32Feet = "${_svgBasePath}truck_32_feet.svg";
  final String notification = "${_svgBasePath}notification_icon.svg";


}

