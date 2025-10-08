import 'package:gro_one_app/core/reset_cubit_state.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/document/cubit/document_type_state.dart';
import 'package:gro_one_app/features/document/model/document_type_response.dart';
import 'package:gro_one_app/features/document/repository/document_repository.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/repository/load_details_repository.dart';

class DocumentTypeCubit extends BaseCubit<DocumentTypeState> {
  final DocumentRepository _documentRepository;
  final LoadDetailsRepository _loadDetailsRepository;

  final LoadDetailsCubit _loadDetailsCubit;
  final DriverLoadDetailsCubit _driverLoadDetailsCubit;

  DocumentTypeCubit(
    this._documentRepository,
    this._loadDetailsRepository,
    this._loadDetailsCubit,
    this._driverLoadDetailsCubit,
  ) : super(DocumentTypeState());

  Future<void> getDocumentTypeList() async {
    emit(state.copyWith(documentTypeState: UIState.loading()));
    Result result = await _documentRepository.getDocumentType();
    if (result is Success<DocumentTypeResponseModel>) {
      emit(state.copyWith(documentTypeState: UIState.success(result.value)));
      _setDocumentData();
    } else if (result is Error) {
      emit(state.copyWith(documentTypeState: UIState.error(result.type)));
    }
  }

  Future<int> getDocumentTypeId(String name) async {
    List<DocumentTypeLst> documentTypeList =
        state.documentTypeState?.data?.documentTypeList ?? [];

    try {
      if (documentTypeList.isNotEmpty) {
        return documentTypeList
                .firstWhere((element) => element.name == name)
                .documentTypeId ??
            0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  _setDocumentData() {
    DocumentDataModel.setDocumentEntityList();
    DocumentDataModel.setDamageDocumentEntity();
    DocumentDataModel.setSupportDocumentEntity();
    Future.delayed(
      Duration(seconds: 1),
      () => _loadDetailsCubit.setDocumentState(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _driverLoadDetailsCubit.setDocumentState(),
    );
  }

  Future<String> getDocumentFileType(String name) async {
    List<DocumentTypeLst> documentTypeList =
        state.documentTypeState?.data?.documentTypeList ?? [];
    try {
      if (documentTypeList.isNotEmpty) {
        return documentTypeList
                .firstWhere((element) => element.name == name)
                .fileType ??
            '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}
