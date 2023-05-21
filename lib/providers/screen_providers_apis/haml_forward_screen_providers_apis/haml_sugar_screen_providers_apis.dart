import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_sugar_model.dart';

class HamlSugarScreenProvidersApis extends ChangeNotifier {
  String? sugarDate;
  void setSugarDate(String date) {
    sugarDate = date;
    notifyListeners();
  }

  Future<List<HamlSugarModel>?> getAllHamlSugar(
      {required BuildContext context}) async {
    List<HamlSugarModel> hamlSugarList = [];

    int? deviceID =  CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);
if(deviceID==null){
  return [];
}
    if (context.mounted) {
      List<dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/diabetes/?device=$deviceID&device__device_id=",
        headers: {},
      );

      if (dataList != null) {
        for (var data in dataList) {
          hamlSugarList.add(HamlSugarModel.fromJson(data));
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
    return hamlSugarList;
  }

  Future<void> setUserSugar({
    required BuildContext context,
    required String sugarNumber,
  }) async {
    HamlSugarModel model = HamlSugarModel(
      sugarNumber: int.parse(sugarNumber),
      sugarDate: sugarDate,
    );
    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/diabetes/",
        headers: {},
        body: model.toJson(deviceID: deviceID),
      );

      if (data != null) {
        if (context.mounted) {
          CommonComponents.showCustomizedSnackBar(
              context: context, title: "تم إضافة قياس السكر بنجاج");
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, PATHS.mainSugarScreen);
        } else {
          return;
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

  Future<void> deleteSugarItem(
      {required BuildContext context, required int sugarID}) async {
    Map<String, dynamic> data = await ApiRequests.deleteApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/diabetes/$sugarID/",
      headers: {},
      body: {},
    );

    if (data == null) {
      if (context.mounted) {
        CommonComponents.showCustomizedSnackBar(
            context: context, title: "تم الحذف بنجاح");
        Navigator.pushReplacementNamed(context, PATHS.mainSugarScreen);
      } else {
        return;
      }
    }
  }
}
