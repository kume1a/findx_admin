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
      builder: (_, state) {
        return state.generatedMathProblemValues.maybeWhen(
          orElse: () => const Center(
            child: Text('Error, refresh the page bro'),
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
    required this.values,
  });

  final GenerateMathProblemValuesRes values;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(values.tex),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              values.answers?.map((e) => '${e.isCorrect ? 'correct   ' : 'incorrect'} ${e.tex}').join('\n') ??
                  '-',
            ),
          )
        ],
      ),
    );
  }
}
