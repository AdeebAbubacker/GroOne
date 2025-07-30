import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/api_request/create_ticket_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/utils/validator.dart';


class AddNewTicketScreen extends StatefulWidget {
  const AddNewTicketScreen({super.key});

  @override
  State<AddNewTicketScreen> createState() => _AddNewTicketScreenState();
}

class _AddNewTicketScreenState extends State<AddNewTicketScreen> {
  final profileCubit = locator<ProfileCubit>();
  final issueCategoryController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final List<String> _uploadedFiles = [];

  @override
  void dispose() {
    issueCategoryController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
       await profileCubit.createTicket(
        request: CreateTicketRequest(
          issueCategory: issueCategoryController.text.trim(),
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          attachmentLink: _uploadedFiles,
        ),
      );

       var uiState = profileCubit.state.createTicketState;

       if (uiState?.status == Status.SUCCESS) {
         Navigator.pop(context);
       }


       if(uiState?.status == Status.ERROR) {
         ToastMessages.error(message: getErrorMsg(errorType: uiState?.errorType ?? GenericError()));
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ],
                validator: (val) => Validator.fieldRequired(val,fieldName: context.appText.title),
              ),
              12.height,
              AppTextField(
                maxLines: 3,
                labelText: context.appText.description,
                controller: descriptionController,
                validator: (val) => Validator.fieldRequired(val,fieldName: context.appText.description),
              ),
              12.height,

              UploadAttachmentFiles(
                title: context.appText.attachment,
                multiFilesList: _uploadedFiles,
                isSingleFile: true,
                allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
              ),

              const Spacer(),

              AppButton(
                onPressed: _submitForm,
                title: context.appText.submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}