import 'package:haml_guide/screens/drawer_screens/favourite_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/alarm_screens/main_alarm_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/haml_forward_details_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/notes_screens/main_notes_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/pressure_screens/main_pressure_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/rklat_screens.dart/add_rklat_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/rklat_screens.dart/main_rklat_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/sugar_screens/main_sugar_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/weight_screens/add_weight_screen.dart';
import 'package:haml_guide/screens/main_screens/haml_forwad_screens.dart/weight_screens/main_weight_screen.dart';
import 'package:haml_guide/screens/splash_screen.dart';

class PATHS {
  static const String splashScreen = "SplashScreen";
  static const String favouriteScreen = "FavouriteScreen";
  static const String mainRklatScreen = "MainRklatScreen";
  static const String mainWeightScreen = "MainWeightScreen";
  static const String mainPressureScreen = "MainPressureScreen";
  static const String mainSugarScreen = "MainSugarScreen";
  static const String mainAlarmScreen = "MainAlarmScreen";
  static const String mainNotesScreen = "MainNotesScreen";
  static const String forwardHamlDetails = "ForwardHamlDetails";
  static const String addWeightScreen = "AddWeightScreen";
  static const String addRklatScreen = "AddRklatScreen";
}

var routes = {
  PATHS.splashScreen: (context) => const SplashScreen(),
  PATHS.favouriteScreen: (context) => const FavouriteScreen(),
  PATHS.mainRklatScreen: (context) => const MainRklatScreen(),
  PATHS.mainWeightScreen: (context) => const MainWeightScreen(),
  PATHS.mainPressureScreen: (context) => const MainPressureScreen(),
  PATHS.mainSugarScreen: (context) => const MainSugarScreen(),
  PATHS.mainAlarmScreen: (context) => const MainAlarmScreen(),
  PATHS.mainNotesScreen: (context) => const MainNotesScreen(),
  PATHS.forwardHamlDetails: (context) => const HamlForwardDetailsScreen(),
  PATHS.addWeightScreen: (context) => const AddWeightScreen(),
  PATHS.addRklatScreen: (context) => const AddRklatScreen(),
};
