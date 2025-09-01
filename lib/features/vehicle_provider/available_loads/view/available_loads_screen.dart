import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/state_extension.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class AvailableLoadsScreen extends StatefulWidget {
  final bool isKycDone;
  const AvailableLoadsScreen({super.key, required this.isKycDone});

  @override
  State<AvailableLoadsScreen> createState() => _AvailableLoadsScreenState();
}

class _AvailableLoadsScreenState extends State<AvailableLoadsScreen> {

  final vpRecentLoadListBloc = locator<VpRecentLoadListBloc>();

  final searchController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    initFunction();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    disposeFunction();
    super.dispose();
  }

  void initFunction() => frameCallback(() async {
    vpRecentLoadListBloc.add(VpRecentLoadEvent());
  });

  void disposeFunction() => frameCallback(() {});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.availableLoads, scrolledUnderElevation: 0.0,),
      body: SafeArea(
        minimum: EdgeInsets.only(right: commonSafeAreaPadding, left: commonSafeAreaPadding, top: 20),
        bottom: false,
        child:  Column(
          children: [
            // Search Bar
            Row(
              children: [
                AppSearchBar(searchController: searchController).expand(),
                // 15.width,
                // AppIconButton(
                //   onPressed: (){
                //     commonBottomSheetWithBGBlur(context: context, screen: AvailableLoadsFilterScreen());
                //   },
                //   style: AppButtonStyle.primaryIconButtonStyle,
                //   icon: SvgPicture.asset(AppIcons.svg.filter, width: 20, colorFilter: AppColors.svg(AppColors.primaryColor)),
                // )
              ],
            ),
            10.height,

            // List
            BlocBuilder<VpRecentLoadListBloc, VpRecentLoadListState>(
              bloc: vpRecentLoadListBloc,
              builder: (context, state) {
                if (state is VpRecentLoadListLoading) {
                  return CircularProgressIndicator().center();
                }
                if (state is VpRecentLoadListError) {
                  return genericErrorWidget(error: state.errorType);
                }
                if (state is VpRecentLoadListSuccess) {
                  if(state.vpRecentLoadResponse.data.isNotEmpty){
                    return RefreshIndicator(
                      onRefresh: () async {
                         initFunction();
                      },
                      child: ListView.separated(
                        itemCount: state.vpRecentLoadResponse.data.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        physics: ScrollPhysics(),
                        separatorBuilder: (context, index) => 20.height,
                        itemBuilder: (context, index) {
                          final companyId = VpVariables.companyId ?? 0;
                          return RecentAddedLoadListBody(
                              kycStatus: 0,
                              data: state.vpRecentLoadResponse.data[index],isKycDone: widget.isKycDone, companyTypeId: companyId);
                        },
                      ),
                    );
                  }else{
                    return genericErrorWidget(error: NotFoundError());
                  }
                }
                return genericErrorWidget(error: GenericError());
              },
            ).expand(),

          ],
        ),
      ),
    );
  }
}
