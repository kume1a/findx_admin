import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../app/di/register_dependencies.dart';
import '../app/navigation/app_route_builder.dart';
import '../entities/math_field/state/math_field_list_state.dart';
import '../entities/math_field/ui/math_field_table.dart';
import 'main/side_menu_page.dart';

class MathFieldListPage extends StatelessWidget {
  const MathFieldListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MathFieldListCubit>(),
      child: const _Content(),
    );
  }
}

class _Content extends HookWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();

    return SideMenuPage(
      title: 'MathField',
      headerEnd: TextButton(
        onPressed: () async {
          await context.push(AppRouteBuilder.mutateMathField());

          if (isMounted()) {
            // ignore: use_build_context_synchronously
            context.mathFieldListCubit.onRefresh();
          }
        },
        child: const Text('Create new'),
      ),
      child: const MathFieldTable(),
    );
  }
}
