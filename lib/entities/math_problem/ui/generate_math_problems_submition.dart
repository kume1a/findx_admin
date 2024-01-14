import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/widgets/loading_text_button.dart';
import '../state/generate_math_problems_form_state.dart';

class GenerateMathProblemsSubmitButton extends StatelessWidget {
  const GenerateMathProblemsSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (previous, current) => previous.stage != current.stage,
      builder: (_, state) {
        if (state.stage != GenerateMathProblemsFormStage.templating) {
          return const SizedBox.shrink();
        }

        return TextButton(
          onPressed: context.generateMathProblemsFormCubit.onSubmit,
          child: const Text('Generate'),
        );
      },
    );
  }
}
