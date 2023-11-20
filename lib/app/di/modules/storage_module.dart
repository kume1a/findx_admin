import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
}
