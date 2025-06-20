import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_event.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_state.dart';
import 'package:gro_one_app/features/kavach/view/kavach_models_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/choose_your_preference_form.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/widgets/app_error_widget.dart';
import 'package:gro_one_app/utils/widgets/app_loading_widget.dart';
import 'package:gro_one_app/utils/widgets/common_app_bar.dart';
import '../../../dependency_injection/locator.dart';


class KavachChooseYourPreferenceScreen extends StatefulWidget {
  const KavachChooseYourPreferenceScreen({super.key});

  @override
  State<KavachChooseYourPreferenceScreen> createState() => _KavachChooseYourPreferenceScreenState();
}

class _KavachChooseYourPreferenceScreenState extends State<KavachChooseYourPreferenceScreen> {
  late final KavachProductsListBloc _bloc;

  @override
  void initState() {
    super.initState();
    // Get the bloc from the dependency injection
    _bloc = locator<KavachProductsListBloc>();
    // Fetch masters data when the screen initializes
    _bloc.add(FetchMastersData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        centreTile: false,
        title: context.appText.tankLock,
        actions: [
          AppIconButton(
            onPressed: () {},
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryColor,
          ),
          10.width,
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<KavachProductsListBloc, KavachProductsListState>(
          bloc: _bloc,
          builder: (context, state) {
            // Handle different UI states based on the masters data status
            if (state.mastersLoading) {
              // Show loading indicator while fetching data
              return const AppLoadingWidget();

            } else if (state.mastersError != null) {
              // Show error widget with retry option
              return AppErrorWidget(
                error: state.mastersError!,
                onRetry: () => _bloc.add(FetchMastersData()),
              );
            } else if (state.mastersData != null) {

              // Show the banner and choose your preference form with fetched data
              return SingleChildScrollView(
                child: Column(
                  children: [
                    //to show the image
                    _buildBannerSection(),

                    20.height,

                    ChooseYourPreferenceForm(
                      vehicleFilters: state.mastersData!.data.vehicleFilters,
                      onPreferenceChanged: (preferences) {
                        // Handle preference changes from the form
                        _bloc.add(UpdateUserPreferences(preferences));
                      },
                      onApply: () {
                        // Navigate to models screen when preferences are applied
                        // Pass the current preferences to the models screen
                        final currentPreferences = state.userPreferences;
                        Navigator.of(context).push(
                          commonRoute(
                            KavachModelsScreen(
                              initialPreferences: currentPreferences,
                            ),
                          ),
                        );
                      },
                      onCancel: () {
                        // Go back to previous screen when cancelled
                        Navigator.of(context).pop();
                      },
                      onSupport: () {
                        // Handle support button when BS6 is selected
                        // You can navigate to support screen or show support dialog
                        print('Support requested for BS6 engine type');
                    
                       
                      },
                    ),

                    20.height,
                    
                  ],
                ),
              );
            } else {
              // Show nothing while initializing
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  /// Builds the banner section with truck image and kavach product overlay
  Widget _buildBannerSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      width: double.infinity,
      height: screenHeight * 0.22, // Responsive height using MediaQuery
      decoration: BoxDecoration(
        color: AppColors.lightPrimaryColor,
      ),
      child: Image.asset( AppImage.png.newTruck, width: double.infinity,   height: double.infinity,   fit: BoxFit.cover, ),
    );
  }
}
