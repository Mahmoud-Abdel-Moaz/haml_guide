import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:riverpod_context/riverpod_context.dart';

import 'config/common_components.dart';
import 'config/local_notification_service.dart';

Future<void> _firebaseMessagingBackGroundHandler(RemoteMessage messages) async {
  await Firebase.initializeApp();




  debugPrint("Handling firebase messaging background${messages.messageId}");
}
String? Fcmtoken;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CommonComponents.initSharedPreferences();
  await MobileAds.instance.initialize();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  if (Platform.isAndroid) {
    final deviceInfoPlugin = DeviceInfoPlugin();
    androidInfo = await deviceInfoPlugin.androidInfo;
  }
  firebaseMessaging.getToken().then((token){
    Fcmtoken = token;

    print("Fcmtoken $Fcmtoken"  );
  });
  runApp(
    const ProviderScope(child: InheritedConsumer(child: HamlGuide())),
  );
}

class HamlGuide extends StatefulWidget {
  const HamlGuide({Key? key}) : super(key: key);

  @override
  State<HamlGuide> createState() => _HamlGuideState();
}

class _HamlGuideState extends State<HamlGuide> {
  @override
  void initState() {

    context
        .read(ApiProviders.notificationHandler)
        .notificationInitialization(context);
    LocalNotificationService.initialize(context);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackGroundHandler);
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("Got Message When App Is Foreground");
      debugPrint("${event.data}");

      if (event != null) {
        debugPrint("my notification is ==>${event.notification}");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("Got Message When App Is BackGround");
      debugPrint("${event.data}");

      if (event != null) {
        debugPrint("my notification is ==>${event.notification}");
      }
    });
    Future.delayed(
      Duration.zero,
      () async {
        await context.read(ApiProviders.notificationHandler).showNotification();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugInvertOversizedImages = true;
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "cairo", useMaterial3: true),
        routes: routes,
        initialRoute: PATHS.splashScreen,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar', 'EG')],
      ),
    );
  }
}
