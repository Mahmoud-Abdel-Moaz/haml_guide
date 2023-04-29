import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/app_colors.dart';

class WeeksScreenWidgets {
  static Widget weeksFileds(
      {required String title, required String subTitle}) {
    return Container(
      padding: EdgeInsets.all(10.0.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGreyColor),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.0.sp,
              color: AppColors.defaultAppColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.0.h),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 13.0.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
