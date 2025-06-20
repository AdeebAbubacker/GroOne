import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/features/kyc/view/kyc_pending_dialogue.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_list_bloc/load_list_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_commodity/load_commodity_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/rate_discovery/rate_discovery_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/get_load_response.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_truck_type_list_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/commodity_types_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/load_summary_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_select_address_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/recent_route_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/truck_type_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/book_shipment_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/incomplete_kyc_status_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/lp_commodity_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/lp_truck_type_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/lp_weight_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/upcoming_shipments_list_body.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/weight_selection_screen.dart';
import 'package:gro_one_app/features/our_value_added_services_view/our_value_added_services_widget.dart';
import 'package:gro_one_app/features/profile/view/profile_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_video.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/textFieldInputFormatter/phone_number_input_formatter.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:video_player/video_player.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';

class HomeScreenLoadProvider extends StatefulWidget {
  const HomeScreenLoadProvider({super.key});

  @override
  State<HomeScreenLoadProvider> createState() => _HomeScreenLoadProviderState();
}

class _HomeScreenLoadProviderState extends State<HomeScreenLoadProvider> {

  ProfileDetailModel? profileResponse;
  LpGetLoadModel? getLoadResponse;

  final lpHomeBloc = locator<LpHomeBloc>();
  final vpHomeBloc = locator<VpCreationBloc>();
  final loadPostingBloc = locator<LoadPostingBloc>();
  final loadCommodityBloc = locator<LoadCommodityBloc>();
  final loadTruckTypeBloc = locator<LoadTruckTypeBloc>();
  final loadDetailBloc = locator<LoadListBloc>();
  final rateDiscoveryBloc = locator<RateDiscoveryBloc>();
  final lpHomeCubit = locator<LPHomeCubit>();


  final dateTimeTextController = TextEditingController();
  final weightTextController = TextEditingController();

  int selectedPercentage = 80;
  int baseAmount = 15000;

  String hintCommodity = 'Commodity';
  String hintTruck = 'Truck';
  String profileImage = "";

  String? commodityId;
  String? truckTypeId;
  String? rateDiscoveryPrice;
  String? selectedCommodity;
  String? selectedTruck;
  String? truckType;
  String? truckLength;
  String? selectedDate;
  String? selectedTime;
  String? laneId;

