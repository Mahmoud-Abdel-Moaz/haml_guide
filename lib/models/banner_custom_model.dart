class BannerCustomModel {
  String? image, country, url;

  BannerCustomModel({this.image, this.country, this.url});

  BannerCustomModel.fromJson(Map<String, dynamic> jsonData) {
    image = jsonData['image'];
    country = jsonData['country'];
    url = jsonData['url'];
  }
}
