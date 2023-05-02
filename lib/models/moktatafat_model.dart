import 'moctatafat_image.dart';

class MoktatafatModel {
  String? headerOne, bodyOne, headerTwo, bodyTwo;
  bool? visibility;
  List<MoctatafatImage>? moktatafatImages;

  MoktatafatModel({
    this.headerOne,
    this.bodyOne,
    this.headerTwo,
    this.bodyTwo,
    this.visibility,
    this.moktatafatImages,
  });

  MoktatafatModel.fromJson(Map<String, dynamic> jsonData) {
    headerOne = jsonData['header1'];
    bodyOne = jsonData['body1'];
    headerTwo = jsonData['header2'];
    bodyTwo = jsonData['body2'];
    visibility = false;
    moktatafatImages= jsonData['images']!= null
        ? (jsonData['images'] as List)
        .map((i) => MoctatafatImage.fromJson(i))
        .toList()
        : [];
  }
}
