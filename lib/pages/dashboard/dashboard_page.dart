import 'package:flutter/material.dart';

import 'ui/header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Header(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
