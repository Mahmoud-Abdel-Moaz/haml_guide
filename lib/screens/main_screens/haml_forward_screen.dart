import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screen_widgets.dart';

import '../../config/cache_helper.dart';

class HamlForwardScreen extends StatefulWidget {
  const HamlForwardScreen({Key? key}) : super(key: key);

  @override
  State<HamlForwardScreen> createState() => _HamlForwardScreenState();
}

class _HamlForwardScreenState extends State<HamlForwardScreen> {
  //check snapshot
  late InterstitialAd _interstitialAd;
  late BannerAd _myBanner;
  @override
  void initState() {
    CacheHelper.saveData(key: 'start_index', value: 2);

    // CommonComponents.createIntersitial(_interstitialAd);
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
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          children: [
            CommonComponents.showBannerAds(_myBanner),
            SizedBox(height: 10.0.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10.0.h),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 150.0.h,
                  crossAxisSpacing: 10.0.w,
                  mainAxisSpacing: 20.0.h,
                ),
                itemCount: HamlForwardScreenWidgets.hamlForwardList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      HamlForwardScreenWidgets.hamlForwardList[index]
                          ['destination'],
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderGreyColor),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          HamlForwardScreenWidgets.hamlForwardList[index]
                              ['image'],
                          height: 80.0.h,
                          width: 80.0.w,
                          cacheHeight: (80.0.h * devicePixelRatio).round(),
                          cacheWidth: (80.0.w * devicePixelRatio).round(),
                        ),
                        SizedBox(height: 10.0.h),
                        Text(
                          HamlForwardScreenWidgets.hamlForwardList[index]
                              ['title'],
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
              ),
            ),
            SizedBox(height: 20.0.h),
          ],
        ),
      ),
    );
  }
}
