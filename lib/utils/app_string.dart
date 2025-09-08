@override
class AppString {
  AppString._();
  static AppLabelText label = AppLabelText();
  static AppErrorText error = AppErrorText();
  static PreferenceKey sessionKey = PreferenceKey();
}

class AppLabelText {
  final String english = 'English';
  final String hindi = 'Hindi';
  final String hindi2 = 'हिन्दी';
  final String tamil2 = 'தமிழ்';
  final String tamil = 'Tamil';
}

class AppErrorText {
  final String deserializationError = 'Deserialization error';
}

class PreferenceKey {
  final String uid = "uid";
  final String userToken = "idToken";
  final String userId = "userId";
  final String accessToken = "accessToken";
  final String refreshToken = "refreshToken";
  final String firstName = "firstName";
  final String lastName = "lastName";
  final String fcmToken = "fcmToken";
  final String userAddress = "userAddress";
  final String userFullName = "userFullName";
  final String userMobileNumber = "mobileNumber";
  final String userEmail = "emailId";
  final String userRole = "userRole";
  final String companyTypeId = "companyTypeId";
  final String blueId = "blueId";
  final String isFirstTimeLoad = "isFirstTimeLoad";
  final String hasBlueIdPopupShown = "hasBlueIdPopupShown";
  final String firstPostedLoadId = "first_posted_load_id";
  final String selectedLanguage = "selected_language";
  final String iskycAdarWebview = "iskycAdarWebview";
  final String customerSeriesId = "customerSeriesId";
  final String gpsToken = "gpsToken";

  /// Aadhar KYC
  final String aadharVerified = "aadharVerified";
  final String aadharNumber = "aadharNumber";
  final String aadharPdf = "aadharPdf";

  final String gtsinNumber = "gtsin";
  final String panNumber = "panNumber";
  final String tanNumber = "tanNumber";

  final String isGstNumberVerified = "isGstNumberVerified";
  final String isPanNumberVerified = "isPanNumberVerified";
  final String isTanNumberVerified = "isTanNumberVerified";

  final String panDocUrl = "panDocUrl";
  final String tanDocUrl = "tanDocUrl";
  final String gstDocUrl = "gstDocUrl";

  final String panDocId = "panDocId";
  final String tanDocID = "tanDocID";
  final String gstDocID = "gstDocID";
}
