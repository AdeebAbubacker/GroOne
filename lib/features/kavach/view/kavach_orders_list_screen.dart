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
import '../../profile/view/support_screen.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_state.dart';
import '../repository/kavach_repository.dart';
import 'kavach_transaction_screen.dart';

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
              title: context.appText.fuelSecurityDevice,
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
                  onPressed: () {
                    Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true), isForward: true));
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
                      Navigator.push(context, commonRoute(KavachTransactionsScreen()));
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: context.appText.transactions,
                        child: Text(context.appText.transactions,style: AppTextStyle.h6,),
                      ),
                    ];
                  },
                ),
                5.width,
              ],
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is KavachOrderListLoaded && state.orders.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.blackishWhite,
            appBar: CommonAppBar(
              title: context.appText.fuelSecurityDevice,
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
                  onPressed: () {
                    Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true), isForward: true));
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
                      Navigator.push(context, commonRoute(KavachTransactionsScreen()));
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: context.appText.transactions,
                        child: Text(context.appText.transactions,style: AppTextStyle.h6,),
                      ),
                    ];
                  },
                ),
                5.width,
              ],
            ),
            body: kavachBenifitsWidget(context),
            bottomNavigationBar: buildGetYourTankLockButtonWidget(),
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
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(commonRoute(KavachChooseYourPreferenceScreen()));
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                ),
                AppIconButton(
                  onPressed: () {
                    Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true), isForward: true));
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
                      Navigator.push(context, commonRoute(KavachTransactionsScreen()));
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: context.appText.transactions,
                        child: Text(context.appText.transactions,style: AppTextStyle.h6,),
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
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: List.generate(5, (index) {
                      final tabLabels = [
                        context.appText.all,
                        context.appText.orderPlaced,
                        context.appText.dispatched,
                        context.appText.delivered,
                        context.appText.installed,
                      ];
                      final isSelected = _tabController.index == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 12,
                        ),
                        child: GestureDetector(
                          onTap: () => _tabController.animateTo(index),
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
                              borderRadius: BorderRadius.circular(25),
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
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTab(status: null),
                      _buildTab(status: 5),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          buildKavachProductImageWidget(),
          6.height,
          buildKavachBenefitsDetailsWidget(context),
          buildGroBannerImageWidget(),
        ],
      ),
    );
  }
  Widget buildGetYourTankLockButtonWidget() {
    return AppButton(
      title: context.appText.getYourTankLockNow,
      onPressed: () {
        Navigator.of(
          context,
        ).push(commonRoute(KavachChooseYourPreferenceScreen()));
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
            Text(subtitle, style: AppTextStyle.body3.copyWith(color: AppColors.textGreyColor)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.benefitsOfKavach, style: AppTextStyle.h4),
        20.height,
        benefitItem(context.appText.kavachBenefit1Title, context.appText.kavachBenefit1Desc),
        benefitItem(context.appText.kavachBenefit2Title, context.appText.kavachBenefit2Desc),
        benefitItem(context.appText.kavachBenefit3Title, context.appText.kavachBenefit3Desc),
        benefitItem(context.appText.kavachBenefit4Title, context.appText.kavachBenefit4Desc),
        benefitItem(context.appText.kavachBenefit5Title, context.appText.kavachBenefit5Desc),
        benefitItem(context.appText.kavachBenefit6Title, context.appText.kavachBenefit6Desc),
        benefitItem(context.appText.kavachBenefit7Title, context.appText.kavachBenefit7Desc),
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
              child: Text(context.appText.noOrdersFound, style: AppTextStyle.h5),
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
