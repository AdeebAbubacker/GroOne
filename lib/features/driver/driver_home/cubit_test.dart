// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gro_one_app/data/ui_state/status.dart';
// import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
// import 'package:gro_one_app/features/driver/driver_load_details/repository/driver_loads_details_repository.dart';
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gro_one_app/data/ui_state/ui_state.dart';
// import 'package:gro_one_app/features/driver/driver_load_details/cubit/driver_load_details_cubit.dart';
// import 'package:gro_one_app/features/driver/driver_load_details/model/driver_load_details_model.dart';
// import 'package:gro_one_app/features/driver/driver_load_details/repository/driver_loads_details_repository.dart';
// import 'package:gro_one_app/utils/common_widgets.dart'; // For `genericErrorWidget` if used


// class CubitTestView extends StatefulWidget {
//   const CubitTestView({super.key});

//   @override
//   State<CubitTestView> createState() => _CubitTestViewState();
// }

// class _CubitTestViewState extends State<CubitTestView> {
//   late DriverLoadDetailsCubit cubit;

//   @override
//   void initState() {
//     super.initState();
//     cubit = context.read<DriverLoadDetailsCubit>();
//     // Optional: Automatically fetch on load
//     // cubit.getLpLoadsById(loadId: 'your-load-id');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Cubit Test")),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 cubit.getLpLoadsById(loadId: 'your-load-id');
//               },
//               child: const Text("Fetch Load"),
//             ),
//             const SizedBox(height: 20),

//             BlocBuilder<DriverLoadDetailsCubit, DriverLoadDetailsState>(
//               builder: (context, state) {
//                 final uiState = state.lpLoadById;

//                 if (uiState == null || uiState.status == Status.LOADING) {
//                   return const CircularProgressIndicator();
//                 }

//                 if (uiState.status == Status.ERROR) {
//                   return genericErrorWidget(
//                     onRefresh: () => cubit.getLpLoadsById(loadId: 'your-load-id'),
//                   );
//                 }

//                 final loadItem = uiState.data;

//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Text(
//                     "Load Name: ${loadItem?.data?.customer?.companyName ?? "--"}",
//                     style: const TextStyle(fontSize: 18),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
