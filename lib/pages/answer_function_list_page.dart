import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/answer_function/state/answer_function_list_state.dart';
import '../entities/answer_function/ui/answer_function_table.dart';
import 'main/side_menu_page.dart';

class AnswerFunctionListPage extends StatelessWidget {
  const AnswerFunctionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AnswerFunctionListCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SideMenuPage(
      title: 'AnswerFunction',
      headerEnd: TextButton(
        onPressed: context.answerFunctionListCubit.onNewAnswerFunctionPressed,
        child: const Text('Create new'),
      ),
      child: const AnswerFunctionTable(),
    );
  }
}
