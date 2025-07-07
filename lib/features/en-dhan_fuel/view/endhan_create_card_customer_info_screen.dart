import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_create_card_info_screen.dart';
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

import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../kavach/view/kavach_support_screen.dart';

class EndhanCreateCardCustomerInfoScreen extends StatelessWidget {
  const EndhanCreateCardCustomerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = locator<EnDhanCubit>();
    final formKey = GlobalKey<FormState>();

    // Initialize data when widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset form data to ensure clean state
      cubit.resetFormData();

      // Fetch master data when screen loads
      cubit.fetchStates();
      cubit.fetchZonalOffices();
    });

    return BlocBuilder<EnDhanCubit, EnDhanState>(
      bloc: cubit,
      builder: (context, state) {
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
                            title: "Customer Information",
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
                          Text("Title & Name *", style: AppTextStyle.body3),
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
                                child: AppTextField(
                                  //labelText: 'Name',
                                  hintText: 'Enter name',
                                  onChanged:
                                      (val) => cubit.setCustomerName(val),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Name is required';
                                    }
                                    if (value.trim().length < 2) {
                                      return 'Name must be at least 2 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          16.height,
                          AppTextField(
                            labelText: 'Mobile Number *',
                            hintText: '+91 9876987654',
                            keyboardType: TextInputType.phone,
                            onChanged: (val) => cubit.setMobile(val),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Mobile number is required';
                              }
                              // Basic mobile number validation for Indian numbers
                              final mobileRegex = RegExp(
                                r'^(\+91\s?)?[6-9]\d{9}$',
                              );
                              if (!mobileRegex.hasMatch(value.trim())) {
                                return 'Please enter a valid mobile number';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            labelText: 'PAN Number *',
                            hintText: 'ABCDE1234F',
                            onChanged: (val) => cubit.setPan(val),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'PAN number is required';
                              }
                              // PAN validation
                              final panRegex = RegExp(
                                r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                              );
                              if (!panRegex.hasMatch(
                                value.trim().toUpperCase(),
                              )) {
                                return 'Please enter a valid PAN number';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            labelText: 'Email Address *',
                            hintText: 'example@email.com',
                            onChanged: (val) => cubit.setEmail(val),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email address is required';
                              }
                              // Email validation
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          // Zonal Office Dropdown
                          AppDropdown(
                            labelText: 'Zonal Office *',
                            dropdownValue:
                                state.selectedZonalOfficeId?.toString(),
                            dropDownList:
                                state.zonalOffices.isNotEmpty
                                    ? state.zonalOffices
                                        .map(
                                          (zonal) => DropdownMenuItem(
                                            value:
                                                (zonal['id'] ?? '').toString(),
                                            child: Text(
                                              zonal['zone_name'] ?? '',
                                            ),
                                          ),
                                        )
                                        .toList()
                                    : [
                                      DropdownMenuItem(
                                        value: '',
                                        child: Text('Loading zonal offices...'),
                                      ),
                                    ],
                            onChanged: (val) {
                              if (val != null && val.isNotEmpty) {
                                final zoneId = int.tryParse(val);
                                if (zoneId != null) {
                                  cubit.setSelectedZonalOfficeId(zoneId);
                                  cubit.fetchRegionalOffices(zoneId);
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a zonal office';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          // Regional Office Dropdown
                          AppDropdown(
                            labelText: 'Regional Office *',
                            dropdownValue: _getValidRegionalOfficeValue(state),
                            dropDownList:
                                state.regionalOffices.isNotEmpty
                                    ? state.regionalOffices
                                        .map(
                                          (regional) => DropdownMenuItem(
                                            value:
                                                (regional['id'] ?? '')
                                                    .toString(),
                                            child: Text(
                                              regional['region_name'] ?? '',
                                            ),
                                          ),
                                        )
                                        .toSet()
                                        .toList() // Remove duplicates
                                    : [
                                      DropdownMenuItem(
                                        value: '',
                                        child: Text(
                                          'Select zonal office first',
                                        ),
                                      ),
                                    ],
                            onChanged: (val) {
                              if (val != null && val.isNotEmpty) {
                                final regionalId = int.tryParse(val);
                                if (regionalId != null) {
                                  cubit.setSelectedRegionalOfficeId(regionalId);
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a regional office';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            labelText: 'Address Line 1 *',
                            hintText: 'Enter',
                            onChanged: (val) => cubit.setAddress1(val),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Address line 1 is required';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            labelText: 'Address Line 2 *',
                            hintText: 'Enter',
                            onChanged: (val) => cubit.setAddress2(val),
                          ),
                          16.height,

                          // State Dropdown
                          AppDropdown(
                            labelText: 'State *',
                            dropdownValue: state.selectedStateId?.toString(),
                            dropDownList:
                                state.states.isNotEmpty
                                    ? state.states
                                        .map<DropdownMenuItem<String>>(
                                          (stateItem) =>
                                              DropdownMenuItem<String>(
                                                value:
                                                    (stateItem['id'] ?? '')
                                                        .toString(),
                                                child: Text(
                                                  stateItem['name'] ?? '',
                                                ),
                                              ),
                                        )
                                        .toList()
                                    : [
                                      DropdownMenuItem(
                                        value: '',
                                        child: Text('Loading states...'),
                                      ),
                                    ],
                            onChanged: (val) {
                              if (val != null && val.isNotEmpty) {
                                final stateId = int.tryParse(val);
                                if (stateId != null) {
                                  cubit.setSelectedStateId(stateId);
                                  cubit.fetchDistricts(stateId);
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a state';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          // District Dropdown
                          AppDropdown(
                            labelText: 'District *',
                            dropdownValue: _getValidDistrictValue(state),
                            dropDownList:
                                state.districts.isNotEmpty
                                    ? state.districts
                                        .map<DropdownMenuItem<String>>(
                                          (district) =>
                                              DropdownMenuItem<String>(
                                                value:
                                                    (district['id'] ?? '')
                                                        .toString(),
                                                child: Text(
                                                  district['district_name'] ??
                                                      '',
                                                ),
                                              ),
                                        )
                                        .toSet()
                                        .toList() // Remove duplicates
                                    : [
                                      DropdownMenuItem(
                                        value: '',
                                        child: Text('Select state first'),
                                      ),
                                    ],
                            onChanged: (val) {
                              if (val != null && val.isNotEmpty) {
                                final districtId = int.tryParse(val);
                                if (districtId != null) {
                                  cubit.setSelectedDistrictId(districtId);
                                }
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a district';
                              }
                              return null;
                            },
                          ),

                          16.height,
                          AppTextField(
                            labelText: 'City Name *',
                            hintText: 'Enter city name',
                            onChanged:
                                (val) => cubit.setCommunicationCityName(val),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'City name is required';
                              }
                              if (value.trim().length < 2) {
                                return 'City name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                          16.height,
                          AppTextField(
                            labelText: 'Pincode *',
                            hintText: 'Enter pincode',
                            keyboardType: TextInputType.number,
                            onChanged: (val) => cubit.setPincode(val),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Pincode is required';
                              }
                              // Pincode validation for India (6 digits)
                              final pincodeRegex = RegExp(r'^[1-9][0-9]{5}$');
                              if (!pincodeRegex.hasMatch(value.trim())) {
                                return 'Please enter a valid 6-digit pincode';
                              }
                              return null;
                            },
                          ),
                          32.height,
                          AppButton(
                            title: 'Next',
                            style: AppButtonStyle.primary,
                            onPressed: () {
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
                    24.height,
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
