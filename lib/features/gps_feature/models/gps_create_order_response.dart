class CreateOrderResponse {
  bool? success;
  String? message;
  Data? data;
  int? statusCode;

  CreateOrderResponse({this.success, this.message, this.data, this.statusCode});

  CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class Data {
  String? id;
  String? customerId;
  int? customerSeriesId;
  String? vendorId;
  String? customerName;
  String? customerMembershipId;
  String? customerEmail;
  String? customerMobileNumber;
  String? orderDate;
  bool? isActive;
  String? orderAmount;
  String? personInCharge;
  String? shippingContactNumber;
  String? createdByUserId;
  String? billType;
  dynamic dueDate;
  String? orderUniqueId;
  bool? isNeedApproval;
  bool? isNeedHoApprove;
  String? orderSource;
  String? orderStatusId;
  String? createdBy;
  dynamic? createdByEmpName;
  String? orderReferencedBy;
  dynamic? isNodalOrder;
  dynamic? paymentUid;
  String? updatedAt;
  String? createdAt;
  dynamic? createdByArea;
  dynamic? invoiceUrlPath;
  dynamic? invoiceNumber;
  dynamic? invoiceGenDate;
  dynamic? deletedAt;

  Data(
      {this.id,
        this.customerId,
        this.customerSeriesId,
        this.vendorId,
        this.customerName,
        this.customerMembershipId,
        this.customerEmail,
        this.customerMobileNumber,
        this.orderDate,
        this.isActive,
        this.orderAmount,
        this.personInCharge,
        this.shippingContactNumber,
        this.createdByUserId,
        this.billType,
        this.dueDate,
        this.orderUniqueId,
        this.isNeedApproval,
        this.isNeedHoApprove,
        this.orderSource,
        this.orderStatusId,
        this.createdBy,
        this.createdByEmpName,
        this.orderReferencedBy,
        this.isNodalOrder,
        this.paymentUid,
        this.updatedAt,
        this.createdAt,
        this.createdByArea,
        this.invoiceUrlPath,
        this.invoiceNumber,
        this.invoiceGenDate,
        this.deletedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    customerSeriesId = json['customer_series_id'];
    vendorId = json['vendor_id'];
    customerName = json['customer_name'];
    customerMembershipId = json['customer_membership_id'];
    customerEmail = json['customer_email'];
    customerMobileNumber = json['customer_mobile_number'];
    orderDate = json['order_date'];
    isActive = json['is_active'];
    orderAmount = json['order_amount'];
    personInCharge = json['person_in_charge'];
    shippingContactNumber = json['shipping_contact_number'];
    createdByUserId = json['created_by_user_id'];
    billType = json['bill_type'];
    dueDate = json['due_date'];
    orderUniqueId = json['order_unique_id'];
    isNeedApproval = json['is_need_approval'];
    isNeedHoApprove = json['is_need_ho_approve'];
    orderSource = json['order_source'];
    orderStatusId = json['order_status_id'];
    createdBy = json['created_by'];
    createdByEmpName = json['created_by_emp_name'];
    orderReferencedBy = json['order_referenced_by'];
    isNodalOrder = json['isNodalOrder'];
    paymentUid = json['payment_uid'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    createdByArea = json['created_by_area'];
    invoiceUrlPath = json['invoice_url_path'];
    invoiceNumber = json['invoice_number'];
    invoiceGenDate = json['invoice_gen_date'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['customer_series_id'] = this.customerSeriesId;
    data['vendor_id'] = this.vendorId;
    data['customer_name'] = this.customerName;
    data['customer_membership_id'] = this.customerMembershipId;
    data['customer_email'] = this.customerEmail;
    data['customer_mobile_number'] = this.customerMobileNumber;
    data['order_date'] = this.orderDate;
    data['is_active'] = this.isActive;
    data['order_amount'] = this.orderAmount;
    data['person_in_charge'] = this.personInCharge;
    data['shipping_contact_number'] = this.shippingContactNumber;
    data['created_by_user_id'] = this.createdByUserId;
    data['bill_type'] = this.billType;
    data['due_date'] = this.dueDate;
    data['order_unique_id'] = this.orderUniqueId;
    data['is_need_approval'] = this.isNeedApproval;
    data['is_need_ho_approve'] = this.isNeedHoApprove;
    data['order_source'] = this.orderSource;
    data['order_status_id'] = this.orderStatusId;
    data['created_by'] = this.createdBy;
    data['created_by_emp_name'] = this.createdByEmpName;
    data['order_referenced_by'] = this.orderReferencedBy;
    data['isNodalOrder'] = this.isNodalOrder;
    data['payment_uid'] = this.paymentUid;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['created_by_area'] = this.createdByArea;
    data['invoice_url_path'] = this.invoiceUrlPath;
    data['invoice_number'] = this.invoiceNumber;
    data['invoice_gen_date'] = this.invoiceGenDate;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
