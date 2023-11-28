import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/state/data_pager_with_last_id_cubit.dart';

typedef MathSubFieldListState = DataState<FetchFailure, DataPage<MathSubFieldPageItem>>;

extension MathSubFieldListCubitX on BuildContext {
  MathSubFieldListCubit get mathSubFieldListCubit => read<MathSubFieldListCubit>();
}

@injectable
final class MathSubFieldListCubit extends DataPagerWithLastIdCubit<FetchFailure, MathSubFieldPageItem> {
  MathSubFieldListCubit(
    this._mathSubFieldRemoteRepository,
  ) {
    fetchNextPage();
  }

  final MathSubFieldRemoteRepository _mathSubFieldRemoteRepository;

  @override
  String idSelector(MathSubFieldPageItem item) => item.id;

  @override
  Future<Either<FetchFailure, DataPage<MathSubFieldPageItem>>?> provideDataPage(
    String? lastId,
  ) {
    return _mathSubFieldRemoteRepository.filter(limit: 10, lastId: lastId);
  }
}
