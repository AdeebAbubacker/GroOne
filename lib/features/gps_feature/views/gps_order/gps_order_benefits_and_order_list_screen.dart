import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_kyc_check_cubit.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_order_list_cubit.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_order_list_models.dart';
import 'package:gro_one_app/features/gps_feature/views/gps_order/gps_models_screen.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/widgets/app_error_widget.dart';
import 'package:gro_one_app/utils/widgets/app_loading_widget.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_image.dart';
import '../../../../utils/app_route.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/common_functions.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/constant_variables.dart';
import '../../../kavach/view/kavach_support_screen.dart';
import 'gps_transaction_screen.dart';
import 'gps_upload_document_screen.dart';

class GpsOrderBenefitsAndOrderListScreen extends StatefulWidget {
  GpsOrderBenefitsAndOrderListScreen({super.key});

  @override
  State<GpsOrderBenefitsAndOrderListScreen> createState() =>
      _GpsOrderBenefitsAndOrderListScreenState();
}

class _GpsOrderBenefitsAndOrderListScreenState
    extends State<GpsOrderBenefitsAndOrderListScreen> {
  final GlobalKey menuKey = GlobalKey();
  String? customerId;

  @override
  void initState() {
    super.initState();
    print('🔄 GPS Benefits Screen: initState called');
    print('🔄 GPS Benefits Screen: Widget key: ${widget.key}');
    _getCustomerId();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset any existing cubit state when screen is navigated to
    print('🔄 GPS Benefits Screen: didChangeDependencies called');
  }

  @override
  void didUpdateWidget(GpsOrderBenefitsAndOrderListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('🔄 GPS Benefits Screen: didUpdateWidget called');
    // Force refresh KYC check when widget is updated
    if (customerId != null) {
      print('🔄 GPS Benefits Screen: Forcing KYC check refresh');
      // This will be handled by the BlocProvider.value in build method
    }
  }

  Future<void> _getCustomerId() async {
    final userRepository = locator<UserInformationRepository>();
    final id = await userRepository.getUserID();
    setState(() {
      customerId = id;
    });
  }

  void _handleBackNavigation() {
    print('🔙 Back button tapped - starting navigation');
    
    // Make navigation synchronous to avoid issues with onLeadingTap
    try {
      _navigateBackSynchronously();
    } catch (e) {
      print('🔙 Error in _handleBackNavigation: $e');
      // Fallback: try to pop or navigate to default route
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        context.go(AppRouteName.lpBottomNavigationBar);
      }
    }
  }

  void _navigateBackSynchronously() {
    // Try multiple navigation approaches
    try {
      // First, try to pop
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return;
      }
      
      // If we can't pop, try to navigate to the appropriate dashboard
      _getUserRoleAndNavigate();
    } catch (e) {
      print('🔙 Error in _navigateBackSynchronously: $e');
      // Final fallback: try to go to default route
      try {
        if (context.mounted) {
          context.go(AppRouteName.lpBottomNavigationBar);
        }
      } catch (fallbackError) {
        print('🔙 Fallback navigation also failed: $fallbackError');
      }
    }
  }

  Future<void> _getUserRoleAndNavigate() async {
    print('🔙 Getting user role for navigation');
    try {
      final userRepository = locator<UserInformationRepository>();
      final userRole = await userRepository.getUserRole();
      print('🔙 User role: $userRole');
      String targetRoute;
      if (userRole == 1 || userRole == 3) {
        targetRoute = AppRouteName.lpBottomNavigationBar;
      } else if (userRole == 2) {
        targetRoute = AppRouteName.vpBottomNavigationBar;
      } else {
        targetRoute = AppRouteName.lpBottomNavigationBar;
      }
      print('🔙 Navigating to: $targetRoute');
      if (context.mounted) {
        context.go(targetRoute);
      } else {
        print('🔙 Context not mounted, cannot navigate');
      }
    } catch (e) {
      print('🔙 Error during navigation: $e');
      // Fallback to default navigation
      if (context.mounted) {
        context.go(AppRouteName.lpBottomNavigationBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('🔙 WillPopScope triggered');
        // Use the same navigation logic as the back button
        _navigateBackSynchronously();
        return false; // Prevent default back behavior
      },
      child: BlocProvider.value(
        value: GpsKycCheckCubit(locator<GpsOrderApiRepository>())..resetCubit(),
        child: BlocConsumer<GpsKycCheckCubit, GpsKycCheckState>(
          listenWhen:
              (previous, current) =>
                  previous.kycCheckState != current.kycCheckState,
          listener: (context, state) {
            // Check if widget is still mounted
            if (!context.mounted) return;
          },
          builder: (context, state) {
            // Initialize KYC check on first build if not already started
            if (state.kycCheckState == null) {
              Future.microtask(() {
                if (mounted) {
                  if (customerId != null) {
                    context.read<GpsKycCheckCubit>().checkKycDocuments(
                      customerId!,
                    );
                  }
                }
              });
            }

            // Show loading while checking KYC
            if (state.kycCheckState?.status == Status.LOADING) {
              return Scaffold(
                backgroundColor: AppColors.blackishWhite,
                appBar: CommonAppBar(
                  title: Text(context.appText.gps, style: AppTextStyle.appBar),
                  centreTile: false,
                  isLeading: true,
                  onLeadingTap: _handleBackNavigation,
                ),
                body: const Center(child: AppLoadingWidget()),
              );
            }

            // Show error state for KYC check
            if (state.kycCheckState?.status == Status.ERROR) {
              return Scaffold(
                backgroundColor: AppColors.blackishWhite,
                appBar: CommonAppBar(
                  title: Text(context.appText.gps, style: AppTextStyle.appBar),
                  centreTile: false,
                  isLeading: true,
                  onLeadingTap: _handleBackNavigation,
                ),
                body: Center(
                  child: AppErrorWidget(
                    error: GenericError(),
                    onRetry: () {
                      if (customerId != null) {
                        context.read<GpsKycCheckCubit>().checkKycDocuments(
                          customerId!,
                        );
                      }
                    },
                  ),
                ),
              );
            }

            // Show benefits screen if no KYC documents found
            if (state.kycCheckState?.status == Status.SUCCESS &&
                (state.hasKycDocuments == false || state.kycData == null)) {
              print('🔍 GPS KYC Check: Showing benefits screen');
              print('  - hasKycDocuments: ${state.hasKycDocuments}');
              print('  - kycData: ${state.kycData}');
              return _buildBenefitsScreen(context);
            }

            // Show order list if KYC documents exist
            if (state.kycCheckState?.status == Status.SUCCESS &&
                state.hasKycDocuments == true &&
                state.kycData != null) {
              print('🔍 GPS KYC Check: Showing order list');
              print('  - hasKycDocuments: ${state.hasKycDocuments}');
              print('  - kycData: ${state.kycData}');
              return _buildOrderListScreen(context);
            }

            // Show loading while waiting for KYC check
            return Scaffold(
              backgroundColor: AppColors.blackishWhite,
              appBar: CommonAppBar(
                title: Text(context.appText.gps, style: AppTextStyle.appBar),
                centreTile: false,
                isLeading: true,
                onLeadingTap: _handleBackNavigation,
              ),
              body: const Center(child: AppLoadingWidget()),
            );
          },
        ),
      ),
    );
  }

  // Build benefits screen with GPS title and support icon only
  Widget _buildBenefitsScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        title: Text(context.appText.gps, style: AppTextStyle.appBar),
        centreTile: false,
        isLeading: true,
        onLeadingTap: _handleBackNavigation,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(context, commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
        ],
      ),
      body: gpsBenifitsWidget(context),
    );
  }

  // Build order list screen with GPS Model title and all icons
  Widget _buildOrderListScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        title: Text("GPS Model", style: AppTextStyle.appBar),
        centreTile: false,
        isLeading: true,
        onLeadingTap: _handleBackNavigation,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.of(context).push(commonRoute(GpsModelsScreen()));
            },
            icon: Icon(Icons.add, color: Colors.white),
            style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
          ),
          4.width,
          AppIconButton(
            onPressed: () {
              Navigator.push(context, commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
          AppIconButton(
            key: menuKey,
            onPressed: () async {
              final RenderBox button =
                  menuKey.currentContext!.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset position = button.localToGlobal(
                Offset.zero,
                ancestor: overlay,
              );

              final selected = await showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  position.dx - 100,
                  position.dy,
                  position.dx,
                  overlay.size.height - position.dy,
                ),
                items: [
                  PopupMenuItem(
                    value: 'transaction',
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Transaction'),
                      ],
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
              );

              if (selected == 'transaction') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GpsTransactionScreen()),
                );
              }
            },
            icon: Icons.more_vert,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
        ],
      ),
      body: gpsOrderListWidget(context),
    );
  }

  // Build benefits content
  Widget _buildBenefitsContent(BuildContext context) {
    return gpsBenifitsWidget(context);
  }

  // Build order list content
  Widget _buildOrderListContent(BuildContext context) {
    return gpsOrderListWidget(context);
  }

  // --- Benefits Section (unchanged) ---
  Widget gpsBenifitsWidget(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildGpsProductImageWidget(context),
                20.height,
                buildGpsBenefitsDetailsWidget(context),
                buildGroBannerImageWidget(),
              ],
            ),
          ),
        ),
        // Fixed bottom button
        AppButton(
          title: context.appText.buyNewGps,
          onPressed: () {
            Navigator.push(context, commonRoute(GpsUploadDocumentScreen()));
            // Navigator.push(context,commonRoute(GpsModelsScreen()));
          },
        ).paddingOnly(bottom: 30, left: 15, right: 15, top: 10),
      ],
    );
  }

  Widget buildGpsProductImageWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.18,
      color: AppColors.lightPrimaryColor,
      child: Image.asset(
        AppImage.png.gpsBenefitTruck,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildGpsBenefitsDetailsWidget(BuildContext context) {
    Widget innerUIWidget({
      required String icon,
      required String title,
      required String subTitle,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            decoration: commonContainerDecoration(
              color: AppColors.lightPrimaryColor,
              borderRadius: BorderRadius.circular(100),
              borderColor: AppColors.primaryColor,
            ),
            child: Image.asset(icon, width: 25).paddingAll(15),
          ),
          15.width,

          // Heading or SubHeading
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.h5),
              5.height,
              Text(subTitle, style: AppTextStyle.body3),
            ],
          ).expand(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.gpsBenefitGps, style: AppTextStyle.body1),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.cardPayment,
          title: context.appText.benefitsOfGpsCardHeading1,
          subTitle: context.appText.benefitsOfGpsCardSubHeading1,
        ),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.tracking,
          title: context.appText.benefitsOfGpsCardHeading2,
          subTitle: context.appText.benefitsOfGpsCardSubHeading2,
        ),
        20.height,
        innerUIWidget(
          icon: AppIcons.png.reconcilation,
          title: context.appText.benefitsOfGpsCardHeading3,
          subTitle: context.appText.benefitsOfGpsCardSubHeading3,
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }

  Widget buildGroBannerImageWidget() {
    return Image.asset(
      AppImage.png.groBanner,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  // --- Order List Section (using real API data) ---
  Widget gpsOrderListWidget(BuildContext context) {
    return BlocProvider.value(
      value: GpsOrderListCubit(locator<GpsOrderApiRepository>())..resetCubit(),
      child: BlocConsumer<GpsOrderListCubit, GpsOrderListState>(
        key: ValueKey(
          'gps_order_list_${DateTime.now().millisecondsSinceEpoch}',
        ),
        listener: (context, state) {
          if (state is GpsOrderListError) {
            // Handle error if needed
            print('GPS Order List Error: ${state.message}');
          }
        },
        builder: (context, state) {
          // Initialize order list on first build
          if (state is GpsOrderListInitial && customerId != null) {
            Future.microtask(() {
              if (mounted) {
                context.read<GpsOrderListCubit>().getOrderList(
                  customerId: customerId!,
                );
              }
            });
          }

          // Show loading while fetching orders
          if (state is GpsOrderListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error state
          if (state is GpsOrderListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load orders', style: AppTextStyle.h5),
                  Text(state.message, style: AppTextStyle.body3),
                  20.height,
                  AppButton(
                    title: 'Retry',
                    onPressed: () {
                      if (customerId != null) {
                        context.read<GpsOrderListCubit>().getOrderList(
                          customerId: customerId!,
                        );
                      }
                    },
                    style: AppButtonStyle.primary,
                  ).paddingSymmetric(horizontal: 40),
                ],
              ),
            );
          }

          // Show orders list
          if (state is GpsOrderListLoaded) {
            return GpsOrderListWithTabs(orders: state.orderList.data.rows);
          }

          // Default loading state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// Separate widget for order list with tabs to avoid full screen refresh
class GpsOrderListWithTabs extends StatefulWidget {
  final List<GpsOrderItem> orders;

  const GpsOrderListWithTabs({super.key, required this.orders});

  @override
  State<GpsOrderListWithTabs> createState() => _GpsOrderListWithTabsState();
}

class _GpsOrderListWithTabsState extends State<GpsOrderListWithTabs> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final tabLabels = [
      'All',
      'Order Placed',
      'Dispatched',
      'Delivered',
      'Installed',
    ];

    // Filter orders based on selected tab
    List<GpsOrderItem> filteredOrders =
        selectedTab == 0
            ? widget.orders
            : widget.orders
                .where((order) => order.currentStatus == tabLabels[selectedTab])
                .toList();

    return Column(
      children: [
        // Tab Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(tabLabels.length, (index) {
              final isSelected = selectedTab == index;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 12,
                ),
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: commonContainerDecoration(
                      color:
                          isSelected
                              ? AppColors.primaryColor
                              : const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      tabLabels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child:
              filteredOrders.isEmpty
                  ? Center(
                    child: Text('No orders found', style: AppTextStyle.h5),
                  )
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (_, __) => 8.height,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final statusColor = AppColors.greenColor;

                      return Container(
                        decoration: commonContainerDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          shadow: true,
                          borderColor: AppColors.borderColor,
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Order ID: ${order.orderUniqueId}',
                                  style: AppTextStyle.h4PrimaryColor.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ).expand(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: commonContainerDecoration(
                                    color: statusColor.withOpacity(0.09),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    order.currentStatus,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            6.height,
                            Row(
                              children: [
                                Text(
                                  order.productNames,
                                  style: AppTextStyle.textGreyColor14w300,
                                ).expand(),
                                Text(
                                  '₹${order.totalPrice.toStringAsFixed(0)}',
                                  style: AppTextStyle.h4,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {}, // TODO: Add details navigation
                                  child: Text(
                                    'View Details',
                                    style: AppTextStyle.primaryColor16w400,
                                  ),
                                ),
                                15.width,
                                Text(
                                  'Purchased on ${formatDateTimeKavach(order.orderDate)}',
                                  style: AppTextStyle.textGreyColor14w300,
                                  maxLines: 1,
                                ).expand(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
