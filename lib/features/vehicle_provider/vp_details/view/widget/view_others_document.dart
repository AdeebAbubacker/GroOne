import 'package:flutter/material.dart';

import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/widget/preview_document_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../vp-helper/vp_helper.dart';

class ViewOtherDocuments extends StatelessWidget {
  final List<LoadDocument>? loadDocument;
  final LoadDetailsCubit? cubit;
  final DocumentEntity? documentEntity;
  const ViewOtherDocuments({super.key,required this.loadDocument,this.cubit,this.documentEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:CommonAppBar(title: context.appText.othersDocument),
      body:Column(
        children: [
          ListView.builder(
            itemCount:loadDocument?.length??0 ,
            itemBuilder: (context, index) {
              final loadDocumentObj=loadDocument?[index];
              return PreviewDocumentWidget(
                showViewMoreButton: false,
                  onClickViewMoreIcon: () {

                  },
                  showAddMoreButton:false ,
                  showDeleteIcon:cubit?.state.loadStatus==LoadStatus.loading ,
                  showDeleteLoader: false,
                  onClickDeleteIcon: () {
                    cubit?.deleteLoadDocument(loadDocumentObj.loadDocumentId??"",index);
                  },
                  onClickDownload: ()  {
                    cubit?.downloadDocument(loadDocumentObj.documentId??"", index);
                  },
                  onClickAddMoreButton: () {

                  },
                  isLoading: false,
                  documentEntity: documentEntity!,
                  loadDocument: loadDocumentObj!).paddingSymmetric(horizontal: 15,vertical: 8);
            },).expand(),
        ],
      )
    );
  }
}
