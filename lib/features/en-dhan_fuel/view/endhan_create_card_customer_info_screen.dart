import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_create_card_info_screen.dart';
import 'package:gro_one_app/features/login/repository/user_information_repository.dart';
import 'package:gro_one_app/features/profile/cubit/profile_cubit.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/data/model/result.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/features/kavach/model/kavach_user_model.dart';
import 'package:gro_one_app/features/en-dhan_fuel/repository/en-dhan_repository.dart';
import 'package:gro_one_app/utils/custom_log.dart';
import 'package:gro_one_app/utils/constant_variables.dart';

import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../kavach/view/kavach_support_screen.dart';
import '../widgets/zonal_office_autocomplete_textfield.dart';
import '../widgets/regional_office_autocomplete_textfield.dart';
import '../widgets/state_autocomplete_textfield.dart';
import '../widgets/district_autocomplete_textfield.dart';
import '../widgets/enhanced_dropdown_field.dart';

class EndhanCreateCardCustomerInfoScreen extends StatefulWidget {
  const EndhanCreateCardCustomerInfoScreen({super.key});

  @override
  State<EndhanCreateCardCustomerInfoScreen> createState() => _EndhanCreateCardCustomerInfoScreenState();
}

class _EndhanCreateCardCustomerInfoScreenState extends State<EndhanCreateCardCustomerInfoScreen> {
  final referralCodeController = TextEditingController();
  final zonalOfficeController = TextEditingController();
  final regionalOfficeController = TextEditingController();
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  // Email controller removed since field is now read-only
  final panController = TextEditingController(); // Add PAN controller
  final nameController = TextEditingController(); // Add PAN controller
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityNameController = TextEditingController();
  final pincodeController = TextEditingController();

