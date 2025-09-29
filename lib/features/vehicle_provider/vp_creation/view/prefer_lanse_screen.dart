import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/widgets/prefer_lanes_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'dart:async';
import 'package:gro_one_app/utils/app_application_bar.dart';

class PreferLensScreen extends StatefulWidget {
  const PreferLensScreen({super.key});

  @override
  State<PreferLensScreen> createState() => _PreferLensScreenState();
}

class _PreferLensScreenState extends State<PreferLensScreen> {
  final searchController = TextEditingController();
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final ScrollController scrollController = ScrollController();
  final Set<int> selectedIds = {};
  Timer? _debounce;

  void _fetchMoreLens() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        vpCreationCubit.fetchPrefLane(null);
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      vpCreationCubit.fetchPrefLane(query, isInit: true);
    });
  }

  @override
  void initState() {
    _fetchMoreLens();
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.preferredLanes),
      body: BlocBuilder<VpCreateAccountCubit, VpCreateAccountState>(
        builder: (context, state) {
          List<Item> preferLanes =
              state.prefLaneUIState?.data?.data?.items ?? [];
          return PreferLanesWidget(
            controller: scrollController,
            preferLanes: preferLanes,
            searchController: searchController,
            onChanged: (p0) {
              _onSearchChanged(p0);
            },
            selectLanes: ({item, masterLanesId, value}) {
              vpCreationCubit.selectLanes(id: masterLanesId, selected: value);
            },
          );
        },
      ),
    );
  }
}
