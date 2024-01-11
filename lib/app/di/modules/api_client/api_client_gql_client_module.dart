import 'package:dio/dio.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/authentication/api/after_sign_out.dart';
import '../../../app_environment.dart';
import '../../injection_token.dart';

@module
abstract class ApiClientGqlClientModule {
  @lazySingleton
  @Named(InjectionToken.apiDio)
  Dio dio(
    AuthTokenStore authTokenStore,
    @Named(InjectionToken.noInterceptorDio) Dio noInterceptorDio,
    AfterSignOut afterSignOut,
    RefreshTokenUsecase refreshTokenUsecase,
  ) {
    return NetworkClientFactory.createAuthenticatedDio(
      noInterceptorDio: noInterceptorDio,
      authTokenStore: authTokenStore,
      afterExit: afterSignOut.call,
      // logPrint: null,
      apiUrl: AppEnvironment.apiUrl,
      refreshTokenUsecase: refreshTokenUsecase,
    );
  }

  @lazySingleton
  @Named(InjectionToken.noInterceptorDio)
  Dio refreshTokenDio() {
    return NetworkClientFactory.createNoInterceptorDio(
      apiUrl: AppEnvironment.apiUrl,
    );
  }

  @lazySingleton
  GraphQLClient gqlApiClient(
    @Named(InjectionToken.apiDio) Dio dio,
  ) {
    return NetworkClientFactory.createGqlClient(
      dio: dio,
      apiUrl: AppEnvironment.apiUrl,
    );
  }
}
