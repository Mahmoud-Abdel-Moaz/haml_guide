import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/screens/widgets/drawer_screen_widgets/favourite_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _fetchAllNames;
  late BannerAd _myBanner;

  Future<void> getAllNames() async {
    _fetchAllNames = context
        .read(ApiProviders.namesScreenProvidersApis)
        .getNames(context: context);

    return await _fetchAllNames;
  }

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () async {
        await getAllNames();
      },
    );
    _myBanner = CommonComponents.getBannerAds();
    _myBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonComponents.commonAppBar(
        title: Text(
          "المفضله",
          style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          children: [
            TextFormField(
              controller: _searchController,
              style: TextStyle(
                fontSize: 11.0.sp,
                color: AppColors.defaultAppColor,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: "البحث",
                hintStyle: TextStyle(
                  fontSize: 11.0.sp,
                  color: AppColors.defaultAppColor,
                  fontWeight: FontWeight.w700,
                ),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: AppColors.greyColor,
                prefixIconConstraints: BoxConstraints(minHeight: 16.0.h),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.greyColor),
                    borderRadius: BorderRadius.circular(10.0.r)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.greyColor),
                    borderRadius: BorderRadius.circular(10.0.r)),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.greyColor),
                    borderRadius: BorderRadius.circular(10.0.r)),
                disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.greyColor),
                    borderRadius: BorderRadius.circular(10.0.r)),
                constraints: BoxConstraints(maxHeight: 40.0.h),
                contentPadding: EdgeInsets.all(10.0.h),
              ),
              onChanged: (value) {
                context
                    .read(ApiProviders.favouriteNamesScreenProvidersApis)
                    .searchNamesList(context: context, value: value);
              },
            ),
            SizedBox(height: 10.0.h),
            CommonComponents.showBannerAds(_myBanner),
            SizedBox(height: 10.0.h),
            Expanded(
              child: Consumer(
                builder: (context, watch, child) => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: 80.0.h,
                    crossAxisSpacing: 10.0.w,
                    mainAxisSpacing: 10.0.h,
                  ),
                  itemCount: watch
                          .watch(ApiProviders.favouriteNamesScreenProvidersApis)
                          .namesSearchlist
                          .isEmpty
                      ? watch
                          .watch(ApiProviders.namesScreenProvidersApis)
                          .favouriteNames
                          .length
                      : watch
                          .watch(ApiProviders.favouriteNamesScreenProvidersApis)
                          .namesSearchlist
                          .length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () async {
                      await FavouriteScreenWidgets.showNameMeaningWidget(
                        context: context,
                        name: watch
                                .watch(ApiProviders
                                    .favouriteNamesScreenProvidersApis)
                                .namesSearchlist
                                .isEmpty
                            ? (watch
                                .watch(ApiProviders.namesScreenProvidersApis)
                                .favouriteNames[index]
                                .name??'')
                            : (watch
                                .watch(ApiProviders
                                    .favouriteNamesScreenProvidersApis)
                                .namesSearchlist[index]
                                .name??''),
                        nameMeaning: watch
                                .watch(ApiProviders
                                    .favouriteNamesScreenProvidersApis)
                                .namesSearchlist
                                .isEmpty
                            ? (watch
                                .watch(ApiProviders.namesScreenProvidersApis)
                                .favouriteNames[index]
                                .nameInfo??'')
                            : (watch
                                .watch(ApiProviders
                                    .favouriteNamesScreenProvidersApis)
                                .namesSearchlist[index]
                                .nameInfo??''),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.defaultAppColor),
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () async {
                                await context
                                    .read(ApiProviders
                                        .favouriteNamesScreenProvidersApis)
                                    .setNameIsFavourite(
                                      context: context,
                                      nameID: watch
                                          .watch(ApiProviders
                                              .namesScreenProvidersApis)
                                          .favouriteNames[index]
                                          .nameID??0,
                                      status: "تم إزالة الاسم من المفضلة",
                                    );
                                if (!mounted) return;
                                context
                                    .read(ApiProviders.namesScreenProvidersApis)
                                    .removeNameFromFav(
                                        context: context, index: index);
                              },
                              child: Icon(
                                Icons.favorite,
                                size: 20.0.h,
                                color: AppColors.defaultAppColor,
                              ),
                            ),
                          ),
                          Text(
                            watch
                                    .watch(ApiProviders
                                        .favouriteNamesScreenProvidersApis)
                                    .namesSearchlist
                                    .isEmpty
                                ? (watch
                                    .watch(
                                        ApiProviders.namesScreenProvidersApis)
                                    .favouriteNames[index]
                                    .name??'')
                                : (watch
                                    .watch(ApiProviders
                                        .favouriteNamesScreenProvidersApis)
                                    .namesSearchlist[index]
                                    .name??''),
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.defaultAppColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
