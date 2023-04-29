import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_kicks_model.dart';

class KicksScreenProvidersApis extends ChangeNotifier {
  String? startDate, endDate;

  void setStartDate(String date) {
    startDate = date;
    notifyListeners();
  }

  void setEndDate(String date) {
    endDate = date;
    notifyListeners();
  }

  Future<List<HamlKicksModel>?> getAllKicks(
      {required BuildContext context}) async {
    List<HamlKicksModel> kicksList = [];

    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      List<dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/kicks/?device__device_id=&device=$deviceID",
        headers: {},
      );

      if (dataList != null) {
        for (var data in dataList) {
          kicksList.add(HamlKicksModel.fromJson(data));
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

    return kicksList;
  }

  Future<void> userAddKicks(
      {required BuildContext context, required String kicksCount}) async {
    HamlKicksModel model = HamlKicksModel(
      kickCount: kicksCount,
      startDateAndTime: startDate,
      endDateAndTime: endDate,
    );

    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/kicks/",
        headers: {},
        body: model.toJson(deviceID: deviceID),
      );

      if (data != null) {
        if (context.mounted) {
          CommonComponents.showCustomizedSnackBar(
              context: context, title: "تم إضافة الركلات بنجاح");
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, PATHS.mainRklatScreen);
        } else {
          return;
        }
      } else {
        if (context.mounted) {
          CommonComponents.getSnackBarWithServerError(context);
        }
      }
    } else {
      return;
    }
  }

  Future<void> deleteRklatItem(
      {required BuildContext context, required int rklatID}) async {
    Map<String, dynamic> data = await ApiRequests.deleteApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/kicks/$rklatID/",
      headers: {},
      body: {},
    );

    if (data == null) {
      if (context.mounted) {
        CommonComponents.showCustomizedSnackBar(
            context: context, title: "تم الحذف بنجاح");
        Navigator.pushReplacementNamed(context, PATHS.mainRklatScreen);
      } else {
        return;
      }
    }
  }
}
