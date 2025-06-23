import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kyc/view/enter_aadhaar_number_bottom_sheet.dart';
import 'package:gro_one_app/features/kyc/view/kyc_pending_dialogue.dart';
import 'package:gro_one_app/features/load_provider/lp_home/bloc/lp_home/lp_home_bloc.dart';
import 'package:gro_one_app/features/load_provider/lp_home/model/profile_detail_response_model.dart';
import 'package:gro_one_app/features/our_value_added_services_view/our_value_added_services_widget.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_bottom_navigation/vp_bottom_navigation.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_creation/bloc/vp_creation_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/bloc/vp_recent_load_list/vp_recent_load_list_bloc.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/model/vp_my_load_response.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/my_loads_list_body.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_home/view/widgets/recent_added_load_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
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
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../../utils/app_dialog.dart';
import '../../../../utils/common_dialog_view/success_dialog_view.dart';
import '../../../load_provider/lp_home/cubit/lp_home_cubit.dart';
import '../../../load_provider/lp_home/cubit/lp_home_state.dart';
import '../../../load_provider/lp_home/view/widgets/incomplete_kyc_status_widget.dart';
import '../bloc/load_accpect/vp_accept_load_bloc.dart';
import '../bloc/load_accpect/vp_accept_load_state.dart';
import '../bloc/vp_home_bloc/vp_home_bloc.dart';

class VpHomeScreen extends StatefulWidget {
  final void Function(int bottomTabIndex, {int? allLoadsSubTabIndex})
  onViewAllOrSeeMore;

  const VpHomeScreen({super.key, required this.onViewAllOrSeeMore});

  @override
  State<VpHomeScreen> createState() => _VpHomeScreenState();
}

class _VpHomeScreenState extends State<VpHomeScreen> {

