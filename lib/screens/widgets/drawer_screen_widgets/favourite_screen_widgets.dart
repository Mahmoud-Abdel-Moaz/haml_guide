import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/app_colors.dart';

class FavouriteScreenWidgets {
  static Future<dynamic> showNameMeaningWidget({
    required BuildContext context,
    required String name,
    required String nameMeaning,
  }) async {
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
}
