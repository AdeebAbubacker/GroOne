import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/app_button.dart';
import '../../../../utils/app_button_style.dart';
import '../../../../utils/app_text_field.dart';
import '../../../../utils/common_widgets.dart';
import '../../../../utils/common_dialog_view/common_dialog_view.dart';
import '../../../../utils/app_dialog.dart';
import '../../../../utils/constant_variables.dart';
import '../../../../utils/extensions/int_extensions.dart';
import '../cubit/endhan_transaction_cubit.dart';

class EndhanTransactionScreen extends StatelessWidget {
  const EndhanTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<EndhanTransactionCubit>(),
      child: const _EndhanTransactionScreenContent(),
    );
  }
}

class _EndhanTransactionScreenContent extends StatefulWidget {
  const _EndhanTransactionScreenContent();

  @override
  State<_EndhanTransactionScreenContent> createState() => _EndhanTransactionScreenContentState();
}

class _EndhanTransactionScreenContentState extends State<_EndhanTransactionScreenContent> {
  DateTime? fromDate;
  DateTime? toDate;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  late final EndhanTransactionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<EndhanTransactionCubit>();
    
    // Set default date range to last 7 days
    toDate = DateTime.now();
    fromDate = toDate!.subtract(const Duration(days: 6));
    _updateDateControllers();
    
