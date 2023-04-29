import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/common_content_haml_forward_widgets.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/kicks_screen_widgets.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_context/riverpod_context.dart';

class AddRklatScreen extends StatefulWidget {
  const AddRklatScreen({Key? key}) : super(key: key);

  @override
  State<AddRklatScreen> createState() => _AddRklatScreenState();
}

class _AddRklatScreenState extends State<AddRklatScreen> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _rklatCountController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  late BannerAd _myBanner;

  @override
  void initState() {
    _myBanner = CommonComponents.getBannerAds();
    _myBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    _rklatCountController.dispose();
    _myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonComponents.commonAppBarForwardHaml(title: "ركلات الجنين"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0.h),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              CommonComponents.showBannerAds(_myBanner),
              SizedBox(height: 20.0.h),
              Text(
                "احسبي عدد حركات طفلك مرة في اليوم، يجب أن تشعري بعدد 6 حركات او اكثر في مدة ساعتين.اذا حسبتي عدداً اقل من 6 حركات في مدة ساعتين لا تنتظري، توجهي الي أقرب مستشفى أو وحدة ولادة.يجب أن تستشعري حركات طفلك طوال اليوم، وذلك كل يوم منذ أن يصل حملك الي 28 اسبوعاً وحتى يُولد الطفل.",
                style: TextStyle(
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20.0.h),
              CommonContentHamlForwardWidgets.hamlAddAlerFieldstWidget(
                  controller: _startTimeController,
                  readOnly: true,
                  hint: "بدايه التوقيت",
                  type: TextInputType.datetime,
                  action: TextInputAction.done,
                  validate: "من فضلك أدخل بداية التوقيت",
                  prefixIcon: const Icon(Icons.alarm),
                  onPress: () async {
                    KicksScreenWidgets.kickTimeWidget(
                      context: context,
                      onPress: () {
                        _startTimeController.text = "";
                        Navigator.pop(context);
                      },
                      timeChanged: (value) {
                        _startTimeController.text =
                            TimeOfDay.fromDateTime(value).format(context);
                        String startDate = DateTime.parse(
                          "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${value.hour.toString().padLeft(2, "0")}:${(value.minute).toString().padLeft(2, "0")}",
                        ).toIso8601String();

                        context
                            .read(ApiProviders.kicksScreenProvidersApis)
                            .setStartDate(startDate);
                      },
                    );
                  }),
              SizedBox(height: 20.0.h),
              CommonContentHamlForwardWidgets.hamlAddAlerFieldstWidget(
                  controller: _endTimeController,
                  readOnly: true,
                  hint: "نهاية التوقيت",
                  type: TextInputType.datetime,
                  action: TextInputAction.done,
                  validate: "من فضلك أدخل نهاية التوقيت",
                  prefixIcon: const Icon(Icons.alarm),
                  onPress: () async {
                    await KicksScreenWidgets.kickTimeWidget(
                      context: context,
                      onPress: () {
                        _endTimeController.text = "";
                        Navigator.pop(context);
                      },
                      timeChanged: (value) {
                        _endTimeController.text =
                            TimeOfDay.fromDateTime(value).format(context);
                        String endDate = DateTime.parse(
                          "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${value.hour.toString().padLeft(2, "0")}:${(value.minute).toString().padLeft(2, "0")}",
                        ).toIso8601String();

                        context
                            .read(ApiProviders.kicksScreenProvidersApis)
                            .setEndDate(endDate);
                      },
                    ); // await showTimePicker(
                    //   context: context,
                    //   initialTime: TimeOfDay.now(),
                    // ).then((value) {
                    //   if (value != null) {
                    //     _endTimeController.text = value.format(context);
                    //     String endDate = DateTime.parse(
                    //       "${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${value.hour.toString().padLeft(2, "0")}:${(value.minute).toString().padLeft(2, "0")}",
                    //     ).toIso8601String();

                    //     context
                    //         .read(ApiProviders.kicksScreenProvidersApis)
                    //         .setEndDate(endDate);
                    //   }
                    // });
                  }),
              SizedBox(height: 20.0.h),
              CommonContentHamlForwardWidgets.hamlAddAlerFieldstWidget(
                controller: _rklatCountController,
                readOnly: false,
                hint: "عدد الركلات",
                type: TextInputType.number,
                action: TextInputAction.done,
                validate: "من فضلك أدخل عدد الركلات",
              ),
              SizedBox(height: 30.0.h),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!=null&&_formkey.currentState!.validate()) {
                    await context
                        .read(ApiProviders.kicksScreenProvidersApis)
                        .userAddKicks(
                          context: context,
                          kicksCount: _rklatCountController.text,
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w700),
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.defaultAppColor,
                  minimumSize: Size(double.infinity, 43.0.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                ),
                child: const Text("ارسال"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
