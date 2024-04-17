import 'package:common_models/common_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../util/data_pager_with_last_id.dart';
import 'filtered_data_page_state.dart';

abstract base class FilteredDataPagerWithLastIdCubit<ERROR, ITEM, FILTER>
    extends Cubit<FilteredDataPageState<ERROR, ITEM, FILTER>> {
  FilteredDataPagerWithLastIdCubit({
    required ERROR nullDataErr,
  }) : super(FilteredDataPageState.initial()) {
    _dataPager = DataPagerWithLastId<ERROR, ITEM, FILTER>(
      dataPageProvider: provideDataPage,
      idSelector: idSelector,
      nullDataErr: nullDataErr,
    );
  }

  late final DataPagerWithLastId<ERROR, ITEM, FILTER> _dataPager;

  @protected
  Future<Either<ERROR, DataPage<ITEM>>?> provideDataPage(
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
  void emit(FilteredDataPageState<ERROR, ITEM, FILTER> state) {
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
    await for (final DataState<ERROR, DataPage<ITEM>> s in _dataPager.fetchNextPage(state.filter)) {
      if (!isClosed) {
        super.emit(state.copyWith(data: s));
      }
    }
  }
}
