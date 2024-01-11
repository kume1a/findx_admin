import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:collection/collection.dart';
import 'package:common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../app/i18n/failure_i18n_extensions.dart';
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
    final theme = Theme.of(context);

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
            // validator: (_) => context.generateMathProblemsFormCubit.state.numberParams[i].min,
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
            // validator: (_) => context.generateMathProblemsFormCubit.state.numberParams[i].min,
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
          ),
        ),
      ],
    );
  }
}

class _ParamFormSwitch extends HookWidget {
  const _ParamFormSwitch({
    super.key,
    required this.formIndex,
  });

  final int formIndex;

  @override
  Widget build(BuildContext context) {
    final i = useState(0);

    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (previous, current) => notDeepEquals(previous.paramForms, current.paramForms),
      builder: (context, state) {
        return AnimatedToggleSwitch<int>.rolling(
          // current: state.paramForms[formIndex].map(
          //   number: (_) => MathProblemTemplateParameterFormType.number,
          //   customStr: (_) => MathProblemTemplateParameterFormType.customStr,
          // ),
          current: i.value,
          // values: MathProblemTemplateParameterFormType.values,
          values: const [0, 1],
          onChanged: (index) {
            i.value = index;
            return;
            context.generateMathProblemsFormCubit.onParamFormToggled(
              formIndex,
              index == 0
                  ? MathProblemTemplateParameterFormType.number
                  : MathProblemTemplateParameterFormType.customStr,
            );
          },
        );
      },
    );
  }
}
