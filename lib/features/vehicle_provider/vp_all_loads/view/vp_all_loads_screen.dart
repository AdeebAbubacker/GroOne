import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_available_load_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_all_loads/view/widgets/vp_all_load_my_load_widget.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../dependency_injection/locator.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_search_bar.dart';
import '../../../../utils/constant_variables.dart';
import '../../../load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import '../../../load_provider/lp_home/model/profile_detail_response_model.dart';
import '../bloc/vp_all_loads_bloc.dart';
import '../bloc/vp_all_loads_event.dart';
import '../bloc/vp_all_loads_state.dart';

class VpAllLoadsScreen extends StatefulWidget {
  const VpAllLoadsScreen({super.key});

  @override
  State<VpAllLoadsScreen> createState() => _VpAllLoadsScreenState();
}

class _VpAllLoadsScreenState extends State<VpAllLoadsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

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
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadDataByTab(_tabController.index);
      }
    });
    _loadDataByTab(0); // load initial tab
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

  void _loadDataByTab(int index) {
    final type = index + 1;
    final search = searchController.text;
    vpLoadBloc.add(FetchVpLoads(type: type, search: search));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            10.height,
            TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: const BoxDecoration(),
              // remove default indicator
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: List.generate(4, (index) {
                final tabLabels = [
                  'Available Loads',
                  'My Loads',
                  'Confirmed',
                  'Assigned',
                ];
                final isSelected = _tabController.index == index;
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : const Color(0xFFEFEFEF),
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
            buildSearchBarAndFilterWidget(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(4, (index) => buildTab()),
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
            return const Center(child: Text("No loads found."));
          }
          return ListView.builder(
            padding: EdgeInsets.all(commonSafeAreaPadding),
            shrinkWrap: true,
            itemCount: state.loads.length,
            itemBuilder: (context, index) {
              if (_tabController.index == 0) {
                return VpAllLoadAvailableLoadWidget(
                  data: state.loads[index],
                  isKycDone: false,
                ).paddingSymmetric(vertical: 7);
              } else if (_tabController.index == 1) {
                return VpAllLoadMyLoadWidget(
                  data: state.loads[index],
                  onClickAssignDriver: () {},
                ).paddingSymmetric(vertical: 7);
              } else{
                return null;
              }
            },
          );
        } else if (state is VpLoadError) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
