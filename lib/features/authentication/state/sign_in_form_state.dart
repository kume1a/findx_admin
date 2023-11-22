import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/page_navigator.dart';
import '../util/notify_admin_sign_in_failure.dart';

part 'sign_in_form_state.freezed.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required Email email,
    required Password password,
    required bool validateForm,
    required bool isSubmitting,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
        email: Email.empty(),
        password: Password.empty(),
        validateForm: false,
        isSubmitting: false,
      );
}

extension SignInFormCubitX on BuildContext {
  SignInFormCubit get signInFormCubit => read<SignInFormCubit>();
}

@injectable
class SignInFormCubit extends Cubit<SignInFormState> {
  SignInFormCubit(
    this._authenticationFacade,
    this._authTokenStore,
    this._pageNavigator,
  ) : super(SignInFormState.initial());

  final AuthenticationFacade _authenticationFacade;
  final AuthTokenStore _authTokenStore;
  final PageNavigator _pageNavigator;

  void onEmailChanged(String value) {
    emit(state.copyWith(email: Email(value)));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: Password(value)));
  }

  Future<void> onSubmit() async {
    emit(state.copyWith(validateForm: true));

    if (state.email.invalid || state.password.invalid) {
      return;
    }

    final res = await _authenticationFacade.adminSignIn(
      email: state.email.getOrThrow,
      password: state.password.getOrThrow,
    );

    res.fold(
      notifyAdminSignInFailure,
      (r) async {
        await _authTokenStore.writeAccessToken(r.accessToken);
        await _authTokenStore.writeRefreshToken(r.refreshToken);

        _pageNavigator.toMain();
      },
    );
  }
}
