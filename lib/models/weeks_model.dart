class WeeksModel {
  String? title, section1, section2, section3;

  WeeksModel({this.title, this.section1, this.section2, this.section3});

  WeeksModel.fromJson(Map<String, dynamic> jsonData) {
    title = jsonData['title'];
    section1 = jsonData['section1'];
    section2 = jsonData['section2'];
    section3 = jsonData['section3'];
  }
}
