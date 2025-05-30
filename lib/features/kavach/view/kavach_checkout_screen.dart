import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/view/kavach_shipping_address_list_screen.dart';
import 'package:gro_one_app/features/kavach/view/kavach_summary_screen.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_check_box.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import '../model/kavach_product.dart';
import 'widgets/product_counter.dart';

class KavachCheckoutScreen extends StatefulWidget {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  const KavachCheckoutScreen({super.key, required this.products, required this.quantities});

  @override
  State<KavachCheckoutScreen> createState() => _KavachCheckoutScreenState();
}

class _KavachCheckoutScreenState extends State<KavachCheckoutScreen> {
  final MultiSelectController<String> vehicleDetailsController = MultiSelectController<String>();


  final List<DropdownItem<String>> vehicleDetailsItems = [
    DropdownItem(label: 'Vehicle 1', value: 'vehicle 1'),
    DropdownItem(label: 'Vehicle 2', value: 'vehicle 2'),
  ];
  late Map<String, int> _quantities;
  late List<KavachProduct> _products;

  @override
  void initState() {
    super.initState();
    _quantities = Map<String, int>.from(widget.quantities);
    _products = List<KavachProduct>.from(widget.products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.checkout,onLeadingTap: () {
        Navigator.of(context).pop(_quantities);
      },),
      bottomNavigationBar: buildPlaceOrderButtonWidget(),
      body: buildBodyWidget(context),
    );
  }

  Widget productWidget(KavachProduct product, int quantity) {
    num totalPrice = product.price*quantity;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(product.name, style: AppTextStyle.h5).expand(),
                ProductCounter(
                  count: quantity,
                  onIncrement: () {
                    setState(() {
                      _quantities[product.id] = quantity + 1;
                    });
                  },
                  onDecrement: () {
                    if (quantity > 1) {
                      setState(() {
                        _quantities[product.id] = quantity - 1;
                      });
                    } else {
                      // Quantity will become 0 – remove the product
                      setState(() {
                        _quantities.remove(product.id);
                        _products.removeWhere((p) => p.id == product.id);
                      });

                    }
                  },

                ),
              ],
            ),
            Row(
              children: [
                Text(product.part, style: AppTextStyle.bodyGreyColor).expand(),
                Text("$indianCurrencySymbol ${totalPrice.toStringAsFixed(2)}", style: AppTextStyle.h4PrimaryColor),
              ],
            ),
          ],
        ).expand(),
      ],
    ).paddingSymmetric(horizontal: 10);
  }

  Widget buildBodyWidget(BuildContext context){
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                decoration: commonContainerDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.appText.productDetails,style: AppTextStyle.h5,),
                    10.height,
                    ListView.separated(
                      itemCount: _products.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(height: 20),
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final quantity = _quantities[product.id] ?? 0;
                        return productWidget(product, quantity);
                      },
                    ),
                    TextButton.icon(onPressed: () {
                      Navigator.of(context).pop(_quantities);
                    }, label: Text(context.appText.addMoreItems,style: AppTextStyle.primaryColor16w400,),
                      icon: Icon(Icons.add,color: AppColors.primaryColor,),
                    ),
                  ],
                )
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppMultiSelectionDropdown<String>(
                    labelText: context.appText.addVehicleDetails,
                    hintText: context.appText.select,
                    controller: vehicleDetailsController,
                    items: vehicleDetailsItems,
                    onSelectionChange: (selected) {
                      print('Vehicle details: $selected');
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "${context.appText.truckType} ${context.appText.pinCode}";
                      }
                      return null;
                    },
                  ),
                  15.height,
                  Text('${context.appText.gstKavach} (${context.appText.optional})',style: AppTextStyle.body3,),
                  AppTextField(
                    hintText: 'Eg: GS68468GS654',
                  ),
                  10.height
                ],
              ),
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.shippingAddress, style: AppTextStyle.body3,),
                  5.height,
                  TextButton.icon(onPressed: () {
                    commonBottomSheetWithBGBlur(context: context, screen: KavachShippingAddressListScreen());
                  }, label: Text(context.appText.addNewAddress,style: AppTextStyle.primaryColor16w400,),
                    icon: Icon(Icons.add,color: AppColors.primaryColor,),
                  ),
                  15.height,
                  Text(context.appText.billingAddress,style: AppTextStyle.body3,),
                  Row(
                    children: [
                      AppCheckBox(onChanged: (p0) {
                      }, value: false),
                      Text(context.appText.sameAsShippingAddress, style: AppTextStyle.primaryColor16w400,).expand()
                    ],
                  ),
                  10.height,
                ],
              ),
            )
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }

  Widget buildPlaceOrderButtonWidget(){
    return AppButton(
      title: context.appText.placeOrder,
      onPressed: (){
        Navigator.of(context).push(commonRoute(KavachSummaryScreen()));
      },
    ).bottomNavigationPadding();
  }
}
