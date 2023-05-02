import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/screens/main_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/cache_helper.dart';
import '../config/common_components.dart';
import '../config/local_notification_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    LocalNotificationService.setNotification(
      time: DateTime.now().add(const Duration(seconds: 10)),
      // id: id + 100 + before,
      id: 500,
      type: 'Baby name',
      title:  "اسم الجنين",
      body: "اختاري اسم جنينك المفضل",
      withSound: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,);

    bool babiesNameNotification=CacheHelper.getData(key: 'babies_names_notification',defaultValue: false);
    if(!babiesNameNotification){
      setBabiesNameNotification();
    }
    return Scaffold(
      body: Center(
        child: AnimatedSplashScreen(
          splash: Image.asset("assets/images/splash_logo.png"),
          splashIconSize: 269.0.h,
          duration: 2000,
          animationDuration: const Duration(seconds: 1),
          curve: Curves.bounceOut,
          splashTransition: SplashTransition.scaleTransition,
          nextScreen: const MainScreen(),
        ),
      ),
    );
  }

  setBabiesNameNotification()async{
    PermissionStatus notificationStatus = await Permission.notification.status;
    if (notificationStatus.isGranted ||
        notificationStatus.isLimited ||
        Platform.isMacOS ||
        Platform.isIOS) {
      if (Platform.isAndroid && androidInfo != null) {
        if (androidInfo!.version.sdkInt < 31) {
          _babiesNamesNotification();
        } else {
          PermissionStatus status = await Permission.scheduleExactAlarm.status;
          if (status.isGranted || status.isLimited) {
            _babiesNamesNotification();
          } else {
            status = await Permission.scheduleExactAlarm.request();
            if (status.isGranted || status.isLimited) {
              _babiesNamesNotification();
            }
          }
        }
      } else {
        _babiesNamesNotification();
      }
    } else {
      PermissionStatus notificationStatus =
          await Permission.notification.request();
      if (notificationStatus.isGranted || notificationStatus.isLimited) {
        if (Platform.isAndroid && androidInfo != null) {
          if (androidInfo!.version.sdkInt < 31) {
            _babiesNamesNotification();
          } else {
            PermissionStatus status = await Permission.scheduleExactAlarm.status;
            if (status.isGranted || status.isLimited) {
              _babiesNamesNotification();
            } else {
              status = await Permission.scheduleExactAlarm.request();
              if (status.isGranted || status.isLimited) {
                _babiesNamesNotification();
              }
            }
          }
        } else {
          _babiesNamesNotification();
        }
      }
    }
  }

  void _babiesNamesNotification() {
    int babiesNamesNotificationId = 1;
    LocalNotificationService.cancelNotificationById(babiesNamesNotificationId);
    DateTime currentTime = DateTime.now();
    CacheHelper.saveData(key: 'babies_names_notification', value: true);
    DateTime morningTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 14, 0, 0, 0, 0);
    if (currentTime.isBefore(morningTime)) {
      LocalNotificationService.setNotification(
        time: morningTime,
        // id: id + 100 + before,
        type: 'Baby name',
        id: babiesNamesNotificationId,
        title:  "اسم الجنين",
        body: "اختاري اسم جنينك المفضل",
        withSound: true,
        matchDateTimeComponents: DateTimeComponents.time,);
    } else {
      LocalNotificationService.setNotification(
        time: morningTime.add(const Duration(days: 1)),
        // id: id + 100 + before,
        id: babiesNamesNotificationId,
        type: 'Baby name',
        title:  "اسم الجنين",
        body: "اختاري اسم جنينك المفضل",
        withSound: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,);
    }
  }

}
