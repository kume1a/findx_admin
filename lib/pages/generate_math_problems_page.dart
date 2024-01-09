import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/math_problem/state/generate_math_problems_form_state.dart';
import '../entities/math_problem/ui/generate_math_problems_form.dart';
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
    return const SideMenuPage(
      showBackButton: true,
      title: 'Generate math problems',
      child: ResponsiveForm(
        child: GenerateMathProblemsForm(),
      ),
    );
  }
}
