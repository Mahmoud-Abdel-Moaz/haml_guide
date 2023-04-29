import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/models/names_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

class BabyNamesScreenWidgets {
  static Widget babyTypesFields({
    required String title,
    required String image,
    required Color containerColor,
    required double devicePixelRatio,
  }) {
    return Container(
      padding: EdgeInsets.all(10.0.h),
      decoration: BoxDecoration(
        border: Border.all(color: containerColor),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 70.0.h,
            width: 45.0.w,
            cacheHeight: (70.0.h * devicePixelRatio).round(),
            cacheWidth: (45.0.w * devicePixelRatio).round(),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.0.sp,
              color: AppColors.defaultAppColor,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }

  static Future<dynamic> showNameMeaningWidget(
      {required BuildContext context,
      required String name,
      required String nameMeaning}) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation1, animation2, child) =>
          ScaleTransition(
        scale: animation1,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.0.h),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: AppColors.defaultAppColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0.h),
              Text(
                nameMeaning,
                style: TextStyle(
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.defaultAppColor,
                textStyle:
                    TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.w700),
              ),
              child: const Text("الغاء"),
            )
          ],
        ),
      ),
    );
  }

  static Widget getBabyNamesList({
    required List<NamesModel> babyNames,
    required ScrollController scrollController,
  }) {
    return GridView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 100.0.h,
        crossAxisSpacing: 10.0.w,
        mainAxisSpacing: 10.0.h,
      ),
      itemCount: babyNames.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () async {
          await BabyNamesScreenWidgets.showNameMeaningWidget(
            context: context,
            name:( babyNames[index].name??''),
            nameMeaning: (babyNames[index].nameInfo??''),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10.0.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderGreyColor),
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () async {
                    if ((babyNames[index].isFavourite??false)) {
                      await context
                          .read(ApiProviders.favouriteNamesScreenProvidersApis)
                          .setNameIsFavourite(
                            context: context,
                            nameID: (babyNames[index].nameID??0),
                            status: "تم إزالة الاسم من المفضلة",
                          );
                      if (context.mounted) {
                        context
                            .read(ApiProviders.namesScreenProvidersApis)
                            .setNameFvourite(index: index);
                      } else {
                        return;
                      }
                    } else {
                      await context
                          .read(ApiProviders.favouriteNamesScreenProvidersApis)
                          .setNameIsFavourite(
                            context: context,
                            nameID: (babyNames[index].nameID??0),
                            status: "تم إضافة الاسم في المفضلة",
                          );

                      if (context.mounted) {
                        context
                            .read(ApiProviders.namesScreenProvidersApis)
                            .setNameFvourite(index: index);
                      } else {
                        return;
                      }
                    }
                  },
                  child: Icon(
                    (babyNames[index].isFavourite??false)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 15.0.h,
                    color: AppColors.defaultAppColor,
                  ),
                ),
              ),
              Text(
                babyNames[index].name??'',
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
    );
  }
}
