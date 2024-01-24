import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/answer_function/state/mutate_answer_function_form_state.dart';
import '../entities/answer_function/ui/mutate_answer_function_form.dart';
import '../shared/ui/widgets/responsive_form.dart';
import 'main/side_menu_page.dart';

class MutateAnswerFunctionPage extends StatelessWidget {
  const MutateAnswerFunctionPage({
    super.key,
    required this.answerFunctionId,
  });

  final String? answerFunctionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutateAnswerFunctionFormCubit>()..init(answerFunctionId),
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
      title: 'Mutate answer function',
      child: ResponsiveForm(
        child: MutateAnswerFunctionForm(),
      ),
    );
  }
}
