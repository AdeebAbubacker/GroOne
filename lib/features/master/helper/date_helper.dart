import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';



class DateHelper {
  /// Parses various date formats and returns formatted string `dd/MM/yyyy`.
  static String? parseDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;

    DateTime? parsedDate;

    // Remove dots and trim spaces
    rawDate = rawDate.replaceAll('.', '').trim();

    // Replace hyphen between day-month-year with space for parsing
    String normalizedDate = rawDate.replaceAllMapped(
        RegExp(r'^(\d{1,2})-(\w{3})-(\d{2,4})$'), (match) {
      return '${match[1]} ${match[2]} ${match[3]}';
    });

    // Normalize month abbreviation to Title Case (Jan, Feb, Mar...)
    normalizedDate = normalizedDate.replaceAllMapped(
      RegExp(r'\b[a-zA-Z]{3}\b'),
      (match) =>
          '${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}',
    );

    // List of possible formats
    List<String> formats = [
      'dd-MM-yyyy',
      'dd/MM/yyyy',
      'dd MMM yyyy', // e.g., 12 Sep 2023
      'dd-MMM-yy',
      'yyyy-MM-dd',
      'yyyy-MM-ddTHH:mm:ss.SSSZ', // ISO full timestamp
      'yyyy-MM-ddTHH:mm:ssZ',
      'yyyy-MM-ddTHH:mm:ss',
    ];

    for (var format in formats) {
      try {
        parsedDate = DateFormat(format, 'en_US').parseStrict(normalizedDate);
        break;
      } catch (_) {}
    }

    // ISO fallback using normalized string
    parsedDate ??= DateTime.tryParse(normalizedDate);

    if (parsedDate != null) {
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    }

    return null; // parsing failed
  }
}





class MasterDriverDropDownHelper {
  /// Maps a list of items to a selected item safely
  /// `list` is your list of models (blood groups or license categories)
  /// `idOrName` can be either int ID or String name (from API)
  /// `getId` returns the item's ID (nullable allowed)
  /// `getName` returns the item's name (nullable allowed)
  static T? mapByIdOrName<T>(
    List<T> list,
    dynamic idOrName, {
    required int? Function(T) getId,
    required String? Function(T) getName,
  }) {
    if (list.isEmpty || idOrName == null) return null;

    return list.firstWhereOrNull(
      (item) =>
          (idOrName is int && getId(item) == idOrName) ||
          (idOrName is String && getName(item) == idOrName),
    );
  }

  static Map<String, dynamic>? mapBloodGroup(
    List<BloodGroupResponseModel> list,
    dynamic idOrName,
  ) {
    final matched = mapByIdOrName<BloodGroupResponseModel>(
      list,
      idOrName,
      getId: (t) => t.id,
      getName: (t) => t.groupName,
    );

    if (matched != null) {
      return {
        'id': matched.id,
        'name': matched.groupName,
      };
    }
    return null;
  }

  static Map<String, dynamic>? mapLicenseCategory(
    List<LicenseCategoryResponseModel> list,
    dynamic idOrName,
  ) {
    final matched = mapByIdOrName<LicenseCategoryResponseModel>(
      list,
      idOrName,
      getId: (t) => t.id,
      getName: (t) => t.categoryName,
    );

    if (matched != null) {
      return {
        'id': matched.id,
        'name': matched.categoryName,
      };
    }
    return null;
  }
}
