import 'package:findx_dart_client/app_client.dart';

import '../model/math_problem_template_parameter_form.dart';

class MathProblemParams {
  MathProblemParams({
    required this.customStrParams,
    required this.numberParams,
  });

  final List<GenerateMathProblemCustomStrParam> customStrParams;
  final List<GenerateMathProblemNumberParam> numberParams;
}

class MapMathProblemTemplateParams {
  MathProblemParams call(List<MathProblemTemplateParameterForm> forms) {
    final customStrParams = <GenerateMathProblemCustomStrParam>[];
    final numberParams = <GenerateMathProblemNumberParam>[];

    for (final form in forms) {
      form.when(
        number: (index, min, max, step) {
          return GenerateMathProblemNumberParam(
            index: index,
            min: min.getOrThrow,
            max: max.getOrThrow,
            step: step.getOrThrow,
          );
        },
        customStr: (index, values) {
          return GenerateMathProblemCustomStrParam(
            index: index,
            values: values.getOrThrow,
          );
        },
      );
    }

    return MathProblemParams(
      customStrParams: customStrParams,
      numberParams: numberParams,
    );
  }
}
