import 'package:flutter/material.dart';
import 'package:haml_guide/config/enums.dart';

class BabyNamesProviders extends ChangeNotifier {
  UserSelectedBabyNames? userSelectedBabyNames;

  void babyNamesIsSelected(UserSelectedBabyNames babyNamesSelected) {
    userSelectedBabyNames = babyNamesSelected;
    notifyListeners();
  }
}
