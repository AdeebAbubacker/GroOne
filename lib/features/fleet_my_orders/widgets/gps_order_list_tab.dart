import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/common_widgets.dart';
import '../../gps_feature/cubit/gps_order_cubit_folder/gps_order_list_cubit.dart';
import '../../gps_feature/gps_order_repo/gps_order_api_repository.dart';
import '../../gps_feature/views/gps_order/gps_order_detail_screen.dart';
import '../../kavach/helper/kavach_helper.dart';
import '../../login/repository/user_information_repository.dart';

class GpsOrderListTabWidget extends StatefulWidget {
  const GpsOrderListTabWidget({super.key});

  @override
  State<GpsOrderListTabWidget> createState() => _GpsOrderListTabWidgetState();
}

class _GpsOrderListTabWidgetState extends State<GpsOrderListTabWidget> {
  String? customerId;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _loadCustomerId();
    _searchController.addListener(() {
      setState(() => _searchText = _searchController.text.trim().toLowerCase());
    });
  }

  Future<void> _loadCustomerId() async {
    final repo = locator<UserInformationRepository>();
    final id = await repo.getUserID();
    if (mounted) setState(() => customerId = id);
  }

  @override
  Widget build(BuildContext context) {
    if (customerId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create:
          (_) =>
              GpsOrderListCubit(locator<GpsOrderApiRepository>())
                ..getOrderList(customerId: customerId!),
      child: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: BlocBuilder<GpsOrderListCubit, GpsOrderListState>(
              builder: (context, state) {
                if (state is GpsOrderListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GpsOrderListLoaded) {
                  if (state.orderList.data.rows.isEmpty) {
                    return Center(child: Text(context.appText.noOrdersFound));
                  }

                  final filtered =
                      state.orderList.data.rows.where((o) {
                        return o.orderUniqueId.toLowerCase().contains(
                              _searchText,
                            ) ||
                            o.productNames.toLowerCase().contains(_searchText);
                      }).toList();

                  return ListView.separated(
                    separatorBuilder: (context, index) => 10.height,
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      final statusColor = AppColors.greenColor;
                      return Container(
                        decoration: commonContainerDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          shadow: true,
                          borderColor: AppColors.borderColor,
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${context.appText.orderId}: ${order.orderUniqueId}',
                                  style: AppTextStyle.h4PrimaryColor.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ).expand(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: commonContainerDecoration(
                                    color: statusColor.withValues(alpha: 0.09),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    order.currentStatus,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            6.height,
                            Row(
                              children: [
                                Text(
                                  order.productNames,
                                  style: AppTextStyle.textGreyColor14w300,
                                ).expand(),
                                Text(
                                  '₹${KavachHelper.formatCurrency(order.totalPrice.toStringAsFixed(0))}',
                                  style: AppTextStyle.h4,
                                ),
                              ],
                            ),
                            8.height,
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      commonRoute(
                                        GpsOrderDetailScreen(order: order),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    context.appText.viewDetails,
                                    style: AppTextStyle.primaryColor16w400,
                                  ),
                                ),
                                15.width,
                                Text(
                                  '${context.appText.purchasedOn} ${order.orderDate}',
                                  style: AppTextStyle.textGreyColor14w300,
                                  maxLines: 1,
                                ).expand(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is GpsOrderListError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: context.appText.search,
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchText.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
