import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/cubit/choose_preference_cubit.dart';
import 'package:gro_one_app/features/kavach/cubit/choose_preference_state.dart';
import 'package:gro_one_app/features/kavach/view/kavach_models_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/choose_your_preference_form.dart';
import 'package:gro_one_app/features/kavach/model/kavach_choose_preference_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/widgets/app_error_widget.dart';
import 'package:gro_one_app/utils/widgets/app_loading_widget.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/common_functions.dart';
import 'kavach_support_screen.dart';


class KavachChooseYourPreferenceScreen extends StatefulWidget {
  const KavachChooseYourPreferenceScreen({super.key});

  @override
  State<KavachChooseYourPreferenceScreen> createState() => _KavachChooseYourPreferenceScreenState();
}

class _KavachChooseYourPreferenceScreenState extends State<KavachChooseYourPreferenceScreen> {
  late final ChoosePreferenceCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Get the cubit from the dependency injection
    _cubit = locator<ChoosePreferenceCubit>();
    // Fetch masters data when the screen initializes
    _cubit.fetchMastersData();
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
            onPressed: () {
              Navigator.push(context, commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          5.width,
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ChoosePreferenceCubit, ChoosePreferenceState>(
          bloc: _cubit,
          builder: (context, state) {
            // Handle different UI states based on the masters data status
            if (state.mastersLoading) {
              // Show loading indicator while fetching data
              return const AppLoadingWidget();

            } else if (state.mastersError != null) {
              // Show error widget with retry option
              return AppErrorWidget(
                error: state.mastersError!,
                onRetry: () => _cubit.fetchMastersData(),
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
                        _cubit.updateUserPreferences(preferences);
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
                        commonSupportDialog(context);
                        print('Support requested for BS6 engine type');
                
                      },
                    ).paddingSymmetric(horizontal: 16),

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
      width: screenWidth,
      height: screenHeight * 0.22, 
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImage.png.newTruck),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
