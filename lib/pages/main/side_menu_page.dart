import 'package:flutter/material.dart';

import '../../shared/ui/responsive.dart';

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.title,
    this.headerEnd,
  });

  final Widget child;
  final bool showBackButton;
  final String? title;
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
              if (showBackButton)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: BackButton(),
                ),
              if (!isDesktop)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              if (title != null && !isMobile)
                Expanded(
                  child: Text(
                    title!,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
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
