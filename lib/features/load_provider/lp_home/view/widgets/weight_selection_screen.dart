import 'package:flutter/material.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';


class WeightSelectionScreen extends StatefulWidget {
  final List<LoadWeightData> dataList;
  final Function(LoadWeightData) onSelect;
  final LPHomeCubit cubit;

  const WeightSelectionScreen({
    super.key,
    required this.dataList,
    required this.onSelect,
    required this.cubit,
  });

  @override
  State<WeightSelectionScreen> createState() => _WeightSelectionScreenState();
}

class _WeightSelectionScreenState extends State<WeightSelectionScreen> {

  // for getting the selected ID
  int? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.cubit.state.selectedWeight?.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Weight", style: AppTextStyle.body1)),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.dataList.length,
              itemBuilder: (context, index) {
                final weight = widget.dataList[index];

                final isSelected = selectedId == weight.id;
                return InkWell(
                  onTap: () {
                    setState(() {
                      print('id ${weight.id}');
                      selectedId = weight.id;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimaryColor2,
                      border: Border.all(
                        color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "${weight.value} MT",
                        style: AppTextStyle.body3.copyWith(
                          color:
                              isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      bottomNavigationBar: buildSubmitButton(),
    );
  }

  Widget buildSubmitButton(){
    return AppButton(
      title: "Select",
      onPressed: selectedId != null ? () {
        final selectedWeight = widget.dataList.firstWhere((w) => w.id == selectedId);
        widget.cubit.selectWeight(selectedWeight);
        widget.onSelect(selectedWeight);
        Navigator.pop(context);
      } : (){},
    ).bottomNavigationPadding();
  }

}
