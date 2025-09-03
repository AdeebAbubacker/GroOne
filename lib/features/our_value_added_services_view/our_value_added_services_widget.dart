import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/fastag/views/fastag_list_screen.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_kyc_check_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_order_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
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
                // KYC done - check order list to decide between GPS home or benefits
                final orderListCubit = GpsOrderListCubit(
                  locator<GpsOrderApiRepository>(),
                );

                // Show loading dialog for order list check
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                // Get order list
                await orderListCubit.getOrderList(customerId: customerId);

                // Close loading dialog
                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                // Navigate based on order list
                if (context.mounted) {
                  if (orderListCubit.state is GpsOrderListLoaded) {
                    final orderState =
                        orderListCubit.state as GpsOrderListLoaded;
                    if (orderState.orderList.data.rows.isNotEmpty) {
                      // Scenario 1: KYC done and has orders - show GPS home screen
                      Navigator.push(context, commonRoute(GpsHomeScreen()));
                    } else {
                      // Scenario 2: KYC done but no orders - show benefits screen
                      Navigator.push(
                        context,
                        commonRoute(GpsOrderBenefitsAndOrderListScreen()),
                      );
                    }
                  } else {
                    // Fallback to benefits screen if order list check fails
                    Navigator.push(
                      context,
                      commonRoute(GpsOrderBenefitsAndOrderListScreen()),
                    );
                  }
                }

                // Dispose the temporary cubits
                orderListCubit.close();
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
        onClick: () {
          // context.push(AppRouteName.buyFastag);
          Navigator.push(context, commonRoute(FastagListScreen()));
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
                child: Text(context.appText.valueAddedServices, style: AppTextStyle.body1),
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
        width: 100,
        height: 90,
        decoration: commonContainerDecoration(color: AppColors.lightBlueColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageString, width: 30),
            10.height,

            Text(title, textAlign: TextAlign.center, style: AppTextStyle.h6),
          ],
        ),
      ),
    );
  }
}
