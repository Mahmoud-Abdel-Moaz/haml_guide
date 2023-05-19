import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:share_plus/share_plus.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userCountryController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Drawer(
      width: 250.0.w,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10.0.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/splash_logo.png",
                height: 215.0.h,
                width: 215.0.w,
                cacheHeight: (215.0.h * devicePixelRatio).round(),
                cacheWidth: (215.0.w * devicePixelRatio).round(),
              ),
            ),
            SizedBox(height: 10.0.h),
            ...context
                .read(InitScreenProviders.drawerScreenProviders)
                .drawerList
                .map(
                  (drawers) => InkWell(
                    onTap: () async {
                      if (drawers['title'] == "تواصل معنا") {
                        context
                            .read(InitScreenProviders.drawerScreenProviders)
                            .updateContactUsWidget(
                              context: context,
                              devicePixelRatio: devicePixelRatio,
                            );
                      } else if (drawers['title'] == "قيم التطبيق") {
                        final InAppReview inAppReview = InAppReview.instance;
                        if (Platform.isAndroid) {
                          inAppReview.openStoreListing(
                              appStoreId: 'com.dalil.elhwamelss');
                          Navigator.pop(context);
                        } else {
                          inAppReview.openStoreListing(
                              appStoreId: '6443834135');
                          Navigator.pop(context);
                        }
                      } else if (drawers['title'] == "المفضله") {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, drawers['destination']);
                      } else if (drawers['title'] == "المصادر") {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, drawers['destination']);
                      } else if (drawers['title'] == "شارك التطبيق") {
                        String iosLink="https://apps.apple.com/eg/app/hamilguide-حاسبة-الحمل-بدقة/id6443834135";
                        String androidLink="https://play.google.com/store/apps/details?id=com.dalil.elhwamelss";

                        Share.share(Platform.isAndroid ? androidLink : iosLink,
                            subject: 'Hamilguide-حاسبة الحمل بدقة');
                        if (!mounted) return;
                        Navigator.pop(context);
                      } else if (drawers['title'] == "معلومات المستخدم") {
                        context
                            .read(InitScreenProviders.drawerScreenProviders)
                            .updateUserInfoWidget(
                              context: context,
                              formkey: _formkey,
                              userNameController: _userNameController,
                              userEmailController: _userEmailController,
                              userPhoneController: _userPhoneController,
                              userCountry: _userCountryController,
                            );
                      } else {
                        context
                            .read(InitScreenProviders.mainScreenProviders)
                            .drawerIsSelected(
                              context: context,
                              tabIndex: drawers['destination'],
                            );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.0.w, vertical: 20.0.h),
                      child: Row(
                        children: [
                          Image.asset(
                            drawers['image'],
                            height: 22.0.h,
                            width: 22.0.w,
                            cacheHeight: (22.0.h * devicePixelRatio).round(),
                            cacheWidth: (22.0.w * devicePixelRatio).round(),
                            color: AppColors.greyColor,
                          ),
                          SizedBox(width: 10.0.w),
                          Text(
                            drawers['title'],
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.defaultAppColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
