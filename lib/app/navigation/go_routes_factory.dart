import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../pages/dashboard_page.dart';
import '../../pages/main/main_page.dart';
import '../../pages/settings_page.dart';
import '../../pages/sign_in_page.dart';
import '../../pages/users_page.dart';
import '../../shared/abstract/factory.dart';
import 'navigator_key_holder.dart';
import 'routes.dart';

@LazySingleton(as: Factory<List<RouteBase>>)
class GoRoutesFactory implements Factory<List<RouteBase>> {
  @override
  List<RouteBase> newInstance() {
    return [
      _buildShellRoute(),
      GoRoute(
        parentNavigatorKey: NavigatorKeyHolder.rootKey,
        path: Routes.signIn,
        builder: (_, __) => const SignInPage(),
      ),
    ];
  }

  RouteBase _buildShellRoute() {
    return StatefulShellRoute.indexedStack(
      parentNavigatorKey: NavigatorKeyHolder.rootKey,
      branches: [
        StatefulShellBranch(
          navigatorKey: NavigatorKeyHolder.dashboardKey,
          routes: [
            GoRoute(
              path: Routes.dashboard,
              builder: (_, __) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: NavigatorKeyHolder.settingsKey,
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (_, __) => const SettingsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: NavigatorKeyHolder.usersKey,
          routes: [
            GoRoute(
              path: Routes.users,
              builder: (_, __) => const UsersPage(),
            ),
          ],
        ),
      ],
      pageBuilder: (_, GoRouterState state, StatefulNavigationShell navigationShell) {
        return MaterialPage(
          key: state.pageKey,
          child: MainPage(
            child: navigationShell,
          ),
        );
      },
    );
  }
}
