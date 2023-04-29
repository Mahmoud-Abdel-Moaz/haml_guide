import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_pressure_model.dart';

class HamlPressureScreenProvidersApis extends ChangeNotifier {
  String? pressureDate;

  void setPressureDate(String date) {
    pressureDate = date;
    notifyListeners();
  }

  Future<List<HamlPressureModel>?> getAllHamlPressure(
      {required BuildContext context}) async {
    List<HamlPressureModel> hamlPressureList = [];

    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      List<dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/pressure/?device=$deviceID&device__device_id=",
        headers: {},
      );

      if (dataList != null) {
        for (var data in dataList) {
          hamlPressureList.add(HamlPressureModel.fromJson(data));
        }
      } else {
        if (context.mounted) {
          CommonComponents.getSnackBarWithServerError(context);
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
    return hamlPressureList;
  }

  Future<void> setUserPressure({
    required BuildContext context,
    required String pressureUp,
    required String pressureDown,
  }) async {
    HamlPressureModel model = HamlPressureModel(
      pressureUp: int.parse(pressureUp),
      pressureDown: int.parse(pressureDown),
      pressureDate: pressureDate,
    );

    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/pressure/",
        headers: {},
        body: model.toJson(deviceID: deviceID),
      );

      if (data != null) {
        if (context.mounted) {
          CommonComponents.showCustomizedSnackBar(
              context: context, title: "تم إضافة ضغطك بنجاح");
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, PATHS.mainPressureScreen);
        }
      } else {
        if (context.mounted) {
          CommonComponents.getSnackBarWithServerError(context);
        } else {
          return;
        }
      }
    } else {
      return;
    }
  }

  Future<void> deletePressureItem(
      {required BuildContext context, required int pressureID}) async {
    Map<String, dynamic> data = await ApiRequests.deleteApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/pressure/$pressureID/",
      headers: {},
      body: {},
    );

    if (data == null) {
      if (context.mounted) {
        CommonComponents.showCustomizedSnackBar(
            context: context, title: "تم الحذف بنجاح");
        Navigator.pushReplacementNamed(context, PATHS.mainPressureScreen);
      } else {
        return;
      }
    }
  }
}
