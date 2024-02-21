import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../util/data_pager_with_last_id.dart';
import 'filtered_data_page_state.dart';

abstract base class FilteredDataPagerWithLastIdCubit<FAILURE, ITEM, FILTER>
    extends Cubit<FilteredDataPageState<FAILURE, ITEM, FILTER>> {
  FilteredDataPagerWithLastIdCubit({
    required FAILURE nullDataFailure,
  }) : super(FilteredDataPageState.initial()) {
    _dataPager = DataPagerWithLastId<FAILURE, ITEM, FILTER>(
      dataPageProvider: provideDataPage,
      idSelector: idSelector,
      nullDataFailure: nullDataFailure,
    );
  }

  late final DataPagerWithLastId<FAILURE, ITEM, FILTER> _dataPager;

  @protected
  Future<Either<FAILURE, DataPage<ITEM>>?> provideDataPage(
    String? lastId,
    FILTER? filter,
  );

  @protected
  String idSelector(ITEM item);

  @nonVirtual
  Future<void> fetchNextPage() async => _fetchNextPage();

  @mustCallSuper
  Future<void> onRefresh() async {
    _dataPager.refresh();

    return _fetchNextPage();
  }

  @override
  void emit(FilteredDataPageState<FAILURE, ITEM, FILTER> state) {
    final DataPage<ITEM> data = state.data.maybeWhen(
      success: (data) => data,
      failure: (_, data) => data ?? DataPage.empty(),
      orElse: () => DataPage.empty(),
    );

    _dataPager.setData(data);

    if (!isClosed) {
      super.emit(state);
    }
  }

  @nonVirtual
  Future<void> _fetchNextPage() async {
    await for (final DataState<FAILURE, DataPage<ITEM>> s in _dataPager.fetchNextPage(state.filter)) {
      if (!isClosed) {
        super.emit(state.copyWith(data: s));
      }
    }
  }
}
