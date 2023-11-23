import 'package:flutter/widgets.dart';

abstract final class NavigatorKeyHolder {
  static final rootKey = GlobalKey<NavigatorState>();

  static final dashboardKey = GlobalKey<NavigatorState>();
  static final settingsKey = GlobalKey<NavigatorState>();
}
