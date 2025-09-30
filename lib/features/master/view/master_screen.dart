import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_vehicle_cubit/gps_vehicle_cubit.dart';
import 'package:gro_one_app/features/kyc/cubit/kyc_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_cubit.dart';
import 'package:gro_one_app/features/load_provider/lp_home/cubit/lp_home_state.dart';
import 'package:gro_one_app/features/master/widget/master_address_tab.dart';
import 'package:gro_one_app/features/master/widget/master_driver_tab.dart';
import 'package:gro_one_app/features/master/widget/master_vehicle_tab.dart';
import 'package:gro_one_app/features/master/widget/prefer_lanes_tab.dart';
import 'package:gro_one_app/features/profile/api_request/delete_vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_request.dart';
import 'package:gro_one_app/features/profile/api_request/vehicle_status_update_request.dart';
import 'package:gro_one_app/features/profile/cubit/masters/masters_cubit.dart';
import 'package:gro_one_app/features/profile/cubit/profile/profile_cubit.dart';
import 'package:gro_one_app/features/profile/model/profile_detail_model.dart';
import 'package:gro_one_app/features/profile/model/vehicle_list_response.dart';
import 'package:gro_one_app/features/profile/view/widgets/master_dialogue_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/cubit/vp_create_account_cubit.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/model/truck_type_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_json.dart';
import 'package:gro_one_app/utils/app_searchabledropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../data/ui_state/status.dart';

