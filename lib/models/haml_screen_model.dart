class HamlScreenModel {
  String? deviceID, miladyDate, hijariDate;

  HamlScreenModel({this.deviceID, this.miladyDate, this.hijariDate});

  Map<String, dynamic> toJsonWithPost(String fcmToken) => {
        "device_id": deviceID,
        "period_date_crist": miladyDate,
        "period_date_islamic": hijariDate,
        "fcm_token": fcmToken,
      };

  Map<String, dynamic> toJsonWithUpdate(String fcmToken) => {
        "device_id": deviceID,
        "period_date_crist": miladyDate,
        "period_date_islamic": hijariDate,
        "fcm_token": fcmToken,
      };
}
