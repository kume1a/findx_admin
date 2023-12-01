import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../../../shared/ui/toast.dart';
import '../../../shared/util/toast/notify_simple_action_failure.dart';

part 'mutate_math_sub_field_form_state.freezed.dart';

@freezed
class MutateMathSubFieldFormState with _$MutateMathSubFieldFormState {
  const factory MutateMathSubFieldFormState({
    required Name name,
    String? mathFieldId,
    required bool isSubmitting,
    required bool validateForm,
    required SimpleDataState<DataPage<MathFieldPageItem>> mathFields,
  }) = _MutateMathSubFieldFormState;

  factory MutateMathSubFieldFormState.initial() => MutateMathSubFieldFormState(
        name: Name.empty(),
        isSubmitting: false,
        validateForm: false,
        mathFields: SimpleDataState.idle(),
      );
}

extension MutateMathSubFieldFormCubitX on BuildContext {
  MutateMathSubFieldFormCubit get mutateMathSubFieldFormCubit => read<MutateMathSubFieldFormCubit>();
}

@injectable
class MutateMathSubFieldFormCubit extends Cubit<MutateMathSubFieldFormState> {
  MutateMathSubFieldFormCubit(
    this._mathSubFieldRemoteRepository,
    this._mathFieldRemoteRepository,
    this._pageNavigator,
  ) : super(MutateMathSubFieldFormState.initial());

  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;
  final MathFieldRemoteRepository _mathFieldRemoteRepository;
  final PageNavigator _pageNavigator;

  final TextEditingController nameFieldController = TextEditingController();

  String? _mathSubFieldId;

  Future<void> init(String? mathSubFieldId) async {
    _mathSubFieldId = mathSubFieldId;

    await _fetchInitialEntity();
    await _fetchMathFields();
  }

  @override
  Future<void> close() async {
    nameFieldController.dispose();

    super.close();
  }

  Future<void> _fetchInitialEntity() async {
    if (_mathSubFieldId == null) {
      return;
    }

    final mathSubField = await _mathSubFieldRemoteRepository.getById(_mathSubFieldId!);

    mathSubField.ifRight((r) {
      nameFieldController.text = r.name;

      emit(state.copyWith(name: Name(r.name)));
    });
  }

  Future<void> _fetchMathFields() async {
    final res = await _mathFieldRemoteRepository.filter(
      limit: 200,
    );

    emit(state.copyWith(mathFields: SimpleDataState.fromEither(res)));
  }

  void onNameChanged(String value) {
    emit(state.copyWith(name: Name(value)));
  }

  void onMathFieldChanged(MathFieldPageItem? value) {
    if (value == null) {
      return;
    }

    emit(state.copyWith(mathFieldId: value.id));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.name.invalid || state.mathFieldId == null) {
      return;
    }

    emit(state.copyWith(isSubmitting: true));

    if (_mathSubFieldId != null) {
      final res = await _mathSubFieldRemoteRepository.update(
        id: _mathSubFieldId!,
        name: state.name.getOrThrow,
      );

      emit(state.copyWith(isSubmitting: false));

      res.fold(
        notifySimpleActionFailure,
        (r) {
          showToast('Updated math field successfully');
          _pageNavigator.pop();
        },
      );
    } else {
      final res = await _mathSubFieldRemoteRepository.create(
        name: state.name.getOrThrow,
        mathFieldId: state.mathFieldId!,
      );

      emit(state.copyWith(isSubmitting: false));

      res.fold(
        notifySimpleActionFailure,
        (r) {
          showToast('Math field created successfully');
          _pageNavigator.pop();
        },
      );
    }
  }
}
