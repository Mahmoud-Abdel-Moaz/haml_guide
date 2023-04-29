import 'package:flutter/material.dart';
import 'package:haml_guide/config/api_keys.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/api_requests.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/names_model.dart';
import 'package:riverpod_context/riverpod_context.dart';

class NamesScreenProvidersApis extends ChangeNotifier {
  List<NamesModel> allNames = [];
  List<NamesModel> favouriteNames = [];
  List<NamesModel> namesSearchlist = [];
  String? nameFilter;
  Key? namesKeyBuilder;
  int pageNumber = 1;

  void setNameFilter(String filter) {
    nameFilter = filter;
    notifyListeners();
  }

  void setAllNames(NamesModel names) {
    allNames.add(names);
    notifyListeners();
  }

  void setAllFavouriteNames(List<NamesModel> favouritesNames) {
    favouriteNames = favouritesNames;
    notifyListeners();
  }

  void setNameFvourite({required int index}) {
    if (namesSearchlist.isEmpty) {
      allNames[index].isFavourite = !(allNames[index].isFavourite??false);
    } else {
      namesSearchlist[index].isFavourite = !(namesSearchlist[index].isFavourite??false);
    }
    notifyListeners();
  }

  void removeNameFromFav(
      {required BuildContext context, required int index}) {
    if (namesSearchlist.isEmpty) {
      for (int i = 0; i < allNames.length; i++) {
        if (favouriteNames[index].nameID == allNames[i].nameID) {
          allNames[i].isFavourite = false;
        }
      }
    } else {
      for (int i = 0; i < namesSearchlist.length; i++) {
        if (favouriteNames[index].nameID == namesSearchlist[i].nameID) {
          namesSearchlist[i].isFavourite = false;
        }
      }
    }

    favouriteNames.removeAt(index);
    notifyListeners();
  }

  void searchNamesList(NamesModel value) {
    namesSearchlist.add(value);
    notifyListeners();
  }

  void incrementPageNumber() {
    pageNumber++;
    notifyListeners();
  }

  Future<List<NamesModel>?> getNames({required BuildContext context}) async {
    CommonComponents.loading(context);
    var dataList = await ApiRequests.getApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: nameFilter != null
          ? "api/v1/names?page=$pageNumber&gender=$nameFilter"
          : "api/v1/names?page=$pageNumber",
      headers: {},
    );
    if (dataList != null) {
      namesSearchlist = [];
      for (var data in dataList['results']) {
        setAllNames(NamesModel.fromjson(jsonData: data, isFav: false));
      }

      if (context.mounted) {
        await context
            .read(ApiProviders.favouriteNamesScreenProvidersApis)
            .getNamesFavourites(context: context);
      } else {
        return null;
      }
      checkIfNamesIsFavourite();

      if (context.mounted) {
        Navigator.pop(context);
      } else {
        return null;
      }
    } else {
      if (context.mounted) {
        CommonComponents.getSnackBarWithServerError(context);
      } else {
        return allNames;
      }
    }
    return null;
  }

  void checkIfNamesIsFavourite() {
    for (int i = 0; i < allNames.length; i++) {
      if (favouriteNames.any((element) => element.name == allNames[i].name)) {
        allNames[i].isFavourite = true;
      }
    }
    notifyListeners();
  }

  void checkIfSearchedNamesIsFavourite() {
    for (int i = 0; i < namesSearchlist.length; i++) {
      if (favouriteNames
          .any((element) => element.name == namesSearchlist[i].name)) {
        namesSearchlist[i].isFavourite = true;
      }
    }
    notifyListeners();
  }

  Future<void> getSearchedNames(
      {required BuildContext context, required String value}) async {
    List<dynamic> dataList = await ApiRequests.postApiRequests(
      context: context,
      baseUrl: ApiKeys.baseUrl,
      apiUrl: "api/v1/names/searched_names/",
      headers: {},
      body: {"search": value},
    );

    if (dataList != null) {
      namesSearchlist = [];
      for (var data in dataList) {
        searchNamesList(NamesModel.fromjson(jsonData: data, isFav: false));
      }
      if (context.mounted) {
        await context
            .read(ApiProviders.favouriteNamesScreenProvidersApis)
            .getNamesFavourites(context: context);
      } else {
        return;
      }
      checkIfSearchedNamesIsFavourite();
    } else {
      if (context.mounted) {
        CommonComponents.getSnackBarWithServerError(context);
      } else {
        return;
      }
    }
  }
}
