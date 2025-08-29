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
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: CommonAppBar(title: context.appText.recentRoutesTitle, isCrossLeadingIcon: true, scrolledUnderElevation: 0.0),
        body: _buildBodyWidget(context),
        bottomNavigationBar: _buildSelectButton(context),
      ),
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
    return AppSearchBar(
        searchController: searchController,
      onChanged: (val) {
        lpHomeCubit.fetchRecentRoute(isLoading: false,search: searchController.text);
      },
      onClear: () {
          searchController.clear();
        lpHomeCubit.fetchRecentRoute(isLoading: false);
      },
    );
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
              if (state.recentRouteUIState?.data != null) {
                final routes = state.recentRouteUIState!.data!.data.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    10.height,
                    _buildSearchBarWidget(), // 🔍 Always show search bar
                    20.height,

                    if (routes.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 100),
                        itemCount: routes.length,
                        separatorBuilder: (context, index) => 20.height,
                        itemBuilder: (context, index) {
                          final route = routes[index];
                          return GestureDetector(
                            onTap: () => updateSelectedRouteState(index, route),
                            child: _buildListBody(index: index, data: route),
                          );
                        },
                      ).expand()
                    else
                      genericErrorWidget(error: NotFoundError()).expand(),
                  ],
                );
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight).paddingSymmetric(vertical: 5),
                10.width,

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Source (Pick Up)
                    Text(context.appText.source, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                    6.height,
                    Text(pickUpLocationText(data), style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor)),

                    commonDivider(),

                    // Destination
                    Text(context.appText.destination, style: AppTextStyle.body3.copyWith(fontSize: 14, color: AppColors.textBlackColor)),
                    6.height,
                    Text(destinationLocationText(data), style: AppTextStyle.body3.copyWith(fontSize: 12, color: AppColors.textBlackColor))

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
    ).paddingAll(commonPadding);
  }

}
