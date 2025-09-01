import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class PreferLensScreen extends StatefulWidget {
  const PreferLensScreen({super.key});

  @override
  State<PreferLensScreen> createState() => _PreferLensScreenState();
}

class _PreferLensScreenState extends State<PreferLensScreen> {

  final searchController=TextEditingController();
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final ScrollController scrollController = ScrollController();
  final Set<int> selectedIds={};

  void _fetchMoreLens(){
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200){
        vpCreationCubit.fetchPrefLane(null);
      }
    },);
  }

  @override
  void initState() {
    _fetchMoreLens();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title:context.appText.preferredLanes),
      body: Column(
        children: [
          AppTextField(
            controller: searchController,
            labelText: context.appText.preferredLanes,
            hintText: context.appText.searchedLanes,
            onChanged: (p0) {
              vpCreationCubit.fetchPrefLane(p0,isInit: true);
            },
          ),
          8.height,
          BlocConsumer<VpCreateAccountCubit,VpCreateAccountState>(
            listener: (context, state) {},
            builder: (context, state) {
              List<Item> preferLanes=  state.prefLaneUIState?.data?.data?.items??[];

              return ListView.builder(
                controller: scrollController,
                itemCount: preferLanes.length,
                itemBuilder: (context, index) {
                final locationItem=preferLanes[index];
                return CheckboxListTile(
                  title: Text( '${locationItem.fromLocation?.name ?? ""} - ${locationItem.toLocation?.name ?? ""}'),
                  value: locationItem.isSelected, onChanged: (bool? value) {
                    vpCreationCubit.selectLanes(
                        id:locationItem.masterLaneId ,
                        selected: value);
                    },
                ) ;
              },).expand();
            }
          )
        ],
      ).paddingAll(15),
    );
  }
}
