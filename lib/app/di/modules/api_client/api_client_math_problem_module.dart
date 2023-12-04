import 'package:findx_dart_client/app_client.dart';
import 'package:graphql/client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiClientMathProblemModule {
  @lazySingleton
  MathProblemRemoteRepository mathProblemRemoteRepository(GraphQLClient client) {
    return ApiMathProblemRemoteRepository(client);
  }

  @lazySingleton
  CreateMathProblemUsecase createMathProblemUsecase(
    MathProblemRemoteRepository mathProblemRemoteRepository,
    MediaFileRemoteRepository mediaFileRemoteRepository,
  ) {
    return ApiCreateMathProblemUsecase(
      mathProblemRemoteRepository,
      mediaFileRemoteRepository,
    );
  }

  @lazySingleton
  UpdateMathProblemUsecase updateMathProblemUsecase(
    MathProblemRemoteRepository mathProblemRemoteRepository,
    MediaFileRemoteRepository mediaFileRemoteRepository,
  ) {
    return ApiUpdateMathProblemUsecase(
      mathProblemRemoteRepository,
      mediaFileRemoteRepository,
    );
  }
}
