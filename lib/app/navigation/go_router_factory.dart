import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/api/auth_status_provider.dart';
import '../../shared/abstract/factory.dart';
import 'routes.dart';
import 'typed_routes.dart';

@lazySingleton
class GoRouterFactory implements Factory<GoRouter> {
  GoRouterFactory(
    this._authStatusProvider,
  );

  final AuthStatusProvider _authStatusProvider;

  @override
  GoRouter newInstance() {
    return GoRouter(
      initialLocation: Routes.main,
      routes: $appRoutes,
      redirect: (BuildContext context, GoRouterState state) async {
        final isAuthenticated = await _authStatusProvider.get();

        if (!isAuthenticated) {
          return '/signIn';
        }

        return null;
      },
    );
  }
}
