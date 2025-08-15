import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../utils/app_image.dart';

class MyDocumentScreen extends StatefulWidget {
  const MyDocumentScreen({super.key});

  @override
  State<MyDocumentScreen> createState() => _MyDocumentScreenState();
}

class _MyDocumentScreenState extends State<MyDocumentScreen> {
  final profileCubit = locator<ProfileCubit>();
  final lpLoadCubit = locator<LpLoadCubit>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(() {
    profileCubit.fetchDocuments();
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(context.appText.myDocuments, style: AppTextStyle.body1),
      ),
      body: RefreshIndicator(
        onRefresh: () async => initFunction(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final uiState = state.documentState;

            if (uiState == null || uiState.status == Status.LOADING) {
              return const Center(child: CircularProgressIndicator());
            }

            if (uiState.status == Status.ERROR) {
              return genericErrorWidget(error: uiState.errorType);
            }

            final docs = uiState.data?.documents;

            if (docs == null) {
              return genericErrorWidget(error: NotFoundError(message: context.appText.noDocumentsFound));
            }

            List<Widget> tiles = [];
            void addTile(String? val, bool? enabled, var details) {
              if ((enabled ?? true) && (val?.isNotEmpty ?? false)) {
                tiles.add(docTile(details?.title ?? context.appText.unknown, DateTimeHelper.formatCustomDateTimeIST(details?.createdAt), details?.documentId ?? '', details?.fileExtension ?? ''));
              }
            }

            addTile(docs.gstin, docs.isGstin, docs.gstinDocLinkDetails);
            addTile(docs.tan, docs.isTan, docs.tanDocLinkDetails);
            addTile(docs.pan, docs.isPan, docs.panDocLinkDetails);
            addTile(docs.tdsDocLink, true, docs.tdsDocLinkDetails);
            addTile(docs.chequeDocLink, true, docs.chequeDocLinkDetails);
            addTile(docs.aadhar, true, docs.aadharDocDetails);

            if (tiles.isEmpty) {
              return genericErrorWidget(error: NotFoundError(message: context.appText.noDocumentsFound));
            }

            return Stack(
              children: [
                if(lpLoadCubit.state.lpDocumentById?.status == Status.LOADING) CircularProgressIndicator().center(),
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: tiles,
                ),
              ],
            );
            },
        ),
      ),
    );
  }

  Widget docTile(String title, String value,  String documentId, String fileExtension) {

    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        await lpLoadCubit.getDocumentById(docId: documentId);

        final uiState = lpLoadCubit.state.lpDocumentById;

        if (uiState?.status == Status.LOADING) {
        } else if (uiState?.status == Status.SUCCESS) {
          await lpLoadCubit.downloadAndOpenDocument('', uiState?.data?.filePath ?? '');

        } else if (uiState?.status == Status.ERROR) {
          final errorType = uiState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
          return;
        }

        setState(() {
          isLoading = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: commonContainerDecoration(),
        child: ListTile(
          leading: () {
            final ext = fileExtension.toLowerCase();
            return ext == "pdf"
                ? SvgPicture.asset(AppImage.svg.myDocumentsIcon2, height: 40, width: 40)
                : ["jpeg", "png", "jpg", "heic"].contains(ext)
                ? Icon(CupertinoIcons.photo_on_rectangle, color: AppColors.primaryColor, size: 40)
                : const Icon(CupertinoIcons.doc_text_fill, color: AppColors.greyIconColor, size: 30);
          }(),
          title: Text(title, style: AppTextStyle.h5),
          subtitle: Text('${context.appText.uploadedOn} $value', style: AppTextStyle.textGreyDetailColor12w400),
        ),
      ),
    );
  }
}