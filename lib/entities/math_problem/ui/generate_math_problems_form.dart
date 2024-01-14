import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:collection/collection.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
import '../../../shared/ui/widgets/dopdown_field.dart';
import '../../../shared/util/equality.dart';
import '../model/math_problem_template_parameter_form.dart';
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
              _DifficultyField(),
              SizedBox(height: 12),
              _MathFieldIdField(),
              SizedBox(height: 12),
              _MathSubFieldIdField(),
              SizedBox(height: 12),
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

class _DifficultyField extends StatelessWidget {
  const _DifficultyField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(hintText: 'Difficulty'),
      onChanged: context.generateMathProblemsFormCubit.onDifficultyChanged,
      validator: (_) => context.generateMathProblemsFormCubit.state.difficulty.translateFailure(),
    );
  }
}

class _MathFieldIdField extends StatelessWidget {
  const _MathFieldIdField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (prev, curr) =>
          prev.mathFields != curr.mathFields ||
          prev.mathField != curr.mathField ||
          prev.validateForm != curr.validateForm,
      builder: (_, state) {
        return DropdownField(
          hintText: 'Math field id',
          validateForm: state.validateForm,
          data: state.mathFields,
          currentValue: state.mathField,
          itemBuilder: (e) => DropdownMenuItem(value: e, child: Text(e.name)),
          onChanged: context.generateMathProblemsFormCubit.onMathFieldChanged,
        );
      },
    );
  }
}

class _MathSubFieldIdField extends StatelessWidget {
  const _MathSubFieldIdField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
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
              state.mathField != null ? context.generateMathProblemsFormCubit.onMathSubFieldChanged : null,
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
          children: state.paramForms.mapIndexed(
            (formIndex, param) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Text(
                      '${param.index}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    _ParamFormSwitch(
                      formIndex: formIndex,
                    ),
                    const SizedBox(width: 12),
                    ..._templatePlaceholderFormWidgets(context, formIndex, param),
                  ],
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }

  List<Widget> _templatePlaceholderFormWidgets(
    BuildContext context,
    int formIndex,
    MathProblemTemplateParameterForm form,
  ) {
    return form.map(
      customStr: (_) => [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Values',
            ),
            onChanged: (value) =>
                context.generateMathProblemsFormCubit.onCustomStrParamValueChanged(formIndex, value),
            validator: (_) => context.generateMathProblemsFormCubit.state.paramForms[formIndex].when(
              number: (_, __, ___, ____) => null,
              customStr: (_, values) => values.translateFailure(),
            ),
          ),
        ),
      ],
      number: (_) => [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Min',
            ),
            onChanged: (value) =>
                context.generateMathProblemsFormCubit.onNumberParamMinChanged(formIndex, value),
            validator: (_) => context.generateMathProblemsFormCubit.state.paramForms[formIndex].when(
              number: (_, min, __, ___) => min.translateFailure(),
              customStr: (_, __) => null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Max',
            ),
            onChanged: (value) =>
                context.generateMathProblemsFormCubit.onNumberParamMaxChanged(formIndex, value),
            validator: (_) => context.generateMathProblemsFormCubit.state.paramForms[formIndex].when(
              number: (_, __, max, ___) => max.translateFailure(),
              customStr: (_, __) => null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Step',
            ),
            onChanged: (value) =>
                context.generateMathProblemsFormCubit.onNumberParamStepChanged(formIndex, value),
            validator: (_) => context.generateMathProblemsFormCubit.state.paramForms[formIndex].when(
              number: (_, __, ___, step) => step.translateFailure(),
              customStr: (_, __) => null,
            ),
          ),
        ),
      ],
    );
  }
}

class _ParamFormSwitch extends StatelessWidget {
  const _ParamFormSwitch({
    required this.formIndex,
  });

  final int formIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (previous, current) => notDeepEquals(previous.paramForms, current.paramForms),
      builder: (context, state) {
        return AnimatedToggleSwitch.size(
          current: state.paramForms[formIndex].map(
            number: (_) => MathProblemTemplateParameterFormType.number,
            customStr: (_) => MathProblemTemplateParameterFormType.customStr,
          ),
          indicatorSize: const Size.fromWidth(42),
          height: 37,
          borderWidth: 1,
          style: ToggleStyle(
            borderColor: theme.colorScheme.primary,
            indicatorColor: theme.colorScheme.primary,
          ),
          customIconBuilder: (context, local, global) {
            final text = const ['N', 'S'][local.index];

            return Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Color.lerp(Colors.white, Colors.black, local.animationValue),
                ),
              ),
            );
          },
          values: MathProblemTemplateParameterFormType.values,
          onChanged: (value) => context.generateMathProblemsFormCubit.onParamFormToggled(formIndex, value),
        );
      },
    );
  }
}
