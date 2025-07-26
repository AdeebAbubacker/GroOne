import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';


class AddNewTicketScreen extends StatelessWidget {
  const AddNewTicketScreen({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              labelText: context.appText.issueCategory,
            ),
            const SizedBox(height: 12),


            AppTextField(
              labelText: context.appText.title,
            ),
            12.height,

            AppTextField(
              maxLines: 3,
              labelText: context.appText.description,
            ),
            12.height,
            UploadAttachmentFiles(
              title: context.appText.attachment,
              multiFilesList: [],
              isSingleFile: true,
              allowedExtensions: ['jpg', 'png', 'heic', 'pdf', 'jpeg'],
            ),

            const Spacer(),

            AppButton(onPressed: () {}, title: context.appText.submit)
          ],
        ),
      ),
    );
  }
}