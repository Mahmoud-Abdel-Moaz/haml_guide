import 'package:haml_guide/config/routes.dart';

class HamlForwardScreenWidgets {
  static List<Map<String, dynamic>> hamlForwardList = [
    {
      "image": "assets/images/rklat.png",
      "title": "ركلات الجنين",
      "destination": PATHS.mainRklatScreen,
    },
    {
      "image": "assets/images/weight.png",
      "title": "وزن الحامل",
      "destination": PATHS.mainWeightScreen,
    },
    {
      "image": "assets/images/pressure.png",
      "title": "قياس الضغط",
      "destination": PATHS.mainPressureScreen,
    },
    {
      "image": "assets/images/sugar.png",
      "title": "قياس السكر",
      "destination": PATHS.mainSugarScreen,
    },
    {
      "image": "assets/images/alarm.png",
      "title": "المنبه",
      "destination": PATHS.mainAlarmScreen,
    },
    {
      "image": "assets/images/notes.png",
      "title": "ملاحظات",
      "destination": PATHS.mainNotesScreen,
    },
  ];
}
