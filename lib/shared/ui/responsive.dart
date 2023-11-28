import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    Key? key,
    required this.desktop,
    this.mobile,
    this.tablet,
  }) : super(key: key);

  final Widget desktop;
  final Widget? tablet;
  final Widget? mobile;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 850;
  }

  static bool isTablet(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final w = mediaQuery.size.width;

    return w < 1100 && w >= 850;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    if (w < 850 && mobile != null) {
      return mobile!;
    }

    if (w < 1100 && tablet != null) {
      return tablet!;
    }

    return desktop;
  }
}
