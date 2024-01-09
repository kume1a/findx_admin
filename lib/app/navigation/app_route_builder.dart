import 'routes.dart';

abstract final class AppRouteBuilder {
  static mutateMathField([String? mathFieldId]) {
    String routePath = '${Routes.mathFieldList}/${Routes.mutateMathField}';

    if (mathFieldId != null) {
      routePath += '/$mathFieldId';
    }

    return routePath;
  }

  static mutateMathSubField([String? mathSubFieldId]) {
    String routePath = '${Routes.mathSubFieldList}/${Routes.mutateMathSubField}';

    if (mathSubFieldId != null) {
      routePath += '/$mathSubFieldId';
    }

    return routePath;
  }

  static mutateMathProblem([String? mathProblemId]) {
    String routePath = '${Routes.mathProblemList}/${Routes.mutateMathProblem}';

    if (mathProblemId != null) {
      routePath += '/$mathProblemId';
    }

    return routePath;
  }

  static generateMathProblems() {
    return '${Routes.mathProblemList}/${Routes.generateMathProblems}';
  }
}
