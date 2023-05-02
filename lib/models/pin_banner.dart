class PinBanner {
  PinBanner({
      this.id, 
      this.createdAt, 
      this.updatedAt, 
      this.image, 
      this.url, 
      this.buttonText, 
      this.text, 
      this.phoneType, 
      this.status, 
      this.country, 
      this.week,});

  PinBanner.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    url = json['url'];
    buttonText = json['button_text'];
    text = json['text'];
    phoneType = json['phone_type'];
    status = json['status'];
    country = json['country'];
    week = json['week'];
  }
  int? id;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? url;
  String? buttonText;
  String? text;
  String? phoneType;
  String? status;
  String? country;
  int? week;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['image'] = image;
    map['url'] = url;
    map['button_text'] = buttonText;
    map['text'] = text;
    map['phone_type'] = phoneType;
    map['status'] = status;
    map['country'] = country;
    map['week'] = week;
    return map;
  }

}