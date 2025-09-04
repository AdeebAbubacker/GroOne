import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/api_request/ticket_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/view/widgets/add_new_support_ticket.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import 'ticket_detail_screen.dart';

class TicketScreen extends StatelessWidget {
  TicketScreen({super.key, this.ticketTag, required this.searchController});

  final profileCubit = locator<ProfileCubit>();

  final String? ticketTag;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final uiState = state.ticketState;

        if (uiState == null || uiState.status == Status.LOADING) {
          return CircularProgressIndicator().center().expand();
        }

        if (uiState.status == Status.ERROR) {
          return genericErrorWidget(error: uiState.errorType, onRefresh: () => profileCubit.fetchTickets(request: TicketRequest())).expand();
        }

        final ticketList = uiState.data?.data ?? [];

        final isSearching = searchController.text.isNotEmpty;

        if (ticketList.isEmpty) {
          final message =
          isSearching
              ? context.appText.noSearchResults
              : context.appText.noTicketsFound;
          return Column(
            children: [
              Text(message).center().expand(),
              buildCreateTicketButton(context),
            ],
          ).expand();
        }

        return Expanded(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    profileCubit.fetchTickets(
                      request: TicketRequest(search: searchController.text),
                    );
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        context.read<ProfileCubit>().fetchTickets(
                          loadMore: true,
                          request: TicketRequest(),
                        );
                      }
                      return false;
                    },
                    child: ListView.separated(
                      itemCount: ticketList.length,
                      separatorBuilder: (_, __) => 12.height,
                      itemBuilder: (_, index) {
                        final ticket = ticketList[index];
                        final isCompleted =
                            ticket.ticketStatusKey == 'COMPLETED';
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, commonRoute(
                                TicketDetailsScreen(
                                  ticketId: ticket.ticketId,
                                  ticketNo: ticket.ticketSeriesId ?? '',
                                  title: ticket.title,
                                  description: ticket.description,
                                  attachment: ticket.attachment.isNotEmpty ? ticket.attachment[0] : '',
                                  time: ticket.createdAt,
                                ),isForward: true));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: commonContainerDecoration(
                              borderColor: AppColors.lightGrey200,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Ticket ID & Status
                                Row(
                                  children: [
                                    Text(
                                      ticket.ticketSeriesId ?? '',
                                      style: AppTextStyle.h5,
                                    ),
                                    20.width,
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                        isCompleted
                                            ? Colors.green.shade50
                                            : Colors.orange.shade50,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        ticket.ticketStatusKey ?? '',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color:
                                          isCompleted
                                              ? AppColors.greenColor
                                              : AppColors.orangeTextColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                commonDivider(height: 20),
                                4.height,
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ticket.title,
                                      style: AppTextStyle.body3.copyWith(
                                        color: AppColors.textGreyDetailColor,
                                      ),
                                    ),
                                    4.height,
                                    Text(
                                      DateTimeHelper.formatCustomDateTimeIST(
                                        ticket.createdAt,
                                      ),
                                      style: AppTextStyle.body3.copyWith(
                                        color: AppColors.grayColor,
                                      ),
                                    ),
                                  ],
                                ),

                                8.height,
                                Text(
                                  ticket.description,
                                  style: AppTextStyle.body4.copyWith(
                                    color: AppColors.grayColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              10.height,
              buildCreateTicketButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget buildCreateTicketButton(BuildContext context) {
    return AppButton(
      onPressed: () {
        Navigator.push(
          context,
          commonRoute(AddNewTicketScreen(ticketTag: ticketTag), isForward: true),
        ).then((val) {
          profileCubit.fetchTickets(request: TicketRequest());
        });
      },
      title: context.appText.createNewTicket,
    );
  }
}
