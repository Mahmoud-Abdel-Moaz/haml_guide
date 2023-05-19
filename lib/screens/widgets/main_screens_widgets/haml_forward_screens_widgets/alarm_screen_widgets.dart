import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_alarm_model.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/haml_forward_details_screen.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/common_content_haml_forward_widgets.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_context/riverpod_context.dart';

class AlarmScreenWidgets {
  static Future<dynamic> alarmAlertWidget({
    required BuildContext context,
    required TextEditingController alarmDateController,
    required TextEditingController alarmTimeController,
    required TextEditingController alarmTitleController,
    required TextEditingController alarmDescriptionController,
    required GlobalKey<FormState> formKey,
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
                content: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.0.h),
                        Center(
                          child: Text(
                            "اضافه منبه",
                            style: TextStyle(
                              fontSize: 15.0.sp,
                              color: AppColors.defaultAppColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        CommonContentHamlForwardWidgets
                            .hamlAddAlerFieldstWidget(
                          controller: alarmDateController,
                          readOnly: true,
                          hint: "التاريخ",
                          type: TextInputType.datetime,
                          action: TextInputAction.next,
                          validate: "من فضلك ادخل التاريخ",
                          prefixIcon: const Icon(Icons.calendar_month),
                          onPress: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            ).then((value) {
                              if (value != null) {
                                alarmDateController.text =
                                    DateFormat().add_yMd().format(value);

                                context
                                    .read(ApiProviders.hamlAlarmScreenProviders)
                                    .setDateForUser(DateFormat('yyyy-MM-dd')
                                        .format(value)
                                        .toString());
                              }
                            });
                          },
                        ),
                        SizedBox(height: 10.0.h),
                        CommonContentHamlForwardWidgets
                            .hamlAddAlerFieldstWidget(
                                controller: alarmTimeController,
                                readOnly: true,
                                hint: "الوقت",
                                type: TextInputType.datetime,
                                action: TextInputAction.next,
                                validate: "من فضلك ادخل الوقت",
                                prefixIcon: const Icon(Icons.alarm),
                                onPress: () async {
                                  await alarmTimeWidget(
                                    context: context,
                                    onPress: () {
                                      alarmTimeController.text = "";
                                      Navigator.pop(context);
                                    },
                                    timeChanged: (value) {
                                      alarmTimeController.text =
                                          TimeOfDay.fromDateTime(value)
                                              .format(context);
                                      context
                                          .read(ApiProviders
                                              .hamlAlarmScreenProviders)
                                          .setTimeForUser(
                                              alarmTimeController.text);
                                      context
                                          .read(ApiProviders
                                              .hamlAlarmScreenProviders)
                                          .setTimeForUserIn24Hours(
                                            "${value.hour.toString().padLeft(2, "0")}:${(value.minute).toString().padLeft(2, "0")}",
                                          );
                                    },
                                  );
                                }),
                        SizedBox(height: 10.0.h),
                        CommonContentHamlForwardWidgets
                            .hamlAddAlerFieldstWidget(
                          controller: alarmTitleController,
                          readOnly: false,
                          hint: "عنوان التنبية",
                          type: TextInputType.text,
                          action: TextInputAction.next,
                          validate: "من فضلك أدخل عنوان التنبية",
                        ),
                        SizedBox(height: 10.0.h),
                        CommonContentHamlForwardWidgets
                            .hamlAddAlerFieldstWidget(
                          controller: alarmDescriptionController,
                          readOnly: false,
                          hint: "نص التنبية",
                          type: TextInputType.text,
                          action: TextInputAction.done,
                          validate: "من فضلك أدخل نص الرسالة",
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!=null&&formKey.currentState!.validate()) {
                        context
                            .read(ApiProviders.hamlAlarmScreenProviders)
                            .setDateAndTimeToIso(
                              DateTime.parse(
                                      "${context.read(ApiProviders.hamlAlarmScreenProviders).dateForUser} ${context.read(ApiProviders.hamlAlarmScreenProviders).timeForuserIn24Hours}")
                                  .toIso8601String(),
                            );
                        //DateTime.now().millisecondsSinceEpoch;
                        await context
                            .read(ApiProviders.hamlAlarmScreenProviders)
                            .setUserAlarm(
                              context: context,
                              title: alarmTitleController.text,
                              description: alarmDescriptionController.text,
                            );

                        alarmDateController.clear();
                        alarmTitleController.clear();
                        alarmDescriptionController.clear();
                        alarmTimeController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.defaultAppColor,
                      minimumSize: Size(180.0.w, 30.0.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0.r)),
                      textStyle: TextStyle(
                          fontSize: 13.0.sp, fontWeight: FontWeight.w700),
                    ),
                    child: const Text("اضافه منبه"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      alarmDateController.clear();
                      alarmTitleController.clear();
                      alarmDescriptionController.clear();
                      alarmTimeController.clear();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.defaultAppColor,
                      textStyle: TextStyle(
                          fontSize: 13.0.sp, fontWeight: FontWeight.w700),
                    ),
                    child: const Text("الغاء"),
                  )
                ],
              ),
            ));
  }

  static Widget alarmContentWidget({
    required List<HamlAlarmModel> contentList,
    required String appBarTitle,
    required String image,
  }) {
    return Expanded(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(height: 10.0.h),
        itemCount: contentList.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {

            navigateTo(context, HamlForwardDetailsScreen(
              appBarTitle: appBarTitle,
              description: contentList[index].description??'',
              image: image,
              title: "المنبة",
            ),);

            /*Navigator.pushNamed(
              context,
              PATHS.forwardHamlDetails,
              arguments: HamlForwardDetailsScreen(
                appBarTitle: appBarTitle,
                description: contentList[index].description??'',
                image: image,
                title: "المنبة",
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
                              .read(ApiProviders.hamlAlarmScreenProviders)
                              .deleteAlarmItem(
                                context: context,
                                alarmID: (contentList[index].alarmID??0),
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
                      (contentList[index].title??''),
                      style: TextStyle(
                        fontSize: 11.0.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.defaultAppColor,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Visibility(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.alarm,
                                    color: AppColors.greyColor,
                                    size: 14.0.h,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: 5.0.w),
                            Text(
                              TimeOfDay.fromDateTime(
                                DateTime.parse(
                                        (contentList[index].alarmDateAndTime??''))
                                    .add(const Duration(hours: 2)),
                              ).format(context),
                              style: TextStyle(
                                fontSize: 9.0.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.greyColor,
                              ),
                            ),
                            SizedBox(width: 5.0.w),
                            Container(
                                height: 10.0.h,
                                width: 1.0.w,
                                color: AppColors.greyColor),
                          ],
                        ),
                        SizedBox(width: 5.0.w),
                        Icon(
                          Icons.calendar_month,
                          size: 14.0.h,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(width: 5.0.w),
                        Text(
                          DateFormat.yMEd().format(DateTime.parse(
                              (contentList[index].alarmDateAndTime??''))),
                          style: TextStyle(
                            fontSize: 9.0.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyColor,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.0.h),
                Text(
                 ( contentList[index].description??''),
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

  static Future<void> alarmTimeWidget({
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
