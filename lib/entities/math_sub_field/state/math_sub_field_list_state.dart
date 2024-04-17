import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/app_route_builder.dart';
import '../../../shared/state/filtered_data_page_state.dart';
import '../../../shared/state/filtered_data_pager_with_last_id_cubit.dart';
import '../util/notify_delete_math_sub_field_err.dart';

typedef MathSubFieldListState = FilteredDataPageState<NetworkCallError, MathSubFieldPageItem, Unit>;

extension MathSubFieldListCubitX on BuildContext {
  MathSubFieldListCubit get mathSubFieldListCubit => read<MathSubFieldListCubit>();
}

@injectable
final class MathSubFieldListCubit
    extends FilteredDataPagerWithLastIdCubit<NetworkCallError, MathSubFieldPageItem, Unit> {
  MathSubFieldListCubit(
    this._mathSubFieldRemoteRepository,
    this._goRouter,
  ) : super(nullDataErr: NetworkCallError.unknown) {
    fetchNextPage();
  }

  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;
  final GoRouter _goRouter;

  @override
  String idSelector(MathSubFieldPageItem item) => item.id;

  @override
  Future<Either<NetworkCallError, DataPage<MathSubFieldPageItem>>?> provideDataPage(
    String? lastId,
    Unit? filter,
  ) {
    return _mathSubFieldRemoteRepository.filter(limit: 10, lastId: lastId);
  }

  Future<void> onNewMathSubFieldPressed() async {
    await _goRouter.push(AppRouteBuilder.mutateMathSubField());

    onRefresh();
  }

  Future<void> onUpdatePressed(MathSubFieldPageItem entity) async {
    await _goRouter.push(AppRouteBuilder.mutateMathSubField(entity.id));

    onRefresh();
  }

  Future<void> onDeletePressed(MathSubFieldPageItem entity) async {
    final res = await _mathSubFieldRemoteRepository.delete(id: entity.id);

    res.fold(
      notifyDeleteMathSubFieldErr,
      (_) => onRefresh(),
    );
  }
}
