import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/social_media_model.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DrawerScreenWidgets {
  static Future<dynamic> contactUsWidget({
    required double devicePixelRatio,
    required BuildContext context,
  }) async {
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
          content: FutureBuilder(
              future: context
                  .read(ApiProviders.userScreenProvidersApis)
                  .getSocialMediaLinks(context: context),
              builder: (context, AsyncSnapshot<SocialMediaModel?> snapshot) {
                if (snapshot.data == null) {
                  return CommonComponents.loadingDataFromServer();
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10.0.h),
                      Text(
                        "تواصل معنا عبر",
                        style: TextStyle(
                          fontSize: 17.0.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.defaultAppColor,
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _socialMediaLinksWidget(
                            devicePixelRatio: devicePixelRatio,
                            image: "assets/images/drawer/whatsup.png",
                            onPress: () async {
                              await CommonComponents.launchOnBrowser(
                                  url: snapshot.data?.whatsupUrl,
                                  context: context);
                            },
                          ),
                          _socialMediaLinksWidget(
                            devicePixelRatio: devicePixelRatio,
                            image: "assets/images/drawer/facebook.png",
                            onPress: () async {
                              await CommonComponents.launchOnBrowser(
                                  url: snapshot.data?.faceBookUrl,
                                  context: context);
                            },
                          ),
                          _socialMediaLinksWidget(
                            devicePixelRatio: devicePixelRatio,
                            image: "assets/images/drawer/instgram.png",
                            onPress: () async {
                              await CommonComponents.launchOnBrowser(
                                  url: snapshot.data?.instgramUrl,
                                  context: context);
                            },
                          ),
                          _socialMediaLinksWidget(
                            devicePixelRatio: devicePixelRatio,
                            image: "assets/images/drawer/telegram.png",
                            onPress: () async {
                              await CommonComponents.launchOnBrowser(
                                  url: snapshot.data?.telegramUrl,
                                  context: context);
                            },
                          ),
                          _socialMediaLinksWidget(
                            devicePixelRatio: devicePixelRatio,
                            image: "assets/images/drawer/webiste.png",
                            onPress: () async {
                              await CommonComponents.launchOnBrowser(
                                  url: snapshot.data?.websiteUrl,
                                  context: context);
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.defaultAppColor,
                textStyle:
                    TextStyle(fontSize: 11.0.sp, fontWeight: FontWeight.w700),
              ),
              child: const Text("إلغاء"),
            )
          ],
        ),
      ),
    );
  }

  static Widget _socialMediaLinksWidget({
    required double devicePixelRatio,
    required String image,
    required void Function() onPress,
  }) {
    return InkWell(
      onTap: onPress,
      child: Image.asset(
        image,
        height: 30.0.h,
        width: 30.0.w,
        cacheHeight: (30.0.h * devicePixelRatio).round(),
        cacheWidth: (30.0.w * devicePixelRatio).round(),
      ),
    );
  }

  static Future<dynamic> rateWidget({required BuildContext context}) async {
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "قيم التطبيق",
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: AppColors.defaultAppColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: SmoothStarRating(
                        allowHalfRating: true,
                        borderColor: AppColors.greyColor,
                        color: AppColors.defaultAppColor,
                        size: 30.0.h,
                        spacing: 10.0.w,
                        starCount: 5,
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(190.0.w, 37.0.h),
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.defaultAppColor,
                              textStyle: TextStyle(
                                  fontSize: 13.0.sp,
                                  fontWeight: FontWeight.w700),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0.r),
                              ),
                            ),
                            child: const Text("ارسال"),
                          ),
                        ),
                        SizedBox(width: 10.0.w),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: AppColors.defaultAppColor,
                              textStyle: TextStyle(
                                  fontSize: 13.0.sp,
                                  fontWeight: FontWeight.w700)),
                          child: const Text("الغاء"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  static Widget _userTextFields({
    required TextEditingController controller,
    required String hint,
    required String validate,
    required TextInputType type,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (value) => value!=null&&value.isEmpty ? validate : null,
      style: TextStyle(
        fontSize: 11.0.sp,
        color: AppColors.defaultAppColor,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 11.0.sp,
          color: AppColors.greyColor,
          fontWeight: FontWeight.w700,
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10.0.r)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10.0.r)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10.0.r)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10.0.r)),
        // constraints: BoxConstraints(maxHeight: 60.0.h),
        isDense: true,
        contentPadding: EdgeInsets.all(10.0.h),
      ),
    );
  }

  static Future<dynamic> userInfoWidget({
    required BuildContext context,
    required TextEditingController userNameController,
    required TextEditingController userPhoneController,
    required TextEditingController userEmailController,
    required TextEditingController userCountry,
    required GlobalKey<FormState> formkey,
  }) async {
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
                content: Form(
                  key: formkey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            "معلومت المستخدم",
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              color: AppColors.defaultAppColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        _userTextFields(
                          controller: userNameController,
                          hint: "ادخل الاسم كامل",
                          validate: "من فضلك ادخل الاسم بالكامل",
                          type: TextInputType.name,
                        ),
                        SizedBox(height: 10.0.h),
                        _userTextFields(
                          controller: userEmailController,
                          hint: "ادخل الإيميل",
                          validate: "من فضلك ادخل الإيميل",
                          type: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 10.0.h),
                        _userTextFields(
                          controller: userPhoneController,
                          hint: "ادخل رقم التليفون",
                          validate: "من فضلك ادخل رقم التليفون",
                          type: TextInputType.phone,
                        ),
                        SizedBox(height: 10.0.h),
                        _userTextFields(
                          controller: userCountry,
                          hint: "ادخل الدولة",
                          validate: "من فضلك ادخل الدولة",
                          type: TextInputType.name,
                        ),
                      ],
                    ),
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!=null&&formkey.currentState!.validate()) {
                        await context
                            .read(ApiProviders.userScreenProvidersApis)
                            .setUserInfo(
                              context: context,
                              userName: userNameController.text,
                              userEmail: userEmailController.text,
                              userPhone: userPhoneController.text,
                              userCountry: userCountry.text,
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.defaultAppColor,
                        minimumSize: Size(80.0.w, 30.0.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0.r)),
                        textStyle: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w400,
                        )),
                    child: const Text("إرسال"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.defaultAppColor,
                        minimumSize: Size(80.0.w, 30.0.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0.r)),
                        textStyle: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w400,
                        )),
                    child: const Text("إلغاء"),
                  )
                ],
              ),
            ));
  }
}
