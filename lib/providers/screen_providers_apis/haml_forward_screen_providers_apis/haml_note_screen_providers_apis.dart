import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/models/haml_forward_models/haml_note_model.dart';

class HamlNoteScreenProvidersApis extends ChangeNotifier {
  Future<List<HamlNoteModel>?> getAllHamlnotes(
      {required BuildContext context}) async {
    List<HamlNoteModel> hamlNotesList = [];

    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      List<dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/notes/?device=$deviceID&device__device_id=",
        headers: {},
      );

      if (dataList != null) {
        for (var data in dataList) {
          hamlNotesList.add(HamlNoteModel.fromJson(data));
        }
      } else {
        if (context.mounted) {
          CommonComponents.getSnackBarWithServerError(context);
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
    return hamlNotesList;
  }

  Future<void> setUserNote({
    required BuildContext context,
    required String title,
    required String description,
  }) async {
    HamlNoteModel model = HamlNoteModel(
      title: title,
      description: description,
    );
    int deviceID = await CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/notes/",
        headers: {},
        body: model.toJson(deviceID: deviceID),
      );
      if (data != null) {
        if (context.mounted) {
          CommonComponents.showCustomizedSnackBar(
              context: context, title: "تم إضافة الملحوظة بنجاح");
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, PATHS.mainNotesScreen);
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

  Future<void> deleteNoteItem(
      {required BuildContext context, required int noteID}) async {
    Map<String, dynamic> data = await ApiRequests.deleteApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/notes/$noteID/",
      headers: {},
      body: {},
    );

    if (data == null) {
      if (context.mounted) {
        CommonComponents.showCustomizedSnackBar(
            context: context, title: "تم الحذف بنجاح");
        Navigator.pushReplacementNamed(context, PATHS.mainNotesScreen);
      } else {
        return;
      }
    }
  }
}
