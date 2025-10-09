import 'package:permission_handler/permission_handler.dart';

class GpsHelper {
  static Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }

    return false;
  }

  static String? extractRingtoneTitle(String uri) {
    final uriObj = Uri.parse(uri);
    return uriObj.queryParameters['title'] ?? "Unknown";
  }

}

enum DocumentFileType {
  lorryReceipt('lorry_receipt', documentType: "Lorry Receipt"),
  ewayBill('eway_bill', documentType: "Eway Bill"),
  materialInvoice('material_invoice', documentType: "Material Invoice"),
  proofOfDelivery('proof_of_delivery', documentType: "Proof of Delivery"),
  uploadOtherDocument('other_documents', documentType: "Other Documents"),
  damageAndShortage(
    'damages_and_shortages',
    documentType: "Damages and Shortages",
  ),
  aadharDocument('aadhaar_card', documentType: 'Aadhaar Card'),
  panDocument('pan_card', documentType: 'PAN Card'),
  tanDocument('tan_document', documentType: 'Tan Document'),
  gstinDocument('gst_document', documentType: 'GST Document'),
  tdsDocument('tds', documentType: 'TDS'),
  chequeDocument('cancelled_cheque', documentType: 'Cancelled Cheque'),
  licenseDocument('driving_licence', documentType: 'Driving Licence');

  final String value;
  final String? documentType;

  const DocumentFileType(this.value, {this.documentType});
}