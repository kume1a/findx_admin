import 'package:flutter/material.dart';

import '../responsive_builder.dart';

class ResponsiveForm extends StatelessWidget {
  const ResponsiveForm({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: (_, __) => child,
      desktop: (_, constraints) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: constraints.maxWidth * .7,
          child: child,
        ),
      ),
    );
  }
}
