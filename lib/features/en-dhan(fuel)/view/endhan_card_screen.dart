// import 'package:flutter/material.dart';
// import 'package:gro_one_app/data/model/result.dart';
// import 'package:gro_one_app/features/en-dhan(fuel)/widgets/endhan_card_item.dart';
// import 'package:gro_one_app/utils/app_button_style.dart';
// import 'package:gro_one_app/utils/app_colors.dart';
// import 'package:gro_one_app/utils/app_icon_button.dart';
// import 'package:gro_one_app/utils/app_icons.dart';
// import 'package:gro_one_app/utils/app_image.dart';
// import 'package:gro_one_app/utils/app_string.dart';
// import 'package:gro_one_app/utils/app_text_style.dart';
// import 'package:gro_one_app/utils/common_widgets.dart';
// import 'package:gro_one_app/utils/widgets/common_app_bar.dart';
// import 'package:gro_one_app/utils/widgets/app_loading_widget.dart';
// import 'package:gro_one_app/utils/widgets/app_error_widget.dart';
// import 'package:gro_one_app/utils/app_search_bar.dart';
// import 'package:gro_one_app/utils/extensions/int_extensions.dart';
// import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

// import '../../../utils/app_route.dart';
// import 'endhan_create_new_card_screen.dart';

// class EndhanCardScreen extends StatefulWidget {
//   const EndhanCardScreen({Key? key}) : super(key: key);

//   @override
//   State<EndhanCardScreen> createState() => _EndhanCardScreenState();
// }

// class _EndhanCardScreenState extends State<EndhanCardScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   // Mock data for demonstration
//   final List<Map<String, dynamic>> _cards = List.generate(3, (index) => {
//     'image': AppImage.png.endhanCard,
//     'cardNumber': '12XXX XXXXX X5678',
//     'vehicleNumber': 'TN12 BD 1234',
//     'status': 'Active',
//     'amount': '₹2,550.00',
//     'mobile': '98777 43321',
//     'dateTime': 'Today 11:34 AM',
//   });

//   String _searchText = '';
//   bool _isLoading = false;
//   String? _error;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.blackishWhite,
//       appBar: CommonAppBar(
//         title: 'eN-Dhan Card',
//         centreTile: false,
//         actions: [
//            AppIconButton(
//               onPressed: (){
//                 Navigator.push(context,commonRoute(EndhanCreateNewCardScreen()));
//               },
//               icon: Icon(Icons.add, color: Colors.white),
//              style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
//           ),
          
//           AppIconButton(
//             onPressed: () {},
//             icon: AppIcons.svg.filledSupport,
//             iconColor: AppColors.primaryColor,
//           ),
        
         
//           10.width,
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             16.height,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 'My Cards (ID: HPCL 43352)',
//                 style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
//               ),
//             ),
//             12.height,
//             AppSearchBar(
//               searchController: _searchController,
//               hintText: 'Search',
//               onChanged: (val) {
//                 setState(() {
//                   _searchText = val;
//                 });
//               },
//               onClear: () {
//                 setState(() {
//                   _searchText = '';
//                 });
//               },
//             ).paddingSymmetric(horizontal: 16.0),
//             16.height,
//             Expanded(
//               child: _isLoading
//                   ? const AppLoadingWidget()
//                   : _error != null
//                       ? AppErrorWidget(
//                           error: GenericError(),
//                           onRetry: () {
//                             setState(() {
//                               _error = null;
//                               _isLoading = false;
//                             });
//                           },
//                         )
//                       : ListView.builder(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                           itemCount: _cards
//                               .where((card) => card['vehicleNumber']
//                                   .toString()
//                                   .toLowerCase()
//                                   .contains(_searchText.toLowerCase()) ||
//                                   card['cardNumber']
//                                       .toString()
//                                       .toLowerCase()
//                                       .contains(_searchText.toLowerCase()))
//                               .length,
//                           itemBuilder: (context, index) {
//                             final filteredCards = _cards
//                                 .where((card) => card['vehicleNumber']
//                                     .toString()
//                                     .toLowerCase()
//                                     .contains(_searchText.toLowerCase()) ||
//                                     card['cardNumber']
//                                         .toString()
//                                         .toLowerCase()
//                                         .contains(_searchText.toLowerCase()))
//                                 .toList();
//                             final card = filteredCards[index];
//                             return EndhanCardItem(card: card).paddingOnly(bottom: 12);
//                           },
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

