import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/preview_document_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class DriverViewOthersDocument extends StatelessWidget {
  final List<LoadDocument>? loadDocument;
  final DriverLoadDetailsCubit? cubit;
  final DocumentEntity? documentEntity;
  const DriverViewOthersDocument({
    super.key,
    required this.loadDocument,
    this.cubit,
    this.documentEntity,
  });

  List<LoadDocument> getOthersDocument(DriverLoadDetailsState state) {
    try {
      return state.tripDocumentList
              ?.firstWhere(
                (element) =>
                    element.documentType ==
                    DocumentFileType.uploadOtherDocument.documentType,
              )
              .loadDocument ??
          [];
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.othersDocument),
      body: Column(
        children: [
          BlocBuilder<DriverLoadDetailsCubit, DriverLoadDetailsState>(
            builder: (context, state) {
              final otherDocument = getOthersDocument(state);
              return ListView.builder(
                itemCount: otherDocument.length,
                itemBuilder: (context, index) {
                  final loadDocumentObj = otherDocument[index];
                  return PreviewDocumentWidget(
                    showViewMoreButton: false,
                    onClickViewMoreIcon: () {},
                    showAddMoreButton: false,
                    showDeleteIcon:
                        cubit?.state.loadStatus == LoadStatus.loading,
                    showDeleteLoader: false,
                    onClickDeleteIcon: () {
                      cubit?.deleteLoadDocument(
                        loadDocumentObj.loadDocumentId ?? "",
                        index,
                        otherDocument: true,
                      );
                    },
                    onClickDownload: () {
                      cubit?.downloadDocument(
                        loadDocumentObj.documentId ?? "",
                        index,
                      );
                    },
                    onClickAddMoreButton: () {},
                    isLoading: false,
                    documentEntity: documentEntity!,
                    loadDocument: loadDocumentObj,
                  ).paddingSymmetric(horizontal: 15, vertical: 8);
                },
              ).expand();
            },
          ),
        ],
      ),
    );
  }
}
