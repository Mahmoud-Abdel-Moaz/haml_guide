class HamlScreenModel {
  String? deviceID, miladyDate, hijariDate,country,deviceType,status;

  HamlScreenModel({this.deviceID, this.miladyDate, this.hijariDate,this.country,this.status,this.deviceType});

  Map<String, dynamic> toJsonWithPost(String fcmToken) => {
        "device_id": deviceID,
        "period_date_crist": miladyDate,
        "period_date_islamic": hijariDate,
        "fcm_token": fcmToken,
    'phone_type':deviceType,
    'country':country
      };

  Map<String, dynamic> toJsonWithUpdate(String fcmToken) => {
        "device_id": deviceID,
        "period_date_crist": miladyDate,
        "period_date_islamic": hijariDate,
        "fcm_token": fcmToken,
    'phone_type':deviceType,
    'country':country,
      };
}
