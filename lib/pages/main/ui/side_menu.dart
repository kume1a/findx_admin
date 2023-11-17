import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/values/assets.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(24),
            child: Image.asset(Assets.imageLogoTransparentBgWhite),
          ),
          DrawerListTile(
            title: 'Dashboard',
            svgSrc: Assets.iconDashboard,
            press: () {},
          ),
          DrawerListTile(
            title: 'Documents',
            svgSrc: Assets.iconDoc,
            press: () {},
          ),
          DrawerListTile(
            title: 'Notification',
            svgSrc: Assets.iconNotification,
            press: () {},
          ),
          DrawerListTile(
            title: 'Settings',
            svgSrc: Assets.iconSettings,
            press: () {},
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
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