  String profileImage = "";
  final vpHomeBloc = locator<VpCreationBloc>();
  final lpHomeBloc = locator<LpHomeBloc>();
  final vpHomeScreenBloc = locator<VpHomeBloc>();
  final vpRecentLoadListBloc = locator<VpRecentLoadListBloc>();
  final searchController = TextEditingController();
  ProfileDetailModel? profileResponse;
  VpMyLoadResponse? vpMyLoadResponse;
  bool showKycSuccessBanner = false;
  final lpHomeCubit = locator<LPHomeCubit>();

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
    vpRecentLoadListBloc.add(VpRecentLoadEvent());
    vpHomeScreenBloc.add(VpMyLoadListRequested());
    await lpHomeBloc.getUserId() ?? "";
    lpHomeBloc.add(GetProfileDetailApiRequest(lpHomeBloc.userId ?? ""));
    await lpHomeCubit.startKycSuccessTimer();
  });

  void disposeFunction() => frameCallback(() {});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        initFunction();
      },
      child: SafeArea(
        child:
            BlocConsumer<LpHomeBloc, HomeState>(
              bloc: lpHomeBloc,
              listener: (context, state) {
                if (state is ProfileDetailSuccess) {
                  profileResponse = state.profileDetailResponse;
                  profileImage =
                      state
                          .profileDetailResponse
                          .data!
                          .details!
                          .profileImageUrl ??
                      "";
                  setState(() {});
                }
                if (state is ProfileDetailError) {
                  ToastMessages.error(
                    message: getErrorMsg(errorType: state.errorType),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    BlocBuilder<LPHomeCubit, LPHomeState>(
                      builder: (context, state) {
                        if (profileResponse != null &&
                            profileResponse?.data != null) {
                          if (profileResponse?.data?.customer != null &&
                              profileResponse!.data!.customer!.isKyc == 3) {
                            if (state.showSuccessKyc) {
                              return kycSuccessStatusWidget();
                            } else {
                              return 0.height;
                            }
                          } else if (profileResponse!.data!.customer!.isKyc ==
                              2) {
                            return kycInProgressStatusWidget();
                          } else {
                            return IncompleteKycStatusWidget();
                          }
                        }
                        return 20.height;
                      },
                    ),
                    20.height,
                    OurValueAddedServicesWidget(),
                    20.height,
                    _buildMyLoadsWidget(context),
                    20.height,
                    _buildRecentAddedLoadWidget(context),
                  ],
                );
              },
            ).withScroll(),
      ),
    );
  }

  /// My Loads
  Widget _buildMyLoadsWidget(BuildContext context) {
    return BlocConsumer(
      listener: (context, state) {
        if (state is VpMyLoadListSuccess) {
          vpMyLoadResponse = state.vpMyLoadResponse;
        }
      },
      bloc: vpHomeScreenBloc,
      builder: (context, state) {
        if (state is VpMyLoadListSuccess) {
          // Check if data is empty, return empty widget
          if (state.vpMyLoadResponse.data.isEmpty) {
            return const SizedBox.shrink(); // Hides the entire widget
          }

          vpMyLoadResponse = state.vpMyLoadResponse;

          return Container(
            decoration: commonContainerDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,

                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.appText.myLoads,
                      textAlign: TextAlign.start,
                      style: AppTextStyle.body1,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.onViewAllOrSeeMore(1, allLoadsSubTabIndex: 1);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: Size(68, 30),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "View All",
                        style: AppTextStyle.h5WhiteColor,
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     widget.onViewAllOrSeeMore(1, allLoadsSubTabIndex: 1);
                    //   },
                    //   style: AppButtonStyle.primaryTextButton,
                    //   child: Text("View All", style: AppTextStyle.h5WhiteColor),
                    // ),
                  ],
                ),
                10.height,

                // List
                ListView.separated(
                  itemCount:
                      state.vpMyLoadResponse.data.length > 3
                          ? 3
                          : state.vpMyLoadResponse.data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => 20.height,
                  itemBuilder: (context, index) {
                    final data = state.vpMyLoadResponse.data[index];
                    return MyLoadsListBody(
                      data: data,
                      onClickAssignDriver: () {
                        final isKycDone = VpVariables.isKycVerified;
                        if (isKycDone) {
                          // Navigate to trip scheduling
                        } else {
                          commonBottomSheetWithBGBlur(
                            context: context,
                            screen: KycPendingDialogue(
                              onPressed: () {
                                context.pop();
                                commonBottomSheetWithBGBlur(
                                  context: context,
                                  screen: EnterAadhaarNumberBottomSheet(),
                                ).then((_) {
                                  lpHomeBloc.add(
                                    GetProfileDetailApiRequest(
                                      lpHomeBloc.userId ?? "0",
                                    ),
                                  );
                                });
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                20.height,
              ],
            ).paddingSymmetric(horizontal: commonSafeAreaPadding),
          );
        }

        if (state is VpMyLoadListError) {
          return genericErrorWidget(error: state.errorType);
        }

        if (state is VpMyLoadListLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          ).paddingSymmetric(vertical: 100);
        }

        return genericErrorWidget(error: GenericError());
      },
    );
  }

  // Widget _buildMyLoadsWidget(BuildContext context) {
  //   return BlocConsumer(
  //     listener: (context, state) {
  //       if (state is VpMyLoadListSuccess) {
  //         vpMyLoadResponse = state.vpMyLoadResponse;
  //       }
  //     },
  //     bloc: vpHomeScreenBloc,
  //     builder: (context, state) {
  //       if (state is VpMyLoadListSuccess) {
  //         return Container(
  //           decoration: commonContainerDecoration(
  //             borderRadius: BorderRadius.circular(0),
  //           ),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               10.height,
  //
  //               // Title
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     context.appText.myLoads,
  //                     textAlign: TextAlign.start,
  //                     style: AppTextStyle.body1,
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       widget.onViewAllOrSeeMore(1, allLoadsSubTabIndex: 1);
  //                     },
  //                     style: AppButtonStyle.primaryTextButton,
  //                     child: Text("View All", style: AppTextStyle.h5WhiteColor),
  //                   ),
  //                 ],
  //               ),
  //               10.height,
  //
  //               // List
  //               Builder(
  //                 builder: (context) {
  //                   if (vpMyLoadResponse == null) {
  //                     return const Center(child: CircularProgressIndicator());
  //                   }
  //
  //                   if (vpMyLoadResponse!.data.isEmpty) {
  //                     return Center(
  //                       child: Image.asset(
  //                         AppImage.png.noShipment,
  //                         width: 201.w,
  //                         height: 134.h,
  //                       ),
  //                     );
  //                   }
  //
  //                   return ListView.separated(
  //                     itemCount:
  //                         vpMyLoadResponse!.data.length > 3
  //                             ? 3
  //                             : vpMyLoadResponse!.data.length,
  //                     shrinkWrap: true,
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     separatorBuilder: (context, index) => 20.height,
  //                     itemBuilder: (context, index) {
  //                       final data = vpMyLoadResponse!.data[index];
  //                       return MyLoadsListBody(
  //                         data: data,
  //                         onClickAssignDriver: () {
  //                           final isKycDone = VpVariables.isKycVerified;
  //                           if (isKycDone) {
  //                             // Navigator.of(context).push(createRoute(TripSchedulingScreen(data: data, allProfileDetails: profileResponse!.data!)));
  //                           } else {
  //                             commonBottomSheetWithBGBlur(
  //                               context: context,
  //                               screen: KycPendingDialogue(
  //                                 onPressed: () {
  //                                   context.pop();
  //                                   commonBottomSheetWithBGBlur(
  //                                     context: context,
  //                                     screen: EnterAadhaarNumberBottomSheet(),
  //                                   ).then((_) {
  //                                     lpHomeBloc.add(
  //                                       GetProfileDetailApiRequest(
  //                                         lpHomeBloc.userId ?? "0",
  //                                       ),
  //                                     );
  //                                   });
  //                                 },
  //                               ),
  //                             );
  //                           }
  //                         },
  //                       );
  //                     },
  //                   );
  //                 },
  //               ),
  //               20.height,
  //             ],
  //           ).paddingSymmetric(horizontal: commonSafeAreaPadding),
  //         );
  //       }
  //       if (state is VpMyLoadListError) {
  //         return genericErrorWidget(error: state.errorType);
  //       }
  //       if (state is VpMyLoadListLoading) {
  //         return CircularProgressIndicator()
  //             .paddingSymmetric(vertical: 100)
  //             .center();
  //       } else {
  //         return genericErrorWidget(error: GenericError());
  //       }
  //     },
  //   );
  // }

  /// Recent Loads
  Widget _buildRecentAddedLoadWidget(BuildContext context) {
    return BlocListener<VpAcceptLoadBloc, VpAcceptLoadState>(
      bloc: locator<VpAcceptLoadBloc>(),
      listener: (context, state) {
        if (state is VpAcceptLoadSuccess) {
          vpRecentLoadListBloc.add(VpRecentLoadEvent());
          vpHomeScreenBloc.add(VpMyLoadListRequested());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              AppDialog.show(
                context,
                child: SuccessDialogView(
                  message: 'Load Accepted Successfully',
                  afterDismiss: () {
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              );
            }
          });
        }
        if (state is VpAcceptLoadError) {
          ToastMessages.error(message: getErrorMsg(errorType: state.errorType));
        }
      },
      child: Container(
        decoration: commonContainerDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            10.height,
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.appText.availableLoads,
                  style: AppTextStyle.body1,
                ).expand(),
                ElevatedButton(
                  onPressed: () {
                    widget.onViewAllOrSeeMore(1, allLoadsSubTabIndex: 0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: Size(68, 30),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    context.appText.seeMore,
                    style: AppTextStyle.h5WhiteColor,
                  ),
                ),
              ],
            ),
            20.height,
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
                  final loads = state.vpRecentLoadResponse.data;
                  if (loads.isEmpty) {
                    return genericErrorWidget(error: NotFoundError());
                  }
                  return ListView.separated(
                    itemCount: loads.length > 3 ? 3 : loads.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => 20.height,
                    itemBuilder: (context, index) {
                      return RecentAddedLoadListBody(
                        data: loads[index],
                        isKycDone: VpVariables.isKycVerified,
                      );
                    },
                  );
                }
                return genericErrorWidget(error: GenericError());
              },
            ),
            20.height,
          ],
        ).paddingSymmetric(horizontal: commonSafeAreaPadding),
      ),
    );
  }
}

