class UserInfoModel {
  String? userName, userEmail, userPhone, userCountry, deviceID;

  UserInfoModel({
    this.userName,
    this.userEmail,
    this.userPhone,
    this.userCountry,
    this.deviceID,
  });

  Map<String, dynamic> tojson() => {
        "name": userName,
        "phone_number": userPhone,
        "email": userEmail,
        "country": userCountry,
        "device_id": deviceID,
      };
}
