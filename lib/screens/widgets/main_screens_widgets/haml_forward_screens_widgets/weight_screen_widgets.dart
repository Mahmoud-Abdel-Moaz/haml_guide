import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_weight_model.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/haml_forward_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_context/riverpod_context.dart';

class WeightScreenWidgets {
  static Widget weightContentWidget({
    required List<HamlWeightModel> contentList,
    required String appBarTitle,
    required String image,
  }) {
    print('WeightScreenWidgets ${appBarTitle} ${image}');

    return Expanded(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 10.0.h),
        itemCount: contentList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            print('click WeightScreenWidgets ');
           navigateTo(context, HamlForwardDetailsScreen(
             appBarTitle: appBarTitle,
             description: (contentList[index].description??''),
             image: image,
             title:
             " معدل الزيادة الحالي هو ${double.parse((contentList[index].weightNow??'0')) - double.parse((contentList[index].weightBefore??'0'))}",
           ));
            /*Navigator.pushNamed(
              context,
              PATHS.forwardHamlDetails,
              arguments: HamlForwardDetailsScreen(
                appBarTitle: appBarTitle,
                description: (contentList[index].description??''),
                image: image,
                title:
                    " معدل الزيادة الحالي هو ${double.parse((contentList[index].weightNow??'0')) - double.parse((contentList[index].weightBefore??'0'))}",
              ),
            );*/
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
                      await CommonComponents.deleteForwardHamlItemListAlert(
                        context: context,
                        onPress: () async {
                          await context
                              .read(ApiProviders.hamlWeigtScreenProvidersApis)
                              .deleteWeightItem(
                                context: context,
                                weightID: (contentList[index].weightID??0),
                              );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.0.h),
                      child: Icon(Icons.close, size: 16.0.sp),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (contentList[index].weekName??''),
                      style: TextStyle(
                        fontSize: 11.0.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.defaultAppColor,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 14.0.h,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(width: 5.0.w),
                        Text(
                          DateFormat.yMEd()
                              .format(
                                  DateTime.parse((contentList[index].startDate??'')))
                              .toString(),
                          style: TextStyle(
                            fontSize: 7.0.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0.h),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "الوزن في ${contentList[index].weekName}",
                    style: TextStyle(
                      fontSize: 11.0.sp,
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                      text: "  ${contentList[index].weightNow} كيلو",
                      style: TextStyle(
                        fontSize: 11.0.sp,
                        color: AppColors.defaultAppColor,
                        fontWeight: FontWeight.w700,
                      ))
                ])),
                SizedBox(height: 10.0.h),
                Text(
                  (contentList[index].description??''),
                  style: TextStyle(
                    fontSize: 12.0.sp,
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
