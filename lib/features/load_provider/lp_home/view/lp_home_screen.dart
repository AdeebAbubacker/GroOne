import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/kyc_bottom_sheet.dart';
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
import 'package:gro_one_app/features/load_provider/lp_home/view/load_summary_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/lp_select_address_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/advance_payment_dailog.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/lp_commodity_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_home/view/widgets/lp_truck_type_dropdown.dart';
import 'package:gro_one_app/features/load_provider/lp_profile/view/lp_profile_screen.dart';
import 'package:gro_one_app/features/our_value_added_service/view/our_value_added_service_widget.dart';
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
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
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
  ProfileDetailResponse? profileResponse;
  GetLoadResponse? getLoadResponse;

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

  Map<String, dynamic>? destination;
  Map<String, dynamic>? pickup;

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

  bool selectedValueCommodity = false;
  bool selectedValueTruck = false;
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
    disposeFunction();
    _controller.removeListener(() {}); // if you store the listener separately
    _controller.dispose();
    super.dispose();
  }


  void initFunction() => addPostFrameCallback(() async {
    await lpHomeBloc.getUserId() ?? "";
    lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? ""));
    loadCommodityBloc.add(LoadCommodity());
    loadTruckTypeBloc.add(LoadTruckType());
    loadDetailBloc.add(GetLoadRequested(lpHomeBloc.userId ?? ""));
    await lpHomeCubit.startKycSuccessTimer();
  });

  void disposeFunction() => addPostFrameCallback(() {
    dateTimeTextController.clear();
    weightTextController.clear();
    pickup = null;
    destination = null;
    commodityId = null;
    truckTypeId = null;
    selectedTruck = null;
    selectedCommodity = null;
    rateDiscoveryPrice = null;
    selectedValueCommodity = false;
    selectedValueTruck = false;
    truckType = null;
    truckLength = null;
  });


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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
        child: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),
      ),
      actions: [

        // KYC
        if( _controller.value.isInitialized)
          Builder(
            builder: (builder){
              if(profileResponse != null && profileResponse?.data != null) {
                if(profileResponse?.data?.customer != null && (!profileResponse!.data!.customer!.isKyc)){
                  return kycWidget(
                    controller: _controller,
                    onTap: () {
                      commonBottomSheetWithBGBlur(context: context, screen: KycBottomSheet());
                    },
                  );
                }
              }
              return Container();
            }
        ),
        10.width,

        // Profile
        InkWell(
          onTap: (){
            Navigator.push(context, commonRoute(ProfileScreen(profileData: profileResponse!.data!), isForward: true)).then((v) {
              addPostFrameCallback(() =>  lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? "")));
            });
          },
          child: commonCacheNetworkImage(radius: 50,
              height: 40,
              width: 40,
              path:profileImage ?? "",
              errorImage: AppImage.png.userProfileError
          ).paddingRight(commonSafeAreaPadding),
        ),
      ],
    );
  }

  // Body
  Widget buildBodyWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        loadCommodityBloc.add(LoadCommodity());
        loadTruckTypeBloc.add(LoadTruckType());
        lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? ""));
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

                  BlocProvider<LPHomeCubit>.value(
                    value: locator<LPHomeCubit>(), // singleton from locator
                    child: BlocConsumer<LPHomeCubit, LPHomeState>(
                      listener: (context, state) {
                        print("State showSuccessKyc: ${state.showSuccessKyc}");
                      },
                      builder: (context, state) {
                        if (profileResponse != null && profileResponse?.data != null) {
                          if (profileResponse?.data?.customer != null && profileResponse!.data!.customer!.isKyc) {
                            if (state.showSuccessKyc) {
                              return kycSuccessStatusWidget();
                            } else {
                              return 20.height;
                            }
                          } else {
                            return buildKYCStatusWidget();
                          }
                        }
                        return 20.height;
                      },
                    ),
                  ),

                  bookShipmentSectionWidget(context),
                  20.height,
                  buildUpComingShipment(),
                  20.height,
                  buildValueAddedService(context),
                  30.height,
                ],
              ),
            );
          },
        ),
      ),
    );
  }


  // KYC Widget
  Widget buildKYCStatusWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      color: AppColors.appRedColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppImage.png.alertTriangle, width: 20),
          10.width,
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.appText.your,
                  style: AppTextStyle.textDarkGreyColor14w500,
                ),
                TextSpan(
                  text: "  ${context.appText.kyc}  ",
                  style: AppTextStyle.textDarkGreyColor14w500.copyWith(
                    color: AppColors.orangeTextColor,
                  ),
                ),
                TextSpan(
                  text: context.appText.stillPending,
                  style: AppTextStyle.textDarkGreyColor14w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUpComingShipment() {
    return BlocConsumer(
      bloc: loadDetailBloc,
      builder: (context, state) {
        return Container(
          color: AppColors.white,
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
                    builder: (context){
                      if(getLoadResponse != null){
                        if (getLoadResponse!.data.isNotEmpty) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: getLoadResponse!.data.length,
                            separatorBuilder: (BuildContext context, int index) => 20.height,
                            itemBuilder: (context, index) {
                              final loadData = getLoadResponse!.data[index];
                              return buildUpcomingShipmentListBody(loadData, context);
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

 Widget buildUpcomingShipmentListBody(LoadData loadData, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: commonContainerDecoration(color: AppColors.scaffoldBackgroundColor),
      child: Column(
        children: [

          Row(
            children: [
              Image.asset(AppImage.png.shipmentBox, height: 45, width: 45),
              10.width,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.idNumber, style: AppTextStyle.body4, maxLines: 1),
                  Text("GD12456", style: AppTextStyle.h5,  maxLines: 1),
                ],
              ).expand(),


              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: commonContainerDecoration(color: AppColors.lightPurpleColor, borderRadius: BorderRadius.circular(100)),
                child: Text("Sourcing", style: AppTextStyle.body4.copyWith(color: AppColors.purpleColor,),
                ),
              ),
              10.width,

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Vehicle Provider", style: AppTextStyle.body4,  maxLines: 1),
                  Text("Raj Sharma", style: AppTextStyle.h5,  maxLines: 1),
                ],
              ).expand(),
            ],
          ),

          commonDivider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loadData.dueDate != null ? DateTimeHelper.formatCustomDate(loadData.dueDate!) : "--", style: AppTextStyle.body4GreyColor),
                  Text(loadData.pickUpAddr, style: AppTextStyle.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ).expand(),

              Icon(Icons.arrow_forward, color: AppColors.primaryColor).paddingSymmetric(horizontal: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(loadData.dueDate != null ? DateTimeHelper.formatCustomDate(loadData.dueDate!) : "--",  style: AppTextStyle.body4GreyColor),
                  Text(loadData.dropAddr,  style: AppTextStyle.body, maxLines: 1),
                ],
              ).expand(),
            ],
          ),
          20.height,


          if (memoDone)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                  AppButton(
                    buttonHeight: 40,
                    style: AppButtonStyle.outline,
                    title: "Pay Now",
                    onPressed: () {
                      context.push(AppRouteName.lpPayNowAndTrackLoad);
                    },
                  ).expand(),
                  15.width,

                  AppButton(
                    buttonHeight: 40,
                    style: AppButtonStyle.outline,
                    title: "Track Load",
                    onPressed: () {
                      context.push(AppRouteName.lpPayNowAndTrackLoad);
                    },
                  ).expand(),

                ],
              )
            else
               AppButton(
                 buttonHeight: 40,
                 style: AppButtonStyle.outline,
                 title: context.appText.iAgreeTripToGo,
                 onPressed: () {
                   AppDialog.show(context, child: AdvancePaymentDialog());
                   //showAdvancePaymentDialogue(context: context);
                 },
               ),

        ],
      ),
    );
  }

  // Book Shipment
  Widget bookShipmentSectionWidget(BuildContext context) {
    // Inner inside Widget
    Widget bookShipmentWidget({
      required String heading,
      required String subHeading,
      required GestureTapCallback onClick,
    }) {
      return InkWell(
        onTap: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(heading, style: AppTextStyle.textGreyColor12w400),
                Text(subHeading, style: AppTextStyle.body, overflow: TextOverflow.ellipsis, maxLines: 1),
              ],
            ).expand(),
            Image.asset(AppImage.png.locationIcon, height: 18.h, width: 18.w),
          ],
        ),
      );
    }

    return Container(
      color: AppColors.white,
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

                Column(
                  children: [

                    // Source
                    bookShipmentWidget(
                      heading: context.appText.source,
                      subHeading: pickup?['address']?? context.appText.selectPickUpPoint,
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
                    bookShipmentWidget(
                      heading: context.appText.destination,
                      subHeading: destination?['address'] ?? context.appText.selectDestination,
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
          20.height,

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
                    viewDropDown: selectedValueCommodity,
                    onTab: () {
                      selectedValueCommodity = !selectedValueCommodity;
                      setState(() {});
                    },
                  ).paddingBottom(10);
                }
                return const SizedBox();
              },
            ),
          ),


          // Truck selection
          BlocListener<LoadTruckTypeBloc, LoadTruckTypeState>(
            bloc: loadTruckTypeBloc,
            listener: (context, state) {
              if (state is LoadTruckTypeError) {
                ToastMessages.error(
                  message: getErrorMsg(errorType: state.errorType),
                );
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
                    viewDropDown: selectedValueTruck,
                    onTab: () {
                      selectedValueTruck = !selectedValueTruck;
                      setState(() {});
                    },
                  ).paddingBottom(10);
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
                  12.width,

                  Text(dateTimeTextController.text.isEmpty ? context.appText.dateAndTime : dateTimeTextController.text, style: AppTextStyle.body).expand(),

                  Icon(Icons.keyboard_arrow_down, color: AppColors.greyIconColor, size: 20),
                ],
              ),
            ),
          ),
          20.height,

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
                  keyboardType: TextInputType.number,
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
          ),
          20.height,

          // Suggested Price
          Container(
            padding: EdgeInsets.all(10),
            decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                          return Text("₹$rateDiscoveryPrice", style: AppTextStyle.textBlackColor16w500);
                        }
                        return const SizedBox();
                      },
                    ),

                  ],
                ),

                SizedBox.shrink().expand(),

                // Post Load Button
                BlocConsumer<LoadPostingBloc, LoadPostingState>(
                  bloc: loadPostingBloc,
                  listener: (context, state) {
                    if (state is CreateLoadSuccess) {
                      disposeFunction();
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is CreateLoadLoading;
                    return AppButton(
                      title: context.appText.postLoad,
                      isLoading: isLoading,
                      onPressed: isLoading ? (){} : () async {
                        if (!profileResponse!.data!.customer!.isKyc) {

                          if(pickup == null){
                            ToastMessages.alert(message: "Please select pickup location");
                            return;
                          }

                          if(destination == null){
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

                          final request = CreateLoadApiRequest(
                            customerId: int.parse(lpHomeBloc.userId.toString()),
                            commodityId: int.parse(commodityId ?? "0"),
                            truckTypeId: int.parse(truckTypeId ?? "0"),
                            pickUpAddr: pickup?['address'] ?? "",
                            pickUpLatlon:  pickup?['latLng']??"",
                            dropAddr:  destination?['address'] ?? "",
                            dropLatlon:  destination?['latLng']??"",
                            dueDate: DateTimeHelper.convertStringToDateTime(dateTimeTextController.text).toString(),
                            consignmentWeight: int.parse(weightTextController.text.isEmpty ? "0" : weightTextController.text),
                            rate: rateDiscoveryPrice ?? "0000 - 0000",
                          );


                          Navigator.push(context, commonRoute(LoadSummaryScreen(
                            apiRequest: request,
                            senderAddress: pickup?['address'] ?? "",
                            receiverAddress: destination?['address'] ?? "",
                            vehicleType: truckType ?? "",
                            vehicleLength: truckLength ?? "",
                            approxWeight: weightTextController.text,
                            category: selectedCommodity ?? "",
                            price: rateDiscoveryPrice ?? "0000 - 0000",
                            date : dateTimeTextController.text,
                          ), isForward: true)).then((onValue){
                            loadDetailBloc.add(GetLoadRequested(lpHomeBloc.userId??"0"));
                            if(onValue!=null && onValue == true){
                              disposeFunction();
                            }
                          });

                        } else {
                          commonBottomSheetWithBGBlur(
                            screen: KycPendingDialogue(
                              onPressed: () {
                                context.pop();
                                commonBottomSheetWithBGBlur(context: context, screen: KycBottomSheet()).then((value) {
                                  lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? "0"),
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
                ).expand(flex: 2)

              ],
            ),
          ),
          20.height,


          // Need Support Next
          TextButton(
            onPressed: (){},
            child: Text("Need Our Customer Support Help?",style: AppTextStyle.h6PrimaryColor),
          ).align(Alignment.center),


        ],
      ).paddingSymmetric(horizontal: commonSafeAreaPadding, vertical: 20),
    );
  }



}
