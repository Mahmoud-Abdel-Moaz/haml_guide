import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'cache_helper.dart';

AndroidDeviceInfo? androidInfo;

launchUrlFun(String url) async {
  final Uri uri=url.contains('https')?Uri.parse(url): Uri(scheme: 'https',host: url,);
  // final Uri uri=Uri.parse(url) ;
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Cant not launch url';
  }
}
makeCall(String phone) async {
  final Uri uri= Uri(scheme: 'tel',path: phone,);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Cant not launch url';
  }
}

navigateTo(context, widget, {void Function()? than}) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
).then((value) => than);

Future<void> navigateToAndFinish(context, widget) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ), (Route<dynamic> route) {
      return false;
    });

void navigateToAndReplacement(context, widget) => Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
  /*      (Route<dynamic> route){
      return false;
    }*/
);

class CommonComponents {
  static PreferredSizeWidget commonAppBar({required Widget title}) {
    return AppBar(
      title: title,
      centerTitle: true,
      backgroundColor: AppColors.defaultAppColor,
      foregroundColor: Colors.white,
    );
  }

  static PreferredSizeWidget commonAppBarForwardHaml({required String title}) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.defaultAppColor,
      foregroundColor: Colors.white,
    );
  }

  static void showCustomizedSnackBar(
      {required BuildContext context, required String title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: TextStyle(
            fontSize: 14.0.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        backgroundColor: AppColors.defaultAppColor,
      ),
    );
  }

  static Future showCustomizedAlert({
    required BuildContext context,
    required String title,
    required String subTitle,
  }) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation1, animation2, child) =>
          ScaleTransition(
        scale: animation1,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/splash_logo.png",
                height: 60.0.h,
                cacheHeight:
                    (60.0.h * MediaQuery.of(context).devicePixelRatio).round(),
              ),
              SizedBox(height: 10.0.h),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            subTitle,
            style: TextStyle(
              color: AppColors.defaultAppColor,
              fontSize: 16.0.sp,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "موافق",
                style: TextStyle(fontSize: 18.0.sp),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<dynamic> deleteForwardHamlItemListAlert(
      {required BuildContext context, required void Function() onPress}) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation1, animation2, child) =>
          ScaleTransition(
        scale: animation1,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          title: Text(
            "هل أنت متأكد من الحذف؟",
            style:
                TextStyle(fontSize: 16.0.sp, color: AppColors.defaultAppColor),
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: [
            ElevatedButton(
              onPressed: onPress,
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w400,
                ),
                minimumSize: Size(68.0.w, 34.0.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0.r)),
                foregroundColor: Colors.white,
                backgroundColor: AppColors.defaultAppColor,
              ),
              child: const Text("موافق"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w400,
                ),
                minimumSize: Size(68.0.w, 34.0.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0.r)),
                foregroundColor: Colors.white,
                backgroundColor: AppColors.defaultAppColor,
              ),
              child: const Text("إلغاء"),
            )
          ],
        ),
      ),
    );
  }

  static Future<void> loading(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          height: 50.0.h,
          width: 50.0.w,
          child: CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation(AppColors.defaultAppColor),
            strokeWidth: 5.0.w,
          ),
        ),
      ),
    );
  }

  static Widget loadingDataFromServer() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColors.defaultAppColor),
      ),
    );
  }

  static Future<bool> checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectionState.none) {
      return false;
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }

  static Future notConnectionAlert({required BuildContext context}) async {
    return await showCustomizedAlert(
      context: context,
      title: "لم يوجد الإتصال بالإنترنت",
      subTitle: "الرجاء الإتصال بالإنترنت من خلال الهاتف او الواي فاي",
    );
  }

  static Future timeOutExceptionAlert(BuildContext context) async {
    return await showCustomizedAlert(
      context: context,
      title: "السيرفر مشغول",
      subTitle: "السيرفر مشغول حاليا,الرجاء المحاولة مرة اخري",
    );
  }

  static Future socketExceptionAlert(BuildContext context) async {
    return await CommonComponents.showCustomizedAlert(
      context: context,
      title: "خطأ بالسيرفر",
      subTitle: "من فضلك تأكد من تشغيل قاعدة البيانات بالسرفر",
    );
  }

  static initSharedPreferences()async{
    await CacheHelper.init();
  }

  static void  saveData(
      {required String key, required dynamic value})  {
    CacheHelper.saveData(key: key, value: value);
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else {
      return await prefs.setInt(key, value);
    }*/
  }

  static dynamic getSavedData(key)  {
   /* SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key);*/
    return CacheHelper.getData(key: key);
  }

  static deleteSavedData(key)  {
  /*  SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);*/
    CacheHelper.removeData(key: key);
  }

  static void getSnackBarWithServerError(BuildContext context) {
    showCustomizedSnackBar(context: context, title: "يوجد خطأ بالسيرفر");
  }

  static Future<void> launchOnBrowser(
      {required String? url, required BuildContext context}) async {
    if (url != null) {
      if (await launchUrlString(url,
          mode: LaunchMode.externalNonBrowserApplication)) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else {
        if (context.mounted) {
          showCustomizedSnackBar(context: context, title: "خطأ في اللينك");
        } else {
          return;
        }
      }
    } else {
      if (context.mounted) {
        showCustomizedSnackBar(context: context, title: "خطأ في اللينك");
      } else {
        return;
      }
    }
  }

  static BannerAd getBannerAds() {
    return BannerAd(
      size: AdSize.largeBanner,
      // adUnitId: Platform.isAndroid
      //     ? "ca-app-pub-3940256099942544/6300978111"
      //     : "ca-app-pub-3940256099942544/2934735716",

      //USE IT WHEN APP IS LIVE
      adUnitId: Platform.isAndroid
          ? "ca-app-pub-7186380452289746/6089718241"
          : "ca-app-pub-7186380452289746/1028808032",
      listener: BannerAdListener(onAdFailedToLoad: (ad, error) {
        debugPrint("failed To Load Banner${error.message}");
        ad.dispose();
      }),
      request: const AdRequest(),
    );
  }

  static void createIntersitial(InterstitialAd? interstitialAd) async {
    await InterstitialAd.load(
      // adUnitId: Platform.isAndroid
      //     ? "ca-app-pub-3940256099942544/8691691433"
      //     : "ca-app-pub-3940256099942544/5135589807",

//USE IT WHEN APP IS LIVE
      adUnitId: Platform.isAndroid
          ? "ca-app-pub-7186380452289746/1631598485"
          : "ca-app-pub-7186380452289746/5450682046",

      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint("Loaded Intersitail ad");
          interstitialAd = ad;
          if (interstitialAd == null) {
            return;
          } else {
            interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
              debugPrint("Ad Showed on Full Screen");
            }, onAdDismissedFullScreenContent: (ad) {
              debugPrint("ad intersilatial disposed");
              ad.dispose();
            }, onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint("on ad failed to show full screen content");
              ad.dispose();
            }, onAdWillDismissFullScreenContent: (ad) {
              debugPrint("ad will dismiss full screen content");
            });
            interstitialAd!.show();
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint("Intersitial add error is =>$error");
          interstitialAd = null;
        },
      ),
      request: const AdRequest(),
    );
  }

  static Widget showBannerAds(BannerAd myBanner) {
    myBanner.load();
    return Center(
      child: SizedBox(
        height: 100.0.h,
        width: 320.0.w,
        child: AdWidget(ad: myBanner),
      ),
    );
  }
}

void showToast({
  required String msg,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: _chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

Color _chooseToastColor(ToastStates state) {
  switch (state) {
    case ToastStates.SUCCESS:
      return Colors.green;
    case ToastStates.WARNING:
      return Colors.yellow;
    case ToastStates.ERROR:
      return Colors.red;
  }
}

enum ToastStates { SUCCESS, ERROR, WARNING }
