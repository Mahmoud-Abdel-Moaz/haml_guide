import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_note_model.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/haml_forward_details_screen.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/common_content_haml_forward_widgets.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_context/riverpod_context.dart';

class NotesScreenWidgets {
  static Future<dynamic> noteAlertWidget({
    required BuildContext context,
    required TextEditingController noteTitleController,
    required TextEditingController noteDescriptionController,
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
                            "اضافه ملحوظه",
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
                          controller: noteTitleController,
                          readOnly: false,
                          hint: "عنوان الملحوظه",
                          type: TextInputType.text,
                          action: TextInputAction.next,
                          validate: "من فضلك ادخل عنوان الملحوظه",
                        ),
                        SizedBox(height: 10.0.h),
                        CommonContentHamlForwardWidgets
                            .hamlAddAlerFieldstWidget(
                          controller: noteDescriptionController,
                          readOnly: false,
                          hint: "نص الملحوظه",
                          type: TextInputType.text,
                          action: TextInputAction.done,
                          validate: "من فضلك ادخل نص الملحوظه",
                          maxLines: 5,
                        ),
                        SizedBox(height: 10.0.h),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!=null&&formKey.currentState!.validate()) {
                        await context
                            .read(ApiProviders.hamlNoteScreenProvidersApis)
                            .setUserNote(
                              context: context,
                              title: noteTitleController.text,
                              description: noteDescriptionController.text,
                            );

                        noteTitleController.clear();
                        noteDescriptionController.clear();
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
                    child: const Text("اضافه ملحوظه"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      noteTitleController.clear();
                      noteDescriptionController.clear();
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

  static Widget noteContentWidget({
    required List<HamlNoteModel> contentList,
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
            Navigator.pushNamed(
              context,
              PATHS.forwardHamlDetails,
              arguments: HamlForwardDetailsScreen(
                appBarTitle: appBarTitle,
                description: (contentList[index].description??''),
                image: image,
                title: (contentList[index].title??''),
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
                              .read(ApiProviders.hamlNoteScreenProvidersApis)
                              .deleteNoteItem(
                                context: context,
                                noteID: (contentList[index].noteID??0),
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
                        Icon(
                          Icons.calendar_month,
                          size: 14.0.h,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(width: 5.0.w),
                        Text(
                          DateFormat.yMEd()
                              .format(DateTime.parse((contentList[index].date??'')))
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
