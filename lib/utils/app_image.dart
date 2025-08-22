@override
abstract class AppImage {
  AppImage._();

  static PngImages png = PngImages();
  static SvgImages svg = SvgImages();
  static JpgImage jpg = JpgImage();

}

class PngImages {

  static const String _pngImageBasePath = "assets/images/png/";

  // Base
  final String appLogoPng = "${_pngImageBasePath}appLogo.png";
  final String signInHeader = "${_pngImageBasePath}signInHeader.png";
  final String userProfileError = "${_pngImageBasePath}userPlaceHolder.png";
  final String backgroundImagePng = "${_pngImageBasePath}backgroundImage.png";
  final String femalePlaceHolder = "${_pngImageBasePath}femalePlaceHolder.png";
  final String malePlaceholder = "${_pngImageBasePath}malePlaceHolder.png";
  final String brokenImage = "${_pngImageBasePath}brokenImage.png";
  final String appIcon = "${_pngImageBasePath}appIcon.png";

  final String translateImage = "${_pngImageBasePath}translateImage.png";
  final String customerSupportImage = "${_pngImageBasePath}customerSupportImage.png";
  final String customerSupport = "${_pngImageBasePath}customerSupport.png";
  final String blueMembership = "${_pngImageBasePath}blueMembership.jpeg";
  final String cards = "${_pngImageBasePath}cards.png";
  final String upi = "${_pngImageBasePath}upi.png";
  final String netBanking = "${_pngImageBasePath}netBanking.png";
  final String bankImage = "${_pngImageBasePath}bankImage.png";
  final String document = "${_pngImageBasePath}document.png";
  final String doc = "${_pngImageBasePath}doc.png";
  final String truck = "${_pngImageBasePath}truck.png";
  final String newTruck = "${_pngImageBasePath}new_truck.png";
  final String privacy = "${_pngImageBasePath}privacy.png";
  final String shipmentBox = "${_pngImageBasePath}shipmentBox.png";
  final String markAsFavourite = "${_pngImageBasePath}markAsFavourite.png";
  final String pendingTransaction = "${_pngImageBasePath}pendingTransaction.png";
  final String completedTransaction = "${_pngImageBasePath}completedTransaction.png";
  final String noShipment = "${_pngImageBasePath}noShipmentFound.png";
  final String alertTriangle = "${_pngImageBasePath}alertTriangle.png";
  final String englishLanguage = "${_pngImageBasePath}englishLanguage.png";
  final String filter = "${_pngImageBasePath}filter.png";
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
  final String truckMyLoad = "${_pngImageBasePath}truck_my_loads.png";


  // App
  final String kavachProduct = "${_pngImageBasePath}kavach_product.png";
  final String kavachNewProduct1 = "${_pngImageBasePath}kavach_new_product_image.png";
  final String kavachNewProduct = "${_pngImageBasePath}kavach_new_product.png";
  final String kavachModel = "${_pngImageBasePath}kavach_model.png";
  final String groBanner = "${_pngImageBasePath}gro_banner.png";
  

  /// assign driver vp
  final String dummyTruckLoad = "${_pngImageBasePath}dummy_truck_load.png";


  //en-dhan
  final String endhanCard = "${_pngImageBasePath}endhan_card.png";

  // gps Order
  final String gpsBenefitTruck = "${_pngImageBasePath}benefitsOfGps.png";
  final String gpsNewProduct = "${_pngImageBasePath}gps_product_image.png";

  //fastag images
  final String fastagNewUser = "${_pngImageBasePath}fasttag-no-user.png";
  final String fastagBenefitsBanner = "${_pngImageBasePath}fastag_benefit_banner.png";
}

class SvgImages {
  static const String _svgImageBasePath = "assets/images/svg/";
  final String appLogo = "${_svgImageBasePath}appLogo.svg";


  final String kycPending = "${_svgImageBasePath}kyc_pending.svg";
  final String kycSuccess = "${_svgImageBasePath}kyc_success.svg";
  final String kycSuccessStatus = "${_svgImageBasePath}kyc_success_status.svg";
  final String kycInProgressStatus = "${_svgImageBasePath}kyc_verification_in_progress_status.svg";
  final String noSearchFound = "${_svgImageBasePath}not_found.svg";
  final String groBanner = "${_svgImageBasePath}gro_banner.svg";
  final String master = "${_svgImageBasePath}master.svg";
  final String routes = "${_svgImageBasePath}routes.svg";
  final String myDocuments = "${_svgImageBasePath}my_documents.svg";
  final String myDocumentsIcon2 = "${_svgImageBasePath}my_doc_icon.svg";
  final String settings = "${_svgImageBasePath}settings.svg";
  final String support = "${_svgImageBasePath}support.svg";
  final String transaction = "${_svgImageBasePath}transaction.svg";
  final String user = "${_svgImageBasePath}user.svg";
  final String logOut = "${_svgImageBasePath}logOut.svg";
  final String location = "${_svgImageBasePath}location.svg";
  final String logOutImage = "${_svgImageBasePath}log_out.svg";
  final String customerSupport = "${_svgImageBasePath}customer_support.svg";
  final String hindujaLogo = "${_svgImageBasePath}hinduja logo.svg";


  final String blueTick = "${_svgImageBasePath}blue_tick.svg";
  final String switchLp = "${_svgImageBasePath}switch_lp.svg";
  final String switchVp= "${_svgImageBasePath}switch_vp.svg";
}

class JpgImage {
  static const String _jpgImageBasePath = "assets/images/jpg/";
  final String noticeBoardBgImage = "${_jpgImageBasePath}noticeBoardBgImage.jpg";
  final String driverImaged = "${_jpgImageBasePath}driver_vehicle.jpg";
}
