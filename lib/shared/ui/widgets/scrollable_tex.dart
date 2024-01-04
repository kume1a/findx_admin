import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class ScrollableTex extends StatelessWidget {
  const ScrollableTex(
    this.tex, {
    super.key,
    this.style,
  });

  final String tex;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
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
