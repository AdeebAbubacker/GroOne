import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/available_loads/cubit/load_filter_state.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/view/widgets/prefer_lanes_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class PreferLanesFilter extends StatefulWidget {
  const PreferLanesFilter({super.key});

  @override
  State<PreferLanesFilter> createState() => _PreferLanesFilterState();
}

class _PreferLanesFilterState extends State<PreferLanesFilter> {
  final searchController = TextEditingController();
  final loadFilterCubit = locator<LoadFilterCubit>();
  final ScrollController scrollController = ScrollController();


  void _fetchMoreLens() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
       await _loadPreferLens(isInit: false, query: searchController.text);
      }
    });
  }

  Future<void> _loadPreferLens({required bool isInit, String? query}) async {
   await loadFilterCubit.getPreferLens(isInit: isInit, query: query);
  }

  @override
  void initState() {
    _fetchMoreLens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.preferredLanes),
      body: BlocBuilder<LoadFilterCubit, LoadFilterState>(
        builder: (context, state) {
          List<Item> preferLanes =
              state.truckTypeLaneUIState?.data?.data?.items ?? [];
          return PreferLanesWidget(
            controller: scrollController,
            preferLanes: preferLanes,
            searchController: searchController,
            onChanged: (p0) {
              _loadPreferLens(isInit: true, query: p0);
            },
           selectLanes: ({item, masterLanesId, value}) {
             loadFilterCubit. selectPreferLanes(item);

           },
          );
        },
      ),
    );
  }
}
