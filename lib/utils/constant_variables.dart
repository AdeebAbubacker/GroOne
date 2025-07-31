library;

import 'dart:io';

import 'package:flutter/material.dart';

// Constant Global variables
const double commonButtonRadius = 8;
const double commonOutlineButtonRadius = 15;
const double commonPadding = 10;
const double commonSafeAreaPadding = 15.0;
const double commonButtonBottomPadding = 10;
const double commonButtonBottomSheetPadding = 30;
const double commonRadius = 12;
const double commonBottomSheetRadius = 25;
const double commonTexFieldRadius = 5;
const double commonButtonHeight = 50;
const double commonButtonHeight2 = 40;
const double commonTextButtonHeight = 30;
const double commonBannerHeight = 180;

// Strings
const String STATUS = "status";
const String OK = "Ok";
const String SUCCESS = "success";
const String FAILED = "failed";
const String ERROR = "Error";
const String MESSAGE = "message";
const String MSG = "msg";
const String SUPPORT_NUMBER = "1800 208 8800";


// Kyc Upload Doc file type
const String PAN_FILE_TYPE = "pan_card";
const String TDS_FILE_TYPE = "tds";
const String GST_FILE_TYPE = "gst_document";
const String TAN_FILE_TYPE = "tan_document";
const String CHECKED_FILE_TYPE = "cancelled_cheque";
const String VP_DOCUMENT = "vp_document";
const String LP_DOCUMENT = "lp_document";
const String CUSTOMER_DOCUMENT = "customer_document";
const String DAMAGES_AND_SHORTAGES = "damages_and_shortages";


const String indianCurrencySymbol = "₹";

const iosNumberKeyboard = TextInputType.numberWithOptions(signed: true, decimal: true);

// Regex Patterns for EnDhan Customer Info Screen
final RegExp multipleSpacesRegex = RegExp(r'\s+');
final RegExp indianMobileNumberRegex = RegExp(r'^(\+91\s?)?[6-9]\d{9}$');
final RegExp panNumberInputRegex = RegExp(r'[A-Z0-9]');
final RegExp panNumberValidationRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
final RegExp emailValidationRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
final RegExp cityNameInputRegex = RegExp(r'[a-zA-Z\s]');
final RegExp cityNameValidationRegex = RegExp(r'^[a-zA-Z\s]+$');
final RegExp indianPincodeRegex = RegExp(r'^[1-9][0-9]{5}$');

// Regex Patterns for Kavach Add Vehicle Screen
final RegExp vehicleAlphaNumSpaceRegex = RegExp(r'[a-zA-Z0-9 ]');
final RegExp licenseAlphaNumHyphenRegex = RegExp(r'[A-Za-z0-9\-]');

final RegExp alphanumericWithSpaceRegex = RegExp(r'[a-zA-Z0-9 ]');
final RegExp alphabetWithSpaceRegex = RegExp(r'[a-zA-Z ]');






