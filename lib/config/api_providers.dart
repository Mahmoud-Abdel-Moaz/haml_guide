import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haml_guide/providers/notification_handler.dart';
import 'package:haml_guide/providers/screen_providers_apis/favourite_names_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/haml_forward_screen_providers_apis/haml_alarm_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/haml_forward_screen_providers_apis/haml_note_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/haml_forward_screen_providers_apis/haml_pressure_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/haml_forward_screen_providers_apis/haml_sugar_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/haml_forward_screen_providers_apis/haml_weight_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/haml_forward_screen_providers_apis/kicks_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/haml_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/moktatafat_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/names_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/user_location_providers.dart';
import 'package:haml_guide/providers/screen_providers_apis/user_screen_providers_apis.dart';
import 'package:haml_guide/providers/screen_providers_apis/weeks_screen_providers_apis.dart';

class ApiProviders {
  static final ChangeNotifierProvider<HamlScreenProvidersApis>
      hamlScreenProvidersApis = ChangeNotifierProvider(
    (ref) => HamlScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<WeeksScreenProvidersApis>
      weeksScreenProvidersApis = ChangeNotifierProvider(
    (ref) => WeeksScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<NamesScreenProvidersApis>
      namesScreenProvidersApis = ChangeNotifierProvider(
    (ref) => NamesScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<FavouriteNamesScreenProvidersApis>
      favouriteNamesScreenProvidersApis = ChangeNotifierProvider(
    (ref) => FavouriteNamesScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<MoktatafatScreenProvidersApis>
      moktatafatScreenProvidersApis = ChangeNotifierProvider(
    (ref) => MoktatafatScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<KicksScreenProvidersApis>
      kicksScreenProvidersApis = ChangeNotifierProvider(
    (ref) => KicksScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<HamlWeigtScreenProvidersApis>
      hamlWeigtScreenProvidersApis = ChangeNotifierProvider(
    (ref) => HamlWeigtScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<HamlPressureScreenProvidersApis>
      hamlPressureScreenProvidersApis = ChangeNotifierProvider(
    (ref) => HamlPressureScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<HamlSugarScreenProvidersApis>
      hamlSugarScreenProvidersApis = ChangeNotifierProvider(
    (ref) => HamlSugarScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<HamlAlarmScreenProviders>
      hamlAlarmScreenProviders = ChangeNotifierProvider(
    (ref) => HamlAlarmScreenProviders(),
  );

  static final ChangeNotifierProvider<HamlNoteScreenProvidersApis>
      hamlNoteScreenProvidersApis = ChangeNotifierProvider(
    (ref) => HamlNoteScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<UserScreenProvidersApis>
      userScreenProvidersApis = ChangeNotifierProvider(
    (ref) => UserScreenProvidersApis(),
  );

  static final ChangeNotifierProvider<UserLocationProviders>
      userLocationProviders = ChangeNotifierProvider(
    (ref) => UserLocationProviders(),
  );

  static final ChangeNotifierProvider<NotificationHandler> notificationHandler =
      ChangeNotifierProvider(
    (ref) => NotificationHandler(),
  );
}
