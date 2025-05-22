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

}

