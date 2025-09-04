import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/ticket_message_response.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../../utils/app_icons.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String ticketNo;
  final String ticketId;
  final String title;
  final String description;
  final String? attachment;
  final DateTime? time;

  const TicketDetailsScreen({
    super.key,
    required this.ticketNo,
    required this.ticketId,
    required this.title,
    required this.description,
    this.attachment,
    this.time,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {

  final profileCubit = locator<ProfileCubit>();
  final lpLoadCubit = locator<LpLoadCubit>();

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  fetchMessages() async {
    await profileCubit.fetchTicketMessages(ticketId: widget.ticketId, docId: widget.attachment);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text(" ${context.appText.ticket} ${widget.ticketNo}")),

      body: RefreshIndicator(
        onRefresh: () => fetchMessages(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// First message (right aligned)
            Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.attachment != '' ? width * 0.7 : width * 0.5,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: commonContainerDecoration(
                    color: AppColors.blue50
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      4.height,
                      Text(widget.description),
                      if(widget.attachment != '')
                        ...[
                          8.height,
                          BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, state) {
                              final uiState = state.documentById;
                              final filePath = uiState?.data?.filePath ?? '';
                              final fileExtension = uiState?.data?.originalFilename ?? '';

                              if (filePath.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              final isImage = fileExtension.toLowerCase().endsWith('.jpg') ||
                                  fileExtension.toLowerCase().endsWith('.jpeg') ||
                                  fileExtension.toLowerCase().endsWith('.png') ||
                                  fileExtension.toLowerCase().endsWith('.webp');

                              if (isImage) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    filePath,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 150,
                                        color: AppColors.greyContainerBg,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                            Icons.broken_image, size: 40,
                                            color: AppColors.grey),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return BlocBuilder<LpLoadCubit, LpLoadState>(
                                  builder: (context, loadState) {
                                    final isFileLoading = loadState.downloadingKey == uiState?.data?.documentId;

                                    return InkWell(
                                      onTap: () async {
                                        lpLoadCubit.setDownloadingKey(uiState?.data?.documentId);
                                        await lpLoadCubit.downloadAndOpenDocument('', uiState?.data?.filePath ?? '');
                                      },
                                      child: Container(
                                        height: 55,
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.docViewCardBgColor,
                                          borderRadius: BorderRadius.circular(commonTexFieldRadius),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppIcons.svg.documentView,
                                              width: 22,
                                              height: 22,
                                              colorFilter: AppColors.svg(
                                                  AppColors.primaryColor),
                                            ),
                                            10.width,
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  fileExtension,
                                                  style: AppTextStyle.body
                                                      .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: AppColors.textBlackColor,
                                                  ),
                                                ),
                                              ],
                                            ).expand(),
                                            isFileLoading
                                                ? const SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                                : SvgPicture.asset(
                                              AppIcons.svg.download,
                                              colorFilter: AppColors.svg(AppColors.primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],

                      8.height,
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateTimeHelper.formatCustomDateTimeIST(widget.time),
                          style: AppTextStyle.body4.copyWith(color: AppColors.greyTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Admin replies
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final ticketState = state.ticketMessageState;

                if (ticketState?.status == Status.LOADING) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (ticketState?.status == Status.ERROR) {
                  return genericErrorWidget(error: ticketState?.errorType);
                }

                List<TicketMessageResponse> messages = ticketState?.data ?? [];

                return Column(
                  children: messages.map((msg) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: commonContainerDecoration(
                            color: AppColors.greyContainerBg
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(msg.message),
                            4.height,
                            Text(
                              DateTimeHelper.formatCustomDateTimeIST(msg.createdAt),
                              style: AppTextStyle.body4.copyWith(color: AppColors.greyTextColor, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),

      /// Fixed bottom content
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: AppColors.lightBlueColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.appText.forAnyQueriesContactSupportTeam,
              style: AppTextStyle.body,
            ).paddingSymmetric(horizontal: 20),
            AppButton(
              onPressed: () {
                 callRedirect(SUPPORT_NUMBER);
              },
              title: context.appText.contactCustomerSupport,
            ).paddingSymmetric(horizontal: 20, vertical: 15),
          ],
        ),
      ),
    );
  }

}