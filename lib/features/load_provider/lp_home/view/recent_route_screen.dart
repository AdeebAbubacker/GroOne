import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/recent_routes_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_select_address_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/book_shipment_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class RecentRouteScreen extends StatefulWidget {
  const RecentRouteScreen({super.key});

  @override
  State<RecentRouteScreen> createState() => _RecentRouteScreenState();
}

class _RecentRouteScreenState extends State<RecentRouteScreen> {

  final lpHomeCubit = locator<LPHomeCubit>();

  final searchController = TextEditingController();

  Map<String, dynamic>? destination;
  Map<String, dynamic>? pickup;

  int? selectedRecentRoutes;

  String? pickupLocation;
  String? pickupLatLong;
  String? destinationLocation;
  String? destinationLatLong;
  String? laneId;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction();

    super.dispose();
  }


  void initFunction() => frameCallback(() async {
    lpHomeCubit.fetchRecentRoute();
  });

  void disposeFunction() => frameCallback(() {

  });

  void updateSelectedRouteState(int index, RecentRouteData data){
    setState(() {
      selectedRecentRoutes = index;
      pickupLocation = data.pickUpAddr;
      destinationLocation = data.dropAddr;
      pickupLatLong = data.pickUpLatlon;
      destinationLatLong = data.dropLatlon;
      laneId = data.id.toString();
    });
    commonHapticFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Recent Routes", isCrossLeadingIcon: true),
      body: _buildBodyWidget(context),
      bottomNavigationBar: _buildSelectButton(context),
    );
  }

  /// Body
  Widget _buildBodyWidget(BuildContext context){
    return SafeArea(
      minimum: EdgeInsets.all(commonSafeAreaPadding),
      child: _buildRecentRouteList(),
    );
  }

  Widget _buildSearchBarWidget(){
    return AppSearchBar(searchController: searchController);
  }


  /// Recent Loads
  Widget _buildRecentRouteList(){
    return BlocConsumer<LPHomeCubit, LPHomeState>(
      listener: (context, state) { },
      builder: (context, state) {
        if(state.recentRouteState != null && state.recentRouteState?.status != null){
          switch (state.recentRouteState!.status){
            case Status.LOADING :
              return CircularProgressIndicator().center();
            case Status.SUCCESS :
              if(state.recentRouteState?.data != null){
                if(state.recentRouteState!.data!.data.isNotEmpty){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      10.height,
                      _buildSearchBarWidget(),
                      20.height,

                      // Title
                      Text("Recent route", style: AppTextStyle.body2),
                      10.height,

                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 100),
                        itemCount: state.recentRouteState!.data!.data.length,
                        separatorBuilder: (BuildContext context, int index) => 20.height,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: ()=> updateSelectedRouteState(index, state.recentRouteState!.data!.data[index]),
                            child: _buildListBody(index: index, data: state.recentRouteState!.data!.data[index]),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return genericErrorWidget(error: NotFoundError(), onRefresh: ()=> initFunction());
                }
              } else {
                return genericErrorWidget(error: GenericError(), onRefresh: ()=> initFunction());
              }
            case Status.ERROR :
              if(state.recentRouteState?.errorType != null){
                return genericErrorWidget(error: state.recentRouteState!.errorType, onRefresh: ()=> initFunction());
              }else{
                return genericErrorWidget(error: GenericError(), onRefresh: ()=> initFunction());
              }
            default :
              return genericErrorWidget(error: GenericError(), onRefresh: ()=> initFunction());
          }
        } else {
          return genericErrorWidget(error: GenericError(), onRefresh: ()=> initFunction());
        }
      },
    );
  }


  /// Recent Load List Body
  Widget _buildListBody({required int index, required RecentRouteData data}){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: commonContainerDecoration(
          color: AppColors.lightPrimaryColor2,
          borderColor: selectedRecentRoutes == index ? AppColors.primaryColor : AppColors.borderColor,
      ),
      child: GestureDetector(
        onTap: ()=> updateSelectedRouteState(index, data),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (data.pickUpAddr.isNotEmpty && data.dropAddr.isNotEmpty)
            // Text("${data.pickUpAddr} - ${ data.dropAddr}".capitalize, style: AppTextStyle.h5),
            // 10.height,
            Row(
              children: [

                // Source or destination vertical line
                Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight),
                10.width,

                Column(
                  children: [

                    // Source
                    BookShipmentWidget(
                      heading: context.appText.source,
                      subHeading: data.pickUpAddr,
                      onClick: () {

                      },
                    ),

                    commonDivider(),

                    // Destination
                    BookShipmentWidget(
                      heading: context.appText.destination,
                      subHeading: data.dropAddr,
                      onClick: () {

                      },
                    ),

                  ],
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Add Different Location Manually
  // Widget _buildAddDifferentLocationWidget(BuildContext context){
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       // Title
  //       Text("Add different route", style: AppTextStyle.body2),
  //       10.height,
  //
  //       Container(
  //         padding: EdgeInsets.all(10),
  //         decoration: commonContainerDecoration(
  //             color: AppColors.lightPrimaryColor2,
  //             borderColor: selectedRecentRoutes != null ? AppColors.borderColor : AppColors.primaryColor,
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Text("Chennai -Bangalore", style: AppTextStyle.h5),
  //             10.height,
  //             Row(
  //               children: [
  //
  //                 // Source or destination vertical line
  //                 Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight),
  //                 10.width,
  //
  //                 Column(
  //                   children: [
  //
  //                     // Source
  //                     BookShipmentWidget(
  //                       heading: context.appText.source,
  //                       subHeading: widget.pickup ??  (pickup?['address']) ?? context.appText.selectPickUpPoint,
  //                       onClick: () {
  //                         Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: "Pickup Point", address: pickup?['address']), isForward: true)).then((onValue){
  //                           if(onValue != null){
  //                             pickup = onValue;
  //                           }
  //                           setState(() {});
  //                         });
  //                       },
  //                     ),
  //
  //                     commonDivider(),
  //
  //                     // Destination
  //                     BookShipmentWidget(
  //                       heading: context.appText.destination,
  //                       subHeading: widget.destination  ?? (destination?['address']) ?? context.appText.selectDestination,
  //                       onClick: () {
  //                         Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: "Select Destination", address: destination?['address']), isForward: true)).then((onValue){
  //                           if(onValue != null){
  //                             destination = onValue;
  //                           }
  //                           setState(() {});
  //                           dynamic req = RateDiscoveryApiRequest(
  //                             // pickup: pickup?.toLowerCase(),
  //                             // drop: destination?.toLowerCase(),
  //                             pickup: "bangalore",
  //                             drop: "chennai",
  //                           );
  //                           rateDiscoveryBloc.add(RateDiscoveryEvent(apiRequest: req));
  //                         });
  //                       },
  //                     ),
  //
  //                   ],
  //                 ).expand(),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSelectButton(BuildContext context){
    return Row(
      children: [
        AppButton(
          title:  "Confirm",
          style:  selectedRecentRoutes != null ? AppButtonStyle.primary : AppButtonStyle.disableButton,
          onPressed: (){
            Map<String, dynamic> pickup = {
              "address": pickupLocation,
              "location": pickupLocation,
              "latLng": pickupLatLong,
              "laneId": laneId,
            };
            lpHomeCubit.setPickup(pickup);

            Map<String, dynamic> destination = {
              "address": destinationLocation,
              "location": destinationLocation,
              "latLng": destinationLatLong,
              "laneId": laneId,
            };
            lpHomeCubit.setDestination(destination);

            Navigator.of(context).pop(true);
          }
        ).expand(),
        10.width,


        AppButton(
          title:  "Select Different",
          onPressed: (){
          Navigator.of(context).pushReplacement(commonRoute(LPSelectAddressScreen(title: "Pickup Point"), isForward: true));
         }
        ).expand(),
      ],
    ).bottomNavigationPadding();
  }

}
