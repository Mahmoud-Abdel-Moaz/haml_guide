import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/models/haml_calculation_model.dart';
import 'package:haml_guide/models/haml_screen_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../config/cache_helper.dart';
import '../../config/local_notification_service.dart';
import '../../models/pin_banner.dart';

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
    required String country,
  }) async {
    String deviceID =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

    if (context.mounted) {
      dynamic d = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices?device_id=$deviceID",
        headers: {},
      );
      bool deviceIdIsFoundInDataBase = false;
log('hamel calc $d');
      if (d != null) {
        if ((d is Map<String, dynamic> && d['results'].isNotEmpty)||(d is List<dynamic> && d.isNotEmpty)) {
          dynamic dataList;
          if((d is Map<String, dynamic>)){
            dataList=d['results'];
          }else{
            dataList=d;
          }
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
                  fcmToken: fcmToken, country: country,
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
                fcmToken: fcmToken, country: country,
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
              fcmToken: fcmToken, country: country,
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
    required String country,
  }) async {
    String deviceID =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

    HamlScreenModel model = HamlScreenModel(
        deviceID: deviceID, hijariDate: hijariDate, miladyDate: miladyDate,country: country,deviceType: Platform.isIOS?'Ios':'Android',status: 'Online',);

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
    required String country,
  }) async {
    int deviceIDFromApi =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    String deviceIDFromUser =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

    HamlScreenModel model = HamlScreenModel(
      hijariDate: hijariDate,
      miladyDate: miladyDate,
      deviceID: deviceIDFromUser
      ,country: country,deviceType: Platform.isIOS?'Ios':'Android',status: 'Online',
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
      log('hamel calc 2 $data');
      if((CommonComponents.getSavedData(ApiKeys.weekNotification)??false)) {
        setWeeksRemainderNotification(data);
      }
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

  setWeeksRemainderNotification(Map<String, dynamic> data)async{
    print("test notification setWeeksRemainderNotification");
    PermissionStatus notificationStatus = await Permission.notification.status;
    if (notificationStatus.isGranted ||
        notificationStatus.isLimited ||
        Platform.isMacOS ||
        Platform.isIOS) {
      if (Platform.isAndroid && androidInfo != null) {
        if (androidInfo!.version.sdkInt < 31) {
          _weeksRemainderNotification(data);
        } else {
          PermissionStatus status = await Permission.scheduleExactAlarm.status;
          if (status.isGranted || status.isLimited) {
            _weeksRemainderNotification(data);
          } else {
            status = await Permission.scheduleExactAlarm.request();
            if (status.isGranted || status.isLimited) {
              _weeksRemainderNotification(data);
            }
          }
        }
      } else {
        _weeksRemainderNotification(data);
      }
    } else {
      PermissionStatus notificationStatus =
      await Permission.notification.request();
      if (notificationStatus.isGranted || notificationStatus.isLimited) {
        if (Platform.isAndroid && androidInfo != null) {
          if (androidInfo!.version.sdkInt < 31) {
            _weeksRemainderNotification(data);
          } else {
            PermissionStatus status = await Permission.scheduleExactAlarm.status;
            if (status.isGranted || status.isLimited) {
              _weeksRemainderNotification(data);
            } else {
              status = await Permission.scheduleExactAlarm.request();
              if (status.isGranted || status.isLimited) {
                _weeksRemainderNotification(data);
              }
            }
          }
        } else {
          _weeksRemainderNotification(data);
        }
      }
    }
  }

  Future<void> _weeksRemainderNotification(Map<String, dynamic> data) async {
    print("test notification _weeksRemainderNotification");
    CommonComponents.saveData(
        key: ApiKeys.weekNotification,
        value: false);
    int babiesNamesNotificationId = 1;
    LocalNotificationService.cancelNotificationById(babiesNamesNotificationId);
    DateTime currentTime = DateTime.now();
    CacheHelper.saveData(key: 'babies_names_notification', value: true);
    DateTime weeksRemainderTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 17, 0, 0, 0, 0);
    for(int i = 0; i < 40;i++){
      LocalNotificationService.cancelNotificationById(i+2);
    }

    if(data['get_remain']['remain_weeks']>0){
      for(int i = 0; i < data['get_remain']['remain_weeks'];i++){
        int id=int.parse('${2+i+data['get_now']['now_weeks']}');
        print("test notification set week $id ${"انت الأن في ${1+i+data['get_now']['now_weeks']}"}");
        weeksRemainderTime=weeksRemainderTime.add(const Duration(days: 7));
      await  LocalNotificationService.setNotification(
          time: weeksRemainderTime,
          // id: id + 100 + before,
          type: 'Week reminder',
          id: id,
          title: "انت الأن في ${1+i+data['get_now']['now_weeks']}",
          body: "تعرفي علي تفاصيل هذا الأسبوع",
          withSound: true,);
      }
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
      dynamic d = (await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices/?device_id=$deviceID",
        headers: {},
      ));
      log('data getUserHamlCalculation $d');
      if((d==null||d.isEmpty)&&res!=null)  {
        data=jsonDecode(res!);
      }else{
        print('/////////////////////');
        if(d!=null&&(((d is Map<String,dynamic>) && d['results'].isNotEmpty)||((d is List<dynamic>) && d.isNotEmpty))) {
           getPinBanner(context: context);
          log('d results ${['results'][0]}');
          data = (d is Map<String,dynamic>)?d['results'][0]:d[0];
          print('data data $data');
        }
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

  Future<PinBanner?> getPinBanner({required BuildContext context,bool cached=false})async{

    String? cachedBannerResponse= CommonComponents.getSavedData(ApiKeys.binBanner,);
    String? country= CommonComponents.getSavedData(ApiKeys.cachedCountry,);
    if(cached){
      if(cachedBannerResponse!=null){
        return PinBanner.fromJson(jsonDecode(cachedBannerResponse));
      }
    }
    List<dynamic>? banners = (await ApiRequests.getApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/custombanners/",
      headers: {},
    ));
    int userWeekNumber=CommonComponents.getSavedData(ApiKeys.userWeekNumber,);
    log('getPinBanner $country $userWeekNumber $banners');
  /*  country='Egypt';
    userWeekNumber=5;*/
    if(banners!=null&&banners.isNotEmpty){
      PinBanner? newBanner;
      PinBanner? cachedBanner;
      String deviceType=Platform.isIOS?'Ios':'Android';
      for (Map<String,dynamic> element in banners) {
        PinBanner banner=PinBanner.fromJson(element);
        if((banner.phoneType==null||banner.phoneType!.toLowerCase()==deviceType.toLowerCase())&&(banner.country==null||country==null||banner.country!.toLowerCase()==country.toLowerCase())&&(banner.week==null||banner.week==userWeekNumber)){
          if(banner.status==null||banner.status!.toLowerCase()=='online'){
            newBanner=banner;
          }
          if(banner.status==null||banner.status!.toLowerCase()=='offline'){
            cachedBanner=banner;
          }
        }
      }
      if(cachedBanner!=null){
        CommonComponents.saveData(key:ApiKeys.binBanner,value:jsonEncode(cachedBanner.toJson()) );
      }else{
        CommonComponents.deleteSavedData(ApiKeys.binBanner,);
      }
      return newBanner;
    }else{
      if(cachedBannerResponse!=null){
        return PinBanner.fromJson(jsonDecode(cachedBannerResponse));
      }else{
        return null;
      }
    }
  }
}
