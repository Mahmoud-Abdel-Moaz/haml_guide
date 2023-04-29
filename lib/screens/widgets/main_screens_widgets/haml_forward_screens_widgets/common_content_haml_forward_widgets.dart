import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/app_colors.dart';

class CommonContentHamlForwardWidgets {
  static Widget hamlAddAlerFieldstWidget({
    required TextEditingController controller,
    required bool readOnly,
    required String hint,
    required TextInputType type,
    required TextInputAction action,
    required String validate,
    int maxLines = 1,
    Widget? prefixIcon,
    Function()? onPress,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: type,
      textInputAction: action,
      maxLines: maxLines,
      onTap: onPress,
      validator: (value) => value!=null&&value.isEmpty ? validate : null,
      style: TextStyle(
        fontSize: 11.0.sp,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 11.0.sp,
          color: AppColors.greyColor,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderGreyColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderGreyColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderGreyColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderGreyColor),
          borderRadius: BorderRadius.circular(10.0.r),
        ),
        contentPadding: EdgeInsets.all(5.0.h),
        // constraints: BoxConstraints(maxHeight: 40.0.h),

        isDense: true,
        prefixIcon: prefixIcon ?? const SizedBox(),
        prefixIconColor: AppColors.greyColor,

        prefixIconConstraints:
            BoxConstraints(minWidth: prefixIcon != null ? 30.0.w : 10.0.w),
      ),
    );
  }
}