  @override
  void dispose() {
    referralCodeController.dispose();
    zonalOfficeController.dispose();
    regionalOfficeController.dispose();
    stateController.dispose();
    districtController.dispose();
    // Email controller disposal removed since field is now read-only
    panController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityNameController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  /// Debug method to log current state of controllers and cubit
  void _logCurrentState(EnDhanCubit cubit) {
    // Debug logging removed for production
  }

  /// Force sync all controller values to cubit state
  void _forceSyncControllersToCubit(EnDhanCubit cubit) {
    // Email sync removed since field is now read-only
    // PAN sync removed since field is now read-only
    cubit.setAddress1(address1Controller.text);
    cubit.setAddress2(address2Controller.text);
    cubit.setCommunicationCityName(cityNameController.text.trim().replaceAll(multipleSpacesRegex, ' '));
    cubit.setPincode(pincodeController.text);
    cubit.setReferralCode(referralCodeController.text);
  }

  /// Add listeners to all controllers to sync with cubit state
  void _addControllerListeners() {
    final cubit = locator<EnDhanCubit>();
    
    referralCodeController.addListener(() {
      cubit.setReferralCode(referralCodeController.text);
    });
    
    // Email controller listener removed since field is now read-only
    
    // PAN controller listener removed since field is now read-only
    
    address1Controller.addListener(() {
      cubit.setAddress1(address1Controller.text);
    });
    
    address2Controller.addListener(() {
      cubit.setAddress2(address2Controller.text);
    });
    
    cityNameController.addListener(() {
      final cleanedValue = cityNameController.text.trim().replaceAll(multipleSpacesRegex, ' ');
      cubit.setCommunicationCityName(cleanedValue);
    });
    
    // Remove pincode listener to avoid circular updates causing cursor jumping
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with current state values immediately
    final cubit = locator<EnDhanCubit>();
    // Email controller initialization removed since field is now read-only
    // Don't initialize PAN controller to avoid cursor jumping
    // address1Controller.text = cubit.state.address1;
    // address2Controller.text = cubit.state.address2;
    // cityNameController.text = cubit.state.cityName;
    // // Don't initialize pincode controller to avoid cursor jumping
    // referralCodeController.text = cubit.state.referralCode;
    
    // Add listeners to sync controllers with cubit state
    _addControllerListeners();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = locator<EnDhanCubit>();
    final profileCubit = locator<ProfileCubit>();
    final userInfoRepo = locator<UserInformationRepository>();
    final formKey = GlobalKey<FormState>();



    // Initialize data when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Only reset form data if it's completely empty (first time loading)
      // Don't reset if user is coming back from card info screen
      if (cubit.state.customerName.isEmpty && 
          cubit.state.mobile.isEmpty && 
          cubit.state.address1.isEmpty &&
          cubit.state.email.isEmpty &&
          cubit.state.pan.isEmpty) {
        cubit.resetFormData();
      } else {
      }

      // Fetch master data when screen loads
      cubit.fetchStates();
      cubit.fetchZonalOffices();
      
      // Check KYC documents to get PAN data if available
      await cubit.checkKycDocuments();
      
      // Auto-populate PAN from KYC data if available and not already set
      if (cubit.state.kycData?.document?.pan != null &&
          cubit.state.kycData!.document!.pan!.isNotEmpty &&
          cubit.state.pan.isEmpty) {
        cubit.setPan(cubit.state.kycData!.document!.pan!);
      }

      // Get username from session first
      String? username = await userInfoRepo.getUsername();
      String? mobileNumber = await userInfoRepo.getUserMobileNumber();
      String? emailID = await userInfoRepo.getUserEmail();
      
      // If username is not in session, fetch from profile
      if (username == null || username.isEmpty) {
        
        // Fetch profile data
        await profileCubit.fetchProfileDetail();
        
        // Get username from profile state
        final profileState = profileCubit.state;
        if (profileState.profileDetailUIState?.data?.customer?.customerName != null) {
          username = profileState.profileDetailUIState!.data!.customer!.customerName;
          mobileNumber = profileState.profileDetailUIState!.data!.customer!.mobileNumber;
          emailID = profileState.profileDetailUIState!.data!.customer!.emailId;
        }
      } else {
      }
      
      // Set username in cubit if available and not already set
      if (username != null && username.isNotEmpty && cubit.state.customerName.isEmpty) {
        cubit.setCustomerName(username);
      }
      // Set mobile number in cubit if available and not already set
      if (mobileNumber != null && mobileNumber.isNotEmpty && cubit.state.mobile.isEmpty) {
        cubit.setMobile(mobileNumber);
      }
      // Set email in cubit if available and not already set
      if (emailID != null && emailID.isNotEmpty && cubit.state.email.isEmpty) {
        cubit.setEmail(emailID);
      }
      

      
      // Update controllers with latest state values after profile data is loaded
      // Set controller values directly (listeners will handle the sync)
      // Email controller update removed since field is now read-only
      // PAN controller update removed since field is now read-only
      address1Controller.text = cubit.state.address1;
      address2Controller.text = cubit.state.address2;
      cityNameController.text = cubit.state.cityName;
      pincodeController.text = cubit.state.pincode;
      referralCodeController.text = cubit.state.referralCode;
    });

