import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/haml_forward_models/haml_alarm_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/alarm_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

class MainAlarmScreen extends StatefulWidget {
  const MainAlarmScreen({Key? key}) : super(key: key);

  @override
  State<MainAlarmScreen> createState() => _MainAlarmScreenState();
}

class _MainAlarmScreenState extends State<MainAlarmScreen> {
  final TextEditingController _alarmDateController = TextEditingController();
  final TextEditingController _alarmTimeController = TextEditingController();
  final TextEditingController _alarmTitleController = TextEditingController();
  final TextEditingController _alarmDescriptionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<HamlAlarmModel>?> _fetchAllAlarms;

  late BannerAd _myBannerMain;

  @override
  void initState() {
    _fetchAllAlarms = context
        .read(ApiProviders.hamlAlarmScreenProviders)
        .getAllHamlAlarms(context: context);

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
      appBar: CommonComponents.commonAppBarForwardHaml(title: "المنبه"),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "المنبه",
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: AppColors.defaultAppColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await AlarmScreenWidgets.alarmAlertWidget(
                      context: context,
                      alarmDateController: _alarmDateController,
                      alarmTimeController: _alarmTimeController,
                      alarmTitleController: _alarmTitleController,
                      alarmDescriptionController: _alarmDescriptionController,
                      formKey: _formKey,
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
                        "اضف تنبية",
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
                future: _fetchAllAlarms,
                builder:
                    (context, AsyncSnapshot<List<HamlAlarmModel>?> snapshot) {
                  if (snapshot.data == null) {
                    return CommonComponents.loadingDataFromServer();
                  } else {
                    return AlarmScreenWidgets.alarmContentWidget(
                      contentList: (snapshot.data??[]),
                      appBarTitle: "المنبة",
                      image: "assets/images/alarm.png",
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
