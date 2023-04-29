import 'package:flutter/material.dart';

class HamlSugarModel {
  int? sugarID, sugarNumber;
  String? sugarDate, description;

  HamlSugarModel(
      {this.sugarID, this.sugarNumber, this.sugarDate, this.description});

  HamlSugarModel.fromJson(Map<String, dynamic> jsonData) {
    sugarID = jsonData['id'];
    sugarNumber = jsonData['measure'];
    sugarDate = jsonData['measure_date'];
    description = jsonData['description'];
  }

  Map<String, dynamic> toJson({required int deviceID}) => {
        "measure": sugarNumber.toString(),
        "measure_date": sugarDate,
        "device": deviceID.toString(),
      };
}
