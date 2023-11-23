import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/ui/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';

typedef OnSideMenuNavChange = void Function(int index);

class NavDestination {
  NavDestination({
    required this.assetName,
    required this.name,
  });

  final String assetName;
  final String name;
}

final List<NavDestination> navItems = [
  NavDestination(assetName: Assets.iconDashboard, name: 'Dashboard'),
  NavDestination(assetName: Assets.iconSettings, name: 'Settings'),
];

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
    required this.onNavChange,
    required this.currentIndex,
  }) : super(key: key);

  final OnSideMenuNavChange onNavChange;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(24),
            child: Image.asset(Assets.imageLogoTransparentBgWhite),
          ),
          for (final (index, navItem) in navItems.indexed)
            DrawerListTile(
              title: navItem.name,
              assetName: navItem.assetName,
              onClick: () => onNavChange(index),
              isSelected: index == currentIndex,
            ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.assetName,
    required this.onClick,
    required this.isSelected,
  }) : super(key: key);

  final String title, assetName;
  final VoidCallback onClick;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onClick,
      horizontalTitleGap: 0.0,
      selectedColor: Colors.white10,
      selected: isSelected,
      leading: SvgPicture.asset(
        assetName,
        colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
