import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../pages/dashboard_page.dart';
import '../../pages/main/main_page.dart';
import '../../pages/math_field_list_page.dart';
import '../../pages/math_problem_list_page.dart';
import '../../pages/math_sub_field_list_page.dart';
import '../../pages/mutate_math_field_page.dart';
import '../../pages/mutate_math_problem_page.dart';
import '../../pages/mutate_math_sub_field_page.dart';
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
          routes: [
            GoRoute(
              path: Routes.dashboard,
              builder: (_, __) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (_, __) => const SettingsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.users,
              builder: (_, __) => const UsersPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.mathFieldList,
              builder: (_, __) => const MathFieldListPage(),
              routes: [
                GoRoute(
                  path: Routes.mutateMathField,
                  builder: (_, state) {
                    final mathFieldId = state.uri.queryParameters['mathFieldId'];

                    return MutateMathFieldPage(
                      mathFieldId: mathFieldId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.mathSubFieldList,
              builder: (_, __) => const MathSubFieldListPage(),
              routes: [
                GoRoute(
                  path: Routes.mutateMathSubField,
                  builder: (_, state) {
                    final mathSubFieldId = state.uri.queryParameters['mathSubFieldId'];

                    return MutateMathSubFieldPage(
                      mathSubFieldId: mathSubFieldId,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.mathProblemList,
              builder: (_, __) => const MathProblemListPage(),
              routes: [
                GoRoute(
                  path: Routes.mutateMathProblem,
                  builder: (_, state) {
                    final mathProblemId = state.uri.queryParameters['mathProblemId'];

                    return MutateMathProblemPage(
                      mathProblemId: mathProblemId,
                    );
                  },
                ),
              ],
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
