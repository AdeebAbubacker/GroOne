import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/profile/api_request/ticket_request.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/view/faq_screen.dart';
import 'package:gro_one_app/features/profile/view/ticket_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../utils/app_icons.dart';
import '../../ai_chat/view/chat_screen.dart';
import '../../ai_chat/cubit/chat_cubit.dart';

class LpSupport extends StatefulWidget {
  const LpSupport({super.key, this.showBackButton = true, this.ticketTag});

  final bool showBackButton;
  final String? ticketTag; // <-- New

  @override
  State<LpSupport> createState() => _LpSupportState();
}

class _LpSupportState extends State<LpSupport> {
  int selectedTabIndex = 0;

  TextEditingController searchController = TextEditingController();
  final profileCubit = locator<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    initFunction();
  }

  void initFunction() => frameCallback(() async {
    await profileCubit.fetchFaq();
  });

  void _onSearchChanged(String query) {
    if (selectedTabIndex == 0) {
      profileCubit.fetchFaq(search: searchController.text, isLoading: false);
    } else {
      profileCubit.fetchTickets(
        isLoading: false,
        request: TicketRequest(search: searchController.text),
      );
    }
  }

  void filterPopUp() {
    AppDialog.show(
      context,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final selected = state.tempSelectedTicketStatus;

          return CommonDialogView(
            crossAxisAlignment: CrossAxisAlignment.start,
            hideCloseButton: true,
            showYesNoButtonButtons: true,
            yesButtonText: context.appText.apply,
            noButtonText: context.appText.clear,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appText.filter,
                  style: AppTextStyle.body1.copyWith(fontSize: 20),
                ),
                10.height,
                RadioListTile<TicketStatus>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.appText.pending),
                  value: TicketStatus.pending,
                  groupValue: selected,
                  onChanged: (val) => profileCubit.updateTempTicketStatus(val),
                ),
                RadioListTile<TicketStatus>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.appText.completed),
                  value: TicketStatus.completed,
                  groupValue: selected,
                  onChanged: (val) => profileCubit.updateTempTicketStatus(val),
                ),
              ],
            ),
            onClickYesButton: () {
              Navigator.pop(context);
              profileCubit.applyTicketStatusFilter();
            },
            onClickNoButton: () {
              Navigator.pop(context);
              profileCubit.clearTicketStatusFilter();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF64B5F6), // Light blue
              Color(0xFF1976D2), // Darker blue
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Navigate to ChatScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider.value(
                      value: locator<ChatCubit>(),
                      child: ChatScreen(),
                    ),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/gif/lntAnimateLogo.gif'),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildToggleTabs(context),
              18.height,
              buildSearchBarAndFilterWidget(),
              18.height,
              buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return CommonAppBar(
      title: context.appText.support,
      scrolledUnderElevation: 0,
      isLeading: widget.showBackButton ? true : false,
      actions: [
        GestureDetector(
          onTap: () {
            commonSupportDialog(
              context,
              message: context.appText.callCustomerSupportSubtitle,
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(AppImage.png.customerSupport, height: 28),
          ),
        ),
      ],
    );
  }

  Widget buildToggleTabs(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        toggleButton(context.appText.faqs, 0),
        12.width,
        toggleButton(context.appText.tickets, 1),
      ],
    );
  }

  Widget buildSearchBarAndFilterWidget() {
    return Row(
      children: [
        AppSearchBar(
          searchController: searchController,
          onChanged: _onSearchChanged,
          onClear: () {
            searchController.clear();
            commonHideKeyboard(context);
            _onSearchChanged('');
          },
        ).expand(),
        8.width,
        if (selectedTabIndex == 1)
          AppIconButton(
            onPressed: filterPopUp,
            style: AppButtonStyle.primaryIconButtonStyle,
            icon: SvgPicture.asset(AppIcons.svg.filter, width: 20),
          ),
      ],
    );
  }

  Widget buildBody() {
    return selectedTabIndex == 0 ? FaqScreen(searchController: searchController) : TicketScreen(ticketTag: widget.ticketTag, searchController: searchController);
  }

  Widget toggleButton(String label, int index) {
    final isSelected = selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          selectedTabIndex = index;
          if (index == 0) {
            await profileCubit.fetchFaq();
          } else {
            profileCubit.fetchTickets(request: TicketRequest());
          }
          searchController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {});
        },
        child: Container(
          height: 42,
          decoration: commonContainerDecoration(
            color: isSelected ? AppColors.primaryColor : AppColors.greyContainerBg,
            borderRadius: BorderRadius.circular(24),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyle.body3.copyWith(
              color: isSelected ? AppColors.white : AppColors.textGreyDetailColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
