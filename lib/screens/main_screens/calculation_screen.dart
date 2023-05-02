import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/models/haml_calculation_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/calculation_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CalculationScreen extends StatefulWidget {
  const CalculationScreen({Key? key}) : super(key: key);

  @override
  State<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? _imageFile;
  Future<HamlCalculationModel?>? _fetchHamlCalculation;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      String deviceID =
          await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

      if (!mounted) return;
      _fetchHamlCalculation = context
          .read(ApiProviders.hamlScreenProvidersApis)
          .getUserHamlCalculation(
            context: context,
            deviceID: deviceID,
          );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: FutureBuilder(
          future: _fetchHamlCalculation,
          builder: (context, AsyncSnapshot<HamlCalculationModel?> snapshot) {
            if (snapshot.data == null) {
              return CommonComponents.loadingDataFromServer();
            } else {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 15.0.h,horizontal: 15.0.w),
                physics: const BouncingScrollPhysics(),
                child: Screenshot(
                  controller: _screenshotController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width:double.infinity,
                        padding:EdgeInsets.symmetric(vertical: 8.h,horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: Color(0xffF8F8F6),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Image.asset(
                            "assets/images/haml_calculate.png",
                            height: 140.0.r,
                            width: 140.0.r,
                            cacheHeight: (140.0.h * devicePixelRatio).round(),
                            cacheWidth: (140.0.w * devicePixelRatio).round(),
                          ),
                            SizedBox(height: 8.h,),
                            Text(
                              "حاسبه الحمل",
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                color: AppColors.defaultAppColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8.h,),
                            ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.defaultAppColor,
                                  minimumSize: Size(200.0.w, 40.0.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0.r),
                                  )),
                              child: const Text("action"),
                            )
                          ],),
                      ),
                      SizedBox(height: 16.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "حاسبه الحمل",
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              color: AppColors.defaultAppColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              _imageFile = await _screenshotController.capture(
                                  delay: const Duration(milliseconds: 100));
                              if(_imageFile!=null) {
                                await ImageGallerySaver.saveImage(_imageFile!);
                                await Fluttertoast.showToast(
                                  msg: "تم التقاط صورة من الشاشة",
                                  gravity: ToastGravity.CENTER,
                                  fontSize: 16.0.sp,
                                  toastLength: Toast.LENGTH_LONG,
                                );
                              }
                            },
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 20.0.h,
                              color: AppColors.defaultAppColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0.h),
                      Center(
                        child: Image.asset(
                          "assets/images/haml_calculate.png",
                          height: 140.0.h,
                          width: 140.0.w,
                          cacheHeight: (140.0.h * devicePixelRatio).round(),
                          cacheWidth: (140.0.w * devicePixelRatio).round(),
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Container(
                        padding: EdgeInsets.all(5.0.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderGreyColor),
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 17.0.h,
                                  color: AppColors.defaultAppColor,
                                ),
                                SizedBox(width: 10.0.w),
                                Text(
                                  "يوم الولاده المتوقع",
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: AppColors.defaultAppColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              (snapshot.data?.expectedPergnantDate??''),
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: AppColors.defaultAppColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Center(
                        child: Text(
                          "انت الان في",
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: AppColors.defaultAppColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Row(
                        children: [
                          Expanded(
                            child: CalculationScreenWidgets.calculationFileds(
                              title: "الشهر",
                              subTitle: "${(snapshot.data?.getNowMonth??'')}",
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          Expanded(
                            child: CalculationScreenWidgets.calculationFileds(
                              title: "الاسبوع",
                              subTitle: "${(snapshot.data?.getNowWeek??'')}",
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          Expanded(
                            child: CalculationScreenWidgets.calculationFileds(
                              title: "اليوم",
                              subTitle: "${(snapshot.data?.getNowDay??'')}",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0.h),
                      Container(
                        padding: EdgeInsets.all(10.0.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10.0.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "الحمل حتى الان",
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: AppColors.defaultAppColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            Text(
                              "${(snapshot.data?.getPastMonth??'')} أشهر - ${(snapshot.data?.getPastWeek??'')} أسبوع - ${(snapshot.data?.getPastDay??'')} يوم",
                              style: TextStyle(
                                fontSize: 15.0.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.defaultAppColor,
                              ),
                            ),
                            SizedBox(height: 10.0.h),
                            TweenAnimationBuilder(
                              duration: const Duration(milliseconds: 500),
                              tween: Tween(begin: 0.0, end: 20.0),
                              builder: (context, value, child) =>
                                  LinearProgressIndicator(
                                value: (snapshot.data?.getPastMonth??9) / 9,
                                backgroundColor: Colors.white,
                                color: AppColors.defaultAppColor,
                                minHeight: 15.0.h,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0.h),
                      Center(
                        child: Text(
                          "المتبقى",
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: AppColors.defaultAppColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Row(
                        children: [
                          Expanded(
                            child: CalculationScreenWidgets.calculationFileds(
                              title: "شهور",
                              subTitle: " ${(snapshot.data?.getRemainMonth??'')} شهور",
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          Expanded(
                            child: CalculationScreenWidgets.calculationFileds(
                              title: "اسابيع",
                              subTitle: " ${(snapshot.data?.getRemainWeek??'')} اسبوع",
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          Expanded(
                            child: CalculationScreenWidgets.calculationFileds(
                              title: "ايام",
                              subTitle: " ${((snapshot.data?.getRemainDay??''))} يوم",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!mounted) return;
                                context
                                    .read(
                                        InitScreenProviders.mainScreenProviders)
                                    .tabIsSelected(1);
                              },
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: 11.0.sp,
                                    fontWeight: FontWeight.w700),
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.defaultAppColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0.r),
                                ),
                              ),
                              child: Text(
                                "المزيد عن الأسبوع الحالي ال ${(snapshot.data?.getNowWeek??'')}",
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0.w),
                          ElevatedButton.icon(
                            onPressed: () async {
                              context.refresh(
                                  InitScreenProviders.hamlScreenProviders);

                               CommonComponents.deleteSavedData(
                                  ApiKeys.deviceIdFromUser);
                               CommonComponents.deleteSavedData(
                                  ApiKeys.hamlCalc);

                              if (!mounted) return;
                              context
                                  .read(InitScreenProviders.mainScreenProviders)
                                  .setIfUserIsCalucaltedHaml(false);
                            },
                            icon: Image.asset(
                              "assets/images/bottom_bar/haml.png",
                              height: 16.0.h,
                              width: 15.0.w,
                              cacheHeight: (16.0.h * devicePixelRatio).round(),
                              cacheWidth: (15.0.w * devicePixelRatio).round(),
                              color: AppColors.defaultAppColor,
                            ),
                            label: const Text("اعاده الحساب"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                  fontSize: 13.0.sp,
                                  fontWeight: FontWeight.w700),
                              foregroundColor: AppColors.defaultAppColor,
                              backgroundColor: Colors.white,
                              minimumSize: Size(142.0.w, 37.0.h),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: AppColors.defaultAppColor),
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20.0.h),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
