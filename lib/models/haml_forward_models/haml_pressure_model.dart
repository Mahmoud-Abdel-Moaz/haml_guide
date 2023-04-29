import 'package:flutter/material.dart';

class HamlPressureModel {
  int? pressureID, pressureUp, pressureDown;
  String? pressureDate, description;

  HamlPressureModel({
    this.pressureID,
    this.pressureUp,
    this.pressureDown,
    this.pressureDate,
    this.description,
  });

  HamlPressureModel.fromJson(Map<String, dynamic> jsonData) {
    pressureID = jsonData['id'];
    pressureUp = jsonData['up'];
    pressureDown = jsonData['down'];
    pressureDate = jsonData['measure_date'];
    description = jsonData['description'];
  }

  Map<String, dynamic> toJson({required int deviceID}) => {
        "up": pressureUp.toString(),
        "down": pressureDown.toString(),
        "measure_date": pressureDate,
        "device": deviceID.toString(),
      };
}
