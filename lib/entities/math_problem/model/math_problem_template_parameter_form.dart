import 'package:common_models/common_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'math_problem_template_parameter_form.freezed.dart';

@freezed
sealed class MathProblemTemplateParameterForm with _$MathProblemTemplateParameterForm {
  const factory MathProblemTemplateParameterForm.number({
    required int index,
    required RequiredInt min,
    required RequiredInt max,
    required PositiveInt step,
  }) = _number;

  const factory MathProblemTemplateParameterForm.customStr({
    required int index,
    required RequiredString values,
  }) = _customStr;
}
