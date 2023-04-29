import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/models/haml_calculation_model.dart';
import 'package:haml_guide/models/haml_screen_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

class HamlScreenProvidersApis extends ChangeNotifier {
  // int deviceIDFromDataBase;

  // void setDeviceIDFromDataBase(int id) {
  //   deviceIDFromDataBase = id;
  //   notifyListeners();
  // }

  Future<void> getDeviceData({
    required BuildContext context,
    required String? miladyDate,
    required String? hijariDate,
    required String fcmToken,
  }) async {
    String deviceID =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

    if (context.mounted) {
      List<dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices?device_id=$deviceID",
        headers: {},
      );
      bool deviceIdIsFoundInDataBase = false;

      if (dataList != null) {
        if (dataList.isNotEmpty) {
          for (int i = 0; i < dataList.length; i++) {
            if (dataList[i]['device_id'] == deviceID) {
              deviceIdIsFoundInDataBase = true;
               CommonComponents.saveData(
                key: ApiKeys.deviceIdFromApi,
                value: dataList[i]['id'],
              );

              // setDeviceIDFromDataBase(dataList[i]['id']);
              // print(deviceIDFromDataBase);
               CommonComponents.saveData(
                key: ApiKeys.userWeekNumber,
                value: dataList[i]['get_now']['now_weeks'],
              );

              if (context.mounted) {
                await updateUserDate(
                  context: context,
                  miladyDate: miladyDate??'',
                  hijariDate: hijariDate??'',
                  fcmToken: fcmToken,
                );
                if (context.mounted) {
                  context
                      .read(InitScreenProviders.mainScreenProviders)
                      .setIfUserIsCalucaltedHaml(true);
                  return;
                } else {
                  return;
                }
              } else {
                return;
              }
            } else {}
          }
          if (!deviceIdIsFoundInDataBase) {
            if (context.mounted) {
              await setUserDate(
                context: context,
                miladyDate: miladyDate,
                hijariDate: hijariDate,
                fcmToken: fcmToken,
              );
            } else {
              return;
            }
          }
        } else {
          if (context.mounted) {
            await setUserDate(
              context: context,
              miladyDate: miladyDate,
              hijariDate: hijariDate,
              fcmToken: fcmToken,
            );
          } else {
            return;
          }
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

  Future<void> setUserDate({
    required BuildContext context,
    required String? miladyDate,
    required String? hijariDate,
    required String fcmToken,
  }) async {
    String deviceID =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

    HamlScreenModel model = HamlScreenModel(
        deviceID: deviceID, hijariDate: hijariDate, miladyDate: miladyDate);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices/",
        headers: {"Content-Type": "application/json"},
        body: json.encode(model.toJsonWithPost(fcmToken)),
      );

      if (data != null&& data['id']!=null) {
        log('deviceIdFromApi data ${data['period_date_islamic']}');
        print('deviceIdFromApi ${ApiKeys.deviceIdFromApi} ${data['id']}');
         CommonComponents.saveData(
            key: ApiKeys.deviceIdFromApi, value: data['id']);

         CommonComponents.saveData(
          key: ApiKeys.userWeekNumber,
          value: data['get_now']['now_weeks'],
        );

        if (context.mounted) {
          context
              .read(InitScreenProviders.mainScreenProviders)
              .setIfUserIsCalucaltedHaml(true);
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
    }
  }

  Future<void> updateUserDate({
    required BuildContext context,
    required String? miladyDate,
    required String? hijariDate,
    required String fcmToken,
  }) async {
    int deviceIDFromApi =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    String deviceIDFromUser =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

    HamlScreenModel model = HamlScreenModel(
      hijariDate: hijariDate,
      miladyDate: miladyDate,
      deviceID: deviceIDFromUser,
    );

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.patchApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices/$deviceIDFromApi/",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "device_id $deviceIDFromUser",
        },
        body: json.encode(model.toJsonWithUpdate(fcmToken)),
      );
      CommonComponents.saveData(
          key: ApiKeys.hamlCalc, value: jsonEncode(data));

      if (data.containsKey('id')) {
         CommonComponents.saveData(
          key: ApiKeys.userWeekNumber,
          value: data['get_now']['now_weeks'],
        );

        if (context.mounted) {
          context
              .read(InitScreenProviders.mainScreenProviders)
              .setIfUserIsCalucaltedHaml(true);
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

  Future<HamlCalculationModel?> getUserHamlCalculation(
      {required BuildContext context, required String deviceID, bool getCash=false}) async {
    String? res=  CommonComponents.getSavedData(
      ApiKeys.hamlCalc,
    );
    HamlCalculationModel? model;
    Map<String,dynamic>? data;
    if(getCash&&res==null){
      return null;
    }
    if(res!=null&&getCash){
      log('data HamlCalculatio $res');
      data =jsonDecode(res!);
    }else{
      List<dynamic> d = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices/?device_id=$deviceID",
        headers: {},
      );
      print('data $d');
      if((d==null||d.isEmpty)&&res!=null)  {
        data=jsonDecode(res!);
      }else{
        data=d[0];

      }
      if(data!=null) {
        CommonComponents.saveData(
            key: ApiKeys.hamlCalc, value: jsonEncode(data));
      }
    }


    if (data != null) {
      CommonComponents.saveData(
        key: ApiKeys.userWeekNumber,
        value: data['get_now']['now_weeks'],
      );
      print('getUserHamlCalculation $data');
      if (data.containsKey('id')) {
         CommonComponents.saveData(
          key: ApiKeys.deviceIdFromApi,
          value: data['id'],
        );

         CommonComponents.saveData(
          key: ApiKeys.userWeekNumber,
          value: data['get_now']['now_weeks'],
        );

        model = HamlCalculationModel.fromJson(data);
        if (context.mounted) {
          context
              .read(InitScreenProviders.mainScreenProviders)
              .setIfUserIsCalucaltedHaml(true);
        } else {
          return null;
        }
      } else {
        if (context.mounted) {
          CommonComponents.getSnackBarWithServerError(context);
        } else {
          return null;
        }
      }
    } else {
      if (context.mounted) {
        CommonComponents.getSnackBarWithServerError(context);
      } else {
        return null;
      }
    }

    return model;
  }
}
