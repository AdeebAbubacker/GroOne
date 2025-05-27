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
  final String dateAndTime = "${_svgBasePath}svg.svg";
  final String kgWeight = "${_svgBasePath}kg_weight.svg";
  final String truck = "${_svgBasePath}truck.svg";
  final String markerLocation = "${_svgBasePath}marker_location.svg";
  final String myLocation = "${_svgBasePath}my_location.svg";


}

