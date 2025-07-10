import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../utils/app_search_bar.dart';

// Static vehicle data
class GpsVehicle {
  final String vehicleNumber;
  final String? truckMakeAndModel;
  final String? truckType;
  final String? truckSubType;
  final int vehicleStatus; // 1 for active, 0 for inactive

  GpsVehicle({
    required this.vehicleNumber,
    this.truckMakeAndModel,
    this.truckType,
    this.truckSubType,
    this.vehicleStatus = 1,
  });
}

class GpsVehicleSelectionScreen extends StatefulWidget {
  const GpsVehicleSelectionScreen({super.key});

  @override
  State<GpsVehicleSelectionScreen> createState() => _GpsVehicleSelectionScreenState();
}

class _GpsVehicleSelectionScreenState extends State<GpsVehicleSelectionScreen> {
  final searchController = TextEditingController();
  List<GpsVehicle> filteredVehicles = [];

  // Static vehicle data
  final List<GpsVehicle> allVehicles = [
    GpsVehicle(
      vehicleNumber: 'TN01AB1234',
      truckMakeAndModel: 'Tata 407',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 1,
    ),
    GpsVehicle(
      vehicleNumber: 'TN02CD5678',
      truckMakeAndModel: 'Ashok Leyland Dost',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 1,
    ),
    GpsVehicle(
      vehicleNumber: 'TN03EF9012',
      truckMakeAndModel: 'Mahindra Bolero Pickup',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 1,
    ),
    GpsVehicle(
      vehicleNumber: 'TN04GH3456',
      truckMakeAndModel: 'Tata Ace',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 0, // Inactive
    ),
    GpsVehicle(
      vehicleNumber: 'TN05IJ7890',
      truckMakeAndModel: 'Force Traveller',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 1,
    ),
    GpsVehicle(
      vehicleNumber: 'TN06KL1234',
      truckMakeAndModel: 'Mahindra Supro',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 1,
    ),
    GpsVehicle(
      vehicleNumber: 'TN07MN5678',
      truckMakeAndModel: 'Tata 709',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 1,
    ),
    GpsVehicle(
      vehicleNumber: 'TN08OP9012',
      truckMakeAndModel: 'Ashok Leyland Partner',
      truckType: 'Mini Truck',
      truckSubType: 'Pickup',
      vehicleStatus: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredVehicles = allVehicles;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterVehicles(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        filteredVehicles = allVehicles;
      } else {
        filteredVehicles = allVehicles.where((vehicle) {
          return vehicle.vehicleNumber.toLowerCase().contains(searchText.toLowerCase()) ||
                 (vehicle.truckMakeAndModel?.toLowerCase().contains(searchText.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  Widget vehicleCard(GpsVehicle vehicle) {
    return InkWell(
      onTap: () {
        if (vehicle.vehicleStatus == 1) {
          Navigator.pop(context, vehicle.vehicleNumber);
        } else {
          ToastMessages.alert(message: 'Vehicle is currently inactive');
        }
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
                        vehicle.vehicleNumber,
                        style: AppTextStyle.h4.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      6.width,
                      if (vehicle.vehicleStatus == 1)
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 18,
                        ),
                    ],
                  ),
                  if (vehicle.truckMakeAndModel != null)
                    Text(
                      vehicle.truckMakeAndModel!,
                      style: AppTextStyle.bodyBlackColorW500,
                    ),
                  if (vehicle.truckType != null)
                    Text(
                      '${vehicle.truckType} - ${vehicle.truckSubType ?? ''}',
                      style: AppTextStyle.textGreyColor12w400,
                    ),
                ],
              ),
            ),
            if (vehicle.vehicleStatus == 1)
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
            Text(
              context.appText.selectVehicleRegNum,
              style: AppTextStyle.appBar.copyWith(
                color: AppColors.primaryTextColor,
              ),
            ),
            10.height,
            AppSearchBar(
              searchController: searchController,
              onChanged: _filterVehicles,
            ),
            Expanded(
              child: filteredVehicles.isEmpty
                  ? Center(
                      child: Text(context.appText.noVehiclesFound),
                    )
                  : ListView.separated(
                      itemCount: filteredVehicles.length,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      separatorBuilder: (_, __) => 12.height,
                      itemBuilder: (_, index) {
                        final vehicle = filteredVehicles[index];
                        return vehicleCard(vehicle);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 