    // Fetch initial transactions after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchTransactions();
      }
    });
  }

  void _updateDateControllers() {
    if (fromDate != null) {
      fromDateController.text = DateFormat('dd MMM yyyy').format(fromDate!);
    }
    if (toDate != null) {
      toDateController.text = DateFormat('dd MMM yyyy').format(toDate!);
    }
  }

  void _showDateRangeErrorDialog(BuildContext context) {
    AppDialog.show(
      context,
      dismissible: true,
      child: CommonDialogView(
        hideCloseButton: true,
        child: Column(
          children: [
            // Orange circular icon with warning triangle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE67E22), // Orange color
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE67E22).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 40,
              ),
            ),
            20.height,
            // Main heading
            Text(
              'Date Range Too Large',
              style: AppTextStyle.h4.copyWith(
                color: const Color(0xFFE67E22),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            12.height,
            // Supporting message
            Text(
              'The selected date range exceeds the maximum limit of 7 days. Please select a smaller date range.',
              style: AppTextStyle.body3.copyWith(
                color: AppColors.greyTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        onTapSingleButton: () {
          Navigator.of(context).pop();
        },
        onSingleButtonText: 'OK',
      ),
    );
  }

  void _fetchTransactions() {
    print('🔄 _fetchTransactions called');
    if (fromDate != null && toDate != null && mounted) {
      // Double-check date range before fetching
      final difference = toDate!.difference(fromDate!).inDays;
      
      if (difference > 7) {
        // Show alert popup
        _showDateRangeErrorDialog(context);
        return;
      }
      
      print('✅ Calling cubit.fetchTransactions');
      _cubit.fetchTransactions(fromDate: fromDate!, toDate: toDate!);
    } else {
      print('❌ Cannot fetch: fromDate=$fromDate, toDate=$toDate, mounted=$mounted');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? (fromDate ?? DateTime.now()) : (toDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Check if the selected date would create a range exceeding 7 days
      bool wouldExceedLimit = false;
      DateTime? tempFromDate = fromDate;
      DateTime? tempToDate = toDate;
      
      if (isFromDate) {
        tempFromDate = picked;
        if (tempToDate != null && tempToDate.difference(picked).inDays > 7) {
          wouldExceedLimit = true;
        }
      } else {
        tempToDate = picked;
        if (tempFromDate != null && picked.difference(tempFromDate).inDays > 7) {
          wouldExceedLimit = true;
        }
      }
      
      if (wouldExceedLimit) {
        // Show alert popup
        if (mounted) {
          _showDateRangeErrorDialog(context);
        }
        return; // Don't update the dates
      }
      
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
        _updateDateControllers();
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return const Color(0xFF22C55E); // Green color matching screenshot
      case 'failed':
        return const Color(0xFFEF4444); // Red color matching screenshot
      case 'pending':
        return const Color(0xFFF59E0B); // Orange color
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
        return const Color(0xFF22C55E).withOpacity(0.1); // Light green background
      case 'failed':
        return const Color(0xFFEF4444).withOpacity(0.1); // Light red background
      case 'pending':
        return const Color(0xFFF59E0B).withOpacity(0.1); // Light orange background
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        title: context.appText.transactions,
        centreTile: true,
        isLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Date Filter Section
            Container(
              padding: EdgeInsets.all(commonSafeAreaPadding),
              decoration: commonContainerDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // From Date
                      Expanded(
                        child: AppTextField(
                          controller: fromDateController,
                          readOnly: true,
                          labelText: context.appText.fromDate,
                          decoration: kavachInputDecoration(
                            // suffixIcon: Icon(
                            //   Icons.calendar_today,
                            //   color: AppColors.chevronGreyColor,
                            //   size: 20,
                            // ),
                          ),
                          onTextFieldTap: () => _selectDate(context, true),
                        ),
                      ),
                      10.width,
                      // To Date
                      Expanded(
                        child: AppTextField(
                          controller: toDateController,
                          readOnly: true,
                          labelText: context.appText.toDate,
                          onTextFieldTap: () => _selectDate(context, false),
                        ),
                      ),
                      10.width,
                      // Apply Button
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: _fetchTransactions,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(context.appText.apply),
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  // Helper text for date range limit
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      5.width,
                      Text(
                        'Maximum date range: 7 days',
                        style: AppTextStyle.textGreyColor14w300.copyWith(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            10.height,
            // Transaction List
            Expanded(
              child: BlocBuilder<EndhanTransactionCubit, EndhanTransactionState>(
                bloc: _cubit,
                builder: (context, state) {
                  if (state is EndhanTransactionLoading) {
                    return const Center(child: CircularProgressIndicator());
                                    } else if (state is EndhanTransactionError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 48),
                          10.height,
                           Text(
                             'No transactions found',
                             style: AppTextStyle.h5,
                           ),
                          10.height,
                         Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: AppButton(onPressed: _fetchTransactions, 
                          title: 'Retry', 
                          style: AppButtonStyle.outline,),),
                        ],
                      ),
                    );
                  } else if (state is EndhanTransactionDateRangeError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.orange, size: 48),
                          10.height,
                          Text(
                            'Date Range Too Large',
                            style: AppTextStyle.h5,
                          ),
                          5.height,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              state.message,
                              style: AppTextStyle.bodyGreyColor,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          15.height,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: AppButton(
                              onPressed: () {
                                // Reset to last 7 days
                                setState(() {
                                  toDate = DateTime.now();
                                  fromDate = toDate!.subtract(const Duration(days: 6));
                                  _updateDateControllers();
                                });
                                _fetchTransactions();
                              },
                              title: 'Set to Last 7 Days',
                              style: AppButtonStyle.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is EndhanTransactionEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, color: Colors.grey, size: 48),
                          10.height,
                          Text(
                            'No transactions found',
                            style: AppTextStyle.h5,
                          ),
                          5.height,
                          Text(
                            'Try adjusting your date range',
                            style: AppTextStyle.bodyGreyColor,
                          ),
                        ],
                      ),
                    );
                  } else if (state is EndhanTransactionLoaded) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactions[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(16),
                          decoration: commonContainerDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              // Transaction Icon
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        '₹',
                                        style: AppTextStyle.h4PrimaryColor.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                    // Status indicator overlay
                                    if (transaction.isSuccess)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF22C55E),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                      )
                                    else
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEF4444),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              15.width,
                              // Transaction Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transaction.merchantName ?? "Unknown Merchant",
                                      style: AppTextStyle.h5.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    4.height,
                                    Text(
                                      'TXN: ${transaction.transactionID ?? "N/A"}',
                                      style: AppTextStyle.textGreyColor14w300.copyWith(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    4.height,
                                    Text(
                                      transaction.parsedTransactionDate != null
                                          ? DateFormat('dd MMM yyyy, h:mm a').format(transaction.parsedTransactionDate!)
                                          : transaction.transactionDate ?? "N/A",
                                      style: AppTextStyle.textGreyColor14w300.copyWith(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Amount and Status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${transaction.amountValue.toStringAsFixed(0)}',
                                    style: AppTextStyle.h5.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  8.height,
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusBackgroundColor(transaction.status),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      transaction.status,
                                      style: AppTextStyle.textDarkGreyColor14w500.copyWith(
                                        color: _getStatusColor(transaction.status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  
                  // Initial state
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration kavachInputDecoration({Widget? suffixIcon, String? hintText, bool? isMandatoryMark, Widget? preffixIcon}) {
    return InputDecoration(
      prefixIcon: preffixIcon,
      hint: Row(
        children: [
          Text(hintText ?? '', style: AppTextStyle.textFieldHint),
          if (isMandatoryMark ?? false)
            Text(" *", style: AppTextStyle.textFiled.copyWith(color: Colors.red)),
        ],
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(commonTexFieldRadius),
      ),
      suffixIcon: suffixIcon,
      counterText: '',
    );
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }
}