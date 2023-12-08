import 'package:dio/dio.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';

import '../../../app_environment.dart';
import '../../injection_token.dart';

@module
abstract class ApiClientAuthenticationModule {
  @lazySingleton
  AuthenticationFacade authenticationFacade(GraphQLClient client) {
    return ApiAuthenticationFacade(client);
  }

  @lazySingleton
  RefreshTokenUsecase refreshTokenUsecase(
    @Named(InjectionToken.noInterceptorDio) Dio dio,
  ) {
    return RefreshTokenUsecaseImpl(dio, AppEnvironment.apiUrl);
  }
}
