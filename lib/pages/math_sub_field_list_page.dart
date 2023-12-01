import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/math_sub_field/state/math_sub_field_list_state.dart';
import '../entities/math_sub_field/ui/math_sub_field_table.dart';
import 'main/side_menu_page.dart';

class MathSubFieldListPage extends StatelessWidget {
  const MathSubFieldListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MathSubFieldListCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return SideMenuPage(
      title: 'MathSubField',
      headerEnd: TextButton(
        onPressed: context.mathSubFieldListCubit.onNewMathSubFieldPressed,
        child: const Text('Create new'),
      ),
      child: const MathSubFieldTable(),
    );
  }
}
