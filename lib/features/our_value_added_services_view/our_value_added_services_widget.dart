import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/fastag/model/fastag_list_response.dart';
import 'package:gro_one_app/features/fastag/repository/fastag_repository.dart';
import 'package:gro_one_app/features/fastag/views/fastag_list_screen.dart';
import 'package:gro_one_app/features/fastag/views/fastag_new_user_screen.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_kyc_check_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_order_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/model/gps_login_model.dart';
import 'package:gro_one_app/features/gps_feature/repository/gps_login_repository.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_order_benefits_and_order_list_screen.dart';

// import 'package:gro_one_app/features/gps/view/gps_order_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_orders_list_screen.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

import '../../utils/app_route.dart';
import '../en-dhan_fuel/view/endhan_new_user_and_card_screen.dart';
import '../gps_feature/views/gps_home_screen.dart';
import '../load_provider/lp_home/cubit/lp_home_cubit.dart';
import '../load_provider/lp_home/helper/event_helper.dart';

class OurValueAddedServicesWidget extends StatefulWidget {
  const OurValueAddedServicesWidget({super.key, this.isGridLayout = false});

  final bool isGridLayout;

  @override
  State<OurValueAddedServicesWidget> createState() =>
      _OurValueAddedServicesWidgetState();
}

class _OurValueAddedServicesWidgetState
    extends State<OurValueAddedServicesWidget> {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  final lpHomeCubit = locator<LPHomeCubit>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      setState(() {
        _scrollProgress =
            maxScroll == 0 ? 0 : (currentScroll / maxScroll).clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> services = [
      _buildServicesWidget(
        title: context.appText.gps,
        imageString: AppImage.png.gps,
        onClick: () async {
          // Navigator.push(context, commonRoute(GpsHomeScreen()));
          // Check KYC status before navigating
          final userRepository = locator<UserInformationRepository>();
          final customerId = await userRepository.getUserID();

          if (customerId != null && customerId.isNotEmpty) {
            // Create a temporary cubit to check KYC
            final kycCheckCubit = GpsKycCheckCubit(
              locator<GpsOrderApiRepository>(),
            );

            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );

            // Check KYC documents
            await kycCheckCubit.checkKycDocuments(customerId);

            // Close loading dialog
            if (context.mounted) {
              Navigator.of(context).pop();
            }

            // Navigate based on KYC status
            if (context.mounted) {
              if (kycCheckCubit.state.hasKycDocuments &&
                  kycCheckCubit.state.kycData != null) {
                // KYC done - check GPS authentication first
                final userRepository = locator<UserInformationRepository>();
                final mobileNumber = await userRepository.getUserMobileNumber();

                if (mobileNumber != null && mobileNumber.isNotEmpty) {
                  // Show loading dialog for GPS auth check
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  // Check GPS authentication
                  final gpsLoginRepository = locator<GpsLoginRepository>();
                  final authResult = await gpsLoginRepository.checkGpsAuth(
                    mobileNumber,
                  );

                  // Close loading dialog
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }

                  if (context.mounted) {
                    if (authResult is Success) {
                      // GPS auth successful - directly navigate to GPS home screen
                      Navigator.push(context, commonRoute(GpsHomeScreen()));
                    } else {
                      // GPS auth failed - check order list and then show benefits screen
                      final orderListCubit = GpsOrderListCubit(
                        locator<GpsOrderApiRepository>(),
                      );

                      // Show loading dialog for order list check
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      // Get order list
                      await orderListCubit.getOrderList(customerId: customerId);

                      // Close loading dialog
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }

                      // Navigate to benefits screen (GPS auth failed)
                      if (context.mounted) {
                        String status =
                            (authResult is Failure)
                                ? (authResult as Failure).statusCode == 401
                                    ? '401'
                                    : ''
                                : '';
                        Navigator.push(
                          context,
                          commonRoute(
                            GpsOrderBenefitsAndOrderListScreen(
                              authStatusCode: status == '401' ? '401' : '',
                            ),
                          ),
                        );
                      }

                      // Dispose the temporary cubit
                      orderListCubit.close();
                    }
                  }
                } else {
                  // No mobile number - show benefits screen
                  Navigator.push(
                    context,
                    commonRoute(GpsOrderBenefitsAndOrderListScreen()),
                  );
                }
              } else {
                // Scenario 3: KYC not done - show benefits screen
                Navigator.push(
                  context,
                  commonRoute(GpsOrderBenefitsAndOrderListScreen()),
                );
              }
            }

            // Dispose the temporary cubit
            kycCheckCubit.close();
          } else {
            // Fallback to benefits screen if customer ID not available
            Navigator.push(
              context,
              commonRoute(GpsOrderBenefitsAndOrderListScreen()),
            );
          }
        },
      ),
      // _buildServicesWidget(
      //   title: context.appText.gps,
      //   imageString: AppImage.png.gps,
      //   onClick: () async {
      //     Navigator.push(
      //       context,
      //       commonRoute(GpsHomeScreen()),
      //
      //       //commonRoute(GpsOrderBenefitsAndOrderListScreen()),
      //     );
      //     // Check KYC status before navigating
      //     // final userRepository =
      //     //     locator<UserInformationRepository>();
      //     // final customerId = await userRepository.getUserID();
      //
      //     // if (customerId != null && customerId.isNotEmpty) {
      //     //   // Create a temporary cubit to check KYC
      //     //   final kycCheckCubit = GpsKycCheckCubit(
      //     //     locator<GpsOrderApiRepository>(),
      //     //   );
      //
      //     //   // Show loading dialog
      //     //   showDialog(
      //     //     context: context,
      //     //     barrierDismissible: false,
      //     //     builder: (BuildContext context) {
      //     //       return const Center(
      //     //         child: CircularProgressIndicator(),
      //     //       );
      //     //     },
      //     //   );
      //
      //     //   // Check KYC documents
      //     //   await kycCheckCubit.checkKycDocuments(customerId);
      //
      //     //   // Close loading dialog
      //     //   if (context.mounted) {
      //     //     Navigator.of(context).pop();
      //     //   }
      //
      //     //   // Navigate based on KYC status
      //     //   if (context.mounted) {
      //     //     if (kycCheckCubit.state.hasKycDocuments &&
      //     //         kycCheckCubit.state.kycData != null) {
      //     //       // KYC done - show GPS home screen
      //     //       Navigator.push(
      //     //         context,
      //     //         commonRoute(GpsHomeScreen()),
      //     //         //commonRoute(GpsOrderBenefitsAndOrderListScreen()),
      //
      //     //       );
      //     //     } else {
      //     //       // KYC not done - show benefits screen
      //     //       Navigator.push(
      //     //         context,
      //     //         commonRoute(
      //     //           GpsOrderBenefitsAndOrderListScreen(),
      //     //         ),
      //     //       );
      //     //     }
      //     //   }
      //
      //     //   // Dispose the temporary cubit
      //     //   kycCheckCubit.close();
      //     // } else {
      //     //   // Fallback to benefits screen if customer ID not available
      //     //   Navigator.push(
      //     //     context,
      //     //     commonRoute(GpsOrderBenefitsAndOrderListScreen()),
      //     //   );
      //     // }
      //   },
      // ),
      _buildServicesWidget(
        title: context.appText.fuelCardEn,
        imageString: AppImage.png.enDhan,
        onClick: () {
          //context.push(AppRouteName.enDhanCard);
          Navigator.push(context, commonRoute(EndhanNewUserAndCardScreen()));
        },
      ),
      _buildServicesWidget(
        title: context.appText.fastag,
        imageString: AppImage.png.buyFastTag,
        onClick: () async {
          // context.push(AppRouteName.buyFastag);
          // Navigator.push(context, commonRoute(FastagListScreen()));
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
          final fastagRepository = locator<FastagRepository>();
          final res = await fastagRepository.getFastagList();
          if (res is Success<FastagListResponse>) {
            if (res.value.data.isNotEmpty) {
              Navigator.of(context).pop();
              Navigator.push(context, commonRoute(FastagListScreen()));
            } else {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FastagNewUserScreen()),
              );
            }
          } else {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FastagNewUserScreen()),
            );
          }
        },
      ),
      _buildServicesWidget(
        title: context.appText.fuelSecurityDevice,
        imageString: AppImage.png.kavach,
        onClick: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => KavachOrdersListScreen(),
              settings: const RouteSettings(name: 'KavachOrderListScreen'),
            ),
          );
        },
      ),

      //
      // _buildServicesWidget(
      //   title: context.appText.instantLoan,
      //   imageString: AppImage.png.insuranceLoan,
      //   onClick: () {
      //     context.push(AppRouteName.instantLoan);
      //   },
      // ),
      // 15.width,
      //
      // _buildServicesWidget(
      //   title: context.appText.insurance,
      //   imageString: AppImage.png.insurance,
      //   onClick: () {
      //     context.push(AppRouteName.insurance);
      //   },
      // ),
    ];

    return Container(
      decoration: commonContainerDecoration(
        borderRadius: BorderRadius.circular(0),
        shadow: true,
      ),
      child: Column(
        children: [
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.appText.valueAddedServices,
                  style: AppTextStyle.body1,
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: commonSafeAreaPadding),
          20.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
            child:
                widget.isGridLayout
                    ? GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.3,
                      physics: const NeverScrollableScrollPhysics(),
                      children: services,
                    )
                    : SizedBox(
                      height: 101,
                      child: ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: services.length,
                        separatorBuilder: (_, __) => 12.width,
                        itemBuilder: (context, index) => services[index],
                      ),
                    ),
          ),
          20.height,
          if (!widget.isGridLayout) ...[
            Container(
              width: 100,
              height: 4,
              decoration: commonContainerDecoration(
                color: AppColors.borderColor,
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: _scrollProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            20.height,
          ],
        ],
      ),
    );
  }

  Widget _buildServicesWidget({
    required String title,
    required String imageString,
    required GestureTapCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 120, // 👈 always at least 100
          maxWidth: 300, // 👈 expand up to this if needed (you can adjust)
        ),
        height: 90,
        decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageString, width: 30),
              10.height,

              Text(title, textAlign: TextAlign.center, style: AppTextStyle.h6),
            ],
          ),
        ),
      ),
    );
  }
}
