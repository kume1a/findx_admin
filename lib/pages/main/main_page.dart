import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/ui/responsive.dart';
import 'ui/side_menu.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    final sideMenu = SideMenu(
      onNavChange: onNavChange,
      currentIndex: child.currentIndex,
    );

    return Scaffold(
      drawer: sideMenu,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context)) Expanded(child: sideMenu),
            Expanded(
              flex: 5,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  void onNavChange(int index) {
    child.goBranch(
      index,
      initialLocation: index == child.currentIndex,
    );
  }
}
