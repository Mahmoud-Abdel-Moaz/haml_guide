import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/network.dart';

class UserLocationProviders extends ChangeNotifier {
  String? userCountry;

  void setUserCountry(String? country) {
    userCountry = country;
    notifyListeners();
  }

  Future<void> getUserLocation() async {
  /*  LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      await Geolocator.getCurrentPosition().then(
        (value) async {
          await placemarkFromCoordinates(value.latitude, value.longitude);
        },
      ).catchError((error) {
        setUserCountry(null);
      });
    } else {
      await Geolocator.requestPermission();
    }*/
    Network n =  Network("http://ip-api.com/json");
    String locationSTR = (await n.getData());
    Map<String,dynamic> locationx = jsonDecode(locationSTR);
    return locationx["country"];
  }

  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    List<Placemark> address = await GeocodingPlatform.instance
        .placemarkFromCoordinates(latitude, longitude, localeIdentifier: "en");

    setUserCountry(address[0].country);
    return address;
  }
}
