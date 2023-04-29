// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/app_colors.dart';

class HamlScreenWidgets {
  static Widget chooseCalendarTypeWidget({
    required String title,
    required void Function() onPress,
    required Color containerColor,
    required Color textColor,
    required Radius topRight,
    required Radius bottomRight,
    required Radius topLeft,
    required Radius bottomLeft,
  }) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 95.0.w,
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0.h),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.only(
            topRight: topRight,
            topLeft: topLeft,
            bottomRight: bottomRight,
            bottomLeft: bottomLeft,
          ),
          border: Border.all(color: AppColors.defaultAppColor),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 12.0.sp, color: textColor),
        ),
      ),
    );
  }

  static Widget calendarDropDownWidget(
      {required BuildContext context,
      required String hint,
      required String validate,
      required List<DropdownMenuItem> items,
      required Function(dynamic) onChanged}) {
    return DropdownButtonFormField(
      validator: (value) => value == null ? validate : null,
      items: items,
      onChanged: onChanged,
      style: TextStyle(fontSize: 13.0.sp, color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13.0.sp, color: AppColors.greyColor),
        errorStyle: TextStyle(fontSize: 14.sp),
        isDense: true,
        contentPadding: EdgeInsets.all(5.0.h),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.defaultAppColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.defaultAppColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.defaultAppColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.defaultAppColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
      ),
    );
  }
}