    return BlocConsumer<EnDhanCubit, EnDhanState>(
      listener: (context, state) {
        if (panController.text != state.pan) {
          panController.text = state.pan;
        }
        nameController.text = state.customerName;
        address1Controller.text = cubit.state.address1;
        address2Controller.text = cubit.state.address2;
        cityNameController.text = cubit.state.cityName;
        // Don't initialize pincode controller to avoid cursor jumping
        referralCodeController.text = cubit.state.referralCode;
      },
      bloc: cubit,
      builder: (context, state) {
        print('DEBUG: BlocBuilder rebuild - selectedZonalOfficeId: ${state.selectedZonalOfficeId}, selectedRegionalOfficeId: ${state.selectedRegionalOfficeId}, selectedStateId: ${state.selectedStateId}, selectedDistrictId: ${state.selectedDistrictId}, selectedDistrictName: ${state.selectedDistrictName}');
        print('DEBUG: BlocBuilder rebuild - states: ${state.states.length}, zonalOffices: ${state.zonalOffices.length}, regionalOffices: ${state.regionalOffices.length}, districts: ${state.districts.length}');
        // Auto-populate PAN from KYC data if available and not already set
        // if (state.kycCheckState?.status == Status.SUCCESS &&
        //     state.hasKycDocuments &&
        //     state.kycData?.document?.pan != null &&
        //     state.kycData!.document!.pan!.isNotEmpty &&
        //     state.pan.isEmpty) {
        //   // Use Future.microtask to avoid setState during build
        //   // Future.microtask(() => cubit.setPan(state.kycData!.document!.pan!));
        // }
        //
        return Scaffold(
          backgroundColor: AppColors.white,

          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Header with blue background, title, and card image
                    Container(
                      width: double.infinity,
                      decoration: commonContainerDecoration(
                        color: const Color(0xFFD6EEFB),
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        children: [
                          CommonAppBar(
                            title: context.appText.customerInformation,
                            backgroundColor: Color(0xFFD6EEFB),
                            actions: [
                              AppIconButton(
                                onPressed: () {
                                  Navigator.push(context,commonRoute(KavachSupportScreen()));
                                },
                                icon: AppIcons.svg.filledSupport,
                                iconColor: AppColors.primaryColor,
                              ),
                            ],
                          ),
                          8.height,
                          Image.asset(
                            AppImage.png.endhanCard,
                            width: 140,
                            height: 90,
                          ),
                          8.height,
                        ],
                      ),
                    ),


                      
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // padding: EdgeInsets.all(20),
                        children: [
                          24.height,

                          // Title & Name
                          Text("${context.appText.titleAndName} *", style: AppTextStyle.body3),
                          6.height,
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: AppDropdown(
                                  // labelText: 'Title',
                                  dropdownValue:
                                      state.title.isNotEmpty
                                          ? state.title
                                          : 'Mr',
                                  dropDownList: const [
                                    DropdownMenuItem(
                                      value: 'Mr',
                                      child: Text('Mr'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Ms',
                                      child: Text('Ms'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Mrs',
                                      child: Text('Mrs'),
                                    ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      cubit.setTitle(val);
                                    }
                                  },
                                ),
                              ),
                              10.width,
                              Expanded(
                                flex: 5,
                                child: AppTextField(                                  decoration: commonInputDecoration(
                                    hintText: context.appText.enterName,
                                    fillColor: AppColors.disabledFieldBackgroundColor,
                                    focusColor: AppColors.disabledFieldBackgroundColor,
                                  ),
                                  //labelText: 'Name',
                                  hintText: context.appText.enterName,
                                  // controller: TextEditingController(text: state.customerName),
                                  controller: nameController,
                                  readOnly: true, // Make the field non-editable
                                  onChanged: null, // Remove onChanged since field is disabled
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return context.appText.nameRequired;
                                    }
                                    if (value.trim().length < 2) {
                                      return context.appText.nameMustBeAtLeast2Characters;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          16.height,
                          AppTextField(
                            labelText: '${context.appText.mobileNumber} *',
                            hintText: '+91 9876987654',
                            controller: TextEditingController(text: state.mobile),
                            readOnly: true,
                            keyboardType: TextInputType.phone,
                            // validator: (value) {
                            //   if (value == null || value.trim().isEmpty) {
                            //     return context.appText.mobileNumberRequired;
                            //   }
                            //   // Basic mobile number validation for Indian numbers
                            //   final mobileRegex = indianMobileNumberRegex;
                            //   if (!mobileRegex.hasMatch(value.trim())) {
                            //     return context.appText.validMobileNumber;
                            //   }
                            //   return null;
                            // },
                            decoration: commonInputDecoration(
                              hintText: '+91 9876987654',
                              fillColor: AppColors.disabledFieldBackgroundColor,
                              focusColor: AppColors.disabledFieldBackgroundColor,
                            ),
                          ),
                          16.height,
                          AppTextField(
                            labelText: '${context.appText.panNumber} *',
                            hintText: 'ABCDE1234F',
                            controller: panController,
                            readOnly: state.pan.isNotEmpty, // Read-only if PAN is already present (from KYC or manual entry)
                            maxLength: 10,
                            textCapitalization: TextCapitalization.characters,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(panNumberInputRegex),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: state.pan.isEmpty ? (value) {
                              cubit.setPan(value);
                            } : null,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.appText.panNumberRequired;
                              }
                              // PAN validation
                              final panRegex = panNumberValidationRegex;
                              if (!panRegex.hasMatch(
                                value.trim().toUpperCase(),
                              )) {
                                return context.appText.validPanNumber;
                              }
                              return null;
                            },
                            decoration: commonInputDecoration(
                              hintText: 'ABCDE1234F',
                              fillColor: state.pan.isNotEmpty ? AppColors.disabledFieldBackgroundColor : null,
                              focusColor: state.pan.isNotEmpty ? AppColors.disabledFieldBackgroundColor : null,
                            ),
                          ),
                          16.height,

                          // email  id feild
                          AppTextField(
                            labelText: '${context.appText.emailAddress} *',
                            hintText: 'example@email.com',
                            controller: TextEditingController(text: state.email),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.appText.emailAddressRequired;
                              }
                              // Email validation
                              final emailRegex = emailValidationRegex;
                              if (!emailRegex.hasMatch(value.trim())) {
                                return context.appText.validEmailAddress;
                              }
                              return null;
                            },
                            decoration: commonInputDecoration(
                              hintText: 'example@email.com',
                              fillColor: AppColors.disabledFieldBackgroundColor,
                              focusColor: AppColors.disabledFieldBackgroundColor,
                            ),
                          ),

                          16.height,
                          //pincode feild
                           AppTextField(
                            labelText: 'Pincode *',
                            hintText: 'Enter pincode',
                            controller: pincodeController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              print('DEBUG: Pincode onChanged called with value: $value, length: ${value.length}');
                              cubit.setPincode(value);
                              // Call API when pincode is 6 digits
                              if (value.length == 6) {
                                print('DEBUG: Calling getPincode with value: $value');
                                cubit.getPincode(value);
                              } else {
                                print('DEBUG: Pincode length is ${value.length}, not calling API');
                              }
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Pincode is required';
                              }
                              // Pincode validation for India (6 digits, only numbers)
                              final pincodeRegex = indianPincodeRegex;
                              if (!pincodeRegex.hasMatch(value.trim())) {
                                return 'Please enter a valid 6-digit pincode';
                              }
                              if (value.trim().length != 6) {
                                return 'Pincode must be exactly 6 digits';
                              }
                              return null;
                            },
                          ),
                          

                          16.height,
                                                     // Zonal Office Dropdown
                           Builder(
                             builder: (context) {
                               print('DEBUG: Zonal field - selectedZonalOfficeId: ${state.selectedZonalOfficeId}, zonalOffices count: ${state.zonalOffices.length}');
                               return EnhancedDropdownField(
                                 labelText: '${context.appText.zonalOffice} *',
                                 hintText: 'Select zonal office',
                                 value: state.selectedZonalOfficeId?.toString(),
                                 options: state.zonalOffices.map((office) => {
                                   'id': office['id'],
                                   'name': office['zone_name'],
                                 }).toList(),
                                 onChanged: (zoneId) {
                                   cubit.setSelectedZonalOfficeId(int.parse(zoneId));
                                   cubit.fetchRegionalOffices(int.parse(zoneId));
                                   // Clear regional office selection when zonal office changes
                                   regionalOfficeController.clear();
                                 },
                                 isLoading: state.zonalOfficesState?.status == Status.LOADING,
                                 validator: (value) {
                                   if (value == null || value.trim().isEmpty) {
                                     return context.appText.selectZonalOffice;
                                   }
                                   return null;
                                 },
                               );
                             },
                           ),
                          16.height,
                                                     // Regional Office Dropdown
                           Builder(
                             builder: (context) {
                               print('DEBUG: Regional field - selectedRegionalOfficeId: ${state.selectedRegionalOfficeId}, regionalOffices count: ${state.regionalOffices.length}');
                               return EnhancedDropdownField(
                                 labelText: '${context.appText.regionalOffice} *',
                                 hintText: 'Select regional office',
                                 value: state.selectedRegionalOfficeId?.toString(),
                                 options: state.regionalOffices.map((office) => {
                                   'id': office['id'],
                                   'name': office['region_name'],
                                 }).toList(),
                                 onChanged: (regionalId) {
                                   cubit.setSelectedRegionalOfficeId(int.parse(regionalId));
                                 },
                                 isLoading: state.regionalOfficesState?.status == Status.LOADING,
                                 validator: (value) {
                                   if (value == null || value.trim().isEmpty) {
                                     return context.appText.selectRegionalOffice;
                                   }
                                   return null;
                                 },
                               );
                             },
                           ),
                          16.height,
                          AppTextField(
                            labelText: '${context.appText.addressLine1} *',
                            hintText: 'Enter',
                            controller: address1Controller,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.appText.addressLine1Required;
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            labelText: '${context.appText.addressLine2} *',
                            hintText: 'Enter',
                            controller: address2Controller,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return context.appText.addressLine2Required;
                              }
                              return null;
                            },
                          ),
                          16.height,

                                                     // State Dropdown
                           Builder(
                             builder: (context) {
                               print('DEBUG: State field - selectedStateId: ${state.selectedStateId}, states count: ${state.states.length}');
                               return EnhancedDropdownField(
                                 labelText: '${context.appText.state} *',
                                 hintText: 'Select state',
                                 value: state.selectedStateId?.toString(),
                                 options: state.states.map((state) => {
                                   'id': state['id'],
                                   'name': state['state_name'],
                                 }).toList(),
                                 onChanged: (stateId) {
                                   cubit.setSelectedStateId(int.parse(stateId));
                                   cubit.fetchDistricts(int.parse(stateId));
                                   // Clear district selection when state changes
                                   districtController.clear();
                                 },
                                 isLoading: state.statesState?.status == Status.LOADING,
                                 validator: (value) {
                                   if (value == null || value.trim().isEmpty) {
                                     return context.appText.pleaseSelectState;
                                   }
                                   return null;
                                 },
                               );
                             },
                           ),
                           16.height,
                                                       // District Dropdown
                            Builder(
                              builder: (context) {
                                final districtValue = state.selectedDistrictName?.isNotEmpty == true 
                                    ? state.selectedDistrictName 
                                    : state.selectedDistrictId?.toString();
                                print('DEBUG: District field - selectedDistrictName: ${state.selectedDistrictName}, selectedDistrictId: ${state.selectedDistrictId}, districtValue: $districtValue, districts count: ${state.districts.length}');
                                return EnhancedDropdownField(
                                  labelText: '${context.appText.district} *',
                                  hintText: 'Select district',
                                  value: districtValue,
                                  options: state.districts.map((district) => {
                                    'id': district['id'],
                                    'name': district['district_name'],
                                  }).toList(),
                                  onChanged: (districtId) {
                                    cubit.setSelectedDistrictId(int.parse(districtId));
                                  },
                                  isLoading: state.districtsState?.status == Status.LOADING,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please select a district';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),

                          16.height,
                          AppTextField(
                            labelText: 'City Name *',
                            hintText: 'Enter city name',
                            controller: cityNameController,
                            maxLength: 50,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(cityNameInputRegex),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'City name is required';
                              }
                              if (value.trim().length < 2) {
                                return 'City name must be at least 2 characters';
                              }
                              if (value.trim().length > 50) {
                                return 'City name cannot exceed 50 characters';
                              }
                              // Check if contains only alphabets and spaces
                              final cityRegex = cityNameValidationRegex;
                              if (!cityRegex.hasMatch(value.trim())) {
                                return 'City name can only contain alphabets and spaces';
                              }
                              return null;
                            },
                          ),
                          
                          16.height,
                      
                          EnDhanReferralAutoCompleteTextField(
                            controller: referralCodeController,
                            labelText: 'Referral Code (Optional)',
                            onSelected: (value) {
                              cubit.setReferralCode(value);
                            },
                          ),
                          50.height,
                          AppButton(
                            title: 'Next',
                            style: AppButtonStyle.primary,
                            onPressed: () async {
                              // Force sync all controller values to cubit state before validation
                              _forceSyncControllersToCubit(cubit);
                              await Future.delayed(Duration(milliseconds: 50));
                              if (formKey.currentState?.validate() ?? false) {
                                // Additional validation for dropdowns and required fields
                                if (state.selectedZonalOfficeId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please select a zonal office',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (state.selectedRegionalOfficeId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please select a regional office',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                if (state.selectedStateId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a state'),
                                    ),
                                  );
                                  return;
                                }
                                if (state.selectedDistrictId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a district'),
                                    ),
                                  );
                                  return;
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => EndhanCreateCardInfoScreen(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                    ),
                    100.height,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper method to get valid regional office value for dropdown
  String? _getValidRegionalOfficeValue(EnDhanState state) {
    if (state.selectedRegionalOfficeId == null) return null;

    // Check if the selected regional office ID exists in the current list
    final selectedId = state.selectedRegionalOfficeId.toString();
    final validOffices =
        state.regionalOffices
            .where(
              (regional) => (regional['id'] ?? '').toString() == selectedId,
            )
            .toList();

    // Return the value only if exactly one match is found
    return validOffices.length == 1 ? selectedId : null;
  }

  /// Helper method to get valid district value for dropdown
  String? _getValidDistrictValue(EnDhanState state) {
    if (state.selectedDistrictId == null) return null;

    // Check if the selected district ID exists in the current list
    final selectedId = state.selectedDistrictId.toString();
    final validDistricts =
        state.districts
            .where(
              (district) => (district['id'] ?? '').toString() == selectedId,
            )
            .toList();

    // Return the value only if exactly one match is found
    return validDistricts.length == 1 ? selectedId : null;
  }
}

/// EnDhan-specific referral autocomplete text field widget
class EnDhanReferralAutoCompleteTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String) onSelected;
  final String? Function(String?)? validator;

  const EnDhanReferralAutoCompleteTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onSelected,
    this.validator,
  });

  @override
  State<EnDhanReferralAutoCompleteTextField> createState() => _EnDhanReferralAutoCompleteTextFieldState();
}

