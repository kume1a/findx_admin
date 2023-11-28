import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/ui/widgets/entity_table.dart';
import '../../../shared/values/shared_date_format.dart';
import '../state/math_sub_field_list_state.dart';

class MathSubFieldTable extends StatelessWidget {
  const MathSubFieldTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MathSubFieldListCubit, MathSubFieldListState>(
      builder: (_, state) {
        return EntityTable(
          state,
          onLoadMorePressed: context.mathSubFieldListCubit.fetchNextPage,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('MathFieldId')),
            DataColumn(label: Text('CreatedAt')),
          ],
          cellsBuilder: (e) => [
            DataCell(Text(e.id)),
            DataCell(Text(e.name)),
            DataCell(Text(e.mathFieldId)),
            DataCell(Text(createdAtDateFormat.format(e.createdAt))),
          ],
        );
      },
    );
  }
}
