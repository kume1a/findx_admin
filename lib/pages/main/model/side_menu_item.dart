sealed class SideMenuItem {}

class SideMenuNavDestination extends SideMenuItem {
  SideMenuNavDestination({
    required this.assetName,
    required this.name,
  });

  final String assetName;
  final String name;
}

class SideMenuSeparator extends SideMenuItem {
  SideMenuSeparator({
    required this.title,
  });

  final String title;
}
