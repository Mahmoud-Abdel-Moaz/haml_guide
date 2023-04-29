import 'dart:math';
import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/banner_custom_model.dart';
import 'package:haml_guide/models/weeks_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

class WeeksScreenProvidersApis extends ChangeNotifier {
  Random random = Random();
  int? weekNumberSelected;
  Key? weekBuilderKey;

  void refreshWeekKeyBuilder() {
    weekBuilderKey = ValueKey(random.nextInt(10000000).toString());
    notifyListeners();
  }

  void selectWeekNumber(int weekNumber) {
    weekNumberSelected = weekNumber;
    notifyListeners();
  }

  Future<WeeksModel?> getWeeksData({required BuildContext context}) async {
    WeeksModel? model;

    List<dynamic> data = await ApiRequests.getApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/weeks/?week_number=$weekNumberSelected",
      headers: {},
    );

    if (data[0].containsKey('id')) {
      model = WeeksModel.fromJson(data[0]);
       CommonComponents.saveData(
          key: ApiKeys.userWeekName, value: model.title);
    } else {
      if (context.mounted) {
        CommonComponents.getSnackBarWithServerError(context);
      } else {
        return null;
      }
    }

    return model;
  }

  Future<List<BannerCustomModel>?> getBunnerCustom(
      {required BuildContext context}) async {
    List<BannerCustomModel> bannersList = [];

    List<dynamic> dataList = await ApiRequests.getApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl:
          "api/v1/firstslider/?search=${context.read(ApiProviders.userLocationProviders).userCountry}",
      headers: {},
    );

    if (dataList != null) {
      for (var data in dataList) {
        bannersList.add(BannerCustomModel.fromJson(data));
      }
    } else {
      if (context.mounted) {
        CommonComponents.getSnackBarWithServerError(context);
      } else {
        return null;
      }
    }

    return bannersList;
  }
}
