import 'package:flutter/material.dart';

class HamlNoteModel {
  int? noteID;
  String? title, description, date;

  HamlNoteModel({this.noteID, this.title, this.description, this.date});

  HamlNoteModel.fromJson(Map<String, dynamic> jsonData) {
    noteID = jsonData['id'];
    title = jsonData['title'];
    description = jsonData['description'];
    date = jsonData['created_at'];
  }

  Map<String, dynamic> toJson({required int deviceID}) => {
        "title": title,
        "description": description,
        "device": deviceID.toString(),
      };
}
