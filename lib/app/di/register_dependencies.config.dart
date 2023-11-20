// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:findx_admin/app/di/modules/abstract_components_module.dart'
    as _i17;
import 'package:findx_admin/app/di/modules/api_client/api_client_gql_client_module.dart'
    as _i15;
import 'package:findx_admin/app/di/modules/api_client/api_client_store_module.dart'
    as _i18;
import 'package:findx_admin/app/di/modules/navigation_di_module.dart' as _i19;
import 'package:findx_admin/app/di/modules/storage_module.dart' as _i16;
import 'package:findx_admin/app/navigation/go_router_factory.dart' as _i13;
import 'package:findx_admin/features/authentication/api/after_sign_out.dart'
    as _i3;
import 'package:findx_admin/features/authentication/api/after_sign_out_impl.dart'
    as _i4;
import 'package:findx_admin/features/authentication/api/auth_status_provider.dart'
    as _i11;
import 'package:findx_admin/features/authentication/api/auth_status_provider_impl.dart'
    as _i12;
import 'package:findx_dart_client/app_client.dart' as _i9;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:go_router/go_router.dart' as _i14;
import 'package:graphql/client.dart' as _i10;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i7;
import 'package:uuid/uuid.dart' as _i8;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final apiClientGqlClientModule = _$ApiClientGqlClientModule();
    final storageModule = _$StorageModule();
    final abstractComponentsModule = _$AbstractComponentsModule();
    final apiClientStoreModule = _$ApiClientStoreModule();
    final navigationDiModule = _$NavigationDiModule();
    gh.lazySingleton<_i3.AfterSignOut>(() => _i4.AfterSignOutImpl());
    gh.lazySingleton<_i5.Dio>(
      () => apiClientGqlClientModule.refreshTokenDio(),
      instanceName: 'no_interceptor_dio',
    );
    gh.lazySingleton<_i6.FlutterSecureStorage>(
        () => storageModule.flutterSecureStorage);
    await gh.lazySingletonAsync<_i7.SharedPreferences>(
      () => storageModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i8.Uuid>(() => abstractComponentsModule.uuid);
    gh.lazySingleton<_i9.AuthTokenStore>(() =>
        apiClientStoreModule.authTokenStore(gh<_i6.FlutterSecureStorage>()));
    gh.lazySingleton<_i5.Dio>(
      () => apiClientGqlClientModule.dio(
        gh<_i9.AuthTokenStore>(),
        gh<_i5.Dio>(instanceName: 'no_interceptor_dio'),
        gh<_i3.AfterSignOut>(),
      ),
      instanceName: 'api_dio',
    );
    gh.lazySingleton<_i10.GraphQLClient>(() => apiClientGqlClientModule
        .gqlApiClient(gh<_i5.Dio>(instanceName: 'api_dio')));
    gh.lazySingleton<_i11.AuthStatusProvider>(
        () => _i12.AuthStatusProviderImpl(gh<_i9.AuthTokenStore>()));
    gh.lazySingleton<_i13.GoRouterFactory>(
        () => _i13.GoRouterFactory(gh<_i11.AuthStatusProvider>()));
    gh.lazySingleton<_i14.GoRouter>(
        () => navigationDiModule.goRouter(gh<_i13.GoRouterFactory>()));
    return this;
  }
}

class _$ApiClientGqlClientModule extends _i15.ApiClientGqlClientModule {}

class _$StorageModule extends _i16.StorageModule {}

class _$AbstractComponentsModule extends _i17.AbstractComponentsModule {}

class _$ApiClientStoreModule extends _i18.ApiClientStoreModule {}

class _$NavigationDiModule extends _i19.NavigationDiModule {}
