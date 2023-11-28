import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    Key? key,
    required this.desktop,
    this.mobile,
    this.tablet,
  }) : super(key: key);

  final LayoutWidgetBuilder desktop;
  final LayoutWidgetBuilder? tablet;
  final LayoutWidgetBuilder? mobile;

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(_) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        if (w < 850 && mobile != null) {
          return mobile!(context, constraints);
        }

        if (w < 1100 && tablet != null) {
          return tablet!(context, constraints);
        }

        return desktop(context, constraints);
      },
    );
  }
}