  bool checkBoxBool = false;
  bool memoDone = false;
  bool hideKycSuccessStatus = false;



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
    disposeFunction(context);
    super.dispose();
  }


  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? ""));
    loadCommodityBloc.add(LoadCommodity());
    loadTruckTypeBloc.add(LoadTruckType());
    loadDetailBloc.add(GetLoadRequested(lpHomeBloc.userId ?? ""));
    await lpHomeCubit.startKycSuccessTimer();
    await lpHomeCubit.fetchRecentRoute();
    await lpHomeCubit.fetchLoadWeight();
    clearAllValues();
  });

  void disposeFunction(BuildContext context) => frameCallback(() {
    dateTimeTextController.dispose();
    weightTextController.dispose();
    lpHomeCubit.setDestination(null);
    lpHomeCubit.setPickup(null);
    commodityId = null;
    truckTypeId = null;
    selectedTruck = null;
    selectedCommodity = null;
    rateDiscoveryPrice = null;
    truckType = null;
    truckLength = null;
    commonHideKeyboard(context);
  });

  void clearAllValues(){
    dateTimeTextController.clear();
    weightTextController.clear();
    lpHomeCubit.clearPickUpAndDestination();
    lpHomeCubit.setDestination(null);
    lpHomeCubit.setPickup(null);
    commodityId = null;
    truckTypeId = null;
    selectedTruck = null;
    selectedCommodity = null;
    rateDiscoveryPrice = null;
    truckType = null;
    truckLength = null;
    lpHomeCubit.state.copyWith(destination: null);
    lpHomeCubit.state.copyWith(pickup: null);
    CustomLog.debug(this, "Clear All Values");
    setState(() {});
  }



  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    print("Parts : ${parts}");

    if(parts.isNotEmpty){
      if (parts.length == 1) return parts.first[0].toUpperCase();
      return parts.take(2).map((e) => e[0].toUpperCase()).join();
    } else {
      return "";
    }

  }


  // For Get Rate Discovery validation
  bool isFormValid() {
    final pickup = lpHomeCubit.state.pickup?.data;
    final destination = lpHomeCubit.state.destination?.data;
    bool checkAllField = pickup != null &&
        destination != null &&
        commodityId != null &&
        truckTypeId != null &&
        dateTimeTextController.text.trim().isNotEmpty &&
        weightTextController.text.trim().isNotEmpty;
    return checkAllField;
  }


  // Validation
  bool checkValidation() {
    final pickup = lpHomeCubit.state.pickup;
    final destination = lpHomeCubit.state.destination;
    if (pickup == null) {
      ToastMessages.alert(message: "Please select pickup location");
      return false;
    }
    if (destination == null) {
      ToastMessages.alert(message: "Please select destination location");
      return false;
    }
    if (commodityId == null) {
      ToastMessages.alert(message: "Please select commodity");
      return false;
    }
    if (truckTypeId == null) {
      ToastMessages.alert(message: "Please select truck");
      return false;
    }
    if (dateTimeTextController.text.trim().isEmpty) {
      ToastMessages.alert(message: "Please select date");
      return false;
    }
    if (weightTextController.text.trim().isEmpty) {
      ToastMessages.alert(message: "Please select consignment weight");
      return false;
    }
    return true;
  }


  Future<void> fetchRateDiscovery() async {
    CustomLog.debug(this, "Fetch Rate Discovery - Form Valid : ${isFormValid()}");
    if (!isFormValid()) {
      CustomLog.debug(this, "All Fields are not valid");
      return;
    }

    if (lpHomeCubit.state.laneId == null){
      ToastMessages.error(message: "Something went wrong, Land Id is null");
      CustomLog.debug(this, "Land Id is null");
      return;
    }

    final req = RateDiscoveryApiRequest(
      laneId: lpHomeCubit.state.laneId.toString(),
      truckTypeId: truckTypeId ?? "",
      commodityId: commodityId,
      weightId: '1',
    );
    await lpHomeCubit.fetchRateDiscovery(req);
    if (lpHomeCubit.state.rateDiscoveryUIState != null) {
      Status? status = lpHomeCubit.state.rateDiscoveryUIState!.status;
      if (status != null) {
         if (status == Status.ERROR) {
           final error = lpHomeCubit.state.rateDiscoveryUIState?.errorType;
           ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
         }
      }
    }
    setState(() {});
  }




  // Load Post Api Call
  Future<void> postLoad(BuildContext context) async {
    if (!checkValidation()) {
      return;
    }

    // 3 Complete KYC | 2 In Progress kyc | 1 Pending Kyc
    // if (profileResponse!.data!.customer!.isKyc != 3) {
    //   kycBottomSheet(context);
    //   return;
    // }

    // Api Request store data in the class
    final request = CreateLoadApiRequest(
        customerId: int.parse(lpHomeBloc.userId.toString()),
        commodityId: int.parse(commodityId ?? "0"),
        truckTypeId: int.parse(truckTypeId ?? "0"),
        pickUpAddr:  lpHomeCubit.state.pickup?.data?.address ?? "",
        pickUpLocation:  lpHomeCubit.state.pickup?.data?.location ?? "",
        pickUpLatlon:   lpHomeCubit.state.pickup?.data?.latLng ??"",
        dropAddr:   lpHomeCubit.state.destination?.data?.address ?? "",
        dropLocation:   lpHomeCubit.state.destination?.data?.location ?? "",
        dropLatlon:  lpHomeCubit.state. destination?.data?.latLng ??"",
        dueDate: DateTimeHelper.convertStringToDateTime(dateTimeTextController.text).toString(),
        consignmentWeight: int.parse(lpHomeCubit.state.selectedWeight!.id.toString()),
        rate: rateDiscoveryPrice ?? "0000 - 0000",
        laneId: lpHomeCubit.state.laneId
    );

    // Pass Data in to next page
    Navigator.push(context, commonRoute(LoadSummaryScreen(
      apiRequest: request,
      pickupAddress:  lpHomeCubit.state.pickup?.data?.address ?? "",
      pickupLocation: lpHomeCubit.state.pickup?.data?.location ?? "",
      destinationAddress:  lpHomeCubit.state.destination?.data?.address ?? "",
      destinationLocation: lpHomeCubit.state.destination?.data?.location ?? "",
      vehicleType: truckType ?? "",
      vehicleLength: truckLength ?? "",
      approxWeight: weightTextController.text,
      category: selectedCommodity ?? "",
      price: rateDiscoveryPrice ?? "0000 - 0000",
      date : dateTimeTextController.text,
    ), isForward: true)).then((onValue){
      loadDetailBloc.add(GetLoadRequested(lpHomeBloc.userId??"0"));
      if(onValue != null && onValue == true){
        if(!context.mounted) return;
        clearAllValues();
      }
    });

  }


  // Kyc Bottom Sheet
  void kycBottomSheet(BuildContext context){
    commonBottomSheetWithBGBlur(
      screen: KycPendingDialogue(
        onPressed: () {
          context.pop();
          commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet()).then((value) {
            lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? "0"),
            );
          });
        },
      ),
      context: context,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: buildBodyWidget(context),
    );
  }

  // Appbar
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return CommonAppBar(
      elevation: 1.0,
      isLeading: false,
      leading: BlocListener<VpCreationBloc, VpCreationState>(
        bloc: vpHomeBloc,
        listener: (context, state) {
          if (state is LogoutSuccess) {
            context.go(AppRouteName.splash);
          }
          if (state is LogoutError) {
            ToastMessages.error(
              message: getErrorMsg(errorType: state.errorType),
            );
          }
        },
        child: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
      ),

      actions: [

        // Notification
        IconButton(
          onPressed: () {},
          icon:  SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),

        // KYC Blinking
        BlocProvider<LPHomeCubit>.value(
          value: locator<LPHomeCubit>(), // singleton from locator
          child: BlocConsumer<LPHomeCubit, LPHomeState>(
            listener: (context, state) { },
            builder: (context, state) {
              if (profileResponse != null && profileResponse?.data != null) {
                if (profileResponse?.data?.customer != null && profileResponse!.data!.customer!.isKyc == 3) {
                  if (state.showSuccessKyc) {
                    return 0.width;
                  } else {
                    return 0.width;
                  }
                } else if (profileResponse!.data!.customer!.isKyc == 2){
                  return 0.width; // kycInProgressStatusWidget
                } else {
                  return kycWidget(
                    onTap: () =>  commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet()),
                  );
                }
              }
              return 0.width;
            },
          ),
        ),

        // Profile
        BlocConsumer<LpHomeBloc, HomeState>(
          bloc: lpHomeBloc,
          listener: (context, state) { },
          builder: (context, state) {
            if (state is ProfileDetailSuccess) {
              return Row(
                children: [
                10.width,

                // Profile
                Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.greyIconBackgroundColor),
                    child: Text(getInitialsFromName(this, name : profileResponse?.data?.details?.companyName ?? '')),
                ).onClick((){
                  Navigator.push(context, commonRoute(ProfileScreen(profileData: profileResponse!.data!), isForward: true)).then((v) {
                    frameCallback(() =>  lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? "")));
                  });
                }).paddingRight(commonSafeAreaPadding),
            ]);
            }
            return Container();
          },
        )

      ],
    );
  }

  // Body
  Widget buildBodyWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        loadCommodityBloc.add(LoadCommodity());
        loadTruckTypeBloc.add(LoadTruckType());
        lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? ""));
        loadDetailBloc.add(GetLoadRequested(lpHomeBloc.userId ?? "1"));
      },
      child: SingleChildScrollView(
        child: BlocConsumer<LpHomeBloc, HomeState>(
          listener: (context, state) {
            if (state is ProfileDetailSuccess) {
              profileResponse = state.profileDetailResponse;
              profileImage = state.profileDetailResponse.data?.details?.profileImageUrl ?? "";
              setState(() {});
            }
            if (state is ProfileDetailError) {
              ToastMessages.error(
                message: getErrorMsg(errorType: state.errorType),
              );
            }
          },
          bloc: lpHomeBloc,
          builder: (context, state) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.height,

                  // Kyc Status Label
                  BlocProvider<LPHomeCubit>.value(
                    value: locator<LPHomeCubit>(), // singleton from locator
                    child: BlocConsumer<LPHomeCubit, LPHomeState>(
                      listener: (context, state) { },
                      builder: (context, state) {
                        if (profileResponse != null && profileResponse?.data != null) {
                          if (profileResponse?.data?.customer != null && profileResponse!.data!.customer!.isKyc == 3) {
                            if (state.showSuccessKyc) {
                              return kycSuccessStatusWidget();
                            } else {
                              return 0.height;
                            }
                          } else if (profileResponse!.data!.customer!.isKyc == 2){
                            return kycInProgressStatusWidget();

                          } else {
                            return IncompleteKycStatusWidget();
                          }
                        }
                        return 20.height;
                      },
                    ),
                  ),
                  20.height,

                  OurValueAddedServicesWidget(),
                  20.height,

                  bookShipmentSectionWidget(context),
                  20.height,

                  buildUpComingShipmentListWidget(),
                  20.height,
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  // Book Shipment
  Widget bookShipmentSectionWidget(BuildContext context) {
    return Container(
      decoration: commonContainerDecoration(borderRadius: BorderRadius.zero, shadow: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(context.appText.bookShipment, style: AppTextStyle.body1),
          15.height,

          // Location Picker
          Container(
            padding: EdgeInsets.all(10),
            decoration: commonContainerDecoration(
              color: AppColors.lightPrimaryColor2,
              borderColor: AppColors.borderColor,
            ),
            child: Row(
              children: [

                // Source or destination vertical line
                Image.asset(AppImage.png.bookAShipment, width: 18, fit: BoxFit.fitHeight),
                10.width,

                BlocConsumer<LPHomeCubit, LPHomeState>(
                  bloc: lpHomeCubit,
                  listener: (context, state){

                  },
                  builder: (context, state){
                    String? pickupLocation;
                    String? destinationLocation;

                    if (state.pickup?.status == Status.SUCCESS && state.pickup?.data != null){
                      pickupLocation = ("${state.pickup!.data!.location!.isNotEmpty ? "${state.pickup!.data!.location.capitalize}, " : ""}${state.pickup!.data!.address.toString().capitalize}");
                    }


                    if (state.destination?.status == Status.SUCCESS && state.destination?.data != null){
                        destinationLocation = ("${state.destination!.data!.location!.isNotEmpty ? "${state.destination!.data!.location.capitalize}, " : ""}${state.destination!.data!.address.toString().capitalize}");
                    }

                    return Column(
                      children: [

                        // Source (Pick Up)
                        BookShipmentWidget(
                          heading: context.appText.source,
                          subHeading: pickupLocation ?? context.appText.selectPickUpPoint,
                          onClick: () {
                            if (state.recentRouteUIState?.data != null){
                              if (state.recentRouteUIState!.data!.data.isNotEmpty) {
                                Navigator.of(context).push(createRoute(RecentRouteScreen()));
                              }
                            }
                            Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: "Pickup Point", address: state.pickup!.data?.address, location: state.pickup!.data?.location), isForward: true));

                          },
                        ),

                        commonDivider(),

                        // Destination
                        BookShipmentWidget(
                          heading: context.appText.destination,
                          subHeading: destinationLocation ?? context.appText.selectDestination,
                          onClick: () {
                            Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: "Select Destination", address: state.destination!.data?.address, location: state.destination!.data?.location), isForward: true)).then((onValue) async {
                              if(onValue != null && onValue == true){
                                 debugPrint("Destination: ${state.destination.toString()}");
                              } else {
                                lpHomeCubit.setDestination(null);
                              }
                              setState(() {});
                            });
                          },
                        ),

                      ],
                    ).expand();
                  },
                ),
              ],
            ),
          ),
          20.height,


          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Commodity selection
              BlocListener<LoadCommodityBloc, LoadCommodityState>(
                bloc: loadCommodityBloc,
                listener: (context, state) {
                  if (state is LoadCommodityError) {
                    ToastMessages.error(
                      message: getErrorMsg(errorType: state.errorType),
                    );
                  }
                },
                child: BlocBuilder<LoadCommodityBloc, LoadCommodityState>(
                  bloc: loadCommodityBloc,
                  builder: (context, state) {
                    if (state is LoadCommoditySuccess) {
                      final commodities = state.commodityListModel.data;
                      return LPCommodityDropdown(
                        preFixIcon: AppIcons.svg.commodity,
                        hintText: hintCommodity,
                        onSelect: (index) async {
                          selectedCommodity = commodities[index].name;
                          commodityId = commodities[index].id.toString();
                          setState(() {});
                        },
                        dataList: commodities,
                        selectedText: selectedCommodity,
                        onTab: () {
                          Navigator.of(context).push(createRoute(CommodityTypesScreen(
                            dataList: commodities,
                            onSelect:  (index) async {
                              selectedCommodity = commodities[index].name;
                              commodityId = commodities[index].id.toString();
                              fetchRateDiscovery();
                              setState(() {});
                            },
                          )));
                        },
                      ).paddingOnly(right: 10).expand();
                    }
                    return Container();
                  },
                ),
              ),


              // Consignment weight (MT)
              // Container(
              //   height: 55,
              //   padding: EdgeInsets.all(10),
              //   decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(AppIcons.svg.kgWeight),
              //       12.width,
              //       TextFormField(
              //         controller: weightTextController,
              //         autofocus: false,
              //         keyboardType: iosNumberKeyboard,
              //         inputFormatters: [
              //           phoneNumberInputFormatter
              //         ],
              //         decoration: InputDecoration(
              //           isDense: true,
              //           contentPadding: EdgeInsets.zero,
              //           border: InputBorder.none,
              //           hintText: context.appText.consignmentWeightWithMT,
              //           hintStyle: AppTextStyle.body,
              //           maintainHintHeight: true,
              //         ),
              //       ).expand(),
              //
              //       Text("MT ", style: AppTextStyle.body3GreyColor)
              //     ],
              //   ),
              // ).expand(),
              // Consignment weight (MT)
              BlocConsumer<LPHomeCubit, LPHomeState>(
                bloc: lpHomeCubit,
                listener: (context, state) {},
                builder: (context, state) {
                  final weights = state.loadWeightUIState?.data?.data ?? [];

                  return LPWeightDropdown(
                    preFixIcon: AppIcons.svg.kgWeight,
                    hintText: "Weight (MT)",
                    onSelect: (LoadWeightData weight) async {
                      weightTextController.text = weight.value.toString();
                      setState(() {});
                    },
                    dataList: weights,
                    selectedText: weightTextController.text.isEmpty ? null : "${weightTextController.text} MT",
                    onTab: () {
                      Navigator.of(context).push(
                        createRoute(
                          WeightSelectionScreen(
                            dataList: weights,
                            onSelect: (weight) {
                              lpHomeCubit.selectWeight(weight);
                              weightTextController.text = weight.value.toString();
                              setState(() {});
                            },
                            cubit: lpHomeCubit,
                          ),
                        ),
                      );
                    },
                    cubit: lpHomeCubit,
                  ).expand();
                },
              )
            ],
          ),
          10.height,


          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              // Truck selection
              BlocListener<LoadTruckTypeBloc, LoadTruckTypeState>(
                bloc: loadTruckTypeBloc,
                listener: (context, state) {
                  if (state is LoadTruckTypeError) {
                    ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
                  }
                },
                child: BlocBuilder<LoadTruckTypeBloc, LoadTruckTypeState>(
                  bloc: loadTruckTypeBloc,
                  builder: (context, state) {
                    if (state is LoadTruckTypeSuccess) {
                      final truckTypesList = state.loadTruckTypeListModel.data;
                      return LPTruckTypeDropdown(
                        preFixIcon: AppIcons.svg.truck,
                        hintText: "Truck Type",
                        onSelect: (TruckTypeData truck) async {
                          selectedTruck = "${truck.type} ${truck.subType}";
                          truckTypeId = truck.id.toString();
                          truckType = truck.type;
                          truckLength = truck.subType;
                          setState(() {});
                        },
                        dataList: truckTypesList,
                        selectedText: selectedTruck,
                        onTab: () {
                          Navigator.of(context).push(createRoute(TruckTypesScreen(
                            dataList: truckTypesList,
                            onSelect: (TruckTypeData truck) async {
                              selectedTruck = "${truck.type} ${truck.subType}";
                              truckTypeId = truck.id.toString();
                              truckType = truck.type;
                              truckLength = truck.subType;
                              fetchRateDiscovery();
                              setState(() {});
                            },
                          )));
                        },
                      ).paddingOnly(right: 10).expand();
                    }
                    return const SizedBox();
                  },
                ),
              ),

              // Date and Time
              InkWell(
                onTap: () async {

                  final String? date = await commonDatePicker(
                    context,
                    firstDate: DateTime.now(),
                    initialDate: DateTimeHelper.convertToDateTimeWithCurrentTime(dateTimeTextController.text),
                  );

                  if(!context.mounted) return;
                  final String? time = await commonTimePicker(context);

                  if (date != null && time != null) {
                    dateTimeTextController.text = "$date";
                    selectedDate = date;
                    selectedTime = time;
                  }
                  fetchRateDiscovery();
                  setState(() {});
                },
                child: Container(
                  height: 55,
                  padding: EdgeInsets.all(10),
                  decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.svg.calendar, width: 20, colorFilter: AppColors.svg(AppColors.primaryIconColor)),
                      10.width,

                      Text(dateTimeTextController.text.isEmpty ? "Pick-up date" : dateTimeTextController.text, style: AppTextStyle.body3, maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
                    ],
                  ),
                ),
              ).expand(),



            ],
          ),
          20.height,

          // Suggested Price
          Builder(
            builder: (context) {
              if(isFormValid()){
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Suggestion Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Suggested Price", style: AppTextStyle.bodyGreyColor),

                          BlocConsumer<LPHomeCubit, LPHomeState>(
                            bloc: lpHomeCubit,
                            listener: (context, state){
                              final status = state.rateDiscoveryUIState?.status;

                              if (status == Status.ERROR) {
                                final error = state.rateDiscoveryUIState?.errorType;
                                ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
                              }
                            },
                            builder: (context, state) {
                              if (state.rateDiscoveryUIState?.status == Status.SUCCESS) {
                                String? suggestedPrice = state.rateDiscoveryUIState?.data?.data?.price;
                                rateDiscoveryPrice = suggestedPrice ?? "00000 - 00000";
                                return Text("₹$rateDiscoveryPrice", style: AppTextStyle.body1);
                              }
                              return  Container();
                            },
                          ),

                        ],
                      ),
                      20.height,


                      Row(
                        children: [

                          // Need Customer Support Button
                          AppButton(
                            title: "Support",
                            style: AppButtonStyle.outline,
                            onPressed: (){
                              commonSupportDialog(context);
                            },
                          ).expand(),
                          10.width,

                          // Post Load Button
                          BlocConsumer<LoadPostingBloc, LoadPostingState>(
                            bloc: loadPostingBloc,
                            listenWhen: (previous, current) => previous != current,
                            listener: (context, state) {
                              if (state is CreateLoadSuccess) {
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is CreateLoadLoading;
                              return AppButton(
                                title: context.appText.postLoad,
                                isLoading: isLoading,
                                onPressed: isLoading ? (){} : () async {
                                  postLoad(context);
                                },
                              );
                            },
                          ).expand()

                        ],
                      )

                    ],
                  ),
                );
              } else {
                return Container();
              }
            }
          ),

        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding, vertical: 20),
    );
  }


  // Up-coming shipment
  Widget buildUpComingShipmentListWidget() {
    return BlocConsumer(
      bloc: loadDetailBloc,
      builder: (context, state) {
        return Container(
          decoration: commonContainerDecoration(borderRadius: BorderRadius.zero, shadow: true),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: commonSafeAreaPadding, horizontal: commonSafeAreaPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.appText.upComingShipment, style: AppTextStyle.body1).expand(),

                    // See More
                    if (getLoadResponse != null && getLoadResponse!.data.isNotEmpty)
                    TextButton(
                      onPressed: () {
                      },
                      style: AppButtonStyle.primaryTextButton,
                      child: Text(context.appText.seeMore, style: AppTextStyle.body3WhiteColor),
                    ),

                  ],
                ),
                15.height,

                Builder(
                  builder: (context) {
                    if (getLoadResponse != null) {
                      if (getLoadResponse!.data.isNotEmpty) {
                        final reversedList = getLoadResponse!.data.reversed.toList();
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: reversedList.length,
                          separatorBuilder: (BuildContext context, int index) => 20.height,
                          itemBuilder: (context, index) {
                            final loadData = reversedList[index];
                            return UpcomingShipmentsListBody(loadData: loadData);
                          },
                        );
                      } else {
                        return genericErrorWidget(error: NotFoundError());
                      }
                    } else {
                      return genericErrorWidget(error: GenericError());
                    }
                  },
                )


                ///Center(child: Image.asset(width: 201.w,height: 134.h,AppImage.png.noShipment))
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is GetLoadSuccess) {
          getLoadResponse = state.getLoadResponse;
          //    loadDetailBloc.add(GetLoadDetailsRequested(getLoadResponse!.data.first.id.toString()));
        } else if (state is GetLoadError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
    );
  }




}
