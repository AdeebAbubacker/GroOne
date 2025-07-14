import 'package:flutter/material.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/model/load_details_response_model.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/view/vp_damages_and_shortages_screen.dart';

class AddedDamageWidget extends StatelessWidget {
  final List<DamageReport>? damageReport;
  const AddedDamageWidget({super.key,this.damageReport});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: List.generate(

        damageReport?.length??0, (index) {
        DamageReport? damageReportModel=damageReport?[index];
      return damageRecordCard(
        context: context,
        onEdit: () {

        },
        description: damageReportModel?.description??"",
        imageUrl:  damageReportModel?.image??[],
        itemName: damageReportModel?.itemName??"",
        onDelete: () {

        },
        showDeleteIcon: false,
        quantity: damageReportModel?.quantity.toString()??"",

      );
      },),
    );
  }
}
