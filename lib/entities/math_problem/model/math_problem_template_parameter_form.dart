import 'package:common_models/common_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'math_problem_template_parameter_form.freezed.dart';

enum MathProblemTemplateParameterFormType {
  number,
  customStr,
}

@freezed
sealed class MathProblemTemplateParameterForm with _$MathProblemTemplateParameterForm {
  const factory MathProblemTemplateParameterForm.number({
    required int index,
    required RequiredInt min,
    required RequiredInt max,
    required PositiveDouble step,
  }) = _number;

  const factory MathProblemTemplateParameterForm.customStr({
    required int index,
    required RequiredString values,
  }) = _customStr;

  const MathProblemTemplateParameterForm._();

  bool get valid {
    return when(
      number: (index, min, max, step) => min.valid && max.valid && step.valid,
      customStr: (index, values) => values.valid,
    );
  }

  bool get invalid => !valid;
}
