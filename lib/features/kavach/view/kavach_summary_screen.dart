import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gro_one_app/features/kavach/api_request/kavach_order_api_request.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_bloc.dart';
import 'package:gro_one_app/features/kavach/bloc/kavach_order_bloc/kavach_order_event.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/nullable_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/utils/toast_messages.dart';
import '../../../dependency_injection/locator.dart';
import '../../../utils/app_application_bar.dart';
import '../../../utils/app_button.dart';
import '../../../utils/app_button_style.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/common_widgets.dart';
import '../../../utils/extra_utils.dart';
import '../bloc/kavach_order_bloc/kavach_order_state.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_bloc.dart';
import '../bloc/kavach_order_list_bloc/kavach_order_list_event.dart';
import '../model/kavach_address_model.dart';
import '../model/kavach_product_model.dart';

class KavachSummaryScreen extends StatefulWidget {
  final List<KavachProduct> products;
  final Map<String, int> quantities;
  final Map<String, int> availableStocks;
  final KavachAddressModel shippingAddress;
  final KavachAddressModel billingAddress;
  final List<String> selectedVehicleNumbers;

  const KavachSummaryScreen({
    super.key,
    required this.products,
    required this.quantities,
    required this.shippingAddress,
    required this.billingAddress,
    required this.selectedVehicleNumbers, required this.availableStocks,
  });

  @override
  State<KavachSummaryScreen> createState() => _KavachSummaryScreenState();
}

class _KavachSummaryScreenState extends State<KavachSummaryScreen> {
  final kavachOrderBloc = locator<KavachOrderBloc>();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: CommonAppBar(title: context.appText.summary),
  //     bottomNavigationBar: buildProceeToPayButton(context),
  //     body: buildBodyWidget(context),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return BlocListener<KavachOrderBloc, KavachOrderState>(
      bloc: kavachOrderBloc,
      listener: (context, state) {
        if (state is KavachOrderSubmitting) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          if (Navigator.canPop(context)) Navigator.of(context).pop();
        }

