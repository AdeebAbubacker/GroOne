import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/en-dhan_fuel/cubit/en_dhan_cubit.dart';
import 'package:gro_one_app/features/en-dhan_fuel/view/endhan_new_user_and_card_screen.dart';
import 'package:gro_one_app/features/en-dhan_fuel/widgets/endhan_document_upload_widget.dart';
import 'package:gro_one_app/features/en-dhan_fuel/widgets/endhan_error_dialog.dart';
import 'package:gro_one_app/features/kavach/view/kavach_added_vehicles_bottom_sheet.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dropdown.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_functions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/common_dialog_view/success_dialog_view.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:gro_one_app/utils/validator.dart';

import '../../../utils/app_dialog.dart';
import '../../../utils/app_icon_button.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/app_route.dart';
import '../../../utils/common_widgets.dart';
import '../../kavach/view/kavach_support_screen.dart';
import 'package:go_router/go_router.dart';
import '../../kavach/view/widgets/vehicle_selection_field.dart';

class EndhanCreateCardInfoScreen extends StatefulWidget {
  const EndhanCreateCardInfoScreen({super.key});

  @override
  State<EndhanCreateCardInfoScreen> createState() => _EndhanCreateCardInfoScreenState();
}

class _EndhanCreateCardInfoScreenState extends State<EndhanCreateCardInfoScreen> {
  bool _isNavigating = false; // Flag to prevent multiple navigation attempts

  @override
  Widget build(BuildContext context) {
    final cubit = locator<EnDhanCubit>();

    return BlocProvider.value(
      value: cubit,
      child: MultiBlocListener(
        listeners: [
          BlocListener<EnDhanCubit, EnDhanState>(
            listener: (context, state) {
              // Handle success state
              if (state.customerCreationState?.status == Status.SUCCESS) {
                _showSuccessDialog(context);
              }
            },
          ),
        ],
        child: BlocBuilder<EnDhanCubit, EnDhanState>(
          builder: (context, state) {
            return _EndhanCreateCardInfoContent(state: state);
          },
        ),
      ),
    );
  }

  // Safe navigation method to prevent crashes
  void _navigateToEnDhanCard(BuildContext context) {
    if (_isNavigating || !context.mounted) return;

    _isNavigating = true;
   
    try {
      // Use GoRouter to navigate to the new user and card screen
      context.go('/enDhanCard');
     
    } catch (e) {
      
      // Fallback: try to pop back to previous screen
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } finally {
      // Reset the flag after a delay to allow for future navigation
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isNavigating = false;
          });
        }
      });
    }
  }

// after afetr uplaod the card
  void _showSuccessDialog(BuildContext context) {
    // Reset the customer creation state immediately
    final enDhanCubit = locator<EnDhanCubit>();
    enDhanCubit.resetCustomerCreationState();
    // Don't reset the entire cubit as it clears customer information
    // enDhanCubit.resetCubit();


    // Show success dialog with proper navigation
    AppDialog.show(
      context,
      child: SuccessDialogView(
        message: context.appText.customerAndCardsCreatedSuccessfully,
        // afterDismiss: () {
        //   // This will be called after 3 seconds automatically
        //   _navigateToEnDhanCard(context);
        // },
        onContinue: () {
          
          // Close the dialog first
          Navigator.of(context).pop();

          // Use a post-frame callback to ensure the dialog is closed before navigation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            
            _navigateToEnDhanCard(context);
          });
        },
        afterDismiss: () {
          
          // Fallback navigation if user doesn't press continue
          if (mounted && !_isNavigating) {
            _navigateToEnDhanCard(context);
          }
        },
      ),
    );
  }
}

class _EndhanCreateCardInfoContent extends StatefulWidget {
  final EnDhanState state;

  const _EndhanCreateCardInfoContent({required this.state});

  @override
  State<_EndhanCreateCardInfoContent> createState() =>
      _EndhanCreateCardInfoContentState();
}

class _EndhanCreateCardInfoContentState extends State<_EndhanCreateCardInfoContent> {
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
  int? _currentUploadingCardIndex;
  List<bool> vehicleVerificationStatus = [false]; // Track verification status for each card

