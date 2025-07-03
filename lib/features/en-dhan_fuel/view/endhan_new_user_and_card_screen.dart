import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_create_card_customer_info_screen.dart';
import 'package:gro_one_app/features/en-dhan_fuel/widgets/endhan_card_item.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/widgets/app_error_widget.dart';
import 'package:gro_one_app/utils/widgets/app_loading_widget.dart';

import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import 'endhan_kyc_screen.dart';

class EndhanNewUserAndCardScreen extends StatefulWidget {
  const EndhanNewUserAndCardScreen({super.key});

  @override
  State<EndhanNewUserAndCardScreen> createState() => _EndhanNewUserAndCardScreenState();
}

class _EndhanNewUserAndCardScreenState extends State<EndhanNewUserAndCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasAttemptedCardsFetch = false;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _cards = List.generate(3, (index) => {
    'image': AppImage.png.endhanCard,
    'cardNumber': '12XXX XXXXX X5678',
    'vehicleNumber': 'TN12 BD 1234',
    'status': 'Active',
    'amount': '₹2,550.00',
    'mobile': '98777 43321',
    'dateTime': 'Today 11:34 AM',
  });

  String _searchText = '';
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hasAttemptedCardsFetch = false;
    super.dispose();
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays == 0) {
        return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = locator<EnDhanCubit>();
        // Initialize API calls with a small delay to ensure cubit is ready
        Future.microtask(() {
          if (!cubit.isClosed && mounted) {
            cubit.checkKycDocuments();
            // Don't fetch cards immediately - wait for KYC check result
          }
        });
        return cubit;
      },
      child: BlocConsumer<EnDhanCubit, EnDhanState>(
        listenWhen: (previous, current) => 
          previous.kycCheckState != current.kycCheckState ||
          previous.cardsState != current.cardsState,
        listener: (context, state) {
          // Check if widget is still mounted
          if (!mounted) {
            print('❌ Widget is not mounted, skipping state handling');
            return;
          }
          
          // Debug logging for state changes
          print('🔄 State changed:');
          print('  KYC Check Status: ${state.kycCheckState?.status}');
          print('  Has KYC Documents: ${state.hasKycDocuments}');
          print('  Cards Status: ${state.cardsState?.status}');
          print('  Cards Count: ${state.cardsState?.data?.data?.length ?? 0}');
          
          // Debug KYC check details
          if (state.kycCheckState?.status == Status.SUCCESS) {
            print('✅ KYC Check successful');
            print('  KYC Data: ${state.kycData}');
            print('  Has Documents: ${state.hasKycDocuments}');
            
            // If KYC documents exist, ensure cards are fetched
            if (state.hasKycDocuments && 
                !_hasAttemptedCardsFetch &&
                state.cardsState?.status != Status.LOADING && 
                state.cardsState?.status != Status.SUCCESS) {
              print('📋 KYC documents found, ensuring cards are fetched...');
              _hasAttemptedCardsFetch = true;
              final cubit = context.read<EnDhanCubit>();
              if (!cubit.isClosed && mounted) {
                cubit.fetchCards();
              } else {
                print('❌ Cubit is closed or widget not mounted, cannot fetch cards');
              }
            }
          } else if (state.kycCheckState?.status == Status.ERROR) {
            print('❌ KYC Check failed: ${state.kycCheckState?.errorType}');
          } else if (state.kycCheckState?.status == Status.LOADING) {
            print('⏳ KYC Check loading...');
          }
          
          // Handle cards state changes
          if (state.cardsState?.status == Status.SUCCESS) {
            print('✅ Cards fetched successfully: ${state.cardsState?.data?.data?.length ?? 0} cards');
          } else if (state.cardsState?.status == Status.ERROR) {
            print('❌ Cards fetch failed: ${state.cardsState?.errorType}');
          }
        },
        builder: (context, state) {
          // Show loading while checking KYC
          if (state.kycCheckState?.status == Status.LOADING) {
            return Scaffold(
              appBar: CommonAppBar(
                title: context.appText.fuelCard,
                centreTile: false,
              ),
              body: const Center(child: AppLoadingWidget()),
            );
          }

          // TEMPORARY: Force show benefits for new user (no KYC documents)
          // Show new user screen if no KYC documents found OR if KYC check hasn't been performed
          if (state.kycCheckState?.status == Status.SUCCESS && !state.hasKycDocuments) {
            print('📋 KYC Check: No documents found, showing benefits screen');
            return Scaffold(
              appBar: CommonAppBar(
                title: context.appText.fuelCard,
                centreTile: false,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      print('🔄 Manual KYC refresh triggered');
                      context.read<EnDhanCubit>().checkKycDocuments();
                    },
                    icon: AppIcons.svg.filledSupport,
                    iconColor: AppColors.primaryButtonColor,
                  ),
                  10.width,
                ],
              ),
              body: SafeArea(child: enDhanBenifitsWidget(context)),
            );
          }

          // Show new user screen if KYC check failed (fallback)
          if (state.kycCheckState?.status == Status.ERROR) {
            print('📋 KYC Check: Failed, showing benefits screen');
            return Scaffold(
              appBar: CommonAppBar(
                title: context.appText.fuelCard,
                centreTile: false,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      print('🔄 Manual KYC refresh triggered');
                      context.read<EnDhanCubit>().checkKycDocuments();
                    },
                    icon: AppIcons.svg.filledSupport,
                    iconColor: AppColors.primaryButtonColor,
                  ),
                  10.width,
                ],
              ),
              body: SafeArea(child: enDhanBenifitsWidget(context)),
            );
          }

          // Show new user screen if KYC check hasn't been performed yet (initial state)
          if (state.kycCheckState == null) {
            print('📋 KYC Check: No check performed yet, showing benefits screen');
            return Scaffold(
              appBar: CommonAppBar(
                title: context.appText.fuelCard,
                centreTile: false,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      print('🔄 Manual KYC refresh triggered');
                      context.read<EnDhanCubit>().checkKycDocuments();
                    },
                    icon: AppIcons.svg.filledSupport,
                    iconColor: AppColors.primaryButtonColor,
                  ),
                  10.width,
                ],
              ),
              body: SafeArea(child: enDhanBenifitsWidget(context)),
            );
          }

          // TEMPORARY: Always show benefits for new user
          print('📋 TEMPORARY: Forcing benefits screen for new user');
          return Scaffold(
            appBar: CommonAppBar(
              title: context.appText.fuelCard,
              centreTile: false,
              actions: [
                AppIconButton(
                  onPressed: () {
                    print('🔄 Manual KYC refresh triggered');
                    context.read<EnDhanCubit>().checkKycDocuments();
                  },
                  icon: AppIcons.svg.filledSupport,
                  iconColor: AppColors.primaryButtonColor,
                ),
                10.width,
              ],
            ),
            body: SafeArea(child: enDhanBenifitsWidget(context)),
          );
        },
      ),
    );
  }

  Widget enDhanBenifitsWidget(BuildContext context){
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              buildenDhanProductImageWidget(context),
              6.height,
              buildenDhanBenefitsDetailsWidget(context),
              buildGroBannerImageWidget(),
              70.height,
            ],
          ),
        ),
        // Fixed bottom button
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
            child: AppButton(
              title: "Buy New Fuel Card",
              onPressed: (){
                Navigator.push(context,commonRoute(EndhanKycScreen()));
              }
           ),
          ),
        ),
      ],
    );
    
    // SingleChildScrollView(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       buildenDhanProductImageWidget(context),
    //       6.height,
    //       buildenDhanBenefitsDetailsWidget(context),
    //       buildGroBannerImageWidget(),
      
    //       AppButton(
    //           title: "Buy New Fuel Card",
    //           onPressed: (){
    //             Navigator.push(context,commonRoute(EndhanKycScreen()));
    //           }
    //       ).paddingOnly(left: 10.0, right: 10.0, bottom: 8.0)
    //     ],
    //   ),
    // );
  }

  Widget buildenDhanProductImageWidget(BuildContext context){
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.2,
      color: AppColors.lightPrimaryColor,
     child: Image.asset(AppImage.png.endhanCard, width: 150),
    );
  }

  Widget buildenDhanBenefitsDetailsWidget(BuildContext context){
    Widget innerUIWidget({required String icon,required String title, required String subTitle}){
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon
          Container(
            decoration: commonContainerDecoration(
                color: AppColors.lightPrimaryColor,
                borderRadius: BorderRadius.circular(100),
                borderColor: AppColors.primaryColor
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
              Text(subTitle, style: AppTextStyle.body3)
            ],
          ).expand()
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.benefitsOfFuelCard, style: AppTextStyle.body1),
        20.height,
        innerUIWidget(icon: AppIcons.png.cardPayment, title: context.appText.benefitsOfFuelCardHeading1, subTitle: context.appText.benefitsOfFuelCardSubHeading1),
        20.height,
        innerUIWidget(icon: AppIcons.png.tracking, title: context.appText.benefitsOfFuelCardHeading2, subTitle: context.appText.benefitsOfFuelCardSubHeading2),
        20.height,
        innerUIWidget(icon: AppIcons.png.reconcilation, title: context.appText.benefitsOfFuelCardHeading3, subTitle: context.appText.benefitsOfFuelCardSubHeading3),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }
  Widget buildGroBannerImageWidget(){
    return Image.asset(AppImage.png.groBanner);
  }
}
