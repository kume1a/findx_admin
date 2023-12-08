import 'package:findx_dart_client/app_client.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class ApiClientStoreModule {
  @lazySingleton
  AuthTokenStore authTokenStore(SharedPreferences sharedPreferences) {
    return SharedPrefsTokenStoreImpl(sharedPreferences);
  }
}
