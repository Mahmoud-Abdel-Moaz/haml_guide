import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_kicks_model.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/haml_forward_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_context/riverpod_context.dart';

class KicksScreenWidgets {
  static Widget kicksContentWidget({
    required List<HamlKicksModel> kicksContentList,
    required String appBarTitle,
    required String image,
  }) {
    return Expanded(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 10.0.h),
        itemCount: kicksContentList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              PATHS.forwardHamlDetails,
              arguments: HamlForwardDetailsScreen(
                appBarTitle: appBarTitle,
                description: (kicksContentList[index].description??''),
                image: image,
                title: "ركلات الجنين هو ${kicksContentList[index].kickCount}",
              ),
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
                      await CommonComponents.deleteForwardHamlItemListAlert(
                        context: context,
                        onPress: () async {
                          await context
                              .read(ApiProviders.kicksScreenProvidersApis)
                              .deleteRklatItem(
                                context: context,
                                rklatID: (kicksContentList[index].kickID??0),
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
                      "من:  ${TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].startDateAndTime??''))).period.name == "pm" ? (TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].startDateAndTime??''))).hour + 2) - 12 : (TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].startDateAndTime??''))).hour + 2)}:${TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].startDateAndTime??''))).minute} ${TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].startDateAndTime??''))).period.name} \n إالي : ${TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].endDateAndTime??''))).period.name == "pm" ? (TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].endDateAndTime??''))).hour + 2) - 12 : TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].endDateAndTime??''))).hour + 2}:${TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].endDateAndTime??''))).minute} ${TimeOfDay.fromDateTime(DateTime.parse((kicksContentList[index].endDateAndTime??''))).period.name}",
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
                              .format(DateTime.parse(
                                  (kicksContentList[index].startDateAndTime??'')))
                              .toString(),
                          style: TextStyle(
                            fontSize: 10.0.sp,
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
                    text: "عدد الركلات",
                    style: TextStyle(
                      fontSize: 11.0.sp,
                      color: AppColors.greyColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                      text: "  ${kicksContentList[index].kickCount}",
                      style: TextStyle(
                        fontSize: 11.0.sp,
                        color: AppColors.defaultAppColor,
                        fontWeight: FontWeight.w700,
                      ))
                ])),
                SizedBox(height: 10.0.h),
                Text(
                  (kicksContentList[index].description??''),
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

  static Future<void> kickTimeWidget({
    required BuildContext context,
    required Function(DateTime) timeChanged,
    required void Function() onPress,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "اختر التوقيت",
              style: TextStyle(
                fontSize: 14.0.sp,
                color: AppColors.defaultAppColor,
              ),
            ),
            TimePickerSpinner(
              time: DateTime.now(),
              alignment: Alignment.center,
              is24HourMode: false,
              itemHeight: 50.0.h,
              highlightedTextStyle: TextStyle(
                  color: AppColors.defaultAppColor, fontSize: 18.0.sp),
              normalTextStyle:
                  TextStyle(fontSize: 16.0.sp, color: AppColors.greyColor),
              onTimeChange: timeChanged,
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.defaultAppColor,
              textStyle: TextStyle(fontSize: 14.0.sp),
              minimumSize: Size(100.0.w, 30.0.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0.r)),
            ),
            child: const Text("موافق"),
          ),
          SizedBox(width: 10.0.w),
          ElevatedButton(
            onPressed: onPress,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.defaultAppColor,
              textStyle: TextStyle(fontSize: 14.0.sp),
              minimumSize: Size(100.0.w, 30.0.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0.r)),
            ),
            child: const Text("إلغاء"),
          )
        ],
      ),
    );
  }
}
