import 'package:flutter/material.dart';

class HamlWeightModel {
  int? weightID;
  String? weekName, startDate, weightNow, weightBefore, description;

  HamlWeightModel({
    this.weightID,
    this.weekName,
    this.startDate,
    this.weightNow,
    this.weightBefore,
    this.description,
  });

  HamlWeightModel.fromJson(Map<String, dynamic> jsonData) {
    weightID = jsonData['id'];
    weekName = jsonData['week']['title'] ?? "";
    startDate = jsonData['created_at'] ?? "";
    weightNow = jsonData['measure_now'] ?? "";
    weightBefore = jsonData['measure_before'] ?? "";
    description = jsonData['description'] ?? "";
  }

  Map<String, dynamic> toJson(
          {required int deviceID, required String weightBefore}) =>
      {
        "measure_before": weightBefore,
        "measure_now": weightNow,
        "measure_date": startDate,
        "device": deviceID.toString(),
      };
}
