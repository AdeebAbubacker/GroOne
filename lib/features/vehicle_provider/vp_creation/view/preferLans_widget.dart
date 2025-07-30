import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_pref_lane_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Preferred Lanes"),
      body: Column(
        children: [
          AppTextField(
            controller: searchController,
            labelText: "Preferred Lanes",
            hintText: "Search lanes",
            onChanged: (p0) {
              vpCreationCubit.fetchPrefLane(p0);
            },
          ),
          8.height,
          BlocBuilder<VpCreateAccountCubit,VpCreateAccountState>(
            builder: (context, state) {
              List<Item> preferLanes=  state.prefLaneUIState?.data?.data?.items??[];

              return ListView.builder(
                itemCount: preferLanes.length,
                itemBuilder: (context, index) {
                final locationItem=preferLanes[index];
                return CheckboxListTile(
                  title: Text( '${locationItem.fromLocation?.name ?? ""} - ${locationItem.toLocation?.name ?? ""}'),
                  value: locationItem.isSelected, onChanged: (bool? value) {
                    vpCreationCubit.selectLanes(index,selected: value);
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
