import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../model/truck_pref_lane_model.dart';

class PreferLanesWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String)? onChanged;
  final List<Item> preferLanes;
  final ScrollController controller;


  final Function({int? masterLanesId, bool? value,Item? item}) selectLanes;
  const PreferLanesWidget({
    super.key,
    required this.searchController,
    this.onChanged,
    required this.preferLanes,
    required this.controller,
    required this.selectLanes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: searchController,
          labelText: context.appText.preferredLanes,
          hintText: context.appText.searchedLanes,
          onChanged: (p0) {
            onChanged!(p0);
            },
        ),
        8.height,
        ListView.builder(
          controller: controller,
          itemCount: preferLanes.length,
          itemBuilder: (context, index) {
            final locationItem = preferLanes[index];
            return CheckboxListTile(
              title: Text(
                '${locationItem.fromLocation?.name ?? ""} - ${locationItem.toLocation?.name ?? ""}',
              ),
              value: locationItem.isSelected,
              onChanged: (bool? value) {
                selectLanes(
                  masterLanesId: locationItem.masterLaneId,
                  value: value,
                  item: locationItem
                );
              },
            );
          },
        ).expand(),
      ],
    ).paddingAll(15);
  }
}
