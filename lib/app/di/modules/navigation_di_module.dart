import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../navigation/go_router_factory.dart';

@module
abstract class NavigationDiModule {
  @lazySingleton
  GoRouter goRouter(GoRouterFactory goRouterFactory) {
    return goRouterFactory.newInstance();
  }
}
