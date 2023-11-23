import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/ui/color.dart';
import '../../../shared/values/app_theme_extension.dart';
import '../../../shared/values/assets.dart';
import '../model/side_menu_item.dart';

typedef OnSideMenuNavChange = void Function(int index);

final List<SideMenuItem> sideMenuItems = [
  SideMenuSeparator(title: 'App'),
  SideMenuNavDestination(assetName: Assets.iconDashboard, name: 'Dashboard'),
  SideMenuNavDestination(assetName: Assets.iconSettings, name: 'Settings'),
  SideMenuSeparator(title: 'User'),
  SideMenuNavDestination(assetName: Assets.iconProfile, name: 'Users'),
  SideMenuSeparator(title: 'Math'),
  SideMenuNavDestination(assetName: Assets.iconDashboard, name: 'MathField'),
  SideMenuNavDestination(assetName: Assets.iconDashboard, name: 'MathSubField'),
  SideMenuNavDestination(assetName: Assets.iconDashboard, name: 'MathProblem'),
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
            padding: const EdgeInsets.all(36),
            child: Image.asset(Assets.imageLogoTransparentBgWhite),
          ),
          ...getItems(context),
        ],
      ),
    );
  }

  List<Widget> getItems(context) {
    final theme = Theme.of(context);

    final List<Widget> items = [];
    int navDestinationIndex = 0;

    for (final item in sideMenuItems) {
      switch (item) {
        case SideMenuSeparator(title: var title):
          final w = Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: theme.appThemeExtension?.elSecondary,
              ),
            ),
          );

          items.add(w);
          break;
        case SideMenuNavDestination(assetName: var assetName, name: var name):
          int index = navDestinationIndex;

          final w = DrawerListTile(
            title: name,
            assetName: assetName,
            onClick: () {
              onNavChange(index);
              Scaffold.of(context).closeDrawer();
            },
            isSelected: index == currentIndex,
          );

          items.add(w);
          navDestinationIndex++;
          break;
      }
    }

    return items;
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
      horizontalTitleGap: 6,
      selectedTileColor: Colors.white.withOpacity(.05),
      selected: isSelected,
      textColor: theme.appThemeExtension?.elSecondary,
      selectedColor: theme.appThemeExtension?.elPrimary,
      leading: SvgPicture.asset(
        assetName,
        colorFilter: svgColor(theme.appThemeExtension?.elSecondary),
        height: 16,
      ),
      title: Text(title),
    );
  }
}
