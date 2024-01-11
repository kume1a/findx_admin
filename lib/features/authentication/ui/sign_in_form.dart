import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/loading_text_button.dart';
import '../state/sign_in_form_state.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: BlocBuilder<SignInFormCubit, SignInFormState>(
        buildWhen: (prev, curr) => prev.validateForm != curr.validateForm,
        builder: (_, state) {
          return Form(
            autovalidateMode: state.validateForm ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Sign in',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 64),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  onChanged: context.signInFormCubit.onEmailChanged,
                  validator: (_) => context.signInFormCubit.state.email.translateFailure(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  onChanged: context.signInFormCubit.onPasswordChanged,
                  validator: (_) => context.signInFormCubit.state.password.translateFailure(),
                ),
                const SizedBox(height: 100),
                BlocBuilder<SignInFormCubit, SignInFormState>(
                  buildWhen: (prev, curr) => prev.isSubmitting != curr.isSubmitting,
                  builder: (_, state) {
                    return LoadingTextButton(
                      isLoading: state.isSubmitting,
                      onPressed: context.signInFormCubit.onSubmit,
                      label: 'Submit',
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
