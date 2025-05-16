import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_string.dart';
import 'package:gro_one_app/utils/app_theme_style.dart';
import 'package:gro_one_app/utils/app_global_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';


/// Field Focus change
void fieldFocusChange(BuildContext context, {required FocusNode current, required FocusNode nextFocus}) {
  current.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

/// Common HapticFeedback Function
Future<void> commonHapticFeedback() async {
  try {
    HapticFeedback.lightImpact();
    debugPrint("Haptic Touch Feedback");
  } catch (e) {
    debugPrint("Touch Feedback $e");
  }
}

/// Common Function
Future<void> commonHideKeyboard(context) async {
  FocusScope.of(context).unfocus();
}

/// Exit App
void exitApp(){
  if(isIOS){
    exit(0);
  }else{
    SystemNavigator.pop();
  }
}

/// Format Time
formattedTime({required int timeInSecond}) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}

Future<String?> commonDatePicker(BuildContext context, {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate }) async {
  DateTime selectedDate = DateTime.now();
  String? date;
  commonHideKeyboard(context);
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now() ,
    firstDate: firstDate ?? DateTime(1970),
    lastDate: lastDate ?? DateTime(3000),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.secondaryColor, // Selection color
            onPrimary: Colors.white, // Text color on selection
            onSurface: Colors.black, // Text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondaryColor, // Button text color
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  try {
    DateFormat formatter = DateFormat("dd/MM/yyyy");
    if (picked != null && picked != selectedDate) {
      date = formatter.format(picked);
      if (kDebugMode) {
        print("Date : $date");
      } // something like 2013-04-20
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return date;
}

Future<String?> commonTimePicker(BuildContext context, {TimeOfDay? initialTime}) async {
  TimeOfDay selectedTime = TimeOfDay.now();
  String? time;
  commonHideKeyboard(context);

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime ?? selectedTime,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.secondaryColor, // Selection color
            onPrimary: Colors.white, // Text color on selection
            onSurface: Colors.black, // Text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondaryColor, // Button text color
            ),
          ),
          timePickerTheme: AppThemeStyle.timePickerTheme,
        ),
        child: child!,
      );
    },
  );

  try {
    if (picked != null && picked != selectedTime) {
      // Convert TimeOfDay to 12-hour format
      final now = DateTime.now();
      final formattedTime = DateFormat('hh : mm a').format(DateTime(now.year, now.month, now.day, picked.hour, picked.minute));
      time = formattedTime;
      if (kDebugMode) {
        print("Time : $time"); // Example output: "09 : 30 AM"
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return time;
}

Future<String?> commonHourPicker(BuildContext context) async {
  TimeOfDay selectedHour = TimeOfDay.now();
  String? hour;

  commonHideKeyboard(context);

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedHour,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.secondaryColor, // Selection color
            onPrimary: AppColors.primaryColor, // Text color on selection
            onSurface: Colors.black, // Text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondaryColor, // Button text color
            ),
          ),
          timePickerTheme: AppThemeStyle.timePickerTheme,
        ),
        child: child!,
      );
    },
  );

  try {
    print("picked $picked");
    if (picked != null) {
      final now = DateTime.now();
      final formattedHour = DateFormat('hh a').format(
        DateTime(now.year, now.month, now.day, picked.hour, 0),
      );
      hour = formattedHour; // Example output: "09 AM" or "04 PM"

      if (kDebugMode) {
        print("Hour: $hour");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  return hour;
}



/// Image Picker Function
class ImagePickerFrom {
  static ImagePicker picker = ImagePicker();

  // From Camera
  static Future<T?> fromCamera<T>() async {
    dynamic imageFile;
    final XFile? pickedFromCamera = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFromCamera == null) {
      ToastMessages.alert(message: AppString.label.noImageSelected);
    } else {
      final File fileImage = File(pickedFromCamera.path);
      final File fileName = File(pickedFromCamera.name);
      final String fileExtension = path.extension(pickedFromCamera.path).replaceFirst('.', '');
      dynamic data = {
        "fileName": fileName.path,
        "path": fileImage.path,
        "extension": fileExtension,
        "dateTime": DateTime.now().toString(),
      };
      if (_imageConstraint(fileImage)) {
        imageFile = data;
      }
    }
    return imageFile;
  }

  // From Gallery
  static Future<T?> fromGallery<T>() async {
    dynamic imageFile;
    final XFile? pickedFromGallery = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFromGallery == null) {
       ToastMessages.alert(message: AppString.label.noImageSelected);
    } else {
      final File fileImage = File(pickedFromGallery.path);
      final File fileName = File(pickedFromGallery.name);
      final String fileExtension = path.extension(pickedFromGallery.path).replaceFirst('.', '');
      dynamic data = {
        "fileName": fileName.path,
        "path": fileImage.path,
        "extension": fileExtension,
        "dateTime": DateTime.now().toString(),
      };
      if (_imageConstraint(fileImage)) {
        imageFile = data;
      }
    }
    return imageFile;
  }

  // Image Constraint
  static bool _imageConstraint(File image) {
    if (!['bmp', 'jpg', 'jpeg', 'png', 'PNG', 'heif', 'HEIF'].contains(image.path.split('.').last.toString())) {
       ToastMessages.alert(message: AppString.label.imageSupport);
      return false;
    }
    if (image.lengthSync() > 8000000) {
      ToastMessages.alert(message: AppString.label.imageSize);
      return false;
    }
    return true;
  }
}

