import 'package:flutter/material.dart';

import 'main/side_menu_page.dart';

class GenerateMathProblemsPage extends StatelessWidget {
  const GenerateMathProblemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const SideMenuPage(
      showBackButton: true,
      title: 'Generate math problems',
      child: SizedBox.shrink(),
    );
  }
}
