import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/data/ui_state/status.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/gps_feature/cubit/gps_order_cubit_folder/gps_products_cubit.dart';
import 'package:gro_one_app/features/gps_feature/models/gps_document_models.dart';
import 'package:gro_one_app/features/gps_feature/gps_order_repo/gps_order_api_repository.dart';
import 'package:gro_one_app/features/kavach/model/kavach_product_model.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extensions/string_extensions.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_route.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import 'package:intl/intl.dart';
import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_icon_button.dart';
import '../../../../utils/app_icons.dart';
import '../../../../utils/app_search_bar.dart';
import '../../../../utils/app_text_style.dart';
import '../../../kavach/view/kavach_support_screen.dart';
import '../../widgets/gps_model_widget.dart';
import 'gps_order_checkout_screen.dart';

class GpsModelsScreen extends StatefulWidget {
  const GpsModelsScreen({super.key});

  @override
  State<GpsModelsScreen> createState() => _GpsModelsScreenState();
}

class _GpsModelsScreenState extends State<GpsModelsScreen> {
  final TextEditingController searchController = TextEditingController();
  late final GpsProductsCubit _gpsProductsCubit;

  @override
  void initState() {
    super.initState();
    try {
      _gpsProductsCubit = locator<GpsProductsCubit>();
      _gpsProductsCubit.fetchGpsProducts();
    } catch (e) {
      // Fallback: create a new instance directly
      final repository = locator<GpsOrderApiRepository>();
      _gpsProductsCubit = GpsProductsCubit(repository);
      _gpsProductsCubit.fetchGpsProducts();
    }
    
    // Clear search field when navigating to this screen
    searchController.clear();
    _gpsProductsCubit.searchProducts('');
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Track previous vehicle selections
  Map<String, List<String>>? _previousVehicleSelection;

  // Track previous form data
  String? _previousReferralCode;
  bool? _previousShippingSameAsBilling;
  String? _previousShippingPersonInCharge;
  String? _previousShippingPersonContactNo;

  // Filtered products based on search
  List<KavachProduct> get _filteredProducts {
    final products = _gpsProductsCubit.filteredProducts.map((gpsProduct) => gpsProduct.toKavachProduct()).toList();

    if (searchController.text.isEmpty) {
      return products;
    }
    return products.where((product) {
      return product.name.toLowerCase().contains(searchController.text.toLowerCase()) ||
          product.part.toLowerCase().contains(searchController.text.toLowerCase());
    }).toList();
  }



  // Get products that have quantities > 0
  List<KavachProduct> get _selectedProducts {
    return _filteredProducts.where((product) => (_gpsProductsCubit.state.quantities[product.id] ?? 0) > 0).toList();
  }

  // Get quantities map for selected products only
  Map<String, int> get _selectedQuantities {
    final selectedQuantities = <String, int>{};
    for (var product in _selectedProducts) {
      final quantity = _gpsProductsCubit.state.quantities[product.id] ?? 0;
      if (quantity > 0) {
        selectedQuantities[product.id] = quantity;
      }
    }
    return selectedQuantities;
  }

  Widget _buildProductsList(GpsProductsState state) {
    // Show loading state
    if (state.productsState?.status == Status.LOADING && state.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state
    if (state.productsState?.status == Status.ERROR && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.greyTextColor,
            ),
            16.height,
            Text(
              context.appText.failedToLoadGpsDevices,
              style: AppTextStyle.h5.copyWith(
                color: AppColors.greyTextColor,
              ),
            ),
            8.height,
            TextButton(
              onPressed: () => _gpsProductsCubit.refreshProducts(),
              child: Text(context.appText.retry),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.greyTextColor,
            ),
            16.height,
            Text(
              context.appText.noGpsDevicesFound,
              style: AppTextStyle.h5.copyWith(
                color: AppColors.greyTextColor,
              ),
            ),
          ],
        ),
      );
    }

    // Separate in-stock and out-of-stock products
    final inStockProducts = _filteredProducts.where((p) => (state.availableStocks[p.id] ?? 0) > 0).toList();
    final outOfStockProducts = _filteredProducts.where((p) => (state.availableStocks[p.id] ?? 0) == 0).toList();

    // Combine them with in-stock first
    final sortedProducts = [...inStockProducts, ...outOfStockProducts];

    // Show products list
    return ListView.separated(
      separatorBuilder: (context, index) => 15.height,
      shrinkWrap: true,
      itemCount: sortedProducts.length,
      itemBuilder: (context, index) {
        final product = sortedProducts[index];
        final quantity = state.quantities[product.id] ?? 0;
        final availableStock = state.availableStocks[product.id] ?? 0;

        return GpsModelWidget(
          product: product,
          quantity: quantity,
          availableStock: availableStock,
          onQuantityChanged: (newQuantity) {
            if (newQuantity <= 0) {
              _gpsProductsCubit.decrementQuantity(product.id);
            } else {
              final currentQty = state.quantities[product.id] ?? 0;
              if (newQuantity > currentQty) {
                // Incrementing - check stock
                if (newQuantity <= availableStock) {
                  _gpsProductsCubit.incrementQuantity(product.id);
                } else {
                  ToastMessages.alert(message: 'Cannot add more items. Stock limit reached.');
                }
              } else {
                // Decrementing - no stock check needed
                _gpsProductsCubit.decrementQuantity(product.id);
              }
            }
          },
        );
      },
    );
  }

  void _onCheckoutPressed() async {
    if (_selectedProducts.isEmpty) {
      ToastMessages.alert(message: context.appText.pleaseSelectAtLeastOneGpsDevice);
      return;
    }

    final result = await Navigator.of(context).push(
      commonRoute(
        GpsOrderCheckoutScreen(
          products: _selectedProducts.map((kavachProduct) =>
              GpsProduct(
                id: kavachProduct.id,
                fleetProductId: '1',
                name: kavachProduct.name,
                part: kavachProduct.part,
                price: kavachProduct.price.toString(),
                gstPerc: kavachProduct.gstPerc.toString(),
              )
          ).toList(),
          quantities: _selectedQuantities,
          previousVehicleSelection: _previousVehicleSelection,
          previousReferralCode: _previousReferralCode,
          previousShippingSameAsBilling: _previousShippingSameAsBilling,
          previousShippingPersonInCharge: _previousShippingPersonInCharge,
          previousShippingPersonContactNo: _previousShippingPersonContactNo,
        ),
      ),
    );

    // Handle result from checkout screen
    if (result != null) {
      
      // Clear search text when returning from checkout (Add More or other navigation)
      searchController.clear();
      _gpsProductsCubit.searchProducts('');
      
      // Update quantities based on result from checkout
      if (result is Map<String, dynamic>) {
        // Handle new format with quantities and vehicles
        if (result.containsKey('quantities')) {
          final quantities = result['quantities'] as Map<String, int>;
          _gpsProductsCubit.updateQuantities(quantities);
        } else if (result is Map<String, int>) {
          // Handle old format (just quantities)
          _gpsProductsCubit.updateQuantities(result);
        }

        // Store vehicle selections for next navigation
        if (result.containsKey('vehicles')) {
          try {
            final vehiclesData = result['vehicles'] as Map<String, dynamic>;
            _previousVehicleSelection = vehiclesData.map(
                  (key, value) => MapEntry(
                key,
                (value as List<dynamic>).map((item) => item.toString()).toList(),
              ),
            );
          } catch (e) {
            _previousVehicleSelection = null;
          }
        }

        // Store form data for next navigation
        if (result.containsKey('referralCode')) {
          _previousReferralCode = result['referralCode'] as String?;
        }

        if (result.containsKey('shippingSameAsBilling')) {
          _previousShippingSameAsBilling = result['shippingSameAsBilling'] as bool?;
        }

        if (result.containsKey('shippingPersonInCharge')) {
          _previousShippingPersonInCharge = result['shippingPersonInCharge'] as String?;
        }

        if (result.containsKey('shippingPersonContactNo')) {
          _previousShippingPersonContactNo = result['shippingPersonContactNo'] as String?;
        }
      }
    } else {
      // Clear quantities when returning from checkout (order completed or cancelled)
      _gpsProductsCubit.clearQuantities();
      _previousVehicleSelection = null;
      _previousReferralCode = null;
      _previousShippingSameAsBilling = null;
      _previousShippingPersonInCharge = null;
      _previousShippingPersonContactNo = null;
      
      // Clear search text when returning from checkout
      searchController.clear();
      _gpsProductsCubit.searchProducts('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: Text(context.appText.gpsModels, style: AppTextStyle.appBar),
        centreTile: false,
        actions: [
          AppIconButton(
            onPressed: () {
              // Navigate to support screen
              Navigator.push(context, commonRoute(KavachSupportScreen()));
            },
            icon: AppIcons.svg.filledSupport,
            iconColor: AppColors.primaryButtonColor,
          ),
          4.width,
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<GpsProductsCubit, GpsProductsState>(
          bloc: _gpsProductsCubit,
          builder: (context, state) {
            return Column(
              children: [
                // Search bar
                AppSearchBar(
                  searchController: searchController,
                  onChanged: (text) {
                    _gpsProductsCubit.searchProducts(text);
                    setState(() {
                      // Trigger rebuild to filter products
                    });
                  },
                ),
                20.height,
                // Products list
                Expanded(
                  child: _buildProductsList(state),
                ),
              ],
            ).paddingAll(commonSafeAreaPadding);
          },
        ),
      ),
      // Bottom navigation with checkout button
      bottomNavigationBar: BlocBuilder<GpsProductsCubit, GpsProductsState>(
        bloc: _gpsProductsCubit,
        builder: (context, state) {
          final totalQuantity = state.quantities.values.fold<int>(0, (sum, qty) => sum + qty);
          final totalPrice = _filteredProducts.fold<double>(0.0, (sum, product) {
            final quantity = state.quantities[product.id] ?? 0;
            return sum + (product.price * quantity);
          });
          
          return totalQuantity > 0
              ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1.0)),
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
                    onPressed: _onCheckoutPressed,
                  ).withWidth(180),
                ],
              ).paddingSymmetric(horizontal: 20, vertical: 20),
            ),
          )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}