  @override
  void initState() {
    super.initState();

    final cubit = locator<EnDhanCubit>();

    // Reset local form data to ensure clean state
    _resetLocalFormData();

    // Fetch vehicle types when screen loads
    cubit.fetchVehicleTypes();

    // Sync existing cubit data with local form data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncCubitDataWithLocalForm();
    });
  }

  @override
  void dispose() {
    // Preserve customer data but clear card data when screen is disposed
    final cubit = locator<EnDhanCubit>();
    cubit.preserveCustomerDataAndClearCards();
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
        'rcDocuments': [], // Ensure this is always empty for new cards
        'controllers': {
          'vehicleNumber': TextEditingController(),
          'vinNumber': TextEditingController(),
          'mobile': TextEditingController(),
          'rcBook': TextEditingController(),
        },
      });
      _expanded.add(false); // default collapsed
      vehicleVerificationStatus.add(false); // new card starts as not verified
    });

    // Also add card to cubit state
    final cubit = locator<EnDhanCubit>();
    cubit.addCard();
  }

  Future<void> _pickAndUploadDocument(int cardIndex) async {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.appText.selectDocument, style: AppTextStyle.body1),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.clear_rounded),
                ),
              ],
            ),
            20.height,
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: AppColors.primaryColor,
              ),
              title: Text(context.appText.camera),
              onTap: () async {
                Navigator.of(context).pop();
                final result = await ImagePickerFrom.fromCamera();
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

                  // Store the current card index for the BlocListener
                  _currentUploadingCardIndex = cardIndex;

                  // Upload document and get the actual URL
                  try {
                    
                    final uploadResponse = await locator<EnDhanCubit>()
                        .uploadDocument(File(result['path']));

                  
                    
                   

                    if (uploadResponse != null &&
                        uploadResponse.data?.url != null &&
                        uploadResponse.data!.url!.isNotEmpty) {
                      final uploadedUrl = uploadResponse.data!.url!;
                    

                      if (cardIndex < cardData.length) {
                        setState(() {
                          cardData[cardIndex]['rcFile'] = uploadedUrl;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.appText.documentUploadedSuccessfully,
                            ),
                          ),
                        );
                      }
                    } else {
                      
                      setState(() {
                        cardData[cardIndex]['rcFile'] = null;
                        cardData[cardIndex]['rcFileName'] = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.appText.uploadFailedNoUrl),
                        ),
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
              leading: Icon(
                Icons.photo_library,
                color: AppColors.primaryColor,
              ),
              title: Text(context.appText.gallery),
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
                    final uploadResponse = await locator<EnDhanCubit>()
                        .uploadDocument(File(result['path']));

                    if (uploadResponse != null &&
                        uploadResponse.data?.url != null) {
                      final uploadedUrl = uploadResponse.data!.url!;

                      if (cardIndex < cardData.length) {
                        setState(() {
                          cardData[cardIndex]['rcFile'] = uploadedUrl;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.appText.documentUploadedSuccessfully,
                            ),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        cardData[cardIndex]['rcFile'] = null;
                        cardData[cardIndex]['rcFileName'] = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.appText.uploadFailedNoUrl),
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      cardData[cardIndex]['rcFile'] = null;
                      cardData[cardIndex]['rcFileName'] = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${context.appText.uploadFailed} $e')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.attach_file,
                color: AppColors.primaryColor,
              ),
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
                    final uploadResponse = await locator<EnDhanCubit>()
                        .uploadDocument(File(result['path']));

                    if (uploadResponse != null &&
                        uploadResponse.data?.url != null) {
                      final uploadedUrl = uploadResponse.data!.url!;

                      if (cardIndex < cardData.length) {
                        setState(() {
                          cardData[cardIndex]['rcFile'] = uploadedUrl;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.appText.documentUploadedSuccessfully,
                            ),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        cardData[cardIndex]['rcFile'] = null;
                        cardData[cardIndex]['rcFileName'] = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.appText.uploadFailedNoUrl),
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      cardData[cardIndex]['rcFile'] = null;
                      cardData[cardIndex]['rcFileName'] = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${context.appText.uploadFailed} $e')),
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
    final cubit = locator<EnDhanCubit>();
    cubit.markFormSubmitted();
    if (_formKey.currentState?.validate() ?? false) {
      // Additional validation for card data
      bool isValid = true;
      String errorMessage = '';

      for (int i = 0; i < cardData.length; i++) {
        final card = cardData[i];
        final controllers =
        card['controllers'] as Map<String, TextEditingController>;

        // Validate vehicle number
        if (controllers['vehicleNumber']?.text?.trim().isEmpty ?? true) {
          isValid = false;
          errorMessage = '${context.appText.vehicleNumberRequired} for ${context.appText.card} ${i + 1}';
          break;
        }

        // Validate vehicle type
        if (card['vehicleType'] == null ||
            card['vehicleType'].toString().isEmpty) {
          isValid = false;
          errorMessage = '${context.appText.vehicleTypeRequired} for ${context.appText.card} ${i + 1}';
          break;
        }

        // Validate VIN number
        if (controllers['vinNumber']?.text?.trim().isEmpty ?? true) {
          isValid = false;
          errorMessage = '${context.appText.vinNumberRequired} for ${context.appText.card} ${i + 1}';
          break;
        }

        // Validate mobile number format only if provided
        final mobileText = controllers['mobile']?.text?.trim() ?? '';
        if (mobileText.isNotEmpty) {
          final mobileRegex = RegExp(r'^(\+91\s?)?[6-9]\d{9}$');
          if (!mobileRegex.hasMatch(mobileText)) {
            isValid = false;
            errorMessage = '${context.appText.validMobileNumber} for ${context.appText.card} ${i + 1}';
            break;
          }
        }

        // Validate RC book (used as RC number)
        final rcBookValidation = Validator.rcBookNumberValidator(
          controllers['rcBook']?.text,
          fieldName: context.appText.rcBook,
        );
        if (rcBookValidation != null) {
          isValid = false;
          errorMessage = '$rcBookValidation for ${context.appText.card} ${i + 1}';
          break;
        }

        // Validate RC file upload
        if (card['rcFile'] == null) {
          isValid = false;
          errorMessage = '${context.appText.rcDocumentUploadRequired} for ${context.appText.card} ${i + 1}';
          break;
        }

        // Vehicle verification is handled automatically when selecting from list
      }

      if (!isValid) {
        EndhanErrorDialog.show(context, errorMessage);
        return;
      }

      // Sync form data with cubit state before API call
      _syncFormDataWithCubit(cubit);

      // Update cubit with card data from the form
      for (int i = 0; i < cardData.length; i++) {
        final card = cardData[i];
        final controllers =
        card['controllers'] as Map<String, TextEditingController>;

        cubit.updateCardField(
          i,
          vehicleNumber: controllers['vehicleNumber']?.text ?? '',
          vehicleType: card['vehicleType'],
          vinNumber: controllers['vinNumber']?.text ?? '',
          mobile: controllers['mobile']?.text ?? '',
          rcNumber:
          controllers['rcBook']?.text ??
              '', // RC book number goes to rcNumber
          rcDocuments:
          card['rcFile'] != null && card['rcFile'] != 'Uploading...'
              ? [
            {'fileName': card['rcFile']},
          ]
              : [], // Uploaded URL goes to rcDocument
        );
      }

      // Call the API
      await cubit.createCustomer();

      // Check for error state after API call
      if (cubit.state.customerCreationState?.status == Status.ERROR) {
        EndhanErrorDialog.show(
          context,
          cubit.state.customerCreationState?.errorType,
        );
      }

      // Success state is handled by the BlocListener in the parent widget
      // No need to show dialog here as it's already handled in _showSuccessDialog
      if (cubit.state.customerCreationState?.status == Status.SUCCESS) {
        cubit.resetCustomerCreationState();
        // Don't reset the entire cubit as it clears customer information
        // cubit.resetCubit();
      }
    }
  }

  /// Sync form data with cubit state to ensure consistency
  void _syncFormDataWithCubit(EnDhanCubit cubit) {
    // Ensure the number of cards in cubit matches the UI
    while (cubit.state.cards.length < cardData.length) {
      cubit.addCard();
    }

    // Update each card in cubit with current form data
    for (int i = 0; i < cardData.length; i++) {
      final card = cardData[i];
      final controllers = card['controllers'] as Map<String, TextEditingController>;

      cubit.updateCardField(
        i,
        vehicleNumber: controllers['vehicleNumber']?.text ?? '',
        vehicleType: card['vehicleType'],
        vinNumber: controllers['vinNumber']?.text ?? '',
        mobile: controllers['mobile']?.text ?? '',
        rcNumber: controllers['rcBook']?.text ?? '',
        rcDocuments: card['rcFile'] != null && card['rcFile'] != 'Uploading...'
            ? [{'fileName': card['rcFile']}]
            : [],
      );
    }
  }

  /// Sync a specific card field with cubit state
  void _syncCardFieldWithCubit(int cardIndex, String fieldName, dynamic value) {
    if (cardIndex >= cardData.length) return;

    final cubit = locator<EnDhanCubit>();
    final card = cardData[cardIndex];
    final controllers = card['controllers'] as Map<String, TextEditingController>;

    // Update the specific field in cubit
    switch (fieldName) {
      case 'vehicleNumber':
        cubit.updateCardField(
          cardIndex,
          vehicleNumber: value,
          vehicleType: card['vehicleType'],
          vinNumber: controllers['vinNumber']?.text ?? '',
          mobile: controllers['mobile']?.text ?? '',
          rcNumber: controllers['rcBook']?.text ?? '',
          rcDocuments: card['rcFile'] != null && card['rcFile'] != 'Uploading...'
              ? [{'fileName': card['rcFile']}]
              : [],
        );
        break;
      case 'vehicleType':
        cubit.updateCardField(
          cardIndex,
          vehicleNumber: controllers['vehicleNumber']?.text ?? '',
          vehicleType: value,
          vinNumber: controllers['vinNumber']?.text ?? '',
          mobile: controllers['mobile']?.text ?? '',
          rcNumber: controllers['rcBook']?.text ?? '',
          rcDocuments: card['rcFile'] != null && card['rcFile'] != 'Uploading...'
              ? [{'fileName': card['rcFile']}]
              : [],
        );
        break;
      case 'vinNumber':
        cubit.updateCardField(
          cardIndex,
          vehicleNumber: controllers['vehicleNumber']?.text ?? '',
          vehicleType: card['vehicleType'],
          vinNumber: value,
          mobile: controllers['mobile']?.text ?? '',
          rcNumber: controllers['rcBook']?.text ?? '',
          rcDocuments: card['rcFile'] != null && card['rcFile'] != 'Uploading...'
              ? [{'fileName': card['rcFile']}]
              : [],
        );
        break;
      case 'mobile':
        cubit.updateCardField(
          cardIndex,
          vehicleNumber: controllers['vehicleNumber']?.text ?? '',
          vehicleType: card['vehicleType'],
          vinNumber: controllers['vinNumber']?.text ?? '',
          mobile: value,
          rcNumber: controllers['rcBook']?.text ?? '',
          rcDocuments: card['rcFile'] != null && card['rcFile'] != 'Uploading...'
              ? [{'fileName': card['rcFile']}]
              : [],
        );
        break;
      case 'rcBook':
        cubit.updateCardField(
          cardIndex,
          vehicleNumber: controllers['vehicleNumber']?.text ?? '',
          vehicleType: card['vehicleType'],
          vinNumber: controllers['vinNumber']?.text ?? '',
          mobile: controllers['mobile']?.text ?? '',
          rcNumber: value,
          rcDocuments: card['rcFile'] != null && card['rcFile'] != 'Uploading...'
              ? [{'fileName': card['rcFile']}]
              : [],
        );
        break;
    }
  }

  /// Sync card documents with cubit state
  void _syncCardDocumentsWithCubit(int cardIndex, List newList) {
    if (cardIndex >= cardData.length) return;

    final cubit = locator<EnDhanCubit>();
    final card = cardData[cardIndex];
    final controllers = card['controllers'] as Map<String, TextEditingController>;

    // Convert document list to the format expected by cubit
    List<Map<String, dynamic>> rcDocuments = [];
    if (newList.isNotEmpty) {
      final document = newList.first;
      if (document['fileName'] != null) {
        // Use the uploaded URL if available, otherwise use the file name
        final fileName = document['fileName'].toString();

        // Check if it's an uploaded URL or local file path
        if (fileName.startsWith('http')) {
          // It's an uploaded URL, use it directly
          rcDocuments = [{'fileName': fileName}];
        } else {
          // It's a local file path, use the file name
          rcDocuments = [{'fileName': fileName}];
        }
      }
    }

    cubit.updateCardField(
      cardIndex,
      vehicleNumber: controllers['vehicleNumber']?.text ?? '',
      vehicleType: card['vehicleType'],
      vinNumber: controllers['vinNumber']?.text ?? '',
      mobile: controllers['mobile']?.text ?? '',
      rcNumber: controllers['rcBook']?.text ?? '',
      rcDocuments: rcDocuments,
    );
  }

  /// Sync cubit data with local form data
  void _syncCubitDataWithLocalForm() {
    final cubit = locator<EnDhanCubit>();
    final cubitCards = cubit.state.cards;

    // Ensure we have the same number of cards
    while (cardData.length < cubitCards.length) {
      _addNewCard();
    }

    // Update local form data with cubit data
    for (int i = 0; i < cubitCards.length && i < cardData.length; i++) {
      final cubitCard = cubitCards[i];
      final localCard = cardData[i];
      final controllers = localCard['controllers'] as Map<String, TextEditingController>;

      // Update text controllers
      controllers['vehicleNumber']?.text = cubitCard.vehicleNumber;
      controllers['vinNumber']?.text = cubitCard.vinNumber;
      controllers['mobile']?.text = cubitCard.mobile;
      controllers['rcBook']?.text = cubitCard.rcNumber;

      // Update other fields
      localCard['vehicleNumber'] = cubitCard.vehicleNumber;
      localCard['vehicleType'] = cubitCard.vehicleType;
      localCard['vinNumber'] = cubitCard.vinNumber;
      localCard['mobile'] = cubitCard.mobile;
      localCard['rcBook'] = cubitCard.rcNumber;

      // Clear RC documents to prevent showing leftover data
      localCard['rcDocuments'] = [];
      localCard['rcFile'] = null;
      localCard['rcFileName'] = null;
      
      // Update verification status - only set as verified if it was previously verified
      if (i < vehicleVerificationStatus.length) {
        // Don't automatically verify vehicles just because they have text
        // They should only be verified if explicitly verified or selected from list
        vehicleVerificationStatus[i] = false;
      }
    }

    setState(() {});
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
        vehicleVerificationStatus = [false];
      });
    }
  }

  bool _isVehicleAlreadySelected(String vehicleNumber) {
    for (int i = 0; i < cardData.length; i++) {
      final controllers = cardData[i]['controllers'] as Map<String, TextEditingController>;
      final currentVehicleNumber = controllers['vehicleNumber']?.text.trim() ?? '';
      if (currentVehicleNumber == vehicleNumber && currentVehicleNumber.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure expansion list length matches cards
    if (_expanded.length != cardData.length) {
      _expanded = List.generate(cardData.length, (index) => false);
    }

    final cubit = locator<EnDhanCubit>();
    final isLoading =
        widget.state.customerCreationState?.status == Status.LOADING;
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
                        title: context.appText.cardInformation,
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
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: commonContainerDecoration(
                          color: AppColors.blackishWhite,
                          shadow: true,
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
                            final controllers =
                            card['controllers']
                            as Map<String, TextEditingController>;
                            return ExpansionPanel(
                              backgroundColor: AppColors.white,
                              canTapOnHeader: true,
                              isExpanded: _expanded[index],
                              headerBuilder: (context, isExpanded) {
                                return ListTile(
                                  title: Text(
                                    '${context.appText.card} ${index + 1}',
                                    style: AppTextStyle.body3.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: index > 0
                                      ? IconButton(
                                    icon: Icon(Icons.delete, color: AppColors.activeRedColor),
                                    tooltip: context.appText.deleteThisCard,
                                    onPressed: () {
                                      setState(() {
                                        cardData.removeAt(index);
                                        _expanded.removeAt(index);
                                      });
                                      // Remove from cubit as well
                                      final cubit = locator<EnDhanCubit>();
                                      cubit.removeCard(index);
                                    },
                                  )
                                      : null,
                                );
                              },
                              body: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${context.appText.vehicleNumber} *',
                                      style: AppTextStyle.body3.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    6.height,
                                    VehicleSelectionField(
                                      controller: controllers['vehicleNumber']!,
                                      hintText: context.appText.selectVehicleNumber,
                                      index: index,
                                      isVerified: index < vehicleVerificationStatus.length ? vehicleVerificationStatus[index] : false,
                                      isVehicleAlreadySelected: _isVehicleAlreadySelected(controllers['vehicleNumber']?.text.trim() ?? ''),
                                      onVehicleSelected: (selectedIndex, selectedVehicle) {
                                        // Check for duplicates across all cards, excluding the current card
                                        bool isAlreadySelected = false;
                                        for (int i = 0; i < widget.state.cards.length; i++) {
                                          // Skip the current card being updated
                                          if (i == index) continue;
                                          
                                          final otherCard = widget.state.cards[i];
                                          if (otherCard.vehicleNumber.trim() == selectedVehicle.trim()) {
                                            isAlreadySelected = true;
                                            break;
                                          }
                                        }
                                        
                                        if (isAlreadySelected) {
                                          ToastMessages.alert(message: 'Vehicle already selected');
                                          return;
                                        }
                                        
                                        // Set the vehicle in the controller only if no duplicates
                                        setState(() {
                                          controllers['vehicleNumber']?.text = selectedVehicle;
                                          card['vehicleNumber'] = selectedVehicle;
                                        });
                                        // Mark as verified when selected from list
                                        if (selectedIndex < vehicleVerificationStatus.length) {
                                          vehicleVerificationStatus[selectedIndex] = true;
                                        }
                                        // Sync with cubit state
                                        _syncCardFieldWithCubit(index, 'vehicleNumber', selectedVehicle);
                                        setState(() {}); // Trigger rebuild to show green tick
                                      },
                                      onVehicleVerified: (verifiedVehicle) {
                                        // Update verification status when manually verified
                                        if (verifiedVehicle.isNotEmpty) {
                                          if (index < vehicleVerificationStatus.length) {
                                            vehicleVerificationStatus[index] = true;
                                          }
                                        } else {
                                          // Reset verification status when text is cleared or changed
                                          if (index < vehicleVerificationStatus.length) {
                                            vehicleVerificationStatus[index] = false;
                                          }
                                        }
                                        setState(() {}); // Trigger rebuild to update UI
                                      },
                                    ),
                                    12.height,
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${context.appText.vehicleType} *',
                                          style: AppTextStyle.body3.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    6.height,
                                    AppDropdown(
                                      hintText: context.appText.select,
                                      dropdownValue: card['vehicleType'],
                                      dropDownList:
                                      (widget
                                          .state
                                          .vehicleTypes
                                          .isNotEmpty ||
                                          widget
                                              .state
                                              .vehicleTypesState
                                              ?.status ==
                                              Status.SUCCESS)
                                          ? widget.state.vehicleTypes
                                          .map(
                                            (vehicleType) =>
                                            DropdownMenuItem(
                                              value: vehicleType,
                                              child: Text(
                                                vehicleType,
                                              ),
                                            ),
                                      )
                                          .toList()
                                          : [
                                        DropdownMenuItem(
                                          value: '',
                                          child: Text(
                                            widget
                                                .state
                                                .vehicleTypesState
                                                ?.status ==
                                                Status.LOADING
                                                ? context.appText.loadingVehicleTypes
                                                : '${context.appText.noVehicleTypesAvailable} (${widget.state.vehicleTypes.length})',
                                          ),
                                        ),
                                      ],
                                      onChanged: (val) {
                                        setState(() => card['vehicleType'] = val);
                                        // Sync with cubit state immediately
                                        _syncCardFieldWithCubit(index, 'vehicleType', val);
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return context.appText.vehicleTypeRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                    12.height,
                                    Text(
                                      '${context.appText.vinNumber} *',
                                      style: AppTextStyle.body3.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    6.height,
                                    AppTextField(
                                      hintText: context.appText.enterVinNumber,
                                      controller: controllers['vinNumber'],
                                      onChanged: (val) {
                                        card['vinNumber'] = val;
                                        // Sync with cubit state immediately
                                        _syncCardFieldWithCubit(index, 'vinNumber', val);
                                      },
                                      maxLength: 17,
                                      inputFormatters: [LengthLimitingTextInputFormatter(17)],
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return context.appText.vinNumberRequired;
                                        }
                                        if (value.trim().length != 17) {
                                          return context.appText.vinNumberMustBe17Characters;
                                        }
                                        return null;
                                      },
                                    ),
                                    12.height,
                                    Text(
                                      context.appText.mobileNumber,
                                      style: AppTextStyle.body3.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    6.height,
                                    AppTextField(
                                      hintText: '+91 9876987654',
                                      controller: controllers['mobile'],
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      onChanged: (val) {
                                        _syncCardFieldWithCubit(index, 'mobile', val);
                                      },
                                      validator: (value) {
                                        if ((widget.state.hasAttemptedSubmit ?? false) && value != null && value.isNotEmpty && value.length > 10) {
                                          return context.appText.mobileNumberCannotBeMoreThan10Digits;
                                        }
                                        return null;
                                      },
                                    ),
                                    12.height,
                                    Row(
                                      children: [
                                        Text(
                                          '${context.appText.rcBook} *',
                                          style: AppTextStyle.body3.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        4.width,
                                        Tooltip(
                                          message:
                                          context.appText.uploadRcBookDocument,
                                          child: Icon(
                                            Icons.info_outline,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    6.height,
                                    AppTextField(
                                      hintText: 'MH12AB1234',
                                      controller: controllers['rcBook'],
                                      textCapitalization: TextCapitalization.characters,
                                      onChanged: (val) {
                                        card['rcBook'] = val;
                                        // Sync with cubit state immediately
                                        _syncCardFieldWithCubit(index, 'rcBook', val);
                                      },
                                      validator: (value) => Validator.rcBookNumberValidator(
                                        value,
                                        fieldName: context.appText.rcBook,
                                      ),
                                    ),


                                    12.height,

                                    // Document upload widget
                                    EndhanDocumentUploadWidget(
                                      key: ValueKey('card_${index}_documents_${card['rcDocuments']?.length ?? 0}_${card['rcFile'] ?? 'null'}'),
                                      feildTitle: "${context.appText.uploadRcDocument} *",
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

                                        // Sync with cubit state immediately
                                        _syncCardDocumentsWithCubit(index, newList);
                                      },
                                      thenUploadFileToSever: () async {
                                        if (card['rcDocuments'].isNotEmpty) {
                                          final document =
                                              card['rcDocuments'].first;
                                          final filePath = document['path'];

                                          if (filePath != null) {
                                            try {
                                              final uploadResponse =
                                              await locator<EnDhanCubit>()
                                                  .uploadDocument(
                                                File(filePath),
                                              );

                                              if (uploadResponse != null &&
                                                  uploadResponse.data?.url !=
                                                      null) {
                                                final uploadedUrl =
                                                uploadResponse.data!.url!;

                                                // Update both rcFile and rcDocuments with the uploaded URL
                                                setState(() {
                                                  card['rcFile'] = uploadedUrl;
                                                  card['rcFileName'] = document['fileName'];
                                                  // Update the documents list with the uploaded URL
                                                  card['rcDocuments'] = [
                                                    {
                                                      'fileName': uploadedUrl,
                                                      'path': uploadedUrl, // Use URL as path for uploaded files
                                                    }
                                                  ];
                                                });

                                                // Sync with cubit state after successful upload
                                                _syncCardDocumentsWithCubit(index, card['rcDocuments']);

                                                // Force a rebuild of the entire widget tree
                                                if (mounted) {
                                                  setState(() {});
                                                }

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Document uploaded successfully!',
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                setState(() {
                                                  card['rcFile'] = null;
                                                  card['rcFileName'] = null;
                                                  card['rcDocuments'] = [];
                                                });
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      context.appText.uploadFailedNoUrl,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              setState(() {
                                                card['rcFile'] = null;
                                                card['rcFileName'] = null;
                                                card['rcDocuments'] = [];
                                              });
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${context.appText.uploadFailed} $e',
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(context.appText.noFilePathFound),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(context.appText.noDocumentsSelected),
                                            ),
                                          );
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
                            icon: Icon(
                              Icons.add,
                              color: AppColors.primaryColor,
                            ),
                            label: Text(
                              context.appText.newCard,
                              style: AppTextStyle.body3.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
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
                          title: isLoading ? context.appText.creating : context.appText.saveAndCreate,
                          style: AppButtonStyle.primary,
                          onPressed: isLoading ? () {} : _handleSaveAndCreate,
                        ),
                      ),
                      16.height,
                    ],
                  ),
                ),
              ],
            ),
            // Loading overlay
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}