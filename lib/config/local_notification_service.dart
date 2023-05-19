// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../screens/main_screen.dart';
import 'cache_helper.dart';
import 'common_components.dart';
import 'init_screen_providers.dart';



class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static _requestPermissions() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static triggeringTheLaunch (BuildContext context)async{
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if(notificationAppLaunchDetails!=null){
     if(notificationAppLaunchDetails.didNotificationLaunchApp){
       print('notificationAppLaunchDetails done');
       if(notificationAppLaunchDetails.notificationResponse!=null){
         final notificationResponse=notificationAppLaunchDetails.notificationResponse!;
         if(notificationResponse.id==1){
           //   navigateToAndFinish(context, const MainScreen());
           print('notificationAppLaunchDetails done 0');
           context
               .read(InitScreenProviders.mainScreenProviders)
               .tabIsSelected(0);
         }else if((notificationResponse.id! >= 2&&notificationResponse.id! <= 42)){
           //   navigateToAndFinish(context, const MainScreen());
           print('notificationAppLaunchDetails done 1');
           context
               .read(InitScreenProviders.mainScreenProviders)
               .tabIsSelected(1);
         }
       }
     }

  }
  }

  static void initialize(BuildContext context) {
    _requestPermissions();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    void onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) async {
      // display a dialog with the notification details, tap ok to go to another page
      print('onDidReceiveLocalNotification payload $payload');
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title ?? ''),
          content: Text(body ?? ''),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('ok'),
              onPressed: () async {

              },
            )
              ],
            ),
      );
    }



    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print('onDidReceiveNotificationResponse ${notificationResponse.id}');
        if(notificationResponse.id==1){
       //   navigateToAndFinish(context, const MainScreen());
          context
              .read(InitScreenProviders.mainScreenProviders)
              .tabIsSelected(0);
        }else if(notificationResponse.id! >= 2&&notificationResponse.id! <= 42){
       //   navigateToAndFinish(context, const MainScreen());
          context
              .read(InitScreenProviders.mainScreenProviders)
              .tabIsSelected(1);
        }
    /*    if (notificationResponse.id == 3 || notificationResponse.id == 4) {
          navigateToAndFinish(context, const AppLayoutScreen());
          navigateTo(context, AzkarScreen());
        } else {
          navigateToAndFinish(context, const AppLayoutScreen());
        }*/
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }
  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse notificationResponse) {
    /* flutterNotificationSelected(
        payLoad: "payLoad",
        context: context,
        notificationResponse: notificationResponse);*/
    log('notificationTapBackground ${notificationResponse.id} ${notificationResponse.notificationResponseType}');
    print('notificationTapBackground ${notificationResponse.id} ${notificationResponse.notificationResponseType}');
    /*if (notificationResponse.id == 1 || notificationResponse.id == 500) {
      log('notificationTapBackground 1');
      print('notificationTapBackground 1');
      showToast(msg: 'baby notification ', state: ToastStates.ERROR);
      CacheHelper.saveData(key: 'start_index', value: 0);
    } else if ((notificationResponse.id! >= 2 &&
        notificationResponse.id! <= 42)) {
      log('notificationTapBackground 2');
      print('notificationTapBackground 2');
      showToast(msg: 'baby notification ', state: ToastStates.SUCCESS);
      CacheHelper.saveData(key: 'start_index', value: 1);
    }*/

  }
  static String? lastType;
  static setNotification(
      {required DateTime time,
      required int id,
      required String body,
      required String type,
      String title = 'Prayer Time',
      bool withSound = true,
      DateTimeComponents? matchDateTimeComponents,}) async {

    lastType = body;
    print(
        'setNotification ${time.toString()} $id $body $title $withSound ');
    Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    if (Platform.isAndroid && androidInfo != null) {
      if (androidInfo!.version.sdkInt < 26) {
        await _flutterLocalNotificationsPlugin.schedule(
          id,
          title,
          body,
          time,
          NotificationDetails(
              android: AndroidNotificationDetails('channel id 11', type,
                  channelDescription: type,
                  playSound: withSound,
                  vibrationPattern: vibrationPattern,
                  fullScreenIntent: true),
              iOS: DarwinNotificationDetails(
                presentSound: withSound,
              )),
          androidAllowWhileIdle: true,
          payload: body,
        );
      } else {
        await _sendNotification(id, title, body, time, withSound,
            vibrationPattern,  matchDateTimeComponents, type);
      }
    } else {
      await _sendNotification(id, title, body, time, withSound,
          vibrationPattern,  matchDateTimeComponents, type);
    }
  }

  static Future<void> _sendNotification(
      int id,
      String title,
      String body,
      DateTime time,
      bool withSound,
      Int64List vibrationPattern,
      DateTimeComponents? matchDateTimeComponents,
      String type) async {
    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(time.difference(DateTime.now())),
        NotificationDetails(
            android: AndroidNotificationDetails('channel id 11', type,
                channelDescription: type,
                playSound: withSound,
                vibrationPattern: vibrationPattern,
                fullScreenIntent: true),
            iOS: DarwinNotificationDetails(
              presentSound: withSound,
            )),
        androidAllowWhileIdle: true,
        payload: body,
        matchDateTimeComponents: matchDateTimeComponents,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static cancelNotification() {
    lastType = null;
    _flutterLocalNotificationsPlugin.cancelAll();
  }

  static cancelNotificationById(int id) {
    lastType = null;
    _flutterLocalNotificationsPlugin.cancel(id);
  }
}
