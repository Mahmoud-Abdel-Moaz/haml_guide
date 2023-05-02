import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/enums.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/providers/screen_providers/main_screens_providers_apis/haml_screen_providers.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../config/geolocator_service.dart';
import '../../main.dart';

class HamlScreen extends StatefulWidget {
  const HamlScreen({Key? key}) : super(key: key);

  @override
  State<HamlScreen> createState() => _HamlScreenState();
}

class _HamlScreenState extends State<HamlScreen> {
  final _formkey = GlobalKey<FormState>();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  late BannerAd _myBanner;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        context
            .read(InitScreenProviders.hamlScreenProviders)
            .setMiladyYearsList();

        String deviceID =
            await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

        if (deviceID != null) {
          if (!mounted) return;
           context
              .read(ApiProviders.hamlScreenProvidersApis)
              .getUserHamlCalculation(
                context: context,
                deviceID: deviceID,
             getCash: true
              );
           context
              .read(ApiProviders.hamlScreenProvidersApis)
              .getUserHamlCalculation(
                context: context,
                deviceID: deviceID,
              );
           context
              .read(ApiProviders.hamlScreenProvidersApis)
              .getPinBanner(
                context: context,
              );
        }
      },
    );
    _myBanner = CommonComponents.getBannerAds();
    _myBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    _myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonComponents.showBannerAds(_myBanner),
            SizedBox(height: 10.0.h),
            Center(
              child: Text(
                "الرجاء ادخال اليوم الأول من اخر دوره شهريه لك",
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: AppColors.defaultAppColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0.h),
            Text(
              "ملحوظه",
              style: TextStyle(
                fontSize: 14.0.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.greyColor,
              ),
            ),
            Text(
              "هذه الحاسبه يستخدمها الأطباء في حساب مده الحمل بحيث يتم احتساب أيام التبويض والدوره الشهريه مع عدم تجاهل أيام الاسبوع",
              style: TextStyle(fontSize: 15.0.sp, color: AppColors.greyColor),
            ),
            SizedBox(height: 40.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "نوع التقويم",
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.defaultAppColor,
                  ),
                ),
                Consumer(
                  builder: (context, watch, child) => Row(
                    children: [
                      HamlScreenWidgets.chooseCalendarTypeWidget(
                        title: "ميلادي",
                        onPress: () {
                          context
                              .read(InitScreenProviders.hamlScreenProviders)
                              .selectBirthType(UserSelectedBirthType.milady);
                        },
                        topRight: Radius.circular(10.0.r),
                        bottomRight: Radius.circular(10.0.r),
                        topLeft: Radius.circular(0.0.r),
                        bottomLeft: Radius.circular(0.0.r),
                        containerColor: watch
                            .watch(InitScreenProviders.hamlScreenProviders)
                            .miladyContainerColor,
                        textColor: watch
                            .watch(InitScreenProviders.hamlScreenProviders)
                            .miladyTextColor,
                      ),
                      HamlScreenWidgets.chooseCalendarTypeWidget(
                        title: "هجري",
                        onPress: () {
                          context
                              .read(InitScreenProviders.hamlScreenProviders)
                              .selectBirthType(UserSelectedBirthType.hijari);
                        },
                        topRight: Radius.circular(0.0.r),
                        bottomRight: Radius.circular(0.0.r),
                        topLeft: Radius.circular(10.0.r),
                        bottomLeft: Radius.circular(10.0.r),
                        containerColor: watch
                            .watch(InitScreenProviders.hamlScreenProviders)
                            .hijariContainerColor,
                        textColor: watch
                            .watch(InitScreenProviders.hamlScreenProviders)
                            .hijariTextColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0.h),
            Text(
              "تاريخ اول يوم لاخر دوره",
              style: TextStyle(
                fontSize: 14.0.sp,
                color: AppColors.defaultAppColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0.h),
            Form(
              key: _formkey,
              child: Consumer(
                builder: (context, watch, child) => Row(
                  children: [
                    Expanded(
                      child: Container(
                        key: watch
                            .watch(InitScreenProviders.hamlScreenProviders)
                            .rebuildYearWidget,
                        child: HamlScreenWidgets.calendarDropDownWidget(
                          context: context,
                          hint: "اختر السنة",
                          validate: "من فضلك اختر السنة",
                          items: watch
                              .watch(InitScreenProviders.hamlScreenProviders)
                              .yearsList
                              .map((years) => DropdownMenuItem(
                                    value: years.toString(),
                                    child: Text(years.toString()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            context
                                .read(InitScreenProviders.hamlScreenProviders)
                                .setYearSelected(value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0.w),
                    Expanded(
                      child: HamlScreenWidgets.calendarDropDownWidget(
                        context: context,
                        hint: "اختر الشهر",
                        validate: "من فضلك اختر الشهر",
                        items: watch
                                    .watch(
                                        InitScreenProviders.hamlScreenProviders)
                                    .birthType ==
                                UserSelectedBirthType.milady
                            ? watch
                                .watch(InitScreenProviders.hamlScreenProviders)
                                .monthsMiladyListInArabic
                                .map((months) => DropdownMenuItem(
                                      value: months['number'],
                                      child: Text(months['name']),
                                    ))
                                .toList()
                            : watch
                                .watch(InitScreenProviders.hamlScreenProviders)
                                .monthsHijariListInArabic
                                .map((months) => DropdownMenuItem(
                                      value: months['number'],
                                      child: Text(months['name']),
                                    ))
                                .toList(),
                        onChanged: (value) {
                          context
                              .read(InitScreenProviders.hamlScreenProviders)
                              .setMonthSelected(value);
                          context
                              .read(InitScreenProviders.hamlScreenProviders)
                              .setDaysNumberList();
                        },
                      ),
                    ),
                    SizedBox(width: 10.0.w),
                    Expanded(
                      child: HamlScreenWidgets.calendarDropDownWidget(
                        context: context,
                        hint: "اختر اليوم",
                        validate: "من فضلك اختر اليوم",
                        items: watch
                            .watch(InitScreenProviders.hamlScreenProviders)
                            .daysNumberList
                            .map((days) => DropdownMenuItem(
                                  value: days.toString(),
                                  child: Text(days.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          context
                              .read(InitScreenProviders.hamlScreenProviders)
                              .dayNumberSelected(value.padLeft(2, "0"));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0.h),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Position? position =await GeolocatorService.checkLocationServicesInDevice();
                  if(position==null){
                    return;
                  }
                  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude,localeIdentifier:'en');
                  if(placemarks.isEmpty||placemarks.first.country==null){
                    return;
                  }
                  CommonComponents.saveData(key:ApiKeys.cachedCountry,value:(placemarks.first.country??'') );
                  print('placemarks ${placemarks.first.country}');
                  HamlScreenProviders hamlDataProviders =
                      context.read(InitScreenProviders.hamlScreenProviders);

                  if (_formkey.currentState!=null&&_formkey.currentState!.validate()) {
                    if (Platform.isAndroid) {
                      print('ElevatedButton 1');
                      AndroidDeviceInfo androidInfo =
                          await _deviceInfo.androidInfo;

                       CommonComponents.saveData(
                          key: ApiKeys.deviceIdFromUser, value: Fcmtoken);

                      if (await CommonComponents.getSavedData(
                              ApiKeys.deviceIdFromApi) ==
                          null) {
                        if (!mounted) return;
                        FirebaseMessaging.instance.getToken().then(
                            (value) async {
                              print('getDeviceData value $value');

                              await context
                                .read(ApiProviders.hamlScreenProvidersApis)
                                .getDeviceData(
                                  context: context,
                                  miladyDate: context
                                              .read(InitScreenProviders
                                                  .hamlScreenProviders)
                                              .birthType ==
                                          UserSelectedBirthType.milady
                                      ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                      : null,
                                  hijariDate: context
                                              .read(InitScreenProviders
                                                  .hamlScreenProviders)
                                              .birthType ==
                                          UserSelectedBirthType.hijari
                                      ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                      : null,
                                  fcmToken: (value??''), country: (placemarks.first.country??''),
                                );
                            });
                      } else {
                        if (!mounted) return;
                        FirebaseMessaging.instance.getToken().then(
                            (value) async => await context
                                .read(ApiProviders.hamlScreenProvidersApis)
                                .updateUserDate(
                                  context: context,
                                  miladyDate: context
                                              .read(InitScreenProviders
                                                  .hamlScreenProviders)
                                              .birthType ==
                                          UserSelectedBirthType.milady
                                      ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                      : null,
                                  hijariDate: context
                                              .read(InitScreenProviders
                                                  .hamlScreenProviders)
                                              .birthType ==
                                          UserSelectedBirthType.hijari
                                      ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                      : null,
                                  fcmToken:( value??''), country: (placemarks.first.country??''),
                                ));
                      }
                    } else {
                      print('ElevatedButton 2');

                      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;

                       CommonComponents.saveData(
                          key: ApiKeys.deviceIdFromUser,
                          value: Fcmtoken);

                      if (await CommonComponents.getSavedData(
                              ApiKeys.deviceIdFromApi) ==
                          null) {
                        print('ElevatedButton 3');

                        if (!mounted) return;
                        FirebaseMessaging.instance.getToken().then(
                            (value) async {
                              print('getDeviceData value $value');
                              print('ElevatedButton 4');

                              await context
                                .read(ApiProviders.hamlScreenProvidersApis)
                                .getDeviceData(
                                  context: context,
                                  miladyDate: context
                                              .read(InitScreenProviders
                                                  .hamlScreenProviders)
                                              .birthType ==
                                          UserSelectedBirthType.milady
                                      ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                      : null,
                                  hijariDate: context
                                              .read(InitScreenProviders
                                                  .hamlScreenProviders)
                                              .birthType ==
                                          UserSelectedBirthType.hijari
                                      ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                      : null,
                                  fcmToken: (value??''), country: (placemarks.first.country??''),
                                );
                            });
                      } else {
                        if (!mounted) return;
                        print('ElevatedButton 5');

                        FirebaseMessaging.instance.getToken().then(
                              (value) async {
                                print('FirebaseMessaging  d $value');
                                await context
                                  .read(ApiProviders.hamlScreenProvidersApis)
                                  .updateUserDate(
                                    context: context,
                                    miladyDate: context
                                                .read(InitScreenProviders
                                                    .hamlScreenProviders)
                                                .birthType ==
                                            UserSelectedBirthType.milady
                                        ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                        : null,
                                    hijariDate: context
                                                .read(InitScreenProviders
                                                    .hamlScreenProviders)
                                                .birthType ==
                                            UserSelectedBirthType.hijari
                                        ? "${hamlDataProviders.yearSelected}-${hamlDataProviders.monthSelected}-${hamlDataProviders.daySelected}"
                                        : null,
                                    fcmToken: (value??''), country:(placemarks.first.country??''),
                                  );
                              },
                            );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.defaultAppColor,
                    minimumSize: Size(200.0.w, 40.0.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0.r),
                    )),
                child: const Text("حاسبة الحمل"),
              ),
            ),
            SizedBox(height: 50.0.h),
          ],
        ),
      ),
    );
  }
}
