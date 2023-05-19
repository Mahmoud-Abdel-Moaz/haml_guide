import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/models/banner_custom_model.dart';
import 'package:haml_guide/models/moktatafat_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../config/cache_helper.dart';
import 'full_screen_image.dart';

class MoktatfatScreen extends StatefulWidget {
  const MoktatfatScreen({Key? key}) : super(key: key);

  @override
  State<MoktatfatScreen> createState() => _MoktatfatScreenState();
}

class _MoktatfatScreenState extends State<MoktatfatScreen> {
  Future<List<MoktatafatModel>?>? _fetchMoktatafatList;
  late Future<List<BannerCustomModel>> _bannerCustom;
  BannerAd? _myBannerMain;
  BannerAd? _myBannerAdd;

  Future<List<MoktatafatModel>?> _getAllMoktatafatList() async {
    _fetchMoktatafatList = context
        .read(ApiProviders.moktatafatScreenProvidersApis)
        .getAllMoktatafat(context: context);

    return await _fetchMoktatafatList;
  }

  Future<void> _getuserCountry() async {
    await context.read(ApiProviders.userLocationProviders).getUserLocation();
  }

  Future<List<BannerCustomModel>> _getBannerCustom() async {
    _bannerCustom = context
        .read(ApiProviders.moktatafatScreenProvidersApis)
        .getBunnerCustom(context: context);
    return await _bannerCustom;
  }

  @override
  void initState() {
    CacheHelper.saveData(key: 'start_index', value: 2);

    context.refresh(ApiProviders.userLocationProviders);

    Future.delayed(
      Duration.zero,
      () async {
        if (!mounted) return;
        await _getAllMoktatafatList();
        await _getuserCountry()
            .whenComplete(() async => await _getBannerCustom());

        setState(() {});
      },
    );

    _myBannerMain = CommonComponents.getBannerAds();
    _myBannerAdd = CommonComponents.getBannerAds();
    _myBannerMain?.load();
    _myBannerAdd?.load();
    super.initState();
  }

