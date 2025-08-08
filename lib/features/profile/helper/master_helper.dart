import 'package:gro_one_app/features/profile/model/blood_group_response.dart';
import 'package:gro_one_app/features/profile/model/license_category_response.dart';

class MasterHelper {
  /// blood groups
  static final List<BloodGroupResponseModel> _bloodGroups = [
    BloodGroupResponseModel(id: 1, groupName: "A+"),
    BloodGroupResponseModel(id: 2, groupName: "A−"),
    BloodGroupResponseModel(id: 3, groupName: "B+"),
    BloodGroupResponseModel(id: 4, groupName: "B−"),
    BloodGroupResponseModel(id: 5, groupName: "AB+"),
    BloodGroupResponseModel(id: 6, groupName: "AB−"),
    BloodGroupResponseModel(id: 7, groupName: "O+"),
    BloodGroupResponseModel(id: 8, groupName: "O−"),
  ];

  /// license categories
  static final List<LicenseCategoryResponseModel> _licenseCategories = [
  LicenseCategoryResponseModel(id: 1, categoryName: "LMV"),
  LicenseCategoryResponseModel(id: 2, categoryName: "MGV"),
  LicenseCategoryResponseModel(id: 3, categoryName: "HMV"),
  LicenseCategoryResponseModel(id: 4, categoryName: "HGMV"),
  LicenseCategoryResponseModel(id: 5, categoryName: "HPMV/HPV"),
  LicenseCategoryResponseModel(id: 6, categoryName: "Trailer"),
  ];

  /// Map a blood group string to its ID
  static int? mapBloodGroupToId(String? groupName) {
    if (groupName == null) return null;
    return _bloodGroups
        .firstWhere((g) => g.groupName?.toUpperCase() == groupName.toUpperCase(),
            orElse: () => BloodGroupResponseModel())
        .id;
  }

  /// Map a license category string to its ID
  static int? mapLicenseCategoryToId(String? categoryName) {
    if (categoryName == null) return null;
    return _licenseCategories
        .firstWhere((c) => c.categoryName?.toLowerCase() == categoryName.toLowerCase(),
            orElse: () => LicenseCategoryResponseModel())
        .id;
  }

  /// Get name from blood group ID
  static String? mapBloodGroupIdToName(int? id) {
    if (id == null) return null;
    return _bloodGroups.firstWhere((g) => g.id == id,
        orElse: () => BloodGroupResponseModel()).groupName;
  }

  /// Get name from license category ID
  static String? mapLicenseCategoryIdToName(int? id) {
    if (id == null) return null;
    return _licenseCategories.firstWhere((c) => c.id == id,
        orElse: () => LicenseCategoryResponseModel()).categoryName;
  }
}
