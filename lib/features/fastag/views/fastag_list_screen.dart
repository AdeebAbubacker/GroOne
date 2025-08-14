import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../data/ui_state/status.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_search_bar.dart';
import '../cubit/fastag_cubit.dart';
import 'buy_new_fastag_screen.dart';
import 'fastag_detail_screen.dart';
import 'fastag_new_user_screen.dart';
import 'fastag_recharge_screen.dart';

class FastagListScreen extends StatefulWidget {
  const FastagListScreen({super.key});

  @override
  State<FastagListScreen> createState() => _FastagListScreenState();
}

class _FastagListScreenState extends State<FastagListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<FastagCubit>().fetchFastagList(isInitialLoad: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FastagCubit, FastagState>(
      listenWhen: (previous, current) =>
      current.shouldNavigateToBuyFastag && !previous.shouldNavigateToBuyFastag,
      listener: (context, state) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BuyNewFastagScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CommonAppBar(
          title: Text(context.appText.fastag, style: AppTextStyle.appBar),
          centreTile: false,
          actions: [
            AppIconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FastagNewUserScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white),
              style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
            ),
            4.width,
            AppIconButton(
              onPressed: () {
                // More options
              },
              icon: Image.asset(AppIcons.png.moreVertical),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              _buildSearchBar(context),
              10.height,
              Text(
                'My Fastag',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ).paddingSymmetric(horizontal: 16.0),
              Expanded(
                child: BlocBuilder<FastagCubit, FastagState>(
                  builder: (context, state) {
                    if (state.fastagListUIState.status == Status.LOADING) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.fastagListUIState.status == Status.ERROR) {
                      return const Center(child: Text("Failed to load data"));
                    }

                    if (state.fastagListUIState.data == null ||
                        (state.fastagListUIState.data!.data.isEmpty)) {
                      return const Center(child: Text("No Data"));
                    }

                    final items = state.fastagListUIState.data!.data;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildFastagCard(
                          id: item.id.toString(),
                          vehicleNumber: item.vehicleNo,
                          status: _mapStatus(item.orderStatus),
                          statusColor: _mapStatusColor(item.orderStatus),
                          balance: "₹${item.balance}",
                          lastUpdated: item.createdAt,
                          context: context,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return AppSearchBar(
      searchController: _searchController,
      hintText: context.appText.search,
      onChanged: (val) {
        context.read<FastagCubit>().fetchFastagList(searchTerm: val.trim());
      },
      onClear: () {
        _searchController.clear();
        context.read<FastagCubit>().fetchFastagList();
      },
    ).paddingSymmetric(horizontal: 16.0);
  }

  String _mapStatus(int statusCode) {
    switch (statusCode) {
      case 1:
      // return "Active";
        return "Under Issuance";
      case 2:
        return "Low Balance";
      default:
        return "Under Issuance";
    }
  }

  Color _mapStatusColor(int statusCode) {
    switch (statusCode) {
      case 1:
      // return Colors.green;
        return Colors.grey;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildFastagCard({
    required String id,
    required String vehicleNumber,
    required String status,
    required Color statusColor,
    required String balance,
    required String lastUpdated,
    // required bool showRechargeButton,
    // required bool showRefreshIcon,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: commonContainerDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        shadow: true,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ID
                    Text('ID - $id', style: AppTextStyle.textGreyColor12w400),

                    8.height,
                    // Vehicle Number Row
                    Row(
                      children: [
                        // Vehicle Icon (Red square with white symbol)
                        Image.asset(AppIcons.png.fastagListCardIcon),
                        8.width,
                        // Vehicle Number
                        Text(vehicleNumber, style: AppTextStyle.h4),
                        15.width,
                        // Status Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyle.h6.copyWith(color: statusColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Navigation Arrow
              AppIconButton(
                onPressed: () {
                  Navigator.push(context, commonRoute(FastagDetailScreen()));
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.black,
                ),
                style: AppButtonStyle.circularIconButtonStyle,
              ),
            ],
          ),
          12.height,
          Divider(color: AppColors.greyTextColor, height: 1),
          4.height,

          // Balance Section
          if (status != 'Under Issuance')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Balance', style: AppTextStyle.body3GreyColor),

                Row(
                  children: [
                    Text(
                      balance,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                        status == 'Under Issuance'
                            ? Colors.grey
                            : AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Refresh Icon
                    const Icon(Icons.refresh, size: 16, color: Colors.grey),
                    const Spacer(),
                    // Recharge Button (if applicable)
                    AppButton(
                      buttonHeight: 40,
                      onPressed: () {
                        // Handle recharge
                        Navigator.push(
                          context,
                          commonRoute(FastagRechargeScreen()),
                        );
                      },
                      title: 'Recharge',
                      style: AppButtonStyle.primary,
                    ).expand(),
                  ],
                ),
                2.height,
                // Last Updated
                Text(
                  'Last Updated $lastUpdated',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

          if (status == 'Under Issuance')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requested On: ${formatDateTimeKavach(lastUpdated)}',
                  style: AppTextStyle.body,
                ),
                10.height,
                AppButton(
                  style: AppButtonStyle.outline,
                  onPressed: () {
                    commonSupportDialog(context);
                  },
                  title: 'Contact Support',
                ),
              ],
            ),
        ],
      ),
    );
  }
}
