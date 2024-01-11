import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/loading_text_button.dart';
import '../state/mutate_math_field_form_state.dart';

class MutateMathFieldForm extends StatelessWidget {
  const MutateMathFieldForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathFieldFormCubit, MutateMathFieldFormState>(
      builder: (_, state) {
        return Form(
          autovalidateMode: state.validateForm ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: ListView(
            children: [
              TextFormField(
                controller: context.mutateMathFieldFormCubit.nameFieldController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(hintText: 'Name'),
                onChanged: context.mutateMathFieldFormCubit.onNameChanged,
                validator: (_) => context.mutateMathFieldFormCubit.state.name.translateFailure(),
              ),
              const SizedBox(height: 20),
              LoadingTextButton(
                onPressed: context.mutateMathFieldFormCubit.onSubmit,
                isLoading: state.isSubmitting,
                label: 'Submit',
              ),
            ],
          ),
        );
      },
    );
  }
}
