import 'dart:typed_data';

import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/ui/toast.dart';
import '../../../shared/util/toast/notify_simple_action_failure.dart';

part 'mutate_math_problem_form_state.freezed.dart';

@freezed
class MutateMathProblemFormState with _$MutateMathProblemFormState {
  const factory MutateMathProblemFormState({
    required PositiveInt difficulty,
    required String text,
    required String tex,
    String? mathFieldId,
    String? mathSubFieldId,
    required List<Uint8List> images,
    required bool isSubmitting,
    required bool validateForm,
    required SimpleDataState<DataPage<MathFieldPageItem>> mathFields,
    required SimpleDataState<DataPage<MathSubFieldPageItem>> mathSubFields,
  }) = _MutateMathProblemFormState;

  factory MutateMathProblemFormState.initial() => MutateMathProblemFormState(
        difficulty: PositiveInt.empty(),
        text: '',
        tex: '',
        images: [],
        isSubmitting: false,
        validateForm: false,
        mathFields: SimpleDataState.idle(),
        mathSubFields: SimpleDataState.idle(),
      );
}

extension MutateMathProblemFormCubitX on BuildContext {
  MutateMathProblemFormCubit get mutateMathProblemFormCubit => read<MutateMathProblemFormCubit>();
}

@injectable
class MutateMathProblemFormCubit extends Cubit<MutateMathProblemFormState> {
  MutateMathProblemFormCubit(
    this._mathSubFieldRemoteRepository,
    this._mathFieldRemoteRepository,
    this._mathProblemRemoteRepository,
    this._pageNavigator,
  ) : super(MutateMathProblemFormState.initial());

  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;
  final MathFieldRemoteRepository _mathFieldRemoteRepository;
  final MathProblemRemoteRepository _mathProblemRemoteRepository;
  final PageNavigator _pageNavigator;

  final difficultyFieldController = TextEditingController();
  final textFieldController = TextEditingController();
  final texFieldController = TextEditingController();

  String? _mathProblemId;

  Future<void> init(String? mathProblemId) async {
    _mathProblemId = mathProblemId;

    await _fetchInitialEntity();
    await _fetchMathFields();
  }

  @override
  Future<void> close() async {
    difficultyFieldController.dispose();
    textFieldController.dispose();
    texFieldController.dispose();

    super.close();
  }

  Future<void> _fetchInitialEntity() async {
    if (_mathProblemId == null) {
      return;
    }

    final mathProblem = await _mathProblemRemoteRepository.getById(_mathProblemId!);

    mathProblem.ifRight((r) {
      difficultyFieldController.text = r.difficulty.toString();
      if (r.text != null) {
        textFieldController.text = r.text!;
      }
      if (r.tex != null) {
        texFieldController.text = r.tex!;
      }

      emit(state.copyWith(
        difficulty: PositiveInt.fromInt(r.difficulty),
        text: r.text ?? state.text,
        tex: r.tex ?? state.tex,
      ));
    });
  }

  void onDifficultyChanged(String value) {
    emit(state.copyWith(difficulty: PositiveInt(value)));
  }

  void onTextChanged(String value) {
    emit(state.copyWith(text: value));
  }

  void onTexChanged(String value) {
    emit(state.copyWith(tex: value));
  }

  void onMathFieldChanged(MathFieldPageItem? value) {
    if (value == null) {
      return;
    }

    emit(state.copyWith(mathFieldId: value.id));

    _fetchMathSubFields(value);
  }

  void onMathSubFieldChanged(MathSubFieldPageItem? value) {
    if (value == null) {
      return;
    }

    emit(state.copyWith(mathSubFieldId: value.id));
  }

  void onPickImages(List<Uint8List> files) {
    emit(state.copyWith(images: files));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.difficulty.invalid || state.mathFieldId == null || state.mathSubFieldId == null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    if (_mathProblemId != null) {
      final res = await _mathProblemRemoteRepository.update(
        id: _mathProblemId!,
        difficulty: state.difficulty.getOrThrow,
        mathFieldId: state.mathFieldId,
        mathSubFieldId: state.mathSubFieldId,
        tex: state.tex.isNotEmpty ? state.tex : null,
        text: state.text.isNotEmpty ? state.text : null,
      );

      emit(state.copyWith(isSubmitting: false));

      res.fold(
        notifySimpleActionFailure,
        (r) {
          showToast('Updated math problem successfully');
          _pageNavigator.pop();
        },
      );
    } else {
      final res = await _mathProblemRemoteRepository.create(
        difficulty: state.difficulty.getOrThrow,
        tex: state.tex.isNotEmpty ? state.tex : null,
        text: state.text.isNotEmpty ? state.text : null,
        mathFieldId: state.mathFieldId!,
        mathSubFieldId: state.mathSubFieldId!,
      );

      emit(state.copyWith(isSubmitting: false));

      res.fold(
        notifySimpleActionFailure,
        (r) {
          showToast('Math problem successfully');
          _pageNavigator.pop();
        },
      );
    }
  }

  Future<void> _fetchMathFields() async {
    final res = await _mathFieldRemoteRepository.filter(
      limit: 200,
    );

    emit(state.copyWith(mathFields: SimpleDataState.fromEither(res)));
  }

  Future<void> _fetchMathSubFields(MathFieldPageItem mathField) async {
    final res = await _mathSubFieldRemoteRepository.filter(
      limit: 200,
      mathFieldId: mathField.id,
    );

    emit(state.copyWith(mathSubFields: SimpleDataState.fromEither(res)));
  }
}
