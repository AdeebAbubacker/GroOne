import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/global_variables.dart';
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
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_dialog.dart';
import 'app_image.dart';
import 'common_dialog_view/common_dialog_view.dart';
import 'constant_variables.dart';

/// Field Focus change
void fieldFocusChange(
  BuildContext context, {
  required FocusNode current,
  required FocusNode nextFocus,
}) {
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
void exitApp() {
  if (Platform.isIOS) {
    exit(0);
  } else {
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

Future<String?> commonDatePicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime selectedDate = DateTime.now();
  String? date;
  commonHideKeyboard(context);
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(1970),
    lastDate: lastDate ?? DateTime(3000),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryColor, // Selection color
            onPrimary: Colors.white, // Text color on selection
            onSurface: AppColors.primaryTextColor, // Text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
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

Future<String?> commonTimePicker(
  BuildContext context, {
  TimeOfDay? initialTime,
}) async {
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
            primary: AppColors.primaryColor, // Selection color
            onPrimary: Colors.white, // Text color on selection
            onSurface: Colors.black, // Text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
            ),
          ),
          timePickerTheme: AppThemeStyle.timePickerTheme,
        ),
        child: child!,
      );
    },
  );

  try {
    if (picked != null) {
      // Convert TimeOfDay to 12-hour format
      final now = DateTime.now();
      final formattedTime = DateFormat('hh : mm a').format(
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
      );
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
            primary: AppColors.primaryColor, // Selection color
            onPrimary: AppColors.white, // Text color on selection
            onSurface: Colors.black, // Text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
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
      final formattedHour = DateFormat(
        'hh a',
      ).format(DateTime(now.year, now.month, now.day, picked.hour, 0));
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
  static Future<T?> fromCamera<T>({List? allowedExtensions}) async {
    dynamic imageFile;
    final XFile? pickedFromCamera = await picker.pickImage(
      source: ImageSource.camera,);
    if (pickedFromCamera == null) {
      ToastMessages.alert(message: appContext.appText.noImageSelected);
    } else {
      final compressedFIle= await ImagePickerFrom.compressImage(File(pickedFromCamera.path));
      if(compressedFIle==null){
        return null;
      }
      final File fileImage = File(pickedFromCamera.path??"");
      final File fileName = File(pickedFromCamera.name);
      final String fileExtension = path.extension(pickedFromCamera.path).replaceFirst('.', '');
      dynamic data = {
        "fileName": compressedFIle.path,
        "path": compressedFIle.path,
        "extension": fileExtension,
        "dateTime": DateTime.now().toString(),
      };
      if (_imageConstraint(fileImage, allowedExtensions: allowedExtensions)) {
        imageFile = data;
      }
    }
    return imageFile;
  }

  // From Gallery
  static Future<T?> fromGallery<T>({List? allowedExtensions}) async {
    dynamic imageFile;
    final XFile? pickedFromGallery = await picker.pickImage(
      source: ImageSource.gallery,

    );
    if (pickedFromGallery == null) {
      ToastMessages.alert(message: appContext.appText.noImageSelected);
    } else {
      final compressedFile = await compressImage(File(pickedFromGallery.path));

      int fileSize =await  compressedFile?.length()??0;
      if(compressedFile==null){
        return null;
      }

      final File fileImage = File(compressedFile.path);
      final File fileName = File(compressedFile.name);
      final String fileExtension = path.extension(compressedFile.path).replaceFirst('.', '');
      dynamic data = {
        "fileName": compressedFile.path,
        "path": compressedFile.path,
        "extension": fileExtension,
        "dateTime": DateTime.now().toString(),
      };
      if (_imageConstraint(File(compressedFile.path), allowedExtensions: allowedExtensions)) {
        imageFile = data;
      }
    }
    return imageFile;
  }





  static Future<XFile?> compressImage(File file) async {
    print("call compress image");
    const int maxSizeInBytes = 5 * 1024 * 1024;
    const int minQuality = 30;


    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      return XFile(file.path);
    }

    final originalSize = await file.length();
    if (originalSize <= maxSizeInBytes) {
      return XFile(file.path);
    }

    final dir = Directory.systemTemp;
    final basePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}';
    int quality = 90;
    File? compressedFile;

    while (quality >= minQuality) {
      final targetPath = '$basePath-q$quality.${mimeType.split("/").last}';
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        rotate: 0,
        minHeight: 400,
        minWidth: 400,
      );

      if (result != null && await result.length() <= maxSizeInBytes) {
        final compressedSize = await result.length();
        print("📉 Compressed (quality $quality): ${(compressedSize / (1024 * 1024)).toStringAsFixed(2)} MB");

        if (compressedSize <= maxSizeInBytes) {
          compressedFile = File(result.path);
          break;
        }
      }

      quality -= 5;
    }

    if (compressedFile == null) {
      print("❌ Compression failed or still too large. Returning original.");
    } else {
      print("✅ Final compressed size: ${(await compressedFile.length() / (1024 * 1024)).toStringAsFixed(2)} MB");
    }

    return XFile(compressedFile?.path ?? file.path);
  }






  // Image Constraint
  static bool _imageConstraint(File image, {List? allowedExtensions}) {
    final extension = image.path.split('.').last.toLowerCase();

    final defaultAllowed = [
      'jpg',
      'jpeg',
      'png',
      'heif',
      'heic',
      'pdf',
    ];

    if (!(allowedExtensions ?? defaultAllowed).contains(extension)) {
      ToastMessages.alert(message: appContext.appText.imageSupport);
      return false;
    }
    if (image.lengthSync() > 5000000) {
      ToastMessages.alert(message: appContext.appText.imageSize);
      return false;
    }
    return true;
  }
}

