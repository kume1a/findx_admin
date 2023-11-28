import 'package:flutter/material.dart';

import '../../shared/ui/responsive.dart';

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({
    super.key,
    required this.child,
    this.title,
    this.headerEnd,
  });

  final String? title;
  final Widget child;
  final Widget? headerEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (!isDesktop)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              if (title != null && !isMobile)
                Text(
                  title!,
                  style: theme.textTheme.titleLarge,
                ),
              if (!isMobile) Spacer(flex: isDesktop ? 2 : 1),
              if (headerEnd != null) headerEnd!,
            ],
          ),
          const SizedBox(height: 24),
          Expanded(child: child),
        ],
      ),
    );
  }
}
