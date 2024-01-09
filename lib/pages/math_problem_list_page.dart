import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../app/di/register_dependencies.dart';
import '../entities/math_problem/state/math_problem_list_state.dart';
import '../entities/math_problem/ui/math_problem_table.dart';
import '../shared/ui/color.dart';
import '../shared/values/assets.dart';
import 'main/side_menu_page.dart';

class MathProblemListPage extends StatelessWidget {
  const MathProblemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MathProblemListCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SideMenuPage(
      title: 'MathProblem',
      headerEnd: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: context.mathProblemListCubit.onGenerateMathProblemsPressed,
            icon: SvgPicture.asset(
              Assets.iconFactory,
              colorFilter: svgColor(Colors.white),
              width: 18,
              height: 18,
            ),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.primaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: context.mathProblemListCubit.onNewMathProblemPressed,
            child: const Text('Create new'),
          ),
        ],
      ),
      child: const MathProblemTable(),
    );
  }
}
