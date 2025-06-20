// import 'package:flutter/material.dart';
// import 'package:gro_one_app/utils/app_bottom_sheet_body.dart';
// import 'package:gro_one_app/utils/extensions/int_extensions.dart';
//
// import '../../../utils/app_text_field.dart';
// import 'kavach_add_vehicle_bottom_sheet.dart';
//
// class KavachAddedVehiclesScreen extends StatefulWidget {
//   const KavachAddedVehiclesScreen({super.key});
//
//   @override
//   State<KavachAddedVehiclesScreen> createState() =>
//       _KavachAddedVehiclesScreenState();
// }
//
// class _KavachAddedVehiclesScreenState
//     extends State<KavachAddedVehiclesScreen> {
//   final searchController = TextEditingController();
//   List<VehicleModel> vehicleList = []; // Replace with API data
//
//   @override
//   void initState() {
//     super.initState();
//     // Dummy data
//     vehicleList = List.generate(
//       4,
//           (index) => VehicleModel(
//         truckNumber: "TN02 UY4356",
//         truckName: "Ashok Leyland - Boss 1920",
//         description: "Closed Truck - 22Ft SLX",
//         isActive: true,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBottomSheetBody(
//       title: "Added Vehicles",
//       actions: [
//         TextButton.icon(
//           onPressed: () {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               builder: (_) => const KavachAddVehicleBottomSheet(),
//             );
//           },
//           icon: const Icon(Icons.add, size: 18),
//           label: const Text("Add Vehicle"),
//         )
//       ],
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             AppTextField(
//               controller: searchController,
//               hintText: "Search",
//               prefixIcon: const Icon(Icons.search),
//               onChanged: (value) {
//                 setState(() {
//                   // filter logic here
//                 });
//               },
//             ),
//             16.height,
//             Expanded(
//               child: ListView.separated(
//                 itemCount: vehicleList.length,
//                 separatorBuilder: (_, __) => 12.height,
//                 itemBuilder: (_, index) {
//                   final vehicle = vehicleList[index];
//                   return _VehicleCard(vehicle: vehicle);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _VehicleCard extends StatelessWidget {
//   final VehicleModel vehicle;
//
//   const _VehicleCard({required this.vehicle});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade200),
//         borderRadius: BorderRadius.circular(12),
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 22,
//             backgroundColor: Color(0xFFEAF1FF),
//             child: Icon(Icons.local_shipping_outlined, color: Colors.blue),
//           ),
//           12.width,
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       vehicle.truckNumber,
//                       style: AppTextStyle.semiBold,
//                     ),
//                     6.width,
//                     const Icon(Icons.verified, color: Colors.green, size: 18),
//                   ],
//                 ),
//                 Text(
//                   vehicle.truckName,
//                   style: AppTextStyle.body.copyWith(color: Colors.black54),
//                 ),
//                 Text(
//                   vehicle.description,
//                   style: AppTextStyle.body.copyWith(color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//           if (vehicle.isActive)
//             Container(
//               padding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE7F8ED),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 "Active",
//                 style: TextStyle(color: Colors.green),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// class VehicleModel {
//   final String truckNumber;
//   final String truckName;
//   final String description;
//   final bool isActive;
//
//   VehicleModel({
//     required this.truckNumber,
//     required this.truckName,
//     required this.description,
//     required this.isActive,
//   });
// }
//
//
