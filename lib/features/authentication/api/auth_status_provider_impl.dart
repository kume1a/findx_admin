import 'package:findx_dart_client/app_client.dart';
import 'package:injectable/injectable.dart';

import 'auth_status_provider.dart';

@LazySingleton(as: AuthStatusProvider)
class AuthStatusProviderImpl implements AuthStatusProvider {
  AuthStatusProviderImpl(
    this._authTokenStore,
  );

  final AuthTokenStore _authTokenStore;

  @override
  Future<bool> get() {
    return _authTokenStore.hasRefreshToken();
  }
}
