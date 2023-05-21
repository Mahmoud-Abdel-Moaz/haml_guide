import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_kicks_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/kicks_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../../config/api_keys.dart';

class MainRklatScreen extends StatefulWidget {
  const MainRklatScreen({Key? key}) : super(key: key);

  @override
  State<MainRklatScreen> createState() => _MainRklatScreenState();
}

class _MainRklatScreenState extends State<MainRklatScreen> {
  late Future<List<HamlKicksModel>?> _fetchAllKicksList;
  late BannerAd _myBanner;
  @override
  void initState() {
    _fetchAllKicksList = context
        .read(ApiProviders.kicksScreenProvidersApis)
        .getAllKicks(context: context);

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
    int? deviceID =  CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    return Scaffold(
      appBar: CommonComponents.commonAppBarForwardHaml(title: "ركلات الجنين"),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ركلات الجنين",
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: AppColors.defaultAppColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if(deviceID==null)
                  const SizedBox(),
                if(deviceID!=null)
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PATHS.addRklatScreen);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 20.0.h,
                        color: AppColors.defaultAppColor,
                      ),
                      Text(
                        "اضف ركلات الجنين",
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
            if(deviceID==null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h,),
                  Center(
                    child: Text(
                      'لأستخدام تسجيل ركلات الجنين يجب تجربة الحاسبة أولا',
                      style:  TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                    ),
                  )
                ],
              ),
            if(deviceID!=null)
            FutureBuilder(
                future: _fetchAllKicksList,
                builder:
                    (context, AsyncSnapshot<List<HamlKicksModel>?> snapshot) {
                  if (snapshot.data == null) {
                    return CommonComponents.loadingDataFromServer();
                  } else {
                    return KicksScreenWidgets.kicksContentWidget(
                      kicksContentList: (snapshot.data??[]),
                      appBarTitle: "ركلات الجنين",
                      image: "assets/images/rklat.png",
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
