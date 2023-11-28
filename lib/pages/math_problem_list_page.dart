import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../app/di/register_dependencies.dart';
import '../app/navigation/app_route_builder.dart';
import '../entities/math_problem/state/math_problem_list_state.dart';
import '../entities/math_problem/ui/math_problem_table.dart';
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
    return SideMenuPage(
      title: 'MathProblem',
      headerEnd: TextButton(
        onPressed: () => context.go(AppRouteBuilder.mutateMathProblem()),
        child: const Text('Create new'),
      ),
      child: const MathProblemTable(),
    );
  }
}
