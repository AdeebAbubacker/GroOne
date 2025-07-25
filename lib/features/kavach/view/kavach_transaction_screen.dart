import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/kavach/helper/kavach_helper.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_icons.dart';
import '../../../utils/common_functions.dart';
import '../cubit/kavach_transaction_cubit/kavach_transaction_cubit.dart';
import '../model/kavach_transaction_model.dart';

class KavachTransactionsScreen extends StatefulWidget {
  const KavachTransactionsScreen({super.key});

  @override
  State<KavachTransactionsScreen> createState() =>
      _KavachTransactionsScreenState();
}

class _KavachTransactionsScreenState extends State<KavachTransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _transactionsCubit = locator<KavachTransactionsCubit>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _transactionsCubit.fetchTransactions();
    _tabController.addListener(() {
      if (mounted) setState(() {}); // Safe setState
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<KavachTransactionModel> filterTransactions(
    List<KavachTransactionModel> transactions,
    String status,
  ) {
    if (status == 'all') return transactions;
    return transactions
        .where((txn) => txn.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: context.appText.transactions,
        bottom: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        indicator: const BoxDecoration(), // Remove default indicator
        labelPadding: const EdgeInsets.symmetric(horizontal:2),
        tabs: List.generate(4, (index) {
          final tabLabels = [
            context.appText.all,
            context.appText.success,
            context.appText.pending,
            context.appText.failed,
          ];
          final isSelected = _tabController.index == index;

          return Tab(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                tabLabels[index],
                style:isSelected?AppTextStyle.h6.copyWith(color: Colors.white): AppTextStyle.h6,
              ),
            ),
          );
        }),
      ),
      ),
      body: BlocBuilder<KavachTransactionsCubit, KavachTransactionsState>(
        bloc: _transactionsCubit,
        builder: (context, state) {
          if (state is KavachTransactionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KavachTransactionsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(
                  filterTransactions(state.transactions, 'all'),
                ),
                _buildTransactionList(
                  filterTransactions(state.transactions, 'success'),
                ),
                _buildTransactionList(
                  filterTransactions(state.transactions, 'pending'),
                ),
                _buildTransactionList(
                  filterTransactions(state.transactions, 'failed'),
                ),
              ],
            );
          } else if (state is KavachTransactionsError) {
            return Center(child: Text(state.message.getText(context)));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTransactionList(List<KavachTransactionModel> txnList) {
    if (txnList.isEmpty) {
      return const Center(child: Text('No transactions found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: txnList.length,
      itemBuilder: (context, index) {
        final txn = txnList[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 15),
              child: SvgPicture.asset(
                txn.status.toLowerCase() == 'success'
                    ? AppIcons.svg.kavachTransactionSuccess
                    : AppIcons.svg.kavachTransactionFailed,
              ),
            ),
            10.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(txn.orderId, style: AppTextStyle.h5),
                  Text(
                    'Txn: ${txn.txnId}\n'
                    '${formatDateTimeKavach(txn.date.toString())}',
                    style: AppTextStyle.textGreyColor12w400,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  KavachHelper.formatCurrency(txn.orderAmount),
                  style: AppTextStyle.h5,
                ),
                4.height,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(txn.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    txn.status.capitalize,
                    style: TextStyle(
                      color: getStatusColor(txn.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ).paddingSymmetric(vertical: 5);
      },
    );
  }
}
