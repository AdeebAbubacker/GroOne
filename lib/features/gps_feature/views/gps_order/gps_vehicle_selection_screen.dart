import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_search_bar.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/constant_variables.dart';

class GpsVehicleSelectionScreen extends StatefulWidget {
  final String? currentlySelectedVehicle;
  
  const GpsVehicleSelectionScreen({
    super.key,
    this.currentlySelectedVehicle,
  });

  @override
  State<GpsVehicleSelectionScreen> createState() => _GpsVehicleSelectionScreenState();
}

class _GpsVehicleSelectionScreenState extends State<GpsVehicleSelectionScreen> {
  final searchController = TextEditingController();
  String? selectedVehicle;
  
  // Static list of vehicles for GPS orders
  final List<String> availableVehicles = [
    'MH12AB1234',
    'MH12CD5678',
    'MH12EF9012',
    'MH12GH3456',
    'MH12IJ7890',
    'MH12KL1234',
    'MH12MN5678',
    'MH12OP9012',
    'MH12QR3456',
    'MH12ST7890',
    'MH12UV1234',
    'MH12WX5678',
    'MH12YZ9012',
    'MH12AB3456',
    'MH12CD7890',
  ];

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.currentlySelectedVehicle;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget vehicleCard(String vehicleNumber) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, vehicleNumber);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightBlueIconBackgroundColor2,
              child: SvgPicture.asset(
                AppIcons.svg.truck,
                colorFilter: AppColors.svg(AppColors.primaryColor),
              ),
            ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vehicleNumber,
                        style: AppTextStyle.h4.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      6.width,
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 18,
                      ),
                    ],
                  ),
                  Text(
                    'Tata 407',
                    style: AppTextStyle.bodyBlackColorW500,
                  ),
                  Text(
                    'Mini Truck - Pickup',
                    style: AppTextStyle.textGreyColor12w400,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F8ED),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                context.appText.active,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            10.height,
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.appText.selectVehicleRegNum,
                    style: AppTextStyle.appBar.copyWith(
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
            AppSearchBar(
              searchController: searchController,
              onChanged: (text) {
                setState(() {});
              },
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final searchText = searchController.text.toLowerCase();

                  // Filter the list based on search text
                  final filteredVehicles = availableVehicles.where((vehicle) {
                    return vehicle.toLowerCase().contains(searchText);
                  }).toList();

                  if (filteredVehicles.isEmpty) {
                    return Center(
                      child: Text(context.appText.noVehiclesFound),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredVehicles.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    separatorBuilder: (_, __) => 12.height,
                    itemBuilder: (_, index) {
                      final vehicle = filteredVehicles[index];
                      return vehicleCard(vehicle);
                    },
                  );
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: commonSafeAreaPadding),
      ),
    );
  }
} 