        if (state is KavachOrderSuccess) {
          showSuccessDialog(
            context,
            text: 'Order placed successfully',
            subheading: ''
          );
          // Future.delayed(Duration(seconds: 3),() {
          //   Navigator.of(context).popUntil((route) => route.settings.name == 'KavachOrderListScreen');
          // },);
          Future.delayed(Duration(seconds: 3),() {
            Navigator.of(context).popUntil((route) {
              if (route.settings.name == 'KavachOrderListScreen') {
                if (route.navigator != null && route.navigator!.context.mounted) {
                  BlocProvider.of<KavachOrderListBloc>(route.navigator!.context).add(FetchKavachOrderList(forceRefresh: true,isRefresh: true));
                }
                return true; // Pop until this route
              }
              return false;
            });
          },);

          // Pop until KavachBenefitsScreen
        } else if (state is KavachOrderFailure) {
          ToastMessages.error(message: "Failed to place order: ${state.message}");
        }
      },
      child: Scaffold(
        appBar: CommonAppBar(title: context.appText.summary),
        bottomNavigationBar: buildProceeToPayButton(context),
        body: buildBodyWidget(context),
      ),
    );
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
                    Text(context.appText.paymentDetails, style: AppTextStyle.h5,),
                    10.height,
                    Row(
                      children: [
                        Expanded(child: Text('Price (${widget.quantities.values.reduce((a, b) => a + b)} items)', style: AppTextStyle.textDarkGreyColor14w500)),
                        Text('₹${totalPrice.toStringAsFixed(2)}', style: AppTextStyle.blackColor15w500),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text(context.appText.gstKavach, style: AppTextStyle.textDarkGreyColor14w500)),
                        Text('₹${totalGst.toStringAsFixed(2)}', style: AppTextStyle.blackColor15w500),
                      ],
                    ),
                    Divider(color: AppColors.greyIconColor),
                    Row(
                      children: [
                        Expanded(child: Text(context.appText.totalAmount, style: AppTextStyle.textDarkGreyColor14w500)),
                        Text('₹${totalAmount.toStringAsFixed(2)}', style: AppTextStyle.blackColor15w500),
                      ],
                    ),

                  ],
                )
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.addVehicleDetails, style: AppTextStyle.blackColor15w500,),
                  10.height,
                  ...widget.selectedVehicleNumbers.map((v) => Text(v,style: AppTextStyle.textDarkGreyColor14w500,),),
                  ]
              ),
            ),
            15.height,
            Container(
              padding: EdgeInsets.all(10),
              decoration: commonContainerDecoration(),
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.appText.shippingAddress, style: AppTextStyle.textFiled,),
                  10.height,
                  _buildAddressCard(widget.shippingAddress),
                  15.height,
                  Text(context.appText.billingAddress, style: AppTextStyle.blackColor15w500,),
                  10.height,
                  _buildAddressCard(widget.billingAddress),
                ],
              ),
            ),
            30.height,
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }

  Widget buildProceeToPayButton(BuildContext context){
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('₹${totalAmount.toStringAsFixed(2)}', style: AppTextStyle.primaryColor16w900),
            Text(context.appText.total, style: AppTextStyle.blackColor14w400,),
          ],
        ),
        15.width,
        AppButton(
          onPressed: () async {
            // Navigator.of(context).push(commonRoute(KavachMakePaymentScreen()));
            final request = KavachOrderRequest(
              orderSource: "MOBILE",
              isOrderPaid: false,
              customerId: await kavachOrderBloc.getUserId()??'',
              totalPrice: totalAmount,
              categoryId: 1,
              shippingPersonIncharge: widget.shippingAddress.customerName,
              shippingPersonContactNo: widget.shippingAddress.mobileNumber??'',
              customerInfo: {
                "CompanyName": "ABC Logistics Pvt Ltd",
                "contactNumber": "9876543210",
                "BlueMembershipID": "BLUE123456"
              },
              billingAddress: {
                "addressLine1": widget.billingAddress.addr1,
                "addressLine2": widget.billingAddress.addr2,
                "city": widget.billingAddress.city,
                "state": widget.billingAddress.state,
                "postalCode": widget.billingAddress.pincode,
                "country": widget.billingAddress.country,
                "gstId": widget.billingAddress.gstin??"",
                "contactPerson": widget.billingAddress.customerName,
                "contactNumber": widget.billingAddress.mobileNumber
              },
              shippingAddress: {
                "addressLine1": widget.shippingAddress.addr1,
                "addressLine2": widget.shippingAddress.addr2,
                "city": widget.shippingAddress.city,
                "state": widget.shippingAddress.state,
                "postalCode": widget.shippingAddress.pincode,
                "country": widget.shippingAddress.country,
                "gstId":  widget.shippingAddress.gstin,
                "contactPerson": widget.shippingAddress.customerName,
                "contactNumber": widget.shippingAddress.mobileNumber
              },
              orders: widget.products.map((product) {
                final quantity = widget.quantities[product.id]!;
                final stock = widget.availableStocks[product.id] ?? 0;

                return KavachOrderItem(
                  productServiceId: int.parse(product.id),
                  noOfProducts: quantity,
                  unitPrice: product.price,
                  totalPrice: product.price * quantity * (1 + (product.gstPerc / 100)),
                  stockAvailable: stock,
                  vehicleNumbers: widget.selectedVehicleNumbers.map((v) => KavachOrderVehicle(vehicleNumber: v)).toList(),
                );
              }).toList(),
            );
            kavachOrderBloc.add(KavachSubmitOrder(request));
          },
          title: context.appText.placeOrder,
          style: AppButtonStyle.primary,
        ).expand()
      ],
    ).paddingAll(30);
  }

  Widget _buildAddressCard(KavachAddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${address.customerName}",style: AppTextStyle.textDarkGreyColor14w500,),
        Text("Mobile: ${address.mobileNumber}",style: AppTextStyle.textDarkGreyColor14w500,),
        Text("${address.addr1}, ${address.addr1}",style: AppTextStyle.textDarkGreyColor14w500,),
        Text("${address.city}, ${address.state}",style: AppTextStyle.textDarkGreyColor14w500,),
        Text("${address.country}- ${address.pincode}",style: AppTextStyle.textDarkGreyColor14w500,),
        Visibility(
            visible: address.gstin!=null && address.gstin!.isNotEmpty,
            child: Text("${context.appText.gstKavach} - ${address.gstin}",style: AppTextStyle.textDarkGreyColor14w500,)),
      ],
    );
  }

  double get totalPrice {
    double total = 0.0;
    for (var product in widget.products) {
      int qty = widget.quantities[product.id] ?? 0;
      total += product.price * qty;
    }
    return total;
  }

  double get totalGst {
    double gst = 0.0;
    for (var product in widget.products) {
      int qty = widget.quantities[product.id] ?? 0;
      double itemTotal = product.price * qty;
      gst += itemTotal * (product.gstPerc / 100);
    }
    return gst;
  }

  double get totalAmount {
    return totalPrice + totalGst;
  }
}

