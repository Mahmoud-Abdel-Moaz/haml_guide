import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';

class HamlForwardDetailsScreen extends StatefulWidget {
  final String? appBarTitle, title, image, description;
  const HamlForwardDetailsScreen(
      {Key? key, this.appBarTitle, this.title, this.image, this.description})
      : super(key: key);

  @override
  State<HamlForwardDetailsScreen> createState() =>
      _HamlForwardDetailsScreenState();
}

class _HamlForwardDetailsScreenState extends State<HamlForwardDetailsScreen> {
 late BannerAd _myBanner;

  @override
  void initState() {
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

    print('HamlForwardDetailsScreen ${widget.appBarTitle} ${widget.title} ${widget.image}');
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
  //  HamlForwardDetailsScreen? args = ModalRoute.of(context)?.settings.arguments as HamlForwardDetailsScreen?;

    return Scaffold(
      appBar: CommonComponents.commonAppBarForwardHaml(title: (widget.appBarTitle??'')/*(args?.appBarTitle??'')*/),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonComponents.showBannerAds(_myBanner),
            SizedBox(height: 30.0.h),
            Image.asset(
              (widget.image??''),
             // (args?.image??''),
              height: 184.0.h,
              width: 184.0.w,
              cacheHeight: (184.0.h * devicePixelRatio).round(),
              cacheWidth: (184.0.w * devicePixelRatio).round(),
            ),
            SizedBox(height: 10.0.h),
            Text(
             ( widget.title??''),
            // ( args?.title??''),
              style: TextStyle(
                fontSize: 14.0.sp,
                color: AppColors.defaultAppColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 15.0.h),
            Text(
              (widget.description??''),
             // (args?.description??''),
              style: TextStyle(
                fontSize: 11.0.sp,
                color: AppColors.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.0.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.defaultAppColor,
                minimumSize: Size(double.infinity, 42.0.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.r)),
                textStyle: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text("الرجوع الى الرئيسية"),
            )
          ],
        ),
      ),
    );
  }
}
