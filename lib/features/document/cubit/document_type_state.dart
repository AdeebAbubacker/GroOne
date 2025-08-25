import 'package:equatable/equatable.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/features/document/model/document_type_response.dart';

class DocumentTypeState extends Equatable {
  final UIState<DocumentTypeResponseModel>? documentTypeState;

  const DocumentTypeState({
    this.documentTypeState,
  });

  DocumentTypeState copyWith({
    UIState<DocumentTypeResponseModel>? documentTypeState,
  }) {
    return DocumentTypeState(
      documentTypeState: documentTypeState ?? this.documentTypeState,
    );
  }

  @override
  List<Object?> get props => [
    documentTypeState,
  ];
}