// class KavachSummaryScreen extends StatelessWidget {
//   final List<KavachProduct> products;
//   final Map<String, int> quantities;
//   final KavachAddressModel shippingAddress;
//   final KavachAddressModel billingAddress;
//   final List<String> selectedVehicleNumbers;
//
//   const KavachSummaryScreen({
//     super.key,
//     required this.products,
//     required this.quantities,
//     required this.shippingAddress,
//     required this.billingAddress,
//     required this.selectedVehicleNumbers,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Order Summary")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle("Products"),
//             ...products.map((product) {
//               final quantity = quantities[product.id] ?? 1;
//               return ListTile(
//                 title: Text(product.name),
//                 subtitle: Text('Quantity: $quantity'),
//                 trailing: Text('₹${(product.price ?? 0) * quantity}'),
//               );
//             }).toList(),
//             const Divider(),
//             _buildSectionTitle("Selected Vehicles"),
//             ...selectedVehicleNumbers.map((v) => ListTile(
//               leading: const Icon(Icons.directions_car),
//               title: Text(v),
//             )),
//
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // call _placeOrder() or any order logic
//               },
//               child: const Text("Proceed to Pay"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//

// void _placeOrder() {
//   final List<Map<String, dynamic>> orderItems = [];
//
//   for (var product in products) {
//     final int quantity = quantities[product.id] ?? 0;
//     final double unitPrice = product.price;
//     final double gstAmount = (unitPrice * product.gstPerc / 100);
//     final double total = (unitPrice + gstAmount) * quantity;
//     final int stock = availableStocks[product.id] ?? 0;
//
//     // For now, we assign all selected vehicles to each product (update if you have mapping)
//     final List<Map<String, dynamic>> vehicleList = selectedVehicleNumbers.map((vehicleNo) {
//       return {
//         "vehicleNumber": vehicleNo,
//         "deviceUniqueNumber": "" // or use mapping if available
//       };
//     }).toList();
//
//     orderItems.add({
//       "productServiceId": int.tryParse(product.id) ?? 0,
//       "noOfProducts": quantity,
//       "unitPrice": unitPrice,
//       "totalPrice": total,
//       "stockAvailable": stock,
//       "vehicle_number": vehicleList
//     });
//   }
//
//   final Map<String, dynamic> orderPayload = {
//     "orderSource": "MOBILE",
//     "isOrderPaid": false,
//     "customerId": "11726", // Replace with actual
//     "totalPrice": totalAmount.toStringAsFixed(2),
//     "categoryId": 1,
//     "shippingPersonIncharge": shippingAddress.customerName,
//     "shippingPersonContactNo": shippingAddress.mobileNumber,
//     "customerInfo": {
//       "CompanyName": "Testing Company name",
//       "contactNumber": "9988998899",
//       "BlueMembershipID": "BLUE123456"
//     },
//     "billingAddress": {
//       "addressLine1": billingAddress.addr1,
//       "addressLine2": billingAddress.addr2,
//       "city": billingAddress.city,
//       "state": billingAddress.state,
//       "postalCode": billingAddress.pincode,
//       "country": "India",
//       "gstId": "",
//       "contactPerson": billingAddress.customerName,
//       "contactNumber": billingAddress.mobileNumber
//     },
//     "shippingAddress": {
//       "addressLine1": shippingAddress.addr1,
//       "addressLine2": shippingAddress.addr2,
//       "city": shippingAddress.city,
//       "state": shippingAddress.state,
//       "postalCode": shippingAddress.pincode,
//       "country": "India",
//       "gstId": "",
//       "contactPerson": shippingAddress.customerName,
//       "contactNumber": shippingAddress.mobileNumber
//     },
//     "orders": orderItems,
//   };
//
//   // Call your API or service
//   print(jsonEncode(orderPayload));
//
// }


