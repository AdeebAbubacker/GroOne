import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'dart:io';
import 'package:gro_one_app/features/en-dhan_fuel/model/en_dhan_models.dart' as models;
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_new_user_and_card_screen.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/data/ui_state/ui_state.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/utils/upload_attachment_files.dart';
import 'package:gro_one_app/features/en-dhan_fuel/widgets/endhan_document_upload_widget.dart';
import 'package:gro_one_app/utils/common_functions.dart';

import '../../../utils/app_dialog.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/common_widgets.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/routing/app_route_name.dart';
import 'package:gro_one_app/features/our_value_added_service/view/en_dhan_card/view/en_dhan_card.dart';

class EndhanCreateCardInfoScreen extends StatefulWidget {
  const EndhanCreateCardInfoScreen({super.key});

  @override
  State<EndhanCreateCardInfoScreen> createState() => _EndhanCreateCardInfoScreenState();
}

class _EndhanCreateCardInfoScreenState extends State<EndhanCreateCardInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> cardData = [
    {
      'vehicleNumber': '',
      'vehicleType': null,
      'vinNumber': '',
      'mobile': '',
      'rcBook': '',
      'rcFile': null,
      'rcFileName': null,
      'rcDocuments': [],
      'controllers': {},
    },
  ];
  List<bool> _expanded = [true];
  bool _isLoading = false;
  int? _currentUploadingCardIndex;
  bool _hasShownSuccessDialog = false;
  bool _hasShownErrorDialog = false;

  @override
  void initState() {
    super.initState();
    // Reset local form data to ensure clean state
    _resetLocalFormData();
    
    // Fetch vehicle types when screen loads
    final cubit = locator<EnDhanCubit>();
    cubit.fetchVehicleTypes();
  }

  @override
  void dispose() {
    // Reset customer creation state when screen is disposed
    final cubit = locator<EnDhanCubit>();
    cubit.resetCustomerCreationState();
    super.dispose();
  }

  void _addNewCard() {
    setState(() {
      cardData.add({
        'vehicleNumber': '',
        'vehicleType': null,
        'vinNumber': '',
        'mobile': '',
        'rcBook': '',
        'rcFile': null,
        'rcFileName': null,
        'rcDocuments': [],
        'controllers': {
          'vehicleNumber': TextEditingController(),
          'vinNumber': TextEditingController(),
          'mobile': TextEditingController(),
          'rcBook': TextEditingController(),
        },
      });
      _expanded.add(false); // default collapsed
    });
    
    // Also add card to cubit state
    final cubit = locator<EnDhanCubit>();
    cubit.addCard();
  }

  Future<void> _pickAndUploadDocument(int cardIndex) async {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Document', style: AppTextStyle.body1),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.clear_rounded)
                )
              ],
            ),
            20.height,
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primaryColor),
              title: Text('Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final result = await ImagePickerFrom.fromCamera();
                print('Camera result: $result');
                if (result != null) {
                  setState(() {
                    cardData[cardIndex]['rcFile'] = 'Uploading...';
                    // Extract just the file name from the path
                    String fileName = result['fileName'];
                    if (fileName.contains('/')) {
                      fileName = fileName.split('/').last;
                    }
                    cardData[cardIndex]['rcFileName'] = fileName;
                  });
                  print('Set uploading - rcFile: ${cardData[cardIndex]['rcFile']}, rcFileName: ${cardData[cardIndex]['rcFileName']}');
                  
                  // Store the current card index for the BlocListener
                  _currentUploadingCardIndex = cardIndex;
                  
                  // Upload document and get the actual URL
                  try {
                    print('Starting upload for card $cardIndex');
                    print('File path: ${result['path']}');
                    
                    // Call the upload method and get the response
                    print('About to call uploadDocument...');
                    final uploadResponse = await locator<EnDhanCubit>().uploadDocument(File(result['path']));
                    print('uploadDocument call completed');
                    
                    if (uploadResponse != null && uploadResponse.data?.url != null) {
                      final uploadedUrl = uploadResponse.data!.url!;
                      print('Upload successful with URL: $uploadedUrl');
                      
                      if (cardIndex < cardData.length) {
                        print('About to update card $cardIndex');
                        print('Before setState - rcFile: ${cardData[cardIndex]['rcFile']}');
                        
                        setState(() {
                          cardData[cardIndex]['rcFile'] = uploadedUrl;
                        });
                        
                        print('After setState - rcFile: ${cardData[cardIndex]['rcFile']}');
                        print('Updated card $cardIndex with actual uploaded URL');
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Document uploaded successfully!')),
                        );
                      } else {
                        print('Card index out of bounds: $cardIndex, cardData length: ${cardData.length}');
                      }
                    } else {
                      print('Upload response is null or missing URL');
                      setState(() {
                        cardData[cardIndex]['rcFile'] = null;
                        cardData[cardIndex]['rcFileName'] = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Upload failed: No URL received')),
                      );
                    }
                  } catch (e) {
                    print('Upload error: $e');
                    setState(() {
                      cardData[cardIndex]['rcFile'] = null;
                      cardData[cardIndex]['rcFileName'] = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Upload failed: $e')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primaryColor),
              title: Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final result = await ImagePickerFrom.fromGallery();
                if (result != null) {
                  setState(() {
                    cardData[cardIndex]['rcFile'] = 'Uploading...';
                    // Extract just the file name from the path
                    String fileName = result['fileName'];
                    if (fileName.contains('/')) {
                      fileName = fileName.split('/').last;
                    }
                    cardData[cardIndex]['rcFileName'] = fileName;
                  });
                  
                  // Upload document and get the actual URL
                  try {
                    final uploadResponse = await locator<EnDhanCubit>().uploadDocument(File(result['path']));
                    
                    if (uploadResponse != null && uploadResponse.data?.url != null) {
                      final uploadedUrl = uploadResponse.data!.url!;
                      
                      if (cardIndex < cardData.length) {
                        setState(() {
                          cardData[cardIndex]['rcFile'] = uploadedUrl;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Document uploaded successfully!')),
                        );
                      }
                    } else {
                      setState(() {
                        cardData[cardIndex]['rcFile'] = null;
                        cardData[cardIndex]['rcFileName'] = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Upload failed: No URL received')),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      cardData[cardIndex]['rcFile'] = null;
                      cardData[cardIndex]['rcFileName'] = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Upload failed: $e')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_file, color: AppColors.primaryColor),
              title: Text('File'),
              onTap: () async {
                Navigator.of(context).pop();
                final result = await pickMultipleFiles();
                if (result != null) {
                  setState(() {
                    cardData[cardIndex]['rcFile'] = 'Uploading...';
                    // Extract just the file name from the path
                    String fileName = result['fileName'];
                    if (fileName.contains('/')) {
                      fileName = fileName.split('/').last;
                    }
                    cardData[cardIndex]['rcFileName'] = fileName;
                  });
                  
                  // Upload document and get the actual URL
                  try {
                    final uploadResponse = await locator<EnDhanCubit>().uploadDocument(File(result['path']));
                    
                    if (uploadResponse != null && uploadResponse.data?.url != null) {
                      final uploadedUrl = uploadResponse.data!.url!;
                      
                      if (cardIndex < cardData.length) {
                        setState(() {
                          cardData[cardIndex]['rcFile'] = uploadedUrl;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Document uploaded successfully!')),
                        );
                      }
                    } else {
                      setState(() {
                        cardData[cardIndex]['rcFile'] = null;
                        cardData[cardIndex]['rcFileName'] = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Upload failed: No URL received')),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      cardData[cardIndex]['rcFile'] = null;
                      cardData[cardIndex]['rcFileName'] = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Upload failed: $e')),
                    );
                  }
                }
              },
            ),
            20.height,
          ],
        ),
      ),
    );
  }

  String getFileNameFromUrl(String url) {
    return url.split('/').last.split('?').first;
  }



  void _handleSaveAndCreate() async {
    // Reset dialog flags when starting new submission
    _hasShownSuccessDialog = false;
    _hasShownErrorDialog = false;
    
    if (_formKey.currentState?.validate() ?? false) {
      // Additional validation for card data
      bool isValid = true;
      String errorMessage = '';
      
      for (int i = 0; i < cardData.length; i++) {
        final card = cardData[i];
        final controllers = card['controllers'] as Map<String, TextEditingController>;
        
        // Validate vehicle number
        if (controllers['vehicleNumber']?.text?.trim().isEmpty ?? true) {
          isValid = false;
          errorMessage = 'Vehicle number is required for card ${i + 1}';
          break;
        }
        
        // Validate vehicle type
        if (card['vehicleType'] == null || card['vehicleType'].toString().isEmpty) {
          isValid = false;
          errorMessage = 'Vehicle type is required for card ${i + 1}';
          break;
        }
        
        // Validate VIN number
        if (controllers['vinNumber']?.text?.trim().isEmpty ?? true) {
          isValid = false;
          errorMessage = 'VIN number is required for card ${i + 1}';
          break;
        }
        
        // Validate mobile number
        if (controllers['mobile']?.text?.trim().isEmpty ?? true) {
          isValid = false;
          errorMessage = 'Mobile number is required for card ${i + 1}';
          break;
        }
        
        // Validate mobile number format
        final mobileRegex = RegExp(r'^(\+91\s?)?[6-9]\d{9}$');
        if (!mobileRegex.hasMatch(controllers['mobile']?.text?.trim() ?? '')) {
          isValid = false;
          errorMessage = 'Please enter a valid mobile number for card ${i + 1}';
          break;
        }
        
        // Validate RC book (used as RC number)
        if (controllers['rcBook']?.text?.trim().isEmpty ?? true) {
          isValid = false;
          errorMessage = 'RC book is required for card ${i + 1}';
          break;
        }
        
        // Validate RC file upload
        if (card['rcFile'] == null) {
          isValid = false;
          errorMessage = 'RC document upload is required for card ${i + 1}';
          break;
        }
      }
      
      if (!isValid) {
        _showErrorDialog(context, errorMessage);
        return;
      }
      
      final cubit = locator<EnDhanCubit>();
      
      // Update cubit with card data from the form
      print('=== DEBUG: UI - Updating cubit with card data ===');
      print('Number of cards in UI: ${cardData.length}');
      
      for (int i = 0; i < cardData.length; i++) {
        final card = cardData[i];
        final controllers = card['controllers'] as Map<String, TextEditingController>;
        
        print('UI Card $i:');
        print('  Vehicle Number: ${controllers['vehicleNumber']?.text ?? ''}');
        print('  Vehicle Type: ${card['vehicleType']}');
        print('  VIN Number: ${controllers['vinNumber']?.text ?? ''}');
        print('  Mobile: ${controllers['mobile']?.text ?? ''}');
        print('  RC Book: ${controllers['rcBook']?.text ?? ''}');
        print('  RC File: ${card['rcFile']}');
        
        cubit.updateCardField(i,
          vehicleNumber: controllers['vehicleNumber']?.text ?? '',
          vehicleType: card['vehicleType'],
          vinNumber: controllers['vinNumber']?.text ?? '',
          mobile: controllers['mobile']?.text ?? '',
          rcNumber: controllers['rcBook']?.text ?? '', // RC book number goes to rcNumber
          rcDocuments: card['rcFile'] != null && card['rcFile'] != 'Uploading...' ? [{'fileName': card['rcFile']}] : [], // Uploaded URL goes to rcDocument
        );
      }
      
      // Call the API
      await cubit.createCustomer();
    }
  }

  void _resetLocalFormData() {
    if (mounted) {
      setState(() {
        cardData = [
          {
            'vehicleNumber': '',
            'vehicleType': null,
            'vinNumber': '',
            'mobile': '',
            'rcBook': '',
            'rcFile': null,
            'rcFileName': null,
            'rcDocuments': [],
            'controllers': {
              'vehicleNumber': TextEditingController(),
              'vinNumber': TextEditingController(),
              'mobile': TextEditingController(),
              'rcBook': TextEditingController(),
            },
          },
        ];
        _expanded = [true];
        _isLoading = false;
        _hasShownSuccessDialog = false;
        _hasShownErrorDialog = false;
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    // Reset the customer creation state immediately
    final enDhanCubit = locator<EnDhanCubit>();
    enDhanCubit.resetCustomerCreationState();
    
    // Reset local form data
    _resetLocalFormData();
    
    // Show success message and navigate immediately
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Customer and cards created successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Navigate back to the card screen
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => EndhanNewUserAndCardScreen()),
    );
  }

  void _showErrorDialog(BuildContext context, dynamic errorType) {
    String errorMessage = 'An error occurred while creating the customer. Please try again.';
    
    if (errorType != null) {
      errorMessage = errorType.toString();
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error', style: AppTextStyle.body1.copyWith(color: Colors.red)),
          content: Text(errorMessage, style: AppTextStyle.body3),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: AppTextStyle.body3.copyWith(color: AppColors.primaryColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure expansion list length matches cards
    if (_expanded.length != cardData.length) {
      _expanded = List.generate(cardData.length, (index) => false);
    }

    final cubit = locator<EnDhanCubit>();

    return BlocBuilder<EnDhanCubit, EnDhanState>(
        bloc: cubit,
        builder: (context, state) {
        // Handle loading state
        if (state.customerCreationState?.status == Status.LOADING) {
          _isLoading = true;
        } else {
          _isLoading = false;
        }

        // Handle success state
        if (state.customerCreationState?.status == Status.SUCCESS && !_hasShownSuccessDialog) {
          _hasShownSuccessDialog = true;
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog(context);
          });
        }

        // Handle error state
        if (state.customerCreationState?.status == Status.ERROR && !_hasShownErrorDialog) {
          _hasShownErrorDialog = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorDialog(context, state.customerCreationState?.errorType);
          });
        }

        return Scaffold(
          backgroundColor: AppColors.blackishWhite,
          body: SafeArea(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
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
                            title: "Card Information",
                            backgroundColor: Color(0xFFD6EEFB),
                            actions: [
                              AppIconButton(
                                onPressed: () {},
                                icon: AppIcons.svg.filledSupport,
                                iconColor: AppColors.primaryColor,
                              ),
                            ],
                          ),
                          8.height,
                          Image.asset(AppImage.png.endhanCard, width: 140, height: 90),
                          8.height,
                        ],
                      ),
                    ),
              
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          //   child: Container(
                          //     padding: const EdgeInsets.all(12),
                          //     decoration: BoxDecoration(
                          //       color: AppColors.primaryColor.withOpacity(0.1),
                          //       borderRadius: BorderRadius.circular(8),
                          //       border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
                          //     ),
                          //     child: Row(
                          //       children: [
                          //         Icon(Icons.info_outline, color: AppColors.primaryColor, size: 20),
                          //         8.width,
                          //         Expanded(
                          //           child: Text(
                          //             'All fields marked with * are required',
                          //             style: AppTextStyle.body3.copyWith(
                          //               color: AppColors.primaryColor,
                          //               fontWeight: FontWeight.w500,
                          //             ),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                         
                          Container(
                            decoration: commonContainerDecoration(
                              color: AppColors.blackishWhite,
                              shadow: true
                            ),
                            child: ExpansionPanelList(
                              dividerColor: Colors.transparent,
                              expansionCallback: (int index, bool isExpanded) {
                                setState(() {
                                  _expanded[index] = !_expanded[index];
                                });
                              },
                              expandedHeaderPadding: EdgeInsets.zero,
                              elevation: 0,
                              children: List.generate(cardData.length, (index) {
                                final card = cardData[index];
                                final controllers = card['controllers'] as Map<String, TextEditingController>;
                                return ExpansionPanel(
                                  backgroundColor: AppColors.white,
                                  canTapOnHeader: true,
                                  isExpanded: _expanded[index],
                                  headerBuilder: (context, isExpanded) {
                                    return ListTile(
                                      title: Text('Card ${index + 1}', style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
                                    );
                                  },
                                  body: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Vehicle Number *', style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
                                        6.height,
                                        AppTextField(
                                          hintText: 'Enter vehicle number',
                                          controller: controllers['vehicleNumber'],
                                          onChanged: (val) => card['vehicleNumber'] = val,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Vehicle number is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        12.height,
                                        Text('Vehicle Type *', style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
                                        6.height,
                                        AppDropdown(
                                          hintText: 'Select',
                                          dropdownValue: card['vehicleType'],
                                          dropDownList: state.vehicleTypes.isNotEmpty
                                              ? state.vehicleTypes.map((vehicleType) => 
                                                DropdownMenuItem(
                                                  value: vehicleType,
                                                  child: Text(vehicleType),
                                                )
                                              ).toList()
                                              : [DropdownMenuItem(value: '', child: Text('Loading vehicle types...'))],
                                          onChanged: (val) => setState(() => card['vehicleType'] = val),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Vehicle type is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        12.height,
                                        Text('VIN Number *', style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
                                        6.height,
                                        AppTextField(
                                          hintText: 'Enter VIN number',
                                          controller: controllers['vinNumber'],
                                          onChanged: (val) => card['vinNumber'] = val,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'VIN number is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        12.height,
                                        Text('Mobile Number *', style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
                                        6.height,
                                        AppTextField(
                                          hintText: '+91 9876987654',
                                          controller: controllers['mobile'],
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Mobile number is required';
                                            }
                                            // Basic mobile number validation for Indian numbers
                                            final mobileRegex = RegExp(r'^(\+91\s?)?[6-9]\d{9}$');
                                            if (!mobileRegex.hasMatch(value.trim())) {
                                              return 'Please enter a valid mobile number';
                                            }
                                            return null;
                                          },
                                        ),
                                        12.height,
                                        Row(
                                          children: [
                                            Text('RC book *', style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.bold)),
                                            4.width,
                                            Tooltip(
                                              message: 'Upload your RC book document',
                                              child: Icon(Icons.info_outline, size: 16, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        6.height,
                                        AppTextField(
                                          hintText: 'AAAPA1234A',
                                          controller: controllers['rcBook'],
                                          onChanged: (val) => card['rcBook'] = val,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'RC book is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        
                                        12.height,

                                        // Document upload widget
                                        EndhanDocumentUploadWidget(
                                          feildTitle: "Upload RC document *",
                                          multiFilesList: card['rcDocuments'] ?? [],
                                          isSingleFile: true,
                                          onFilesChanged: (newList) {
                                            setState(() {
                                              card['rcDocuments'] = newList;
                                              // Reset file data if document is removed
                                              if (newList.isEmpty) {
                                                card['rcFile'] = null;
                                                card['rcFileName'] = null;
                                              }
                                            });
                                          },
                                          thenUploadFileToSever: () async {
                                            if (card['rcDocuments'].isNotEmpty) {
                                              final document = card['rcDocuments'].first;
                                              final filePath = document['path'];
                                              
                                              if (filePath != null) {
                                                try {
                                                  final uploadResponse = await locator<EnDhanCubit>().uploadDocument(File(filePath));
                                                  
                                                  if (uploadResponse != null && uploadResponse.data?.url != null) {
                                                    final uploadedUrl = uploadResponse.data!.url!;
                                                    
                                                    setState(() {
                                                      card['rcFile'] = uploadedUrl;
                                                      card['rcFileName'] = document['fileName'];
                                                    });
                                                    
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Document uploaded successfully!')),
                                                    );
                                                  } else {
                                                    setState(() {
                                                      card['rcFile'] = null;
                                                      card['rcFileName'] = null;
                                                    });
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Upload failed: No URL received')),
                                                    );
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    card['rcFile'] = null;
                                                    card['rcFileName'] = null;
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Upload failed: $e')),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          8.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: _addNewCard,
                                icon: Icon(Icons.add, color: AppColors.primaryColor),
                                label: Text('New Card', style: AppTextStyle.body3.copyWith(color: AppColors.primaryColor)),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primaryColor,
                                  textStyle: AppTextStyle.body3,
                                ),
                              ),
                            ),
                          ),
                          16.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AppButton(
                              title: _isLoading ? 'Creating...' : 'Save & Create',
                              style: AppButtonStyle.primary,
                              onPressed: _isLoading ? () {} : _handleSaveAndCreate,
                            ),
                          ),
                          16.height,
                        ],
                      ),
                    ),
                  ],
                ),
                // Loading overlay
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


