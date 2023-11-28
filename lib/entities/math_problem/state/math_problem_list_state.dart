import 'package:common_models/common_models.dart';
import 'package:findx_dart_client/app_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../shared/state/data_pager_with_last_id_cubit.dart';

typedef MathProblemListState = DataState<FetchFailure, DataPage<MathProblemPageItem>>;

extension MathProblemListCubitX on BuildContext {
  MathProblemListCubit get mathProblemListCubit => read<MathProblemListCubit>();
}

@injectable
final class MathProblemListCubit extends DataPagerWithLastIdCubit<FetchFailure, MathProblemPageItem> {
  MathProblemListCubit(
    this._mathProblemRemoteRepository,
  ) {
    fetchNextPage();
  }

  final MathProblemRemoteRepository _mathProblemRemoteRepository;

  @override
  String idSelector(MathProblemPageItem item) => item.id;

  @override
  Future<Either<FetchFailure, DataPage<MathProblemPageItem>>?> provideDataPage(
    String? lastId,
  ) {
    return _mathProblemRemoteRepository.filter(limit: 10, lastId: lastId);
  }
}
