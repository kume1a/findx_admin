import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/math_sub_field/state/mutate_math_sub_field_form_state.dart';
import '../entities/math_sub_field/ui/mutate_math_sub_field_form.dart';
import '../shared/ui/widgets/responsive_form.dart';
import 'main/side_menu_page.dart';

class MutateMathSubFieldPage extends StatelessWidget {
  const MutateMathSubFieldPage({
    super.key,
    required this.mathSubFieldId,
  });

  final String? mathSubFieldId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutateMathSubFieldFormCubit>()..init(mathSubFieldId),
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
      title: 'Mutate math sub field',
      child: ResponsiveForm(
        child: MutateMathSubFieldForm(),
      ),
    );
  }
}
