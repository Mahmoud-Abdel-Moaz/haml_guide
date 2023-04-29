import 'package:flutter/material.dart';

class NamesModel {
  int? nameID;
  String? name, nameInfo;
  bool? isFavourite;

  NamesModel({this.nameID, this.name, this.nameInfo, this.isFavourite});

  NamesModel.fromjson(
      {required Map<String, dynamic> jsonData, required bool isFav}) {
    nameID = jsonData['id'];
    name = jsonData['name'];
    nameInfo = jsonData['description'];
    isFavourite = isFav;
  }
}
