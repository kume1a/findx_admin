import 'package:findx_dart_client/app_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiClientStoreModule {
  @lazySingleton
  AuthTokenStore authTokenStore(FlutterSecureStorage flutterSecureStorage) {
    return SecureStoreageTokenStoreImpl(flutterSecureStorage);
  }
}
