import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/init_screen_providers.dart';
import 'package:haml_guide/screens/drawer_screen.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../config/cache_helper.dart';

class MainScreen extends StatefulWidget {
  final int? startIndex;
  const MainScreen({Key? key, this.startIndex}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {

    if(widget.startIndex!=null){
      /*print('${widget.startIndex!} object');
      context
          .read(InitScreenProviders.mainScreenProviders)
          .tabIsSelected(widget.startIndex!);*/
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: CommonComponents.commonAppBar(
        title: Consumer(
          builder: (context, watch, child) => Text(
            watch.watch(InitScreenProviders.mainScreenProviders).bottomBarList[
                watch
                    .watch(InitScreenProviders.mainScreenProviders)
                    .tabIndexSelected]['title'],
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, watch, child) => CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.white,
          animationDuration: const Duration(milliseconds: 300),
          index: context
              .read(InitScreenProviders.mainScreenProviders)
              .tabIndexSelected,
          onTap: (value) {
            context
                .read(InitScreenProviders.mainScreenProviders)
                .tabIsSelected(value);
          },
          items: watch
              .watch(InitScreenProviders.mainScreenProviders)
              .bottomBarList
              .map((tabs) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.0.w, vertical: 10.0.h),
                    decoration: BoxDecoration(
                      color: tabs['selected']
                          ? AppColors.defaultAppColor
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          tabs['image'],
                          color: tabs['selected']
                              ? AppColors.yellowColor
                              : AppColors.greyColor,
                          height: tabs['selected'] ? 13.0.h : 13.0.h,
                          width: tabs['selected'] ? 19.0.w : 17.0.w,
                          cacheHeight: (tabs['selected']
                                  ? (13.0.h * devicePixelRatio).round()
                                  : 13.0.h * devicePixelRatio)
                              .round(),
                          cacheWidth: (tabs['selected']
                                  ? (19.0.w * devicePixelRatio).round()
                                  : 17.0.w * devicePixelRatio)
                              .round(),
                        ),
                        Text(
                          tabs['title'],
                          style: TextStyle(
                            fontSize: 9.0.sp,
                            color: tabs['selected']
                                ? AppColors.yellowColor
                                : AppColors.greyColor,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
      body: Consumer(
        builder: (context, watch, child) =>
            watch.watch(InitScreenProviders.mainScreenProviders).bottomBarList[
                watch
                    .watch(InitScreenProviders.mainScreenProviders)
                    .tabIndexSelected]['page'],
      ),
    );
  }
}
