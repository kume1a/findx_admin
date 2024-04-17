import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/ui/toast.dart';
import '../../../shared/util/toast/notify_network_call_error.dart';
import '../model/math_problem_template_parameter_form.dart';
import '../model/math_problem_template_placeholder.dart';
import '../util/map_math_problem_template_params.dart';

part 'generate_math_problems_form_state.freezed.dart';

enum GenerateMathProblemsFormStage {
  templating,
  submitting,
  generated,
}

@freezed
class GenerateMathProblemsFormState with _$GenerateMathProblemsFormState {
  const factory GenerateMathProblemsFormState({
    required GenerateMathProblemsFormStage stage,
    required bool validateForm,
    required RequiredString template,
    required List<MathProblemTemplateParameterForm> paramForms,
    required bool reloadingParamForms,
    required bool isSubmitting,
    required DataState<NetworkCallError, List<GenerateMathProblemValuesRes>> generatedMathProblemValues,
    int? generatedTotalCount,
    required SimpleDataState<DataPage<MathFieldPageItem>> mathFields,
    required SimpleDataState<DataPage<MathSubFieldPageItem>> mathSubFields,
    MathFieldPageItem? mathField,
    MathSubFieldPageItem? mathSubField,
    required Percent difficulty,
    required RequiredString generatedBatchName,
    required String answerConditionFunc,
    required String correctAnswerConditionFunc,
  }) = _GenerateMathProblemsFormState;

  factory GenerateMathProblemsFormState.initial() => GenerateMathProblemsFormState(
        stage: GenerateMathProblemsFormStage.templating,
        validateForm: false,
        template: RequiredString.empty(),
        paramForms: [],
        reloadingParamForms: false,
        generatedMathProblemValues: DataState.idle(),
        isSubmitting: false,
        mathFields: SimpleDataState.idle(),
        mathSubFields: SimpleDataState.idle(),
        difficulty: Percent.empty(),
        generatedBatchName: RequiredString.empty(),
        answerConditionFunc: '',
        correctAnswerConditionFunc: '',
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
    this._bulkCreateMathProblemsUsecase,
    this._mathFieldRemoteRepository,
    this._mathSubFieldRemoteRepository,
    this._router,
  ) : super(GenerateMathProblemsFormState.initial()) {
    _init();
  }

  final MathProblemRemoteRepository _mathProblemRemoteRepository;
  final MapMathProblemTemplateParams _mapMathProblemTemplateParams;
  final BulkCreateMathProblemsUsecase _bulkCreateMathProblemsUsecase;
  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;
  final MathFieldRemoteRepository _mathFieldRemoteRepository;
  final GoRouter _router;

  Future<void> _init() async {
    await _fetchMathFields();
  }

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
      template: RequiredString(value),
    ));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.template.invalid ||
        state.difficulty.invalid ||
        state.mathField == null ||
        state.mathSubField == null ||
        state.paramForms.any((e) => e.invalid)) {
      return;
    }

    emit(state.copyWith(
      isSubmitting: true,
      stage: GenerateMathProblemsFormStage.submitting,
    ));

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
    if (state.template.invalid || state.paramForms.any((e) => e.invalid) || state.mathSubField == null) {
      return;
    }

    emit(state.copyWith(
      isSubmitting: true,
      generatedMathProblemValues: DataState.loading(),
    ));

    final templateParams = _mapMathProblemTemplateParams(state.paramForms);

    final generated = await _mathProblemRemoteRepository.generateValues(
      numberParams: templateParams.numberParams,
      customStrParams: templateParams.customStrParams,
      template: state.template.getOrThrow,
      mathSubFieldId: state.mathSubField!.id,
      answerConditionFunc: state.answerConditionFunc.isNotEmpty ? state.answerConditionFunc : null,
      correctAnswerConditionFunc:
          state.correctAnswerConditionFunc.isNotEmpty ? state.correctAnswerConditionFunc : null,
    );

    emit(state.copyWith(
      isSubmitting: false,
      stage: GenerateMathProblemsFormStage.generated,
      generatedMathProblemValues: DataState.fromEither(generated),
    ));
  }

  Future<void> cancelGenerateMathProblems() async {
    emit(state.copyWith(
      isSubmitting: false,
      generatedTotalCount: null,
      stage: GenerateMathProblemsFormStage.templating,
      generatedMathProblemValues: DataState.idle(),
    ));
  }

  Future<void> onSubmitGeneratedValues() async {
    if (state.difficulty.invalid ||
        state.mathField == null ||
        state.mathSubField == null ||
        state.generatedBatchName.invalid) {
      return;
    }

    final values = state.generatedMathProblemValues.getOrNull;

    if (values == null) {
      return;
    }

    if (values.any((element) => element.answers == null || element.answers?.length != 4)) {
      showToast('All answers must be defined');
      return;
    }

    final params = List.of(values)
        .map(
          (e) => CreateMathProblemParams(
            difficulty: state.difficulty.getOrThrow,
            text: null,
            tex: e.tex,
            mathFieldId: state.mathField!.id,
            mathSubFieldId: state.mathSubField!.id,
            images: null,
            answers: e.answers!
                .map(
                  (answer) => CreateMathProblemAnswerInput(
                    isCorrect: answer.isCorrect,
                    tex: answer.tex,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    emit(state.copyWith(isSubmitting: true));

    final res = await _bulkCreateMathProblemsUsecase(
      params,
      generatedBatchName: state.generatedBatchName.getOrThrow,
    );

    emit(state.copyWith(isSubmitting: false));

    res.fold(
      notifyNetworkCallError,
      (_) => _router.pop(),
    );
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

  void onDifficultyChanged(String value) {
    emit(state.copyWith(difficulty: Percent(value)));
  }

  void onGeneratedBatchNameChanged(String value) {
    emit(state.copyWith(generatedBatchName: RequiredString(value)));
  }

  void onAnswerConditionFuncChanged(String value) {
    emit(state.copyWith(answerConditionFunc: value));
  }

  void onCorrectAnswerConditionFuncChanged(String value) {
    emit(state.copyWith(correctAnswerConditionFunc: value));
  }

  void onMathFieldChanged(MathFieldPageItem? value) {
    if (value == null) {
      return;
    }

    emit(state.copyWith(mathField: value));

    _fetchMathSubFields(value, null);
  }

  void onMathSubFieldChanged(MathSubFieldPageItem? value) {
    if (value == null) {
      return;
    }

    emit(state.copyWith(mathSubField: value));
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

  Future<void> _fetchMathFields() async {
    final res = await _mathFieldRemoteRepository.filter(
      limit: 200,
    );

    emit(state.copyWith(mathFields: SimpleDataState.fromEither(res)));
  }

  Future<void> _fetchMathSubFields(
    MathFieldPageItem mathField,
    MathSubFieldGetByIdRes? mathSubField,
  ) async {
    final res = await _mathSubFieldRemoteRepository.filter(
      limit: 200,
      mathFieldId: mathField.id,
    );

    final selected = res.rightOrNull?.items.firstWhereOrNull((e) => e.id == mathSubField?.id);

    emit(state.copyWith(
      mathSubFields: SimpleDataState.fromEither(res),
      mathSubField: selected,
    ));
  }
}
