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
      print('Error getting GpsProductsCubit: $e');
      // Fallback: create a new instance directly
      final repository = locator<GpsOrderApiRepository>();
      _gpsProductsCubit = GpsProductsCubit(repository);
      _gpsProductsCubit.fetchGpsProducts();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Available stocks for each product (mock data for now)
  final Map<String, int> _availableStocks = {
    '261': 20,
    '255': 15,
    '257': 10,
    '247': 8,
    '248': 25,
    '249': 12,
    '250': 18,
    '251': 14,
    '254': 16,
    '262': 22,
  };

  // Track quantities for each product
  final Map<String, int> _quantities = {};
  
  // Track previous vehicle selections
  Map<String, List<String>>? _previousVehicleSelection;

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

  // Calculate total quantity
  int get _totalQuantity {
    return _quantities.values.fold<int>(0, (sum, qty) => sum + qty);
  }

  // Calculate total price
  double get _totalPrice {
    return _filteredProducts.fold<double>(0.0, (sum, product) {
      final quantity = _quantities[product.id] ?? 0;
      return sum + (product.price * quantity);
    });
  }

  // Get products that have quantities > 0
  List<KavachProduct> get _selectedProducts {
    return _filteredProducts.where((product) => (_quantities[product.id] ?? 0) > 0).toList();
  }

  // Get quantities map for selected products only
  Map<String, int> get _selectedQuantities {
    final selectedQuantities = <String, int>{};
    for (var product in _selectedProducts) {
      final quantity = _quantities[product.id] ?? 0;
      if (quantity > 0) {
        selectedQuantities[product.id] = quantity;
      }
    }
    return selectedQuantities;
  }

  void _updateQuantity(String productId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        _quantities.remove(productId);
      } else {
        final availableStock = _availableStocks[productId] ?? 0;
        if (newQuantity <= availableStock) {
          _quantities[productId] = newQuantity;
        } else {
          ToastMessages.alert(message: 'Cannot add more items. Stock limit reached.');
        }
      }
    });
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
              'Failed to load GPS devices',
              style: AppTextStyle.h5.copyWith(
                color: AppColors.greyTextColor,
              ),
            ),
            8.height,
            TextButton(
              onPressed: () => _gpsProductsCubit.refreshProducts(),
              child: Text('Retry'),
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
              'No GPS devices found',
              style: AppTextStyle.h5.copyWith(
                color: AppColors.greyTextColor,
              ),
            ),
          ],
        ),
      );
    }

    // Show products list
    return ListView.separated(
      separatorBuilder: (context, index) => 15.height,
      shrinkWrap: true,
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        final quantity = _quantities[product.id] ?? 0;
        final availableStock = _availableStocks[product.id] ?? 0;

        return GpsModelWidget(
          product: product,
          quantity: quantity,
          availableStock: availableStock,
          onQuantityChanged: (newQuantity) {
            _updateQuantity(product.id, newQuantity);
          },
        );
      },
    );
  }

  void _onCheckoutPressed() async {
    if (_selectedProducts.isEmpty) {
      ToastMessages.alert(message: 'Please select at least one GPS device');
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
        ),
      ),
    );

    // Handle result from checkout screen
    if (result != null) {
      print('GPS Models: Received result from checkout: $result');
      setState(() {
        // Update quantities based on result from checkout
        _quantities.clear();
        if (result is Map<String, dynamic>) {
          // Handle new format with quantities and vehicles
          if (result.containsKey('quantities')) {
            final quantities = result['quantities'] as Map<String, int>;
            _quantities.addAll(quantities);
            print('GPS Models: Updated quantities: $_quantities');
          } else if (result is Map<String, int>) {
            // Handle old format (just quantities)
            _quantities.addAll(result);
            print('GPS Models: Updated quantities (old format): $_quantities');
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
              print('GPS Models: Stored vehicle selections: $_previousVehicleSelection');
            } catch (e) {
              print('Error parsing vehicle selections: $e');
              _previousVehicleSelection = null;
            }
          }
        }
      });
    } else {
      // Clear quantities when returning from checkout (order completed or cancelled)
      setState(() {
        _quantities.clear();
        _previousVehicleSelection = null;
      });
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
      bottomNavigationBar: _totalQuantity > 0
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
                          "₹ ${NumberFormat("#,##,###").format(_totalPrice.toInt())}",
                          style: AppTextStyle.h4,
                        ),
                        Text(
                          "$_totalQuantity ${context.appText.items}",
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
          : const SizedBox.shrink(),
    );
  }
}
