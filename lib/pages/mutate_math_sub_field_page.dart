import 'package:flutter/material.dart';

import 'main/side_menu_page.dart';

class MutateMathSubFieldPage extends StatelessWidget {
  const MutateMathSubFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SideMenuPage(
      showBackButton: true,
      title: 'Mutate math sub field',
      child: Center(
        child: Text('Mutate math sub field'),
      ),
    );
  }
}
