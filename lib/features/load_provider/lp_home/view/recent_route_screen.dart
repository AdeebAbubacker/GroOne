import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/rate_discovery/rate_discovery_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_select_address_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/book_shipment_widget.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class RecentRouteScreen extends StatefulWidget {
  final String? pickup;
  final String? destination;
  const RecentRouteScreen({super.key, this.pickup, this.destination});

  @override
  State<RecentRouteScreen> createState() => _RecentRouteScreenState();
}

class _RecentRouteScreenState extends State<RecentRouteScreen> {

  final rateDiscoveryBloc = locator<RateDiscoveryBloc>();

  Map<String, dynamic>? destination;
  Map<String, dynamic>? pickup;

  int? selectedRecentRoutes;

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

  });

  void disposeFunction() => frameCallback(() {

  });

  void updateSelectedRouteState(int index){
    setState(() {
      selectedRecentRoutes = index;
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
      child: Column(
        children: [
          10.height,

          // Add Different Route
          _buildAddDifferentLocationWidget(context),
          20.height,

          // Recent Load List
          _buildRecentRouteList(),
        ],
      ).withScroll(padding: EdgeInsets.all(commonSafeAreaPadding)),
    );
  }


  /// Recent Loads
  Widget _buildRecentRouteList(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Text("Recent route", style: AppTextStyle.body2),
        10.height,

        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 100),
          itemCount: 4,
          separatorBuilder: (BuildContext context, int index) => 20.height,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: ()=> updateSelectedRouteState(index),
              child: _buildListBody(index: index),
            );
          },
        ),
      ],
    );
  }


  /// Recent Load List Body
  Widget _buildListBody({required int index}){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: commonContainerDecoration(
          color: AppColors.lightPrimaryColor2,
          borderColor: selectedRecentRoutes == index ? AppColors.primaryColor : AppColors.borderColor,
      ),
      child: GestureDetector(
        onTap: ()=> updateSelectedRouteState(index),
        child: Row(
          children: [

            // Source or destination vertical line
            Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight),
            10.width,

            Column(
              children: [

                // Source
                BookShipmentWidget(
                  heading: context.appText.source,
                  subHeading: "Mumbai",
                  onClick: () {

                  },
                ),

                commonDivider(),

                // Destination
                BookShipmentWidget(
                  heading: context.appText.destination,
                  subHeading: "Pune",
                  onClick: () {

                  },
                ),

              ],
            ).expand(),
          ],
        ),
      ),
    );
  }

  /// Add Different Location Manually
  Widget _buildAddDifferentLocationWidget(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Text("Add different route", style: AppTextStyle.body2),
        10.height,

        Container(
          padding: EdgeInsets.all(10),
          decoration: commonContainerDecoration(
              color: AppColors.lightPrimaryColor2,
              borderColor: selectedRecentRoutes != null ? AppColors.borderColor : AppColors.primaryColor,
          ),
          child: Row(
            children: [

              // Source or destination vertical line
              Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight),
              10.width,

              Column(
                children: [

                  // Source
                  BookShipmentWidget(
                    heading: context.appText.source,
                    subHeading: widget.pickup ??  (pickup?['address']) ?? context.appText.selectPickUpPoint,
                    onClick: () {
                      Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: "Pickup Point", address: pickup?['address']), isForward: true)).then((onValue){
                        if(onValue != null){
                          pickup = onValue;
                        }
                        setState(() {});
                      });
                    },
                  ),

                  commonDivider(),

                  // Destination
                  BookShipmentWidget(
                    heading: context.appText.destination,
                    subHeading: widget.destination  ?? (destination?['address']) ?? context.appText.selectDestination,
                    onClick: () {
                      Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: "Select Destination", address: destination?['address']), isForward: true)).then((onValue){
                        if(onValue != null){
                          destination = onValue;
                        }
                        setState(() {});
                        dynamic req = RateDiscoveryApiRequest(
                          // pickup: pickup?.toLowerCase(),
                          // drop: destination?.toLowerCase(),
                          pickup: "bangalore",
                          drop: "chennai",
                        );
                        rateDiscoveryBloc.add(RateDiscoveryEvent(apiRequest: req));
                      });
                    },
                  ),

                ],
              ).expand(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectButton(BuildContext context){
    return AppButton(
      title: "Select",
      onPressed: (){
        if(pickup != null && destination != null){
          Map data = {
            "pickup": pickup,
            "destination": destination,
          };
          Navigator.of(context).pop(data);
        }
     },
    ).bottomNavigationPadding();
  }

}
