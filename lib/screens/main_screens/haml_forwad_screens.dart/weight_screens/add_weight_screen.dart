import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/common_content_haml_forward_widgets.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_context/riverpod_context.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({Key? key}) : super(key: key);

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final TextEditingController _weightBeforeHamlController =
      TextEditingController();
  final TextEditingController _weightDateHamlController =
      TextEditingController();
  final TextEditingController _weightNowHamlController =
      TextEditingController();

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
    _weightBeforeHamlController.dispose();
    _weightNowHamlController.dispose();
    _weightDateHamlController.dispose();
    _myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonComponents.commonAppBarForwardHaml(title: "وزن الحامل"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0.h),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              CommonComponents.showBannerAds(_myBanner),
              SizedBox(height: 20.0.h),
              CommonContentHamlForwardWidgets.hamlAddAlerFieldstWidget(
                controller: _weightBeforeHamlController,
                readOnly: false,
                hint: "الوزن ما قبل الحمل",
                type: TextInputType.number,
                action: TextInputAction.next,
                validate: "من فضلك أدخل الوزن ما قبل الحمل",
              ),
              SizedBox(height: 20.0.h),
              CommonContentHamlForwardWidgets.hamlAddAlerFieldstWidget(
                controller: _weightNowHamlController,
                readOnly: false,
                hint: "الوزن الآن",
                type: TextInputType.number,
                action: TextInputAction.next,
                validate: "من فضلك أدخل وزنك الحالي",
              ),
              SizedBox(height: 20.0.h),
              CommonContentHamlForwardWidgets.hamlAddAlerFieldstWidget(
                  controller: _weightDateHamlController,
                  readOnly: true,
                  hint: "تاريخ الوزن الحالي",
                  type: TextInputType.datetime,
                  action: TextInputAction.done,
                  validate: "من فضلك أدخل تاريخ وزنك الحالي",
                  onPress: () async {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    ).then((value) {
                      if (value != null) {
                        _weightDateHamlController.text =
                            DateFormat().add_yMd().format(value);

                        String date =
                            "${value.year}-${(value.month).toString().padLeft(2, "0")}-${(value.day).toString().padLeft(2, "0")}";

                        context
                            .read(ApiProviders.hamlWeigtScreenProvidersApis)
                            .setStartDate(date);
                      }
                    });
                  }),
              SizedBox(height: 30.0.h),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!=null&&_formkey.currentState!.validate()) {
                    context
                        .read(ApiProviders.hamlWeigtScreenProvidersApis)
                        .setUserWeight(
                          context: context,
                          weightNow: _weightNowHamlController.text,
                          weightBefore: _weightBeforeHamlController.text,
                        );
                  }
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.defaultAppColor,
                    minimumSize: Size(double.infinity, 43.0.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w700,
                    )),
                child: const Text("اضافه الوزن"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
