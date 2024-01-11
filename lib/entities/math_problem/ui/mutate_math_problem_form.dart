import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/dopdown_field.dart';
import '../../../shared/ui/widgets/editable_image_dropzone.dart';
import '../../../shared/ui/widgets/expandable_image.dart';
import '../../../shared/ui/widgets/loading_text_button.dart';
import '../../../shared/ui/widgets/scrollable_tex.dart';
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
              const _MathFieldIdField(),
              const SizedBox(height: 20),
              const _MathSubFieldIdField(),
              const SizedBox(height: 20),
              const _TextField(),
              const SizedBox(height: 20),
              const _TexField(),
              const _TexValue(),
              const SizedBox(height: 20),
              const _AnswerFields(),
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
                        child: ExpandableImage(
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
      validator: (_) => context.mutateMathProblemFormCubit.state.difficulty.translateFailure(),
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

        return ScrollableTex(
          state.tex,
          style: const TextStyle(fontSize: 20),
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

class _AnswerFields extends StatelessWidget {
  const _AnswerFields();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MutateMathProblemFormCubit, MutateMathProblemFormState>(
      buildWhen: (previous, current) => notDeepEquals(previous.answers, current.answers),
      builder: (_, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: state.answers
              .mapIndexed(
                (index, answer) => _AnswerField(
                  index: index,
                  isCorrectAnswerField: index == 0,
                  stateContent: answer,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _AnswerField extends HookWidget {
  const _AnswerField({
    required this.index,
    required this.isCorrectAnswerField,
    required this.stateContent,
  });

  final int index;
  final bool isCorrectAnswerField;
  final RequiredString stateContent;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();

    useEffect(
      () {
        final currentStr = textController.text;
        final stateStr = stateContent.get ?? '';

        if (currentStr != stateStr) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            textController.text = stateStr;
          });
        }
        return null;
      },
      [textController, stateContent],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Answer ${index + 1}${isCorrectAnswerField ? ' (Correct)' : ''}',
              ),
              onChanged: (value) => context.mutateMathProblemFormCubit.onAnswerChanged(index, value),
              validator: (_) => context.mutateMathProblemFormCubit.state.answers[index].translateFailure(),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ScrollableTex(
              textController.text,
            ),
          ),
        ],
      ),
    );
  }
}