/// Multiple File Picker
Future<Map?> pickMultipleFiles<T>({List? allowedExtensions}) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      withReadStream: true,


    );

    if (result == null || result.files.isEmpty) {
      ToastMessages.alert(message: "No files have been selected");
      return null;
    }

    final defaultAllowedExtensions = <String>{
      "jpg",
      "jpeg",
      "bmp",
      "pdf",
      "png",
      "doc",
      "docx",
      "txt",
      "xls",
      "xlsx",
      "ods",
      "zip",
      "rar",
      "xml",
      "mp4",
      "hevc",
      "h.264",
      "mov",
      "heic",
      "mp3",
    };

    final extensionSet = allowedExtensions != null
        ? allowedExtensions.map((e) => e.toLowerCase()).toSet()
        : defaultAllowedExtensions;

    var validFiles = {};

    for (final file in result.files) {
      final extension = file.extension?.toLowerCase() ?? '';
      final compressedFIle= await ImagePickerFrom.compressImage(File(file.path!));
      String? path;
      if(compressedFIle!=null){
        path = compressedFIle.path;
      }


      if (!extensionSet.contains(extension)) {
        ToastMessages.alert(message: "Invalid file format: ${file.name}");
        return null;
      }

      if (path == null || path.isEmpty) {
        ToastMessages.alert(message: "Invalid file path for: ${file.name}");
        return null;
      }

      validFiles = {
        "fileName": compressedFIle?.name,
        "path": path,
        "extension": extension,
        "dateTime": DateTime.now().toString(),
      };

      if ((await compressedFIle?.length()??0) > 5 * 1024 * 1024) {
        ToastMessages.alert(message: appContext.appText.imageSize);
        return null;
      } else {
        return validFiles;
      }

    }
    return null;
  } catch (e) {
    ToastMessages.alert(message: "An error occurred while picking files");
    return null;
  }
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
  final context = appContext;
  switch (errorType) {
    case NotFoundError _:
      return errorType.getText(appContext);
    case GenericError _:
      return context.appText.genericError;
    case InternetNetworkError _:
      return context.appText.networkError;
    case BadRequestError _://
      return errorType.getText(appContext);
    case TokenExpiredError _:
      return context.appText.tokenExpireError;
    case InvalidTokenError _:
      return context.appText.invalidTokenError;
    case ConflictError _://
      return errorType.message ?? '';
    case DeserializationError _:
      return context.appText.deserializationError;
    case RequestCancelledError _:
      return context.appText.requestCancelledError;
    case UnauthenticatedError _:
      return errorType.getText(appContext);
    case NetworkTimeoutError _:
      return context.appText.timeOutError;
    case ResponseStatusFailed _:
      return errorType.getText();
    case SerializationError _:
      return context.appText.serializationError;
    case LoginAttemptError _:
      return context.appText.loginAttemptError;
    case InvalidInputError _:
      return context.appText.invalidInput;
    case InternalServerError _:
      return errorType.message ?? '';
    case ErrorWithMessage _:
      return errorType.message;
    default:
      return "(${errorType.toString()}) error".capitalize;
  }
}

bool isNumeric(String? s) {
  if (s == null) {
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

String timeAgoSinceDate({
  required String dateAndTimeString,
  bool numericDates = true,
  Object? instance,
}) {
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

String formatDateTimeKavach(String dateTimeString) {
  DateTime utcDateTime = DateTime.parse(dateTimeString);
  DateTime localDateTime = utcDateTime.toLocal();
  String formatted = DateFormat('dd MMMM yyyy, h:mm a').format(localDateTime);

  return formatted;
}



/// Common Support Dialog
void commonSupportDialog(BuildContext context, {String? message}) {
  AppDialog.show(
    context,
    child: CommonDialogView(
      heading: context.appText.callCustomerSupport,
      message: message ?? context.appText.contactOurCustomerSupport,
      headingTextStyle: AppTextStyle.h3.copyWith(fontWeight: FontWeight.w200),
      onSingleButtonText: context.appText.call,
      onTapSingleButton: () async {
        await callRedirect(SUPPORT_NUMBER);
      },
      child: SvgPicture.asset(AppImage.svg.customerSupport, width: 200),
    ),
  );
}

String getInitialsFromName(Object instance, {required String name}) {
  CustomLog.debug(instance, "Name is $name, Length is ${name.length}");
  if (name.trim().isEmpty) return '?'; // or return ''; if you prefer

  final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();

  if (parts.length == 1) return parts[0][0].toUpperCase();

  return parts.take(2).map((e) => e[0].toUpperCase()).join();
}

// Get App Version Info
Future<String> appVersionInfo() async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
}
