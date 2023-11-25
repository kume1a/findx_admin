import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/state/data_pager_with_last_id_cubit.dart';

typedef MathFieldListState = DataState<FetchFailure, DataPage<MathFieldPageItem>>;

@injectable
final class MathFieldListCubit extends DataPagerWithLastIdCubit<FetchFailure, MathFieldPageItem> {
  MathFieldListCubit(
    this._mathFieldRemoteRepository,
  ) {
    fetchNextPage();
  }

  final MathFieldRemoteRepository _mathFieldRemoteRepository;

  @override
  String idSelector(MathFieldPageItem item) => item.id;

  @override
  Future<Either<FetchFailure, DataPage<MathFieldPageItem>>?> provideDataPage(
    String? lastId,
  ) {
    return _mathFieldRemoteRepository.filter(limit: 10, lastId: lastId);
  }
}
