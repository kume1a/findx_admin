import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/dopdown_field.dart';
import '../../../shared/ui/widgets/editable_image_dropzone.dart';
import '../../../shared/ui/widgets/loading_text_button.dart';
import '../state/mutate_math_problem_form_state.dart';

class MutateMathProblemForm extends StatelessWidget {
  const MutateMathProblemForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathProblemFormCubit, MutateMathProblemFormState>(
      builder: (_, state) {
        return Form(
          autovalidateMode: state.validateForm ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: ListView(
            children: [
              EditableImageDropzone(
                onChangePickedImages: context.mutateMathProblemFormCubit.onPickImages,
              ),
              const SizedBox(height: 20),
              const _DifficultyField(),
              const SizedBox(height: 20),
              const _TextField(),
              const SizedBox(height: 20),
              const _TexField(),
              const SizedBox(height: 20),
              const _MathFieldIdField(),
              const SizedBox(height: 20),
              const _MathSubFieldIdField(),
              const SizedBox(height: 20),
              LoadingTextButton(
                onPressed: context.mutateMathProblemFormCubit.onSubmit,
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

class _DifficultyField extends StatelessWidget {
  const _DifficultyField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.mutateMathProblemFormCubit.difficultyFieldController,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(hintText: 'Difficulty'),
      onChanged: context.mutateMathProblemFormCubit.onDifficultyChanged,
      validator: (_) => context.mutateMathProblemFormCubit.state.difficulty.failureToString(
        (f) => f.translate(),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.mutateMathProblemFormCubit.textFieldController,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Text',
        contentPadding: EdgeInsets.all(18),
      ),
      onChanged: context.mutateMathProblemFormCubit.onTextChanged,
      minLines: 4,
      maxLines: 10,
    );
  }
}

class _TexField extends StatelessWidget {
  const _TexField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: context.mutateMathProblemFormCubit.texFieldController,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Tex',
        contentPadding: EdgeInsets.all(18),
      ),
      onChanged: context.mutateMathProblemFormCubit.onTexChanged,
      minLines: 4,
      maxLines: 10,
    );
  }
}

class _MathFieldIdField extends StatelessWidget {
  const _MathFieldIdField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathProblemFormCubit, MutateMathProblemFormState>(
      buildWhen: (prev, curr) =>
          prev.mathFields != curr.mathFields ||
          prev.mathFieldId != curr.mathFieldId ||
          prev.validateForm != curr.validateForm,
      builder: (_, state) {
        return DropdownField(
          hintText: 'Math field id',
          validateForm: state.validateForm,
          data: state.mathFields,
          currentValue: state.mathFieldId,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged: context.mutateMathProblemFormCubit.onMathFieldChanged,
        );
      },
    );
  }
}

class _MathSubFieldIdField extends StatelessWidget {
  const _MathSubFieldIdField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathProblemFormCubit, MutateMathProblemFormState>(
      buildWhen: (prev, curr) =>
          prev.mathSubFields != curr.mathSubFields ||
          prev.mathSubFieldId != curr.mathSubFieldId ||
          prev.validateForm != curr.validateForm ||
          prev.mathFieldId != curr.mathFieldId,
      builder: (_, state) {
        return DropdownField(
          hintText: 'Math sub field id',
          validateForm: state.validateForm,
          data: state.mathSubFields,
          currentValue: state.mathSubFieldId,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged:
              state.mathFieldId != null ? context.mutateMathProblemFormCubit.onMathSubFieldChanged : null,
        );
      },
    );
  }
}