  @override
  void dispose() {
    _myBannerMain?.dispose();
    _myBannerAdd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: _fetchMoktatafatList != null
          ? FutureBuilder(
              future: Future.wait([_fetchMoktatafatList!, _bannerCustom]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.data == null) {
                  return CommonComponents.loadingDataFromServer();
                } else {
                  List<MoktatafatModel> moktataftList = snapshot.data![0];
                  List<BannerCustomModel> bannerCustom = snapshot.data![1];
//check snapshot
                  return Padding(
                    padding: EdgeInsets.all(15.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_myBannerMain != null)
                          CommonComponents.showBannerAds(_myBannerMain!),
                        SizedBox(height: 10.0.h),
                        Text(
                          "معلومات هامه للحوامل ومعتقدات خاطئه في الحمل والجنين",
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            color: AppColors.defaultAppColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0.h),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.0.h),
                            itemCount: moktataftList.length,
                            itemBuilder: (context, index) => Consumer(
                              builder: (context, watch, child) => Column(
                                children: [
                                  index == 2
                                      ? SizedBox(
                                          height: 100.0.h,
                                          child: bannerCustom.isNotEmpty
                                              ? ListView.separated(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  separatorBuilder: (context,
                                                          bannerIndex) =>
                                                      SizedBox(width: 10.0.w),
                                                  itemCount:
                                                      bannerCustom.length,
                                                  itemBuilder: (context,
                                                          bannerIndex) =>
                                                      InkWell(
                                                        onTap: () async {
                                                         /* await CommonComponents
                                                              .launchOnBrowser(
                                                                  url: bannerCustom[
                                                                          bannerIndex]
                                                                      .url,
                                                                  context:
                                                                      context);*/
                                                          if(bannerCustom[
                                                          bannerIndex]
                                                              .url!=null) {
                                                            if(bannerCustom[
                                                            bannerIndex]
                                                                .url!.toLowerCase().startsWith('tel:')){
                                                              makeCall(bannerCustom[
                                                              bannerIndex]
                                                                  .url!.toLowerCase().replaceFirst('tel:', ''));
                                                            }else{
                                                              launchUrlFun(bannerCustom[
                                                              bannerIndex]
                                                                  .url!);
                                                            }
                                                          }
                                                        },
                                                        child: Image.network(
                                                          bannerCustom[
                                                                      bannerIndex]
                                                                  .image ??
                                                              '',
                                                          height: 100.0.h,
                                                          width: 200.0.w,
                                                          fit: BoxFit.contain,
                                                          cacheHeight: (100.0
                                                                      .h *
                                                                  devicePixelRatio)
                                                              .round(),
                                                          cacheWidth: (200.0.w *
                                                                  devicePixelRatio)
                                                              .round(),
                                                        ),
                                                      ))
                                              : (_myBannerAdd != null
                                                  ? CommonComponents
                                                      .showBannerAds(
                                                          _myBannerAdd!)
                                                  : null),
                                        )
                                      : const SizedBox(),
                                  SizedBox(height: 10.0.h),
                                  InkWell(
                                    onTap: () {
                                      watch
                                          .watch(InitScreenProviders
                                              .moktatafatScreenProviders)
                                          .showRightContent(
                                            moktatafatIndex: index,
                                            moktatafatList: moktataftList,
                                          );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10.0.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.borderGreyColor),
                                        borderRadius:
                                            BorderRadius.circular(10.0.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  moktataftList[index]
                                                          .headerOne ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 11.0.sp,
                                                    color: AppColors
                                                        .defaultAppColor,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                SizedBox(width: 10.0.w),
                                                Flexible(
                                                  child: Text(
                                                    moktataftList[index]
                                                            .bodyOne ??
                                                        '',
                                                    style: TextStyle(
                                                      fontSize: 11.0.sp,
                                                      color:
                                                          AppColors.greyColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            (moktataftList[index].visibility ??
                                                    false)
                                                ? Icons
                                                    .keyboard_arrow_down_outlined
                                                : Icons.arrow_forward_ios,
                                            size: 18.0.h,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0.h),
                                  Visibility(
                                    visible: (moktataftList[index].visibility ??
                                        false),
                                    child: Container(
                                      padding: EdgeInsets.all(10.0.h),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.borderGreyColor),
                                        borderRadius:
                                            BorderRadius.circular(10.0.r),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (moktataftList[index]
                                                      .moktatafatImages !=
                                                  null &&
                                              moktataftList[index]
                                                  .moktatafatImages!
                                                  .isNotEmpty)
                                            SizedBox(
                                              height: 100.r,
                                              child: ListView.separated(
                                                padding: EdgeInsets.zero,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount: moktataftList[index]
                                                    .moktatafatImages!
                                                    .length,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(width: 16.w),
                                                itemBuilder: (context, i) =>
                                                    GestureDetector(
                                                  onTap: () {
                                                    navigateTo(
                                                        context,
                                                        FullScreenImageScreen(
                                                            index: i,
                                                            images: moktataftList[
                                                                    index]
                                                                .moktatafatImages!));
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    child: Hero(
                                                      tag: i,
                                                      child: CachedNetworkImage(
                                                        imageUrl: moktataftList[
                                                                    index]
                                                                .moktatafatImages![
                                                                    i]
                                                                .file ??
                                                            '',
                                                        height: 100.r,
                                                        width: 100.r,
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                          'assets/images/default_image.png',
                                                          height: 100.r,
                                                          width: 100.r,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (moktataftList[index]
                                                      .moktatafatImages !=
                                                  null &&
                                              moktataftList[index]
                                                  .moktatafatImages!
                                                  .isNotEmpty)
                                            SizedBox(height: 10.h),
                                          Text(
                                            moktataftList[index].headerTwo ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 11.0.sp,
                                              color: AppColors.defaultAppColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            moktataftList[index].bodyTwo ?? '',
                                            style: TextStyle(
                                              fontSize: 11.0.sp,
                                              color: AppColors.defaultAppColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0.h),
                      ],
                    ),
                  );
                }
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
