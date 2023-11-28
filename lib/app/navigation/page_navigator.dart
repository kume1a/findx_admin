import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'routes.dart';

@lazySingleton
final class PageNavigator {
  PageNavigator(
    this._router,
  );

  final GoRouter _router;

  void pop<T>([T? result]) {
    _router.pop(result);
  }

  void toMain() {
    _router.go(Routes.main);
  }
}
