import 'package:flutter/material.dart';

class HamlAlarmModel {
  int? alarmID;
  String? alarmDateAndTime, title, description;

  HamlAlarmModel({
    this.alarmID,
    this.alarmDateAndTime,
    this.title,
    this.description,
  });

  HamlAlarmModel.fromJson(Map<String, dynamic> jsonData) {
    alarmID = jsonData['id'];
    alarmDateAndTime = jsonData['date'];
    title = jsonData['title'];
    description = jsonData['description'];
  }

  Map<String, dynamic> toJson({required int deviceID}) => {
        "title": title,
        "description": description,
        "date": alarmDateAndTime,
        "device": deviceID.toString()
      };
}
