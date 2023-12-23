import 'dart:typed_data';

import 'package:collection/collection.dart';
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
    MathFieldPageItem? mathField,
    MathSubFieldPageItem? mathSubField,
    required List<Uint8List> images,
    required bool isSubmitting,
    required bool validateForm,
    required SimpleDataState<DataPage<MathFieldPageItem>> mathFields,
    required SimpleDataState<DataPage<MathSubFieldPageItem>> mathSubFields,
    required List<MediaFile> currentImages,
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
        currentImages: [],
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
    this._createMathProblemUsecase,
    this._updateMathProblemUsecase,
    this._pageNavigator,
  ) : super(MutateMathProblemFormState.initial());

  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;
  final MathFieldRemoteRepository _mathFieldRemoteRepository;
  final MathProblemRemoteRepository _mathProblemRemoteRepository;
  final CreateMathProblemUsecase _createMathProblemUsecase;
  final UpdateMathProblemUsecase _updateMathProblemUsecase;
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

    emit(state.copyWith(mathField: value));

    _fetchMathSubFields(value, null);
  }

  void onMathSubFieldChanged(MathSubFieldPageItem? value) {
    if (value == null) {
      return;
    }

    emit(state.copyWith(mathSubField: value));
  }

  void onPickImages(List<Uint8List> files) {
    emit(state.copyWith(images: files));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.difficulty.invalid || state.mathField == null || state.mathSubField == null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    if (_mathProblemId != null) {
      final res = await _updateMathProblemUsecase(
        id: _mathProblemId!,
        difficulty: state.difficulty.getOrThrow,
        mathFieldId: state.mathField!.id,
        mathSubFieldId: state.mathSubField!.id,
        tex: state.tex.isNotEmpty ? state.tex : null,
        text: state.text.isNotEmpty ? state.text : null,
        images: state.images,
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
      final res = await _createMathProblemUsecase(
        difficulty: state.difficulty.getOrThrow,
        tex: state.tex.isNotEmpty ? state.tex : null,
        text: state.text.isNotEmpty ? state.text : null,
        mathFieldId: state.mathField!.id,
        mathSubFieldId: state.mathSubField!.id,
        images: state.images,
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

  Future<void> _fetchInitialEntity() async {
    if (_mathProblemId == null) {
      return;
    }

    final mathProblem = await _mathProblemRemoteRepository.getById(_mathProblemId!);

    mathProblem.ifRight((r) async {
      difficultyFieldController.text = r.difficulty.toString();
      if (r.text != null) {
        textFieldController.text = r.text!;
      }
      if (r.tex != null) {
        texFieldController.text = r.tex!;
      }

      final mathField = await _mathFieldRemoteRepository.getById(r.mathFieldId);
      final mathSubField = await _mathSubFieldRemoteRepository.getById(r.mathSubFieldId);

      mathField.ifRight((r) => _fetchMathSubFields(r, mathSubField.rightOrNull));

      emit(state.copyWith(
        difficulty: PositiveInt.fromInt(r.difficulty),
        text: r.text ?? state.text,
        tex: r.tex ?? state.tex,
        mathField: mathField.rightOrNull,
        currentImages: r.images ?? [],
      ));
    });
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
