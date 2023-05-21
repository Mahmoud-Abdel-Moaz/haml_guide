import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_weight_model.dart';

class HamlWeigtScreenProvidersApis extends ChangeNotifier {
  String? startDate;

  void setStartDate(String date) {
    startDate = date;
    notifyListeners();
  }

  Future<List<HamlWeightModel>?> getAllHamlWeights(
      {required BuildContext context}) async {
    List<HamlWeightModel> hamlWeightsList = [];

    int? deviceId =  CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);
if(deviceId == null){
  return [];
}
    if (context.mounted) {
      List<dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/weights/?device=$deviceId&device__device_id=",
        headers: {},
      );

      if (dataList != null) {
        for (var data in dataList) {
          hamlWeightsList.add(HamlWeightModel.fromJson(data));
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
    return hamlWeightsList;
  }

  Future<void> setUserWeight({
    required BuildContext context,
    required String weightNow,
    required String weightBefore,
  }) async {
    HamlWeightModel model =
        HamlWeightModel(weightNow: weightNow, startDate: startDate);

    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/weights/",
        headers: {},
        body: model.toJson(deviceID: deviceID, weightBefore: weightBefore),
      );

      if (data != null) {
        if (context.mounted) {
          CommonComponents.showCustomizedSnackBar(
              context: context, title: "تم إضافة وزنك بنجاح");
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, PATHS.mainWeightScreen);
        }
      } else {
        if (context.mounted) {
          CommonComponents.getSnackBarWithServerError(context);
        } else {
          return;
        }
      }
    }
  }

  Future<void> deleteWeightItem(
      {required BuildContext context, required int weightID}) async {
    Map<String, dynamic> data = await ApiRequests.deleteApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/weights/$weightID/",
      headers: {},
      body: {},
    );

    if (data == null) {
      if (context.mounted) {
        CommonComponents.showCustomizedSnackBar(
            context: context, title: "تم الحذف بنجاح");
        Navigator.pushReplacementNamed(context, PATHS.mainWeightScreen);
      } else {
        return;
      }
    }
  }
}
