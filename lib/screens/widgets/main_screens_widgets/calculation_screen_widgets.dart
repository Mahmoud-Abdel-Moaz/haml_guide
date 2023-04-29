import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/app_colors.dart';

class CalculationScreenWidgets {
  static Widget calculationFileds(
      {required String title, required String subTitle}) {
    return Container(
      height: 71.0.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderGreyColor),
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11.0.sp,
              color: AppColors.defaultAppColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5.0.h),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 15.0.sp,
              color: AppColors.defaultAppColor,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
