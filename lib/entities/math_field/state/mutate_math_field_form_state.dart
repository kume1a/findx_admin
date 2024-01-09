import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/ui/toast.dart';
import '../../../shared/util/toast/notify_simple_action_failure.dart';

part 'mutate_math_field_form_state.freezed.dart';

@freezed
class MutateMathFieldFormState with _$MutateMathFieldFormState {
  const factory MutateMathFieldFormState({
    required Name name,
    required bool isSubmitting,
    required bool validateForm,
  }) = _MutateMathFieldFormState;

  factory MutateMathFieldFormState.initial() => MutateMathFieldFormState(
        name: Name.empty(),
        isSubmitting: false,
        validateForm: false,
      );
}

extension MutateMathFieldFormCubitX on BuildContext {
  MutateMathFieldFormCubit get mutateMathFieldFormCubit => read<MutateMathFieldFormCubit>();
}

@injectable
class MutateMathFieldFormCubit extends Cubit<MutateMathFieldFormState> {
  MutateMathFieldFormCubit(
    this._mathFieldRemoteRepository,
    this._pageNavigator,
  ) : super(MutateMathFieldFormState.initial());

  final MathFieldRemoteRepository _mathFieldRemoteRepository;
  final PageNavigator _pageNavigator;

  final TextEditingController nameFieldController = TextEditingController();

  String? _mathFieldId;

  void init(String? mathFieldId) {
    _mathFieldId = mathFieldId;

    _fetchInitialEntity();
  }

  @override
  Future<void> close() async {
    nameFieldController.dispose();

    super.close();
  }

  Future<void> _fetchInitialEntity() async {
    if (_mathFieldId == null) {
      return;
    }

    final mathField = await _mathFieldRemoteRepository.getById(_mathFieldId!);

    mathField.ifRight((r) {
      nameFieldController.text = r.name;

      emit(state.copyWith(name: Name(r.name)));
    });
  }

  void onNameChanged(String value) {
    emit(state.copyWith(name: Name(value)));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.name.invalid) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    if (_mathFieldId != null) {
      final res = await _mathFieldRemoteRepository.update(
        id: _mathFieldId!,
        name: state.name.getOrThrow,
      );

      emit(state.copyWith(isSubmitting: false));

      res.fold(
        notifyActionFailure,
        (r) {
          showToast('Updated math field successfully');
          _pageNavigator.pop();
        },
      );
    } else {
      final res = await _mathFieldRemoteRepository.create(name: state.name.getOrThrow);

      emit(state.copyWith(isSubmitting: false));

      res.fold(
        notifyActionFailure,
        (r) {
          showToast('Math field created successfully');
          _pageNavigator.pop();
        },
      );
    }
  }
}
