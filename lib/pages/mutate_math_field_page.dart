import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/di/register_dependencies.dart';
import '../entities/math_field/state/mutate_math_field_form_state.dart';
import '../entities/math_field/ui/mutate_math_field_form.dart';
import '../shared/ui/widgets/responsive_form.dart';
import 'main/side_menu_page.dart';

class MutateMathFieldPage extends StatelessWidget {
  const MutateMathFieldPage({
    super.key,
    required this.mathFieldId,
  });

  final String? mathFieldId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MutateMathFieldFormCubit>()..init(mathFieldId),
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
      title: 'Mutate math field',
      child: ResponsiveForm(
        child: MutateMathFieldForm(),
      ),
    );
  }
}
