import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/haml_forward_models/haml_pressure_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/pressure_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../../config/api_keys.dart';

class MainPressureScreen extends StatefulWidget {
  const MainPressureScreen({Key? key}) : super(key: key);

  @override
  State<MainPressureScreen> createState() => _MainPressureScreenState();
}

class _MainPressureScreenState extends State<MainPressureScreen> {
  final TextEditingController _pressureUpController = TextEditingController();
  final TextEditingController _pressureDownController = TextEditingController();
  final TextEditingController _pressureDateController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late Future<List<HamlPressureModel>?> _fetcAllHamlPressures;
  late BannerAd _myBannerMain;

  @override
  void initState() {
    _fetcAllHamlPressures = context
        .read(ApiProviders.hamlPressureScreenProvidersApis)
        .getAllHamlPressure(context: context);

    _myBannerMain = CommonComponents.getBannerAds();

    _myBannerMain.load();

    super.initState();
  }

  @override
  void dispose() {
    _myBannerMain.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? deviceID =  CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    return Scaffold(
      appBar: CommonComponents.commonAppBarForwardHaml(title: "قياس الضغط"),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "قياس الضغط",
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
                  onTap: () async {
                    await PressureScreenWidgets.pressureAlertWidget(
                      context: context,
                      pressureUpController: _pressureUpController,
                      pressureDownController: _pressureDownController,
                      pressureDateController: _pressureDateController,
                      formKey: _formkey,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 20.0.h,
                        color: AppColors.defaultAppColor,
                      ),
                      Text(
                        "اضف قياس الضغط",
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
            CommonComponents.showBannerAds(_myBannerMain),
            SizedBox(height: 20.0.h),
            if(deviceID==null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h,),
                  Center(
                    child: Text(
                      'لأستخدام قياس الضغط يجب تجربة الحاسبة أولا',
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
                future: _fetcAllHamlPressures,
                builder:
                    (context, AsyncSnapshot<List<HamlPressureModel>?> snapshot) {
                  if (snapshot.data == null) {
                    return CommonComponents.loadingDataFromServer();
                  } else {
                    return PressureScreenWidgets.pressureContentWidget(
                      contentList: (snapshot.data??[]),
                      appBarTitle: "قياس الضغط",
                      image: "assets/images/pressure.png",
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