class _EnDhanReferralAutoCompleteTextFieldState extends State<EnDhanReferralAutoCompleteTextField> {
  final List<KavachUserModel> allUsers = [];
  final List<KavachUserModel> filteredUsers = [];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  final EnDhanRepository _repository = locator<EnDhanRepository>();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _loadUsers();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _removeOverlay();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        hasError = false;
      });
    }

    try {
      CustomLog.debug(this, "EnDhan Referral - Starting to fetch users...");
      final result = await _repository.fetchUsers();
      CustomLog.debug(this, "EnDhan Referral - Fetch result type: ${result.runtimeType}");
      
      if (result is Success<List<KavachUserModel>>) {
        CustomLog.debug(this, "EnDhan Referral - Successfully fetched ${result.value.length} users");
        if (mounted) {
          setState(() {
            allUsers.clear();
            allUsers.addAll(result.value);
            isLoading = false;
            hasError = false;
          });
        }
      } else if (result is Error<List<KavachUserModel>>) {
        CustomLog.error(this, "EnDhan Referral - Failed to fetch users: ${result.type}", null);
        if (mounted) {
          setState(() {
            hasError = true;
            errorMessage = result.type.getText(context);
            isLoading = false;
          });
        }
      } else {
        CustomLog.error(this, "EnDhan Referral - Unknown result type: ${result.runtimeType}", null);
        if (mounted) {
          setState(() {
            hasError = true;
            errorMessage = 'Failed to load users';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      CustomLog.error(this, "EnDhan Referral - Exception while fetching users", e);
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load users: $e';
          isLoading = false;
        });
      }
    }
  }

  void _onChanged() {
    final query = widget.controller.text.toLowerCase();
    
    if (query.isNotEmpty) {
      filteredUsers.clear();
      filteredUsers.addAll(allUsers
          .where((user) => 
              user.userName.toLowerCase().contains(query) ||
              user.empCode.toLowerCase().contains(query) ||
              '${user.empCode} ${user.userName}'.toLowerCase().contains(query))
          .toList());

      if (filteredUsers.isNotEmpty) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    } else {
      filteredUsers.clear();
      _removeOverlay();
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _showOverlay() {
    _removeOverlay();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 40, // Account for padding
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    dense: true,
                    title: Row(
                      children: [
                        Text(
                          user.empCode,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.userName,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      widget.controller.text = "${user.empCode} ${user.userName}";
                      widget.onSelected(user.empCode);
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            labelText: widget.labelText,
            controller: widget.controller,
            validator: widget.validator,
            decoration: commonInputDecoration(
              hintText: 'Enter referral code',
            ),
          ),
        ],
      ),
    );
  }
}
