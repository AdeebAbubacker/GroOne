import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_order_card_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
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
import 'kavach_models_screen.dart';

class KavachOrdersListScreen extends StatefulWidget {
  const KavachOrdersListScreen({super.key});

  @override
  State<KavachOrdersListScreen> createState() => _KavachOrdersListScreenState();
}
class _KavachOrdersListScreenState extends State<KavachOrdersListScreen> with TickerProviderStateMixin {
  final _ordersBloc = locator<KavachOrderListBloc>();
  final _scrollController = ScrollController();
  bool _firstBuild = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {}); // Safe setState
    });
    _ordersBloc.add(FetchKavachOrderList());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_firstBuild) {
      _firstBuild = false;
      _ordersBloc.add(FetchKavachOrderList(isRefresh: true));
    }
  }

  void _onScroll() {
    if (_isBottom) {
      _ordersBloc.add(FetchKavachOrderList());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _ordersBloc,
      child: BlocBuilder<KavachOrderListBloc, KavachOrderListState>(
        builder: (context, state) {
          if (state is KavachOrderListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KavachOrderListLoaded && state.orders.isEmpty) {
            return Scaffold(
              appBar: CommonAppBar(title: context.appText.kavach,
                actions: [
                AppIconButton(
                  onPressed: () => Navigator.of(context).push(commonRoute(KavachModelsScreen())),
                  icon: Icon(Icons.add, color: Colors.white),
                  style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                ),
                AppIconButton(
                  onPressed: () {},
                  icon: AppIcons.svg.support,
                  style: AppButtonStyle.circularIconButtonStyle,
                ),
                10.width,
              ],),
              body: kavachBenifitsWidget(context),
            );
          } else {
            return Scaffold(
              appBar: CommonAppBar(
                title: context.appText.kavach,
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: const BoxDecoration(), // remove default indicator
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                  tabs: List.generate(5, (index) {
                    final tabLabels = ['All', 'Order Placed', 'Dispatched', 'Delivered', 'Installed'];
                    final isSelected = _tabController.index == index;
                    return Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryColor : const Color(0xFFEFEFEF),
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
                    );
                  }),
                ),
                actions: [
                  AppIconButton(
                    onPressed: () => Navigator.of(context).push(commonRoute(KavachModelsScreen())),
                    icon: Icon(Icons.add, color: Colors.white),
                    style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                  ),
                  AppIconButton(
                    onPressed: () {},
                    icon: AppIcons.svg.support,
                    style: AppButtonStyle.circularIconButtonStyle,
                  ),
                  10.width,
                ],
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildTab(status: null),
                  _buildTab(status: 4),
                  _buildTab(status: 7),
                  _buildTab(status: 8),
                  _buildTab(status: 10),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget kavachBenifitsWidget(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildKavachProductImageWidget(),
        buildKavachBenefitsDetailsWidget(context),
        buildGroBannerImageWidget()
      ],
    );
  }
  Widget buildKavachProductImageWidget(){
    return Container(
      width: double.infinity,
      height: 200,
      color: AppColors.lightPrimaryColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppImage.png.truck, width: 150),
          Image.asset(AppImage.png.kavachProduct, width: 70).paddingOnly(top: 80, right: 140),
        ],
      ),
    );
  }
  Widget buildKavachBenefitsDetailsWidget(BuildContext context){
    Widget innerUIWidget({required String icon,required String title, required String subTitle}){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            decoration: commonContainerDecoration(
                color: AppColors.lightPrimaryColor,
                borderRadius: BorderRadius.circular(100),
                borderColor: AppColors.primaryColor
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
              Text(subTitle, style: AppTextStyle.body3)
            ],
          ).expand()
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.benefitsOfKavach, style: AppTextStyle.body1),
        20.height,
        innerUIWidget(icon: AppIcons.png.lockAndKey, title: context.appText.benefitsOfKavachHeading1, subTitle: context.appText.benefitsOfKavachSubHeading1),
        20.height,
        innerUIWidget(icon: AppIcons.png.insightGraph, title: context.appText.benefitsOfKavachHeading1, subTitle: context.appText.benefitsOfKavachSubHeading1),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }
  Widget buildGroBannerImageWidget(){
    return Image.asset(AppImage.png.groBanner);
  }
  Widget _buildTab({int? status}) {
    return BlocProvider(
      create: (_) => KavachOrderListBloc(locator<KavachRepository>())
        ..add(FetchKavachOrderList(status: status)),
      child: _OrdersListView(),
    );
  }
}
class _OrdersListView extends StatefulWidget {
  @override
  State<_OrdersListView> createState() => _OrdersListViewState();
}
class _OrdersListViewState extends State<_OrdersListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<KavachOrderListBloc>();
      bloc.add(FetchKavachOrderList());
    }
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
            return Center(child: Text('No orders found'));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.orders.length
                : state.orders.length + 1,
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
