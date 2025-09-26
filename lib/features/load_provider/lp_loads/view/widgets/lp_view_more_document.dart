import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/view/widgets/trip_documents.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../model/lp_load_get_by_id_response.dart';

class LpViewMoreDocument extends StatelessWidget {
  final List<LoadDocumentData>?  othersDocument;
  const LpViewMoreDocument({super.key,required this.othersDocument});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CommonAppBar(title: context.appText.othersDocument),
      body: Column(
          children: (othersDocument??[]).isNotEmpty ? othersDocument!.map((doc) =>  TripDocuments(
            showViewMoreIcon: false,
            otherDocument:[] ,
            docName:
            doc.documentDetails?.documentType ?? '',
            docDateTime: doc.createdAt!,
            docUrl: doc.documentDetails?.filePath ?? '',
            downloadKey: doc.loadDocumentId,
            docId: doc.documentId,
          ),).toList() :[],
      ).paddingSymmetric(horizontal: 15),
    );
  }
}
