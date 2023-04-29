class MoktatafatModel {
  String? headerOne, bodyOne, headerTwo, bodyTwo;
  bool? visibility;

  MoktatafatModel({
    this.headerOne,
    this.bodyOne,
    this.headerTwo,
    this.bodyTwo,
    this.visibility,
  });

  MoktatafatModel.fromJson(Map<String, dynamic> jsonData) {
    headerOne = jsonData['header1'];
    bodyOne = jsonData['body1'];
    headerTwo = jsonData['header2'];
    bodyTwo = jsonData['body2'];
    visibility = false;
  }
}
