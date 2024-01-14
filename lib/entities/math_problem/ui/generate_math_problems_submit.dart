import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/generate_math_problems_form_state.dart';

class GenerateMathProblemsSubmit extends StatelessWidget {
  const GenerateMathProblemsSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (previous, current) => previous.stage != current.stage,
      builder: (_, state) {
        if (state.stage == GenerateMathProblemsFormStage.templating) {
          return TextButton(
            onPressed: context.generateMathProblemsFormCubit.onSubmit,
            child: const Text('Generate'),
          );
        }

        if (state.stage == GenerateMathProblemsFormStage.generated) {
          return TextButton(
            onPressed: context.generateMathProblemsFormCubit.onSubmitGeneratedValues,
            child: const Text('Submit'),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
