import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/names_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

class FavouriteNamesScreenProvidersApis extends ChangeNotifier {
  List<NamesModel> namesSearchlist = [];
  void searchNamesList(
      {required BuildContext context, required String value}) {
    namesSearchlist = [];
    for (int i = 0;
        i <
            context
                .read(ApiProviders.namesScreenProvidersApis)
                .favouriteNames
                .length;
        i++) {
      if ((context
          .read(ApiProviders.namesScreenProvidersApis)
          .favouriteNames[i]
          .name??'')
          .contains(value)) {
        namesSearchlist.add(context
            .read(ApiProviders.namesScreenProvidersApis)
            .favouriteNames[i]);
      }
    }
    notifyListeners();
  }

  Future<void> getNamesFavourites({required BuildContext context}) async {
    List<NamesModel> namesFavList = [];
    int? deviceId =  CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);
if(deviceId==null){
  return ;
}
    if (context.mounted) {
      Map<String, dynamic> dataList = await ApiRequests.getApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/devices/$deviceId/",
        headers: {},
      );

      if (dataList!=null&&dataList.containsKey('id')) {
        for (var data in dataList['favourites']) {
          namesFavList.add(NamesModel.fromjson(jsonData: data, isFav: true));
        }

        if (context.mounted) {
          context
              .read(ApiProviders.namesScreenProvidersApis)
              .setAllFavouriteNames(namesFavList);
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

  Future<void> setNameIsFavourite({
    required BuildContext context,
    required int nameID,
    required String status,
  }) async {
    String deviceId =
        await CommonComponents.getSavedData(ApiKeys.deviceIdFromUser);

    if (context.mounted) {
      Map<String, dynamic> data = await ApiRequests.postApiRequests(
        context: context,
        baseUrl: ApiKeys.baseUrl,
        apiUrl: "api/v1/add-remove-favourite/",
        headers: {},
        body: {
          "device_id": deviceId,
          "name_id": nameID.toString(),
        },
      );

      if (data != null) {
        if (context.mounted) {
          CommonComponents.showCustomizedSnackBar(
              context: context, title: status);
        } else {
          return;
        }
      }
    } else {
      return;
    }
  }
}
