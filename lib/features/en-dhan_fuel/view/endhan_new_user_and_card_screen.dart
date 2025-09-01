import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/data/model/result.dart' show GenericError;
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_create_card_customer_info_screen.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/en-dhan_fuel/widgets/endhan_card_item.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/widgets/app_error_widget.dart';
import 'package:gro_one_app/utils/widgets/app_loading_widget.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_image.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/constant_variables.dart';
import '../../../utils/app_dialog.dart';
import '../../../utils/common_dialog_view/common_dialog_view.dart';
import '../../profile/view/support_screen.dart';
import '../../profile/view/widgets/add_new_support_ticket.dart';
import 'endhan_kyc_screen.dart';
import 'endhan_transaction_screen.dart';

class EndhanNewUserAndCardScreen extends StatefulWidget {
  const EndhanNewUserAndCardScreen({super.key});

  @override
  State<EndhanNewUserAndCardScreen> createState() => _EndhanNewUserAndCardScreenState();
}

class _EndhanNewUserAndCardScreenState extends State<EndhanNewUserAndCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasAttemptedCardsFetch = false;
  bool _isNavigating = false; // Flag to prevent multiple navigation attempts

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    // Reset the cubit to ensure it's in a clean state
    final cubit = locator<EnDhanCubit>();
    cubit.resetCubit();

    // Initialize API calls with a small delay to ensure cubit is ready
    Future.microtask(() {
      if (!cubit.isClosed && mounted) {
        cubit.checkEndhanServerStatus();
        cubit.checkKycDocuments();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hasAttemptedCardsFetch = false;
    super.dispose();
  }

  // Safe navigation method to prevent crashes
  void _safeNavigateBack(BuildContext context) {
    if (_isNavigating || !context.mounted) return;

    _isNavigating = true;

    try {
      // Check if we can pop back to previous screen
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        // If no previous screen, go to dashboard based on user role
        _navigateToDashboard(context);
      }
    } catch (e) {
      // Fallback: try to go to dashboard
      _navigateToDashboard(context);
    } finally {
      // Reset the flag after a delay to allow for future navigation
      Future.delayed(Duration(seconds: 2), () {
        _isNavigating = false;
      });
    }
  }

  // Navigate to appropriate dashboard based on user role
  void _navigateToDashboard(BuildContext context) {
    try {
      final userRepository = locator<UserInformationRepository>();
      userRepository.getUserRole().then((userRole) {
        if (!context.mounted) return;

        String targetRoute;
        if (userRole == 1 || userRole == 3) {
          targetRoute = '/lpBottomNavigation';
        } else if (userRole == 2) {
          targetRoute = '/vpBottomNavigationBar';
        } else {
          targetRoute = '/lpBottomNavigation';
        }

        if (context.mounted) {
          context.go(targetRoute);
        }
      }).catchError((e) {
        // Fallback to default route
        if (context.mounted) {
          context.go('/lpBottomNavigation');
        }
      });
    } catch (e) {
      // Last resort fallback
      if (context.mounted) {
        try {
          context.go('/lpBottomNavigation');
        } catch (finalError) {
          // Silent fallback
        }
      }
    }
  }

  void _showAlreadyAddedCardDialog(BuildContext context) {
    AppDialog.show(
      context,
      dismissible: true,
      child: CommonDialogView(
        hideCloseButton: true,
        onTapSingleButton: () {
          Navigator.of(context).pop();
        },
        onSingleButtonText: context.appText.ok,
        child: Column(
          children: [
            // Orange circular icon with warning triangle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange, // Orange color
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            20.height,
            // Main heading
            Text(
              context.appText.cardAlreadyAdded,
              style: AppTextStyle.h4.copyWith(
                color: AppColors.orangeTextColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            12.height,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents auto-pop (like returning false in WillPopScope)
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // System tried to pop, but we blocked it
          _safeNavigateBack(context);
        }
      },
      child: BlocProvider.value(
        value: locator<EnDhanCubit>(),
        child: BlocConsumer<EnDhanCubit, EnDhanState>(
          listenWhen: (previous, current) =>
          previous.kycCheckState != current.kycCheckState ||
              previous.cardsState != current.cardsState,
          listener: (context, state) {
            // Check if widget is still mounted
            if (!mounted) return;

            // If KYC documents exist, fetch cards and balance
            if (state.kycCheckState?.status == Status.SUCCESS && state.hasKycDocuments &&
                !_hasAttemptedCardsFetch &&
                state.cardsState?.status != Status.LOADING &&
                state.cardsState?.status != Status.SUCCESS) {
              _hasAttemptedCardsFetch = true;
              final cubit = context.read<EnDhanCubit>();
              if (!cubit.isClosed && mounted) {
                cubit.fetchCards();
                cubit.fetchCardBalance();
              }
            }

            // If KYC documents exist and cards haven't been fetched yet, fetch them
            if (state.kycCheckState?.status == Status.SUCCESS &&
                state.hasKycDocuments &&
                state.cardsState?.status == Status.INITIAL) {
              final cubit = context.read<EnDhanCubit>();
              if (!cubit.isClosed && mounted) {
                cubit.fetchCards();
                cubit.fetchCardBalance();
              }
            }
          },
          builder: (context, state) {
            // Show loading while checking KYC
            if (state.kycCheckState?.status == Status.LOADING) {
              return Scaffold(
                appBar: CommonAppBar(
                  title: Text(context.appText.fuelCard),
                  centreTile: false,
                  onLeadingTap: () => _safeNavigateBack(context),
                ),
                body: const Center(child: AppLoadingWidget()),
              );
            }

            // Show loading while fetching cards after KYC check
            if (state.kycCheckState?.status == Status.SUCCESS &&
                state.hasKycDocuments &&
                state.cardsState?.status == Status.LOADING) {
              return Scaffold(
                appBar: CommonAppBar(
                  title: Text(context.appText.fuelCard),
                  centreTile: false,
                  onLeadingTap: () => _safeNavigateBack(context),
                ),
                body: const Center(child: AppLoadingWidget()),
              );
            }

            // Show error state for KYC check
            if (state.kycCheckState?.status == Status.ERROR) {
              return Scaffold(
                appBar: CommonAppBar(
                  title: Text(context.appText.fuelCard),
                  centreTile: false,
                  onLeadingTap: () => _safeNavigateBack(context),
                  actions: [
                    AppIconButton(
                      onPressed: () {
                        Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true, ticketTag: TicketTags.ENDHAN), isForward: true));
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

            // Show error state for cards fetching
            if (state.kycCheckState?.status == Status.SUCCESS &&
                state.hasKycDocuments &&
                state.cardsState?.status == Status.ERROR) {
              return Scaffold(
                appBar: CommonAppBar(
                  title: Text(context.appText.fuelCard),
                  centreTile: false,
                  onLeadingTap: () => _safeNavigateBack(context),
                  actions: [
                    AppIconButton(
                      onPressed: () {
                        Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true,ticketTag: TicketTags.ENDHAN,), isForward: true));
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
                      context.read<EnDhanCubit>().fetchCards();
                    },
                  ),
                ),
              );
            }

            // Show benefits screen if no KYC documents found
            if (state.kycCheckState?.status == Status.SUCCESS && !state.hasKycDocuments) {
              return Scaffold(
                appBar: CommonAppBar(
                  title: Text(context.appText.fuelCard),
                  centreTile: false,
                  onLeadingTap: () => _safeNavigateBack(context),
                  actions: [
                    AppIconButton(
                      onPressed: () {
                        Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true, ticketTag: TicketTags.ENDHAN,), isForward: true));
                      },
                      icon: AppIcons.svg.filledSupport,
                      iconColor: AppColors.primaryButtonColor,
                    ),
                    10.width,
                  ],
                ),
                body: SafeArea(child: enDhanBenifitsWidget(context, showKycScreen: true)),
              );
            }

           // Show benefits screen if KYC documents exist but no cards found
            if (state.kycCheckState?.status == Status.SUCCESS &&
                state.hasKycDocuments &&
                state.cardsState?.status == Status.SUCCESS &&
                (state.cardsState?.data?.data?.document ?? []).isEmpty) {
              return Scaffold(
                appBar: CommonAppBar(
                  title: Text(context.appText.fuelCard),
                  centreTile: false,
                  onLeadingTap: () => _safeNavigateBack(context),
                  actions: [
                    AppIconButton(
                      onPressed: () {
                        Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true, ticketTag: TicketTags.ENDHAN,), isForward: true));
                      },
                      icon: AppIcons.svg.filledSupport,
                      iconColor: AppColors.primaryButtonColor,
                    ),
                    10.width,
                  ],
                ),
                body: SafeArea(child: enDhanBenifitsWidget(context, showKycScreen: false)),
              );
            }

            // Show cards screen if KYC documents exist and cards are available
            if (state.kycCheckState?.status == Status.SUCCESS &&
                state.hasKycDocuments &&
                state.cardsState?.status == Status.SUCCESS &&
                (state.cardsState?.data?.data?.document ?? []).isNotEmpty) {
              return Scaffold(
                backgroundColor: AppColors.blackishWhite,
                appBar: CommonAppBar(
                  title: Text(context.appText.enDhanCard,style: AppTextStyle.h4.copyWith(fontWeight: FontWeight.w500),),
                  centreTile: false,
                  onLeadingTap: () => _safeNavigateBack(context),
                  actions: [
                    AppIconButton(
                      onPressed: () {
                        // Check if there are already cards
                        final cards = state.cardsState?.data?.data?.document ?? [];
                        if (cards.isNotEmpty) {
                          // Show popup if cards already exist
                          _showAlreadyAddedCardDialog(context);
                        } else {
                          final serverStatus = state.endhanServerStatusState;

                          // ✅ Check loading or error state first
                          if (serverStatus?.status == Status.LOADING) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(context.appText.checkingEndhanServer)),
                            );
                            return;
                          }

                          if (serverStatus?.status == Status.ERROR) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(context.appText.couldNotCheckEndhanServerStatus)),
                            );
                            return;
                          }

                          // ✅ Now check API response
                          if (serverStatus?.data?["success"] == false) {
                            // Server is down, show dialog instead of navigating
                            AppDialog.show(
                              context,
                              dismissible: true,
                              child: CommonDialogView(
                                hideCloseButton: true,
                                onTapSingleButton: () => Navigator.of(context).pop(),
                                onSingleButtonText: context.appText.ok,
                                child: Text(
                                  serverStatus?.data?["message"] ?? context.appText.endhanServerNotWorking,
                                  style: AppTextStyle.h5.copyWith(color: Colors.red),
                                ),
                              ),
                            );
                          }else{
                            // Navigate to create card screen if no cards exist
                            Navigator.push(context, commonRoute(EndhanCreateCardCustomerInfoScreen()));
                          }
                      }
                      },
                      icon: Icon(Icons.add, color: Colors.white),
                      style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
                    ),
                    AppIconButton(
                      onPressed: () {
                        Navigator.of(context).push(commonRoute(LpSupport(showBackButton: true, ticketTag: TicketTags.ENDHAN), isForward: true));
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${context.appText.myCards} (${context.appText.idHpcl} ${state.cardsState?.data?.data?.endhanCustomerId ?? ''})',
                                    style: AppTextStyle.h5.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  // Show balance if available
                                  if (state.cardBalanceState?.status == Status.SUCCESS)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${context.appText.balance}: ',
                                            style: AppTextStyle.body3.copyWith(
                                              color: AppColors.greyTextColor,
                                            ),
                                          ),
                                          Text(
                                            state.cardBalanceState?.data?.data?.balance?.hasBalance == true
                                                ? '₹${state.cardBalanceState?.data?.data?.balance?.totalBalance.toStringAsFixed(2)}'
                                                : '₹0.00',
                                            style: AppTextStyle.body3.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: state.cardBalanceState?.data?.data?.balance?.hasBalance == true
                                                  ? AppColors.primaryColor
                                                  : AppColors.greyTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),

                              InkWell(
                                onTap: (){
                                  Navigator.push(context,commonRoute(EndhanTransactionScreen()));
                                },
                                child:
                                Row(children: [
                                  Text(context.appText.transactions,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                    ),),
                                  Icon(Icons.arrow_forward_ios,color: AppColors.primaryColor,size: 15,),
                                ],),
                              )

                            ],
                          )

                      ),
                      12.height,
                      AppSearchBar(
                        searchController: _searchController,
                        hintText: context.appText.search,
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
                title: Text(context.appText.fuelCard),
                centreTile: false,
                onLeadingTap: () => _safeNavigateBack(context),
              ),
              body: const Center(child: AppLoadingWidget()),
            );
          
          },
        ),
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
                context.appText.noFuelCardsFound,
                style: AppTextStyle.h5.copyWith(color: AppColors.greyTextColor),
              ),
              8.height,
              Text(
                context.appText.addYourFirstFuelCard,
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

      // Show "no data found" message if search returns no results
      if (_searchText.isNotEmpty && filteredCards.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.greyTextColor,
              ),
              16.height,
              Text(
                context.appText.noCardsFound,
                style: AppTextStyle.h5.copyWith(color: AppColors.greyTextColor),
              ),
              8.height,
              Text(
                '${context.appText.noCardsFound} "$_searchText"',
                style: AppTextStyle.body3.copyWith(color: AppColors.greyTextColor),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: filteredCards.length,
        itemBuilder: (context, index) {
          final card = filteredCards[index];
          // Convert EnDhanCardModel to Map for EndhanCardItem
          final cardMap = {
            'cardNumber':card.cardNumber ?? '',
            // 'cardNumber': _maskCardNumber(card.cardNumber ?? ''),
            'vehicleNumber': (card.vehicleNumber ?? '').formatVehicleNumberForDisplay,
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

  Widget enDhanBenifitsWidget(BuildContext context, {bool showKycScreen = false}){
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
                title: context.appText.buyNewFuelCard,
                onPressed: (){
                  final serverStatus = context.read<EnDhanCubit>().state.endhanServerStatusState;
                  if (serverStatus?.status == Status.LOADING) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(context.appText.checkingEndhanServer)),
                    );
                    return;
                  }
                  if (serverStatus?.status == Status.ERROR) {
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(context.appText.couldNotCheckEndhanServerStatus)),
                    );
                    return;
                  }
                  if (serverStatus?.data?["success"] == false) {
                    AppDialog.show(
                      context,
                      dismissible: true,
                      child: CommonDialogView(
                        hideCloseButton: true,
                        onTapSingleButton: () => Navigator.of(context).pop(),
                        onSingleButtonText: context.appText.ok,
                        child: Text(
                          serverStatus?.data?["message"] ?? context.appText.endhanServerNotWorking,
                          style: AppTextStyle.h5.copyWith(color: Colors.red),
                        ),
                      ),
                    );
                    return;
                  }
                  if (showKycScreen) {
                    final kycData = context.read<EnDhanCubit>().state.kycData;
                    final document = kycData?.document;

                    Navigator.push(
                      context,
                      commonRoute(
                        EndhanKycScreen(
                          aadhaarPrefill: document?.aadhar?.replaceAll(' ', ''),
                          panPrefill: document?.pan,
                          isAadhaarVerified: document?.aadhar?.isNotEmpty ?? false, // or true if you add logic for it
                          isPanVerified: document?.panImage != null && document!.panImage!.isNotEmpty,
                          showPanUpload: document?.pan?.isEmpty ?? true,
                          // panPrefill: 'AXSPA8900K',
                          // isPanVerified: true,
                        ),
                      ),
                    );
                  } else {
                    // Navigate to create card screen if user has KYC documents but no cards
                    Navigator.push(context,commonRoute(EndhanCreateCardCustomerInfoScreen()));
                  }
                }
            ),
          ),
        ),
      ],
    );
  }

  Widget buildenDhanProductImageWidget(BuildContext context){
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.2,
      color: AppColors.lightPrimaryColor,
      child: Image.asset(AppImage.png.endhanCard, width: 150),
    );
  }

  Widget buildenDhanBenefitsDetailsWidget(BuildContext context) {
    Widget benefitItem(String title, String subtitle) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyle.h5),
            5.height,
            Text(
              subtitle,
              style: AppTextStyle.body3.copyWith(color: AppColors.greyTextColor),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.appText.benefitsOfFuelCard, style: AppTextStyle.h4),
        20.height,

        benefitItem(
          context.appText.cashlessFuelTollTitle,
          context.appText.cashlessFuelTollDesc,
        ),
        benefitItem(
          context.appText.acceptedPumpsTitle,
          context.appText.acceptedPumpsDesc,
        ),
        benefitItem(
          context.appText.spendingLimitTitle,
          context.appText.spendingLimitDesc,
        ),
        benefitItem(
          context.appText.centralizedFinanceTitle,
          context.appText.centralizedFinanceDesc,
        ),
        benefitItem(
          context.appText.cashbackTitle,
          context.appText.cashbackDesc,
        ),
        benefitItem(
          context.appText.insuranceTitle,
          context.appText.insuranceDesc,
        ),
        benefitItem(
          context.appText.breakdownSupportTitle,
          context.appText.breakdownSupportDesc,
        ),
      ],
    ).paddingSymmetric(horizontal: commonSafeAreaPadding);
  }
  Widget buildGroBannerImageWidget(){
    return Image.asset(AppImage.png.groBanner);
  }
}

