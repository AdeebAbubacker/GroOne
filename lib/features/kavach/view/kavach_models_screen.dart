import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_event.dart'
    as events;
import 'package:gro_one_app/features/kavach/bloc/kavach_list_bloc/kavach_products_list_state.dart';
import 'package:gro_one_app/features/kavach/view/kavach_checkout_screen.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_models_list_body.dart';
import 'package:gro_one_app/features/kavach/view/widgets/choose_your_preference_form.dart';
import 'package:gro_one_app/features/kavach/model/kavach_choose_preference_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_button_style.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_dialog.dart';
import 'package:gro_one_app/utils/app_icon_button.dart';
import 'package:gro_one_app/utils/app_icons.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/common_dialog_view/common_dialog_view.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:intl/intl.dart';

import '../../../utils/common_functions.dart';
import 'kavach_support_screen.dart';
import 'kavach_transaction_screen.dart';

class KavachModelsScreen extends StatelessWidget {
  final KavachChoosePreferenceModel? initialPreferences;

  const KavachModelsScreen({super.key, this.initialPreferences});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: locator<KavachProductsListBloc>(),
      child: KavachModelsScreenContent(initialPreferences: initialPreferences),
    );
  }
}

class KavachModelsScreenContent extends StatefulWidget {
  final KavachChoosePreferenceModel? initialPreferences;

  const KavachModelsScreenContent({super.key, this.initialPreferences});

  @override
  State<KavachModelsScreenContent> createState() =>
      _KavachModelsScreenContentState();
}

class _KavachModelsScreenContentState extends State<KavachModelsScreenContent> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<String, List<String>> selectedVehicles = {};

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<KavachProductsListBloc>();

    // Update preferences if provided
    if (widget.initialPreferences != null) {
      bloc.add(events.UpdateUserPreferences(widget.initialPreferences!));
    }

    bloc.add(events.ClearKavachQuantities());

    // Fetch products with preferences and masters data if not already loaded
    bloc.add(
      events.FetchKavachProducts(preferences: widget.initialPreferences),
    );
    if (bloc.state.mastersData == null) {
      bloc.add(events.FetchMastersData());
    }

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// Handles scroll events for pagination
  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<KavachProductsListBloc>();
      if (!bloc.state.loading && bloc.state.hasMore) {
        bloc.add(
          events.FetchKavachProducts(
            page: bloc.state.currentPage + 1,
            isLoadMore: true,
            preferences: bloc.state.userPreferences,
          ),
        );
      }
    }
  }

  /// Debounces search input to avoid excessive API calls
  void debounce(VoidCallback callback) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), callback);
  }

  /// Checks if the user has scrolled to the bottom of the list
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackishWhite,
      appBar: CommonAppBar(
        title: context.appText.buyNewTankLock,
        centreTile: false,
        elevation: 0.1,
        actions: [
          AppIconButton(
            onPressed: () {
              Navigator.push(context, commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),

          //  AppIconButton(
          //   onPressed: () {
          //   },
          //   icon: Image.asset(AppIcons.png.moreVertical),
          //   iconColor: AppColors.primaryColor,
          // ),
          PopupMenuButton<String>(
            color: Colors.white,
            icon: Image.asset(AppIcons.png.moreVertical),
            offset: Offset(20, 50),
            onSelected: (value) {
              if (value == context.appText.transactions) {
                Navigator.push(context, commonRoute(KavachTransactionsScreen()));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: context.appText.transactions,
                  child: Text(context.appText.transactions,style: AppTextStyle.h6,),
                ),
              ];
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search bar and filter section
            buildSearchBarAndFilterWidget(context),
            15.height,
            // Main content area
            Expanded(child: buildBodyWidget(context)),
          ],
        ).paddingAll(commonSafeAreaPadding),
      ),
      // Bottom navigation with buy button
      bottomNavigationBar:
          BlocBuilder<KavachProductsListBloc, KavachProductsListState>(
            builder: (context, state) {
              final totalQuantity = state.quantities.values.fold<int>(
                0,
                (sum, qty) => sum + qty,
              );
              if (totalQuantity == 0) return const SizedBox.shrink();

              final totalPrice = state.products.fold<double>(0.0, (
                sum,
                product,
              ) {
                final quantity = state.quantities[product.id] ?? 0;
                return sum + (product.price * quantity);
              });

              return buildBuyButtonWidget(totalQuantity, totalPrice);
            },
          ),
    );
  }

  /// Builds the search bar and filter widget
  Widget buildSearchBarAndFilterWidget(BuildContext context) {
    return Row(
      children: [
        // Search bar
        AppSearchBar(
          searchController: searchController,
          onChanged: (text) {
            debounce(() {
              final bloc = context.read<KavachProductsListBloc>();
              bloc.add(events.ClearKavachQuantities());
              bloc.add(
                events.FetchKavachProducts(
                  search: text,
                  preferences: bloc.state.userPreferences,
                ),
              );
            });
          },
        ).expand(),
        15.width,
        // Filter button
        AppIconButton(
          onPressed: () {
            // Show choose preference form in bottom sheet
            final bloc = context.read<KavachProductsListBloc>();
            final state = bloc.state;

            if (state.mastersData != null) {
              commonBottomSheetWithBGBlur(
                context: context,
                screen: Material(
                  child: ChooseYourPreferenceForm(
                    vehicleFilters: state.mastersData!.data.vehicleFilters,
                    showTitle: true,
                    initialValues: state.userPreferences,
                    onPreferenceChanged: (preferences) {
                      // Handle preference changes
                      bloc.add(events.UpdateUserPreferences(preferences));
                    },
                    onApply: () {
                      Navigator.of(context).pop(); // Close bottom sheet
                      bloc.add(events.ClearKavachQuantities());
                      bloc.add(
                        events.FetchKavachProducts(
                          preferences: bloc.state.userPreferences,
                        ),
                      );
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onSupport: () {
                      // Handle support button when BS6 is selected
                      commonSupportDialog(context);
                    },
                  ),
                ),
              );
            }
          },
          style: AppButtonStyle.primaryIconButtonStyle,
          icon: SvgPicture.asset(AppIcons.svg.newFilter, width: 20),
        ),
      ],
    );
  }

  Widget buildBodyWidget(BuildContext context) {
    return BlocBuilder<KavachProductsListBloc, KavachProductsListState>(
      builder: (context, state) {
        if (state.loading && state.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: AppColors.greyTextColor,
                ),
                16.height,
                Text(
                  'No data available',
                  style: AppTextStyle.h5.copyWith(
                    color: AppColors.greyTextColor,
                  ),
                ),
              ],
            ),
          );
        }
        // Separate in-stock and out-of-stock products
        final inStockProducts = state.products.where((p) => (state.availableStocks[p.id] ?? 0) > 0).toList();
        final outOfStockProducts = state.products.where((p) => (state.availableStocks[p.id] ?? 0) == 0).toList();

