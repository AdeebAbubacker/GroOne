@override
abstract class AppImage {
  AppImage._();

  static PngImages png = PngImages();
  static SvgImages svg = SvgImages();
  static JpgImage jpg = JpgImage();
}

class PngImages {

  static const String _pngImageBasePath = "assets/images/png/";
  ///Prabhat======================+>
  final String appIcon = "${_pngImageBasePath}appIcon.png";
  final String englishLanguage = "${_pngImageBasePath}englishLanguage.png";
  final String tamilLanguage = "${_pngImageBasePath}tamilLanguage.png";
  final String hindiLanguage = "${_pngImageBasePath}hindiLanguage.png";
  final String lp = "${_pngImageBasePath}lp.png";
  final String vp = "${_pngImageBasePath}vp.png";
  final String lpVp = "${_pngImageBasePath}lpVp.png";
  final String fleet = "${_pngImageBasePath}fleet.png";
  final String hinduja = "${_pngImageBasePath}hinduja.png";
  final String flag = "${_pngImageBasePath}flag.png";
  final String signUpBanner = "${_pngImageBasePath}signUpBanner.png";
  final String successGif = "${_pngImageBasePath}success.gif";
  final String loadImage = "${_pngImageBasePath}load_image.png";
  final String buyFastTag = "${_pngImageBasePath}buyFastTag.png";
  final String enDhan = "${_pngImageBasePath}enDhan.png";
  final String gps = "${_pngImageBasePath}gps.png";
  final String insuranceLoan = "${_pngImageBasePath}insuranceLoan.png";
  final String insurance = "${_pngImageBasePath}insurance.png";
  final String bookAShipment = "${_pngImageBasePath}book_a_shipment.png";
  final String locationIcon = "${_pngImageBasePath}location_icon.png";
  final String kavach = "${_pngImageBasePath}kavach.png";
  final String splash = "${_pngImageBasePath}splash_video.mp4";

  ///Prabhat======================+>

  final String appLogoPng = "${_pngImageBasePath}appLogo.png";
  final String signInHeader = "${_pngImageBasePath}signInHeader.png";
  final String userProfileError = "${_pngImageBasePath}userPlaceHolder.png";
  final String backgroundImagePng = "${_pngImageBasePath}backgroundImage.png";
  final String femalePlaceHolder = "${_pngImageBasePath}femalePlaceHolder.png";
  final String malePlaceholder = "${_pngImageBasePath}malePlaceHolder.png";
  final String brokenImage = "${_pngImageBasePath}brokenImage.png";
}

class SvgImages {
  static const String _svgImageBasePath = "assets/images/svg/";
  final String appLogo = "${_svgImageBasePath}appLogo.svg";
  final String noSearchFound = "${_svgImageBasePath}searchNotFound.svg";
  final String intro1 = "${_svgImageBasePath}intro1.svg";
}

class JpgImage {
  static const String _jpgImageBasePath = "assets/images/jpg/";
  final String noticeBoardBgImage =
      "${_jpgImageBasePath}noticeBoardBgImage.jpg";
}
