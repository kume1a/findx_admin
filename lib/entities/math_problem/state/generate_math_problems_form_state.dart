import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/util/collection.dart';
import '../model/math_problem_template_parameter_form.dart';
import '../model/math_problem_template_placeholder.dart';

part 'generate_math_problems_form_state.freezed.dart';

@freezed
class GenerateMathProblemsFormState with _$GenerateMathProblemsFormState {
  const factory GenerateMathProblemsFormState({
    required bool validateForm,
    required RequiredString template,
    required List<MathProblemTemplateParameterForm> paramForms,
    required bool reloadingParamForms,
  }) = _GenerateMathProblemsFormState;

  factory GenerateMathProblemsFormState.initial() => GenerateMathProblemsFormState(
        validateForm: false,
        template: RequiredString.empty(),
        paramForms: [],
        reloadingParamForms: false,
      );
}

extension GenerateMathProblemsFormCubitX on BuildContext {
  GenerateMathProblemsFormCubit get generateMathProblemsFormCubit => read<GenerateMathProblemsFormCubit>();
}

final _templatePlaceholderRegexp = RegExp(r'#(\d)');

@injectable
class GenerateMathProblemsFormCubit extends Cubit<GenerateMathProblemsFormState> {
  GenerateMathProblemsFormCubit(
    this._mathProblemRemoteRepository,
  ) : super(GenerateMathProblemsFormState.initial());

  final MathProblemRemoteRepository _mathProblemRemoteRepository;

  Future<void> onTemplateChanged(String value) async {
    if (state.reloadingParamForms) {
      return;
    }

    emit(state.copyWith(reloadingParamForms: true));

    final parsedTemplatePlaceholders = _parseTemplatePlaceholders(value);
    final paramFormsClone = List.of(state.paramForms);

    final partitionedParamForms = List.of(parsedTemplatePlaceholders).partition(
      (templatePlaceholder) =>
          paramFormsClone.any((paramForm) => paramForm.index == templatePlaceholder.templateParamIndex),
    );

    final existingTemplatePlaceholders = partitionedParamForms.pass;
    final newTemplatePlaceholders = partitionedParamForms.fail;

    final newParamForms = newTemplatePlaceholders.map(
      (e) => MathProblemTemplateParameterForm.number(
        index: e.templateParamIndex,
        min: RequiredInt.fromInt(0),
        max: RequiredInt.fromInt(0),
        step: PositiveInt.fromInt(1),
      ),
    );

    final paramForms = paramFormsClone
        .where(
          (paramForm) => existingTemplatePlaceholders
              .any((placeholder) => placeholder.templateParamIndex == paramForm.index),
        )
        .toList()
      ..addAll(newParamForms);

    emit(state.copyWith(
      paramForms: paramForms,
      reloadingParamForms: false,
    ));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));
  }

  void onNumberParamMinChanged(int index, String value) {}

  void onNumberParamMaxChanged(int index, String value) {}

  void onNumberParamStepChanged(int index, String value) {}

  void onCustomStrParamValueChanged(int index, String value) {}

  List<MathProblemTemplatePlaceholder> _parseTemplatePlaceholders(String template) {
    return groupBy(
      _templatePlaceholderRegexp.allMatches(template),
      (m) => int.tryParse(m.group(1) ?? 'INVALID'),
    )
        .entries
        .where((e) => e.key != null)
        .map((e) {
          if (e.key == null) {
            return null;
          }

          final firstMatch = e.value.firstOrNull;
          if (firstMatch == null) {
            return null;
          }

          return MathProblemTemplatePlaceholder(
            templateParamIndex: e.key!,
            placeholder: firstMatch.group(0) ?? '',
            positions: e.value
                .map(
                  (match) => StringPosition(
                    start: match.start,
                    end: match.end,
                  ),
                )
                .toList(),
          );
        })
        .where((e) => e != null)
        .cast<MathProblemTemplatePlaceholder>()
        .toList();
  }
}
