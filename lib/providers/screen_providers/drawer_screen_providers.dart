import 'package:flutter/material.dart';
import 'package:haml_guide/config/routes.dart';
import 'package:haml_guide/screens/widgets/drawer_widgets.dart';

class DrawerScreenProviders extends ChangeNotifier {
  List<Map<String, dynamic>> drawerList = [
    {
      "image": "assets/images/drawer/haml.png",
      "title": "حاسبه الحمل",
      "destination": 2
    },
    {
      "image": "assets/images/drawer/forward_haml.png",
      "title": "متابعة الحمل",
      "destination": 4
    },
    {
      "image": "assets/images/drawer/mwlod_name.png",
      "title": "اسم المولد",
      "destination": 0
    },
    {
      "image": "assets/images/drawer/fav.png",
      "title": "المفضله",
      "destination": PATHS.favouriteScreen
    },
    {
      "image": "assets/images/drawer/weeks.png",
      "title": "الاسابيع",
      "destination": 1
    },
    {
      "image": "assets/images/drawer/moktafat.png",
      "title": "مقتطفات",
      "destination": 3
    },
    {
      "image": "assets/images/drawer/contacts.png",
      "title": "تواصل معنا",
      "destination": const SizedBox()
    },
    {
      "image": "assets/images/drawer/contacts.png",
      "title": "المصادر",
      "destination": PATHS.sourcesScreen
    },
    {
      "image": "assets/images/drawer/share.png",
      "title": "شارك التطبيق",
      "destination": const SizedBox()
    },
    {
      "image": "assets/images/drawer/rate.png",
      "title": "قيم التطبيق",
      "destination": const SizedBox()
    },
    {
      "image": "assets/images/drawer/forward_haml.png",
      "title": "معلومات المستخدم",
      "destination": const SizedBox()
    },
  ];

  void updateContactUsWidget({
    required BuildContext context,
    required double devicePixelRatio,
  }) {
    Navigator.pop(context);

    drawerList[6]['destination'] = DrawerScreenWidgets.contactUsWidget(
      devicePixelRatio: devicePixelRatio,
      context: context,
    );

    notifyListeners();
  }

  void updateRateWidget({required BuildContext context}) {
    Navigator.pop(context);
    drawerList[8]['destination'] =
        DrawerScreenWidgets.rateWidget(context: context);

    notifyListeners();
  }

  void updateUserInfoWidget({
    required BuildContext context,
    required TextEditingController userNameController,
    required TextEditingController userPhoneController,
    required TextEditingController userEmailController,
    required TextEditingController userCountry,
    required GlobalKey<FormState> formkey,
  }) {
    Navigator.pop(context);
    drawerList[9]['destination'] = DrawerScreenWidgets.userInfoWidget(
      context: context,
      formkey: formkey,
      userEmailController: userEmailController,
      userNameController: userNameController,
      userPhoneController: userPhoneController,
      userCountry: userCountry,
    );

    notifyListeners();
  }
}
