import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_map_view_screen.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_notification_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_dropdown.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../cubit/gps_geofence_cubit/gps_geofence_cubit.dart';
import '../models/gps_geofence_model.dart';

class GpsGeofenceScreen extends StatefulWidget {
  const GpsGeofenceScreen({super.key});

  @override
  State<GpsGeofenceScreen> createState() => _GpsGeofenceScreenState();
}

class _GpsGeofenceScreenState extends State<GpsGeofenceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final gpsGeofenceCubit = locator<GpsGeofenceCubit>();
  Map<String, Map<String, bool>> vehicleGeofenceStates = {}; // { vehicleId: { geofenceId: isEnabled } }

  final List<Map<String, String>> geofences = [
    {'name': 'Zone!', 'area': '2342.1 Hcts'},
    {'name': 'Hussain Garden', 'area': '8.9 Hcts'},
    {'name': 'Zone!', 'area': '2342.1 Hcts'},
    {'name': 'Zone!', 'area': '2342.1 Hcts'},
    {'name': 'Zone!', 'area': '2342.1 Hcts'},
    {'name': 'Zone!', 'area': '2342.1 Hcts'},
  ];

  String selectedVehicle = 'R17-KA32C7098';
  final List<String> vehicles = ['R17-KA32C7098', 'MH12-DE3456', 'UP65-XY7890'];

  @override
  void initState() {
    super.initState();
    gpsGeofenceCubit.loadGeofences();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {}); // rebuild to hide/show button
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getFormattedValue(GpsGeofenceModel item) {
    switch (item.shapeType) {
      case 'circle':
        return '${(item.radius ?? 0).toStringAsFixed(0)} m';
      case 'polygon':
      case 'polyline':
      // Use coveredArea directly from model
        return item.coveredArea ?? '';
      default:
        return '';
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(
        title: context.appText.geofence,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(context, commonRoute(GpsNotificationScreen()));
            },
            icon: SvgPicture.asset(AppIcons.svg.notification, height: 20),
            iconColor: AppColors.primaryColor,
          ),
          AppIconButton(
            onPressed: () {},
            icon: Image.asset(AppIcons.png.moreVertical),
            iconColor: AppColors.primaryColor,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          labelStyle: AppTextStyle.h5,
          tabs: [
            Tab(text: context.appText.geofence),
            Tab(text: context.appText.vehicles),
          ],
        ),
      ),
      bottomNavigationBar: buildAddNewGeofenceButtonWidget(),
      body: TabBarView(
        controller: _tabController,
        children: [buildGeofenceList(), buildVehiclesTab()],
      ),
    );
  }

  Widget buildGeofenceList() {
    // return ListView.builder(
    //   padding: const EdgeInsets.all(16),
    //   itemCount: geofences.length,
    //   itemBuilder: (context, index) {
    //     final item = geofences[index];
    //     return Card(
    //       color: AppColors.white,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       elevation: 0,
    //       child: ListTile(
    //         title: Text('${item['name']} (${item['area']})'),
    //         trailing: const Icon(Icons.chevron_right),
    //         onTap: () {
    //           // Handle tap
    //         },
    //       ),
    //     );
    //   },
    // );
    return BlocBuilder<GpsGeofenceCubit, GpsGeofenceState>(
      builder: (context, state) {
        if (state is GpsGeofenceLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GpsGeofenceLoaded) {
          final geofences = state.geofences;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: geofences.length,
            itemBuilder: (context, index) {
              final item = geofences[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: AppColors.white,
                elevation: 0,
                child: ListTile(
                  title: Text('${item.name} (${_getFormattedValue(item)})', style: AppTextStyle.h5),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(context, commonRoute(GeofenceMapViewScreen(
                      geofence: item,
                      onSave: (updatedGeofence) {
                        // Handle the updated geofence data (e.g., save to database, API)
                        print("Geofence updated: ${updatedGeofence.name}, ID: ${updatedGeofence.id}");
                        if (updatedGeofence.shapeType == "circle") {
                          print("Center: ${updatedGeofence.center}, Radius: ${updatedGeofence.radius}");
                        } else if (updatedGeofence.shapeType == "polygon") {
                          print("Polygon Points: ${updatedGeofence.polygonPoints}");
                        }
                      },
                    ),));
                  },
                ),
              );
            },
          );
        } else if (state is GpsGeofenceError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    );
  }

  Widget buildVehiclesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppDropdown(
            labelText: "Select Vehicle",
            dropdownValue: selectedVehicle,
            dropDownList: vehicles.map((vehicle) {
              return DropdownMenuItem<String>(
                value: vehicle,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.primaryLightColor,
                      child: SvgPicture.asset(
                        AppIcons.svg.truck,
                        width: 20,
                      ),
                    ),
                    10.width,
                    Text(vehicle, style: AppTextStyle.h6),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedVehicle = newValue!;
              });
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<GpsGeofenceCubit, GpsGeofenceState>(
            builder: (context, state) {
              if (state is GpsGeofenceLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GpsGeofenceLoaded) {
                final geofences = state.geofences;

                // Initialize state map for selected vehicle if not present
                vehicleGeofenceStates.putIfAbsent(
                  selectedVehicle,
                      () => {
                    for (var geofence in geofences)
                      geofence.id: false, // Default all switches off
                  },
                );

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: geofences.length,
                  itemBuilder: (context, index) {
                    final item = geofences[index];
                    final isEnabled = vehicleGeofenceStates[selectedVehicle]?[item.id] ?? false;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColors.white,
                      elevation: 0,
                      child: ListTile(
                        title: Text(
                          '${item.name} (${_getFormattedValue(item)})',
                          style: AppTextStyle.h6,
                        ),
                        trailing: Switch(
                          value: isEnabled,
                          onChanged: (bool value) {
                            setState(() {
                              vehicleGeofenceStates[selectedVehicle]?[item.id] = value;
                              // TODO: Optionally call API to update server here
                              print(
                                  'Geofence ${item.id} for $selectedVehicle is now ${value ? "enabled" : "disabled"}');
                            });
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (state is GpsGeofenceError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }


  // Widget buildVehiclesTab() {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: AppDropdown(
  //           labelText: "Select Vehicle",
  //           dropdownValue: selectedVehicle,
  //           dropDownList:
  //               vehicles.map((vehicle) {
  //                 return DropdownMenuItem<String>(
  //                   value: vehicle,
  //                   child: Row(
  //                     children: [
  //                       CircleAvatar(
  //                         radius: 15,
  //                         backgroundColor: AppColors.primaryLightColor,
  //                         child: SvgPicture.asset(
  //                           AppIcons.svg.truck,
  //                           width: 20,
  //                         ),
  //                       ),
  //                       10.width,
  //                       Text(vehicle, style: AppTextStyle.h6),
  //                     ],
  //                   ),
  //                 );
  //               }).toList(),
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               selectedVehicle = newValue!;
  //             });
  //           },
  //         ),
  //       ),
  //       Expanded(
  //         child: ListView.builder(
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           itemCount: geofences.length,
  //           itemBuilder: (context, index) {
  //             final item = geofences[index];
  //             return Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               color: AppColors.white,
  //               elevation: 0,
  //               child: ListTile(
  //                 title: Text(
  //                   '${item['name']} (${item['area']})',
  //                   style: AppTextStyle.h6,
  //                 ),
  //                 trailing: Switch(
  //                   value: true, // TODO: Replace with actual toggle state
  //                   onChanged: (bool value) {
  //                     // TODO: Handle toggle change for geofence
  //                   },
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildAddNewGeofenceButtonWidget() {
    // If current tab is "Vehicles" (index 1), hide the button
    if (_tabController.index == 1) {
      return const SizedBox.shrink(); // returns an empty widget
    }

    // Otherwise, show the button
    return AppButton(
      title: context.appText.addNewGeofence,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeofenceMapViewScreen(
              geofence: null,
              onSave: (newGeofence) {
                print("New Geofence added: ${newGeofence.name}");
              },
            ),
          ),
        );
      },
    ).bottomNavigationPadding();
  }
}

// class GpsGeofenceScreen extends StatefulWidget {
//   const GpsGeofenceScreen({super.key});
//
//   @override
//   State<GpsGeofenceScreen> createState() => _GpsGeofenceScreenState();
// }
//
// class _GpsGeofenceScreenState extends State<GpsGeofenceScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   final gpsGeofenceCubit = locator<GpsGeofenceCubit>();
//
//   final List<Map<String, String>> geofences = [
//     {'name': 'Zone!', 'area': '2342.1 Hcts'},
//     {'name': 'Hussain Garden', 'area': '8.9 Hcts'},
//     {'name': 'Zone!', 'area': '2342.1 Hcts'},
//     {'name': 'Zone!', 'area': '2342.1 Hcts'},
//     {'name': 'Zone!', 'area': '2342.1 Hcts'},
//     {'name': 'Zone!', 'area': '2342.1 Hcts'},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     gpsGeofenceCubit.loadGeofences();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //   appBar: CommonAppBar(
//     //     title: context.appText.geofence,
//     //     actions: [
//     //       AppIconButton(
//     //         onPressed: () {},
//     //         icon: SvgPicture.asset(AppIcons.svg.notification,height: 20,),
//     //         iconColor: AppColors.primaryColor,
//     //       ),
//     //       AppIconButton(
//     //         onPressed: () {},
//     //         icon: Image.asset(AppIcons.png.moreVertical),
//     //         iconColor: AppColors.primaryColor,
//     //       ),
//     //     ],
//     //     bottom: TabBar(
//     //       controller: _tabController,
//     //       indicatorColor: AppColors.primaryColor,
//     //       indicatorSize: TabBarIndicatorSize.tab,
//     //       labelColor: AppColors.primaryColor,
//     //       unselectedLabelColor: Colors.grey,
//     //       labelStyle: AppTextStyle.h5,
//     //       tabs:  [
//     //         Tab(text: context.appText.geofence),
//     //         Tab(text: context.appText.vehicles),
//     //       ],
//     //     ),
//     //   ),
//     //   bottomNavigationBar: buildAddNewGeofenceButtonWidget(),
//     //   body: Column(
//     //     children: [
//     //       Expanded(
//     //         child: TabBarView(
//     //           controller: _tabController,
//     //           children: [
//     //             ListView.builder(
//     //               padding: const EdgeInsets.all(16),
//     //               itemCount: geofences.length,
//     //               itemBuilder: (context, index) {
//     //                 final item = geofences[index];
//     //                 return Card(
//     //                   shape: RoundedRectangleBorder(
//     //                     borderRadius: BorderRadius.circular(10),
//     //                   ),
//     //                   elevation: 1,
//     //                   child: ListTile(
//     //                     title: Text('${item['name']} (${item['area']})'),
//     //                     trailing: const Icon(Icons.chevron_right),
//     //                     onTap: () {
//     //                       // Handle tap
//     //                     },
//     //                   ),
//     //                 );
//     //               },
//     //             ),
//     //
//     //             // Vehicles Tab
//     //             const Center(
//     //               child: Text(
//     //                 'No vehicles available.',
//     //                 style: TextStyle(color: Colors.grey),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //     ],
//     //   ),
//     // );
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: CommonAppBar(
//         title: context.appText.geofence,
//         actions: [
//           AppIconButton(
//             onPressed: () {
//             },
//             icon: SvgPicture.asset(AppIcons.svg.notification, height: 20),
//             iconColor: AppColors.primaryColor,
//           ),
//           AppIconButton(
//             onPressed: () {},
//             icon: Image.asset(AppIcons.png.moreVertical),
//             iconColor: AppColors.primaryColor,
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: AppColors.primaryColor,
//           indicatorSize: TabBarIndicatorSize.tab,
//           labelColor: AppColors.primaryColor,
//           unselectedLabelColor: Colors.grey,
//           labelStyle: AppTextStyle.h5,
//           tabs: [
//             Tab(text: context.appText.geofence),
//             Tab(text: context.appText.vehicles),
//           ],
//         ),
//       ),
//       bottomNavigationBar: buildAddNewGeofenceButtonWidget(),
//       body: BlocBuilder<GpsGeofenceCubit, GpsGeofenceState>(
//         builder: (context, state) {
//           if (state is GpsGeofenceLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is GpsGeofenceLoaded) {
//             final geofences = state.geofences;
//             return ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: geofences.length,
//               itemBuilder: (context, index) {
//                 final item = geofences[index];
//                 return Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   color: AppColors.white,
//                   elevation: 0,
//                   child: ListTile(
//                     title: Text(item.name,style: AppTextStyle.h5,),
//                     trailing: const Icon(Icons.chevron_right),
//                     onTap: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (_) => GeofenceMapViewScreen(
//                         //       geofence: item, // pass GpsGeofenceModel
//                         //     ),
//                         //   ),
//                         // );
//                     },
//                   ),
//                 );
//               },
//             );
//           } else if (state is GpsGeofenceError) {
//             return Center(child: Text('Error: ${state.message}'));
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//
//   }
//
//
//
//   Widget buildAddNewGeofenceButtonWidget() {
//     return AppButton(
//       title: context.appText.addNewGeofence,
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => GeofenceMapViewScreen(
//               geofence: null, // Pass null to indicate adding a new geofence
//               onSave: (newGeofence) {
//                 // Handle the newly created geofence data
//                 print("New Geofence added: ${newGeofence.name}, ID: ${newGeofence.id}");
//                 if (newGeofence.shapeType == "circle") {
//                   print("Center: ${newGeofence.center}, Radius: ${newGeofence.radius}");
//                 } else if (newGeofence.shapeType == "polygon") {
//                   print("Polygon Points: ${newGeofence.polygonPoints}");
//                 }
//               },
//             ),
//           ),
//         );
//       },
//     ).bottomNavigationPadding();
//   }
// }
