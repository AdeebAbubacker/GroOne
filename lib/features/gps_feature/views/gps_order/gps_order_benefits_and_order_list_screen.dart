import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_kyc_check_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_order_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_order_list_models.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_models_screen.dart';
import 'package:gro_one_app/features/kavach/helper/kavach_helper.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/widgets/app_error_widget.dart';
import 'package:gro_one_app/utils/widgets/app_loading_widget.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/constant_variables.dart';
import '../../../kavach/view/kavach_transaction_screen.dart';
import '../../../profile/view/support_screen.dart';
import '../../../profile/view/widgets/add_new_support_ticket.dart';
import 'gps_order_detail_screen.dart';
import 'gps_upload_document_screen.dart';

class GpsOrderBenefitsAndOrderListScreen extends StatefulWidget {
  const GpsOrderBenefitsAndOrderListScreen({super.key});

  @override
  State<GpsOrderBenefitsAndOrderListScreen> createState() =>
      _GpsOrderBenefitsAndOrderListScreenState();
}

class _GpsOrderBenefitsAndOrderListScreenState
    extends State<GpsOrderBenefitsAndOrderListScreen>
    with TickerProviderStateMixin {
  final GlobalKey menuKey = GlobalKey();
  String customerId = '';
  final PageStorageBucket _bucket = PageStorageBucket();
  Map<int, List<GpsOrderItem>> tabOrders = {};
  Map<int, ScrollController> tabControllers = {};
  int selectedTab = 0;
  int totalPage = 1;
  int page = 1;
  String? statusParam;
  final tabScrollController = ScrollController();
  GpsOrderListCubit? gpsOrderListCubit;
  PageController? _pageController;
  List<String> tabLabels = [
    "All",
    "Order placed",
    "Dispatched",
    "Delivered",
    "Installed",
  ];
  int? previousIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedTab);
    for (int i = 0; i < tabLabels.length; i++) {
      tabOrders[i] = [];
      tabControllers[i] = ScrollController();
      tabControllers[i]!.addListener(() {
        final controller = tabControllers[i]!;
        if (controller.position.pixels >= controller.position.maxScrollExtent) {
          _loadMoreOrders(i);
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gpsOrderListCubit = context.read<GpsOrderListCubit>();
      gpsOrderListCubit?.resetCubit();
    });
    _getCustomerId();
  }

  void _scrollTabToCenter(int index) {
    final tabWidth = 100.0; // approximate width of one tab
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = (tabWidth * index) - (screenWidth / 2 - tabWidth / 2);
    tabScrollController.animateTo(
      offset.clamp(0.0, tabScrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _loadMoreOrders(int tabIndex) {
    if (page >= totalPage) return;
    page += 1;

    final status = _getStatusForIndex(tabIndex)?.toString();
    gpsOrderListCubit?.getOrderList(
      customerId: customerId,
      page: page,
      statusParam: status,
    );
  }

  // void _onScroll() async {
  //   if (!scrollController.hasClients || (page == totalPage)) {
  //     return;
  //   }
  //
  //   // Simple bottom detection like your example
  //   // Simple pagination trigger - exactly like your working example
  //   if (scrollController.position.pixels ==
  //       scrollController.position.maxScrollExtent) {
  //     if (customerId.isNotEmpty) {
  //       Future.microtask(() {
  //         if (mounted) {
  //           page += 1;
  //           if (!context.mounted) return;
  //           gpsOrderListCubit = context.read<GpsOrderListCubit>();
  //           if (gpsOrderListCubit != null) {
  //             // final initialStatus = _getStatusForIndex(_tabController!.index);
  //             // debugPrint('initialStatus=>$initialStatus');
  //             gpsOrderListCubit?.getOrderList(
  //               customerId: customerId,
  //               page: page,
  //               // statusParam: initialStatus.toString(),
  //             );
  //           }
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _pageController!.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset any existing cubit state when screen is navigated to
  }

  @override
  void didUpdateWidget(GpsOrderBenefitsAndOrderListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Force refresh KYC check when widget is updated
    if (customerId != null) {
      // This will be handled by the BlocProvider.value in build method
    }
  }

  Future<void> _getCustomerId() async {
    final userRepository = locator<UserInformationRepository>();
    final id = await userRepository.getUserID();
    setState(() {
      customerId = id ?? '';
    });
  }

  void _handleBackNavigation() {
    // Make navigation synchronous to avoid issues with onLeadingTap
    try {
      _navigateBackSynchronously();
    } catch (e) {
      // Fallback: try to pop or navigate to default route
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        context.go(AppRouteName.lpBottomNavigationBar);
      }
    }
  }

  void _navigateBackSynchronously() {
    // Try multiple navigation approaches
    try {
      // First, try to pop
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return;
      }

      // If we can't pop, try to navigate to the appropriate dashboard
      _getUserRoleAndNavigate();
    } catch (e) {
      // Final fallback: try to go to default route
      try {
        if (context.mounted) {
          context.go(AppRouteName.lpBottomNavigationBar);
        }
      } catch (fallbackError) {
        // Handle fallback error silently
      }
    }
  }

  Future<void> _getUserRoleAndNavigate() async {
    try {
      final userRepository = locator<UserInformationRepository>();
      final userRole = await userRepository.getUserRole();
      String targetRoute;
      if (userRole == 1 || userRole == 3) {
        targetRoute = AppRouteName.lpBottomNavigationBar;
      } else if (userRole == 2) {
        targetRoute = AppRouteName.vpBottomNavigationBar;
      } else {
        targetRoute = AppRouteName.lpBottomNavigationBar;
      }
      if (!mounted) return;
      if (context.mounted) {
        context.go(targetRoute);
      }
    } catch (e) {
      // Fallback to default navigation
      if (context.mounted) {
        context.go(AppRouteName.lpBottomNavigationBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // disables default pop, same as returning false in onWillPop
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Use the same navigation logic as the back button
          _navigateBackSynchronously();
        }
      },
      child: BlocProvider(
        create:
            (_) =>
                GpsKycCheckCubit(locator<GpsOrderApiRepository>())
                  ..resetCubit(),
        child: BlocConsumer<GpsKycCheckCubit, GpsKycCheckState>(
          listenWhen:
              (previous, current) =>
                  previous.kycCheckState != current.kycCheckState,
          listener: (context, state) {
            // Check if widget is still mounted
            if (!context.mounted) return;
          },
          builder: (context, state) {
            // Initialize KYC check on first build if not already started
            if (state.kycCheckState == null) {
              Future.microtask(() {
                if (mounted) {
                  if (customerId.isNotEmpty) {
                    if (!context.mounted) return;
                    context.read<GpsKycCheckCubit>().checkKycDocuments(
                      customerId,
                    );
                  }
                }
              });
            }

            // Show loading while checking KYC
            if (state.kycCheckState?.status == Status.LOADING) {
              return Scaffold(
                backgroundColor: AppColors.blackishWhite,
                appBar: CommonAppBar(
                  title: Text(context.appText.gps, style: AppTextStyle.appBar),
                  centreTile: false,
                  isLeading: true,
                  onLeadingTap: _handleBackNavigation,
                ),
                body: const Center(child: AppLoadingWidget()),
              );
            }

            // Show error state for KYC check
            if (state.kycCheckState?.status == Status.ERROR) {
              return Scaffold(
                backgroundColor: AppColors.blackishWhite,
                appBar: CommonAppBar(
                  title: Text(context.appText.gps, style: AppTextStyle.appBar),
                  centreTile: false,
                  isLeading: true,
                  onLeadingTap: _handleBackNavigation,
                ),
                body: Center(
                  child: AppErrorWidget(
                    error: GenericError(),
                    onRetry: () {
                      if (customerId.isNotEmpty) {
                        context.read<GpsKycCheckCubit>().checkKycDocuments(
                          customerId,
                        );
                      }
                    },
                  ),
                ),
              );
            }
            // debugPrint('sfsdfsdfdfg${state.hasKycDocuments}');
            // debugPrint('sfsdfsdfdfg${state.kycData}');
            // // Scenario 1: KYC not done or no documents - Show benefits screen
            if (state.kycCheckState?.status == Status.SUCCESS &&
                (state.hasKycDocuments == false || state.kycData == null)) {
              return _buildBenefitsScreen(
                context,
                navigateToUploadDocument:
                    state.kycData != null &&
                    state.kycData!['documents'] != null &&
                    state.kycData!['documents']['panDocLink'] == null,
              );
            }

            // Scenario 2 & 3: KYC done and has documents - Check order list
            if (state.kycCheckState?.status == Status.SUCCESS &&
                state.hasKycDocuments == true &&
                state.kycData != null) {
              return _buildOrderListScreen(context);
            }

            // Show loading while waiting for KYC check
            return Scaffold(
              backgroundColor: AppColors.blackishWhite,
              appBar: CommonAppBar(
                title: Text(context.appText.gps, style: AppTextStyle.appBar),
                centreTile: false,
                isLeading: true,
                onLeadingTap: _handleBackNavigation,
              ),
              body: const Center(child: AppLoadingWidget()),
            );
          },
        ),
      ),
    );
  }

  // Build benefits screen with GPS title and support icon only
  Widget _buildBenefitsScreen(
    BuildContext context, {
    bool navigateToUploadDocument = false,
  }) {
    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        title: Text(context.appText.gps, style: AppTextStyle.appBar),
        centreTile: false,
        isLeading: true,
        onLeadingTap: _handleBackNavigation,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.of(context).push(
                commonRoute(
                  LpSupport(showBackButton: true, ticketTag: TicketTags.GPS),
                  isForward: true,
                ),
              );
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
        ],
      ),
      body: gpsBenifitsWidget(
        context,
        navigateToUploadDocument: navigateToUploadDocument,
      ),
    );
  }

  // Build order list screen with dynamic title based on content
  Widget _buildOrderListScreen(BuildContext context) {
    return BlocConsumer<GpsOrderListCubit, GpsOrderListState>(
      listener: (context, state) {
        if (state is GpsOrderListError) {
          // Handle error if needed
        } else if (state is GpsOrderListLoaded) {
          totalPage = state.orderList.data.meta.totalPages;
          tabOrders[selectedTab]?.addAll(state.orderList.data.rows);
          setState(() {});
        }
      },
      builder: (context, state) {
        // Initialize order list on first build
        if (state is GpsOrderListInitial) {
          Future.microtask(() {
            if (mounted) {
              if (!context.mounted) return;
              context.read<GpsOrderListCubit>().getOrderList(
                customerId: customerId,
              );
            }
          });
        }

        // Show loading while fetching orders
        if (state is GpsOrderListLoading) {
          return Scaffold(
            backgroundColor: AppColors.blackishWhite,
            appBar: CommonAppBar(
              title: Text(context.appText.gpsModel, style: AppTextStyle.appBar),
              centreTile: false,
              isLeading: true,
              onLeadingTap: _handleBackNavigation,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Show error state
        if (state is GpsOrderListError) {
          return Scaffold(
            backgroundColor: AppColors.blackishWhite,
            appBar: CommonAppBar(
              title: Text(context.appText.gpsModel, style: AppTextStyle.appBar),
              centreTile: false,
              isLeading: true,
              onLeadingTap: _handleBackNavigation,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.appText.failedToLoadOrders,
                    style: AppTextStyle.h5,
                  ),
                  Text(state.message, style: AppTextStyle.body3),
                  20.height,
                  AppButton(
                    title: context.appText.retry,
                    onPressed: () {
                      if (customerId.isNotEmpty) {
                        context.read<GpsOrderListCubit>().getOrderList(
                          customerId: customerId,
                        );
                      }
                    },
                    style: AppButtonStyle.primary,
                  ).paddingSymmetric(horizontal: 40),
                ],
              ),
            ),
          );
        }

        // Show orders list or benefits based on order count
        if (state is GpsOrderListLoaded) {
          if (tabOrders.isEmpty) {
            debugPrint('cscsdsds');
            // Scenario 2: KYC done but no orders - show benefits screen with GPS title
            return Scaffold(
              backgroundColor: AppColors.blackishWhite,
              appBar: CommonAppBar(
                title: Text(context.appText.gps, style: AppTextStyle.appBar),
                centreTile: false,
                isLeading: true,
                onLeadingTap: _handleBackNavigation,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        commonRoute(
                          LpSupport(
                            showBackButton: true,
                            ticketTag: TicketTags.GPS,
                          ),
                          isForward: true,
                        ),
                      );
                    },
                    icon: AppIcons.svg.filledSupport,
                    iconColor: AppColors.primaryButtonColor,
                  ),
                  4.width,
                ],
              ),
              body: gpsBenifitsWidget(context, navigateToUploadDocument: false),
            );
          } else {
            // Scenario 3: KYC done and has orders - show order list with GPS Model title
            return Scaffold(
              backgroundColor: AppColors.blackishWhite,
              appBar: CommonAppBar(
                title: Text(
                  context.appText.gpsModel,
                  style: AppTextStyle.appBar,
                ),
                centreTile: false,
                isLeading: true,
                onLeadingTap: _handleBackNavigation,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(commonRoute(GpsModelsScreen()));
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                  ),
                  4.width,
                  AppIconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        commonRoute(
                          LpSupport(
                            showBackButton: true,
                            ticketTag: TicketTags.GPS,
                          ),
                          isForward: true,
                        ),
                      );
                    },
                    icon: AppIcons.svg.filledSupport,
                    iconColor: AppColors.primaryButtonColor,
                  ),
                  4.width,
                  AppIconButton(
                    key: menuKey,
                    onPressed: () async {
                      final RenderBox button =
                          menuKey.currentContext!.findRenderObject()
                              as RenderBox;
                      final RenderBox overlay =
                          Overlay.of(context).context.findRenderObject()
                              as RenderBox;
                      final Offset position = button.localToGlobal(
                        Offset.zero,
                        ancestor: overlay,
                      );

                      final selected = await showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          position.dx - 100,
                          position.dy,
                          position.dx,
                          overlay.size.height - position.dy,
                        ),
                        items: [
                          PopupMenuItem(
                            value: 'transaction',
                            child: Row(
                              children: [
                                Icon(Icons.receipt_long, color: Colors.black),
                                SizedBox(width: 10),
                                Text(context.appText.transaction),
                              ],
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.white,
                      );

                      if (selected == 'transaction') {
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    KavachTransactionsScreen(fleetProductId: 1),
                          ),
                        );
                      }
                    },
                    icon: Icons.more_vert,
                    iconColor: AppColors.primaryButtonColor,
                  ),
                  4.width,
                ],
              ),
              body: Column(
                children: [
                  // Tab Bar
                  SingleChildScrollView(
                    // key: PageStorageKey('myListView_$tabIndex'),
                    controller: tabScrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tabLabels.length, (index) {
                        final isSelected = selectedTab == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = index;
                                page = 1;
                              });
                              tabOrders[selectedTab]?.clear();
                              statusParam =
                                  _getStatusForIndex(selectedTab)?.toString();
                              gpsOrderListCubit?.getOrderList(
                                customerId: customerId,
                                page: 1,
                                statusParam: statusParam,
                              );
                              _pageController?.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: commonContainerDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.greyContainerBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tabLabels[index],
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) async {
                        tabOrders[selectedTab]?.clear();
                        tabOrders[previousIndex!] = [];
                        if (previousIndex != null) {
                          tabOrders[previousIndex]?.clear();
                          tabOrders[selectedTab] = [];
                        }
                        setState(() {
                          selectedTab = index;
                          page = 1;
                        });
                        statusParam =
                            _getStatusForIndex(selectedTab).toString();
                        gpsOrderListCubit?.getOrderList(
                          customerId: customerId,
                          page: 1,
                          statusParam:
                              statusParam.toString() == 'null'
                                  ? ''
                                  : statusParam,
                        );
                      },
                      itemCount: tabLabels.length,
                      itemBuilder: (context, tabIndex) {
                        final orders = tabOrders[tabIndex] ?? [];
                        debugPrint('orders=>$orders');
                        return orders.isEmpty
                            ? Center(
                              child: Text(
                                context.appText.noOrdersFound,
                                style: AppTextStyle.h5,
                              ),
                            )
                            : PageStorage(
                              bucket: _bucket,
                              child: ListView.separated(
                                key: PageStorageKey<String>(
                                  'myListView_$tabIndex',
                                ),
                                controller: tabControllers[tabIndex],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                itemCount: orders.length,
                                separatorBuilder: (_, __) => 8.height,
                                itemBuilder: (context, index) {
                                  debugPrint('sdsfdfsdgs${orders.length}');
                                  final order = orders[index];
                                  previousIndex = index;
                                  final statusColor = AppColors.greenColor;

                                  return Container(
                                    decoration: commonContainerDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      shadow: true,
                                      borderColor: AppColors.borderColor,
                                    ),
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${context.appText.orderId}: ${order.orderUniqueId}',
                                              style: AppTextStyle.h4PrimaryColor
                                                  .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                  ),
                                            ).expand(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration:
                                                  commonContainerDecoration(
                                                    color: statusColor
                                                        .withValues(
                                                          alpha: 0.09,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                              child: Text(
                                                order.currentStatus,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        6.height,
                                        Row(
                                          children: [
                                            Text(
                                              order.productNames,
                                              style:
                                                  AppTextStyle
                                                      .textGreyColor14w300,
                                            ).expand(),
                                            Text(
                                              '₹${KavachHelper.formatCurrency(order.totalPrice.toStringAsFixed(0))}',
                                              style: AppTextStyle.h4,
                                            ),
                                          ],
                                        ),
                                        8.height,
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  commonRoute(
                                                    GpsOrderDetailScreen(
                                                      order: order,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                context.appText.viewDetails,
                                                style:
                                                    AppTextStyle
                                                        .primaryColor16w400,
                                              ),
                                            ),
                                            Text(
                                              '${context.appText.purchasedOn} ${order.orderDate}',
                                              style:
                                                  AppTextStyle
                                                      .textGreyColor14w300,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
              floatingActionButton: ChatActionButton(),
            );
          }
        }

        // Default loading state
        return Scaffold(
          backgroundColor: AppColors.blackishWhite,
          appBar: CommonAppBar(
            title: Text(context.appText.gpsModel, style: AppTextStyle.appBar),
            centreTile: false,
            isLeading: true,
            onLeadingTap: _handleBackNavigation,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  int? _getTabIndexFromStatusParam(String? statusParam) {
    switch (statusParam) {
      case '0':
        return 0; // all
      case '5':
        return 1; // orderPlaced
      case '7':
        return 2; // dispatched
      case '8':
        return 3; // delivered
      case '10':
        return 4; // installed
      default:
        return null;
    }
  }

  int? _getStatusForIndex(int index) {
    switch (index) {
      case 0:
        return null; // all
      case 1:
        return 5; // orderPlaced
      case 2:
        return 7; // dispatched
      case 3:
        return 8; // delivered
      case 4:
        return 10; // installed
      default:
        return null;
    }
  }

  // --- Benefits Section (unchanged) ---
  Widget gpsBenifitsWidget(
    BuildContext context, {
    bool navigateToUploadDocument = false,
  }) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildGpsProductImageWidget(context),
                20.height,
                buildGpsBenefitsDetailsWidget(context),
                // Removed as per change request
                // buildGroBannerImageWidget(),
              ],
            ),
          ),
        ),
        // Fixed bottom button
        AppButton(
          title: context.appText.buyNewGps,
          onPressed: () {
            if (navigateToUploadDocument) {
              // Scenario 1: KYC not done - navigate to upload document
              Navigator.push(
                context,
                commonRoute(GpsUploadDocumentScreen()),
              ).then((v) {
                if (!context.mounted) return;
                Future.microtask(() {
                  if (mounted) {
                    if (customerId != null) {
                      if (!context.mounted) return;
                      context.read<GpsKycCheckCubit>().checkKycDocuments(
                        customerId!,
                      );
                    }
                  }
                });
              });
            } else {
              // Scenario 2: KYC done but no orders - navigate to GPS model screen
              Navigator.push(context, commonRoute(GpsModelsScreen()));
            }
          },
        ).paddingOnly(bottom: 30, left: 15, right: 15, top: 10),
      ],
    );
  }

  Widget buildGpsProductImageWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.18,
      color: AppColors.lightPrimaryColor,
      child: Image.asset(
        AppImage.png.gpsBenefitTruck,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildGpsBenefitsDetailsWidget(BuildContext context) {
    Widget benefitItem(String title, String subtitle) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyle.h5),
            5.height,
            Text(
              subtitle,
              style: AppTextStyle.body3.copyWith(
                color: AppColors.textGreyColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.gpsBenefitsHeading, style: AppTextStyle.h4),
        20.height,
        benefitItem(
          context.appText.realTimeTrackingTitle,
          context.appText.realTimeTrackingDesc,
        ),
        benefitItem(
          context.appText.fleetSafetyTitle,
          context.appText.fleetSafetyDesc,
        ),
        benefitItem(
          context.appText.geofencingTitle,
          context.appText.geofencingDesc,
        ),
        benefitItem(
          context.appText.driverBehaviourTitle,
          context.appText.driverBehaviourDesc,
        ),
        benefitItem(
          context.appText.tripReportsTitle,
          context.appText.tripReportsDesc,
        ),
        benefitItem(
          context.appText.maintenanceTitle,
          context.appText.maintenanceDesc,
        ),
        benefitItem(
          context.appText.fasterAllocationTitle,
          context.appText.fasterAllocationDesc,
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }

  Widget buildGroBannerImageWidget() {
    return Image.asset(
      AppImage.png.groBanner,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

// Separate widget for order list with tabs to avoid full screen refresh
// class GpsOrderListWithTabs extends StatefulWidget {
//   final List<GpsOrderItem> orders;
//
//   const GpsOrderListWithTabs({super.key, required this.orders});
//
//   @override
//   State<GpsOrderListWithTabs> createState() => _GpsOrderListWithTabsState();
// }
//
// class _GpsOrderListWithTabsState extends State<GpsOrderListWithTabs> {
//   int selectedTab = 0;
//   int listCount = 7;
//   final ScrollController scrollController = ScrollController();
//   String customerId = '';
//   int page = 1;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     scrollController.addListener(_onScroll);
//     _getCustomerId();
//   }
//
//   Future<void> _getCustomerId() async {
//     final userRepository = locator<UserInformationRepository>();
//     final id = await userRepository.getUserID() ?? '';
//     setState(() {
//       customerId = id;
//     });
//   }
//
//   void _onScroll() async {
//     if (!scrollController.hasClients) return;
//
//     // Simple bottom detection like your example
//
//     // Simple pagination trigger - exactly like your working example
//     if (scrollController.position.pixels ==
//         scrollController.position.maxScrollExtent) {
//       if (customerId.isNotEmpty) {
//         Future.microtask(() {
//           if (mounted) {
//             page += 1;
//             if (!context.mounted) return;
//             context.read<GpsOrderListCubit>().getOrderList(
//               customerId: customerId,
//               page: page,
//             );
//           }
//         });
//         await Future.delayed(Duration(seconds: 10));
//         setState(() {
//           listCount = 35;
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final tabLabels = [
//       context.appText.all,
//       context.appText.orderPlaced,
//       context.appText.dispatched,
//       context.appText.delivered,
//       context.appText.installed,
//     ];
//
//     final statusKeys = [
//       "ALL", // pseudo key
//       "Order Placed",
//       "Dispatched",
//       "Delivered",
//       "Installed",
//     ];
//
//     // Filter orders based on selected tab
//     List<GpsOrderItem> filteredOrders =
//         selectedTab == 0
//             ? widget.orders
//             : widget.orders
//                 .where(
//                   (order) => order.currentStatus == statusKeys[selectedTab],
//                 )
//                 .toList();
//
//     return Column(
//       children: [
//         // Tab Bar
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(tabLabels.length, (index) {
//               final isSelected = selectedTab == index;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 12,
//                 ),
//                 child: GestureDetector(
//                   onTap: () => setState(() => selectedTab = index),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 18,
//                       vertical: 8,
//                     ),
//                     decoration: commonContainerDecoration(
//                       color:
//                           isSelected
//                               ? AppColors.primaryColor
//                               : AppColors.greyContainerBg,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       tabLabels[index],
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//         Expanded(
//           child:
//               filteredOrders.isEmpty
//                   ? Center(
//                     child: Text(
//                       context.appText.noOrdersFound,
//                       style: AppTextStyle.h5,
//                     ),
//                   )
//                   : ListView.separated(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 10,
//                       horizontal: 10,
//                     ),
//                     controller: scrollController,
//                     itemCount: filteredOrders.length,
//                     separatorBuilder: (_, __) => 8.height,
//                     itemBuilder: (context, index) {
//                       final order = filteredOrders[index];
//                       final statusColor = AppColors.greenColor;
//
//                       return Container(
//                         decoration: commonContainerDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           shadow: true,
//                           borderColor: AppColors.borderColor,
//                         ),
//                         padding: const EdgeInsets.all(14),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   '${context.appText.orderId}: ${order.orderUniqueId}',
//                                   style: AppTextStyle.h4PrimaryColor.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 15,
//                                   ),
//                                 ).expand(),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 8,
//                                     vertical: 4,
//                                   ),
//                                   decoration: commonContainerDecoration(
//                                     color: statusColor.withValues(alpha: 0.09),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: Text(
//                                     order.currentStatus,
//                                     style: TextStyle(
//                                       color: statusColor,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             6.height,
//                             Row(
//                               children: [
//                                 Text(
//                                   order.productNames,
//                                   style: AppTextStyle.textGreyColor14w300,
//                                 ).expand(),
//                                 Text(
//                                   '₹${KavachHelper.formatCurrency(order.totalPrice.toStringAsFixed(0))}',
//                                   style: AppTextStyle.h4,
//                                 ),
//                               ],
//                             ),
//                             8.height,
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 4,
//                               crossAxisAlignment: WrapCrossAlignment.center,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.of(context).push(
//                                       commonRoute(
//                                         GpsOrderDetailScreen(order: order),
//                                       ),
//                                     );
//                                   },
//                                   child: Text(
//                                     context.appText.viewDetails,
//                                     style: AppTextStyle.primaryColor16w400,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${context.appText.purchasedOn} ${order.orderDate}',
//                                   style: AppTextStyle.textGreyColor14w300,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//         ),
//       ],
//     );
//   }
// }
