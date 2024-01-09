import 'dart:developer';

import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'generate_math_problems_form_state.freezed.dart';

class MathProblemTemplateCustomStrParamForm {
  MathProblemTemplateCustomStrParamForm({
    required this.index,
    required this.values,
  });

  final PositiveInt index;
  final RequiredString values;
}

class MathProblemTemplateNumberParamForm {
  MathProblemTemplateNumberParamForm({
    required this.index,
    required this.min,
    required this.max,
    required this.step,
  });

  final PositiveInt index;
  final int? min;
  final int? max;
  final PositiveInt step;
}

@freezed
class GenerateMathProblemsFormState with _$GenerateMathProblemsFormState {
  const factory GenerateMathProblemsFormState({
    required bool validateForm,
    required RequiredString template,
    required List<MathProblemTemplateCustomStrParamForm> customStrParams,
    required List<MathProblemTemplateNumberParamForm> numberParams,
  }) = _GenerateMathProblemsFormState;

  factory GenerateMathProblemsFormState.initial() => GenerateMathProblemsFormState(
        validateForm: false,
        template: RequiredString.empty(),
        customStrParams: [],
        numberParams: [],
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
    final placeholders = _templatePlaceholderRegexp.allMatches(value);

    log(placeholders.toString());
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));
  }

  void onNumberParamMinChanged(int index, String value) {}

  void onNumberParamMaxChanged(int index, String value) {}

  void onNumberParamStepChanged(int index, String value) {}
}
