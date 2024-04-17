import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/app_route_builder.dart';
import '../../../shared/state/filtered_data_page_state.dart';
import '../../../shared/state/filtered_data_pager_with_last_id_cubit.dart';
import '../util/notify_delete_math_field_err.dart';

typedef MathFieldListState = FilteredDataPageState<NetworkCallError, MathFieldPageItem, Unit>;

extension MathFieldListCubitX on BuildContext {
  MathFieldListCubit get mathFieldListCubit => read<MathFieldListCubit>();
}

@injectable
final class MathFieldListCubit
    extends FilteredDataPagerWithLastIdCubit<NetworkCallError, MathFieldPageItem, Unit> {
  MathFieldListCubit(
    this._mathFieldRemoteRepository,
    this._goRouter,
  ) : super(nullDataErr: NetworkCallError.unknown) {
    fetchNextPage();
  }

  final MathFieldRemoteRepository _mathFieldRemoteRepository;
  final GoRouter _goRouter;

  @override
  String idSelector(MathFieldPageItem item) => item.id;

  @override
  Future<Either<NetworkCallError, DataPage<MathFieldPageItem>>?> provideDataPage(
    String? lastId,
    Unit? filter,
  ) {
    return _mathFieldRemoteRepository.filter(limit: 10, lastId: lastId);
  }

  Future<void> onNewMathFieldPressed() async {
    await _goRouter.push(AppRouteBuilder.mutateMathField());

    onRefresh();
  }

  Future<void> onUpdatePressed(MathFieldPageItem entity) async {
    await _goRouter.push(AppRouteBuilder.mutateMathField(entity.id));

    onRefresh();
  }

  Future<void> onDeletePressed(MathFieldPageItem entity) async {
    final res = await _mathFieldRemoteRepository.delete(id: entity.id);

    res.fold(
      notifyDeleteMathFieldErr,
      (_) => onRefresh(),
    );
  }
}
