import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';

import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_state.dart';
import 'package:gro_one_app/utils/app_colors.dart';


class DriverDamagesListView extends StatefulWidget {
  const DriverDamagesListView({super.key});

  @override
  State<DriverDamagesListView> createState() => _DriverDamagesListViewState();
}

class _DriverDamagesListViewState extends State<DriverDamagesListView> {
  late DriverLoadDetailsCubit cubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit = BlocProvider.of<DriverLoadDetailsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverLoadDetailsCubit, DriverLoadDetailsState>(
      builder: (context, state) {
        final damageList = state.damageListUIState?.data?.data!.data;

        if (state.uploadDamageUIState == true && damageList != null && damageList.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Damage Images",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: damageList.length,
                itemBuilder: (context, index) {
                  final item = damageList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.chevronGreyColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: item.image?.first ?? '',
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.description ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                               
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox(); // Empty if isUpdateDamage is false or no data
      },
    );
  }
}
