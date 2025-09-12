import 'package:shared_preferences/shared_preferences.dart';

import './config_dev.dart' as devConfig;
import './config_prod.dart' as prodConfig;

class AppConfig {
  static late String baseUrl;
  static late String externalVersion;
  static late String internalVersion;
  static late String ct;

  static Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    //  flutter build apk --dart-define=ENV=dev --dart-define=COUNTRY=EU
    //  flutter build apk --dart-define=ENV=prod --dart-define=COUNTRY=EU
    const env = String.fromEnvironment('ENV', defaultValue: 'prod');
    const String country =
        String.fromEnvironment('COUNTRY', defaultValue: 'EU');

    const EXV = String.fromEnvironment('EXV', defaultValue: '');
    const ITV = String.fromEnvironment('ITV', defaultValue: '');

    ct = prefs.getString('country') ?? country;

    print("loadConfig env :$env");
    print("loadConfig ct :$ct");
    print("loadConfig externalVersion :$EXV");
    print("loadConfig internalVersion :$ITV");

    if (env == 'dev') {
      baseUrl = devConfig.Config.baseUrl_us;
    } else {
      baseUrl = ct == "EU"
          ? prodConfig.Config.baseUrl_eu
          : prodConfig.Config.baseUrl_us;
    }
    externalVersion = EXV;
    internalVersion = ITV;
    print("loadConfig baseUrl :$baseUrl");
    print("loadConfig externalVersion :$externalVersion");
    print("loadConfig internalVersion :$internalVersion");
  }

  static Future<void> setcountry(country) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("country", country);
    baseUrl = country == "EU"
        ? prodConfig.Config.baseUrl_eu
        : prodConfig.Config.baseUrl_us;
    print(baseUrl);
  }
}
