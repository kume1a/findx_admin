class StringPosition {
  StringPosition({
    required this.start,
    required this.end,
  });

  final int start;
  final int end;

  @override
  String toString() {
    return 'StringPosition(start: $start, end: $end)';
  }
}

class MathProblemTemplatePlaceholder {
  MathProblemTemplatePlaceholder({
    required this.templateParamIndex,
    required this.positions,
    required this.placeholder,
  });

  final int templateParamIndex;
  final List<StringPosition> positions;
  final String placeholder;

  @override
  String toString() {
    return 'MathProblemTemplatePlaceholder(templateParamIndex: $templateParamIndex, positions: $positions, placeholder: $placeholder)';
  }
}
