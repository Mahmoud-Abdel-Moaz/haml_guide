import 'package:flutter/material.dart';

class HamlKicksModel {
  int?  kickID;
  String? kickCount, startDateAndTime, endDateAndTime, description;

  HamlKicksModel({
    this.kickID,
    this.kickCount,
    this.startDateAndTime,
    this.endDateAndTime,
    this.description,
  });

  HamlKicksModel.fromJson(Map<String, dynamic> jsonData) {
    kickID = jsonData['id'];
    kickCount = jsonData['count'].toString();
    startDateAndTime = jsonData['start'];
    endDateAndTime = jsonData['end'];
    description = jsonData['description'];
  }

  Map<String, dynamic> toJson({required int deviceID}) => {
        "count": kickCount,
        "start": startDateAndTime,
        "end": endDateAndTime,
        "device": deviceID.toString(),
      };
}
