import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/generate_math_problems_form_state.dart';

class GeneratedMathProblemValues extends StatelessWidget {
  const GeneratedMathProblemValues({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenerateMathProblemsFormCubit, GenerateMathProblemsFormState>(
      buildWhen: (previous, current) =>
          previous.generatedMathProblemValues != current.generatedMathProblemValues,
      builder: (context, state) {
        return state.generatedMathProblemValues.maybeWhen(
          orElse: () => IconButton(
            onPressed: context.generateMathProblemsFormCubit.cancelGenerateMathProblems,
            icon: const Icon(Icons.refresh),
          ),
          success: (data) => ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) => _Item(values: data[index]),
          ),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.values,
  });

  final GenerateMathProblemValuesRes values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
          'tex: ${values.tex}, answers = ${values.answers?.map((e) => '{tex: ${e.tex}, correct ? ${e.isCorrect}}').join(', ') ?? '-'}'),
    );
  }
}
