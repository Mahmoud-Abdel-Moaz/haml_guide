import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/social_media_model.dart';
import 'package:haml_guide/models/user_info_model.dart';

class UserScreenProvidersApis extends ChangeNotifier {
  Future<void> setUserInfo({
    required BuildContext context,
    required String userName,
    required String userEmail,
    required String userPhone,
    required String userCountry,
  }) async {
    String deviceIDFromUser =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);
    UserInfoModel model = UserInfoModel(
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      userCountry: userCountry,
      deviceID: deviceIDFromUser,
    );

    int deviceIDFromApi =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.patchApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices/$deviceIDFromApi/",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "device_id $deviceIDFromUser",
        },
        body: json.encode(model.tojson()),
      );

      if (data.containsKey('id')) {
        if (context.mounted) {
          Navigator.pop(context);
          CommonComponents.showCustomizedSnackBar(
              context: context, title: "تم إرسال معلوماتك بنجاح");
        } else {
          return;
        }
      } else {
        if (context.mounted) {
          CommonComponents.getSnackBarWithServerError(context);
        } else {
          return;
        }
      }
    } else {
      return;
    }
  }

  Future<SocialMediaModel?> getSocialMediaLinks(
      {required BuildContext context}) async {
    SocialMediaModel? socialMediaLinksModel;

    List<dynamic> dataList = await ApiRequests.getApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/social-media/",
      headers: {},
    );

    if (dataList != null) {
      socialMediaLinksModel = SocialMediaModel.fromjson(dataList[0]);
    } else {
      if (context.mounted) {
        CommonComponents.getSnackBarWithServerError(context);
      } else {
        return null;
      }
    }

    return socialMediaLinksModel;
  }
}
