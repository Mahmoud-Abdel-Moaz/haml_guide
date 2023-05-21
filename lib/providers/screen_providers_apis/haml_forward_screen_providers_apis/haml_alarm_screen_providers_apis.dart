import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_alarm_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../config/local_notification_service.dart';

class HamlAlarmScreenProviders extends ChangeNotifier {
  String? timeForuser, dateForUser, dateTimeForUserNow, timeForuserIn24Hours;
  void setDateAndTimeToIso(String dateAndTimeIso) {
    dateTimeForUserNow = dateAndTimeIso;
    notifyListeners();
  }

  void setTimeForUserIn24Hours(String time) {
    timeForuserIn24Hours = time;
    notifyListeners();
  }

  void setTimeForUser(String time) {
    timeForuser = time;
    notifyListeners();
  }

  void setDateForUser(String date) {
    dateForUser = date;
    notifyListeners();
  }

  Future<List<HamlAlarmModel>?> getAllHamlAlarms(
      {required BuildContext context}) async {
    List<HamlAlarmModel> hamlAlarmsList = [];

    int? deviceID =  CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);
if(deviceID==null){
  return [];
}
    if (context.mounted) {
      List<dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/Alarms/?device=$deviceID&device__device_id=",
        headers: {},
      );

      if (dataList != null) {
        for (var data in dataList) {
          hamlAlarmsList.add(HamlAlarmModel.fromJson(data));
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
    if (context.mounted) {
      context
          .read(ApiProviders.notificationHandler)
          .resetAlarmNotificationList();
    } else {
      return null;
    }
    for (int i = 0; i < hamlAlarmsList.length; i++) {

      if (context.mounted) {
        DateTime? alarmTime=DateTime.tryParse((hamlAlarmsList[i].alarmDateAndTime??''));
        if(alarmTime!=null&&alarmTime.isAfter(DateTime.now())){
          context.read(ApiProviders.notificationHandler)
              .setAlarmNotificationList(
            description: (hamlAlarmsList[i].description ?? ''),
            dateTimeIso: (hamlAlarmsList[i].alarmDateAndTime ?? ''),
          );
          context.read(ApiProviders.notificationHandler).showAlarmNotification(
            description: (hamlAlarmsList[i].description ?? ''),
            dateTime: DateTime.parse(
                (hamlAlarmsList[i].alarmDateAndTime ?? '')),
            notificationIDS:(hamlAlarmsList[i].alarmID??43)+ 42,
          );
        }
      } else {
        return null;
      }
    }

    return hamlAlarmsList;
  }

  Future<void> setUserAlarm({
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    HamlAlarmModel model = HamlAlarmModel(
      alarmDateAndTime: dateTimeForUserNow,
      description: description,
      title: title,
    );

    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/Alarms/",
        headers: {},
        body: model.toJson(deviceID: deviceID),
      );

      if (data != null) {
        if (context.mounted) {
          CommonComponents.showCustomizedSnackBar(
              context: context, title: "تم إضافة التنبية بنجاح");
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, PATHS.mainAlarmScreen);
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

  Future<void> deleteAlarmItem(
      {required BuildContext context, required int alarmID}) async {
    Map<String, dynamic> data = await ApiRequests.deleteApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/Alarms/$alarmID/",
      headers: {},
      body: {},
    );

    if (data == null) {
      if (context.mounted) {
        LocalNotificationService.cancelNotificationById(alarmID+42);
        CommonComponents.showCustomizedSnackBar(
            context: context, title: "تم الحذف بنجاح");
        Navigator.pushReplacementNamed(context, PATHS.mainAlarmScreen);
      } else {
        return;
      }
    }
  }
}
