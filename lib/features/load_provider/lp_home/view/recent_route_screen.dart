import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/destination_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/pick_up_model.dart';
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

  int? selectedRecentRoutes;

  String? pickupLocation;
  String? pickupAddress;
  String? pickupLatLong;
  String? destinationLocation;
  String? destinationAddress;
  String? destinationLatLong;
  num? laneId;

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
    selectedRecentRoutes = index;

    pickupLocation = data.loadRoute?.pickUpLocation;
    pickupAddress = data.loadRoute?.pickUpAddr;
    pickupLatLong = data.loadRoute?.pickUpLatlon;

    destinationLocation = data.loadRoute?.dropLocation;
    destinationAddress = data.loadRoute?.dropAddr;
    destinationLatLong = data.loadRoute?.dropLatlon;

    laneId = data.laneId;

    lpHomeCubit.setLaneId(data.laneId);

    setState(() {});
    commonHapticFeedback();
  }


  String pickUpLocationText(RecentRouteData data){
    if (data.loadRoute!.pickUpWholeAddr.isNotEmpty && data.loadRoute!.pickUpLocation.isNotEmpty){
      return data.loadRoute?.pickUpWholeAddr ?? '';
    } else {
      return "";
    }

  }

  String destinationLocationText(RecentRouteData data){
    if (data.loadRoute!.dropWholeAddr.isNotEmpty && data.loadRoute!.dropLocation.isNotEmpty){
      return data.loadRoute?.dropWholeAddr ?? '';
    } else {
      return "";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.recentRoutes, isCrossLeadingIcon: true, scrolledUnderElevation: 0.0),
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
        if(state.recentRouteUIState != null && state.recentRouteUIState?.status != null){
          switch (state.recentRouteUIState!.status){
            case Status.LOADING :
              return CircularProgressIndicator().center();
            case Status.SUCCESS :
              if(state.recentRouteUIState?.data != null){
                if(state.recentRouteUIState!.data!.data.isNotEmpty){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      10.height,

                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 100),
                        itemCount: state.recentRouteUIState!.data!.data.length,
                        separatorBuilder: (BuildContext context, int index) => 20.height,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: ()=> updateSelectedRouteState(index, state.recentRouteUIState!.data!.data[index]),
                            child: _buildListBody(index: index, data: state.recentRouteUIState!.data!.data[index]),
                          );
                        },
                      ).expand(),
                    ],
                  );
                } else {
                  return genericErrorWidget(error: NotFoundError(), onRefresh: ()=> initFunction());
                }
              } else {
                return genericErrorWidget(error: GenericError(), onRefresh: ()=> initFunction());
              }
            case Status.ERROR :
              if(state.recentRouteUIState?.errorType != null){
                return genericErrorWidget(error: state.recentRouteUIState!.errorType, onRefresh: ()=> initFunction());
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
                      subHeading: pickUpLocationText(data),
                      onClick: () {

                      },
                    ),

                    commonDivider(),

                    // Destination
                    BookShipmentWidget(
                      heading: context.appText.destination,
                      subHeading: destinationLocationText(data),
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

  Widget _buildSelectButton(BuildContext context){
    return Row(
      children: [
        AppButton(
          title:  context.appText.confirm,
          style:  selectedRecentRoutes != null ? AppButtonStyle.primary : AppButtonStyle.disableButton,
          onPressed: (){
            if(selectedRecentRoutes != null) {
              final destinationData = DestinationModel(
                  address: destinationAddress,
                  location: destinationLocation,
                  latLng: destinationLatLong,
                  laneId: lpHomeCubit.state.laneId
              );
              lpHomeCubit.setDestination(destinationData);


              final pickupData = PickUpModel(
                  address: pickupAddress,
                  location: pickupLocation,
                  latLng: pickupLatLong,
                  laneId: lpHomeCubit.state.laneId
              );
              lpHomeCubit.setPickup(pickupData);

              Navigator.of(context).pop(true);
            }
          }
        ).expand(),
        10.width,


        AppButton(
          title:  context.appText.selectDifferent,
          onPressed: (){
          Navigator.of(context).pushReplacement(commonRoute(LPSelectAddressScreen(title: context.appText.pickupPoint), isForward: true));
         }
        ).expand(),
      ],
    ).bottomNavigationPadding();
  }

}
