import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/app_route_builder.dart';
import '../../../shared/state/data_pager_with_last_id_cubit.dart';
import '../../../shared/util/toast/notify_simple_action_failure.dart';

typedef AnswerFunctionListState = DataState<FetchFailure, DataPage<AnswerFunctionPageItem>>;

extension AnswerFunctionListCubitX on BuildContext {
  AnswerFunctionListCubit get answerFunctionListCubit => read<AnswerFunctionListCubit>();
}

@injectable
final class AnswerFunctionListCubit extends DataPagerWithLastIdCubit<FetchFailure, AnswerFunctionPageItem> {
  AnswerFunctionListCubit(
    this._answerFunctionRemoteRepository,
    this._goRouter,
  ) : super(nullDataFailure: FetchFailure.unknown) {
    fetchNextPage();
  }

  final AnswerFunctionRemoteRepository _answerFunctionRemoteRepository;
  final GoRouter _goRouter;

  @override
  String idSelector(AnswerFunctionPageItem item) => item.id;

  @override
  Future<Either<FetchFailure, DataPage<AnswerFunctionPageItem>>?> provideDataPage(
    String? lastId,
  ) {
    return _answerFunctionRemoteRepository.filter(limit: 20, lastId: lastId);
  }

  Future<void> onNewAnswerFunctionPressed() async {
    await _goRouter.push(AppRouteBuilder.mutateAnswerFunction());

    onRefresh();
  }

  Future<void> onUpdatePressed(AnswerFunctionPageItem entity) async {
    await _goRouter.push(AppRouteBuilder.mutateAnswerFunction(entity.id));

    onRefresh();
  }

  Future<void> onDeletePressed(AnswerFunctionPageItem entity) async {
    final res = await _answerFunctionRemoteRepository.delete(id: entity.id);

    res.fold(
      notifyActionFailure,
      (_) => onRefresh(),
    );
  }
}
