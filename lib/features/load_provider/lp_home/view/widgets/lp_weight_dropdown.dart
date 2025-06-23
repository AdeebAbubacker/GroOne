import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/weight_selection_screen.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/app_route.dart';

class LPWeightDropdown extends StatelessWidget {
  final String preFixIcon;
  final String hintText;
  final Function(LoadWeightData) onSelect;
  final List<LoadWeightData> dataList;
  final String? selectedText;
  final VoidCallback onTab;
  final LPHomeCubit cubit;

  const LPWeightDropdown({
    super.key,
    required this.preFixIcon,
    required this.hintText,
    required this.onSelect,
    required this.dataList,
    this.selectedText,
    required this.onTab,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LPHomeCubit, LPHomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
          height: 55,
          padding: const EdgeInsets.all(10),
          decoration: commonContainerDecoration(
            color: AppColors.lightPrimaryColor2,
            borderColor: AppColors.borderColor,
          ),
          child: InkWell(
            onTap: onTab,
            child: Row(
              children: [
                SvgPicture.asset(
                  preFixIcon,
                  width: 20,
                  colorFilter: AppColors.svg(AppColors.primaryIconColor),
                ),
                10.width,
                Text(
                  cubit.state.selectedWeight != null ? "${cubit.state.selectedWeight?.value} MT" : hintText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.body3.copyWith(color: AppColors.black),
                ).expand(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.greyIconColor,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
