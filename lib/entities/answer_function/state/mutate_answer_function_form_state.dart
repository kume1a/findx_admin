import 'package:common_models/common_models.dart';

import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../app/navigation/page_navigator.dart';
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
    NumberType? numberType,
    MathSubFieldPageItem? mathSubField,
    required SimpleDataState<DataPage<MathSubFieldPageItem>> mathSubFields,
  }) = _MutateAnswerFunctionFormState;

  factory MutateAnswerFunctionFormState.initial() => MutateAnswerFunctionFormState(
        func: RequiredString.empty(),
        condition: null,
        weight: Percent.empty(),
        isSubmitting: false,
        validateForm: false,
        mathSubFields: SimpleDataState.idle(),
      );
}

extension MutateAnswerFunctionFormCubitX on BuildContext {
  MutateAnswerFunctionFormCubit get mutateAnswerFunctionFormCubit => read<MutateAnswerFunctionFormCubit>();
}

@injectable
class MutateAnswerFunctionFormCubit extends Cubit<MutateAnswerFunctionFormState> {
  MutateAnswerFunctionFormCubit(
    this._answerFunctionRemoteRepository,
    this._mathSubFieldRemoteRepository,
    this._pageNavigator,
  ) : super(MutateAnswerFunctionFormState.initial());

  final AnswerFunctionRemoteRepository _answerFunctionRemoteRepository;
  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;
  final PageNavigator _pageNavigator;

  final funcFieldController = TextEditingController();
  final conditionFieldController = TextEditingController();
  final weightFieldController = TextEditingController();

  String? _answerFunctionId;

  Future<void> init(String? answerFunctionId) async {
    _answerFunctionId = answerFunctionId;

    await _fetchMathSubFields();
    await _fetchInitialEntity();
  }

  @override
  Future<void> close() async {
    funcFieldController.dispose();
    conditionFieldController.dispose();
    weightFieldController.dispose();

    super.close();
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

  void onNumberTypeChanged(NumberType? value) {
    emit(state.copyWith(numberType: value));
  }

  void onMathSubFieldChanged(Fragment$MathSubFieldWithRelations? value) {
    emit(state.copyWith(mathSubField: value));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.func.invalid ||
        state.weight.invalid ||
        state.numberType == null ||
        state.mathSubField == null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    if (_answerFunctionId != null) {
      final res = await _answerFunctionRemoteRepository.update(
        id: _answerFunctionId!,
        func: state.func.getOrThrow,
        condition: state.condition?.isNotEmpty == true ? state.condition : null,
        weight: state.weight.getOrThrow,
        numberType: state.numberType!,
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
      numberType: state.numberType!,
      mathSubFieldId: state.mathSubField!.id,
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

  Future<void> _fetchMathSubFields() async {
    emit(state.copyWith(mathSubFields: SimpleDataState.loading()));

    final res = await _mathSubFieldRemoteRepository.filter(
      limit: 200,
    );

    emit(state.copyWith(mathSubFields: SimpleDataState.fromEither(res)));
  }

  Future<void> _fetchInitialEntity() async {
    if (_answerFunctionId == null) {
      return;
    }

    final answerFunction = await _answerFunctionRemoteRepository.getById(_answerFunctionId!);

    final mathSubField =
        await answerFunction.ifRight((r) => _mathSubFieldRemoteRepository.getById(r.mathSubFieldId));

    answerFunction.ifRight((r) {
      funcFieldController.text = r.func;
      conditionFieldController.text = r.condition ?? '';
      weightFieldController.text = r.weight.toString();

      emit(state.copyWith(
        func: RequiredString(r.func),
        condition: r.condition,
        weight: Percent(r.weight),
        numberType: r.numberType,
        mathSubField: mathSubField?.rightOrNull,
      ));
    });
  }
}
