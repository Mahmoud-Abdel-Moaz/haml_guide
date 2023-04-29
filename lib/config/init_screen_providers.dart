import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haml_guide/providers/screen_providers/drawer_screen_providers.dart';
import 'package:haml_guide/providers/screen_providers/main_screen_providers.dart';
import 'package:haml_guide/providers/screen_providers/main_screens_providers_apis/baby_names_providers.dart';
import 'package:haml_guide/providers/screen_providers/main_screens_providers_apis/haml_screen_providers.dart';
import 'package:haml_guide/providers/screen_providers/main_screens_providers_apis/moktatafat_screen_providers.dart';

class InitScreenProviders {
  static final ChangeNotifierProvider<MainScreenProviders> mainScreenProviders =
      ChangeNotifierProvider(
    (ref) => MainScreenProviders(),
  );

  static final ChangeNotifierProvider<HamlScreenProviders> hamlScreenProviders =
      ChangeNotifierProvider(
    (ref) => HamlScreenProviders(),
  );

  static final ChangeNotifierProvider<DrawerScreenProviders>
      drawerScreenProviders = ChangeNotifierProvider(
    (ref) => DrawerScreenProviders(),
  );

  static final ChangeNotifierProvider<MoktatafatScreenProviders>
      moktatafatScreenProviders = ChangeNotifierProvider(
    (ref) => MoktatafatScreenProviders(),
  );

  static final ChangeNotifierProvider<BabyNamesProviders> babyNamesProviders =
      ChangeNotifierProvider(
    (ref) => BabyNamesProviders(),
  );
}
