import 'package:flutter/material.dart';
import 'package:haml_guide/screens/main_screens/baby_name_screen.dart';
import 'package:haml_guide/screens/main_screens/calculation_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forward_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_screen.dart';
import 'package:haml_guide/screens/main_screens/moktatafat_screen.dart';
import 'package:haml_guide/screens/main_screens/weeks_screen.dart';

class MainScreenProviders extends ChangeNotifier {
  int tabIndexSelected = 2;

  List<Map<String, dynamic>> bottomBarList = [
    {
      "image": "assets/images/bottom_bar/mwlod_name.png",
      "title": "اسم المولود",
      "selected": false,
      "page": const BabyNameScreen()
    },
    {
      "image": "assets/images/bottom_bar/weeks.png",
      "title": "أسابيع",
      "selected": false,
      "page": const WeeksScreen()
    },
    {
      "image": "assets/images/bottom_bar/haml.png",
      "title": "الحمل",
      "selected": true,
      "page": const HamlScreen()
    },
    {
      "image": "assets/images/bottom_bar/moktafat.png",
      "title": "مقتطفات",
      "selected": false,
      "page": const MoktatfatScreen()
    },
    {
      "image": "assets/images/bottom_bar/forward_haml.png",
      "title": "متابعة الحمل",
      "selected": false,
      "page": const HamlForwardScreen()
    },
  ];

  void tabIsSelected(int tabIndex) {
    for (int i = 0; i < bottomBarList.length; i++) {
      bottomBarList[i]['selected'] = false;
    }
    bottomBarList[tabIndex]['selected'] = true;
    tabIndexSelected = tabIndex;
    notifyListeners();
  }

  void setIfUserIsCalucaltedHaml(bool userIsCalculated) {
    bottomBarList[2]['page'] =
        userIsCalculated ? const CalculationScreen() : const HamlScreen();

    notifyListeners();
  }

  void drawerIsSelected(
      {required BuildContext context, required int tabIndex}) {
    Navigator.pop(context);
    tabIsSelected(tabIndex);
    tabIndexSelected = tabIndex;
    notifyListeners();
  }
}
