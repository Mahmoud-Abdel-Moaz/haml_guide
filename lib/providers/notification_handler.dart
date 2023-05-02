import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHandler extends ChangeNotifier {
  int pageIndex = 0;
  bool navigateToAlarmScreen = false;
  List<Map<String, dynamic>> alarmNotifications = [];

  void notificationInitialization(BuildContext context) {
    FlutterLocalNotificationsPlugin fltrNotification;

    AndroidInitializationSettings androidInitialize =
        const AndroidInitializationSettings('app_icon');

    DarwinInitializationSettings iosInitialize =
        const DarwinInitializationSettings();
    var initalizationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    fltrNotification = FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(
      initalizationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        flutterNotificationSelected(payLoad: "payLoad", context: context);
      },
    );
  }

  Future showNotification() async {
    FlutterLocalNotificationsPlugin fltrNotification =
        FlutterLocalNotificationsPlugin();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
   // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var andoridDetails = const AndroidNotificationDetails(
      "channelId",
      "channelName",
      channelDescription: "Channel Description",
      importance: Importance.max,
      priority: Priority.high,
      ticker: "Ticker",
    );

    var iosDetails = const DarwinNotificationDetails();
    var generalNotification =
        NotificationDetails(android: andoridDetails, iOS: iosDetails);

    String userWeekName =
        await CommonComponents.getSavedData(ApiKeys.userWeekName);

 /*   await fltrNotification
        .periodicallyShow(
          1,
          "انت الأن في $userWeekName",
          "تعرفي علي تفاصيل هذا الأسبوع",
          RepeatInterval.weekly,
          generalNotification,
          androidAllowWhileIdle: true,
        )
        .then((value) => pageIndex = 1);*/

   // await setNotification(time: DateTime.now(), id: 1, body: "تعرفي علي تفاصيل هذا الأسبوع", type: 'Week reminder', title: "انت الأن في $userWeekName", androidInfo: androidInfo,matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime).then((value) => pageIndex = 1);

   // Timer.periodic(const Duration(days: 3), (timer) async {
   /*   await fltrNotification
          .schedule(
            0,
            "اسم الجنين",
            "اختاري اسم جنينك المفضل",
            DateTime.now().add(Duration.zero),
            generalNotification,
            androidAllowWhileIdle: true,
          )
          .then((value) => pageIndex = 0);*/
    //  await setNotification(time: DateTime.now(), id: 2, body: "اختاري اسم جنينك المفضل", type: 'Baby name', title: "اسم الجنين", androidInfo: androidInfo,).then((value) => pageIndex = 0);

   // });

  }

  Future<void>  setNotification(
      {required DateTime time,
        required int id,
        required String body,
        required String type,
        required String title,
        required AndroidDeviceInfo androidInfo,
        bool withSound = true,
        DateTimeComponents? matchDateTimeComponents,}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    print(
        'setNotification ${time.toString()} $id $body $title $withSound ');
    Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    if (Platform.isAndroid) {
      if (androidInfo.version.sdkInt < 26) {
        await flutterLocalNotificationsPlugin.schedule(
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
            vibrationPattern, matchDateTimeComponents, type);
      }
    } else {
      await _sendNotification(id, title, body, time, withSound,
          vibrationPattern, matchDateTimeComponents, type);
    }
  }

  static Future<void> _sendNotification(
      int id,
      String title,
      String body,
      DateTime time,
      bool withSound,
      Int64List vibrationPattern,
      DateTimeComponents? matchDateTimeComponents,String type) async {
    tz.initializeTimeZones();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.zonedSchedule(
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

  void flutterNotificationSelected({
    required String payLoad,
    required BuildContext context,
  }) {
    if (!navigateToAlarmScreen) {
      context
          .read(InitScreenProviders.mainScreenProviders)
          .tabIsSelected(pageIndex);
    } else {
      Navigator.pushNamed(context, PATHS.mainAlarmScreen);
    }

    notifyListeners();
  }

  void setAlarmNotificationList(
      {required String description, required String dateTimeIso}) {
    alarmNotifications.add({
      "description": description,
      "dateTime": dateTimeIso,
    });
  }

  void resetAlarmNotificationList() {
    alarmNotifications.clear();
    notifyListeners();
  }

  Future<void> showAlarmNotification(
      {required int notificationIDS,required  String description,required  DateTime dateTime}) async {
    const sound = "notification_sound.wav";
    FlutterLocalNotificationsPlugin fltrNotification =
        FlutterLocalNotificationsPlugin();
    var andoridDetails = AndroidNotificationDetails(
      "channelID1",
      "channelName",
      channelDescription: "Channel Description",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(sound.split('.').first),
    );

    var iosDetails = const DarwinNotificationDetails(sound: sound);
    var generalNotification =
        NotificationDetails(android: andoridDetails, iOS: iosDetails);

    // for (int i = 0; i < alarmNotifications.length; i++) {
    await fltrNotification
        .schedule(
          notificationIDS??0,
          "المنبة",
          description,
          dateTime,
          generalNotification,
          androidAllowWhileIdle: true,
        )
        .then((value) => navigateToAlarmScreen = true);
    // notifyListeners();
  }
  // }
}
