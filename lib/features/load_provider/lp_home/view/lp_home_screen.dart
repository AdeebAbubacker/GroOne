import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
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
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/commodity_types_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/load_summary_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_select_address_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/recent_route_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/truck_type_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/advance_payment_dailog.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/book_shipment_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/incomplete_kyc_status_widget.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/lp_commodity_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/lp_truck_type_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/upcoming_shipments_list_body.dart';
import 'package:gro_one_app/features/our_value_added_service/view/our_value_added_service_widget.dart';
import 'package:gro_one_app/features/our_value_added_services_view/our_value_added_services_widget.dart';
import 'package:gro_one_app/features/profile/view/profile_screen.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/app_video.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
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

  late VideoPlayerController _controller;
  ProfileDetailModel? profileResponse;
  LPGetLoadModel? getLoadResponse;

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
    initializeVideoPlayer(context);
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    disposeFunction(context);
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }


  void initFunction() => frameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? ""));
    loadCommodityBloc.add(LoadCommodity());
    loadTruckTypeBloc.add(LoadTruckType());
    loadDetailBloc.add(GetLoadRequested(lpHomeBloc.userId ?? ""));
    await lpHomeCubit.startKycSuccessTimer();
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

  void clearAllValues(BuildContext context){
    dateTimeTextController.clear();
    weightTextController.clear();
    lpHomeCubit.clearPickUpAndDestination();
    commodityId = null;
    truckTypeId = null;
    selectedTruck = null;
    selectedCommodity = null;
    rateDiscoveryPrice = null;
    truckType = null;
    truckLength = null;
    commonHideKeyboard(context);
  }


  void initializeVideoPlayer(BuildContext context){
    _controller = VideoPlayerController.asset(AppVideo.kycBlinking)
      ..initialize().then((_) {
        if (mounted) {
          _controller.play();
          setState(() {});
        }
      });
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration && _controller.value.isInitialized && mounted) {
        setState((){});
      }
    });
  }



  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
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
        child: InkWell(
          onTap: (){
            // AppDialog.show(context, child: SuccessDialogView(message: "Load Accepted Successfully"));
          },
            child: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding)),
      ),
      actions: [

        IconButton(
          onPressed: () {},
          icon:  SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),

        // KYC
        BlocProvider<LPHomeCubit>.value(
          value: locator<LPHomeCubit>(), // singleton from locator
          child: BlocConsumer<LPHomeCubit, LPHomeState>(
            listener: (context, state) { },
            builder: (context, state) {
              if (profileResponse != null && profileResponse?.data != null) {
                if (profileResponse?.data?.customer != null && profileResponse!.data!.customer!.isKyc == 3) {
                  if (state.showSuccessKyc) {
                    return kycWidget(
                      controller: _controller,
                      onTap: () {
                        commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                      },
                    );
                  } else {
                    return 0.width;
                  }
                } else {
                  return kycWidget(
                    controller: _controller,
                    onTap: () {
                      commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                    },
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
                InkWell(
                    onTap: (){
                      Navigator.push(context, commonRoute(ProfileScreen(profileData: profileResponse!.data!), isForward: true)).then((v) {
                        frameCallback(() =>  lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? "")));
                      });
                    },
                    child: Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.greyIconBackgroundColor),
                        child: Text(_getInitials(state.profileDetailResponse.data?.details?.companyName ?? ''),
                    )
                ).paddingRight(commonSafeAreaPadding),
              ),
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
              profileImage = state.profileDetailResponse.data!.details!.profileImageUrl ?? "";
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

                BlocBuilder<LPHomeCubit, LPHomeState>(
                  bloc: lpHomeCubit,
                  builder: (context, state){
                    return Column(
                      children: [

                        // Source
                        BookShipmentWidget(
                          heading: context.appText.source,
                          subHeading: state.pickup != null ? ("${state.pickup!['location'].toString().capitalizeFirst}, ${state.pickup!["address"].toString().capitalizeFirst}") :  context.appText.selectPickUpPoint,
                          onClick: () {

                            // if (state.pickup != null){
                            //   Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: "Pickup Point", address: state.pickup?['address'], location: state.pickup?['location']), isForward: true));
                            // } else {
                            //   Navigator.of(context).push(createRoute(RecentRouteScreen()));
                            // }

                            Navigator.of(context).push(createRoute(RecentRouteScreen())).then((onValue){
                              if(onValue != null && onValue == true){
                                debugPrint("Pick up : ${state.pickup}");
                                debugPrint("Destination : ${state.destination}");
                                dynamic req = RateDiscoveryApiRequest(pickup: "bangalore", drop: "chennai");
                                rateDiscoveryBloc.add(RateDiscoveryEvent(apiRequest: req));
                                setState(() {});
                              }
                            });

                          },
                        ),

                        commonDivider(),

                        // Destination
                        BookShipmentWidget(
                          heading: context.appText.destination,
                          subHeading: state.destination != null ? ("${state.destination!['location'].toString().capitalizeFirst}, ${state.destination!["address"].toString().capitalizeFirst}") :  context.appText.selectDestination,
                          onClick: () {

                            Navigator.of(context).push(commonRoute(LPSelectAddressScreen(
                              title: "Select Destination",
                              address: state.destination?['address'],
                              location: state.destination?['location'],
                            ), isForward: true)).then((onValue){
                              if(onValue != null && onValue == true){
                                 debugPrint("Destination: ${state.destination}");
                                dynamic req = RateDiscoveryApiRequest(pickup: "bangalore", drop: "chennai");
                                rateDiscoveryBloc.add(RateDiscoveryEvent(apiRequest: req));
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
                              setState(() {});
                            },
                          )));
                        },
                      ).paddingBottom(10);
                    }
                    return const SizedBox();
                  },
                ),
              ).expand(),
              15.width,

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
                        hintText: hintTruck,
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
                              setState(() {});
                            },
                          )));
                          setState(() {});
                        },
                      ).paddingBottom(10);
                    }
                    return const SizedBox();
                  },
                ),
              ).expand(),
            ],
          ),


          Row(
            children: [

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
                    dateTimeTextController.text = "$date - $time";
                    selectedDate = date;
                    selectedTime = time;
                  }
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

                      Text(dateTimeTextController.text.isEmpty ? context.appText.dateAndTime : dateTimeTextController.text, style: AppTextStyle.body3).expand(),
                    ],
                  ),
                ),
              ).expand(),
              15.width,

              // Consignment weight (MT)
              Container(
                height: 55,
                padding: EdgeInsets.all(10),
                decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
                child: Row(
                  children: [
                    SvgPicture.asset(AppIcons.svg.kgWeight),
                    12.width,
                    TextFormField(
                      controller: weightTextController,
                      autofocus: false,
                      keyboardType: iosNumberKeyboard,
                      inputFormatters: [
                        phoneNumberInputFormatter
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: context.appText.consignmentWeightWithMT,
                        hintStyle: AppTextStyle.body,
                        maintainHintHeight: true,
                      ),
                    ).expand(),
                  ],
                ),
              ).expand(),
            ],
          ),
          20.height,

          // Suggested Price
          Container(
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

                    BlocConsumer<RateDiscoveryBloc, RateDiscoveryState>(
                      listener: (context, state){
                        if(state is RateDiscoveryError){
                          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
                        }
                      },
                      bloc: rateDiscoveryBloc,
                      builder: (context, state) {
                        if (state is RateDiscoverySuccess) {
                          final suggestedPrice = state.rateDiscoveryModel.data;
                          rateDiscoveryPrice = suggestedPrice?.price ?? "00000 - 00000";
                          return Text("₹$rateDiscoveryPrice", style: AppTextStyle.body1);
                        }
                        return const SizedBox();
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
                      listener: (context, state) {
                        if (state is CreateLoadSuccess) {
                          clearAllValues(context);
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is CreateLoadLoading;
                        return AppButton(
                          title: context.appText.postLoad,
                          isLoading: isLoading,
                          onPressed: isLoading ? (){} : () async {
                            if (profileResponse!.data!.customer!.isKyc != 3) {

                              if(lpHomeCubit.state.pickup == null){
                                ToastMessages.alert(message: "Please select pickup location");
                                return;
                              }

                              if(lpHomeCubit.state.destination == null){
                                ToastMessages.alert(message: "Please select destination location");
                                return;
                              }

                              if(commodityId == null){
                                ToastMessages.alert(message: "Please select commodity");
                                return;
                              }

                              if(truckTypeId == null){
                                ToastMessages.alert(message: "Please select truck");
                                return;
                              }

                              if(dateTimeTextController.text.isEmpty){
                                ToastMessages.alert(message: "Please select date");
                                return;
                              }

                              if(weightTextController.text.isEmpty){
                                ToastMessages.alert(message: "Please select consignment weight");
                                return;
                              }

                              if (lpHomeCubit.state.pickup == null && lpHomeCubit.state.destination == null){
                                ToastMessages.alert(message: "Something went wrong");
                                return;
                              }

                              final request = CreateLoadApiRequest(
                                customerId: int.parse(lpHomeBloc.userId.toString()),
                                commodityId: int.parse(commodityId ?? "0"),
                                truckTypeId: int.parse(truckTypeId ?? "0"),
                                pickUpAddr:  lpHomeCubit.state.pickup?['address'] ?? "",
                                pickUpLatlon:   lpHomeCubit.state.pickup?['latLng']??"",
                                dropAddr:   lpHomeCubit.state.destination?['address'] ?? "",
                                dropLatlon:  lpHomeCubit.state. destination?['latLng']??"",
                                dueDate: DateTimeHelper.convertStringToDateTime(dateTimeTextController.text).toString(),
                                consignmentWeight: int.parse(weightTextController.text.isEmpty ? "0" : weightTextController.text),
                                rate: rateDiscoveryPrice ?? "0000 - 0000",
                                laneId: int.parse(lpHomeCubit.state.pickup?["laneId"] ?? "0")
                              );


                              Navigator.push(context, commonRoute(LoadSummaryScreen(
                                apiRequest: request,
                                pickupAddress:  lpHomeCubit.state.pickup!['address'] ?? "",
                                pickupLocation: lpHomeCubit.state.pickup!['location'] ?? "",
                                destinationAddress:  lpHomeCubit.state.destination!['address'] ?? "",
                                destinationLocation: lpHomeCubit.state.destination!['location'] ?? "",
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
                                  clearAllValues(context);
                                }
                              });

                            } else {
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
                          },
                        );
                      },
                    ).expand()
                  ],
                )

              ],
            ),
          ),
          20.height,


          // Need Support Next
          TextButton(
            onPressed: (){
              commonSupportDialog(context);
            },
            child: Text("Need Our Customer Support Help?",style: AppTextStyle.h5PrimaryColor),
          ).align(Alignment.center),


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
