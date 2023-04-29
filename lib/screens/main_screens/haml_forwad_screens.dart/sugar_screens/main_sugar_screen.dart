import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/haml_forward_models/haml_sugar_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/sugar_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

class MainSugarScreen extends StatefulWidget {
  const MainSugarScreen({Key? key}) : super(key: key);

  @override
  State<MainSugarScreen> createState() => _MainSugarScreenState();
}

class _MainSugarScreenState extends State<MainSugarScreen> {
  final TextEditingController _sugarTitleController = TextEditingController();
  final TextEditingController _sugarDateController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late Future<List<HamlSugarModel>?> _fetchAllHamlSugars;
 late BannerAd _myBannerMain;

  @override
  void initState() {
    _fetchAllHamlSugars = context
        .read(ApiProviders.hamlSugarScreenProvidersApis)
        .getAllHamlSugar(context: context);

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
    return Scaffold(
      appBar: CommonComponents.commonAppBarForwardHaml(title: "قياس السكر"),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "قياس السكر",
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: AppColors.defaultAppColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await SugarScreenWidgets.sugarAlertWidget(
                      context: context,
                      sugarTitleController: _sugarTitleController,
                      sugarDateController: _sugarDateController,
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
                        "اضف قياس السكر",
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
            FutureBuilder(
                future: _fetchAllHamlSugars,
                builder:
                    (context, AsyncSnapshot<List<HamlSugarModel>?> snapshot) {
                  if (snapshot.data == null) {
                    return CommonComponents.loadingDataFromServer();
                  } else {
                    return SugarScreenWidgets.sugarContentWidget(
                      contentList: (snapshot.data??[]),
                      appBarTitle: "قياس السكر",
                      image: "assets/images/sugar.png",
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