/// Multiple File Picker
Future<List<PlatformFile>?> pickMultipleFile<T>(
    {required BuildContext context, required String type}) async {
  try {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true, withData: true, withReadStream: true);
    if (result != null && result.files.isNotEmpty) {
      if (type.toString().contains("add")) {
        for (var i = 0; i < result.files.length; i++) {
          if (result.files[i].extension.toString().contains("jpg") ||
              result.files[i].extension.toString().contains("jpeg") ||
              result.files[i].extension.toString().contains("gif") ||
              result.files[i].extension.toString().contains("bmp") ||
              result.files[i].extension.toString().contains("pdf") ||
              result.files[i].extension.toString().contains("png") ||
              result.files[i].extension.toString().contains("PNG") ||
              result.files[i].extension.toString().contains("doc") ||
              result.files[i].extension.toString().contains("mp4") ||
              result.files[i].extension.toString().contains("HEVC") ||
              result.files[i].extension.toString().contains("H.264") ||
              result.files[i].extension.toString().contains("MOV") ||
              result.files[i].extension.toString().contains("HEIC") ||
              result.files[i].extension.toString().contains("mp3") ||
              result.files[i].extension.toString().contains("docx") ||
              result.files[i].extension.toString().contains("txt") ||
              result.files[i].extension.toString().contains("xls") ||
              result.files[i].extension.toString().contains("xlsx") ||
              result.files[i].extension.toString().contains("ods") ||
              result.files[i].extension.toString().contains("zip") ||
              result.files[i].extension.toString().contains("rar") ||
              result.files[i].extension.toString().contains("xml")) {
            return result.files;
          } else {
            if (context.mounted) {
              //ToastMessage.alert(message: "Invalid file format");
            }
            break;
          }
        }
      } else {
        for (var i = 0; i < result.files.length;) {
          if (result.files[i].extension.toString().contains("jpg") ||
              result.files[i].extension.toString().contains("jpeg") ||
              result.files[i].extension.toString().contains("gif") ||
              result.files[i].extension.toString().contains("bmp") ||
              result.files[i].extension.toString().contains("pdf") ||
              result.files[i].extension.toString().contains("png") ||
              result.files[i].extension.toString().contains("PNG") ||
              result.files[i].extension.toString().contains("doc") ||
              result.files[i].extension.toString().contains("mp4") ||
              result.files[i].extension.toString().contains("HEVC") ||
              result.files[i].extension.toString().contains("H.264") ||
              result.files[i].extension.toString().contains("MOV") ||
              result.files[i].extension.toString().contains("HEIC") ||
              result.files[i].extension.toString().contains("mp3") ||
              result.files[i].extension.toString().contains("xml") ||
              result.files[i].extension.toString().contains("txt") ||
              result.files[i].extension.toString().contains("xls") ||
              result.files[i].extension.toString().contains("xlsx") ||
              result.files[i].extension.toString().contains("ods") ||
              result.files[i].extension.toString().contains("zip") ||
              result.files[i].extension.toString().contains("rar") ||
              result.files[i].extension.toString().contains("docx")) {
            return result.files;
          } else {
            if (context.mounted) {
             // ToastMessage.alert(message: "Invalid file format");
            }
            break;
          }
        }
      }
    } else {
      if (context.mounted) {
       // ToastMessage.alert(message: "No files has been selected");
      }
    }
  } catch (e) {
    debugPrint("File Picker error $e");
  }
  return null;
}

