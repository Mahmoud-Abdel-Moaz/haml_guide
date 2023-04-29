import 'package:flutter/material.dart';
import 'package:haml_guide/models/moktatafat_model.dart';

class MoktatafatScreenProviders extends ChangeNotifier {
  void showRightContent({
    required int moktatafatIndex,
    required List<MoktatafatModel> moktatafatList,
  }) {
    moktatafatList[moktatafatIndex].visibility =
        !(moktatafatList[moktatafatIndex].visibility??false);

    notifyListeners();
  }
}
