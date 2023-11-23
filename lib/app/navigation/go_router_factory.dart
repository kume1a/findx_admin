import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../features/authentication/api/auth_status_provider.dart';
import '../../shared/abstract/factory.dart';
import 'navigator_key_holder.dart';
import 'routes.dart';

@LazySingleton(as: Factory<GoRouter>)
class GoRouterFactory implements Factory<GoRouter> {
  GoRouterFactory(
    this._authStatusProvider,
    this._goRoutesFactory,
  );

  final AuthStatusProvider _authStatusProvider;
  final Factory<List<RouteBase>> _goRoutesFactory;

  @override
  GoRouter newInstance() {
    return GoRouter(
      navigatorKey: NavigatorKeyHolder.rootKey,
      initialLocation: Routes.dashboard,
      routes: _goRoutesFactory.newInstance(),
      redirect: (BuildContext context, GoRouterState state) async {
        if (state.fullPath == '/') {
          return Routes.dashboard;
        }

        final isAuthenticated = await _authStatusProvider.get();

        if (!isAuthenticated) {
          return Routes.signIn;
        }

        return null;
      },
    );
  }
}