// /// Error Image
// String getErrorImage({required ErrorType errorType}){
//     switch (errorType){
//       case NotFoundError _:
//         return AppImage.nothingFound;
//       case GenericError _ :
//         return AppImage.somethingWentWrong;
//       case InternetNetworkError _:
//         return AppImage.somethingWentWrong;
//       case BadRequestError _:
//         return AppImage.somethingWentWrong;
//       case UnauthenticatedError _:
//         return AppImage.somethingWentWrong;
//       case InvalidTokenError _:
//         return AppImage.somethingWentWrong;
//       case ConflictError _:
//         return AppImage.somethingWentWrong;
//       case DeserializationError _:
//         return AppImage.somethingWentWrong;
//       default:
//         return AppImage.somethingWentWrong;
//     }
// }

/// Get Error Msg
String getErrorMsg({required ErrorType errorType}) {
  print(errorType);
  switch (errorType) {
    case NotFoundError _:
      return AppString.errorType.notFound;
    case GenericError _:
      return AppString.errorType.genericError;
    case InternetNetworkError _:
      return AppString.errorType.networkError;
    case BadRequestError _:
      return AppString.errorType.badRequestError;
    case TokenExpiredError _:
      return AppString.errorType.tokenExpireError;
    case InvalidTokenError _:
      return AppString.errorType.invalidTokenError;
    case ConflictError _:
      return AppString.errorType.conflictError;
    case DeserializationError _:
      return AppString.errorType.deserializationError;
    case RequestCancelledError _:
      return AppString.errorType.requestCancelledError;
    case UnauthenticatedError _:
      return AppString.errorType.unauthenticatedError;
    case NetworkTimeoutError _:
      return AppString.errorType.timeOutError;
    case ResponseStatusFailed _:
      return AppString.errorType.responseStatusFail;
    case SerializationError _:
      return AppString.errorType.serializationError;
    case LoginAttemptError _:
      return AppString.errorType.loginAttemptError;
    case InvalidInputError _:
      return AppString.errorType.invalidInput;
    case InternalServerError _:
      return AppString.errorType.internalServerError;
    case ErrorWithMessage  _:
      return errorType.message;
    default:
      return "(${errorType.toString()}) error".capitalize;
  }
}

bool isNumeric(String? s) {
  if(s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

Future popToPush(BuildContext context) async {
  Navigator.of(context).pop();
  await Future.delayed(const Duration(milliseconds: 300));
}

// Share Content
void shareContent(String text, {String? subject}) {
  Share.share(text, subject: subject);
}

// Share Files
void shareFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/example.png';

  // Ensure file exists before sharing
  final file = File(filePath);
  if (await file.exists()) {
    Share.shareXFiles([XFile(filePath)], text: "Check this image!");
  }
}

String timeAgoSinceDate({required String dateAndTimeString, bool numericDates = true, Object? instance}) {
  try {
    DateTime notificationDate = DateTime.parse(dateAndTimeString).toLocal();
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return DateFormat("yyyy/MM/dd").format(notificationDate);
    } else if (difference.inDays >= 7) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  } catch (e) {
    if (instance != null) {
      CustomLog.error(instance, "Error on timeAgoSinceDate", e);
    }
    return '';
  }
}


Future<void> callRedirect(String phoneNumber) async {
  try {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (!await launchUrl(url)) {
      throw "Could not launch $url";
    }
  } catch (e) {
    debugPrint("Error launching dial pad: $e");
  }
}


Future<void> downloadAndOpenPdf(String url) async {
  try {
    // Get the directory where we can store files
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/downloaded_pdf.pdf';

    // Download the file
    Dio dio = Dio();
    await dio.download(url, filePath);

    // Open the downloaded PDF file
    OpenFilex.open(filePath);
  } catch (e) {
    debugPrint("Error downloading file: $e");
  }
}



