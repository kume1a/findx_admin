import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/app_route_builder.dart';
import '../../../shared/state/data_pager_with_last_id_cubit.dart';
import '../../../shared/util/toast/notify_simple_action_failure.dart';

typedef MathProblemListState = DataState<FetchFailure, DataPage<MathProblemPageItem>>;

extension MathProblemListCubitX on BuildContext {
  MathProblemListCubit get mathProblemListCubit => read<MathProblemListCubit>();
}

@injectable
final class MathProblemListCubit extends DataPagerWithLastIdCubit<FetchFailure, MathProblemPageItem> {
  MathProblemListCubit(
    this._mathProblemRemoteRepository,
    this._goRouter,
  ) {
    fetchNextPage();
  }

  final MathProblemRemoteRepository _mathProblemRemoteRepository;
  final GoRouter _goRouter;

  @override
  String idSelector(MathProblemPageItem item) => item.id;

  @override
  Future<Either<FetchFailure, DataPage<MathProblemPageItem>>?> provideDataPage(
    String? lastId,
  ) {
    return _mathProblemRemoteRepository.filter(limit: 10, lastId: lastId);
  }

  Future<void> onNewMathProblemPressed() async {
    await _goRouter.push(AppRouteBuilder.mutateMathProblem());

    onRefresh();
  }

  Future<void> onUpdatePressed(MathProblemPageItem entity) async {
    await _goRouter.push(AppRouteBuilder.mutateMathProblem(entity.id));

    onRefresh();
  }

  Future<void> onDeletePressed(MathProblemPageItem entity) async {
    final res = await _mathProblemRemoteRepository.delete(id: entity.id);

    res.fold(
      notifySimpleActionFailure,
      (_) => onRefresh(),
    );
  }
}
