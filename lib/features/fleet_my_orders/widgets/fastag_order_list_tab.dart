import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/fastag/cubit/fasttag_order_list_tab_cubit.dart';
import 'package:gro_one_app/features/fastag/cubit/fasttag_order_list_tab_state.dart';
import 'package:gro_one_app/features/fastag/model/fastag_list_response.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../data/ui_state/status.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/common_widgets.dart';
import '../../fastag/views/fastag_recharge_screen.dart';

class FastagOrderListTabWidget extends StatefulWidget {
  const FastagOrderListTabWidget({super.key});

  @override
  State<FastagOrderListTabWidget> createState() =>
      _FastagOrderListTabWidgetState();
}

class _FastagOrderListTabWidgetState extends State<FastagOrderListTabWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final PageStorageBucket _bucket = PageStorageBucket();
  String _searchText = "";
  int page = 1;
  int totalPage = 1;
  List<FastagItem> itemsFiltered = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim().toLowerCase());
    });


    scrollController.addListener(_onScroll);

    // Trigger fetch once
    context.read<FastagOrderListTabCubit>().fetchFastagList(
      isInitialLoad: true,
      page: 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe to RouteObserver

    if (ModalRoute.of(context)?.isCurrent == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      });
    }
  }

  void didPopNext() {
    // Reset scroll when coming back to this screen
    _resetScroll();
  }

  void _resetScroll() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(0);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0);
        }
      });
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients || (totalPage == itemsFiltered.length)) {
      return;
    }

    // Simple bottom detection like your example

    // Simple pagination trigger - exactly like your working example
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page += 1;
      context.read<FastagOrderListTabCubit>().fetchFastagList(
        isInitialLoad: true,
        page: page,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: BlocConsumer<FastagOrderListTabCubit, FastagOrderListTabState>(
            listener: (c, s) {
              if (s.fastagListUIState.data != null) {
                totalPage =
                    s.fastagListUIState.data != null
                        ? s.fastagListUIState.data!.totalCount
                        : 0;
                if (s.fastagListUIState.data!.data.isEmpty) {
                  // stopPagination = true;
                } else {
                  itemsFiltered.addAll(
                    s.fastagListUIState.data!.data.where((f) {
                      return f.vehicleNo.toLowerCase().contains(_searchText) ||
                          f.id.toString().contains(_searchText);
                    }).toList(),
                  );
                  debugPrint('itemsFiltered=>${itemsFiltered.length}');
                  debugPrint('totalPage=>${totalPage}');
                }
              }
            },
            builder: (context, state) {
              if (state.fastagListUIState.status == Status.LOADING) {
                return const Center(child: CircularProgressIndicator());
              }
              if (itemsFiltered.isEmpty &&
                  state.fastagListUIState.status == Status.ERROR) {
                return Center(child: Text(context.appText.noOrdersFound));
              }

              // items = state.fastagListUIState.data?.data ?? [];
              if (itemsFiltered.isEmpty) {
                return Center(child: Text(context.appText.noOrdersFound));
              }

              return PageStorage(
                bucket: _bucket,
                child: ListView.builder(
                  key: const PageStorageKey<String>('myListView'),
                  padding: const EdgeInsets.all(16),
                  itemCount: itemsFiltered.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    final item = itemsFiltered[index];
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        onChanged: (v) {
          itemsFiltered.clear();
          context.read<FastagOrderListTabCubit>().fetchFastagList(
            searchTerm: _searchController.text,
            isInitialLoad: true,
            page: 1,
          );
        },
        decoration: InputDecoration(
          hintText: context.appText.search,
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchText.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      itemsFiltered.clear();
                      _searchController.clear();
                      context.read<FastagOrderListTabCubit>().fetchFastagList(
                        searchTerm: _searchController.text,
                        isInitialLoad: true,
                        page: 1,
                      );
                    },
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  String _mapStatus(int statusCode) {
    switch (statusCode) {
      case 1:
        // return "Active";
        return context.appText.underIssuance;
      case 2:
        return context.appText.lowBalance;
      default:
        return context.appText.underIssuance;
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
                            color: statusColor.withValues(alpha: 0.1),
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
            ],
          ),
          12.height,
          Divider(color: AppColors.greyTextColor, height: 1),
          4.height,

          // Balance Section
          if (status != context.appText.underIssuance)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.appText.currentBalance} ',
                  style: AppTextStyle.body3GreyColor,
                ),

                Row(
                  children: [
                    Text(
                      balance,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            status == context.appText.underIssuance
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
                      title: context.appText.recharge,
                      style: AppButtonStyle.primary,
                    ).expand(),
                  ],
                ),
                2.height,
                // Last Updated
                Text(
                  '${context.appText.lastUpdated} $lastUpdated',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

          if (status == context.appText.underIssuance)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.appText.requestedOn}: ${formatDateTimeKavach(lastUpdated)}',
                  style: AppTextStyle.body,
                ),
                10.height,
                AppButton(
                  style: AppButtonStyle.outline,
                  onPressed: () {
                    commonSupportDialog(context);
                  },
                  title: context.appText.contactSupport,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
