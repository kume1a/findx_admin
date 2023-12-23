import 'package:common_widgets/common_widgets.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tex/flutter_tex.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/dopdown_field.dart';
import '../../../shared/ui/widgets/editable_image_dropzone.dart';
import '../../../shared/ui/widgets/loading_text_button.dart';
import '../../../shared/util/assemble_media_url.dart';
import '../../../shared/util/equality.dart';
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
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              const _CurrentMathProblemImages(),
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
              const _TexValue(),
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

class _CurrentMathProblemImages extends StatelessWidget {
  const _CurrentMathProblemImages();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathProblemFormCubit, MutateMathProblemFormState>(
      buildWhen: (previous, current) => notDeepEquals(previous.currentImages, current.currentImages),
      builder: (_, state) {
        if (state.currentImages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 200,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current images:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.currentImages.length,
                  itemBuilder: (context, index) {
                    final image = state.currentImages[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: SafeImage(
                          borderRadius: BorderRadius.circular(8),
                          url: assembleResourceUrl(image.path),
                        ),
                      ),
                    );
                  },
                ),
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

class _TexValue extends StatelessWidget {
  const _TexValue();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathProblemFormCubit, MutateMathProblemFormState>(
      buildWhen: (prev, curr) => prev.tex != curr.tex,
      builder: (_, state) {
        if (state.tex.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: TeXView(
            style: const TeXViewStyle(
              contentColor: Colors.white,
              textAlign: TeXViewTextAlign.left,
            ),
            child: TeXViewDocument(state.tex),
          ),
        );
      },
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
          prev.mathField != curr.mathField ||
          prev.validateForm != curr.validateForm,
      builder: (_, state) {
        return DropdownField<MathFieldPageItem>(
          hintText: 'Math field id',
          validateForm: state.validateForm,
          data: state.mathFields,
          currentValue: state.mathField,
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
          prev.mathSubField != curr.mathSubField ||
          prev.validateForm != curr.validateForm ||
          prev.mathField != curr.mathField,
      builder: (_, state) {
        return DropdownField(
          hintText: 'Math sub field id',
          validateForm: state.validateForm,
          data: state.mathSubFields,
          currentValue: state.mathSubField,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged:
              state.mathField != null ? context.mutateMathProblemFormCubit.onMathSubFieldChanged : null,
        );
      },
    );
  }
}
