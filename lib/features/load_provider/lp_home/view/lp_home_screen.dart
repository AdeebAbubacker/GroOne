import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/features/kyc/view/kyc_inProgress_dialogue.dart';
import 'package:gro_one_app/features/kyc/view/kyc_pending_dialogue.dart';
import 'package:gro_one_app/features/kyc/view/kyc_upload_document_screen.dart';
import 'package:gro_one_app/features/load_provider/lp_bottom_navigation/lp_bottom_navigation.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/create_load_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/api_request/rate_discovery_api_request.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_commodity/load_commodity_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_posting/load_posting_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/load_truck_type/load_truck_type_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/load_weight_model.dart';
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
import 'package:gro_one_app/features/load_provider/lp_loads/cubit/lp_load_cubit.dart';
import 'package:gro_one_app/features/our_value_added_services_view/our_value_added_services_widget.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/features/profile/view/profile_screen.dart';
import 'package:gro_one_app/helpers/date_helper.dart';
import 'package:gro_one_app/helpers/price_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/blue_membership_dialog_view.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
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


  final lpHomeBloc = locator<LpHomeBloc>();
  final loadPostingBloc = locator<LoadPostingBloc>();
  final loadCommodityBloc = locator<LoadCommodityBloc>();
  final loadTruckTypeBloc = locator<LoadTruckTypeBloc>();
  final lpHomeCubit = locator<LPHomeCubit>();
  final profileCubit = locator<ProfileCubit>();
  final lpLoadLocator = locator<LpLoadCubit>();


  final dateTimeTextController = TextEditingController();
  final weightTextController = TextEditingController();

  int selectedPercentage = 80;
  int baseAmount = 15000;
  int isKycValid = 0;

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
  String? selectedDateTime;
  String? laneId;
  String? sessionBlueId;
  String? minRate;
  String? maxRate;
  String? weightId;

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
    profileCubit.fetchProfileDetail();
    loadCommodityBloc.add(LoadCommodity());
    loadTruckTypeBloc.add(LoadTruckType());
    lpHomeCubit.fetchGetLoadList();
    lpHomeCubit.fetchRecentRoute();
    lpHomeCubit.fetchLoadWeight();
    lpHomeCubit.setBluIDFlag();
    clearAllValues();
  });

  void refreshLoadList(){
    lpHomeCubit.fetchGetLoadList();
  }

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
  });

  void clearAllValues(){
    dateTimeTextController.clear();
    weightTextController.clear();
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
    lpHomeCubit.state.copyWith(selectedWeight: null);
    lpHomeCubit.resetState();
    setState(() {});
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

  Future<void> fetchRateDiscovery() async {

    if (!isFormValid()) {
      return;
    }

    if (lpHomeCubit.state.laneId == null){
      ToastMessages.error(message: context.appText.landIdNull);
      return;
    }

    final req = RateDiscoveryApiRequest(
      laneId: lpHomeCubit.state.laneId.toString(),
      truckTypeId: truckTypeId ?? "",
      commodityId: commodityId,
      weightId: '${lpHomeCubit.state.selectedWeight?.id}',
      date: selectedDate
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


    // 3 Complete KYC | 2 In Progress kyc | 1 Pending Kyc
    if (isKycValid == 1) {
      kycBottomSheet(context);
      return;
    }

    if (isKycValid == 2) {
      String? firstPostedLoadId = await lpLoadLocator.getFirstPostedLoadId();

      if (firstPostedLoadId != null) {
        AppDialog.show(context, child: KycInProgressDialogue(onPressed: () {
          Navigator.pop(context);
        }));
        return;
      }
    }

    if(rateDiscoveryPrice == '00000') return;

    // Api Request store data in the class
    final request = CreateLoadApiRequest(
        commodityId: int.parse(commodityId ?? "0"),
        truckTypeId: int.parse(truckTypeId ?? "0"),
        pickUpAddr:  lpHomeCubit.state.pickup?.data?.address ?? "",
        pickUpLocation:  lpHomeCubit.state.pickup?.data?.location ?? "",
        pickUpLatlon:   lpHomeCubit.state.pickup?.data?.latLng ??"",
        dropAddr:   lpHomeCubit.state.destination?.data?.address ?? "",
        dropLocation:   lpHomeCubit.state.destination?.data?.location ?? "",
        dropLatlon:  lpHomeCubit.state. destination?.data?.latLng ??"",
        // dueDate: selectedDateTime.toString(),
        pickUpDateTime: selectedDateTime.toString() ,
        weightId: int.parse(lpHomeCubit.state.selectedWeight!.id.toString()),
        // rate: rateDiscoveryPrice ?? "0000 - 0000",
        rate: minRate,
        maxRate: maxRate,
        laneId: lpHomeCubit.state.laneId,
        // rateId: 0,
        rateId: lpHomeCubit.state.rateDiscoveryUIState?.data?.data?.rateDiscoveryId ?? 0,
        pickUpWholeAddr: lpHomeCubit.state.pickup?.data?.location ?? "",
        dropWholeAddr: lpHomeCubit.state.destination?.data?.location ?? "",
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
      isKycValid: isKycValid
    ), isForward: true)).then((onValue)async{
      if(onValue != null && onValue == true){
        clearAllValues();
        await lpHomeCubit.fetchLoadWeight();
        setState(() {});
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

  // Blue Membership Dialog
  void blueMembershipDialog(BuildContext context, String blueId)=> frameCallback(() {
    AppDialog.show(
      context,
      child: CommonDialogView(
        hideCloseButton: true,
        child: BlueMembershipDialogView(
          blueId: blueId,
        ),
      ),
    );
  });


  void navigateToLPSelectAddressScreen(state) {
    Navigator.of(context).push(commonRoute(LPSelectAddressScreen(
        title: context.appText.pickupPoint,
        address: state.pickup?.data?.address,
        location: state.pickup?.data?.location), isForward: true))
        .then((onValue) async {
      if (onValue != null && onValue == true) {
        await fetchRateDiscovery();
      }
    });
  }

  void navigateToRecentRouteScreen() {
    Navigator.of(context).push(createRoute(RecentRouteScreen()))
        .then((onValue) async {
      if (onValue != null && onValue == true) {
        await fetchRateDiscovery();
      }
    });
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
      leading: Image.asset(AppIcons.png.appIcon).paddingLeft(commonSafeAreaPadding),

      actions: [

        // Notification
        IconButton(
          onPressed: () {
            //Navigator.of(context).push(commonRoute(KycUploadDocumentScreen(aadhaarNumber: "000000000000")));
          },
          icon:  SvgPicture.asset(AppIcons.svg.notification, width: 30 ,colorFilter: AppColors.svg( AppColors.black)),
        ),

        // KYC Blinking
        BlocConsumer<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {},
          builder: (context, state) {
            final profileState = state.profileDetailUIState;

            if (profileState == null || profileState.status != Status.SUCCESS ||
                profileState.data == null || profileState.data?.customer == null) {
              return const SizedBox.shrink();
            }

            final customer = profileState.data!.customer!;
            final int kycFlag = customer.isKyc.toInt(); // 1 / 2 / 3
            final companyId = profileState.data!.customer?.companyTypeId;


            if (kycFlag == 3 || kycFlag == 2) {
              return const SizedBox.shrink();
            }

            if (kycFlag == 1) {
              return kycWidget(
                onTap: () {
                  if (companyId != null && (companyId == 2 || companyId == 1)) {
                    commonBottomSheetWithBGBlur(context: context, screen: EnterAadhaarNumberBottomSheet());
                  } else {
                    Navigator.of(context).push(commonRoute(KycUploadDocumentScreen()));
                  }
                },
              );
            } else {
              return const SizedBox.shrink();
            }

          },
        ),


        // Profile
        BlocConsumer<ProfileCubit, ProfileState>(
          bloc: profileCubit,
          listener: (context, state) {
            final status = state.profileDetailUIState?.status;

            if (status == Status.ERROR) {
              final error = state.profileDetailUIState?.errorType;
              ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
            }
          },
          builder: (context, state) {
            if (state.profileDetailUIState != null && state.profileDetailUIState?.status == Status.SUCCESS) {
              if (state.profileDetailUIState?.data != null && state.profileDetailUIState?.data?.customer != null) {
                final blueId = state.profileDetailUIState!.data!.customer?.blueId;
                return Row(
                  children: [
                    10.width,

                    // Profile
                    Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: commonContainerDecoration(borderColor: blueId != null && blueId.isNotEmpty ? AppColors.primaryColor : Colors.transparent, borderWidth : 2, borderRadius: BorderRadius.circular(100), color: AppColors.extraLightBackgroundGray),
                      child: Text(getInitialsFromName(this, name : state.profileDetailUIState!.data!.customer!.companyName)),
                    ).onClick((){
                      Navigator.push(context, commonRoute(ProfileScreen(), isForward: true)).then((v) {
                        // frameCallback(() =>  profileCubit.fetchProfileDetail());
                      });
                    }).paddingRight(commonSafeAreaPadding),
                  ],
                );
              }
            }
            return Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(100), color: AppColors.extraLightBackgroundGray),
              child: Text(getInitialsFromName(this, name : "")),
            ).onClick((){
              Navigator.push(context, commonRoute(ProfileScreen(), isForward: true));
            }).paddingRight(commonSafeAreaPadding);
          },
        ),

      ],
    );
  }

  // Body
  Widget buildBodyWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        initFunction();

      },
      child: SingleChildScrollView(
        child: BlocConsumer<LpHomeBloc, HomeState>(
          listener: (context, state) {
            if (state is ProfileDetailSuccess) {

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
                  buildKycLabelWidget(),
                  10.height,
                  OurValueAddedServicesWidget(),
                  10.height,
                  bookShipmentSectionWidget(context),
                  10.height,
                  buildUpComingShipmentListWidget(),
                  10.height,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Kyc Label
  Widget buildKycLabelWidget(){
    return BlocConsumer<ProfileCubit, ProfileState>(
      bloc: profileCubit,
      listenWhen: (previous, current) => previous.profileDetailUIState?.status != current.profileDetailUIState?.status,
      listener: (context, state)   async {
        final profileState = state.profileDetailUIState;

        if (profileState != null && profileState.status == Status.SUCCESS && profileState.data?.customer != null) {

          final blueIdFromApi = profileState.data!.customer!.blueId;
          final blueIdFlag = profileState.data!.customer?.blueIdFlg  ?? false;

          if (blueIdFromApi.isNotEmpty && blueIdFlag) {

            if (!context.mounted) return;
            sessionBlueId = blueIdFromApi;
            blueMembershipDialog(context, blueIdFromApi);

            await profileCubit.startKycSuccessTimer(true);
            // Set flag that popup is shown
            await  profileCubit.saveHasShowBluePopup(false);
          }

          profileCubit.startKycSuccessTimer(false);
        }
      },
      builder: (context, state) {
        final profileState = state.profileDetailUIState;

        if (profileState != null &&
            profileState.status == Status.SUCCESS &&
            profileState.data != null &&
            profileState.data?.customer != null) {

          final customer = profileState.data!.customer!;
          final companyId = profileState.data?.customer?.companyTypeId;

          isKycValid = customer.isKyc.toInt();

          if (customer.isKyc == 3) {
            return (state.showSuccessKyc) ? kycSuccessStatusWidget().paddingTop(10) :  0.width;
          } else if (customer.isKyc == 2) {
            return kycInProgressStatusWidget().paddingTop(10);
          } else if (customer.isKyc == 1) {
            return IncompleteKycStatusWidget(companyId: companyId).paddingTop(10);
          }
        }
        return  20.width;
      },
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
                  listener: (context, state){},
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
                          onClick: () async {
                            final uiState = state.recentRouteUIState;

                            if (uiState != null) {
                              switch (uiState.status) {
                                case Status.SUCCESS:
                                  if (uiState.data != null && uiState.data!.data.isNotEmpty && pickupLocation == null) {
                                    navigateToRecentRouteScreen();
                                  } else {
                                    ToastMessages.alert(message: context.appText.noRecentRouteFound);
                                    navigateToLPSelectAddressScreen(state);
                                  }
                                  break;

                                case Status.ERROR:
                                  navigateToLPSelectAddressScreen(state);
                                  break;
                                default:
                                  navigateToRecentRouteScreen();
                              }
                            } else {
                              navigateToLPSelectAddressScreen(state);
                            }
                          },

                        ),

                        commonDivider(),

                        // Destination
                        BookShipmentWidget(
                          heading: context.appText.destination,
                          subHeading: destinationLocation ?? context.appText.selectDestination,
                          onClick: () async {
                            Navigator.of(context).push(commonRoute(LPSelectAddressScreen(title: context.appText.selectDestinationTitle, address: state.destination!.data?.address, location: state.destination!.data?.location), isForward: true)).then((onValue) async {
                              if(onValue != null && onValue == true){
                                await fetchRateDiscovery();
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
                    ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
                  }
                },
                child: BlocBuilder<LoadCommodityBloc, LoadCommodityState>(
                  bloc: loadCommodityBloc,
                  builder: (context, state) {

                    if (state is LoadCommoditySuccess) {
                      final commodities = state.commodityListModel;

                      return LPCommodityDropdown(
                        preFixIcon: AppIcons.svg.commodity,
                        hintText: context.appText.commodity,
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
                            selectedIndex: commodities.indexWhere((element) => element.id.toString()==commodityId),
                            onSelect:  (index) async {
                              selectedCommodity = commodities[index].name;
                              commodityId = commodities[index].id.toString();
                              setState(() {});
                              await fetchRateDiscovery();
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
              BlocConsumer<LPHomeCubit, LPHomeState>(
                bloc: lpHomeCubit,
                listener: (context, state) {},
                builder: (context, state) {
                  final weights = state.loadWeightUIState?.data ?? [];
                  return LPWeightDropdown(
                    preFixIcon: AppIcons.svg.kgWeight,
                    hintText: context.appText.weightHintText,
                    onSelect: (LoadWeightModel weight) async {
                      weightTextController.text = weight.value.toString();
                      setState(() {});
                    },
                    dataList: weights,
                    selectedText: weightTextController.text.isEmpty ? null : "${weightTextController.text} MT",
                    onTab: () async {
                      Navigator.of(context).push(createRoute(WeightSelectionScreen(
                            dataList: weights,
                            onSelect: (weight) async {
                              lpHomeCubit.selectWeight(weight);
                              weightTextController.text = weight.value.toString();
                              setState(() {});
                              await fetchRateDiscovery();
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
                      final truckTypesList = state.loadTruckTypeListModel;
                      return LPTruckTypeDropdown(
                        preFixIcon: AppIcons.svg.truck,
                        hintText: context.appText.truckType,
                        onSelect: ( truck) async {
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
                            onSelect: (truck) async {
                              selectedTruck = "${truck.type} ${truck.subType}";
                              truckTypeId = truck.id.toString();
                              truckType = truck.type;
                              truckLength = truck.subType;
                              await fetchRateDiscovery();
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
                   String? time = await commonTimePicker(context);


                  if (date != null && time != null) {
                    dateTimeTextController.text = date;
                    selectedDate = DateTimeHelper.convertToDatabaseFormat2(date);
                    selectedTime = time;
                    selectedDateTime = DateTimeHelper.convertToApiDateTime(date, time!);

                  }
                  await fetchRateDiscovery();
                },
                child: Container(
                  height: 55,
                  padding: EdgeInsets.all(10),
                  decoration: commonContainerDecoration(color: AppColors.lightPrimaryColor2, borderColor: AppColors.borderColor),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.svg.calendar, width: 20, colorFilter: AppColors.svg(AppColors.primaryIconColor)),
                      10.width,

                      Text(dateTimeTextController.text.isEmpty ? context.appText.pickUpdate : dateTimeTextController.text, style: AppTextStyle.body, maxLines: 1, overflow: TextOverflow.ellipsis).expand(),
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
                          Text(context.appText.suggestedPrice, style: AppTextStyle.bodyGreyColor),

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

                                final data = state.rateDiscoveryUIState?.data?.data;

                                String? suggestedPrice;
                                if (data?.minPrice != null) {
                                  if (data?.maxPrice == null || data?.maxPrice == 0) {
                                    suggestedPrice = data?.minPrice.toString();
                                  } else {
                                    suggestedPrice = "${data?.minPrice} - ${data?.maxPrice}";
                                  }
                                  minRate = data?.minPrice.toString();
                                  maxRate = data?.maxPrice.toString();
                                } else {
                                  suggestedPrice = "00000";
                                }

                                rateDiscoveryPrice = suggestedPrice;

                                String formattedPrice;
                                if (data?.minPrice == null) {
                                  formattedPrice = "₹0";
                                } else if (data?.maxPrice == null || data?.maxPrice == 0) {
                                  formattedPrice = PriceHelper.formatINR(data!.minPrice);
                                } else {
                                  formattedPrice = PriceHelper.formatINRRange('${data?.minPrice} - ${data?.maxPrice}');
                                }

                                return Text(
                                  formattedPrice ?? '',
                                  style: AppTextStyle.body1,
                                );
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
                            title: context.appText.support,
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
    return BlocConsumer<LPHomeCubit, LPHomeState>(
      bloc: lpHomeCubit,
      listenWhen: (previous, current) =>  previous.lpGetLoadUIState != current.lpGetLoadUIState,
      listener: (context, state) {
        final status = state.lpGetLoadUIState?.status;
        if (status == Status.ERROR) {
          final error = state.lpGetLoadUIState?.errorType;
          ToastMessages.error(message: getErrorMsg(errorType: error ?? GenericError()));
        }
      },
      builder: (context, state) {
        return Container(
          decoration: commonContainerDecoration(borderRadius: BorderRadius.zero, shadow: true),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: commonSafeAreaPadding, horizontal: commonSafeAreaPadding),
            child: Builder(
              builder: (context) {
                if(state.lpGetLoadUIState != null && state.lpGetLoadUIState?.status != null){
                  switch (state.lpGetLoadUIState!.status){
                    case Status.LOADING :
                      return CircularProgressIndicator().center();
                    case Status.SUCCESS :
                      if(state.lpGetLoadUIState?.data != null){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.appText.upComingShipment, style: AppTextStyle.body1).expand(),

                                // See More
                                if(state.lpGetLoadUIState!.data!.data.isNotEmpty)
                                TextButton(
                                  onPressed: () {
                                    LpBottomNavigation.selectedIndexNotifier.value = 1;
                                  },
                                  style: AppButtonStyle.primaryTextButton,
                                  child: Text(context.appText.seeMore, style: AppTextStyle.body3WhiteColor),
                                ),

                              ],
                            ),
                            15.height,

                            if(state.lpGetLoadUIState!.data!.data.isNotEmpty)
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: state.lpGetLoadUIState!.data!.data.length,
                                separatorBuilder: (BuildContext context, int index) => 20.height,
                                itemBuilder: (context, index) {
                                  final loadData = state.lpGetLoadUIState!.data!.data[index];
                                  return UpcomingShipmentsListBody(loadData: loadData);
                                },
                              )
                            else
                              buildGenericError(error: NotFoundError())
                          ],
                        );
                      } else {
                        return buildGenericError(error: ConflictError());
                      }
                    case Status.ERROR :
                      if(state.lpGetLoadUIState?.errorType != null){
                        return buildGenericError(error: state.lpGetLoadUIState!.errorType);
                      }else{
                        return  buildGenericError(error: GenericError());
                      }
                    default :
                      return  buildGenericError(error: GenericError());
                  }
                } else {
                  return  buildGenericError(error: GenericError());
                }
              },
            ),
          ),
        );
      },
    );
  }


  Widget buildGenericError({dynamic error}) => genericErrorWidget(error: error ?? GenericError(), onRefresh: () => refreshLoadList()).paddingOnly(top: 50);


}
