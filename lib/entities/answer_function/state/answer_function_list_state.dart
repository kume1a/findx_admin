import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../../app/navigation/app_route_builder.dart';
import '../../../shared/state/filtered_data_page_state.dart';
import '../../../shared/state/filtered_data_pager_with_last_id_cubit.dart';
import '../../../shared/util/toast/notify_network_call_error.dart';
import '../model/answer_function_list_filter.dart';

typedef AnswerFunctionListState
    = FilteredDataPageState<NetworkCallError, AnswerFunctionPageItem, AnswerFunctionListFilter>;

extension AnswerFunctionListCubitX on BuildContext {
  AnswerFunctionListCubit get answerFunctionListCubit => read<AnswerFunctionListCubit>();
}

@injectable
final class AnswerFunctionListCubit extends FilteredDataPagerWithLastIdCubit<NetworkCallError,
    AnswerFunctionPageItem, AnswerFunctionListFilter> {
  AnswerFunctionListCubit(
    this._answerFunctionRemoteRepository,
    this._goRouter,
    this._mathSubFieldRemoteRepository,
  ) : super(nullDataErr: NetworkCallError.unknown) {
    fetchNextPage();

    _fetchMathSubFields();
  }

  final AnswerFunctionRemoteRepository _answerFunctionRemoteRepository;
  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;
  final GoRouter _goRouter;

  @override
  String idSelector(AnswerFunctionPageItem item) => item.id;

  @override
  Future<Either<NetworkCallError, DataPage<AnswerFunctionPageItem>>?> provideDataPage(
    String? lastId,
    AnswerFunctionListFilter? filter,
  ) {
    return _answerFunctionRemoteRepository.filter(
      limit: 20,
      lastId: lastId,
      mathSubFieldId: filter?.mathSubField?.id,
    );
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
      notifyNetworkCallError,
      (_) => onRefresh(),
    );
  }

  void onMathSubFieldChanged(MathSubFieldPageItem? mathSubField) {
    final filter = state.filter ?? AnswerFunctionListFilter.initial();

    emit(state.copyWith(filter: filter.copyWith(mathSubField: mathSubField)));

    onRefresh();
  }

  void onClearFilter() {
    emit(state.copyWith(filter: AnswerFunctionListFilter.initial()));

    onRefresh();
  }

  Future<void> _fetchMathSubFields() async {
    final filter = state.filter ?? AnswerFunctionListFilter.initial();

    emit(state.copyWith(
      filter: filter.copyWith(mathSubFields: SimpleDataState.loading()),
    ));

    final res = await _mathSubFieldRemoteRepository.filter(
      limit: 200,
    );

    emit(state.copyWith(
      filter: filter.copyWith(mathSubFields: SimpleDataState.fromEither(res)),
    ));
  }
}
