// import 'package:gro_one_app/data/model/serializable.dart';
//
// class KavachPlaceOrderApiRequest extends Serializable<KavachPlaceOrderApiRequest>{
//   KavachPlaceOrderApiRequest({
//     this.userId,
//     this.productList,
//     this.vehicle,
//     this.shippingAddress,
//     this.billingAddress,
//     this.gstNo,
//     this.price,
//     this.gstAmt,
//     this.orderDateTime,
//     this.totalAmt
//   });
//
//   String? userId;
//   List<ProductList>? productList;
//   List<Vehicle>? vehicle;
//   String? shippingAddress;
//   String? billingAddress;
//   String? gstNo;
//   String? price;
//   String? gstAmt;
//   String? orderDateTime;
//   String? totalAmt;
//
//   KavachPlaceOrderApiRequest copyWith({
//     String? userId,
//     List<ProductList>? productList,
//     List<Vehicle>? vehicle,
//     String? shippingAddress,
//     String? billingAddress,
//     String? gstNo,
//     String? price,
//     String? gstAmt,
//     String? orderDateTime,
//     String? totalAmt,
//   }) {
//     return KavachPlaceOrderApiRequest(
//       userId: userId ?? this.userId,
//       productList: productList ?? this.productList,
//       vehicle: vehicle ?? this.vehicle,
//       shippingAddress: shippingAddress ?? this.shippingAddress,
//       billingAddress: billingAddress ?? this.billingAddress,
//       gstNo: gstNo ?? this.gstNo,
//       price: price ?? this.price,
//       gstAmt: gstAmt ?? this.gstAmt,
//       orderDateTime: orderDateTime ?? this.orderDateTime,
//       totalAmt: totalAmt ?? this.totalAmt,
//     );
//   }
//
//   @override
//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "product_list": productList?.map((x) => x.toJson()).toList(),
//     "vehicle": vehicle?.map((x) => x.toJson()).toList(),
//     "shipping_address": shippingAddress,
//     "billing_address": billingAddress,
//     "gst_no": gstNo,
//     "price": price,
//     "gst_amt": gstAmt,
//     "order_date_time": orderDateTime,
//     "total_amt": totalAmt,
//   };
//
// }
//
// class ProductList {
//   ProductList({
//     required this.id,
//     required this.quantity,
//   });
//
//   final String id;
//   final String quantity;
//
//   ProductList copyWith({
//     String? id,
//     String? quantity,
//   }) {
//     return ProductList(
//       id: id ?? this.id,
//       quantity: quantity ?? this.quantity,
//     );
//   }
//
//   factory ProductList.fromJson(Map<String, dynamic> json){
//     return ProductList(
//       id: json["id"] ?? "",
//       quantity: json["quantity"] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "quantity": quantity,
//   };
//
// }
//
// class Vehicle {
//   Vehicle({
//     required this.id,
//     required this.vehicleName,
//   });
//
//   final String id;
//   final String vehicleName;
//
//   Vehicle copyWith({
//     String? id,
//     String? vehicleName,
//   }) {
//     return Vehicle(
//       id: id ?? this.id,
//       vehicleName: vehicleName ?? this.vehicleName,
//     );
//   }
//
//   factory Vehicle.fromJson(Map<String, dynamic> json){
//     return Vehicle(
//       id: json["id"] ?? "",
//       vehicleName: json["vehicle_name"] ?? "",
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "vehicle_name": vehicleName,
//   };
//
// }
