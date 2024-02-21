import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../shared/ui/widgets/entity_table.dart';
import '../state/math_field_list_state.dart';

class MathFieldTable extends StatelessWidget {
  const MathFieldTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MathFieldListCubit, MathFieldListState>(
      builder: (_, state) {
        return EntityTable(
          state.data,
          onLoadMorePressed: context.mathFieldListCubit.fetchNextPage,
          onUpdate: context.mathFieldListCubit.onUpdatePressed,
          onDelete: context.mathFieldListCubit.onDeletePressed,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('CreatedAt')),
          ],
          cellsBuilder: (e) => [
            DataCell(Text(e.id)),
            DataCell(Text(e.name)),
            DataCell(Text(DateFormat('MMM dd, yyyy HH:mm:ss').format(e.createdAt))),
          ],
        );
      },
    );
  }
}
