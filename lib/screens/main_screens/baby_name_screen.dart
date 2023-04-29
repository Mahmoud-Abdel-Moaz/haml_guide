import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/enums.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/baby_names_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

class BabyNameScreen extends StatefulWidget {
  const BabyNameScreen({Key? key}) : super(key: key);

  @override
  State<BabyNameScreen> createState() => _BabyNameScreenState();
}

class _BabyNameScreenState extends State<BabyNameScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  InterstitialAd? _interstitialAd;
  Future<void>? _fetchAllNames;

  Future<void> getAllNames() async {
    _fetchAllNames = context
        .read(ApiProviders.namesScreenProvidersApis)
        .getNames(context: context);

    return await _fetchAllNames;
  }

  @override
  void initState() {
    context.refresh(ApiProviders.namesScreenProvidersApis);
    context.refresh(InitScreenProviders.babyNamesProviders);

    Future.delayed(
      Duration.zero,
      () async {
        _scrollController.addListener(() async {
          if (context
              .read(ApiProviders.namesScreenProvidersApis)
              .namesSearchlist
              .isEmpty) {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              context
                  .read(ApiProviders.namesScreenProvidersApis)
                  .incrementPageNumber();
              await getAllNames();
            }
          }
        });
        await getAllNames();
        CommonComponents.createIntersitial(_interstitialAd);
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) => Padding(
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
                  prefixIcon: InkWell(
                      onTap: () async {
                        if (_searchController.text.isNotEmpty) {
                          await context
                              .read(ApiProviders.namesScreenProvidersApis)
                              .getSearchedNames(
                                  context: context,
                                  value: _searchController.text);
                        } else {
                          await context
                              .read(ApiProviders.namesScreenProvidersApis)
                              .getNames(context: context);
                        }
                      },
                      child: const Icon(Icons.search)),
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
                onFieldSubmitted: (value)async{
                  if (_searchController.text.isNotEmpty) {
                    await context
                        .read(ApiProviders.namesScreenProvidersApis)
                        .getSearchedNames(
                        context: context,
                        value: _searchController.text);
                  } else {
                    await context
                        .read(ApiProviders.namesScreenProvidersApis)
                        .getNames(context: context);
                  }
                },
              ),
              SizedBox(height: 10.0.h),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.refresh(ApiProviders.namesScreenProvidersApis);

                        context
                            .read(InitScreenProviders.babyNamesProviders)
                            .babyNamesIsSelected(UserSelectedBabyNames.boy);

                        context
                            .read(ApiProviders.namesScreenProvidersApis)
                            .setNameFilter("Male");

                        _fetchAllNames = context
                            .read(ApiProviders.namesScreenProvidersApis)
                            .getNames(context: context);
                      },
                      child: BabyNamesScreenWidgets.babyTypesFields(
                        title: "ولد",
                        image: "assets/images/boy.png",
                        devicePixelRatio: devicePixelRatio,
                        containerColor: watch
                                    .watch(
                                        InitScreenProviders.babyNamesProviders)
                                    .userSelectedBabyNames ==
                                UserSelectedBabyNames.boy
                            ? AppColors.defaultAppColor
                            : AppColors.borderGreyColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        context.refresh(ApiProviders.namesScreenProvidersApis);
                        context
                            .read(InitScreenProviders.babyNamesProviders)
                            .babyNamesIsSelected(UserSelectedBabyNames.girl);

                        context
                            .read(ApiProviders.namesScreenProvidersApis)
                            .setNameFilter("Female");

                        _fetchAllNames = context
                            .read(ApiProviders.namesScreenProvidersApis)
                            .getNames(context: context);
                      },
                      child: BabyNamesScreenWidgets.babyTypesFields(
                        title: "بنت",
                        image: "assets/images/girl.png",
                        devicePixelRatio: devicePixelRatio,
                        containerColor: watch
                                    .watch(
                                        InitScreenProviders.babyNamesProviders)
                                    .userSelectedBabyNames ==
                                UserSelectedBabyNames.girl
                            ? AppColors.defaultAppColor
                            : AppColors.borderGreyColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0.h),
              Expanded(
                child: BabyNamesScreenWidgets.getBabyNamesList(
                  scrollController: _scrollController,
                  babyNames: watch
                          .watch(ApiProviders.namesScreenProvidersApis)
                          .namesSearchlist
                          .isEmpty
                      ? watch
                          .watch(ApiProviders.namesScreenProvidersApis)
                          .allNames
                      : watch
                          .watch(ApiProviders.namesScreenProvidersApis)
                          .namesSearchlist,
                ),
              )
            ],
          ),
        ),
        //   }
        // }),
      ),
    );
  }
}
