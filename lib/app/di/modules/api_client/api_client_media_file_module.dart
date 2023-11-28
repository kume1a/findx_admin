import 'package:dio/dio.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:injectable/injectable.dart';

import '../../injection_token.dart';

@module
abstract class ApiClientMediaFileModule {
  @lazySingleton
  MediaFileRemoteRepository mediaFileRemoteRepository(
    @Named(InjectionToken.apiDio) Dio dio,
  ) {
    return ApiMediaFileRemoteRepository(dio);
  }
}
