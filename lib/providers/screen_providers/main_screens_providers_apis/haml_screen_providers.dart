// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/enums.dart';
import 'package:hijri/hijri_calendar.dart';

class HamlScreenProviders extends ChangeNotifier {
  Random random = Random();
  List<int> yearsList = [];
  List<int> daysNumberList = [];
  Key? rebuildYearWidget;
  List<Map<String, dynamic>> monthsMiladyListInArabic = [
    {"number": "01", "name": "1- يناير"},
    {"number": "02", "name": "2- فبراير"},
    {"number": "03", "name": "3- مارس"},
    {"number": "04", "name": "4- أبريل"},
    {"number": "05", "name": "5- مايو"},
    {"number": "06", "name": "6- يونيو"},
    {"number": "07", "name": "7- يوليو"},
    {"number": "08", "name": "8- أغسطس"},
    {"number": "09", "name": "9- سبتمبر"},
    {"number": "10", "name": "10- أكتوبر"},
    {"number": "11", "name": "11- نوفمبر"},
    {"number": "12", "name": "12- ديسمبر"},
  ];

  List<Map<String, dynamic>> monthsHijariListInArabic = [
    {"number": "01", "name": "1- محرم"},
    {"number": "02", "name": "2- صفر"},
    {"number": "03", "name": "3- ربيع الأول"},
    {"number": "04", "name": "4- ربيع الآخر"},
    {"number": "05", "name": "5- جمادى الأولى"},
    {"number": "06", "name": "6- جمادى الآخرة"},
    {"number": "07", "name": "7- رجب"},
    {"number": "08", "name": "8- شعبان"},
    {"number": "09", "name": "9- رمضان"},
    {"number": "10", "name": "10- شوال"},
    {"number": "11", "name": "11- ذو القعدة"},
    {"number": "12", "name": "12- ذو الحجة"},
  ];

  String monthSelected = "01";
  String? yearSelected, daySelected;
  UserSelectedBirthType birthType = UserSelectedBirthType.milady;
  Color miladyContainerColor = AppColors.defaultAppColor;
  Color hijariContainerColor = Colors.white;
  Color miladyTextColor = AppColors.yellowColor;
  Color hijariTextColor = AppColors.defaultAppColor;

  void selectBirthType(UserSelectedBirthType type) {
    birthType = type;
    if (type == UserSelectedBirthType.milady) {
      miladyContainerColor = AppColors.defaultAppColor;
      miladyTextColor = AppColors.yellowColor;
      hijariContainerColor = Colors.white;
      hijariTextColor = AppColors.defaultAppColor;
      refreshYearWidget();
      setMiladyYearsList();
    } else {
      miladyContainerColor = Colors.white;
      miladyTextColor = AppColors.defaultAppColor;
      hijariContainerColor = AppColors.defaultAppColor;
      hijariTextColor = AppColors.yellowColor;
      refreshYearWidget();
      setHijariYearsList();
    }

    notifyListeners();
  }

  void refreshYearWidget() {
    rebuildYearWidget = ValueKey(random.nextInt(1000));
    notifyListeners();
  }

  void setMonthSelected(String monthSelectedNumber) {
    monthSelected = monthSelectedNumber;
    notifyListeners();
  }

  void setYearSelected(String year) {
    yearSelected = year;
    notifyListeners();
  }

  void dayNumberSelected(String day) {
    daySelected = day;
    notifyListeners();
  }

  void setMiladyYearsList() {
    yearsList = [];
    int yearNow = DateTime.now().year;
    int newYear = (DateTime.now().year - 3);

    for (int i = yearNow; i > newYear; i--) {
      yearsList.add(i);
    }

    notifyListeners();
  }

  void setHijariYearsList() {
    yearsList = [];

    int yearNow = HijriCalendar.now().hYear;
    int newYear = (HijriCalendar.now().hYear - 3);

    for (int i = yearNow; i > newYear; i--) {
      yearsList.add(i);
    }

    notifyListeners();
  }

  void setDaysNumberList() {
    daysNumberList = [];
    if (monthSelected == "01" ||
        monthSelected == "03" ||
        monthSelected == "05" ||
        monthSelected == "07" ||
        monthSelected == "08" ||
        monthSelected == "10" ||
        monthSelected == "12") {
      for (int i = 1; i < 32; i++) {
        daysNumberList.add(i);
      }
    } else if (monthSelected == "02") {
      for (int i = 1; i < 29; i++) {
        daysNumberList.add(i);
      }
    } else {
      for (int i = 1; i < 31; i++) {
        daysNumberList.add(i);
      }
    }
    notifyListeners();
  }
}
