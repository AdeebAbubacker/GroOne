import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/view/endhan_create_new_card_screen.dart';
import 'package:gro_one_app/features/en-dhan(fuel)/widgets/endhan_card_item.dart';
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
  final cubit = locator<EnDhanCubit>();
  final TextEditingController _searchController = TextEditingController();

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
    // Check KYC documents for customer
    cubit.checkKycDocuments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    cubit.resetKycCheckUIState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EnDhanCubit, EnDhanState>(
      bloc: cubit,
      listenWhen: (previous, current) => previous.kycCheckState != current.kycCheckState,
      listener: (context, state) {
        if (state.kycCheckState?.status == Status.ERROR) {
          // Handle error - show new user screen as fallback
          setState(() {
            _error = state.kycCheckState?.errorType?.getText(context);
          });
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

        // Show error state
        if (state.kycCheckState?.status == Status.ERROR) {
          return Scaffold(
            appBar: CommonAppBar(
              title: context.appText.fuelCard,
              centreTile: false,
            ),
            body: Center(
              child: AppErrorWidget(
                error: state.kycCheckState?.errorType ?? GenericError(),
                onRetry: () => cubit.checkKycDocuments(),
              ),
            ),
          );
        }

        // Show new user screen if no KYC documents found
        if (state.kycCheckState?.status == Status.SUCCESS && !state.hasKycDocuments) {
          return Scaffold(
            appBar: CommonAppBar(
              title: context.appText.fuelCard,
              centreTile: false,
              actions: [
                AppIconButton(
                  onPressed: () {},
                  icon: AppIcons.svg.filledSupport,
                  iconColor: AppColors.primaryButtonColor,
                ),
                10.width,
              ],
            ),
            body: SafeArea(child: enDhanBenifitsWidget(context)),
          );
        }

        // Show existing cards screen if KYC documents found
        return Scaffold(
          backgroundColor: AppColors.blackishWhite,
          appBar: CommonAppBar(
            title: 'eN-Dhan Card',
            centreTile: false,
            actions: [
              AppIconButton(
                onPressed: () {
                  Navigator.push(context, commonRoute(EndhanCreateNewCardScreen()));
                },
                icon: Icon(Icons.add, color: Colors.white),
                style: AppButtonStyle.circularPrimaryColorIconButtonStyle,
              ),
              AppIconButton(
                onPressed: () {},
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
                    'My Cards (ID: HPCL 43352)',
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
                  child: _isLoading
                      ? const AppLoadingWidget()
                      : _error != null
                          ? AppErrorWidget(
                              error: GenericError(),
                              onRetry: () {
                                setState(() {
                                  _error = null;
                                  _isLoading = false;
                                });
                              },
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              itemCount: _cards
                                  .where((card) => card['vehicleNumber']
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchText.toLowerCase()) ||
                                      card['cardNumber']
                                          .toString()
                                          .toLowerCase()
                                          .contains(_searchText.toLowerCase()))
                                  .length,
                              itemBuilder: (context, index) {
                                final filteredCards = _cards
                                    .where((card) => card['vehicleNumber']
                                        .toString()
                                        .toLowerCase()
                                        .contains(_searchText.toLowerCase()) ||
                                        card['cardNumber']
                                            .toString()
                                            .toLowerCase()
                                            .contains(_searchText.toLowerCase()))
                                    .toList();
                                final card = filteredCards[index];
                                return EndhanCardItem(card: card).paddingOnly(bottom: 12);
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
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
