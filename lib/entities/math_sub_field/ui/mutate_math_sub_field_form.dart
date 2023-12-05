import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/dopdown_field.dart';
import '../../../shared/ui/widgets/loading_text_button.dart';
import '../state/mutate_math_sub_field_form_state.dart';

class MutateMathSubFieldForm extends StatelessWidget {
  const MutateMathSubFieldForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathSubFieldFormCubit, MutateMathSubFieldFormState>(
      builder: (_, state) {
        return Form(
          autovalidateMode: state.validateForm ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              const _NameField(),
              const SizedBox(height: 20),
              const _MathFieldIdField(),
              const SizedBox(height: 20),
              LoadingTextButton(
                onPressed: context.mutateMathSubFieldFormCubit.onSubmit,
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

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.mutateMathSubFieldFormCubit.nameFieldController,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(hintText: 'Name'),
      onChanged: context.mutateMathSubFieldFormCubit.onNameChanged,
      validator: (_) => context.mutateMathSubFieldFormCubit.state.name.failureToString(
        (f) => f.translate(),
      ),
    );
  }
}

class _MathFieldIdField extends StatelessWidget {
  const _MathFieldIdField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathSubFieldFormCubit, MutateMathSubFieldFormState>(
      buildWhen: (prev, curr) =>
          prev.mathFields != curr.mathFields ||
          prev.mathField != curr.mathField ||
          prev.validateForm != curr.validateForm,
      builder: (_, state) {
        return DropdownField<MathFieldPageItem>(
          hintText: 'Math field id',
          validateForm: state.validateForm,
          data: state.mathFields,
          currentValue: state.mathField,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged: context.mutateMathSubFieldFormCubit.onMathFieldChanged,
        );
      },
    );
  }
}
