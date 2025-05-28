import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Gro One'**
  String get appName;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'You can also change the language later on'**
  String get chooseLanguage;

  /// No description provided for @choosePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Preferred'**
  String get choosePreferredLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseRoleText.
  ///
  /// In en, this message translates to:
  /// **'What do you use this app for?'**
  String get chooseRoleText;

  /// No description provided for @lpTextHeading.
  ///
  /// In en, this message translates to:
  /// **'I am a Load Provider'**
  String get lpTextHeading;

  /// No description provided for @lpText.
  ///
  /// In en, this message translates to:
  /// **'I have commodities to be transported'**
  String get lpText;

  /// No description provided for @vpTextHeading.
  ///
  /// In en, this message translates to:
  /// **'I am a Truck Provider'**
  String get vpTextHeading;

  /// No description provided for @vpText.
  ///
  /// In en, this message translates to:
  /// **'I can provide trucks for loads'**
  String get vpText;

  /// No description provided for @vpLpHeading.
  ///
  /// In en, this message translates to:
  /// **'Both Load & Truck Provider'**
  String get vpLpHeading;

  /// No description provided for @vpLp.
  ///
  /// In en, this message translates to:
  /// **'I have trucks and commodities'**
  String get vpLp;

  /// No description provided for @fleetHeading.
  ///
  /// In en, this message translates to:
  /// **'Require Fleet Products'**
  String get fleetHeading;

  /// No description provided for @fleet.
  ///
  /// In en, this message translates to:
  /// **'I want value added services for my fleet'**
  String get fleet;

  /// No description provided for @getOtp.
  ///
  /// In en, this message translates to:
  /// **'Get OTP'**
  String get getOtp;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number to continue.'**
  String get enterMobileNumber;

  /// No description provided for @loginSingUp.
  ///
  /// In en, this message translates to:
  /// **'Login / Sign up'**
  String get loginSingUp;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'By Logging in, you agree to GRO’s '**
  String get agree;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'terms & conditions'**
  String get termsAndConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @iAgree.
  ///
  /// In en, this message translates to:
  /// **'I Agree'**
  String get iAgree;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterOtpSendNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to '**
  String get enterOtpSendNumber;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend;

  /// No description provided for @bookShipment.
  ///
  /// In en, this message translates to:
  /// **'Book Shipment'**
  String get bookShipment;

  /// No description provided for @ourValueAddedServices.
  ///
  /// In en, this message translates to:
  /// **'Our Value Added Services'**
  String get ourValueAddedServices;

  /// No description provided for @buyFastTag.
  ///
  /// In en, this message translates to:
  /// **'Buy FASTag'**
  String get buyFastTag;

  /// No description provided for @enDan.
  ///
  /// In en, this message translates to:
  /// **'En-Dhan Card'**
  String get enDan;

  /// No description provided for @gps.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get gps;

  /// No description provided for @instantLoan.
  ///
  /// In en, this message translates to:
  /// **'Instant Loan'**
  String get instantLoan;

  /// No description provided for @kavach.
  ///
  /// In en, this message translates to:
  /// **'KAVACH'**
  String get kavach;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'LOGIN SUCCESSFUL'**
  String get loginSuccessful;

  /// No description provided for @loginSuccessfulSubHeading.
  ///
  /// In en, this message translates to:
  /// **'Now you can explore the rates\nand post loads'**
  String get loginSuccessfulSubHeading;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @loads.
  ///
  /// In en, this message translates to:
  /// **'Loads'**
  String get loads;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @selectPickUpPoint.
  ///
  /// In en, this message translates to:
  /// **'Select pickup point'**
  String get selectPickUpPoint;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @selectDestination.
  ///
  /// In en, this message translates to:
  /// **'Select destination'**
  String get selectDestination;

  /// No description provided for @upComingShipment.
  ///
  /// In en, this message translates to:
  /// **'Upcoming shipments'**
  String get upComingShipment;

  /// No description provided for @postLoad.
  ///
  /// In en, this message translates to:
  /// **'Post Load'**
  String get postLoad;

  /// No description provided for @your.
  ///
  /// In en, this message translates to:
  /// **'Your'**
  String get your;

  /// No description provided for @stillPending.
  ///
  /// In en, this message translates to:
  /// **'verification is still Pending'**
  String get stillPending;

  /// No description provided for @allTrips.
  ///
  /// In en, this message translates to:
  /// **'All Trips'**
  String get allTrips;

  /// No description provided for @activeTrips.
  ///
  /// In en, this message translates to:
  /// **'Active Trips'**
  String get activeTrips;

  /// No description provided for @upcomingTrips.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcomingTrips;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @kyc.
  ///
  /// In en, this message translates to:
  /// **'KYC'**
  String get kyc;

  /// No description provided for @recentAddedLoad.
  ///
  /// In en, this message translates to:
  /// **'Recent Added Load'**
  String get recentAddedLoad;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @availableLoads.
  ///
  /// In en, this message translates to:
  /// **'Available Loads'**
  String get availableLoads;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This filed is required'**
  String get thisFieldIsRequired;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get vehicleType;

  /// No description provided for @selectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle type'**
  String get selectVehicleType;

  /// No description provided for @lane.
  ///
  /// In en, this message translates to:
  /// **'Lane'**
  String get lane;

  /// No description provided for @selectLaneType.
  ///
  /// In en, this message translates to:
  /// **'Select lane type'**
  String get selectLaneType;

  /// No description provided for @roadType.
  ///
  /// In en, this message translates to:
  /// **'Road Type'**
  String get roadType;

  /// No description provided for @selectRoadType.
  ///
  /// In en, this message translates to:
  /// **'Select road type'**
  String get selectRoadType;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @tripTracking.
  ///
  /// In en, this message translates to:
  /// **'Trip Tracking'**
  String get tripTracking;

  /// No description provided for @allTrip.
  ///
  /// In en, this message translates to:
  /// **'All Trip'**
  String get allTrip;

  /// No description provided for @kavachModels.
  ///
  /// In en, this message translates to:
  /// **'KAVACH Models'**
  String get kavachModels;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get phoneNumber;

  /// No description provided for @businessName.
  ///
  /// In en, this message translates to:
  /// **'Business Details'**
  String get businessName;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @truckType.
  ///
  /// In en, this message translates to:
  /// **'Truck Type'**
  String get truckType;

  /// No description provided for @ownedTrucks.
  ///
  /// In en, this message translates to:
  /// **'Owned Trucks'**
  String get ownedTrucks;

  /// No description provided for @attachedTrucks.
  ///
  /// In en, this message translates to:
  /// **'Attached Trucks'**
  String get attachedTrucks;

  /// No description provided for @preferredLanes.
  ///
  /// In en, this message translates to:
  /// **'Preferred Lanes'**
  String get preferredLanes;

  /// No description provided for @businessProof.
  ///
  /// In en, this message translates to:
  /// **'Business Proof'**
  String get businessProof;

  /// No description provided for @uploadRC.
  ///
  /// In en, this message translates to:
  /// **'Upload RC (for 1 Truck)'**
  String get uploadRC;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload document'**
  String get uploadDocument;

  /// No description provided for @aadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number(optional)'**
  String get aadhaarNumber;

  /// No description provided for @aadhaarHint.
  ///
  /// In en, this message translates to:
  /// **'xxxx xxxx xxxx'**
  String get aadhaarHint;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @selectTruckType.
  ///
  /// In en, this message translates to:
  /// **'Select truck type'**
  String get selectTruckType;

  /// No description provided for @benefitsOfKavach.
  ///
  /// In en, this message translates to:
  /// **'Benefits of KAVACH'**
  String get benefitsOfKavach;

  /// No description provided for @benefitsOfKavachHeading1.
  ///
  /// In en, this message translates to:
  /// **'No Unfair Blame for Fuel Loss'**
  String get benefitsOfKavachHeading1;

  /// No description provided for @benefitsOfKavachHeading2.
  ///
  /// In en, this message translates to:
  /// **'Prevents Delay from Theft Investigations'**
  String get benefitsOfKavachHeading2;

  /// No description provided for @benefitsOfKavachSubHeading1.
  ///
  /// In en, this message translates to:
  /// **'KAVACH protects drivers from being wrongly accused of fuel theft.'**
  String get benefitsOfKavachSubHeading1;

  /// No description provided for @benefitsOfKavachSubHeading2.
  ///
  /// In en, this message translates to:
  /// **'Keeps drivers on schedule by avoiding time lost to fuel theft issues.'**
  String get benefitsOfKavachSubHeading2;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @blueMembershipId.
  ///
  /// In en, this message translates to:
  /// **'Blue Membership ID'**
  String get blueMembershipId;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @registrationData.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationData;

  /// No description provided for @kycStatus.
  ///
  /// In en, this message translates to:
  /// **'KYC Status'**
  String get kycStatus;

  /// No description provided for @companyDetails.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get companyDetails;

  /// No description provided for @gst.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get gst;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @updateChanges.
  ///
  /// In en, this message translates to:
  /// **'Update Changes'**
  String get updateChanges;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @validateMemo.
  ///
  /// In en, this message translates to:
  /// **'Validate Memo'**
  String get validateMemo;

  /// No description provided for @iAgreeTripToGo.
  ///
  /// In en, this message translates to:
  /// **'I agree trip to Gro'**
  String get iAgreeTripToGo;

  /// No description provided for @memo.
  ///
  /// In en, this message translates to:
  /// **'Memo'**
  String get memo;

  /// No description provided for @verifyAdvance.
  ///
  /// In en, this message translates to:
  /// **'Verify Advance'**
  String get verifyAdvance;

  /// No description provided for @advancePayment.
  ///
  /// In en, this message translates to:
  /// **'Advance payment'**
  String get advancePayment;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get needHelp;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @models.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get models;

  /// No description provided for @excludingGST.
  ///
  /// In en, this message translates to:
  /// **'*Excluding GST'**
  String get excludingGST;

  /// No description provided for @pinCode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pinCode;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created Successfully'**
  String get accountCreatedSuccessfully;

  /// No description provided for @accountCreatedSuccessfullySubHeading.
  ///
  /// In en, this message translates to:
  /// **'Now you can explore the rates\nand post loads'**
  String get accountCreatedSuccessfullySubHeading;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @companyType.
  ///
  /// In en, this message translates to:
  /// **'Company Type'**
  String get companyType;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @inText.
  ///
  /// In en, this message translates to:
  /// **'  in  '**
  String get inText;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **' seconds'**
  String get second;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'checkout'**
  String get checkout;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @addMoreItems.
  ///
  /// In en, this message translates to:
  /// **'Add More Items'**
  String get addMoreItems;

  /// No description provided for @addVehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle Details'**
  String get addVehicleDetails;

  /// No description provided for @gstKavach.
  ///
  /// In en, this message translates to:
  /// **'GST'**
  String get gstKavach;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddress;

  /// No description provided for @billingAddress.
  ///
  /// In en, this message translates to:
  /// **'Billing Address'**
  String get billingAddress;

  /// No description provided for @addNewAddress.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get addNewAddress;

  /// No description provided for @sameAsShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Same As Shipping Address'**
  String get sameAsShippingAddress;

  /// No description provided for @deliverHere.
  ///
  /// In en, this message translates to:
  /// **'Deliver Here'**
  String get deliverHere;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
