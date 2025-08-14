import 'dart:io';
import 'package:gro_one_app/features/fastag/service/fastag_service.dart';
import '../../../data/model/result.dart';
import '../../en-dhan_fuel/model/document_upload_response.dart';
import '../model/fastag_list_response.dart';

class FastagRepository{
  final FastagService _service;

  FastagRepository(this._service);


  Future<Result<DocumentUploadResponse>> uploadDocument(File file) async {
    try {
      return await _service.uploadDocument(file);
    } catch (e) {
      return Error(ErrorWithMessage(message: e.toString()));
    }
  }

  Future<Result<bool>> addVehicleRequest({
    required String referralCode,
    required String addressName,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String contactNo,
    required List<Map<String, String>> vehicles,
  }) async {
    return await _service.addVehicleRequest(
      referralCode: referralCode,
      addressName: addressName,
      address: address,
      city: city,
      state: state,
      pincode: pincode,
      contactNo: contactNo,
      vehicles: vehicles,
    );
  }

  Future<Result<FastagListResponse>> getFastagList({String searchTerm = ''}) {
    return _service.getFastagList(searchTerm: searchTerm);
  }


}