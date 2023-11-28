import 'package:flutter/material.dart';

import 'main/side_menu_page.dart';

class MutateMathFieldPage extends StatelessWidget {
  const MutateMathFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SideMenuPage(
      showBackButton: true,
      title: 'Mutate math field',
      child: Center(
        child: Text('Mutate math field'),
      ),
    );
  }
}
