import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/features/vehicle_provider/vp-helper/vp_helper.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_available_load_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_my_load_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../dependency_injection/locator.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dialog.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_search_bar.dart';
import '../../../../utils/common_dialog_view/success_dialog_view.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/constant_variables.dart';
import '../../../../utils/toast_messages.dart';
import '../../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import '../../../profile/model/profile_detail_model.dart';
import '../../vp_home/bloc/load_accpect/vp_accept_load_bloc.dart';
import '../../vp_home/bloc/load_accpect/vp_accept_load_state.dart';
import '../bloc/vp_all_loads_bloc.dart';
import '../bloc/vp_all_loads_event.dart';
import '../bloc/vp_all_loads_state.dart';

class VpAllLoadsScreen extends StatefulWidget {
  final int initialTabIndex;

  const VpAllLoadsScreen({super.key, this.initialTabIndex = 0});

  @override
  State<VpAllLoadsScreen> createState() => _VpAllLoadsScreenState();
}

class _VpAllLoadsScreenState extends State<VpAllLoadsScreen>
    with TickerProviderStateMixin {

  late TabController _tabController;
  final ScrollController _tabScrollController = ScrollController();


  String profileImage = "";
  final searchController = TextEditingController();
  ProfileDetailModel? profileResponse;
  final lpHomeBloc = locator<LpHomeBloc>();
  late VpLoadBloc vpLoadBloc;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    vpLoadBloc = locator<VpLoadBloc>();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadDataByTab(index: _tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(_tabScrollController.positions.isNotEmpty){
        _tabScrollController.jumpTo(50);
      }
       // or .animateTo(...) for animation
    });
    _loadDataByTab(index: widget.initialTabIndex); // load initial tab
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final type = _tabController.index + 1;
      vpLoadBloc.add(FetchVpLoads(type: type, search: query));
    });
  }


  void _loadDataByTab({required int index,bool forceRefresh = false}) {
    final type = index + 1;
    final search = searchController.text;
    vpLoadBloc.add(FetchVpLoads(type: type, search: search, forceRefresh: forceRefresh));
    setState(() {});
  }

  Future<void> _onPullToRefresh({bool forceRefresh=false}) async{
    final type = _tabController.index+1;
    final search = searchController.text;
    vpLoadBloc.add(FetchVpLoads(type: type, search: search, forceRefresh: forceRefresh));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            20.height,

            // Tab Bar
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: AppColors.lightGreyBackgroundColor),
              padding: EdgeInsets.only(top: 2, bottom: 0, right: 6, left: 6),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                physics: const NeverScrollableScrollPhysics(),
                dividerHeight: 0,
                tabAlignment: TabAlignment.center,
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicator: const BoxDecoration(),
                splashFactory: NoSplash.splashFactory,
                tabs: List.generate(4, (index) {
                  final tabLabels = [
                    context.appText.availableLoads,
                    context.appText.myLoads,
                    context.appText.confirmed,
                    context.appText.assigned,
                  ];
                  final isSelected = _tabController.index == index;
                  return Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: commonContainerDecoration(
                        color: isSelected ? AppColors.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tabLabels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ).paddingSymmetric(horizontal: commonSafeAreaPadding),

            // Filter
            buildSearchBarAndFilterWidget(context),

            // Tab bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  BlocListener<VpAcceptLoadBloc, VpAcceptLoadState>(
                    bloc: locator<VpAcceptLoadBloc>(),
                    listener: (context, state) {
                      if (state is VpAcceptLoadSuccess) {
                        _loadDataByTab(index: 0, forceRefresh: true);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (context.mounted) {
                            AppDialog.show(
                              context,
                              child: SuccessDialogView(
                                message: context.appText.loadAcceptedSuccessfully,
                                afterDismiss: () {
                                  if (context.mounted) Navigator.pop(context);
                                },
                              ),
                            );
                          }
                        });
                      }
                      if (state is VpAcceptLoadError) {
                        ToastMessages.error(
                          message: getErrorMsg(errorType: state.errorType),
                        );
                      }
                    },
                    child: buildTab(),
                  ),
                  buildTab(),
                  buildTab(),
                  buildTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Row(
      children: [
        AppSearchBar(
          searchController: searchController,
          onChanged: _onSearchChanged,
        ).expand(),
        15.width,
        AppIconButton(
          onPressed: () {},
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(AppIcons.svg.filter, width: 20),
        ),
      ],
    ).paddingAll(commonSafeAreaPadding);
  }


  Widget buildTab() {
    return BlocBuilder<VpLoadBloc, VpLoadState>(
      bloc: vpLoadBloc,
      builder: (context, state) {
        if (state is VpLoadLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is VpLoadLoaded) {
          if (state.loads.isEmpty) {
            return VpHelper.withSliverRefresh(
                child: Center(child: Text(context.appText.noLoadsFound)),
                _onPullToRefresh);

          }
          return VpHelper.withRefreshIndicator(
              child: ListView.builder(
                padding: EdgeInsets.all(commonSafeAreaPadding),
                shrinkWrap: true,
                itemCount: state.loads.length,
                itemBuilder: (context, index) {
                  if (_tabController.index == 0) {
                    return VpAllLoadAvailableLoadWidget(
                        data: state.loads[index]
                    ).paddingSymmetric(vertical: 7);
                  } else if (_tabController.index == 1) {
                    return VpAllLoadMyLoadWidget(
                      data: state.loads[index],
                      onClickAssignDriver: () {
                        context.push(AppRouteName.loadDetailsScreen,extra: {
                          "loadId":state.loads[index].id
                        });
                      },
                    ).paddingSymmetric(vertical: 7);
                  } else {
                    return GestureDetector(
                      onTap: () {
                        context.push(AppRouteName.loadDetailsScreen,extra: {
                          "loadId":state.loads[index].id
                        });
                      },
                      child: VpAllLoadMyLoadWidget(
                        data: state.loads[index],
                        showButton: _tabController.index!=3,
                        onClickAssignDriver: () {
                          context.push(AppRouteName.loadDetailsScreen,extra: {
                            "loadId":state.loads[index].id
                          });
                        },
                      ).paddingSymmetric(vertical: 7),
                    );
                  }
                },
              ),
              _onPullToRefresh);


        } else if (state is VpLoadError) {
          return VpHelper.withSliverRefresh(
              _onPullToRefresh,
            child: Center(child: Text(state.message)));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }


}