// Widget _buildMyLoadsWidget(BuildContext context) {
//   return BlocConsumer(
//     listener: (context, state) {
//       if (state is VpMyLoadListSuccess) {
//         vpMyLoadResponse = state.vpMyLoadResponse;
//       }
//     },
//     bloc: vpHomeScreenBloc,
//     builder: (context, state) {
//       if (state is VpMyLoadListSuccess) {
//         return Container(
//           decoration: commonContainerDecoration(borderRadius: BorderRadius.circular(0)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               10.height,
//
//               // Title
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(context.appText.myLoads, textAlign: TextAlign.start, style: AppTextStyle.body1),
//
//                   // See More
//                   //if (state is VpMyLoadListSuccess)
//                   // if (state.vpMyLoadResponse.data.length > 2)
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(context, commonRoute(const AvailableLoadsScreen(), isForward: true));
//                     },
//                     style: AppButtonStyle.primaryTextButton,
//                     child: Text(context.appText.seeMore, style: AppTextStyle.body3WhiteColor),
//                   )
//                 ],
//               ),
//               10.height,
//
//               // List
//               Builder(
//                 builder: (context) {
//                   if (vpMyLoadResponse == null) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   if (vpMyLoadResponse!.data.isEmpty) {
//                     return Center(
//                       child: Image.asset(
//                         AppImage.png.noShipment,
//                         width: 201.w,
//                         height: 134.h,
//                       ),
//                     );
//                   }
//
//                   return ListView.separated(
//                     itemCount: vpMyLoadResponse!.data.length > 2 ? 2 : vpMyLoadResponse!.data.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     separatorBuilder: (context, index) => 20.height,
//                     itemBuilder: (context, index) {
//                       final data = vpMyLoadResponse!.data[index];
//
//                       return MyLoadsListBody(
//                         data: data,
//                         onClickAssignDriver: () {
//                           final isKycDone = profileResponse?.data?.customer?.isKyc == 3;
//                           if (isKycDone) {
//                             Navigator.push(context, commonRoute(TripSchedulingScreen(data: data, allProfileDetails: profileResponse!.data!), isForward: true));
//                           } else {
//                             commonBottomSheetWithBGBlur(
//                               context: context,
//                               screen: KycPendingDialogue(
//                                 onPressed: () {
//                                   context.pop();
//                                   commonBottomSheetWithBGBlur(
//                                     context: context,
//                                     screen: EnterAadhaarNumberBottomSheet(),
//                                   ).then((_) {
//                                     lpHomeBloc.add(ProfileDetailRequested(lpHomeBloc.userId ?? "0"));
//                                   });
//                                 },
//                               ),
//                             );
//                           }
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//               20.height,
//             ],
//           ).paddingSymmetric(horizontal: commonSafeAreaPadding),
//         );
//       }
//       if (state is VpMyLoadListError) {
//          return genericErrorWidget(error: state.errorType);
//       }
//       if (state is VpMyLoadListLoading) {
//          return CircularProgressIndicator().paddingSymmetric(vertical: 100).center();
//       } else {
//         return genericErrorWidget(error: GenericError());
//       }
//     },
//   );
// }

