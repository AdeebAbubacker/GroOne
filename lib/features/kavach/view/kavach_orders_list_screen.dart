import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_upload_document_screen.dart';
import 'package:gro_one_app/features/kavach/model/kavach_order_list_model.dart';
import 'package:gro_one_app/features/kavach/view/kavach_choose_your_preference_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_order_card_widget.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/chat_action_button.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import '../../profile/view/support_screen.dart';
import '../../profile/view/widgets/add_new_support_ticket.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_state.dart';
import '../repository/kavach_repository.dart';
import 'kavach_transaction_screen.dart';

class KavachOrdersListScreen extends StatefulWidget {
  int? status;

  KavachOrdersListScreen({super.key, this.status});

  @override
  State<KavachOrdersListScreen> createState() => _KavachOrdersListScreenState();
}

class _KavachOrdersListScreenState extends State<KavachOrdersListScreen>
    with TickerProviderStateMixin {
  KavachOrderListBloc _ordersBloc = locator<KavachOrderListBloc>();
  TabController? _tabController;
  final tabScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  List<KavachOrderListOrderItem> allOrders = [];
  bool initialBuild = true;
  int page = 1;
  int totalPage = 1;
  int selectedTab = 0;
  Map<int, List<KavachOrderListOrderItem>> tabOrders = {};
  int? previousIndex;
  bool orderHasPlaced = false;
  bool listLoaded = false;
  List<String> tabLabels = [
    "All",
    "Order placed",
    "Dispatched",
    "Delivered",
    "Installed",
  ];
  PageController? _pageController;
  String statusParam = '';
  Map<int, ScrollController> tabControllers = {};
  String customerId = '';
  final PageStorageBucket _bucket = PageStorageBucket();

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
      _ordersBloc.add(
        FetchKavachOrderList(status: null, isRefresh: true, page: page),
      );
    });
  }

  void _loadMoreOrders(int tabIndex) {
    if (page == totalPage) return;
    page += 1;
    final status = _getStatusForIndex(tabIndex)?.toString();
    _ordersBloc.add(
      FetchKavachOrderList(status: status, isRefresh: true, page: page),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  // void _onScroll() {
  //   final currentState = context.read<KavachOrderListBloc>().state;
  //   if (!_scrollController.hasClients ||
  //       (currentState is KavachOrderListLoaded &&
  //           page == currentState.totalPage!)) {
  //     return;
  //   }
  //
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     context.read<KavachOrderListBloc>().add(ResetKavachOrderList());
  //     page += 1;
  //     context.read<KavachOrderListBloc>().add(FetchKavachOrderList(page: page));
  //   }
  //   // });
  // }

  bool get _isLoading {
    final state = context.read<KavachOrderListBloc>().state;
    return state is KavachOrderListLoading; // or use a flag in your state
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KavachOrderListBloc, KavachOrderListState>(
      listener: (c, state) {
        if (state is KavachOrderListLoaded) {
          totalPage = int.parse(
            state.totalPage != null && state.totalPage!.toString().isNotEmpty
                ? state.totalPage.toString()
                : '0',
          );
          initialBuild = false;
          allOrders.addAll(state.orders);
          tabOrders[selectedTab]!.addAll(state.orders);
          if (!listLoaded) {
            listLoaded = true;
            orderHasPlaced = allOrders.isNotEmpty;
          }
          setState(() {});
        } else if (state is KavachOrderListError) {
          initialBuild = false;
        }
      },
      builder: (context, state) {
        if (state is KavachOrderListLoading && allOrders.isEmpty) {
          return Scaffold(
            appBar: CommonAppBar(
              centreTile: false,
              title: context.appText.fuelSecurityDevice,
              actions: [
                AppIconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(commonRoute(KavachChooseYourPreferenceScreen()))
                        .then((v) {
                          tabOrders.updateAll((key, value) => []);
                          setState(() {
                            selectedTab = 0;
                          });
                          statusParam =
                              _getStatusForIndex(selectedTab).toString();
                          context.read<KavachOrderListBloc>().add(
                            FetchKavachOrderList(
                              forceRefresh: true,
                              isRefresh: true,
                              page: page,
                              status: statusParam,
                            ),
                          );
                          _scrollTabToCenter(0);
                        });
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                ),
                AppIconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      commonRoute(
                        LpSupport(
                          showBackButton: true,
                          ticketTag: TicketTags.TANK_LOCK,
                        ),
                        isForward: true,
                      ),
                    );
                  },
                  icon: AppIcons.svg.filledSupport,
                  iconColor: AppColors.primaryButtonColor,
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  icon: Image.asset(AppIcons.png.moreVertical),
                  offset: Offset(20, 50),
                  onSelected: (value) {
                    if (value == context.appText.transactions) {
                      Navigator.push(
                        context,
                        commonRoute(KavachTransactionsScreen()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: context.appText.transactions,
                        child: Text(
                          context.appText.transactions,
                          style: AppTextStyle.h6,
                        ),
                      ),
                    ];
                  },
                ),
                5.width,
              ],
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is KavachOrderListLoaded &&
            ((state.kycStatusUpdated == null) ||
                (state.kycStatusUpdated != null && !state.kycStatusUpdated!) ||
                (state.kycStatusUpdated! && !orderHasPlaced))) {
          return Scaffold(
            appBar: CommonAppBar(
              title: context.appText.fuelSecurityDevice,
              centreTile: false,
            ),
            body: kavachBenifitsWidget(context),
            bottomNavigationBar: buildGetYourTankLockButtonWidget(
              state,
              context,
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.blackishWhite,
            appBar: CommonAppBar(
              //elevation: 1.0,
              title: context.appText.fuelSecurityDevice,
              centreTile: false,
              actions: [
                AppIconButton(
                  onPressed: () async {
                    final res = await Navigator.of(
                      context,
                    ).push(commonRoute(KavachChooseYourPreferenceScreen()));
                    if (!mounted) return;
                    tabOrders.updateAll((key, value) => []);
                    setState(() {
                      selectedTab = 0;
                      page = 1;
                    });
                    debugPrint('fsdfsjhjhdg');
                    statusParam = _getStatusForIndex(selectedTab).toString();
                    context.read<KavachOrderListBloc>().add(
                      FetchKavachOrderList(
                        status: widget.status.toString(),
                        forceRefresh: true,
                        isRefresh: true,
                        page: page,
                      ),
                    );
                    _scrollTabToCenter(0);
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                ),
                AppIconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      commonRoute(
                        LpSupport(
                          showBackButton: true,
                          ticketTag: TicketTags.TANK_LOCK,
                        ),
                        isForward: true,
                      ),
                    );
                  },
                  icon: AppIcons.svg.filledSupport,
                  iconColor: AppColors.primaryButtonColor,
                ),
                PopupMenuButton<String>(
                  color: Colors.white,
                  icon: Image.asset(AppIcons.png.moreVertical),
                  offset: Offset(20, 50),
                  onSelected: (value) {
                    if (value == context.appText.transactions) {
                      Navigator.push(
                        context,
                        commonRoute(KavachTransactionsScreen()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: context.appText.transactions,
                        child: Text(
                          context.appText.transactions,
                          style: AppTextStyle.h6,
                        ),
                      ),
                    ];
                  },
                ),
                5.width,
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
                            if (selectedTab != index) {
                              tabOrders[selectedTab]?.clear();
                              if (previousIndex != null) {
                                tabOrders[previousIndex]?.clear();
                                tabOrders[selectedTab] = [];
                              }
                              setState(() {
                                selectedTab = index;
                                page = 1;
                              });
                              _pageController?.jumpToPage(index);
                              statusParam =
                                  _getStatusForIndex(selectedTab).toString();
                              _scrollTabToCenter(index);
                            }
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
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                15.height,
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) async {
                      tabOrders[selectedTab]?.clear();
                      if (previousIndex != null) {
                        tabOrders[previousIndex]?.clear();
                        tabOrders[selectedTab] = [];
                      }
                      setState(() {
                        selectedTab = index;
                        page = 1;
                      });
                      statusParam = _getStatusForIndex(selectedTab).toString();
                      _ordersBloc.add(
                        FetchKavachOrderList(
                          status: statusParam,
                          isRefresh: true,
                          page: page,
                        ),
                      );
                      _scrollTabToCenter(index);
                    },
                    itemCount: tabLabels.length,
                    itemBuilder: (context, tabIndex) {
                      final orders = tabOrders[selectedTab] ?? [];
                      return state is KavachOrderListLoading
                          ? Center(child: CircularProgressIndicator())
                          : orders.isEmpty
                          ? Center(
                            child: Text(
                              context.appText.noOrdersFound,
                              style: AppTextStyle.h5,
                            ),
                          )
                          : PageStorage(
                            bucket: _bucket,
                            child: ListView.builder(
                              key: PageStorageKey('orders-tab-$tabIndex'),
                              controller: tabControllers[tabIndex],
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                final order = orders[index];
                                previousIndex = index;
                                return KavachOrderCardWidget(order: order);
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
      },
    );
  }

  void _scrollTabToCenter(int index) {
    final tabWidth = 100.0; // approximate width of one tab
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = (tabWidth * index) - (screenWidth / 2 - tabWidth / 2);
    if (!tabScrollController.hasClients) return;
    tabScrollController.animateTo(
      offset.clamp(0.0, tabScrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  navigateToNextScreen(KavachOrderListLoaded state, BuildContext context) {
    if (state.kycStatusUpdated == false) {
      Navigator.push(
        context,
        commonRoute(GpsUploadDocumentScreen(fromKavachScreen: true)),
      ).then((v) {
        if (!mounted) return;
        tabOrders.updateAll((key, value) => []);
        setState(() {
          selectedTab = 0;
        });
        statusParam = _getStatusForIndex(selectedTab).toString();
        context.read<KavachOrderListBloc>().add(
          FetchKavachOrderList(
            status: selectedTab.toString(),
            forceRefresh: true,
            isRefresh: true,
            page: page,
          ),
        );
        _scrollTabToCenter(0);
      });
    } else {
      Navigator.of(
        context,
      ).push(commonRoute(KavachChooseYourPreferenceScreen())).then((v) {
        tabOrders.updateAll((key, value) => []);
        setState(() {
          selectedTab = 0;
        });
        debugPrint('fsdfsjhjhdg');
        statusParam = _getStatusForIndex(selectedTab).toString();
        context.read<KavachOrderListBloc>().add(
          FetchKavachOrderList(
            status: widget.status.toString(),
            forceRefresh: true,
            isRefresh: true,
            page: page,
          ),
        );
        _scrollTabToCenter(0);
      });
    }
  }

  Widget kavachBenifitsWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildKavachProductImageWidget(),
          6.height,
          buildKavachBenefitsDetailsWidget(context),
          // Removed as per change request
          // buildGroBannerImageWidget(),
        ],
      ),
    );
  }

  Widget buildGetYourTankLockButtonWidget(
    KavachOrderListLoaded state,
    BuildContext context,
  ) {
    return AppButton(
      title: context.appText.getYourTankLockNow,
      onPressed: () {
        navigateToNextScreen(state, context);
      },
    ).bottomNavigationPadding();
  }

  Widget buildKavachProductImageWidget() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.24,
      color: AppColors.lightPrimaryColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background truck image
          Image.asset(
            AppImage.png.newTruck,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Kavach product overlay positioned responsively
          Positioned(
            top: screenHeight * 0.15,
            right: screenWidth * 0.05,
            child: Image.asset(
              AppImage.png.kavachNewProduct,
              width: screenWidth * 0.17,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildKavachBenefitsDetailsWidget(BuildContext context) {
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
        Text(context.appText.benefitsOfKavach, style: AppTextStyle.h4),
        20.height,
        benefitItem(
          context.appText.kavachBenefit1Title,
          context.appText.kavachBenefit1Desc,
        ),
        benefitItem(
          context.appText.kavachBenefit2Title,
          context.appText.kavachBenefit2Desc,
        ),
        benefitItem(
          context.appText.kavachBenefit3Title,
          context.appText.kavachBenefit3Desc,
        ),
        benefitItem(
          context.appText.kavachBenefit4Title,
          context.appText.kavachBenefit4Desc,
        ),
        benefitItem(
          context.appText.kavachBenefit5Title,
          context.appText.kavachBenefit5Desc,
        ),
        benefitItem(
          context.appText.kavachBenefit6Title,
          context.appText.kavachBenefit6Desc,
        ),
        benefitItem(
          context.appText.kavachBenefit7Title,
          context.appText.kavachBenefit7Desc,
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }

  Widget buildGroBannerImageWidget() {
    return Image.asset(AppImage.png.groBanner);
  }
}

// class _OrdersListView extends StatefulWidget {
//   final int? status;
//
//   const _OrdersListView({this.status});
//
//   @override
//   State<_OrdersListView> createState() => _OrdersListViewState();
// }
//
// class _OrdersListViewState extends State<_OrdersListView> {
//   final ScrollController _scrollController = ScrollController();
//   Timer? _debounce;
//   List<KavachOrderListOrderItem> allOrders = [];
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<KavachOrderListBloc>().add(
//       FetchKavachOrderList(status: widget.status, forceRefresh: true),
//     );
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (_debounce?.isActive ?? false) return;
//     _debounce = Timer(const Duration(milliseconds: 200), () {
//       final currentState = context.read<KavachOrderListBloc>().state;
//       if (_isBottom &&
//           !_isLoading &&
//           currentState is KavachOrderListLoaded &&
//           !currentState.hasReachedMax) {
//         context.read<KavachOrderListBloc>().add(FetchKavachOrderList());
//       }
//     });
//   }
//

//
//
//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
