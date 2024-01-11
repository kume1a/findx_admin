import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class ScrollableTex extends HookWidget {
  const ScrollableTex(
    this.tex, {
    super.key,
    this.style,
  });

  final String tex;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Align(
          child: Math.tex(
            tex,
            textStyle: style,
          ),
        ),
      ),
    );
  }
}
