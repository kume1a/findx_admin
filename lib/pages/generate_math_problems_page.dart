import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/math_problem/state/generate_math_problems_form_state.dart';
import '../entities/math_problem/ui/generate_math_problems_form.dart';
import '../entities/math_problem/ui/generate_math_problems_submition.dart';
import '../entities/math_problem/ui/generated_math_problem_values.dart';
import '../shared/ui/widgets/responsive_form.dart';
import 'main/side_menu_page.dart';

class GenerateMathProblemsPage extends StatelessWidget {
  const GenerateMathProblemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GenerateMathProblemsFormCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SideMenuPage(
      showBackButton: true,
      title: 'Generate math problems',
      headerEnd: const GenerateMathProblemsSubmitButton(),
      child: BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
        buildWhen: (previous, current) =>
            previous.stage != current.stage || previous.isSubmitting != current.isSubmitting,
        builder: (context, state) {
          if (state.isSubmitting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return switch (state.stage) {
            GenerateMathProblemsFormStage.templating => const ResponsiveForm(
                child: GenerateMathProblemsForm(),
              ),
            GenerateMathProblemsFormStage.submitting => Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total count: ${state.generatedTotalCount}'),
                    ElevatedButton(
                      onPressed: context.generateMathProblemsFormCubit.cancelGenerateMathProblems,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: context.generateMathProblemsFormCubit.onConfirmGenerate,
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            GenerateMathProblemsFormStage.generated => const GeneratedMathProblemValues(),
          };
        },
      ),
    );
  }
}
