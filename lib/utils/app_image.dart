@override
abstract class AppImage {
  AppImage._();

  static PngImages png = PngImages();
  static SvgImages svg = SvgImages();
  static JpgImage jpg = JpgImage();
}

class PngImages {
  ///Prabhat======================+>
  final String appIcon = "assets/appIcon.png";
  final String englishLanguage = "assets/englishLanguage.png";
  final String tamilLanguage = "assets/tamilLanguage.png";
  final String hindiLanguage = "assets/hindiLanguage.png";
  final String lp = "assets/lp.png";
  final String vp = "assets/vp.png";
  final String lpVp = "assets/lpVp.png";
  final String fleet = "assets/fleet.png";
  final String hinduja = "assets/hinduja.png";
  final String flag = "assets/flag.png";
  final String signUpBanner = "assets/signUpBanner.png";
  final String successGif = "assets/success.gif";
  final String loadImage = "assets/load_image.png";
  final String buyFastTag = "assets/buyFastTag.png";
  final String enDhan = "assets/enDhan.png";
  final String gps = "assets/gps.png";
  final String insuranceLoan = "assets/insuranceLoan.png";
  final String insurance = "assets/insurance.png";
  final String bookAShipment = "assets/book_a_shipment.png";
  final String locationIcon = "assets/location_icon.png";
  final String kavach = "assets/kavach.png";

  ///Prabhat======================+>

  static const String _pngImageBasePath = "assets/images/png/";
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