// Combine them with in-stock first
        final sortedProducts = [...inStockProducts, ...outOfStockProducts];


        return ListView.separated(
          controller: _scrollController,
          // itemCount: state.products.length + (state.loading ? 1 : 0),
          // separatorBuilder: (_, __) => 20.height,
          // itemBuilder: (context, index) {
          //   if (index == state.products.length) {
          //     return const Center(
          //       child: Padding(
          //         padding: EdgeInsets.all(8.0),
          //         child: CircularProgressIndicator(),
          //       ),
          //     );
          //   }
          //   final product = state.products[index];
          //   final qty = state.quantities[product.id] ?? 0;
          //   final availableStock = state.availableStocks[product.id] ?? 0;
          //
          //   return KavachModelsListBody(
          //     product: product,
          //     quantity: qty,
          //     availableStock: availableStock,
          //   );
          // },
          separatorBuilder: (_, __) => 20.height,
          itemCount: sortedProducts.length + (state.loading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == sortedProducts.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final product = sortedProducts[index];
            final qty = state.quantities[product.id] ?? 0;
            final availableStock = state.availableStocks[product.id] ?? 0;

            return KavachModelsListBody(
              product: product,
              quantity: qty,
              availableStock: availableStock,
            );
          },

        );
      },
    );
  }

  Widget buildBuyButtonWidget(int totalQuantity, double totalPrice) {
    return BlocBuilder<KavachProductsListBloc, KavachProductsListState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹ ${NumberFormat("#,##,###").format(totalPrice.toInt())}",
                      style: AppTextStyle.h4,
                    ),
                    Text(
                      "$totalQuantity ${totalQuantity == 1 ? context.appText.item : context.appText.items}",
                      style: AppTextStyle.bodyPrimaryColor,
                    ),
                  ],
                ),
                AppButton(
                  title: context.appText.checkout.capitalize,
                  onPressed: () async {
                    final bloc = context.read<KavachProductsListBloc>();
                    final result = await Navigator.of(context).push(
                      commonRoute(
                        KavachCheckoutScreen(
                          products:
                              bloc.state.products
                                  .where(
                                    (p) =>
                                        (bloc.state.quantities[p.id] ?? 0) > 0,
                                  )
                                  .toList(),
                          quantities: Map.from(bloc.state.quantities),
                          previousVehicleSelection: selectedVehicles,
                        ),
                      ),
                    );

                    if (result != null) {
                      // Update quantities
                      bloc.add(
                        events.UpdateKavachQuantities(result['quantities']),
                      );

                      // Store selected vehicles
                      setState(() {
                        selectedVehicles = Map<String, List<String>>.from(
                          (result['vehicles'] as Map).map(
                            (key, value) => MapEntry(
                              key as String,
                              List<String>.from(value),
                            ),
                          ),
                        );
                      });
                    } else {
                      // Clear quantities and vehicle selections if back without any selection
                      bloc.add(events.ClearKavachQuantities());
                      setState(() {
                        selectedVehicles = {};
                      });
                    }
                  },
                ).withWidth(180),
              ],
            ).paddingSymmetric(horizontal: 20, vertical: 20),
          ),
        );
      },
    );
  }
}
