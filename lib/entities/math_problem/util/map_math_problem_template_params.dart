import 'package:findx_dart_client/app_client.dart';
import 'package:injectable/injectable.dart';

import '../model/math_problem_template_parameter_form.dart';

class MathProblemParams {
  MathProblemParams({
    required this.customStrParams,
    required this.numberParams,
  });

  final List<GenerateMathProblemCustomStrParam> customStrParams;
  final List<GenerateMathProblemNumberParam> numberParams;
}

@lazySingleton
class MapMathProblemTemplateParams {
  MathProblemParams call(List<MathProblemTemplateParameterForm> forms) {
    final customStrParams = <GenerateMathProblemCustomStrParam>[];
    final numberParams = <GenerateMathProblemNumberParam>[];

    for (final form in forms) {
      form.when(
        number: (index, min, max, step) {
          final param = GenerateMathProblemNumberParam(
            index: index,
            min: min.getOrThrow,
            max: max.getOrThrow,
            step: step.getOrThrow,
          );

          numberParams.add(param);
        },
        customStr: (index, values) {
          final param = GenerateMathProblemCustomStrParam(
            index: index,
            values: values.getOrThrow,
          );

          customStrParams.add(param);
        },
      );
    }

    return MathProblemParams(
      customStrParams: customStrParams,
      numberParams: numberParams,
    );
  }
}
