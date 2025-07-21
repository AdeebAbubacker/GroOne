import 'package:realm/realm.dart';

import 'gps_mobile_config_model.dart';

part 'gps_mobile_config_realm_model.realm.dart';

@RealmModel()
class _GpsMobileConfigRealmModel {
  @PrimaryKey()
  late ObjectId id;

  String? faqUrl;
  String? whiteLabelUrl;
  bool? reportActive;
  bool? subscriptionActive;
  String? freshChatId;
  String? freshChatKey;
  String? supportEmail;
  String? supportMobile;
  String? supportWebsiteUrl;
  String? supportWhatsapp;
  late DateTime createdAt;
}

extension GpsMobileConfigRealmModelMapper on GpsMobileConfigRealmModel {
  GpsMobileConfigData toDomain() => GpsMobileConfigData(
    faqUrl: faqUrl,
    whiteLabelUrl: whiteLabelUrl,
    report: reportActive != null ? GpsReport(active: reportActive) : null,
    subscription:
        subscriptionActive != null
            ? GpsSubscription(active: subscriptionActive)
            : null,
    freshChat:
        (freshChatId != null ||
                freshChatKey != null ||
                supportEmail != null ||
                supportMobile != null ||
                supportWebsiteUrl != null ||
                supportWhatsapp != null)
            ? GpsFreshChat(
              freshChatDetails: GpsFreshChatDetails(
                id: freshChatId,
                key: freshChatKey,
              ),
              supportDetails: GpsSupportDetails(
                email: supportEmail != null ? [supportEmail!] : null,
                mobile: supportMobile != null ? [supportMobile!] : null,
                websiteUrl: supportWebsiteUrl,
                whatsapp: supportWhatsapp,
              ),
            )
            : null,
  );

  static GpsMobileConfigRealmModel fromDomain(GpsMobileConfigData data) {
    final obj = GpsMobileConfigRealmModel(
      ObjectId(),
      faqUrl: data.faqUrl,
      whiteLabelUrl: data.whiteLabelUrl,
      reportActive: data.report?.active,
      subscriptionActive: data.subscription?.active,
      freshChatId: data.freshChat?.freshChatDetails?.id,
      freshChatKey: data.freshChat?.freshChatDetails?.key,
      supportEmail:
          data.freshChat?.supportDetails?.email?.isNotEmpty == true
              ? data.freshChat?.supportDetails?.email?.first
              : null,
      supportMobile:
          data.freshChat?.supportDetails?.mobile?.isNotEmpty == true
              ? data.freshChat?.supportDetails?.mobile?.first
              : null,
      supportWebsiteUrl: data.freshChat?.supportDetails?.websiteUrl,
      supportWhatsapp: data.freshChat?.supportDetails?.whatsapp,
      DateTime.now(),
    );
    return obj;
  }
}
