import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/logger.dart';
import '../model/math_problem_template_parameter_form.dart';
import '../model/math_problem_template_placeholder.dart';
import '../util/map_math_problem_template_params.dart';

part 'generate_math_problems_form_state.freezed.dart';

@freezed
class GenerateMathProblemsFormState with _$GenerateMathProblemsFormState {
  const factory GenerateMathProblemsFormState({
    required bool validateForm,
    required RequiredString template,
    required List<MathProblemTemplateParameterForm> paramForms,
    required bool reloadingParamForms,
    required bool isSubmitting,
    int? generatedTotalCount,
  }) = _GenerateMathProblemsFormState;

  factory GenerateMathProblemsFormState.initial() => GenerateMathProblemsFormState(
        validateForm: false,
        template: RequiredString.empty(),
        paramForms: [],
        reloadingParamForms: false,
        isSubmitting: false,
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
    this._mapMathProblemTemplateParams,
  ) : super(GenerateMathProblemsFormState.initial());

  final MathProblemRemoteRepository _mathProblemRemoteRepository;
  final MapMathProblemTemplateParams _mapMathProblemTemplateParams;

  Future<void> onTemplateChanged(String value) async {
    if (state.reloadingParamForms) {
      return;
    }

    emit(state.copyWith(reloadingParamForms: true));

    final parsedTemplatePlaceholders = _parseTemplatePlaceholders(value);

    final paramForms = parsedTemplatePlaceholders
        .map(
          (e) => MathProblemTemplateParameterForm.number(
            index: e.templateParamIndex,
            min: RequiredInt.empty(),
            max: RequiredInt.empty(),
            step: PositiveDouble.empty(),
          ),
        )
        .toList();

    emit(state.copyWith(
      paramForms: paramForms,
      reloadingParamForms: false,
      generatedTotalCount: null,
    ));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.template.invalid || state.paramForms.any((e) => e.invalid)) {
      return;
    }

    emit(state.copyWith(isSubmitting: false));

    final templateParams = _mapMathProblemTemplateParams(state.paramForms);

    final generatedTotalCount = await _mathProblemRemoteRepository.countGenerateValues(
      numberParams: templateParams.numberParams,
      customStrParams: templateParams.customStrParams,
    );

    emit(state.copyWith(
      generatedTotalCount: generatedTotalCount.rightOrNull?.count,
      isSubmitting: false,
    ));
  }

  Future<void> onConfirmGenerate() async {
    if (state.template.invalid || state.paramForms.any((e) => e.invalid)) {
      return;
    }

    emit(state.copyWith(isSubmitting: false));

    final templateParams = _mapMathProblemTemplateParams(state.paramForms);

    final generated = await _mathProblemRemoteRepository.generateValues(
      numberParams: templateParams.numberParams,
      customStrParams: templateParams.customStrParams,
      template: state.template.getOrThrow,
    );

    emit(state.copyWith(isSubmitting: false));

    logger.i(generated);
  }

  void onNumberParamMinChanged(int index, String value) {
    _onParamFormValueChanged(
      index,
      mutate: (form) => form.map(
        number: (val) => MathProblemTemplateParameterForm.number(
          index: val.index,
          min: RequiredInt(value),
          max: val.max,
          step: val.step,
        ),
        customStr: (_) => null,
      ),
    );
  }

  void onNumberParamMaxChanged(int index, String value) {
    _onParamFormValueChanged(
      index,
      mutate: (form) => form.map(
        number: (val) => MathProblemTemplateParameterForm.number(
          index: val.index,
          min: val.min,
          max: RequiredInt(value),
          step: val.step,
        ),
        customStr: (_) => null,
      ),
    );
  }

  void onNumberParamStepChanged(int index, String value) {
    _onParamFormValueChanged(
      index,
      mutate: (form) => form.map(
        number: (val) => MathProblemTemplateParameterForm.number(
          index: val.index,
          min: val.min,
          max: val.max,
          step: PositiveDouble(value),
        ),
        customStr: (_) => null,
      ),
    );
  }

  void onCustomStrParamValueChanged(int index, String value) {
    _onParamFormValueChanged(
      index,
      mutate: (form) => form.map(
        number: (_) => null,
        customStr: (val) => MathProblemTemplateParameterForm.customStr(
          index: val.index,
          values: RequiredString(value),
        ),
      ),
    );
  }

  Future<void> _onParamFormValueChanged(
    int index, {
    required MathProblemTemplateParameterForm? Function(MathProblemTemplateParameterForm form) mutate,
  }) async {
    final form = state.paramForms.elementAtOrNull(index);
    if (form == null) {
      return;
    }

    final newForm = mutate(form);

    if (newForm == null) {
      return;
    }

    _replaceFormAndEmit(index, newForm);
  }

  void onParamFormToggled(int index, MathProblemTemplateParameterFormType formType) {
    final form = state.paramForms.elementAtOrNull(index);
    if (form == null) {
      return;
    }

    final newForm = switch (formType) {
      MathProblemTemplateParameterFormType.number => MathProblemTemplateParameterForm.number(
          index: form.index,
          min: RequiredInt.empty(),
          max: RequiredInt.empty(),
          step: PositiveDouble.empty(),
        ),
      MathProblemTemplateParameterFormType.customStr => MathProblemTemplateParameterForm.customStr(
          index: form.index,
          values: RequiredString.empty(),
        ),
    };

    _replaceFormAndEmit(index, newForm);
  }

  void _replaceFormAndEmit(int index, MathProblemTemplateParameterForm form) {
    final formsCopy = List.of(state.paramForms);

    formsCopy.removeAt(index);
    formsCopy.insert(index, form);

    emit(state.copyWith(
      paramForms: formsCopy,
      generatedTotalCount: null,
    ));
  }

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
