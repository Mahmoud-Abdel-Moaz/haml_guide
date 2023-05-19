import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/banner_custom_model.dart';
import 'package:haml_guide/models/weeks_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/weeks_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../config/cache_helper.dart';

class WeeksScreen extends StatefulWidget {
  const WeeksScreen({Key? key}) : super(key: key);

  @override
  State<WeeksScreen> createState() => _WeeksScreenState();
}

class _WeeksScreenState extends State<WeeksScreen> {
  Future<WeeksModel?>? _getWeeksData;
 late AutoScrollController _scrollController;
 late InterstitialAd _interstitialAd;
  late BannerAd _myBanner;
 late Future<List<BannerCustomModel>?> _bannerCustom;

  Future<WeeksModel?> _fetchWeeksData() async {
    _getWeeksData = context
        .read(ApiProviders.weeksScreenProvidersApis)
        .getWeeksData(context: context);
    return await _getWeeksData;
  }

  Future<List<BannerCustomModel>?> _getBannerCustom() async {
    _bannerCustom = context
        .read(ApiProviders.weeksScreenProvidersApis)
        .getBunnerCustom(context: context);
    return await _bannerCustom;
  }

  Future<void> _getuserCountry() async {
    await context.read(ApiProviders.userLocationProviders).getUserLocation();
  }

  @override
  void initState() {
    CacheHelper.saveData(key: 'start_index', value: 2);

    // CommonComponents.createIntersitial(_interstitialAd);

    Future.delayed(Duration.zero, () async {
      int userWeekNumber =
          await CommonComponents.getSavedData(ApiKeys.userWeekNumber);

      if (!mounted) return;
      context
          .read(ApiProviders.weeksScreenProvidersApis)
          .selectWeekNumber(userWeekNumber ?? 1);
      await _getuserCountry();
      await _getBannerCustom();
      await _fetchWeeksData();
      setState(() {});
      _scrollController = AutoScrollController(axis: Axis.horizontal);

      WidgetsBinding.instance.addPostFrameCallback((_) async =>
          await _scrollController.scrollToIndex((context
                  .read(ApiProviders.weeksScreenProvidersApis)
                  .weekNumberSelected??0) +
              2));
    });
    _myBanner = CommonComponents.getBannerAds();
    _myBanner.load();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _scrollController = AutoScrollController(axis: Axis.horizontal);

    WidgetsBinding.instance.addPostFrameCallback((_) async =>
        await _scrollController.scrollToIndex((context
            .read(ApiProviders.weeksScreenProvidersApis)
            .weekNumberSelected??0)));
    super.didChangeDependencies();
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
      body: Consumer(
        builder: (context, watch, child) =>_getWeeksData!=null? FutureBuilder(
            key: ValueKey(watch
                .watch(ApiProviders.weeksScreenProvidersApis)
                .weekBuilderKey),
            future: Future.wait([_getWeeksData!, _bannerCustom]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.data == null) {
                return CommonComponents.loadingDataFromServer();
              } else {
                WeeksModel weeksData = snapshot.data![0];
                List<BannerCustomModel> bannersCustom = snapshot.data![1];
                //check snapshot
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0.h),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100.0.h,
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10.0.w),
                          itemCount: 40,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async {
                              context
                                  .read(ApiProviders.weeksScreenProvidersApis)
                                  .selectWeekNumber(index + 1);

                              didChangeDependencies();

                              context
                                  .read(ApiProviders.weeksScreenProvidersApis)
                                  .refreshWeekKeyBuilder();

                              _getWeeksData = context
                                  .read(ApiProviders.weeksScreenProvidersApis)
                                  .getWeeksData(context: context);
                            },
                            child: AutoScrollTag(
                              controller: _scrollController,
                              index: index,
                              key: ValueKey(index),
                              child: Container(
                                padding: EdgeInsets.all(15.0.h),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.defaultAppColor),
                                  color: watch
                                              .watch(ApiProviders
                                                  .weeksScreenProvidersApis)
                                              .weekNumberSelected ==
                                          index + 1
                                      ? AppColors.defaultAppColor
                                      : Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: watch
                                                    .watch(ApiProviders
                                                        .weeksScreenProvidersApis)
                                                    .weekNumberSelected ==
                                                index + 1
                                            ? Colors.white
                                            : AppColors.defaultAppColor,
                                      ),
                                    ),
                                    Text(
                                      "أسبوع",
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: watch
                                                    .watch(ApiProviders
                                                        .weeksScreenProvidersApis)
                                                    .weekNumberSelected ==
                                                index + 1
                                            ? Colors.white
                                            : AppColors.defaultAppColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Text(
                        "انت الأن في ${weeksData.title}",
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.defaultAppColor,
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      Text(
                        "نبذه عنك",
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.defaultAppColor,
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      WeeksScreenWidgets.weeksFileds(
                        title: "ماما",
                        subTitle: weeksData.section1??'',
                      ),
                      SizedBox(height: 10.0.h),
                      SizedBox(
                        height: 100.0.h,
                        child: bannersCustom.isNotEmpty
                            ? ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, bannerIndex) =>
                                    SizedBox(width: 10.0.w),
                                itemCount: bannersCustom.length,
                                itemBuilder: (context, bannerIndex) => InkWell(
                                      onTap: () async {
                                        /*await CommonComponents.launchOnBrowser(
                                            url: bannersCustom[bannerIndex].url,
                                            context: context);*/
                                        if(bannersCustom[
                                        bannerIndex]
                                            .url!=null) {
                                          if(bannersCustom[
                                          bannerIndex]
                                              .url!.toLowerCase().startsWith('tel:')){
                                            makeCall(bannersCustom[
                                            bannerIndex]
                                                .url!.toLowerCase().replaceFirst('tel:', ''));
                                          }else{
                                            launchUrlFun(bannersCustom[
                                            bannerIndex]
                                                .url!);
                                          }
                                        }
                                      },
                                      child: Image.network(
                                        bannersCustom[bannerIndex].image??'',
                                        height: 100.0.h,
                                        width: 290.0.w,
                                        fit: BoxFit.contain,
                                        cacheHeight:
                                            (100.0.h * devicePixelRatio)
                                                .round(),
                                        cacheWidth: (290.0.w * devicePixelRatio)
                                            .round(),
                                      ),
                                    ))
                            : CommonComponents.showBannerAds(_myBanner),
                      ),
                      SizedBox(height: 10.0.h),
                      Text(
                        "نبذه عن الطفل",
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: AppColors.defaultAppColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                      WeeksScreenWidgets.weeksFileds(
                        title: "الجنين",
                        subTitle:( weeksData.section2??''),
                      ),
                      SizedBox(height: 10.0.h),
                      WeeksScreenWidgets.weeksFileds(
                        title: "فحوصات - نصائح - محاذ ير",
                        subTitle:( weeksData.section3??''),
                      ),
                      SizedBox(height: 10.0.h),
                    ],
                  ),
                );
              }
            }):const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
