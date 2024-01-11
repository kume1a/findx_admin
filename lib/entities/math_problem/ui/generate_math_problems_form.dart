import 'package:collection/collection.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/util/equality.dart';
import '../state/generate_math_problems_form_state.dart';

class GenerateMathProblemsForm extends StatelessWidget {
  const GenerateMathProblemsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (previous, current) => previous.validateForm != current.validateForm,
      builder: (_, state) {
        return ValidatedForm(
          showErrors: state.validateForm,
          child: ListView(
            children: const [
              _TemplateField(),
              SizedBox(height: 24),
              _TemplateParamFields(),
            ],
          ),
        );
      },
    );
  }
}

class _TemplateField extends StatelessWidget {
  const _TemplateField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: 6,
      decoration: const InputDecoration(hintText: 'Template'),
      onChanged: context.generateMathProblemsFormCubit.onTemplateChanged,
      validator: (_) => context.generateMathProblemsFormCubit.state.template.translateFailure(),
    );
  }
}

class _TemplateParamFields extends StatelessWidget {
  const _TemplateParamFields();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (previous, current) => notDeepEquals(previous.paramForms, current.paramForms),
      builder: (_, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: state.paramForms
              .mapIndexed(
                (index, param) => Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          hintText: 'Min',
                        ),
                        onChanged: (value) =>
                            context.generateMathProblemsFormCubit.onNumberParamMinChanged(index, value),
                        // validator: (_) => context.generateMathProblemsFormCubit.state.numberParams[i].min,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          hintText: 'Max',
                        ),
                        onChanged: (value) =>
                            context.generateMathProblemsFormCubit.onNumberParamMaxChanged(index, value),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          hintText: 'Step',
                        ),
                        onChanged: (value) =>
                            context.generateMathProblemsFormCubit.onNumberParamStepChanged(index, value),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        );
      },
    );
  }
}
