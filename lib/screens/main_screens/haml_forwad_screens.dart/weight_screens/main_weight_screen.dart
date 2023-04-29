import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_weight_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/weight_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

class MainWeightScreen extends StatefulWidget {
  const MainWeightScreen({Key? key}) : super(key: key);

  @override
  State<MainWeightScreen> createState() => _MainWeightScreenState();
}

class _MainWeightScreenState extends State<MainWeightScreen> {
  late Future<List<HamlWeightModel>?> _fetchAllHamlWeights;
 late  BannerAd _myBanner;
  @override
  void initState() {
    _fetchAllHamlWeights = context
        .read(ApiProviders.hamlWeigtScreenProvidersApis)
        .getAllHamlWeights(context: context);
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
      appBar: CommonComponents.commonAppBarForwardHaml(title: "وزن الحامل"),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "وزن الحامل",
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: AppColors.defaultAppColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PATHS.addWeightScreen);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 20.0.h,
                        color: AppColors.defaultAppColor,
                      ),
                      Text(
                        "اضف وزن الحامل",
                        style: TextStyle(
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.defaultAppColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0.h),
            CommonComponents.showBannerAds(_myBanner),
            SizedBox(height: 20.0.h),
            FutureBuilder(
                future: _fetchAllHamlWeights,
                builder:
                    (context, AsyncSnapshot<List<HamlWeightModel>?> snapshot) {
                  if (snapshot.data == null) {
                    return CommonComponents.loadingDataFromServer();
                  } else {
                    return WeightScreenWidgets.weightContentWidget(
                      contentList: (snapshot.data??[]),
                      appBarTitle: "وزن الحامل",
                      image: "assets/images/weight.png",
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
