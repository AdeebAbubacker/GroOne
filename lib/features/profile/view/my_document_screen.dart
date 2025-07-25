import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';

import '../../../utils/app_image.dart';

class MyDocumentScreen extends StatefulWidget {
  const MyDocumentScreen({super.key});

  @override
  State<MyDocumentScreen> createState() => _MyDocumentScreenState();
}

class _MyDocumentScreenState extends State<MyDocumentScreen> {

  final profileLocator = locator<ProfileCubit>();


  @override
  void initState() {
    super.initState();
    profileLocator.fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(context.appText.myDocuments, style: AppTextStyle.body1),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Expanded(child: documentInfoWidget()),
      ),
    );
  }

  Widget documentInfoWidget(){
    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final uiState = state.documentState;

          if (uiState == null || uiState.status == Status.LOADING) {
            return const Center(child: CircularProgressIndicator());
          }

          if (uiState.status == Status.ERROR) {
            return genericErrorWidget(error: uiState.errorType);
          }

          final documents = uiState.data?.documents;

          if (documents == null) {
            return genericErrorWidget(error: NotFoundError(message: context.appText.noDocumentsFound));
          }

          return Column(
            children: [
              buildDocuments(title: 'GSTIN'),
              buildDocuments(title: 'TAN'),
              buildDocuments(title: 'PAN'),
            ],
          );
        },);
  }

  Widget buildDocuments({required String title}) {
    return  Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric( vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.white,
        ),
        child:ListTile(
          leading:  SvgPicture.asset(AppImage.svg.myDocumentsIcon2, height: 40, width: 40),
          title:   Text(
            title,
            style: AppTextStyle.h5,
          ),
          subtitle: Text("",style: AppTextStyle.textGreyDetailColor12w400,),
        ));
  }
}