class MasterScreen extends StatefulWidget {
  final int? initialIndex;
  const MasterScreen({super.key, this.initialIndex});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen>
    with SingleTickerProviderStateMixin {
  final profileCubit = locator<ProfileCubit>();
  final mastersCubit = locator<MastersCubit>();
  final vpCreationCubit = locator<VpCreateAccountCubit>();
  final gpsVehicleCubit = locator<GpsVehicleCubit>();
  final lpHomeCubit = locator<LPHomeCubit>();
  List<String> selectedCommodities = [];
  late TabController _tabController;
  final vehicleSearchController = TextEditingController();
  final addressSearchController = TextEditingController();
  final driverSearchController = TextEditingController();
  Timer? vehicleSearchDebounce;
  Timer? addressSearchDebounce;
  Timer? driverSearchDebounce;
  final kycCubit = locator<KycCubit>();
  String? selectedTruckType;
  String? selectedTruckLength;
  String? truckLengthDropdownValue;
  bool showValidationErrors = false;
  List<Map<String, dynamic>> vehicleDocList = [];
  String? insuranceValidityDate;
  String? fcExpiryDate;
  String? pucExpiryDate;
  String? registrationDate;
  List<LaneDetailsResponse> laneDetails=[];






  @override
  void initState() {

    super.initState();
    context.read<MastersCubit>().resetVehicleVerification();
    _tabController = TabController(
      initialIndex: widget.initialIndex ?? 0,
      length: (kycCubit.userRole == 3 && (profileCubit.state.switchToVp??false)) ||  kycCubit.userRole==2 ?  4:3,
      vsync: this,
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    kycCubit.fetchStateList();
    initFunction();
  }

  @override
  void dispose() {
   disposeFunction();
    super.dispose();
  }

  List<Widget> getTabs(BuildContext context) {
    if (kycCubit.userRole == 2 || (kycCubit.userRole == 3 && (profileCubit.state.switchToVp??false))) {
      return [
        _buildTab(context.appText.lanes, _tabController.index == 0,0),
        _buildTab(context.appText.address, _tabController.index == 1,1),
        _buildTab(context.appText.vehicles, _tabController.index == 2,2),
        _buildTab(context.appText.drivers, _tabController.index == 3,3),
      ];
    } else {
      return [
        _buildTab(context.appText.address, _tabController.index == 0,0),
        _buildTab(context.appText.vehicles, _tabController.index == 1,1),
        _buildTab(context.appText.drivers, _tabController.index == 2,2),
      ];
    }

  }

  List<Widget> getTabViews() {
    if (kycCubit.userRole == 2 || (kycCubit.userRole == 3 && (profileCubit.state.switchToVp??false))) {
      return [
        PreferLanesTab(),
        BuildAddressTab(),
        BuildVehicleTab(),
        BuildDriverTab(),
      ];
    } else {
      return [
        BuildAddressTab(),
        BuildVehicleTab(),
        BuildDriverTab(),
      ];
    }
  }



  void initFunction() => frameCallback(() async {
    await kycCubit.fetchUserRole();
    await profileCubit.fetchProfileDetail();
    await vpCreationCubit.fetchPrefLane(null,isInit: true);
    _autoSelectPreSelectLanes();
    lpHomeCubit.fetchLoadWeight();
     _tabController.animation!.addListener(() {
    setState(() {}); 
  });
  });

  void _autoSelectPreSelectLanes()  {
    ProfileDetailModel? profileDetailModel= profileCubit.state.profileDetailUIState?.data;
    laneDetails =profileDetailModel?.customer?.laneDetails??[];
    if((laneDetails).isNotEmpty){
      vpCreationCubit.autoSelectLanes(laneDetails);
    }
    // profileDetailModel.vehicles

  }



  void disposeFunction() => frameCallback(() {
    _tabController.dispose();
    vehicleSearchDebounce?.cancel();
    addressSearchDebounce?.cancel();
    driverSearchDebounce?.cancel();
    vehicleSearchController.dispose();
    addressSearchController.dispose();
    driverSearchController.dispose();

    vpCreationCubit.clearSelectedLanes();
  });




  /// Delete Popup
  void showDeletePopUp({
    required BuildContext context,
    required String confirmMessage,
    required String successMessage,
    required Future<dynamic> Function() onDelete,
  }) {
    AppDialog.show(
      context,
      dismissible: true,
      child: CommonDialogView(
        hideCloseButton: true,
        showYesNoButtonButtons: true,
        noButtonText: context.appText.cancel,
        yesButtonText: context.appText.delete,
        yesButtonTextStyle: AppButtonStyle.deleteTextButton,
        child: Column(
          children: [
            Lottie.asset(
              AppJSON.alertRed,
              repeat: true,
              frameRate: FrameRate(200),
            ),
            Center(child: Text(confirmMessage, textAlign: TextAlign.center)),
          ],
        ),
        onClickYesButton: () async {
          final result = await onDelete();
          if (result is Success) {
            if (context.mounted) {
              Navigator.of(context).pop();
              ToastMessages.success(message: successMessage);
            }
          } else if (result is Error) {
            ToastMessages.error(message: getErrorMsg(errorType: result.type));
          }
        },
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected,int tabIndex) {
    double animationValue = _tabController.animation?.value ?? _tabController.index.toDouble();
  
  // The closer the tab is to the animation index, the more selected it appears
  bool isSelected = (animationValue - tabIndex).abs() < 0.5;

    return Container(
      height: 30,
      constraints: const BoxConstraints(
      minWidth: 120, 
    ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : AppColors.greyContainerBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          maxLines: 1,
          style: AppTextStyle.h6.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade100,
        appBar: CommonAppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            context.appText.masters,
            style: AppTextStyle.textBlackColor18w500,
          ),
        ),
        body: Column(
          children: [
           15.height,
          TabBar(
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.only(right: 15),
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.transparent, // selected tab bg
            borderRadius: BorderRadius.circular(30),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerHeight: 0,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white,
          labelStyle: AppTextStyle.h6.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTextStyle.h6,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs:  getTabs(context),
        ).paddingLeft(7),
        Expanded(
              child: TabBarView(
                controller: _tabController,
                children:  getTabViews(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Map<String, dynamic>? createFileFromLink(String url) {
    if (url.trim().isEmpty) return null;

    final uri = Uri.parse(url);
    if (uri.pathSegments.isEmpty) return null;

    final fileName = uri.pathSegments.last;
    final extension = fileName.split('.').last;

    return {"fileName": fileName, "path": url, "extension": extension};
  }
}

/// Read Only Textfield
Widget buildReadOnlyField(
  String label,
  String value, {
  Color? fillColor,
  TextStyle? textStyle,
  bool mandatoryStar = false,
  bool isEdit = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(label, style: AppTextStyle.textFiled),
          if (mandatoryStar)
            Text(
              " *",
              style: AppTextStyle.textFiled.copyWith(color: Colors.red),
            ),
        ],
      ),
      6.height,
      Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: commonContainerDecoration(
          color:   (isEdit) ?  AppColors.lightGreyColor:  AppColors.white,    
          borderRadius: BorderRadius.circular(commonTexFieldRadius),
          borderColor: AppColors.borderColor,
        ),
        child: Row(
          children: [
            Text(value, style:textStyle),
            Spacer(),
            SvgPicture.asset(AppIcons.svg.calendar),
          ],
        ),
      ),
    ],
  );
}


String? formatApiDateForVehicleVahan(String? apiDate) {
  if (apiDate == null || apiDate.isEmpty) return null;
  try {
    final parsed = DateFormat('dd-MMM-yyyy').parse(apiDate);
    return DateFormat('dd/MM/yyyy').format(parsed);
  } catch (_) {
    return apiDate;
  }
}
