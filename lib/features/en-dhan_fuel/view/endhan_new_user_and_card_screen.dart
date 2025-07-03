import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/model/result.dart' show GenericError;
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_create_card_customer_info_screen.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_create_card_info_screen.dart';
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
import '../../kavach/view/kavach_support_screen.dart';
import 'endhan_kyc_screen.dart';

class EndhanNewUserAndCardScreen extends StatefulWidget {
  const EndhanNewUserAndCardScreen({super.key});

  @override
  State<EndhanNewUserAndCardScreen> createState() => _EndhanNewUserAndCardScreenState();
}

class _EndhanNewUserAndCardScreenState extends State<EndhanNewUserAndCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasAttemptedCardsFetch = false;

  String _searchText = '';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = locator<EnDhanCubit>();
        // Initialize API calls with a small delay to ensure cubit is ready
        Future.microtask(() {
          if (!cubit.isClosed && mounted) {
            cubit.checkKycDocuments();
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
          if (!mounted) return;
          
          // If KYC documents exist, fetch cards
          if (state.kycCheckState?.status == Status.SUCCESS && 
              state.hasKycDocuments && 
              !_hasAttemptedCardsFetch &&
              state.cardsState?.status != Status.LOADING && 
              state.cardsState?.status != Status.SUCCESS) {
            _hasAttemptedCardsFetch = true;
            final cubit = context.read<EnDhanCubit>();
            if (!cubit.isClosed && mounted) {
              cubit.fetchCards();
            }
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

          // Show error state for KYC check
          if (state.kycCheckState?.status == Status.ERROR) {
            return Scaffold(
              appBar: CommonAppBar(
                title: context.appText.fuelCard,
                centreTile: false,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      Navigator.push(context,commonRoute(KavachSupportScreen()));
                    },
                    icon: AppIcons.svg.filledSupport,
                    iconColor: AppColors.primaryButtonColor,
                  ),
                  10.width,
                ],
              ),
              body: Center(
                child: AppErrorWidget(
                  error: GenericError(),
                  onRetry: () {
                    context.read<EnDhanCubit>().checkKycDocuments();
                  },
                ),
              ),
            );
          }

          // Show benefits screen if no KYC documents found
          if (state.kycCheckState?.status == Status.SUCCESS && !state.hasKycDocuments) {
            return Scaffold(
              appBar: CommonAppBar(
                title: context.appText.fuelCard,
                centreTile: false,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      Navigator.push(context,commonRoute(KavachSupportScreen()));
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

          // Show cards screen if KYC documents exist
          if (state.kycCheckState?.status == Status.SUCCESS && state.hasKycDocuments) {
            return Scaffold(
              backgroundColor: AppColors.blackishWhite,
              appBar: CommonAppBar(
                title: 'eN-Dhan Card',
                centreTile: false,
                actions: [
                  AppIconButton(
                    onPressed: () {
                      Navigator.push(context, commonRoute(EndhanCreateCardCustomerInfoScreen()));
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                  ),
                  AppIconButton(
                    onPressed: () {
                      Navigator.push(context,commonRoute(KavachSupportScreen()));
                    },
                    icon: AppIcons.svg.filledSupport,
                    iconColor: AppColors.primaryColor,
                  ),
                  10.width,
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'My Cards (ID: HPCL${state.cardsState?.data?.data?.endhanCustomerId ?? ''})',
                        style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    12.height,
                    AppSearchBar(
                      searchController: _searchController,
                      hintText: 'Search',
                      onChanged: (val) {
                        setState(() {
                          _searchText = val;
                        });
                      },
                      onClear: () {
                        setState(() {
                          _searchText = '';
                        });
                      },
                    ).paddingSymmetric(horizontal: 16.0),
                    16.height,
                    Expanded(
                      child: _buildCardsList(context, state),
                    ),
                  ],
                ),
              ),
            );
          }
          
          // Show loading while waiting for KYC check
          return Scaffold(
            appBar: CommonAppBar(
              title: context.appText.fuelCard,
              centreTile: false,
            ),
            body: const Center(child: AppLoadingWidget()),
          );
        },
      ),
    );
  }

  Widget _buildCardsList(BuildContext context, EnDhanState state) {
    if (state.cardsState?.status == Status.LOADING) {
      return const Center(child: AppLoadingWidget());
    }
    if (state.cardsState?.status == Status.ERROR) {
      return Center(
        child: AppErrorWidget(
          error: GenericError(),
          onRetry: () {
            context.read<EnDhanCubit>().fetchCards();
          },
        ),
      );
    }
    if (state.cardsState?.status == Status.SUCCESS) {
      final cards = state.cardsState?.data?.data?.document ?? [];
      if (cards.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.credit_card_off,
                size: 64,
                color: AppColors.greyTextColor,
              ),
              16.height,
              Text(
                'No fuel cards found',
                style: AppTextStyle.h5.copyWith(color: AppColors.greyTextColor),
              ),
              8.height,
              Text(
                'Add your first fuel card to get started',
                style: AppTextStyle.body3.copyWith(color: AppColors.greyTextColor),
              ),
            ],
          ),
        );
      }
      
      // Filter cards based on search
      final filteredCards = cards.where((card) {
        if (_searchText.isEmpty) return true;
        final cardNumber = card.cardNumber?.toString().toLowerCase() ?? '';
        final vehicleNumber = card.vehicleNumber?.toString().toLowerCase() ?? '';
        final mobile = card.cardMobileNo?.toString().toLowerCase() ?? '';
        final searchLower = _searchText.toLowerCase();
        return cardNumber.contains(searchLower) ||
            vehicleNumber.contains(searchLower) ||
            mobile.contains(searchLower);
      }).toList();
      
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: filteredCards.length,
        itemBuilder: (context, index) {
          final card = filteredCards[index];
          // Convert EnDhanCardModel to Map for EndhanCardItem
          final cardMap = {
            'cardNumber': _maskCardNumber(card.cardNumber ?? ''),
            'vehicleNumber': card.vehicleNumber ?? '',
            'mobile': card.cardMobileNo ?? '',
            'status': 'Active', // Default status since API doesn't provide it
            'image': AppImage.png.endhanCard,
            'dateTime': card.createdAt ?? '',
          };
          return EndhanCardItem(card: cardMap).paddingOnly(bottom: 12);
        },
      );
    }
    return const Center(child: AppLoadingWidget());
  }

  String _maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    // Mask all but the first 2 and last 4 digits
    final visibleStart = cardNumber.substring(0, 2);
    final visibleEnd = cardNumber.substring(cardNumber.length - 4);
    return ' 0{visibleStart}XXX XXXXX X$visibleEnd';
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
