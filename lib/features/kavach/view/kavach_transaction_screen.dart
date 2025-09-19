import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gro_one_app/features/kavach/helper/kavach_helper.dart';
import 'package:gro_one_app/features/kavach/model/kavach_order_list_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_icons.dart';
import '../cubit/kavach_transaction_cubit/kavach_transaction_cubit.dart';

class KavachTransactionsScreen extends StatefulWidget {
  final int fleetProductId;

  const KavachTransactionsScreen({super.key, this.fleetProductId = 2});

  @override
  State<KavachTransactionsScreen> createState() =>
      _KavachTransactionsScreenState();
}

class _KavachTransactionsScreenState extends State<KavachTransactionsScreen> {
  final _transactionsCubit = locator<KavachTransactionsCubit>();
  String _searchQuery = '';
  int page = 1;
  int totalPage = 1;
  List<KavachOrderListPayment> filteredPayments = [];
  final ScrollController productScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    productScroll.addListener(_onScroll);
    _transactionsCubit.fetchTransactions(fleetProductId: widget.fleetProductId);
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

  void _onScroll() {
    if (!productScroll.hasClients || page > totalPage) return;

    // Simple bottom detection like your example

    // Simple pagination trigger - exactly like your working example
    if (productScroll.position.pixels ==
        productScroll.position.maxScrollExtent) {
      debugPrint('jiooo');
      _transactionsCubit.fetchTransactions(
        fleetProductId: widget.fleetProductId,
        pageNo: page,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.transactions),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: AppTextField(
              decoration: InputDecoration(
                hintText: context.appText.search,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                filteredPayments =
                    filteredPayments
                        .where(
                          (p) =>
                              p.referenceNumber.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ) ||
                              p.paymentMode.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ),
                        )
                        .toList();
              },
            ),
          ),
          Expanded(
            child:
                BlocConsumer<KavachTransactionsCubit, KavachTransactionsState>(
                  listener: (c, s) {
                    if (s is KavachTransactionsLoaded) {
                      page += 1;
                      filteredPayments.addAll(s.transactions.toList());
                      totalPage = s.totalPage;
                    }
                  },
                  bloc: _transactionsCubit,
                  builder: (context, state) {
                    if (state is KavachTransactionsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is KavachTransactionsLoaded) {
                      // Directly using KavachOrderListPayment

                      if (filteredPayments.isEmpty) {
                        return Center(
                          child: Text(context.appText.noTransactionsFound),
                        );
                      }

                      return ListView.builder(
                        key: const PageStorageKey('transactionsList'),
                        controller: productScroll,
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredPayments.length,
                        itemBuilder: (context, index) {
                          final txn = filteredPayments[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13.0,
                                  vertical: 15,
                                ),
                                child: SvgPicture.asset(
                                  txn.status?.toLowerCase() == 'success'
                                      ? AppIcons.svg.kavachTransactionSuccess
                                      : AppIcons.svg.kavachTransactionFailed,
                                ),
                              ),
                              10.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      txn.referenceNumber,
                                      style: AppTextStyle.h5,
                                    ),
                                    Text(
                                      txn.paymentDate,
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
                                    KavachHelper.formatCurrency(
                                      double.tryParse(txn.paidAmount) ?? 0.0,
                                    ),
                                    style: AppTextStyle.h5,
                                  ),
                                  4.height,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: getStatusColor(
                                        txn.status ?? '',
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      (txn.status ?? '').capitalize,
                                      style: TextStyle(
                                        color: getStatusColor(txn.status ?? ''),
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
                    } else if (state is KavachTransactionsError) {
                      return Center(
                        child: Text(state.message.getText(context)),
                      );
                    }
                    return const SizedBox();
                  },
                ),
          ),
        ],
      ),
    );
  }
}
