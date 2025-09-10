import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/api_request/create_document_api_request.dart';
import 'package:gro_one_app/features/profile/api_request/create_ticket_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/entitiy/document_entity.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:mime/mime.dart';


class AddNewTicketScreen extends StatefulWidget {
  const AddNewTicketScreen({super.key, this.ticketTag});

  final String? ticketTag;

  @override
  State<AddNewTicketScreen> createState() => _AddNewTicketScreenState();
}

class _AddNewTicketScreenState extends State<AddNewTicketScreen> {
  final profileCubit = locator<ProfileCubit>();
  final issueCategoryController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final List<dynamic> ticketList = [];
  String? ticketDocId;

  @override
  void dispose() {
    issueCategoryController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final tag = widget.ticketTag ??
          (profileCubit.userRole == 1
              ? TicketTags.LOAD_PROVIDER
              : profileCubit.userRole == 2
              ? TicketTags.VEHICLE_PROVIDER
              : profileCubit.userRole == 3
              ? TicketTags.BOTH_LP_VP
              : '');

       await profileCubit.createTicket(
        request: CreateTicketRequest(
          issueCategory: issueCategoryController.text.trim(),
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          attachmentLink: ticketDocId != null ? [ticketDocId] : [],
          ticketTag: tag,
        ),
      );

       var uiState = profileCubit.state.createTicketState;

       if (uiState?.status == Status.SUCCESS) {
         WidgetsBinding.instance.addPostFrameCallback((_) {
           Navigator.pop(context);
           ToastMessages.success(message: context.appText.ticketCreatedSuccess);
         });
       }


       if(uiState?.status == Status.ERROR) {
         ToastMessages.error(message: getErrorMsg(errorType: uiState?.errorType ?? GenericError()));
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: CommonAppBar(
          backgroundColor: Colors.grey.shade100,
          title: context.appText.addNewTicket,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  labelText: context.appText.issueCategory,
                  controller: issueCategoryController,
                  validator: (val) => Validator.fieldRequired(val,fieldName: context.appText.issueCategory),
                ),
                12.height,
                AppTextField(
                  labelText: context.appText.title,
                  controller: titleController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                    LengthLimitingTextInputFormatter(50),
                  ],
                  validator: (val) => Validator.fieldRequired(val,fieldName: context.appText.title),
                ),
                12.height,
                AppTextField(
                  maxLines: 3,
                  labelText: context.appText.description,
                  controller: descriptionController,
                  validator: (val) => Validator.fieldRequired(val,fieldName: context.appText.description),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(240),
                  ],
                ),
                12.height,

                UploadAttachmentFiles(
                  title: context.appText.attachment,
                  multiFilesList: ticketList,
                  isSingleFile: true,
                  allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
                  thenUploadFileToSever: () async {
                    final Result result = await uploadTicketDocumentApiCall(ticketList);
                    if(result is Success) {
                      final ticketData = profileCubit.state.uploadTicketDocUIState?.data;
                      if(ticketData != null &&  ticketList.isNotEmpty){
                        final mimeType = lookupMimeType(ticketList.first['extension']);
                        final supportDocumentEntity=DocumentDataModel.supportDocumentEntity;

                        final apiRequest =  CreateDocumentApiRequest(
                          documentTypeId : supportDocumentEntity?.documentTypeId,
                          title : supportDocumentEntity?.title,
                          description : 'Ticket',
                          originalFilename : ticketData.originalName,
                          filePath : ticketData.filePath,
                          fileSize : ticketData.size,
                          mimeType : mimeType,
                          fileExtension : ticketList.first['extension'],
                        );
                        await createDocumentApiCall(apiRequest);
                        if(profileCubit.state.createDocumentUIState?.status == Status.SUCCESS){
                          if(profileCubit.state.createDocumentUIState?.data != null && profileCubit.state.createDocumentUIState?.data?.data != null){
                            ticketDocId = profileCubit.state.createDocumentUIState!.data!.data!.documentId;
                            if(context.mounted) {
                              ToastMessages.success(message: context.appText.fileUploadedSuccessfully);
                            }
                          }
                        }
                      }
                    }
                  },
                    onDelete: (index) {
                      ticketList.remove(index);
                    }
                ),

                const Spacer(),

                BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  final isLoading = profileState.createTicketState?.status == Status.LOADING;
                  return AppButton(
                    isLoading: isLoading,
                    onPressed: _submitForm,
                    title: context.appText.submit,
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Result<bool>> uploadTicketDocumentApiCall(List<dynamic> multiFilesList) async {
    await profileCubit.uploadTicketDoc(File(multiFilesList.first['path']));
    final status = profileCubit.state.uploadTicketDocUIState?.status;
    if (status != null &&  status == Status.SUCCESS) {
      final data = profileCubit.state.uploadTicketDocUIState?.data;
      final url = data?.url ?? '';

      if (url.isNotEmpty) {
        ticketList.first['path'] = url;
        return Success(true);
      }
    }
    if (status == Status.ERROR) {
      final errorType = profileCubit.state.uploadTicketDocUIState?.errorType;
      ToastMessages.error(message: getErrorMsg(errorType: errorType ?? GenericError()));
    }
    return Error(GenericError());
  }

  // Create Document Api Call
  Future<Result<bool>> createDocumentApiCall(CreateDocumentApiRequest request) async {
    await profileCubit.createDocument(request);
    final status = profileCubit.state.createDocumentUIState?.status;
    if (status == Status.SUCCESS) {
      return Success(true);
    }
    if (status == Status.ERROR) {
      final error = profileCubit.state.createDocumentUIState?.errorType;
      return Error(error ?? GenericError());
    }
    return Error(GenericError());
  }
}

class TicketTags {
  static const BOTH_LP_VP = 'Both Load provider Vehicle provider related';
  static const LOAD_PROVIDER = 'Load provider related';
  static const VEHICLE_PROVIDER = 'Vehicle provider related';
  static const ENDHAN = 'Endhan related';
  static const FASTAG = 'Fastag related';
  static const GPS = 'GPS related';
  static const TANK_LOCK = 'Tank lock related';
  static const DRIVER = 'Driver related';
}
