import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/banner_custom_model.dart';
import 'package:haml_guide/models/moktatafat_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

class MoktatafatScreenProvidersApis extends ChangeNotifier {
  Future<List<MoktatafatModel>?> getAllMoktatafat(
      {required BuildContext context}) async {
    List<MoktatafatModel> moktatafatList = [];

    var dataList = await ApiRequests.getApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/FAQ",
      headers: {},
    );

    if (dataList[0].containsKey('id')) {
      for (var data in dataList) {
        moktatafatList.add(MoktatafatModel.fromJson(data));
      }
    } else {
      if (context.mounted) {
        CommonComponents.getSnackBarWithServerError(context);
      } else {
        return null;
      }
    }
    return moktatafatList;
  }

  Future<List<BannerCustomModel>> getBunnerCustom(
      {required BuildContext context}) async {
    List<BannerCustomModel> bannersList = [];

    List<dynamic> dataList = await ApiRequests.getApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl:
          "api/v1/secondslider/?search=${context.read(ApiProviders.userLocationProviders).userCountry}",
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
        return bannersList;
      }
    }

    return bannersList;
  }
}
