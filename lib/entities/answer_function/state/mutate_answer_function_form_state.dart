import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/logger.dart';
import '../../../shared/ui/toast.dart';
import '../../../shared/util/toast/notify_simple_action_failure.dart';

part 'mutate_answer_function_form_state.freezed.dart';

@freezed
class MutateAnswerFunctionFormState with _$MutateAnswerFunctionFormState {
  const factory MutateAnswerFunctionFormState({
    required RequiredString func,
    required String? condition,
    required Percent weight,
    required bool isSubmitting,
    required bool validateForm,
  }) = _MutateAnswerFunctionFormState;

  factory MutateAnswerFunctionFormState.initial() => MutateAnswerFunctionFormState(
        func: RequiredString.empty(),
        condition: null,
        weight: Percent.empty(),
        isSubmitting: false,
        validateForm: false,
      );
}

extension MutateAnswerFunctionFormCubitX on BuildContext {
  MutateAnswerFunctionFormCubit get mutateAnswerFunctionFormCubit => read<MutateAnswerFunctionFormCubit>();
}

@injectable
class MutateAnswerFunctionFormCubit extends Cubit<MutateAnswerFunctionFormState> {
  MutateAnswerFunctionFormCubit(
    this._answerFunctionRemoteRepository,
    this._pageNavigator,
  ) : super(MutateAnswerFunctionFormState.initial());

  final AnswerFunctionRemoteRepository _answerFunctionRemoteRepository;
  final PageNavigator _pageNavigator;

  final funcFieldController = TextEditingController();
  final conditionFieldController = TextEditingController();
  final weightFieldController = TextEditingController();

  String? _answerFunctionId;

  void init(String? answerFunctionId) {
    _answerFunctionId = answerFunctionId;

    _fetchInitialEntity();
  }

  @override
  Future<void> close() async {
    funcFieldController.dispose();
    conditionFieldController.dispose();
    weightFieldController.dispose();

    super.close();
  }

  Future<void> _fetchInitialEntity() async {
    if (_answerFunctionId == null) {
      return;
    }

    final answerFunction = await _answerFunctionRemoteRepository.getById(_answerFunctionId!);

    answerFunction.ifRight((r) {
      funcFieldController.text = r.func;
      conditionFieldController.text = r.condition ?? '';
      weightFieldController.text = r.weight.toString();

      emit(state.copyWith(
        func: RequiredString(r.func),
        condition: r.condition,
        weight: Percent(r.weight),
      ));
    });
  }

  void onFuncChanged(String value) {
    emit(state.copyWith(func: RequiredString(value)));
  }

  void onConditionChanged(String value) {
    emit(state.copyWith(condition: value));
  }

  void onWeightChanged(String value) {
    emit(state.copyWith(weight: Percent(value)));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.func.invalid || state.weight.invalid) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    if (_answerFunctionId != null) {
      final res = await _answerFunctionRemoteRepository.update(
        id: _answerFunctionId!,
        func: state.func.getOrThrow,
        condition: state.condition?.isNotEmpty == true ? state.condition : null,
        weight: state.weight.getOrThrow,
      );

      emit(state.copyWith(isSubmitting: false));

      res.fold(
        notifyActionFailure,
        (r) {
          showToast('Updated answer function successfully');
          _pageNavigator.pop();
        },
      );
      return;
    }

    final res = await _answerFunctionRemoteRepository.create(
      func: state.func.getOrThrow,
      condition: state.condition?.isNotEmpty == true ? state.condition : null,
      weight: state.weight.getOrThrow,
    );

    emit(state.copyWith(isSubmitting: false));

    res.fold(
      notifyActionFailure,
      (r) {
        showToast('Answer function created successfully');
        _pageNavigator.pop();
      },
    );
  }
}
