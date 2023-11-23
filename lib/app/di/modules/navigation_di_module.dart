import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/abstract/factory.dart';

@module
abstract class NavigationDiModule {
  @lazySingleton
  GoRouter goRouter(Factory<GoRouter> goRouterFactory) {
    return goRouterFactory.newInstance();
  }
}
