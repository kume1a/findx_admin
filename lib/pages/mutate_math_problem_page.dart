import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/math_problem/state/mutate_math_problem_form_state.dart';
import '../entities/math_problem/ui/mutate_math_problem_form.dart';
import '../shared/ui/widgets/responsive_form.dart';
import 'main/side_menu_page.dart';

class MutateMathProblemPage extends StatelessWidget {
  const MutateMathProblemPage({
    super.key,
    required this.mathProblemId,
  });

  final String? mathProblemId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutateMathProblemFormCubit>()..init(mathProblemId),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    return const SideMenuPage(
      showBackButton: true,
      title: 'Mutate math problem',
      child: ResponsiveForm(
        child: MutateMathProblemForm(),
      ),
    );
  }
}
