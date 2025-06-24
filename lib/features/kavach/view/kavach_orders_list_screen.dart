import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/view/kavach_choose_your_preference_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_order_card_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
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
import '../bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_state.dart';
import '../repository/kavach_repository.dart';

class KavachOrdersListScreen extends StatefulWidget {
  const KavachOrdersListScreen({super.key});

  @override
  State<KavachOrdersListScreen> createState() => _KavachOrdersListScreenState();
}

class _KavachOrdersListScreenState extends State<KavachOrdersListScreen>
    with TickerProviderStateMixin {
  final _ordersBloc = locator<KavachOrderListBloc>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _ordersBloc.add(FetchKavachOrderList(forceRefresh: true, isRefresh: true));
    _tabController.addListener(() {
      if (mounted) setState(() {}); // Safe setState
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KavachOrderListBloc, KavachOrderListState>(
      builder: (context, state) {
        if (state is KavachOrderListLoading) {
          return Scaffold(
            appBar: CommonAppBar(
              centreTile: false,
              title: context.appText.tankLock,
              actions: [
                AppIconButton(
                  onPressed: () {},
                  icon: AppIcons.svg.filledSupport,
                  iconColor: AppColors.primaryButtonColor,
                ),
                4.width,
              ],
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is KavachOrderListLoaded && state.orders.isEmpty) {
          return Scaffold(
            appBar: CommonAppBar(
              title: context.appText.tankLock,
              centreTile: false,
              actions: [
                AppIconButton(
                  onPressed: () {},
                  icon: AppIcons.svg.filledSupport,
                  iconColor: AppColors.primaryButtonColor,
                ),
                4.width,
              ],
            ),
            body: kavachBenifitsWidget(context),
          );
        } else {
          return Scaffold(
            appBar: CommonAppBar(
              //elevation: 1.0,
              title: context.appText.tankLock,
              centreTile: false,
              actions: [
                AppIconButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(commonRoute(KavachChooseYourPreferenceScreen()));
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                ),
                AppIconButton(
                  onPressed: () {},
                  icon: AppIcons.svg.filledSupport,
                  iconColor: AppColors.primaryButtonColor,
                ),
                4.width,
              ],
            ),
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  indicator: const BoxDecoration(),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  tabs: List.generate(5, (index) {
                    final tabLabels = [
                      'All',
                      'Order Placed',
                      'Dispatched',
                      'Delivered',
                      'Installed',
                    ];
                    final isSelected = _tabController.index == index;
                    return Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primaryColor
                                  : const Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          tabLabels[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                15.height,
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTab(status: null),
                      _buildTab(status: 4),
                      _buildTab(status: 7),
                      _buildTab(status: 8),
                      _buildTab(status: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget kavachBenifitsWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildKavachProductImageWidget(),
        6.height,
        buildKavachBenefitsDetailsWidget(context),
        buildGroBannerImageWidget(),

        AppButton(
          title: context.appText.getYourTankLockNow,
          onPressed: () {
            Navigator.of(
              context,
            ).push(commonRoute(KavachChooseYourPreferenceScreen()));
          },
        ).paddingOnly(left: 10.0, right: 10.0, bottom: 8.0),
      ],
    );
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
    Widget innerUIWidget({
      required String icon,
      required String title,
      required String subTitle,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            decoration: commonContainerDecoration(
              color: AppColors.lightPrimaryColor,
              borderRadius: BorderRadius.circular(100),
              borderColor: AppColors.primaryColor,
            ),
            child: Image.asset(icon, width: 25).paddingAll(15),
          ),
          15.width,

          // Heading or SubHeading
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.h5),
              5.height,
              Text(subTitle, style: AppTextStyle.body3),
            ],
          ).expand(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.benefitsofTankLock, style: AppTextStyle.body1),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.lockAndKey,
          title: context.appText.benefitsOfKavachHeading1,
          subTitle: context.appText.benefitsOfKavachSubHeading1,
        ),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.insightGraph,
          title: context.appText.benefitsOfKavachHeading1,
          subTitle: context.appText.benefitsOfKavachSubHeading1,
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }

  Widget buildGroBannerImageWidget() {
    return Image.asset(AppImage.png.groBanner);
  }


  Widget _buildTab({int? status}) {
    return BlocProvider(
      create: (_) => KavachOrderListBloc(locator<KavachRepository>())
        ..add(FetchKavachOrderList(status: status, isRefresh: true)),
      child: _OrdersListView(status: status),
    );
  }
}

class _OrdersListView extends StatefulWidget {
  final int? status;
  const _OrdersListView({this.status});

  @override
  State<_OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<_OrdersListView> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<KavachOrderListBloc>().add(
        FetchKavachOrderList(status: widget.status, forceRefresh: true));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) return;
    _debounce = Timer(const Duration(milliseconds: 200), () {
      // if (_isBottom && !_isLoading) {
      //   context.read<KavachOrderListBloc>().add(FetchKavachOrderList());
      // }
      final currentState = context.read<KavachOrderListBloc>().state;
      if (_isBottom &&
          !_isLoading &&
          currentState is KavachOrderListLoaded &&
          !currentState.hasReachedMax) {
        context.read<KavachOrderListBloc>().add(FetchKavachOrderList());
      }

    });
  }

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
  Widget build(BuildContext context) {
    return BlocBuilder<KavachOrderListBloc, KavachOrderListState>(
      builder: (context, state) {
        if (state is KavachOrderListLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is KavachOrderListLoaded) {
          if (state.orders.isEmpty) {
            return Center(
              child: Text('No orders found', style: AppTextStyle.h5),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.orders.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final order = state.orders[index];
              return KavachOrderCardWidget(order: order);
            },
          );
        } else if (state is KavachOrderListError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }
}

///old
// @override
// Widget build(BuildContext context) {
//   return BlocProvider.value(
//     value: _ordersBloc,
//     child: DefaultTabController(
//       length: 5,
//       child: Scaffold(
//               appBar: CommonAppBar(
//         title: context.appText.kavach,
//                 bottom: const TabBar(
//                   isScrollable: true,
//                   tabs: [
//                     Tab(text: 'All'),
//                     Tab(text: 'Order Placed'),
//                     Tab(text: 'Dispatched'),
//                     Tab(text: 'Delivered'),
//                     Tab(text: 'Installed'),
//                   ],
//                 ),
//         actions: [
//           AppIconButton(
//             onPressed: ()=> Navigator.of(context).push(commonRoute(KavachModelsScreen())),
//             icon: Icon(Icons.add, color: Colors.white),
//             style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
//           ),
//           AppIconButton(onPressed: (){}, icon: AppIcons.svg.support,  style: AppButtonStyle.circularIconButtonStyle),
//           10.width,
//         ],
//       ),
//         body:  TabBarView(
//           children: [
//             _buildTab(status: null),    // All
//             _buildTab(status: 4),       // Order Placed
//             _buildTab(status: 7),       // Dispatched
//             _buildTab(status: 8),       // Delivered
//             _buildTab(status: 10),      // Installed
//           ],
//         ),
//       ),
//     ),
//   );
// }

// class _OrdersListView extends StatefulWidget {
//   @override
//   State<_OrdersListView> createState() => _OrdersListViewState();
// }
//
// class _OrdersListViewState extends State<_OrdersListView> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<KavachOrderListBloc, KavachOrderListState>(
//       builder: (context, state) {
//         if (state is KavachOrderListLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is KavachOrderListLoaded) {
//           if (state.orders.isEmpty) {
//             return Center(child: Text('No orders found'));
//           }
//           return ListView.builder(
//             itemCount: state.orders.length,
//             itemBuilder: (context, index) {
//               final order = state.orders[index];
//               return KavachOrderCardWidget(order: order);
//             },
//           );
//         } else if (state is KavachOrderListError) {
//           return Center(child: Text(state.message));
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