// Widget _buildRecentAddedLoadWidget(BuildContext context) {
//   return Container(
//     decoration: commonContainerDecoration(
//       borderRadius: BorderRadius.circular(0),
//     ),
//     child: Column(
//       children: [
//         10.height,
//         // Title
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(context.appText.availableLoads, style: AppTextStyle.body1).expand(),
//
//             // See More
//             TextButton(
//               onPressed: () {
//                 Navigator.push(context, commonRoute(const AvailableLoadsScreen(), isForward: true));
//               },
//               style: AppButtonStyle.primaryTextButton,
//               child: Text(context.appText.seeMore, style: AppTextStyle.h5WhiteColor),
//             ),
//
//           ],
//         ),
//         // 10.height,
//         // buildSearchBarAndFilterWidget(context),
//         20.height,
//
//         // List
//         BlocBuilder<VpRecentLoadListBloc, VpRecentLoadListState>(
//           bloc: vpRecentLoadListBloc,
//           builder: (context, state) {
//             if (state is VpRecentLoadListLoading) {
//                return CircularProgressIndicator().center();
//             }
//             if (state is VpRecentLoadListError) {
//                return genericErrorWidget(error: state.errorType);
//             }
//             if (state is VpRecentLoadListSuccess) {
//               if(state.vpRecentLoadResponse.data.isNotEmpty){
//                 return ListView.separated(
//                   itemCount: state.vpRecentLoadResponse.data.length > 3? 3 : state.vpRecentLoadResponse.data.length,
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   separatorBuilder: (context, index) => 20.height,
//                   itemBuilder: (context, index) {
//                     return RecentAddedLoadListBody(data: state.vpRecentLoadResponse.data[index],isKycDone:profileResponse?.data?.customer?.isKyc == 3,);
//                   },
//                 );
//               }else{
//                 return genericErrorWidget(error: NotFoundError());
//               }
//             } else {
//               return genericErrorWidget(error: GenericError());
//             }
//           },
//         ),
//         20.height,
//       ],
//     ).paddingSymmetric(horizontal: commonSafeAreaPadding),
//   );
// }
