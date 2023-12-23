import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpandableImage extends StatelessWidget {
  const ExpandableImage({
    super.key,
    required this.url,
    this.borderRadius = BorderRadius.zero,
    this.width,
    this.height,
  });

  final String url;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return Dialog(
                child: Stack(
                  children: [
                    SafeImage(
                      url: url,
                      borderRadius: borderRadius,
                    ),
                    Positioned(
                      right: 24,
                      top: 24,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        color: Colors.white,
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: SafeImage(
          width: width,
          height: height,
          url: url,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
