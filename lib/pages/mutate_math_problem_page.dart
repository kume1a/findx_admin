import 'package:flutter/material.dart';

import 'main/side_menu_page.dart';

class MutateMathProblemPage extends StatelessWidget {
  const MutateMathProblemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SideMenuPage(
      showBackButton: true,
      title: 'Mutate math problem',
      child: Center(
        child: Text('Mutate math problem'),
      ),
    );
  }
}
