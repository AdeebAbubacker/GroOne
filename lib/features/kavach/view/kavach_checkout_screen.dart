import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_check_box.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_multi_selection_dropdown.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/extra_utils.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_route.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/constant_variables.dart';
import '../helper/product_counter.dart';

class KavachCheckoutScreen extends StatefulWidget {
  const KavachCheckoutScreen({super.key});

  @override
  State<KavachCheckoutScreen> createState() => _KavachCheckoutScreenState();
}

class _KavachCheckoutScreenState extends State<KavachCheckoutScreen> {
  final MultiSelectController<String> vehicleDetailsController = MultiSelectController<String>();


  final List<DropdownItem<String>> vehicleDetailsItems = [
    DropdownItem(label: 'Vehicle 1', value: 'vehicle 1'),
    DropdownItem(label: 'Vehicle 2', value: 'vehicle 2'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.checkout),
      bottomNavigationBar: buildPlaceOrderButtonWidget(),
      body: buildBodyWidget(context),
    );
  }

  Widget productWidget(){
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("eN-Dhan Kavach", style: AppTextStyle.h5).expand(),
                ProductCounter(
                  count: 1,
                  onIncrement: () {

                  },
                  onDecrement: () {

                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("CS01K0001", style: AppTextStyle.bodyGreyColor).expand(),
                Text("$indianCurrencySymbol 1,499", style: AppTextStyle.h4PrimaryColor),
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
                    Text('Product Details',style: AppTextStyle.h5,),
                    10.height,
                    ListView.separated(
                      itemCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(height: 20,),
                      itemBuilder: (context, index){
                        return productWidget();
                      },
                    ),
                    InkWell(
                      onTap: () {
        
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add,color: AppColors.primaryColor,),
                          Text('Add more items',style: AppTextStyle.primaryColor16w400,),
                        ],
                      ),
                    )
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
                    labelText: 'Add Vehicle Details',
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
                  Text('GST (optional)',style: AppTextStyle.body3,),
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
                  Text('Shipping Address',style: AppTextStyle.body3,),
                  5.height,
                  InkWell(
                    onTap: () {
        
                    },
                    child: Row(
                      children: [
                        Icon(Icons.add,color: AppColors.primaryColor,),
                        Text('Add New Addresses',style: AppTextStyle.primaryColor16w400,),
                      ],
                    ),
                  ),
                  15.height,
                  Text('Billing Address',style: AppTextStyle.body3,),
                  Row(
                    children: [
                      AppCheckBox(onChanged: (p0) {
        
                      }, value: false),
                      Text('Same as Shipping Address',style: AppTextStyle.primaryColor16w400,).expand()
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
      title: 'Place Order',
      onPressed: (){
        Navigator.of(context).push(commonRoute(KavachCheckoutScreen()));
      },
    ).bottomNavigationPadding();
  }
}
